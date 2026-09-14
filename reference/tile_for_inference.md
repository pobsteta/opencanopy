# Découper une image IGN en tuiles pour l'inférence

Les modèles Open-Canopy travaillent sur des tuiles de 1km x 1km. À 1.5m
de résolution : 667 x 667 pixels.

## Usage

``` r
tile_for_inference(ign_raster, tile_size = 1000, overlap = 0)
```

## Arguments

- ign_raster:

  SpatRaster IGN (déjà rééchantillonné à 1.5m)

- tile_size:

  Taille des tuiles en mètres (1000 = 1km)

- overlap:

  Chevauchement entre tuiles en mètres

## Value

Liste de SpatRasters (tuiles)
