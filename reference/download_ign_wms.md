# Télécharger une ortho IGN via WMS (pour une emprise donnée)

Télécharger une ortho IGN via WMS (pour une emprise donnée)

## Usage

``` r
download_ign_wms(
  bbox,
  layer = IGN_LAYER_ORTHO,
  res_m = RES_IGN,
  dest_file = NULL
)
```

## Arguments

- bbox:

  Emprise c(xmin, ymin, xmax, ymax) en Lambert-93 (EPSG:2154)

- layer:

  Couche WMS (RVB ou IRC)

- res_m:

  Résolution en mètres (0.2 par défaut)

- dest_file:

  Chemin du fichier de sortie

## Value

Chemin local du fichier téléchargé
