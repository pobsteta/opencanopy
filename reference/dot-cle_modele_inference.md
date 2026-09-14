# Clé d'identité du modèle d'inférence

Deux appels qui produisent la même clé réutilisent le modèle déjà
construit ; toute différence force une reconstruction. `img_size` est
arrondi au multiple de 32 supérieur, comme l'exige la réduction ×32 du
PVTv2 : deux tuiles de tailles voisines partagent donc le même modèle.

## Usage

``` r
.cle_modele_inference(model_path, model_name, num_bands, img_size)
```

## Arguments

- model_path:

  Chemin du checkpoint, déjà résolu

- model_name:

  "unet" ou "pvtv2"

- num_bands:

  Nombre de canaux d'entrée

- img_size:

  Taille de référence, arrondie au multiple de 32 supérieur

## Value

Chaîne de caractères identifiant le modèle
