# Le modele d'inference est construit une seule fois par serie de tuiles : le
# checkpoint fait ~520 Mo et sa relecture, tuile apres tuile, coutait l'essentiel
# du temps d'inference. C'est la cle du cache qui decide de tout.

cle <- function(...) opencanopy:::.cle_modele_inference(...)

test_that("img_size est arrondi au multiple de 32 superieur", {
  # PVTv2 reduit par 32 : deux tuiles de tailles voisines doivent partager le
  # meme modele plutot que d'en faire reconstruire un a chaque fois.
  expect_identical(cle("m.ckpt", "pvtv2", 4L, 200),
                   cle("m.ckpt", "pvtv2", 4L, 224))
  expect_identical(cle("m.ckpt", "pvtv2", 4L, 641),
                   cle("m.ckpt", "pvtv2", 4L, 672))
  # Un multiple exact n'est pas modifie
  expect_identical(cle("m.ckpt", "pvtv2", 4L, 320),
                   cle("m.ckpt", "pvtv2", 4L, 320))
})

test_that("un multiple de 32 different donne une cle differente", {
  expect_false(identical(cle("m.ckpt", "pvtv2", 4L, 320),
                         cle("m.ckpt", "pvtv2", 4L, 640)))
})

test_that("chaque composante de l'identite du modele change la cle", {
  reference <- cle("m.ckpt", "pvtv2", 4L, 320)
  expect_false(identical(reference, cle("autre.ckpt", "pvtv2", 4L, 320)))
  expect_false(identical(reference, cle("m.ckpt", "unet",  4L, 320)))
  expect_false(identical(reference, cle("m.ckpt", "pvtv2", 3L, 320)))
  expect_false(identical(reference, cle("m.ckpt", "pvtv2", 4L, 640)))
})

# --- Decision de rechargement -------------------------------------------------
# reticulate est mocke : ces tests ne demarrent aucun interpreteur Python et ne
# lisent aucun checkpoint.

with_reticulate_mocke <- function(code, py_present = TRUE) {
  appels <- new.env(parent = emptyenv())
  appels$n <- 0L
  testthat::local_mocked_bindings(
    py_eval = function(...) py_present,
    py_run_string = function(...) {
      appels$n <- appels$n + 1L
      invisible(NULL)
    },
    .package = "reticulate"
  )
  force(code)
  appels
}

charger <- function(img_size = 320) {
  suppressMessages(opencanopy:::init_inference_model(
    "checkpoint-inexistant.ckpt", "pvtv2", num_bands = 4L, img_size = img_size))
}

test_that("deux appels identiques ne relisent le checkpoint qu'une fois", {
  cache <- opencanopy:::.cache_modele_inference
  cache$cle <- NULL
  on.exit(cache$cle <- NULL)

  appels <- with_reticulate_mocke({
    premier <- charger()
    second  <- charger()
    expect_true(premier)    # construit
    expect_false(second)    # reutilise
  })
  expect_identical(appels$n, 1L)
})

test_that("un img_size menant a un autre multiple de 32 force la reconstruction", {
  cache <- opencanopy:::.cache_modele_inference
  cache$cle <- NULL
  on.exit(cache$cle <- NULL)

  appels <- with_reticulate_mocke({
    charger(img_size = 320)
    charger(img_size = 640)
  })
  expect_identical(appels$n, 2L)
})

test_that("un interpreteur relance fait recharger malgre le cache R", {
  # py_eval renvoie FALSE : _OC_MODEL n'existe plus cote Python. Le cache R ne
  # doit pas laisser croire que le modele est encore la.
  cache <- opencanopy:::.cache_modele_inference
  cache$cle <- NULL
  on.exit(cache$cle <- NULL)

  appels <- with_reticulate_mocke({
    charger()
    charger()
  }, py_present = FALSE)
  expect_identical(appels$n, 2L)
})

test_that("un chargement en echec ne laisse pas le cache croire au succes", {
  cache <- opencanopy:::.cache_modele_inference
  cache$cle <- NULL
  on.exit(cache$cle <- NULL)

  testthat::local_mocked_bindings(
    py_eval = function(...) TRUE,
    py_run_string = function(...) stop("checkpoint illisible"),
    .package = "reticulate"
  )
  expect_error(charger(), "Erreur chargement du mod")
  # Sans cette remise a NULL, l'appel suivant sauterait le chargement et
  # predict_tile() partirait sur un _OC_MODEL inexistant.
  expect_null(cache$cle)
})
