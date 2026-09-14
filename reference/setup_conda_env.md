# Configurer reticulate pour utiliser l'environnement conda open_canopy

Vérifie la présence de **tous** les modules Python requis par le
pipeline Open-Canopy (torch + inférence ET le stack géospatial geopandas
/ shapely / pyproj / rioxarray / xarray). Avec `install_missing = TRUE`,
installe les manquants via pip dans l'environnement.

## Usage

``` r
setup_conda_env(envname = CONDA_ENV, install_missing = FALSE)
```

## Arguments

- envname:

  Nom de l'environnement conda.

- install_missing:

  Si `TRUE`, installe les modules manquants via pip. Par défaut `FALSE`
  : signale seulement, avec la commande à lancer.

## Value

(Invisible) le vecteur des noms d'import des modules manquants.
