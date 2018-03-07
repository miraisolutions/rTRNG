context("TRNG.Engine")


engineClasses <- list(
  lagfib2plus_19937_64,
  lagfib2xor_19937_64,
  lagfib4plus_19937_64,
  lagfib4xor_19937_64,
  lcg64,
  lcg64_shift,
  mrg2,
  mrg3,
  mrg3s,
  mrg4,
  mrg5,
  mrg5s,
  mt19937,
  mt19937_64,
  yarn2,
  yarn3,
  yarn3s,
  yarn4, yarn5,
  yarn5s
)
# engineClasses <- list(lcg64)
# engineClass <- yarn2
# library(testthat)
SEED <- 117L
SAMPLES <- 15L
rdist_test <- function(n, engine) {
  runif_trng(n, engine = engine)
}
.name <- function(engineClass) {
  sub("Rcpp_", "", as.character(engineClass))
}


test_that("constructor with no arguments works", {
  for (engineClass in engineClasses) {
    expect_error(e <- engineClass$new(), NA, info = .name(engineClass))
    expect_is(e, as.character(engineClass), info = .name(engineClass))
    e <- NULL
  }
})


test_that("$name and $kind return the engine name", {
  for (engineClass in engineClasses) {
    engineName <- .name(engineClass)
    e <- engineClass$new()
    expect_identical(e$name(), e$kind(), info = .name(engineClass))
    expect_is(e$name(), "character", info = .name(engineClass))
    expect_identical(length(e$name()), 1L, info = .name(engineClass))
    expect_identical(e$name(), !!engineName, info = .name(engineClass))
    e <- NULL
  }
})


test_that("$toString returns a 1-length character", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    s <- e$toString()
    expect_is(s, "character", info = .name(engineClass))
    expect_identical(length(s), 1L, info = .name(engineClass))
    e <- NULL
  }
})


test_that("$seed changes the internal state", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    preSeed <- e$toString()
    e$seed(SEED)
    postSeed <- e$toString()
    expect_false(preSeed == postSeed, info = .name(engineClass))
    e <- NULL
  }
})


test_that("constructor with seed argument works", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    e$seed(SEED)
    f <- engineClass$new(SEED)
    expect_identical(e$toString(), f$toString(), info = .name(engineClass))
    expect_identical(rdist_test(SAMPLES, e), rdist_test(SAMPLES, f),
                     info = .name(engineClass))
    e <- f <- NULL
  }
})


test_that("constructor with string argument works", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(e$toString())
    expect_identical(e$toString(), f$toString(), info = .name(engineClass))
    expect_identical(rdist_test(SAMPLES, e), rdist_test(SAMPLES, f),
                     info = .name(engineClass))
    e <- f <- NULL
  }
})


test_that("constructor with wrong string argument errors", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(e$toString())
    expect_error(engineClass$new("!dummy!"), "failed to restore",
                 info = .name(engineClass))
    e <- f <- NULL
  }
})


test_that("the state is updated upon draw of random variates", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    preDraw <- e$toString()
    invisible(rdist_test(SAMPLES, e))
    postDraw <- e$toString()
    expect_false(preDraw == postDraw, info = .name(engineClass))
    e <- NULL
  }
})


test_that("the state correctly persists for future draws", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(SEED)
    expect_identical(c(rdist_test(ceiling(SAMPLES/2), e),
                       rdist_test(floor(SAMPLES/2), e)),
                     rdist_test(SAMPLES, f),
                     info = .name(engineClass))
    e <- f <- NULL
  }
})


test_that("$copy works and detaches the new engine from the original one", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- e$copy()
    expect_identical(e$toString(), f$toString(), info = .name(engineClass))
    expect_identical(rdist_test(SAMPLES, e), rdist_test(SAMPLES, f),
                     info = .name(engineClass))
    e <- f <- NULL
  }
})


test_that("assignment is by reference to the same underlying engine", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    g <- e
    f <- e$copy()
    expect_identical(c(rdist_test(ceiling(SAMPLES/2), e),
                       rdist_test(floor(SAMPLES/2), g)),
                     rdist_test(SAMPLES, f),
                     info = .name(engineClass))
    e <- f <- g <- NULL
  }
})


test_that("$jump works for parallel engines", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(SEED)
    steps <- 3L
    if (grepl("(lagfib|mt)", engineClass)) {
      expect_error(f$jump(steps), "jump.*not.*valid",
                   info = .name(engineClass))
    } else {
      f$jump(steps)
      expect_identical(rdist_test(SAMPLES, e)[-seq_len(steps)],
                       rdist_test(SAMPLES-steps, f),
                       info = .name(engineClass))
    }
    e <- f <- NULL
  }
})


test_that("$split works for parallel engines", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(SEED)
    p <- 5L
    s <- 4L
    if (grepl("(lagfib|mt)", engineClass)) {
      expect_error(f$split(p, s), "split.*not.*valid",
                   info = .name(engineClass))
    } else {
      f$split(p, s)
      expect_identical(rdist_test(SAMPLES, e)[seq(4, SAMPLES, 5)],
                       rdist_test(SAMPLES/p, f),
                       info = .name(engineClass))
    }
    e <- f <- NULL
  }
})


test_that("$jump errors for negative argument values", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    if (!grepl("(lagfib|mt)", engineClass)) {
      expect_error(e$jump(-1L), "negative",
                   info = .name(engineClass))
    }
    e <- NULL
  }
})


test_that("$split errors for out-of-range subsequence indices", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    p <- 5L
    if (!grepl("(lagfib|mt)", engineClass)) {
      expect_error(e$split(p, 0L), "invalid",
                   info = .name(engineClass)) # 1-base indexing
      expect_error(e$split(p, p+1L), "invalid",
                   info = .name(engineClass))
      expect_error(e$split(p, -1L), "negative",
                   info = .name(engineClass))
      expect_error(e$split(-1L, 1L), "negative",
                   info = .name(engineClass))
    }
    e <- NULL
  }
})


test_that("$.Random.seed returns the engine name and internal state", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    expect_identical(e$.Random.seed(),
                     c(e$kind(), e$toString()),
                     info = .name(engineClass))
    e <- NULL
  }
})
