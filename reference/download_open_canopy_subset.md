# Télécharger un sous-ensemble du dataset Open-Canopy

Télécharger un sous-ensemble du dataset Open-Canopy

## Usage

``` r
download_open_canopy_subset(
  split = "test",
  n_tiles = 5,
  data_type = "all",
  dest_dir = DATA_DIR_HF,
  token = HF_TOKEN
)
```

## Arguments

- split:

  "train", "val", ou "test"

- n_tiles:

  Nombre de tuiles

- data_type:

  "images" (SPOT), "lidar" (CHM), "lidar_v2", ou "all"

- dest_dir:

  Répertoire de destination

- token:

  Token Hugging Face
