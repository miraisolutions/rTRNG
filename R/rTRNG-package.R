# See 'Documenting packages' in vignette("rd", package = "roxygen2")

#' @title TRNG C++ library functionality exposed to R.
#
#' @description
#'
#' Tina's Random Number Generator Library (\pkg{TRNG}) is a state-of-the-art C++
#' pseudo-random number generator library for sequential and parallel Monte
#' Carlo simulations (\url{https://numbercrunch.de/trng/}). It provides a variety
#' of random number engines (pseudo-random number generators) and distributions.
#' In particular, \emph{parallel} random number engines provided by TRNG support
#' techniques such as \emph{block-splitting} and \emph{leapfrogging} suitable
#' for parallel algorithms. See \sQuote{References} for an introduction to the
#' concepts and details around (parallel) random number generation.
#'
#' \if{html}{\figure{rTRNG.svg}{options: height="150px" alt="rTRNG"}}
#'
#' Package \pkg{rTRNG} provides the \R users with access to the functionality of
#' the underlying TRNG C++ library in different ways and at different levels.
#' \itemize{
#'   \item
#'     Base-\R \link{Random}-like usage via \link{TRNG.Random} functions, for
#'     selecting and manipulating the current engine. This is the simplest and
#'     more immediate way for \R users to use \pkg{rTRNG}.
#'   \item
#'     \link[=TRNG.Engine]{Reference Objects} wrapping the underlying C++ TRNG
#'     random number engines can be created and manipulated in OOP-style. This
#'     allows greater flexibility in using TRNG engines in \R.
#'   \item
#'     TRNG C++ library and headers are made available to other \R projects
#'     and packages using C++.
#'     \itemize{
#'     \item
#'       Standalone C++ code sourced via \code{\link[Rcpp]{sourceCpp}} can rely
#'       on the \code{\link[=dependsAttribute]{Rcpp::depends}} attribute to
#'       correctly setup building against \pkg{rTRNG}.
#'       \preformatted{// [[Rcpp::depends(rTRNG)]]}
#'     \item
#'       Creating an \R package with C++ code using the TRNG library is achived
#'       by \code{LinkingTo: rTRNG} in the DESCRIPTION file and by setting the
#'       relevant linker flags in Makevars[.win] via
#'       \code{\link[rTRNG]{LdFlags}}.
#'     }
#' }
#' See the package vignettes (\code{browseVignettes("rTRNG")}) for an overview
#' and demos and refer to the examples in the documentation for further use
#' cases.
#'
#' @template references-TRNG
#' @references Stephan Mertens, \emph{Random Number Generators: A Survival Guide
#'   for Large Scale Simulations}, 2009,
#'   \url{http://adsabs.harvard.edu/abs/2009arXiv0905.4238M}
#'
#' @useDynLib rTRNG, .registration=TRUE
#' @import methods
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
"_PACKAGE"
