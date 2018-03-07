#' @rdname TRNG.Random
#' @description \code{TRNGseed} specifies the seed for the current
#'   engine.
#' @param seed Scalar integer seed, determining the internal state of the
#'   current engine.
#' @include TRNGkind.R
#' @export
TRNGseed <- function(seed) {
  getCurrentEngine()$seed(seed)
  invisible(NULL)
}
