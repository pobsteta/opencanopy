# Découper un raster en tuiles pour l'inférence

Toutes les tuiles ont **exactement les mêmes dimensions en pixels** : la
dernière colonne / ligne est décalée vers l'intérieur au lieu d'être
rognée. Deux raisons, à l'origine de l'effet de bord observé sur la
mosaïque :

- le modèle PVTv2 est reconstruit avec un `img_size` déduit de la taille
  de la tuile ; des tuiles de tailles différentes donnaient des
  géométries de tête de segmentation différentes, donc des prédictions
  incohérentes entre le cœur et la bordure de l'AOI ;

- les tuiles rognées étaient complétées côté Python par des **zéros**,
  c'est-à-dire une bande noire artificielle que le modèle voit comme du
  sol nu.

## Usage

``` r
make_inference_tiles(r, tile_size = 1000, overlap = 200)
```

## Arguments

- r:

  SpatRaster (déjà à 1.5m)

- tile_size:

  Taille des tuiles en mètres

- overlap:

  Chevauchement en mètres

## Value

Liste nommée de SpatRasters, portant les attributs `margin_x` et
`margin_y` (largeur du fondu, en pixels)

## Details

Le chevauchement (200 m par défaut, ~133 px à 1.5 m) alimente le fondu
pondéré de
[`mosaiquer_predictions()`](https://pobsteta.github.io/opencanopy/reference/mosaiquer_predictions.md).
