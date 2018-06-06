#' @rdname TRNG.Random
#' @description \code{TRNGkind} allows to query or set the kind of TRNG engine
#'   in use. See \sQuote{Random number engines details} for the available
#'   engines.
#' @template param-kind
#' @return \code{TRNGkind} returns the TRNG kind selected before the call,
#'   invisibly if argument \code{kind} is not NULL.
#' @export
TRNGkind <- function(kind = NULL) {
  initialKind <- getCurrentEngine()$name()
  if (is.null(kind)) {
    initialKind
  } else {
    if (kind == "default") {
      kind <- defaultKind()
    }
    rng <- withCallingHandlers(
      get(kind)$new(),
      error = function(e) stop("invalid kind '", kind, "'")
    )
    setCurrentEngine(rng)
    invisible(initialKind)
  }
}
