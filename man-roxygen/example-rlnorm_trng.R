## generate 10 random variates using the current TRNG engine
rlnorm_trng(10, meanlog = 0, sdlog = 1)

## use a TRNG engine reference class object
r <- yarn2$new()
rlnorm_trng(10, meanlog = 0, sdlog = 1, engine = r)

## generate 100k random variates in parallel, with 2 threads and 100 grain size
TRNGseed(117)
RcppParallel::setThreadOptions(numThreads = 2L)
x_parallel <- rlnorm_trng(100e3, meanlog = 0, sdlog = 1, parallelGrain = 100L)
TRNGseed(117)
x_serial <- rlnorm_trng(100e3, meanlog = 0, sdlog = 1)
identical(x_serial, x_parallel)
