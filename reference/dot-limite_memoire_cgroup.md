# Lire le plafond mémoire du cgroup courant (Linux)

`terra` dimensionne ses décisions « en mémoire vs sur disque » à partir
de `/proc/meminfo`, qui n'est pas cgroup-aware : dans un conteneur ou
sous un `systemd-run --property=MemoryMax=...`, il voit la RAM de la
machine entière et se fait tuer par le cgroup. Cette fonction retrouve
le plafond réel.

## Usage

``` r
.limite_memoire_cgroup(
  racine = "/sys/fs/cgroup",
  proc_cgroup = "/proc/self/cgroup"
)
```

## Arguments

- racine:

  Racine du système de fichiers cgroup (paramétrable pour les tests)

- proc_cgroup:

  Fichier décrivant le cgroup du processus

## Value

Plafond en octets, ou NA si aucun plafond n'est posé

## Details

On remonte toute la hiérarchie du cgroup : la contrainte effective est
le plus petit plafond rencontré entre la racine et le cgroup du
processus.
