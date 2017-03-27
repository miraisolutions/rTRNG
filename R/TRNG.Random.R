#' @name TRNG.Random
#' @title TRNG random number generation.
#' @description The functions below allow setting and manipulating the current
#'   TRNG random number engine (pseudo-random number generator), similarly to
#'   base-\R \link{Random}. The current engine is then used for generating
#'   random variates via any of the \code{r<dist>.trng} functions (e.g.,
#'   \code{\link{runif.trng}}).
#'
#' @template details-TRNG
#'
#' @section Details:
#' The current engine is an instance of one \link[=TRNG.Engine]{TRNG engine
#' class} provided by \pkg{rTRNG}. Note that the current engine is not
#' persistent across \R sessions. Function \code{TRNG.Random.seed} can be used
#' to extract and restore the current engine and its internal state.
#'
#' @template details-engines
#'
#' @template references-TRNG
NULL
