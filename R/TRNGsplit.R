#' @rdname TRNG.Random
#' @description If the current engine is of a \emph{parallel} kind,
#'   \code{TRNGsplit} updates its internal state and parameters in order to
#'   generate directly a subsequence obtained by decimation, producing every
#'   \code{s}th element starting from the \code{p}th.
#' @param p Number of subsequences to split the engine by.
#' @param s Index of the desired subsequence between \code{1} and \code{p}.
#' @include TRNGjump.R
#' @export
TRNGsplit <- function(p, s) {
  getCurrentEngine()$split(p, s)
}
