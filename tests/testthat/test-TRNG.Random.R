context("TRNG.Random")


KIND <- "yarn4"
KIND_CLASS <- getFromNamespace(KIND, "rTRNG")
KIND_NONPAR <- "lagfib2plus_19937_64"
SEED <- 117L
SAMPLES <- 15L


test_that("TRNGkind sets an engine of the specified kind", {
  TRNGkind(KIND)
  expect_identical(TRNGkind(), KIND)
})


test_that("TRNGkind works with the default kind", {
  TRNGkind("default")
  expect_identical(TRNGkind(), defaultKind())
})


test_that("TRNGkind errors for invalid kind", {
  expect_error(TRNGkind("!DUMMY!"), "invalid")
})


test_that("TRNG.Random.seed returns the kind and internal state of the current engine", {
  TRNGkind(KIND)
  TRNGseed(SEED)
  e <- KIND_CLASS$new(SEED)
  engspec <- TRNG.Random.seed()
  expect_identical(length(engspec), 2L)
  expect_identical(engspec, c(KIND, e$toString()))
})


test_that("TRNG.Random.seed restores the current engine with correct kind and state", {
  TRNGkind(KIND)
  TRNGseed(SEED)
  engspec <- TRNG.Random.seed()
  x1 <- runif_trng(SAMPLES)
  TRNGkind("default")
  expect_false(identical(
    TRNG.Random.seed(),
    engspec
  ))
  y <- runif_trng(SAMPLES)
  expect_false(identical(x1, y))
  TRNG.Random.seed(engspec)
  expect_identical(
    TRNG.Random.seed(),
    engspec
  )
  x2 <- runif_trng(SAMPLES)
  expect_identical(x1, x2)
})


test_that("TRNG.Random.seed errors for invalid engine specifications", {
  expect_error(TRNG.Random.seed(c("!DUMMY!", "!dummy!")))
  expect_error(TRNG.Random.seed(c(KIND, "!dummy!")), "failed to restore")
})


test_that("TRNGseed yields the same random variates as the corresponding engine", {
  TRNGkind(KIND)
  TRNGseed(SEED)
  e <- KIND_CLASS$new(SEED)
  expect_identical(
    runif_trng(SAMPLES),
    runif_trng(SAMPLES, engine = e)
  )
})


test_that("TRNGjump yields the same random variates as the corresponding engine", {
  steps <- 3L
  TRNGkind(KIND)
  TRNGseed(SEED)
  TRNGjump(steps)
  e <- KIND_CLASS$new(SEED)
  e$jump(steps)
  expect_identical(
    runif_trng(SAMPLES),
    runif_trng(SAMPLES, engine = e)
  )
})


test_that("TRNGsplit yields the same random variates as the corresponding engine", {
  p <- 5L
  s <- 4L
  TRNGkind(KIND)
  TRNGseed(SEED)
  TRNGsplit(p, s)
  e <- KIND_CLASS$new(SEED)
  e$split(p, s)
  expect_identical(
    runif_trng(SAMPLES),
    runif_trng(SAMPLES, engine = e)
  )
})


test_that("TRNGjump errors for non-parallel engines", {
  steps <- 3L
  TRNGkind(KIND_NONPAR)
  TRNGseed(SEED)
  expect_error(TRNGjump(steps), "jump.*not.*valid")
})


test_that("TRNGsplit errors for non-parallel engines", {
  p <- 5L
  s <- 4L
  TRNGkind(KIND_NONPAR)
  TRNGseed(SEED)
  expect_error(TRNGsplit(p, s), "split.*not.*valid")
})


test_that("TRNGjump errors for negative argument values", {
  TRNGkind(KIND)
  TRNGseed(SEED)
  expect_error(TRNGjump(-1L), "negative")
})


test_that("TRNGsplit errors for out-of-range subsequence indices", {
  TRNGkind(KIND)
  TRNGseed(SEED)
  p <- 5L
  expect_error(TRNGsplit(p, 0L), class = expected_invalid_argument_class) # 1-base indexing
  expect_error(TRNGsplit(p, p + 1L), class = expected_invalid_argument_class)
  expect_error(TRNGsplit(p, -1L), "negative")
  expect_error(TRNGsplit(-1L, 1L), "negative")
})
