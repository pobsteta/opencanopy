# Télécharger un fichier depuis Hugging Face

Télécharger un fichier depuis Hugging Face

## Usage

``` r
hf_download_file(repo_id, filename, dest_dir, token = "", overwrite = FALSE)
```

## Arguments

- repo_id:

  Identifiant du dépôt

- filename:

  Chemin du fichier dans le dépôt

- dest_dir:

  Répertoire de destination local

- token:

  Token Hugging Face (optionnel)

- overwrite:

  Écraser si le fichier existe déjà

## Value

Chemin local du fichier téléchargé
