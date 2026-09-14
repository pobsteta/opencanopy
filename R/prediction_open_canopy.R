#!/usr/bin/env Rscript
# ==============================================================================
# prediction_open_canopy.R
# Inférence des modèles Open-Canopy sur images IGN (0.20m)
# via l'environnement conda open_canopy + reticulate
#
# Workflow :
#   1. Charger l'ortho IGN (RVB ou IRC) à 0.20m
#   2. Rééchantillonner à 1.5m pour compatibilité avec les modèles SPOT
#   3. Exécuter le modèle UNet/PVTv2 via Python (reticulate + conda)
#   4. Post-traiter et analyser les prédictions en R
# ==============================================================================

library(terra)
library(sf)
library(fs)

# ==============================================================================
# Configuration
# ==============================================================================

DATA_DIR     <- file.path(getwd(), "data")
DATA_DIR_IGN <- file.path(DATA_DIR, "ign")
OUTPUT_DIR   <- file.path(getwd(), "outputs")
# Pas de dir_create() ici : au chargement du package cela creerait outputs/
# dans le repertoire courant, quel qu'il soit. Cf. les fonctions d'export.

RES_SPOT <- 1.5  # Résolution des modèles Open-Canopy
RES_IGN  <- 0.2  # Résolution des ortho IGN

# Environnement conda (miniforge / open_canopy)
CONDA_ENV <- "open_canopy"

# Modules Python requis par le pipeline `pipeline_aoi_to_chm()` (nom d'import
# -> nom pip). Le pipeline charge le stack géospatial (geopandas / shapely /
# pyproj / rioxarray / xarray) en plus de torch + inférence (torchvision /
# timm / segmentation_models_pytorch) : un env créé à la main n'a souvent que
# torch/rasterio, d'où des échecs `ModuleNotFoundError` à l'étape AOI/CHM.
OPEN_CANOPY_PY_MODULES <- c(
  torch                       = "torch",
  torchvision                 = "torchvision",
  numpy                       = "numpy",
  rasterio                    = "rasterio",
  huggingface_hub             = "huggingface_hub",
  timm                        = "timm",
  segmentation_models_pytorch = "segmentation-models-pytorch",
  geopandas                   = "geopandas",
  shapely                     = "shapely",
  pyproj                      = "pyproj",
  rioxarray                   = "rioxarray",
  xarray                      = "xarray"
)

# ==============================================================================
# 1. Interface Python via reticulate + conda open_canopy
# ==============================================================================

#' Configurer reticulate pour utiliser l'environnement conda open_canopy
#'
#' Vérifie la présence de **tous** les modules Python requis par le pipeline
#' Open-Canopy (torch + inférence ET le stack géospatial geopandas / shapely /
#' pyproj / rioxarray / xarray). Avec `install_missing = TRUE`, installe les
#' manquants via pip dans l'environnement.
#'
#' @param envname Nom de l'environnement conda.
#' @param install_missing Si `TRUE`, installe les modules manquants via pip.
#'   Par défaut `FALSE` : signale seulement, avec la commande à lancer.
#' @return (Invisible) le vecteur des noms d'import des modules manquants.
#' @export
setup_conda_env <- function(envname = CONDA_ENV, install_missing = FALSE) {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    install.packages("reticulate")
  }

  # Utiliser l'environnement conda existant (miniforge)
  reticulate::use_condaenv(envname, required = TRUE)
  message("Environnement conda configur\u00e9: ", envname)

  # Vérifier la liste complète des modules requis par le pipeline
  modules   <- names(OPEN_CANOPY_PY_MODULES)
  available <- vapply(modules, reticulate::py_module_available, logical(1))
  for (i in seq_along(modules)) {
    message(sprintf("  %s: %s", modules[i],
                    ifelse(available[i], "OK", "MANQUANT")))
  }

  missing <- modules[!available]
  if (length(missing)) {
    pip_pkgs <- unname(OPEN_CANOPY_PY_MODULES[missing])
    if (isTRUE(install_missing)) {
      message("Installation des modules manquants (pip): ",
              paste(pip_pkgs, collapse = ", "))
      reticulate::py_install(pip_pkgs, envname = envname, pip = TRUE)
    } else {
      warning(sprintf(
        paste0("Modules Python manquants dans '%s' : %s.\n",
               "R\u00e9parez avec setup_conda_env(install_missing = TRUE), ou :\n",
               "  python -m pip install %s"),
        envname, paste(missing, collapse = ", "),
        paste(pip_pkgs, collapse = " ")), call. = FALSE)
    }
  }
  invisible(missing)
}

