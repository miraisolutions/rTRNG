#' @rdname TRNG.Random
#' @description If the current engine is of a \emph{parallel} kind,
#'   \code{TRNGjump} advances its internal state without generating all
#'   intermediate steps.
#' @param steps Number of steps to jump ahead.
#' @include TRNGseed.R
#' @export
TRNGjump <- function(steps) {
  getCurrentEngine()$jump(steps)
}
