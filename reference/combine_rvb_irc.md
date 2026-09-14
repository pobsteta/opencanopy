# Combiner les ortho RVB et IRC en image 4 bandes (R, G, B, PIR)

Le modèle Open-Canopy attend 4 canaux : Rouge, Vert, Bleu, PIR

- RVB fournit les 3 premières bandes

- IRC fournit le PIR (bande 1 de l'IRC = Proche Infrarouge)

## Usage

``` r
combine_rvb_irc(rvb, irc)
```

## Arguments

- rvb:

  SpatRaster ortho RVB (3 bandes : Rouge, Vert, Bleu)

- irc:

  SpatRaster ortho IRC (3 bandes : PIR, Rouge, Vert)

## Value

SpatRaster 4 bandes (Rouge, Vert, Bleu, PIR)
