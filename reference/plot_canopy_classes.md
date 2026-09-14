# Classification de la canopée

Classification de la canopée

## Usage

``` r
plot_canopy_classes(
  chm_raster,
  breaks = c(0, 2, 5, 10, 20, Inf),
  labels = c("Sol/herbe (<2m)", "Arbustes (2-5m)", "Petits arbres (5-10m)",
    "Arbres moyens (10-20m)", "Grands arbres (>20m)"),
  title = "Classes de hauteur de canopée"
)
```

## Arguments

- chm_raster:

  SpatRaster du CHM

- breaks:

  Bornes des classes de hauteur, en mètres

- labels:

  Étiquettes des classes ; une de moins que `breaks`

- title:

  Titre du graphique

## Value

SpatRaster classifié, renvoyé de façon invisible