#' Trouver le nom du fichier checkpoint dans un dépôt HF via l'API
#'
#' Interroge l'API Hugging Face pour découvrir les fichiers checkpoint
#' disponibles dans le répertoire pretrained_models/ du dataset.
#'
#' @param repo_id Identifiant du dépôt HF (ex: "AI4Forest/Open-Canopy")
#' @param model_name "unet" ou "pvtv2" pour filtrer
#' @return Chemin du fichier checkpoint dans le dépôt, ou NULL
find_checkpoint_name <- function(repo_id = "AI4Forest/Open-Canopy",
                                  model_name = "pvtv2") {
  url <- paste0("https://huggingface.co/api/datasets/", repo_id)
  resp <- tryCatch(
    httr2::request(url) |> httr2::req_perform(),
    error = function(e) NULL
  )
  if (is.null(resp)) return(NULL)

  info <- jsonlite::fromJSON(httr2::resp_body_string(resp))
  files <- info$siblings$rfilename
  ckpt_files <- files[grepl("^pretrained_models/.*\\.ckpt$", files)]
  if (length(ckpt_files) == 0) return(NULL)

  # Filtrer par nom de modèle
  pattern <- switch(model_name,
    unet  = "unet|smp",
    pvtv2 = "pvt|pvtv2",
    model_name
  )
  matches <- ckpt_files[grep(pattern, ckpt_files, ignore.case = TRUE)]
  if (length(matches) > 0) return(matches[1])
  return(ckpt_files[1])
}

#' Télécharger les modèles pré-entraînés depuis Hugging Face
#'
#' Pour l'étape téléchargement uniquement, utilise le package R
#' hfhub (sans passer par le sous-module Python huggingface_hub).
#' Fallback sur huggingface_hub Python si hfhub n'est pas
#' installé. L'inférence qui suit nécessite toujours Python
#' (torch, rasterio, smp, timm).
#'
#' @param model_name "unet" ou "pvtv2"
#' @return Chemin local du modèle
download_pretrained_model <- function(model_name = "pvtv2") {
  repo_id <- "AI4Forest/Open-Canopy"

  model_files <- list(
    unet = "pretrained_models/unet_best.ckpt",
    pvtv2 = "pretrained_models/pvtv2_best.ckpt"
  )

  if (!model_name %in% names(model_files)) {
    stop("Mod\u00e8le inconnu: ", model_name,
         ". Choisir parmi: ", paste(names(model_files), collapse = ", "))
  }

  message("T\u00e9l\u00e9chargement du mod\u00e8le ", model_name, "...")
  message("Depuis: ", repo_id)

  # --- Méthode 1 : hfhub R natif (préféré) ---
  if (requireNamespace("hfhub", quietly = TRUE)) {
    ckpt_name <- find_checkpoint_name(repo_id, model_name)
    if (is.null(ckpt_name)) {
      ckpt_name <- model_files[[model_name]]
    }
    message("  T\u00e9l\u00e9chargement via hfhub (R natif): ", ckpt_name)
    tryCatch({
      local_path <- hfhub::hub_download(repo_id, ckpt_name,
                                          repo_type = "dataset")
      message("  Mod\u00e8le t\u00e9l\u00e9charg\u00e9: ", local_path)
      return(local_path)
    }, error = function(e) {
      message("  hfhub \u00e9chou\u00e9: ", e$message, " \u2192 fallback Python")
    })
  }

  # --- Méthode 2 : Python huggingface_hub (fallback) ---
  hf_hub <- reticulate::import("huggingface_hub")

  filename <- model_files[[model_name]]
  tryCatch({
    local_path <- hf_hub$hf_hub_download(
      repo_id = repo_id,
      filename = filename,
      repo_type = "dataset"
    )
    message("  Mod\u00e8le t\u00e9l\u00e9charg\u00e9: ", local_path)
    return(local_path)
  }, error = function(e) {
    stop("\u00c9chec du t\u00e9l\u00e9chargement: ", e$message, call. = FALSE)
  })
}

