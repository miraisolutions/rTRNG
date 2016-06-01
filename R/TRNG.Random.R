#' @name TRNG.Random
#' @title TRNG random number generation.
#' @description The functions below allow setting and manipulating the current
#'   TRNG random number engine (pseudo-random number generator), similarly to
#'   base-\R \link{Random}. The current engine is then used for generating
#'   random variates via \ldots.
#'
#' @template DetailsTRNG
#'
#' @section Details:
#' The current engine is an instance of one \link[=TRNG.Engine]{TRNG engine
#' class} provided by \pkg{rTRNG}. Note that the current engine is not
#' persistent across \R sessions. Function \code{TRNG.Random.seed} can be used
#' to extract and restore the current engine and its internal state.
#'
#' @template EngineDetails
#'
#' @template trngReferences
NULL
