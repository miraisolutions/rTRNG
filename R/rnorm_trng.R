#' @template template-rdist
#' @templateVar distTitle Normal
#' @templateVar distDesc normal
#' @templateVar rdist rnorm
#' @templateVar n n
#' @templateVar distparam mean,sd
#' @example man-roxygen/example-rnorm_trng.R
#' @export
rnorm_trng <- function(n, mean = 0, sd = 1,
                       engine = NULL, parallelGrain = 0L) {
  if (is.null(engine)) {
    engine <- getCurrentEngine()
  }
  x <- C_rnorm_trng(n, mean, sd, engine, parallelGrain)
  return(x)
}
