# Calculer le GNDVI (Green NDVI) depuis une ortho IRC IGN

GNDVI = (PIR - Vert) / (PIR + Vert)

## Usage

``` r
compute_gndvi(irc_raster)
```

## Arguments

- irc_raster:

  SpatRaster IRC IGN

## Value

SpatRaster du GNDVI
