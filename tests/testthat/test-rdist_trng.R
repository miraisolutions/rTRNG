KIND <- "yarn4"
KIND_CLASS <- getFromNamespace(KIND, "rTRNG")
SEED <- 117L
SAMPLES <- 15L
SAMPLES_PAR <- 1000L


test_rdist <- function(rdist, ...) {

  rdist_trng <- sprintf("%s_trng", rdist)
  context(rdist_trng)
  rdist_fun <- getFromNamespace(rdist_trng, "rTRNG")

  test_that(paste(rdist_trng, "returns the correct number of samples"), {
    TRNGkind(KIND)
    TRNGseed(SEED)
    expect_identical(
      length(rdist_fun(SAMPLES, ...)),
      SAMPLES
    )
  })

  test_that(paste(rdist_trng, "works with explicit 'engine' argument"), {
    TRNGkind(KIND)
    TRNGseed(SEED)
    e <- KIND_CLASS$new(SEED)
    expect_identical(
      rdist_fun(SAMPLES, ...),
      rdist_fun(SAMPLES, ..., engine = e)
    )
  })

  test_that(paste(rdist_trng, "parallel genration via 'parallelGrain' works"), {
    # CRAN policies: If running a package uses multiple threads/cores it must
    # never use more than two simultaneously
    RcppParallel::setThreadOptions(numThreads = 2)
    TRNGkind(KIND)
    TRNGseed(SEED)
    x_serial <- rdist_fun(SAMPLES_PAR, ...)
    TRNGseed(SEED)
    x_parallel <- rdist_fun(SAMPLES_PAR, ..., parallelGrain = 50L)
    expect_identical(
      x_serial, x_parallel,
      info = "TRNG.Random current engine"
    )
    e <- KIND_CLASS$new(SEED)
    x_serial <- rdist_fun(SAMPLES_PAR, ..., engine = e)
    e$seed(SEED)
    x_parallel <- rdist_fun(SAMPLES_PAR, ..., engine = e, parallelGrain = 50L)
    expect_identical(
      x_serial, x_parallel,
      info = "explicit engine"
    )
  })

}


test_rdist("runif", min = 0, max = 1)
test_rdist("rnorm", mean = 0, sd = 1)
test_rdist("rlnorm", meanlog = 0, sdlog = 1)
test_rdist("rbinom", size = 1L, prob = 0.5)
test_rdist("rpois", lambda = 4)
