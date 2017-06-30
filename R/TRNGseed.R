#' @rdname TRNG.Random
#' @description \code{TRNGseed} specifies the seed for the current
#'   engine.
#' @param seed Scalar seed, interpreted as integer, determining the internal
#'   state of the current engine.
#' @include TRNGkind.R
#' @export
TRNGseed <- function(seed) {
  getCurrentEngine()$seed(seed)
  invisible(NULL)
}
