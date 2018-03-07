#' @name TRNG.Random
#' @title TRNG random number generation.
#' @description The functions below allow setting and manipulating the current
#'   TRNG random number engine (pseudo-random number generator), similar to
#'   base-\R \link{Random}. The current engine is then used for generating
#'   random variates via any of the \code{r<dist>_trng} functions (e.g.,
#'   \code{\link{runif_trng}}).
#'
#' @template details-TRNG
#'
#' @section Details:
#' The current engine is an instance of one \link[=TRNG.Engine]{TRNG engine
#' class} provided by \pkg{rTRNG}, and is stored as \code{"TRNGengine"} global
#' option. If not explicitly set via \code{TRNGkind}, an engine of
#' \link[=defaultKind]{default kind} is implicitly created upon the first call
#' to any \code{TRNG*} or \code{r<dist>_trng} function. Note that the current
#' engine is not persistent across \R sessions. Function \code{TRNG.Random.seed}
#' can be used to extract and restore the current engine and its internal state.
#'
#' @template details-engines
#'
#' @template references-TRNG
#'
#' @template seealso-rdist_trng
#'
#' @example man-roxygen/example-TRNG.Random.R
NULL
