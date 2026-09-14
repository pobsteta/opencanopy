# Pipeline d'inférence complet sur un raster

Pipeline d'inférence complet sur un raster

## Usage

``` r
run_inference(
  rvb,
  irc,
  model_path,
  model_name = "pvtv2",
  tile_size = 1000,
  overlap = 200,
  open_canopy_src = NULL,
  progress_callback = NULL
)
```

## Arguments

- rvb:

  SpatRaster ortho RVB (0.20m, 3 bandes)

- irc:

  SpatRaster ortho IRC (0.20m, 3 bandes)

- model_path:

  Chemin du modèle .ckpt

- model_name:

  "unet" ou "pvtv2"

- tile_size:

  Taille des tuiles en mètres

- overlap:

  Chevauchement entre tuiles en mètres (fondu au recollement)

## Value

SpatRaster CHM prédit