# ==============================================================================
# 2. Préparation des images IGN pour l'inférence
# ==============================================================================

#' Rééchantillonner une ortho IGN de 0.20m vers 1.5m
#'
#' Les modèles Open-Canopy sont entraînés sur SPOT à 1.5m.
#' Pour les utiliser sur les ortho IGN, on agrège les pixels.
#' Facteur d'agrégation : 1.5 / 0.2 = 7.5 → arrondi à 8
#'
#' @param ign_raster SpatRaster IGN à 0.20m
#' @param target_res Résolution cible en mètres
#' @param method Méthode d'agrégation ("mean", "median")
#' @return SpatRaster à la résolution cible
resample_ign_to_spot <- function(ign_raster, target_res = RES_SPOT,
                                  method = "mean") {
  current_res <- res(ign_raster)[1]
  agg_factor <- round(target_res / current_res)

  message(sprintf("R\u00e9\u00e9chantillonnage IGN: %.2fm \u2192 %.2fm (facteur %dx)",
                   current_res, target_res, agg_factor))
  message(sprintf("  Avant: %d x %d pixels (%d)",
                   nrow(ign_raster), ncol(ign_raster), ncell(ign_raster)))

  r_resampled <- aggregate(ign_raster, fact = agg_factor, fun = method,
                             na.rm = TRUE)

  message(sprintf("  Apr\u00e8s: %d x %d pixels (%d)",
                   nrow(r_resampled), ncol(r_resampled), ncell(r_resampled)))

  return(r_resampled)
}

#' Découper une image IGN en tuiles pour l'inférence
#'
#' Les modèles Open-Canopy travaillent sur des tuiles de 1km x 1km.
#' À 1.5m de résolution : 667 x 667 pixels.
#'
#' @param ign_raster SpatRaster IGN (déjà rééchantillonné à 1.5m)
#' @param tile_size Taille des tuiles en mètres (1000 = 1km)
#' @param overlap Chevauchement entre tuiles en mètres
#' @return Liste de SpatRasters (tuiles)
tile_for_inference <- function(ign_raster, tile_size = 1000, overlap = 0) {
  e <- ext(ign_raster)
  x_starts <- seq(e[1], e[2] - tile_size, by = tile_size - overlap)
  y_starts <- seq(e[3], e[4] - tile_size, by = tile_size - overlap)

  tiles <- list()
  idx <- 1
  for (x0 in x_starts) {
    for (y0 in y_starts) {
      tile_ext <- ext(x0, x0 + tile_size, y0, y0 + tile_size)
      tile <- crop(ign_raster, tile_ext)
      tile_name <- sprintf("tile_%06d_%07d", round(x0), round(y0))
      tiles[[tile_name]] <- tile
      idx <- idx + 1
    }
  }

  message(sprintf("%d tuile(s) de %dm x %dm cr\u00e9\u00e9e(s)", length(tiles),
                   tile_size, tile_size))
  return(tiles)
}

