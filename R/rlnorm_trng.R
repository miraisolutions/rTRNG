#' @template template-rdist
#' @templateVar distTitle Log-normal
#' @templateVar distDesc log-normal
#' @templateVar rdist rlnorm
#' @templateVar n n
#' @templateVar distparam meanlog,sdlog
#' @export
rlnorm_trng <- function(n, meanlog = 0, sdlog = 1,
                        engine = NULL, parallelGrain = 0L) {
  if (is.null(engine)) {
    engine <- getCurrentEngine()
  }
  x <- C_rlnorm_trng(n, meanlog, sdlog, engine, parallelGrain)
  return(x)
}
