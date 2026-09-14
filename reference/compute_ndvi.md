# Calculer le NDVI depuis une ortho IRC IGN

NDVI = (PIR - Rouge) / (PIR + Rouge) Nécessite une image IRC avec bandes
PIR et Rouge

## Usage

``` r
compute_ndvi(irc_raster)
```

## Arguments

- irc_raster:

  SpatRaster IRC IGN (bandes: PIR, Rouge, Vert)

## Value

SpatRaster du NDVI (valeurs entre -1 et 1)
