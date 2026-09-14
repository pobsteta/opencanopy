# Couverture forestière par grille

Couverture forestière par grille

## Usage

``` r
compute_forest_cover_grid(chm_raster, cell_size = 100, height_threshold = 2)
```

## Arguments

- chm_raster:

  SpatRaster du CHM

- cell_size:

  Côté de la maille en mètres

- height_threshold:

  Hauteur minimale, en mètres, pour compter une cellule comme forestière

## Value

SpatRaster de la fraction forestière par maille, dans `[0, 1]`
