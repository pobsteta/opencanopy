# Différence de canopée entre deux dates

Différence de canopée entre deux dates

## Usage

``` r
compute_canopy_change(chm_t1, chm_t2)
```

## Arguments

- chm_t1:

  SpatRaster du CHM à la première date

- chm_t2:

  SpatRaster du CHM à la seconde date, rééchantillonné sur `chm_t1` si
  les géométries diffèrent

## Value

SpatRaster de la variation de hauteur, en mètres (positif = croissance)
