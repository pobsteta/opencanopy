# Rattacher le CRS d'un raster à l'autorité EPSG:2154

Les GeoTIFF renvoyés par le WMS IGN portent un WKT dont le *nom* est
"EPSG:2154" mais qui n'a pas de bloc d'autorité `ID["EPSG",2154]` : le
datum y est "unnamed" et l'ellipsoïde "unretrievable - using WGS84".
Conséquence, `sf::st_crs(x)$epsg` y lit `NA`, et tout aval qui écrit un
GeoPackage depuis ces rasters (segmentation de houppiers, exports
vectoriels) embarque un CRS non rattachable. On le re-tamponne à
l'écriture, une fois pour tous les consommateurs, plutôt que de laisser
chacun le rattraper à la lecture.

## Usage

``` r
ancrer_crs_l93(r)
```

## Arguments

- r:

  SpatRaster

## Value

le SpatRaster, CRS rattaché à EPSG:2154 si l'autorité manquait

## Details

Ne touche que les rasters dépourvus de code d'autorité : un raster
correctement identifié dans un autre CRS est laissé tel quel (ce serait
un bug ailleurs, pas quelque chose à masquer ici).
