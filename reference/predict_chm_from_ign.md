# Pipeline complet : ortho IGN → prédiction CHM

Pipeline complet : ortho IGN → prédiction CHM

## Usage

``` r
predict_chm_from_ign(ign_path, model_path, ign_type = "rvb")
```

## Arguments

- ign_path:

  Chemin de l'ortho IGN (.jp2 ou .tif)

- model_path:

  Chemin du modèle pré-entraîné

- ign_type:

  "rvb" ou "irc"

## Value

SpatRaster des prédictions mosaïquées
