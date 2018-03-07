## generate 10 random variates using the current TRNG engine
rbinom_trng(10, size = 1L, prob = 0.5)

## use a TRNG engine reference class object
r <- yarn2$new()
rbinom_trng(10, size = 1L, prob = 0.5, engine = r)

## generate 100k random variates in parallel, with 2 threads and 100 grain size
TRNGseed(117)
RcppParallel::setThreadOptions(numThreads = 2L)
x_parallel <- rbinom_trng(100e3, size = 1L, prob = 0.5, parallelGrain = 100L)
TRNGseed(117)
x_serial <- rbinom_trng(100e3, size = 1L, prob = 0.5)
identical(x_serial, x_parallel)
