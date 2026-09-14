# Cloner le dataset complet via git (nécessite git-lfs)

Cloner le dataset complet via git (nécessite git-lfs)

## Usage

``` r
hf_git_clone(
  dest_dir = file.path(DATA_DIR_HF, "Open-Canopy"),
  token = HF_TOKEN
)
```

## Arguments

- dest_dir:

  Répertoire de destination du clone

- token:

  Jeton Hugging Face, inséré dans l'URL pour un dépôt privé

## Value

Chemin du dépôt cloné
