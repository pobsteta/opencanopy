# Calculer le NDWI (Normalized Difference Water Index, McFeeters 1996)

NDWI = (Vert - PIR) / (Vert + PIR) Valeurs \> 0 typiquement = eau ;
utile pour masquer rivières/étangs du CHM.

## Usage

``` r
compute_ndwi(irc_raster)
```

## Arguments

- irc_raster:

  SpatRaster IRC IGN (bandes: PIR, Rouge, Vert)

## Value

SpatRaster du NDWI (valeurs entre -1 et 1)
