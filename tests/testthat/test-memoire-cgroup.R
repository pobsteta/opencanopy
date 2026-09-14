# Plafond memoire : terra n'est pas cgroup-aware et se faisait tuer par le
# cgroup au calcul des indices. On verifie la lecture du plafond reel.

skip_si_pas_unix <- function() {
  testthat::skip_if_not(.Platform$OS.type == "unix",
                        "hierarchie cgroup specifique a Linux")
}

# Construit une fausse hierarchie cgroups v2 :
#   <racine>/memory.max                       = plafond racine
#   <racine>/<chemin>/memory.max              = plafond feuille
faire_cgroup_v2 <- function(chemin = "app.slice/job.scope",
                            plafonds = c(racine = "max", feuille = "max")) {
  racine <- file.path(tempdir(), paste0("cgroup-", basename(tempfile())))
  dir.create(file.path(racine, chemin), recursive = TRUE)
  writeLines(plafonds[["racine"]], file.path(racine, "memory.max"))
  writeLines(plafonds[["feuille"]], file.path(racine, chemin, "memory.max"))

  proc <- tempfile()
  writeLines(paste0("0::/", chemin), proc)
  list(racine = racine, proc = proc)
}

lire <- function(fx) {
  opencanopy:::.limite_memoire_cgroup(racine = fx$racine,
                                      proc_cgroup = fx$proc)
}

test_that("aucun plafond pose renvoie NA", {
  skip_si_pas_unix()
  fx <- faire_cgroup_v2()
  on.exit(unlink(c(fx$racine, fx$proc), recursive = TRUE))
  expect_true(is.na(lire(fx)))
})

test_that("le plafond du cgroup feuille est lu", {
  skip_si_pas_unix()
  douze_go <- 12 * 1024^3
  fx <- faire_cgroup_v2(plafonds = c(racine = "max",
                                     feuille = format(douze_go, scientific = FALSE)))
  on.exit(unlink(c(fx$racine, fx$proc), recursive = TRUE))
  expect_equal(lire(fx), douze_go)
})

test_that("le plafond retenu est le plus contraignant de la hierarchie", {
  skip_si_pas_unix()
  fx <- faire_cgroup_v2(plafonds = c(
    racine  = format(8 * 1024^3, scientific = FALSE),
    feuille = format(12 * 1024^3, scientific = FALSE)))
  on.exit(unlink(c(fx$racine, fx$proc), recursive = TRUE))
  # Le parent plafonne a 8 Go : le cgroup enfant ne peut pas depasser ca.
  expect_equal(lire(fx), 8 * 1024^3)
})

test_that("la valeur sentinelle cgroups v1 (~2^63) n'est pas prise pour un plafond", {
  skip_si_pas_unix()
  fx <- faire_cgroup_v2(plafonds = c(racine = "max",
                                     feuille = "9223372036854771712"))
  on.exit(unlink(c(fx$racine, fx$proc), recursive = TRUE))
  expect_true(is.na(lire(fx)))
})

test_that("configurer_memoire_terra applique une fraction du plafond", {
  skip_si_pas_unix()
  fx <- faire_cgroup_v2(plafonds = c(racine = "max",
                                     feuille = format(12 * 1024^3, scientific = FALSE)))
  memmax0 <- terra::terraOptions(print = FALSE)$memmax
  on.exit({
    unlink(c(fx$racine, fx$proc), recursive = TRUE)
    terra::terraOptions(memmax = memmax0)
  })

  applique <- suppressMessages(opencanopy:::configurer_memoire_terra(
    fraction = 0.5, racine = fx$racine, proc_cgroup = fx$proc))
  # 12 Go de plafond, moitie pour terra
  expect_equal(as.numeric(applique), 6)
  expect_equal(terra::terraOptions(print = FALSE)$memmax, 6)
})
