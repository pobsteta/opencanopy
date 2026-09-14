# Exécuter l'inférence sur une tuile

Supporte les deux architectures Open-Canopy :

- UNet (SMP, ResNet34) : reconstruction directe via
  segmentation_models_pytorch

- PVTv2 (timm, pvt_v2_b3) : module embarqué ou code source Open-Canopy

## Usage

``` r
predict_tile(
  tile,
  model_path,
  model_name = "pvtv2",
  open_canopy_src = NULL,
  img_size = NULL
)
```

## Arguments

- tile:

  SpatRaster (4 bandes : R, G, B, PIR à 1.5m)

- model_path:

  Chemin du modèle .ckpt (PyTorch Lightning)

- model_name:

  "unet" ou "pvtv2" pour la reconstruction

- open_canopy_src:

  Chemin vers le code source Open-Canopy (pour PVTv2)

- img_size:

  Taille de référence du modèle (NULL = déduite de la tuile).
  [`run_inference()`](https://pobsteta.github.io/opencanopy/reference/run_inference.md)
  passe la même valeur pour toutes les tuiles afin que le modèle ne soit
  construit qu'une fois.

## Value

SpatRaster CHM prédit (1 bande, en mètres)

## Details

Le modèle est chargé par
[`init_inference_model()`](https://pobsteta.github.io/opencanopy/reference/init_inference_model.md)
au premier appel puis réutilisé : cette fonction ne fait plus que lire
le raster, la passe avant et l'écriture.
