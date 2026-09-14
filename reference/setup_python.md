# Configurer l'environnement Python

Vérifie que les modules Python nécessaires sont disponibles. Python
(torch, rasterio, segmentation_models_pytorch, timm, numpy) est TOUJOURS
requis pour l'inférence — c'est là que tourne le modèle PVTv2/UNet. Le
package R `hfhub` remplace seulement le sous-module Python
`huggingface_hub` pour l'étape de téléchargement du checkpoint, ce qui
fait une dépendance Python en moins mais ne dispense jamais d'une
installation Python complète.

## Usage

``` r
setup_python()
```
