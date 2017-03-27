#' @template template-rdist
#' @templateVar distTitle Normal
#' @templateVar distDesc normal
#' @templateVar rdist rnorm
#' @templateVar n n
#' @templateVar distparam mean,sd
#' @export
rnorm.trng <- function(n, mean = 0.0, sd = 1.0, engine = NULL, parallelGrain = 0L) {
  if (is.null(engine)) {
    engine <- getCurrentEngine()
  }
  x <- C_rnorm_trng(n, mean, sd, engine, parallelGrain)
  return(x)
}
