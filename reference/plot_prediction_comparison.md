# Visualiser la comparaison prédiction vs référence

Visualiser la comparaison prédiction vs référence

## Usage

``` r
plot_prediction_comparison(
  prediction,
  reference,
  metrics = NULL,
  tile_name = "",
  n_points = 50000
)
```

## Arguments

- prediction:

  SpatRaster du CHM prédit

- reference:

  SpatRaster du CHM de référence (LiDAR)

- metrics:

  Liste de métriques à afficher, telle que renvoyée par
  [`evaluate_predictions()`](https://pobsteta.github.io/opencanopy/reference/evaluate_predictions.md)
  ; `NULL` pour ne rien annoter

- tile_name:

  Nom de la tuile, repris dans les titres

- n_points:

  Nombre de cellules échantillonnées pour le nuage de points

## Value

Invisible `NULL`, appelée pour son effet de bord (tracé)
