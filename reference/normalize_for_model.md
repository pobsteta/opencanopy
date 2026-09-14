# Préparer une tuile IGN pour le modèle Open-Canopy

Normalisation des valeurs et conversion en format attendu. Les images
SPOT Open-Canopy sont en réflectance 0, 1 ou 0, 10000. Les ortho IGN
sont en radiométrie 8-bit 0, 255.

## Usage

``` r
normalize_for_model(tile, normalize_to = "0_1")
```

## Arguments

- tile:

  SpatRaster d'une tuile

- normalize_to:

  Plage cible ("0_1" ou "0_10000")

## Value

SpatRaster normalisé
