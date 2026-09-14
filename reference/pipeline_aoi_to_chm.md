# Pipeline complet : AOI → Ortho IGN → CHM prédit

Pipeline complet : AOI → Ortho IGN → CHM prédit

## Usage

``` r
pipeline_aoi_to_chm(
  aoi_path,
  output_dir = file.path(getwd(), "outputs"),
  model_name = "pvtv2",
  model_path = NULL,
  open_canopy_src = NULL,
  res_m = RES_IGN,
  millesime_ortho = MILLESIME_ORTHO,
  millesime_irc = MILLESIME_IRC,
  ndvi_threshold = 0.25,
  ndwi_threshold = 0.2,
  progress_callback = NULL
)
```

## Arguments

- aoi_path:

  Chemin vers le fichier aoi.gpkg

- output_dir:

  Répertoire de sortie

- model_name:

  "unet" ou "pvtv2"

- model_path:

  Chemin local vers un checkpoint .ckpt (optionnel, sinon téléchargé
  depuis HuggingFace)

- open_canopy_src:

  Chemin vers le code source Open-Canopy (optionnel, le module embarqué
  timmnet_standalone est utilisé par défaut)

- res_m:

  Résolution de téléchargement IGN (0.2m par défaut)

- millesime_ortho:

  Millésime ortho RVB (NULL = plus récent)

- millesime_irc:

  Millésime IRC (NULL = plus récent)

## Value

Liste avec tous les résultats
