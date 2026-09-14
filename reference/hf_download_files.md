# Télécharger un ensemble de fichiers depuis Hugging Face

Télécharger un ensemble de fichiers depuis Hugging Face

## Usage

``` r
hf_download_files(repo_id, file_list, dest_dir, token = "", overwrite = FALSE)
```

## Arguments

- repo_id:

  Identifiant du dépôt Hugging Face (ex. "AI4Forest/Open-Canopy")

- file_list:

  Vecteur des chemins de fichiers à télécharger dans le dépôt

- dest_dir:

  Répertoire de destination local

- token:

  Jeton Hugging Face ; chaîne vide pour un dépôt public

- overwrite:

  Retélécharger un fichier déjà présent localement

## Value

Vecteur des chemins locaux téléchargés
