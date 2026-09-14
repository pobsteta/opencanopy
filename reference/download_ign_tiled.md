# Télécharger une ortho IGN complète pour une emprise (avec tuilage automatique)

Découpe en sous-tuiles si l'emprise dépasse la limite WMS (4096 px)

## Usage

``` r
download_ign_tiled(
  bbox,
  layer,
  res_m = RES_IGN,
  output_dir,
  prefix = "ortho",
  progress_callback = NULL
)
```

## Arguments

- bbox:

  c(xmin, ymin, xmax, ymax) en Lambert-93

- layer:

  Couche WMS (RVB ou IRC)

- res_m:

  Résolution en mètres

- output_dir:

  Répertoire de sortie

- prefix:

  Préfixe pour les fichiers

- progress_callback:

  Fonction appelée à chaque étape avec une liste décrivant l'avancement
  ; `NULL` pour ne rien émettre

## Value

SpatRaster mosaïqué
