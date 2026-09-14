# Statistiques de hauteur de canopée

Ce que `global()` sait calculer en streaming l'est, et reste exact :
min, max, moyenne, écart-type, comptages. `values()` rapatriait la
couche entière (plusieurs Go à 0.20 m, 4e8 cellules) pour une poignée de
scalaires.

## Usage

``` r
compute_chm_stats(chm_raster, max_cells = 1e+06)
```

## Arguments

- chm_raster:

  SpatRaster CHM

- max_cells:

  Taille max de l'échantillon régulier (quantiles et parts)

## Value

data.frame d'une ligne

## Details

Quantiles et parts de surface échappent à `global()`. Les obtenir par un
raster dérivé (`global(chm >= 2, "mean")`) serait exact mais matérialise
une couche de plus, soit *plus* de mémoire que `values()` : mesuré à 6
Go contre 4,7 Go sur 1,4e8 cellules. On les estime donc sur un
échantillon régulier borné à `max_cells` cellules — mémoire constante
(~1,2 Go au lieu de 4,7 Go sur ce même raster), écart mesuré de l'ordre
de 0,01 point de pourcentage, et résultat exact dès que le raster tient
dans `max_cells`.
