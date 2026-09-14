# Télécharger une tuile WMS IGN

Effectue des tentatives répétées en cas d'erreurs serveur transitoires
(HTTP 5xx, timeouts), avec backoff exponentiel.

## Usage

``` r
download_wms_tile(bbox, layer, res_m = RES_IGN, dest_file, max_attempts = 4)
```

## Arguments

- bbox:

  c(xmin, ymin, xmax, ymax) en Lambert-93

- layer:

  Couche WMS

- res_m:

  Résolution en mètres

- dest_file:

  Fichier de sortie

- max_attempts:

  Nombre maximal de tentatives en cas d'échec transitoire

## Value

SpatRaster ou NULL si échec
