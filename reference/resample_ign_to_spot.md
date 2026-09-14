# Rééchantillonner une ortho IGN de 0.2m vers 1.5m

Pour utiliser les modèles Open-Canopy (entraînés sur SPOT 1.5m), il faut
rééchantillonner les images IGN à la même résolution.

Les modèles Open-Canopy sont entraînés sur SPOT à 1.5m. Pour les
utiliser sur les ortho IGN, on agrège les pixels. Facteur d'agrégation :
1.5 / 0.2 = 7.5 → arrondi à 8

## Usage

``` r
resample_ign_to_spot(ign_raster, target_res = RES_SPOT, method = "mean")

resample_ign_to_spot(ign_raster, target_res = RES_SPOT, method = "mean")
```

## Arguments

- ign_raster:

  SpatRaster IGN à 0.20m

- target_res:

  Résolution cible en mètres

- method:

  Méthode d'agrégation ("mean", "median")

## Value

SpatRaster rééchantillonné

SpatRaster à la résolution cible
