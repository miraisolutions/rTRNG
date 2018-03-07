## generate 10 random variates using the current TRNG engine
rpois_trng(10, lambda = 4)

## use a TRNG engine reference class object
r <- yarn2$new()
rpois_trng(10, lambda = 4, engine = r)

## generate 100k random variates in parallel, with 2 threads and 100 grain size
TRNGseed(117)
RcppParallel::setThreadOptions(numThreads = 2L)
x_parallel <- rpois_trng(100e3, lambda = 4, parallelGrain = 100L)
TRNGseed(117)
x_serial <- rpois_trng(100e3, lambda = 4)
identical(x_serial, x_parallel)
