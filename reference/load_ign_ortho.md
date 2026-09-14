# Charger une ortho IGN (RVB ou IRC, 0.20m)

Supporte JPEG2000 (.jp2) et GeoTIFF (.tif) RVB : bandes Rouge, Vert,
Bleu IRC : bandes Proche Infrarouge (PIR), Rouge, Vert

La BD ORTHO® IGN est distribuée en JPEG2000 (.jp2) depuis 2016. Le
package terra supporte nativement ce format via GDAL.

## Usage

``` r
load_ign_ortho(file_path, type = "rvb")

load_ign_ortho(file_path, type = "rvb")
```

## Arguments

- file_path:

  Chemin vers le fichier .jp2 ou .tif

- type:

  "rvb" ou "irc"

## Value

SpatRaster avec bandes nommées

SpatRaster
