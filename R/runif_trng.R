#' @template template-rdist
#' @templateVar distTitle Uniform
#' @templateVar distDesc uniform
#' @templateVar rdist runif
#' @templateVar n n
#' @templateVar distparam min,max
#' @example man-roxygen/example-runif_trng.R
#' @export
runif_trng <- function(n, min = 0, max = 1,
                       engine = NULL, parallelGrain = 0L) {
  if (is.null(engine)) {
    engine <- getCurrentEngine()
  }
  x <- C_runif_trng(n, min, max, engine, parallelGrain)
  return(x)
}