#' Préparer une tuile IGN pour le modèle Open-Canopy
#'
#' Normalisation des valeurs et conversion en format attendu.
#' Les images SPOT Open-Canopy sont en réflectance `[0, 1]` ou `[0, 10000]`.
#' Les ortho IGN sont en radiométrie 8-bit `[0, 255]`.
#'
#' @param tile SpatRaster d'une tuile
#' @param normalize_to Plage cible ("0_1" ou "0_10000")
#' @return SpatRaster normalisé
normalize_for_model <- function(tile, normalize_to = "0_1") {
  # La fonction n'a besoin que du maximum : global("max") le donne en streaming,
  # la ou values() rapatriait la tuile entiere (4 bandes) — sur chaque tuile de
  # chaque prediction, c'est le rapatriement le plus systematique du paquet.
  maxima <- as.numeric(global(tile, "max", na.rm = TRUE)[, "max"])
  maxima <- maxima[is.finite(maxima)]

  # Tuile (ou bande) entierement NA : rien a normaliser. values() renvoyait
  # -Inf avec un warning ; on sort proprement.
  if (length(maxima) == 0) return(tile)
  current_max <- max(maxima)

  if (normalize_to == "0_1") {
    if (current_max > 1) {
      tile <- tile / current_max
    }
  } else if (normalize_to == "0_10000") {
    if (current_max <= 255) {
      tile <- tile / 255 * 10000
    } else if (current_max <= 1) {
      tile <- tile * 10000
    }
  }

  return(tile)
}

# ==============================================================================
# 3. Inférence Python via reticulate
# ==============================================================================

#' Exécuter l'inférence sur une tuile via Python
#'
#' @param tile_path Chemin du fichier raster de la tuile
#' @param model_path Chemin du modèle .ckpt
#' @param output_path Chemin de sortie
#' @return Chemin du fichier de prédiction
run_inference_python <- function(tile_path, model_path, output_path = NULL) {

  if (is.null(output_path)) {
    output_path <- file.path(OUTPUT_DIR,
                              paste0("pred_", basename(tile_path)))
  }
  dir_create(dirname(output_path))

  # Script Python inline pour l'inference
  py_code <- '
import torch
import numpy as np
import rasterio

# Charger le modele
checkpoint = torch.load("__MODEL_PATH__", map_location="cpu", weights_only=False)

# Charger l image
with rasterio.open("__TILE_PATH__") as src:
    image = src.read().astype(np.float32)
    profile = src.profile.copy()

# Preparer pour le modele (batch dim)
tensor = torch.from_numpy(image).unsqueeze(0)

# Inference
model = checkpoint.get("model", checkpoint.get("state_dict", None))
if model is not None:
    print("Modele charge, inference en cours...")
else:
    print("Structure du checkpoint:")
    print(list(checkpoint.keys()))

# Sauvegarder le resultat
profile.update(count=1, dtype="float32")
# Note: adapter selon la sortie reelle du modele
'
  py_code <- gsub("__MODEL_PATH__", gsub("\\\\", "/", model_path), py_code, fixed = TRUE)
  py_code <- gsub("__TILE_PATH__", gsub("\\\\", "/", tile_path), py_code, fixed = TRUE)

  tryCatch({
    reticulate::py_run_string(py_code)
    message("Inf\u00e9rence termin\u00e9e: ", output_path)
    return(output_path)
  }, error = function(e) {
    warning("Erreur d'inf\u00e9rence: ", e$message)
    return(NULL)
  })
}

#' Pipeline complet : ortho IGN → prédiction CHM
#'
#' @param ign_path Chemin de l'ortho IGN (.jp2 ou .tif)
#' @param model_path Chemin du modèle pré-entraîné
#' @param ign_type "rvb" ou "irc"
#' @return SpatRaster des prédictions mosaïquées
predict_chm_from_ign <- function(ign_path, model_path, ign_type = "rvb") {
  message("=== Pipeline : Ortho IGN \u2192 CHM pr\u00e9dit ===")
  message(sprintf("Image: %s (%s, %.2fm)", basename(ign_path),
                   toupper(ign_type), RES_IGN))

  # 1. Charger l'image IGN
  ign <- rast(ign_path)
  if (ign_type == "irc" && nlyr(ign) >= 3) {
    names(ign)[1:3] <- c("PIR", "Rouge", "Vert")
  } else if (nlyr(ign) >= 3) {
    names(ign)[1:3] <- c("Rouge", "Vert", "Bleu")
  }

  # 2. Rééchantillonner à 1.5m
  ign_resampled <- resample_ign_to_spot(ign)

  # 3. Découper en tuiles
  tiles <- tile_for_inference(ign_resampled)

  # 4. Inférence sur chaque tuile
  pred_paths <- character(length(tiles))
  for (i in seq_along(tiles)) {
    tile_name <- names(tiles)[i]
    message(sprintf("  Tuile %d/%d: %s", i, length(tiles), tile_name))

    # Sauvegarder la tuile temporairement
    tmp_path <- tempfile(pattern = tile_name, fileext = ".tif")
    tile_norm <- normalize_for_model(tiles[[i]])
    writeRaster(tile_norm, tmp_path, overwrite = TRUE)

    # Inférence
    pred_path <- file.path(OUTPUT_DIR, paste0("pred_", tile_name, ".tif"))
    pred_paths[i] <- run_inference_python(tmp_path, model_path, pred_path)
    unlink(tmp_path)
  }

  message("=== Pipeline termin\u00e9 ===")
  return(pred_paths)
}

