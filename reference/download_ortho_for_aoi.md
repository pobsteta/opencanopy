# Télécharger les ortho RVB et IRC pour une AOI

Télécharger les ortho RVB et IRC pour une AOI

## Usage

``` r
download_ortho_for_aoi(
  aoi,
  output_dir,
  res_m = RES_IGN,
  millesime_ortho = MILLESIME_ORTHO,
  millesime_irc = MILLESIME_IRC,
  progress_callback = NULL
)
```

## Arguments

- aoi:

  sf object (AOI en Lambert-93)

- output_dir:

  Répertoire de sortie

- res_m:

  Résolution en mètres

- millesime_ortho:

  Millésime ortho RVB (NULL = plus récent)

- millesime_irc:

  Millésime IRC (NULL = plus récent)

- progress_callback:

  Fonction appelée à chaque étape avec une liste décrivant l'avancement
  ; `NULL` pour ne rien émettre

## Value

Liste avec rvb, irc (SpatRaster) et millésimes utilisés
