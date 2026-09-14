# Package index

## Pipeline complet

Point d’entree principal : produit CHM + indices + PDF recapitulatif
depuis un fichier AOI GeoPackage.

- [`pipeline_aoi_to_chm()`](https://pobsteta.github.io/opencanopy/reference/pipeline_aoi_to_chm.md)
  : Pipeline complet : AOI → Ortho IGN → CHM prédit

## Telechargement de donnees

Orthophotos IGN (WMS Geoplateforme) et dataset Open-Canopy (Hugging
Face).

- [`download_ign_ortho_pair()`](https://pobsteta.github.io/opencanopy/reference/download_ign_ortho_pair.md)
  : Télécharger les ortho RVB et IRC pour une même emprise
- [`download_ign_tiled()`](https://pobsteta.github.io/opencanopy/reference/download_ign_tiled.md)
  : Télécharger une ortho IGN complète pour une emprise (avec tuilage
  automatique)
- [`download_ign_wms()`](https://pobsteta.github.io/opencanopy/reference/download_ign_wms.md)
  : Télécharger une ortho IGN via WMS (pour une emprise donnée)
- [`download_model()`](https://pobsteta.github.io/opencanopy/reference/download_model.md)
  : Télécharger le modèle pré-entraîné depuis Hugging Face
- [`download_open_canopy_src()`](https://pobsteta.github.io/opencanopy/reference/download_open_canopy_src.md)
  : Télécharger le code source Open-Canopy
- [`download_open_canopy_subset()`](https://pobsteta.github.io/opencanopy/reference/download_open_canopy_subset.md)
  : Télécharger un sous-ensemble du dataset Open-Canopy
- [`download_ortho_for_aoi()`](https://pobsteta.github.io/opencanopy/reference/download_ortho_for_aoi.md)
  : Télécharger les ortho RVB et IRC pour une AOI
- [`download_pretrained_model()`](https://pobsteta.github.io/opencanopy/reference/download_pretrained_model.md)
  : Télécharger les modèles pré-entraînés depuis Hugging Face
- [`download_wms_tile()`](https://pobsteta.github.io/opencanopy/reference/download_wms_tile.md)
  : Télécharger une tuile WMS IGN
- [`hf_download_file()`](https://pobsteta.github.io/opencanopy/reference/hf_download_file.md)
  : Télécharger un fichier depuis Hugging Face
- [`hf_download_files()`](https://pobsteta.github.io/opencanopy/reference/hf_download_files.md)
  : Télécharger un ensemble de fichiers depuis Hugging Face
- [`hf_git_clone()`](https://pobsteta.github.io/opencanopy/reference/hf_git_clone.md)
  : Cloner le dataset complet via git (nécessite git-lfs)
- [`hf_list_files()`](https://pobsteta.github.io/opencanopy/reference/hf_list_files.md)
  : Lister les fichiers du dataset sur Hugging Face
- [`load_aoi()`](https://pobsteta.github.io/opencanopy/reference/load_aoi.md)
  : Charger l'AOI depuis un fichier GeoPackage
- [`load_ign_ortho()`](https://pobsteta.github.io/opencanopy/reference/load_ign_ortho.md)
  : Charger une ortho IGN (RVB ou IRC, 0.20m)
- [`scan_ign_files()`](https://pobsteta.github.io/opencanopy/reference/scan_ign_files.md)
  : Scanner un répertoire pour trouver les ortho IGN

## Indices spectraux et analyse

Calcul d’indices depuis l’IRC, masques, statistiques zonales.

- [`compute_canopy_change()`](https://pobsteta.github.io/opencanopy/reference/compute_canopy_change.md)
  : Différence de canopée entre deux dates
- [`compute_chm_stats()`](https://pobsteta.github.io/opencanopy/reference/compute_chm_stats.md)
  : Statistiques de hauteur de canopée
- [`compute_forest_cover_grid()`](https://pobsteta.github.io/opencanopy/reference/compute_forest_cover_grid.md)
  : Couverture forestière par grille
- [`compute_gndvi()`](https://pobsteta.github.io/opencanopy/reference/compute_gndvi.md)
  : Calculer le GNDVI (Green NDVI) depuis une ortho IRC IGN
- [`compute_irc_stats()`](https://pobsteta.github.io/opencanopy/reference/compute_irc_stats.md)
  : Statistiques spectrales d'une ortho IRC IGN
- [`compute_ndvi()`](https://pobsteta.github.io/opencanopy/reference/compute_ndvi.md)
  : Calculer le NDVI depuis une ortho IRC IGN
- [`compute_ndwi()`](https://pobsteta.github.io/opencanopy/reference/compute_ndwi.md)
  : Calculer le NDWI (Normalized Difference Water Index, McFeeters 1996)
- [`compute_savi()`](https://pobsteta.github.io/opencanopy/reference/compute_savi.md)
  : Calculer le NDRE (Normalized Difference Red Edge) approximé
- [`mask_vegetation()`](https://pobsteta.github.io/opencanopy/reference/mask_vegetation.md)
  : Créer un masque de végétation à partir du NDVI
- [`cross_ndvi_chm()`](https://pobsteta.github.io/opencanopy/reference/cross_ndvi_chm.md)
  : Croiser NDVI (IGN IRC) et CHM pour caractériser la végétation
- [`zonal_canopy_stats()`](https://pobsteta.github.io/opencanopy/reference/zonal_canopy_stats.md)
  : Statistiques zonales
- [`detect_canopy_loss()`](https://pobsteta.github.io/opencanopy/reference/detect_canopy_loss.md)
  : Détection de perte de canopée

## Inference et post-traitement

Preparation des tuiles, inference Python, reechantillonnage du CHM.

- [`setup_conda_env()`](https://pobsteta.github.io/opencanopy/reference/setup_conda_env.md)
  : Configurer reticulate pour utiliser l'environnement conda
  open_canopy
- [`setup_python()`](https://pobsteta.github.io/opencanopy/reference/setup_python.md)
  : Configurer l'environnement Python
- [`download_pretrained_model()`](https://pobsteta.github.io/opencanopy/reference/download_pretrained_model.md)
  : Télécharger les modèles pré-entraînés depuis Hugging Face
- [`download_model()`](https://pobsteta.github.io/opencanopy/reference/download_model.md)
  : Télécharger le modèle pré-entraîné depuis Hugging Face
- [`download_open_canopy_src()`](https://pobsteta.github.io/opencanopy/reference/download_open_canopy_src.md)
  : Télécharger le code source Open-Canopy
- [`find_checkpoint_name()`](https://pobsteta.github.io/opencanopy/reference/find_checkpoint_name.md)
  : Trouver le nom du fichier checkpoint dans le dataset HF via l'API
- [`tile_for_inference()`](https://pobsteta.github.io/opencanopy/reference/tile_for_inference.md)
  : Découper une image IGN en tuiles pour l'inférence
- [`normalize_for_model()`](https://pobsteta.github.io/opencanopy/reference/normalize_for_model.md)
  : Préparer une tuile IGN pour le modèle Open-Canopy
- [`run_inference_python()`](https://pobsteta.github.io/opencanopy/reference/run_inference_python.md)
  : Exécuter l'inférence sur une tuile via Python
- [`predict_chm_from_ign()`](https://pobsteta.github.io/opencanopy/reference/predict_chm_from_ign.md)
  : Pipeline complet : ortho IGN → prédiction CHM
- [`resample_ign_to_spot()`](https://pobsteta.github.io/opencanopy/reference/resample_ign_to_spot.md)
  : Rééchantillonner une ortho IGN de 0.2m vers 1.5m
- [`upsample_chm_to_ign()`](https://pobsteta.github.io/opencanopy/reference/upsample_chm_to_ign.md)
  : Suréchantillonner un CHM prédit (1.5m) vers la résolution IGN
  (0.20m)
- [`load_predictions()`](https://pobsteta.github.io/opencanopy/reference/load_predictions.md)
  : Charger les prédictions
- [`evaluate_predictions()`](https://pobsteta.github.io/opencanopy/reference/evaluate_predictions.md)
  : Évaluer les prédictions vs CHM de référence

## Visualisation et export

- [`plot_canopy_change()`](https://pobsteta.github.io/opencanopy/reference/plot_canopy_change.md)
  : Visualiser les changements de canopée
- [`plot_canopy_classes()`](https://pobsteta.github.io/opencanopy/reference/plot_canopy_classes.md)
  : Classification de la canopée
- [`plot_chm()`](https://pobsteta.github.io/opencanopy/reference/plot_chm.md)
  : Visualiser le CHM
- [`plot_chm_histogram()`](https://pobsteta.github.io/opencanopy/reference/plot_chm_histogram.md)
  : Histogramme des hauteurs de canopée
- [`plot_ign_full_comparison()`](https://pobsteta.github.io/opencanopy/reference/plot_ign_full_comparison.md)
  : Comparaison multi-panneaux : IGN RVB + IRC + NDVI + CHM
- [`plot_irc()`](https://pobsteta.github.io/opencanopy/reference/plot_irc.md)
  : Visualiser une ortho IRC en fausses couleurs
- [`plot_ndvi()`](https://pobsteta.github.io/opencanopy/reference/plot_ndvi.md)
  : Visualiser le NDVI
- [`plot_prediction_comparison()`](https://pobsteta.github.io/opencanopy/reference/plot_prediction_comparison.md)
  : Visualiser la comparaison prédiction vs référence
- [`plot_resolution_comparison()`](https://pobsteta.github.io/opencanopy/reference/plot_resolution_comparison.md)
  : Comparaison SPOT (1.5m) vs IGN (0.20m) sur la même zone
- [`plot_rgb()`](https://pobsteta.github.io/opencanopy/reference/plot_rgb.md)
  : Visualiser une image en couleurs naturelles (RGB)
- [`export_to_gpkg()`](https://pobsteta.github.io/opencanopy/reference/export_to_gpkg.md)
  : Exporter une liste de rasters vers un GeoPackage

## Utilitaires geospatiaux

Helpers de projection et de rattachement du CRS.

- [`ancrer_crs_l93()`](https://pobsteta.github.io/opencanopy/reference/ancrer_crs_l93.md)
  : Rattacher le CRS d'un raster à l'autorité EPSG:2154
