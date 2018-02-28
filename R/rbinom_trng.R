#' @template template-rdist
#' @templateVar distTitle Binomial
#' @templateVar distDesc binomial
#' @templateVar rdist rbinom
#' @templateVar n n
#' @templateVar distparam size,prob
#' @export
rbinom_trng <- function(n, size, prob,
                        engine = NULL, parallelGrain = 0L) {
  if (is.null(engine)) {
    engine <- getCurrentEngine()
  }
  x <- C_rbinom_trng(n, size, prob, engine, parallelGrain)
  return(x)
}
