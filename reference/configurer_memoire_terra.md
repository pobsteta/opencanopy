# Aligner le budget mémoire de terra sur le plafond du cgroup

Sans cela, `terra` conclut qu'un calcul tient en RAM (il voit la mémoire
de la machine) alors que le cgroup le tue bien avant : c'est ce qui a
produit un SIGKILL au calcul des indices, après une heure, sur un AOI de
233 millions de cellules. Avec `memmax`, `terra` bascule seul sur
disque.

## Usage

``` r
configurer_memoire_terra(fraction = TERRA_MEM_FRACTION, ...)
```

## Arguments

- fraction:

  Part du plafond laissée à terra

- ...:

  Passé à
  [`.limite_memoire_cgroup()`](https://pobsteta.github.io/opencanopy/reference/dot-limite_memoire_cgroup.md)
  (racine du cgroup, pour les tests)

## Value

Le `memmax` appliqué en Go, ou NA si aucun plafond détecté