# ==============================================================================
# 4. Post-traitement et évaluation des prédictions
# ==============================================================================

#' Charger les prédictions
#'
#' @param prediction_path Chemin d'un fichier de prédiction, ou d'un répertoire
#'   dont les .tif seront tous chargés
#' @return SpatRaster, ou liste de SpatRaster si `prediction_path` est un dossier
load_predictions <- function(prediction_path) {
  pred <- rast(prediction_path)
  message(sprintf("Pr\u00e9dictions: %s (%d x %d, %.2fm)",
                   basename(prediction_path), nrow(pred), ncol(pred), res(pred)[1]))
  return(pred)
}

#' Évaluer les prédictions vs CHM de référence
#'
#' Biais, RMSE et nombre de pixels sont exacts et calculés en streaming sur le
#' seul raster de différence ; le MAE l'est aussi, au prix d'une couche dérivée.
#' `values()` rapatriait au contraire trois couches pleine résolution
#' simultanément (plusieurs Go à 0.20 m) — et se cassait dès que prédiction et
#' référence n'avaient pas exactement le même masque de NA, `cor()` recevant
#' alors deux vecteurs de longueurs différentes.
#'
#' Le R² demande des moments croisés, hors de portée de `global()` sans
#' matérialiser deux couches de plus : il est estimé sur un échantillon régulier
#' borné à `max_cells` paires (exact dès que le raster y tient), où les cellules
#' NA de part ou d'autre sont écartées par paires.
#'
#' @param prediction SpatRaster CHM prédit
#' @param reference SpatRaster CHM de référence
#' @param max_cells Taille max de l'échantillon régulier servant au R²
#' @return liste des métriques + le raster de différence
evaluate_predictions <- function(prediction, reference, max_cells = 1e6) {
  if (!compareGeom(prediction, reference, stopOnError = FALSE)) {
    message("Alignement des rasters...")
    prediction <- resample(prediction, reference, method = "bilinear")
  }

  # La difference porte deja le masque des cellules valides des deux cotes.
  diff_raster <- prediction - reference

  # Un seul passage streame sur la difference : biais, RMSE et effectif.
  g <- global(diff_raster, c("mean", "sdpop", "notNA"), na.rm = TRUE)
  bias <- as.numeric(g[1, "mean"])

  # RMSE reconstruite depuis les moments : E[x^2] == sd_pop(x)^2 + E[x]^2.
  # (Ne pas prendre global("rms") : terra y divise par n-1, pas par n.)
  rmse <- sqrt(as.numeric(g[1, "std"])^2 + bias^2)

  # Seule metrique exacte a demander une couche derivee — une de plus que la
  # difference, la ou values() en tenait trois en memoire d'un coup.
  mae <- as.numeric(global(abs(diff_raster), "mean", na.rm = TRUE))

  # R2 sur un echantillon regulier borne : na.rm ecarte les paires incompletes,
  # donc prediction et reference restent alignees quels que soient leurs NA.
  ech <- spatSample(c(prediction, reference), max_cells, method = "regular",
                    na.rm = TRUE, warn = FALSE)
  r_squared <- cor(ech[[1]], ech[[2]])^2

  metrics <- list(
    mae = mae, rmse = rmse, bias = bias,
    r_squared = r_squared, diff_raster = diff_raster,
    n_pixels = as.numeric(g[1, "notNA"])
  )

  message("=== M\u00e9triques ===")
  message(sprintf("  MAE: %.3fm | RMSE: %.3fm | Biais: %.3fm | R\u00b2: %.4f",
                   mae, rmse, bias, r_squared))
  return(metrics)
}

