# Télécharger le code source Open-Canopy

Clone le dépôt GitHub Open-Canopy dans un dossier cache local. Réutilise
le clone existant si déjà présent.

## Usage

``` r
download_open_canopy_src(dest = NULL, force = FALSE)
```

## Arguments

- dest:

  Dossier de destination (NULL = cache utilisateur)

- force:

  Forcer le re-téléchargement même si déjà présent

## Value

Chemin vers le dossier Open-Canopy cloné, ou NULL en cas d'échec
