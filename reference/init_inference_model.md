# Charger le checkpoint et construire le modèle une seule fois

Le modèle est laissé dans l'environnement Python persistant de
`reticulate` (`_OC_MODEL`). Les appels suivants avec les mêmes
paramètres ne rechargent rien : c'est ce qui évite de relire 520 Mo de
checkpoint et de reconstruire PVTv2-b3 à chaque tuile.

## Usage

``` r
init_inference_model(
  model_path,
  model_name = "pvtv2",
  open_canopy_src = NULL,
  num_bands = 4L,
  img_size = 640L
)
```

## Arguments

- model_path:

  Chemin du modèle .ckpt (PyTorch Lightning)

- model_name:

  "unet" ou "pvtv2"

- open_canopy_src:

  Chemin vers le code source Open-Canopy (pour PVTv2)

- num_bands:

  Nombre de canaux d'entrée (4 : R, G, B, PIR)

- img_size:

  Taille de référence du modèle (multiple de 32)

## Value

TRUE si le modèle a été (re)construit, FALSE s'il était déjà chargé
