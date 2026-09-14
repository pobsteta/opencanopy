# Positions de départ (1-based) d'un découpage régulier et couvrant

La dernière tuile est **décalée** pour finir exactement sur le bord du
raster, de sorte que toutes gardent la même taille.

## Usage

``` r
.tile_starts(n, size, step)
```

## Arguments

- n:

  Nombre total de pixels sur l'axe

- size:

  Taille d'une tuile en pixels

- step:

  Pas entre deux tuiles en pixels

## Value

Vecteur entier d'indices de départ
