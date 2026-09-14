# Recoller les prédictions par moyenne pondérée (fondu sur le recouvrement)

Remplace
[`terra::merge()`](https://rspatial.github.io/terra/reference/merge.html),
qui conservait brutalement la valeur de la première tuile dans la zone
de recouvrement et laissait donc une couture nette à chaque limite de
tuile.

## Usage

``` r
mosaiquer_predictions(preds, margin_x = 0L, margin_y = 0L)
```

## Arguments

- preds:

  Liste de SpatRasters prédits (même grille, même résolution)

- margin_x, margin_y:

  Largeur du fondu en pixels

## Value

SpatRaster mosaïqué

## Details

Les NA sont exclus de la moyenne (poids nul) : une tuile partiellement
invalide n'efface plus les valeurs de ses voisines.
