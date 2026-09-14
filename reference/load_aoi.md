# Charger l'AOI depuis un fichier GeoPackage

Charger l'AOI depuis un fichier GeoPackage

## Usage

``` r
load_aoi(gpkg_path, layer = NULL)
```

## Arguments

- gpkg_path:

  Chemin vers le fichier .gpkg

- layer:

  Nom de la couche (NULL = première couche)

## Value

sf object en Lambert-93 (EPSG:2154)
