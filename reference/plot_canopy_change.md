# Visualiser les changements de canopée

Visualiser les changements de canopée

## Usage

``` r
plot_canopy_change(
  change_raster,
  title = "Changement de hauteur de canopée (m)"
)
```

## Arguments

- change_raster:

  SpatRaster de variation de hauteur, tel que renvoyé par
  [`compute_canopy_change()`](https://pobsteta.github.io/opencanopy/reference/compute_canopy_change.md)

- title:

  Titre du graphique

## Value

Invisible `NULL`, appelée pour son effet de bord (tracé)
