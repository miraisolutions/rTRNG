
#' @keywords internal
getCurrentEngine <- function() {
  engine <- getOption("TRNGengine", default = get(defaultKind())$new())
  setCurrentEngine(engine)
  return(engine)
}

#' @keywords internal
setCurrentEngine <- function(engine) {
  # TODO: check class?
  options(TRNGengine = engine)
}