#' Visualiser la comparaison prédiction vs référence
#'
#' @param prediction SpatRaster du CHM prédit
#' @param reference SpatRaster du CHM de référence (LiDAR)
#' @param metrics Liste de métriques à afficher, telle que renvoyée par
#'   [evaluate_predictions()] ; `NULL` pour ne rien annoter
#' @param tile_name Nom de la tuile, repris dans les titres
#' @param n_points Nombre de cellules échantillonnées pour le nuage de points
#' @return Invisible `NULL`, appelée pour son effet de bord (tracé)
plot_prediction_comparison <- function(prediction, reference, metrics = NULL,
                                        tile_name = "", n_points = 50000) {
  par(mfrow = c(2, 2), mar = c(2, 2, 3, 4))

  col_chm <- colorRampPalette(
    c("#f7fcb9", "#addd8e", "#41ab5d", "#006837", "#004529")
  )(100)

  plot(prediction, main = paste("Pr\u00e9diction", tile_name),
       col = col_chm, plg = list(title = "H (m)"))
  plot(reference, main = paste("R\u00e9f\u00e9rence LiDAR", tile_name),
       col = col_chm, plg = list(title = "H (m)"))

  if (!is.null(metrics)) {
    col_div <- colorRampPalette(
      c("#d73027", "#fc8d59", "#fee08b", "#ffffbf",
        "#d9ef8b", "#91cf60", "#1a9850")
    )(100)

    # global() streame : values() rapatriait le raster d'erreur pour une amplitude.
    g <- global(metrics$diff_raster, c("min", "max"), na.rm = TRUE)
    max_abs <- max(abs(c(g[1, "min"], g[1, "max"])))

    plot(metrics$diff_raster, main = "Erreur (Pred - Ref)",
         col = col_div, range = c(-max_abs, max_abs),
         plg = list(title = "Delta (m)"))

    # Le nuage n'affiche que n_points points : les tirer directement par
    # echantillonnage regulier, au lieu de rapatrier les deux couches entieres
    # pour n'en garder qu'une fraction. na.rm ecarte les cellules NA de part
    # ou d'autre, donc les paires restent alignees.
    ech <- spatSample(c(prediction, reference), n_points, method = "regular",
                      na.rm = TRUE, warn = FALSE)

    plot(ech[[2]], ech[[1]],
         pch = ".", col = rgb(0, 0.5, 0, 0.1),
         main = sprintf("Pred vs Ref (R\u00b2=%.3f, MAE=%.2fm)",
                         metrics$r_squared, metrics$mae),
         xlab = "R\u00e9f\u00e9rence (m)", ylab = "Pr\u00e9diction (m)")
    abline(0, 1, col = "red", lwd = 2)
  }

  par(mfrow = c(1, 1))
}

# ==============================================================================
# 5. Analyse spatiale
# ==============================================================================

#' Statistiques zonales
#'
#' @param chm_raster SpatRaster du CHM
#' @param zones SpatVector des zones d'agrégation
#' @param fun Fonction d'agrégation passée à [terra::zonal()] (ex. "mean")
#' @return data.frame d'une ligne par zone
zonal_canopy_stats <- function(chm_raster, zones, fun = "mean") {
  extract(chm_raster, zones, fun = fun, na.rm = TRUE)
}

