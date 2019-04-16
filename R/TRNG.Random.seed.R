#' @rdname TRNG.Random
#' @description \code{TRNG.Random.seed} allows to get a full representation of
#'   the current state of the engine in use, and to restore the current engine
#'   from such representation.
#' @usage
#' TRNG.Random.seed(engspec)
#' @param engspec Optional two-element character vector \code{c(kind, state)},
#'   where the second element is a character representation of the current
#'   engine's internal state and parameters.
#'
#' @return
#' \code{TRNG.Random.seed()} called with no arguments returns a two-element
#' character vector \code{c(kind, state)} fully representing the current state
#' of the engine in use. When argument \code{engspec = c(kind, state)} is
#' provided, it is used to set an engine of the given \code{kind} with internal
#' state and parameters restored from \code{state}.
#' @include TRNGsplit.R
#' @export
TRNG.Random.seed <- function(engspec) {
  if (missing(engspec)) {
    return(getCurrentEngine()$.Random.seed())
  } else {
    setCurrentEngine(get(engspec[1])$new(engspec[2]))
    return(invisible(NULL))
  }
}
