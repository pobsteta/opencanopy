# Histogramme des hauteurs de canopée

Histogramme des hauteurs de canopée

## Usage

``` r
plot_chm_histogram(
  chm_raster,
  title = "Distribution des hauteurs de canopée",
  n_breaks = 50,
  max_cells = 1e+06
)
```

## Arguments

- chm_raster:

  SpatRaster du CHM

- title:

  Titre du graphique

- n_breaks:

  Nombre de classes de l'histogramme

- max_cells:

  Nombre maximal de cellules échantillonnées : au-delà, le raster est
  sous-échantillonné plutôt que rapatrié en mémoire

## Value

Invisible `NULL`, appelée pour son effet de bord (tracé)