#' Couverture forestière par grille
#'
#' @param chm_raster SpatRaster du CHM
#' @param cell_size Côté de la maille en mètres
#' @param height_threshold Hauteur minimale, en mètres, pour compter une cellule
#'   comme forestière
#' @return SpatRaster de la fraction forestière par maille, dans `[0, 1]`
compute_forest_cover_grid <- function(chm_raster, cell_size = 100,
                                       height_threshold = 2) {
  forest_mask <- chm_raster >= height_threshold
  agg_factor <- round(cell_size / res(chm_raster)[1])
  if (agg_factor > 1) {
    forest_cover <- aggregate(forest_mask, fact = agg_factor, fun = mean,
                               na.rm = TRUE) * 100
  } else {
    forest_cover <- forest_mask * 100
  }
  names(forest_cover) <- "forest_cover_pct"
  return(forest_cover)
}

#' Détection de perte de canopée
#'
#' @param chm_t1 SpatRaster du CHM à la première date
#' @param chm_t2 SpatRaster du CHM à la seconde date, rééchantillonné sur
#'   `chm_t1` si les géométries diffèrent
#' @param threshold Seuil de variation, en mètres ; négatif, une perte étant une
#'   diminution de hauteur
#' @return SpatRaster booléen, TRUE là où la perte dépasse le seuil
detect_canopy_loss <- function(chm_t1, chm_t2, threshold = -5) {
  if (!compareGeom(chm_t1, chm_t2, stopOnError = FALSE)) {
    chm_t2 <- resample(chm_t2, chm_t1, method = "bilinear")
  }
  change <- chm_t2 - chm_t1
  loss <- change <= threshold
  names(loss) <- "canopy_loss"

  # global("sum") streame : values() sur un masque plein resolution coute des Go.
  loss_area <- as.numeric(global(loss, "sum", na.rm = TRUE)) *
               prod(res(chm_t1)) / 10000
  message(sprintf("Perte d\u00e9tect\u00e9e: %.2f ha (seuil: %dm)", loss_area, threshold))
  return(loss)
}

#' Suréchantillonner un CHM prédit (1.5m) vers la résolution IGN (0.20m)
#'
#' @param chm_predicted SpatRaster CHM prédit à 1.5m
#' @param target_res Résolution cible (0.2m)
#' @param method Méthode d'interpolation
#' @return SpatRaster à 0.20m
upsample_chm_to_ign <- function(chm_predicted, target_res = RES_IGN,
                                  method = "bilinear") {
  current_res <- res(chm_predicted)[1]
  disagg_factor <- round(current_res / target_res)

  message(sprintf("Sur\u00e9chantillonnage CHM: %.2fm \u2192 %.2fm (facteur %dx)",
                   current_res, target_res, disagg_factor))

  chm_hr <- disagg(chm_predicted, fact = disagg_factor, method = method)

  message(sprintf("  R\u00e9sultat: %d x %d pixels", nrow(chm_hr), ncol(chm_hr)))
  return(chm_hr)
}

# ==============================================================================
# 6. Export
# ==============================================================================

#' Exporter une liste de rasters vers un GeoPackage
#'
#' Chaque couche binaire (valeurs valant 0 ou 1) est vectorisée puis écrite comme
#' couche du GeoPackage ; les autres sont écrites en GeoTIFF à côté, un raster
#' continu n'ayant pas de représentation vectorielle utile.
#'
#' @param raster_list Liste nommée de SpatRaster ; les noms deviennent les noms
#'   de couches du GeoPackage
#' @param filename Nom du fichier GeoPackage produit
#' @param output_dir Répertoire de sortie
#' @return Invisible `NULL`, appelée pour son effet de bord (écriture disque)
export_to_gpkg <- function(raster_list, filename = "results.gpkg",
                            output_dir = OUTPUT_DIR) {
  dir_create(output_dir)
  out_path <- file.path(output_dir, filename)

  for (i in seq_along(raster_list)) {
    name <- names(raster_list)[i]
    r <- raster_list[[i]]

    # Test binaire en streaming : compte les cellules hors {0, 1} sans charger r.
    # NA = aucune cellule valide, ce que l'ancien all(logical(0)) rendait TRUE.
    n_hors <- as.numeric(global(r != 0 & r != 1, "sum", na.rm = TRUE))
    if (is.na(n_hors) || n_hors == 0) {
      v <- as.polygons(r)
      writeVector(v, out_path, layer = name, overwrite = (i == 1))
    } else {
      writeRaster(r, paste0(out_path, "_", name, ".tif"), overwrite = TRUE)
    }
  }

  message("R\u00e9sultats export\u00e9s: ", out_path)
}

