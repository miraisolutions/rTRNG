#' @template template-rdist
#' @templateVar distTitle Poisson
#' @templateVar distDesc Poisson
#' @templateVar rdist rpois
#' @templateVar n n
#' @templateVar distparam lambda
#' @export
rpois_trng <- function(n, lambda,
                       engine = NULL, parallelGrain = 0L) {
  if (is.null(engine)) {
    engine <- getCurrentEngine()
  }
  x <- C_rpois_trng(n, lambda, engine, parallelGrain)
  return(x)
}
