# Statistiques zonales

Statistiques zonales

## Usage

``` r
zonal_canopy_stats(chm_raster, zones, fun = "mean")
```

## Arguments

- chm_raster:

  SpatRaster du CHM

- zones:

  SpatVector des zones d'agrégation

- fun:

  Fonction d'agrégation passée à
  [`terra::zonal()`](https://rspatial.github.io/terra/reference/zonal.html)
  (ex. "mean")

## Value

data.frame d'une ligne par zone
