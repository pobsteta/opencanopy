# Trouver le nom du fichier checkpoint dans le dataset HF via l'API

Interroge l'API Hugging Face pour découvrir les fichiers checkpoint
disponibles dans le répertoire pretrained_models/ du dataset.

Interroge l'API Hugging Face pour découvrir les fichiers checkpoint
disponibles dans le répertoire pretrained_models/ du dataset.

## Usage

``` r
find_checkpoint_name(repo_id = "AI4Forest/Open-Canopy", model_name = "pvtv2")

find_checkpoint_name(repo_id = "AI4Forest/Open-Canopy", model_name = "pvtv2")
```

## Arguments

- repo_id:

  Identifiant du dépôt HF (ex: "AI4Forest/Open-Canopy")

- model_name:

  "unet" ou "pvtv2" pour filtrer

## Value

Chemin du fichier checkpoint dans le dépôt, ou NULL

Chemin du fichier checkpoint dans le dépôt, ou NULL
