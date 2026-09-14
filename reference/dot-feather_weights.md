# Poids de fondu (taper linéaire) d'une tuile

Poids proche de 0 sur les `margin` pixels de bordure, 1 au cœur. Les
pixels de bord — les moins fiables, le modèle n'y voit qu'un contexte
tronqué — pèsent ainsi peu face au cœur de la tuile voisine.

## Usage

``` r
.feather_weights(x, margin_x, margin_y)
```

## Arguments

- x:

  SpatRaster tuile (gabarit géométrique)

- margin_x, margin_y:

  Largeur du fondu en pixels

## Value

SpatRaster mono-bande de poids dans \]0, 1\]
