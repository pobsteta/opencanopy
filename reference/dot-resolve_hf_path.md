# Résoudre le chemin réel d'un fichier HuggingFace cache

Sur Windows, le cache HF utilise des symlinks (snapshots/ → blobs/) qui
ne fonctionnent pas sans le mode développeur. Cette fonction résout le
chemin réel ou copie le fichier blob si nécessaire.

## Usage

``` r
.resolve_hf_path(path)
```

## Arguments

- path:

  Chemin retourné par hub_download

## Value

Chemin réel accessible