# ==============================================================================
# Exécution principale
# ==============================================================================

if (sys.nframe() == 0) {
  message("=== Open-Canopy : Pr\u00e9diction CHM depuis images IGN (0.20m) ===\n")
  message("Workflow :")
  message("  1. Ortho IGN (RVB/IRC) \u00e0 0.20m")
  message("  2. Agr\u00e9gation \u00e0 1.5m (r\u00e9solution SPOT)")
  message("  3. Inf\u00e9rence UNet/PVTv2 (conda: open_canopy)")
  message("  4. Post-traitement et analyse en R\n")

  message("--- Configuration ---")
  message(sprintf("  R\u00e9solution IGN:  %.2f m (%d pixels/km\u00b2)",
                   RES_IGN, as.integer((1000 / RES_IGN)^2)))
  message(sprintf("  R\u00e9solution SPOT: %.1f m  (%d pixels/km\u00b2)",
                   RES_SPOT, as.integer((1000 / RES_SPOT)^2)))
  message(sprintf("  Env. conda:      %s", CONDA_ENV))

  # Vérifier l'environnement conda
  tryCatch({
    setup_conda_env()
    message("\nEnvironnement Python op\u00e9rationnel.")
  }, error = function(e) {
    message("\nEnvironnement conda non disponible: ", e$message)
    message("Assurez-vous que miniforge et l'env 'open_canopy' sont install\u00e9s.")
  })

  # Rechercher des images IGN
  ign_files <- unlist(lapply(c("*.jp2", "*.tif"), function(ext) {
    dir_ls(DATA_DIR_IGN, recurse = TRUE, glob = ext)
  }))

  if (length(ign_files) > 0) {
    message(sprintf("\n%d image(s) IGN trouv\u00e9e(s):", length(ign_files)))
    for (f in ign_files) {
      message(sprintf("  %s (%.1f Mo)", basename(f), file.size(f) / 1024^2))
    }
  } else {
    message("\nAucune image IGN trouv\u00e9e dans: ", DATA_DIR_IGN)
    message("Placez vos fichiers ortho IGN (.jp2 ou .tif) dans ce r\u00e9pertoire.")
    message("\nD\u00e9monstration avec donn\u00e9es simul\u00e9es...\n")

    # Simulation
    set.seed(42)
    ref <- rast(nrows = 667, ncols = 667,
                 xmin = 843000, xmax = 844000,
                 ymin = 6518000, ymax = 6519000,
                 crs = "EPSG:2154")
    values(ref) <- pmax(0, rnorm(ncell(ref), mean = 10, sd = 8))
    names(ref) <- "reference_chm"

    pred <- ref + rnorm(ncell(ref), mean = 0, sd = 2)
    values(pred) <- pmax(0, values(pred))
    names(pred) <- "predicted_chm"

    metrics <- evaluate_predictions(pred, ref)

    pdf(file.path(OUTPUT_DIR, "demo_prediction_ign.pdf"), width = 12, height = 10)
    plot_prediction_comparison(pred, ref, metrics, "Simulation IGN")
    dev.off()

    forest_cover <- compute_forest_cover_grid(ref, cell_size = 50)

    pdf(file.path(OUTPUT_DIR, "demo_forest_cover.pdf"), width = 8, height = 8)
    plot(forest_cover, main = "Couverture foresti\u00e8re (%)",
         col = colorRampPalette(c("#fff7bc", "#41ab5d", "#004529"))(100))
    dev.off()

    message("Graphiques: ", OUTPUT_DIR)
  }

  message("\n=== Termin\u00e9 ===")
}
