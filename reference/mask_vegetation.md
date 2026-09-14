# Créer un masque de végétation à partir du NDVI

Créer un masque de végétation à partir du NDVI

## Usage

``` r
mask_vegetation(ndvi_raster, threshold = 0.3)
```

## Arguments

- ndvi_raster:

  SpatRaster du NDVI

- threshold:

  Seuil NDVI pour considérer de la végétation

## Value

SpatRaster binaire (1 = végétation)
