#' @rdname TRNG.Random
#' @description \code{TRNG.Random.seed} allows to get a full represention the
#'   current state of the engine in use, and to restore the current engine from
#'   such representation.
#' @usage
#' TRNG.Random.seed(kindstr)
#' @param kindstr Optional two-element character vector \code{c(kind, str)},
#'   where \code{str} is a character representation of the current engine's
#'   internal state and parameters.
#'
#' @return
#' \code{TRNG.Random.seed()} called with no arguments returns a two-element
#' character vector \code{c(kind, str)} fully representing the current state of
#' the engine in use. When argument \code{kindstr = c(kind, str)} is provided,
#' it is used to set an engine of the given \code{kind} with internal state and
#' parameters restored from \code{str}.
#' @include TRNGsplit.R
#' @export
TRNG.Random.seed <- function(kindstr) {
  if (missing(kindstr)) {
    return(getCurrentEngine()$.Random.seed())
  } else {
  setCurrentEngine(get(kindstr[1])$new(kindstr[2]))
    return(invisible(NULL))
  }
}
