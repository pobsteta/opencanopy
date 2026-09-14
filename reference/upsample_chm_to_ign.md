# Suréchantillonner un CHM prédit (1.5m) vers la résolution IGN (0.20m)

Suréchantillonner un CHM prédit (1.5m) vers la résolution IGN (0.20m)

## Usage

``` r
upsample_chm_to_ign(chm_predicted, target_res = RES_IGN, method = "bilinear")
```

## Arguments

- chm_predicted:

  SpatRaster CHM prédit à 1.5m

- target_res:

  Résolution cible (0.2m)

- method:

  Méthode d'interpolation

## Value

SpatRaster à 0.20m
