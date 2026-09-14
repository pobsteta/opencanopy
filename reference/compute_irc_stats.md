# Statistiques spectrales d'une ortho IRC IGN

Statistiques spectrales d'une ortho IRC IGN

## Usage

``` r
compute_irc_stats(irc_raster, max_cells = 1e+06)
```

## Arguments

- irc_raster:

  SpatRaster IRC IGN

- max_cells:

  Taille max de l'échantillon régulier (médiane et parts)

## Value

data.frame avec statistiques par bande + NDVI
