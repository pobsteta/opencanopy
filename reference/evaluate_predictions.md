# Évaluer les prédictions vs CHM de référence

Biais, RMSE et nombre de pixels sont exacts et calculés en streaming sur
le seul raster de différence ; le MAE l'est aussi, au prix d'une couche
dérivée. `values()` rapatriait au contraire trois couches pleine
résolution simultanément (plusieurs Go à 0.20 m) — et se cassait dès que
prédiction et référence n'avaient pas exactement le même masque de NA,
[`cor()`](https://rdrr.io/r/stats/cor.html) recevant alors deux vecteurs
de longueurs différentes.

## Usage

``` r
evaluate_predictions(prediction, reference, max_cells = 1e+06)
```

## Arguments

- prediction:

  SpatRaster CHM prédit

- reference:

  SpatRaster CHM de référence

- max_cells:

  Taille max de l'échantillon régulier servant au R²

## Value

liste des métriques + le raster de différence

## Details

Le R² demande des moments croisés, hors de portée de `global()` sans
matérialiser deux couches de plus : il est estimé sur un échantillon
régulier borné à `max_cells` paires (exact dès que le raster y tient),
où les cellules NA de part ou d'autre sont écartées par paires.
