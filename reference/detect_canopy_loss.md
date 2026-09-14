# Détection de perte de canopée

Détection de perte de canopée

## Usage

``` r
detect_canopy_loss(chm_t1, chm_t2, threshold = -5)
```

## Arguments

- chm_t1:

  SpatRaster du CHM à la première date

- chm_t2:

  SpatRaster du CHM à la seconde date, rééchantillonné sur `chm_t1` si
  les géométries diffèrent

- threshold:

  Seuil de variation, en mètres ; négatif, une perte étant une
  diminution de hauteur

## Value

SpatRaster booléen, TRUE là où la perte dépasse le seuil
