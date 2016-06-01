context("TRNG.Engine")

engineClasses <- list(lagfib2plus_19937_64, lagfib2xor_19937_64, lagfib4plus_19937_64, lagfib4xor_19937_64, lcg64, lcg64_shift, mrg2, mrg3, mrg3s, mrg4, mrg5, mrg5s, mt19937, mt19937_64, yarn2, yarn3, yarn3s, yarn4, yarn5, yarn5s)
# engineClasses <- list(lcg64)
# engineClass <- yarn2
# library(testthat)

rdist.test <- function(n, engine) {
  runif.trng(n, engine = engine)
}
SEED <- 117
SAMPLES <- 15


test_that("constructor with no arguments works", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    expect_is(e, as.character(engineClass), info = as.character(engineClass))
  }
})


test_that("str returns a 1-length character", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    s <- e$str()
    expect_is(s, "character", info = as.character(engineClass))
    expect_equal(length(s), 1, info = as.character(engineClass))
  }
})


test_that("seed changes the internal state", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    preSeed <- e$str()
    e$seed(SEED)
    postSeed <- e$str()
    expect_false(preSeed == postSeed, info = as.character(engineClass))
  }
})


test_that("constructor with seed argument works", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    e$seed(SEED)
    f <- engineClass$new(SEED)
    expect_equal(e$str(), f$str(), info = as.character(engineClass))
    expect_equal(rdist.test(SAMPLES, e), rdist.test(SAMPLES, f),
                 info = as.character(engineClass))
  }
})


test_that("constructor with string argument works", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(e$str())
    expect_equal(e$str(), f$str(), info = as.character(engineClass))
    expect_equal(rdist.test(SAMPLES, e), rdist.test(SAMPLES, f),
                 info = as.character(engineClass))
  }
})


test_that("copy detaches the underlying generator", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- e$copy()
    expect_equal(e$str(), f$str(), info = as.character(engineClass))
    expect_equal(rdist.test(SAMPLES, e), rdist.test(SAMPLES, f),
                 info = as.character(engineClass))
  }
})


test_that("state is updated upon draw of random variates", {
  for (engineClass in engineClasses) {
    e <- engineClass$new()
    preDraw <- e$str()
    invisible(rdist.test(SAMPLES, e))
    postDraw <- e$str()
    expect_false(preDraw == postDraw, info = as.character(engineClass))
  }
})


test_that("state correctly persits", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(SEED)
    expect_equal(c(rdist.test(ceiling(SAMPLES/2), e),
                   rdist.test(floor(SAMPLES/2), e)),
                 rdist.test(SAMPLES, f),
                 info = as.character(engineClass))
  }
})


test_that("copy vs. assignment", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- e$copy()
    g <- e
    expect_equal(c(rdist.test(ceiling(SAMPLES/2), e),
                   rdist.test(floor(SAMPLES/2), g)),
                 rdist.test(SAMPLES, f),
                 info = as.character(engineClass))
  }
})


test_that("jump works for parallel engines", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(SEED)
    steps <- 3L
    if (grepl("(lagfib|mt)", engineClass)) {
      expect_error(f$jump(steps), info = as.character(engineClass))
    } else {
      f$jump(steps)
      expect_equal(rdist.test(SAMPLES, e)[-seq_len(steps)],
                   rdist.test(SAMPLES-steps, f),
                   info = as.character(engineClass))
    }
  }
})


test_that("split works for parallel engines", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    f <- engineClass$new(SEED)
    p <- 5L
    s <- 4L
    if (grepl("(lagfib|mt)", engineClass)) {
      expect_error(f$split(p, s), info = as.character(engineClass))
    } else {
      f$split(p, s)
      expect_equal(rdist.test(SAMPLES, e)[seq(4, SAMPLES, 5)],
                   rdist.test(SAMPLES/p, f),
                   info = as.character(engineClass))
    }
  }
})


test_that("jump errors for negative argument values", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    if (!grepl("(lagfib|mt)", engineClass)) {
      expect_error(e$jump(-1L), info = as.character(engineClass))
    }
  }
})


test_that("split errors for out-of-range subsequence indices", {
  for (engineClass in engineClasses) {
    e <- engineClass$new(SEED)
    p <- 5L
    if (!grepl("(lagfib|mt)", engineClass)) {
      expect_error(e$split(p, 0L), info = as.character(engineClass)) # 1-base indexing
      expect_error(e$split(p, p+1), info = as.character(engineClass))
      expect_error(e$split(p, -1L), info = as.character(engineClass))
      expect_error(e$split(-1L, 1L), info = as.character(engineClass))
    }
  }
})

