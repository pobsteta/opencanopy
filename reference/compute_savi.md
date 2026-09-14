# Calculer le SAVI (Soil Adjusted Vegetation Index, Huete 1988)

SAVI = ((PIR - Rouge) / (PIR + Rouge + L)) \* (1 + L) Le facteur L
attenue l'influence du sol nu, sensible sur couvert clairsemé.

## Usage

``` r
compute_savi(irc_raster, L = 0.5)
```

## Arguments

- irc_raster:

  SpatRaster IRC IGN

- L:

  Facteur de correction du sol ; 0.5 convient à un couvert moyen, 0
  ramène le SAVI au NDVI et 1 correspond à un couvert très clairsemé

## Value

SpatRaster du SAVI
