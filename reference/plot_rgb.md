# Visualiser une image en couleurs naturelles (RGB)

Fonctionne avec SPOT (Open-Canopy) et ortho IGN RVB

## Usage

``` r
plot_rgb(raster_rgb, title = "Image RGB", bands = c(1, 2, 3))
```

## Arguments

- raster_rgb:

  SpatRaster avec au moins 3 bandes

- title:

  Titre du graphique

- bands:

  Indices des bandes RGB
