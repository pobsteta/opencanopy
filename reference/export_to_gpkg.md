# Exporter une liste de rasters vers un GeoPackage

Chaque couche binaire (valeurs dans 0, 1) est vectorisée puis écrite
comme couche du GeoPackage ; les autres sont écrites en GeoTIFF à côté,
un raster continu n'ayant pas de représentation vectorielle utile.

## Usage

``` r
export_to_gpkg(raster_list, filename = "results.gpkg", output_dir = OUTPUT_DIR)
```

## Arguments

- raster_list:

  Liste nommée de SpatRaster ; les noms deviennent les noms de couches
  du GeoPackage

- filename:

  Nom du fichier GeoPackage produit

- output_dir:

  Répertoire de sortie

## Value

Invisible `NULL`, appelée pour son effet de bord (écriture disque)
