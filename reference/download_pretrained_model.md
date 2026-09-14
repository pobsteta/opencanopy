# Télécharger les modèles pré-entraînés depuis Hugging Face

Pour l'étape téléchargement uniquement, utilise le package R hfhub (sans
passer par le sous-module Python huggingface_hub). Fallback sur
huggingface_hub Python si hfhub n'est pas installé. L'inférence qui suit
nécessite toujours Python (torch, rasterio, smp, timm).

## Usage

``` r
download_pretrained_model(model_name = "pvtv2")
```

## Arguments

- model_name:

  "unet" ou "pvtv2"

## Value

Chemin local du modèle
