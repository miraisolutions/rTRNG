#' @title TRNG C++ library functionality exposed to R.
#
#' @description
#'
#' Tina's Random Number Generator Library (\pkg{TRNG}) is a state of the art C++
#' pseudo-random number generator library for sequential and parallel Monte
#' Carlo simulations (\url{http://numbercrunch.de/trng/}). It provides a variety
#' of random number engines (pseudo-random number generators) and distributions.
#' In particular, \emph{parallel} random number engines provided by TRNG support
#' techniques such as \emph{block-splitting} and \emph{leapfrogging} suitable
#' for parallel algorithms. See \sQuote{References} for an introduction to the
#' concepts and details around (parallel) random number generation.
#'
#' Package \pkg{rTRNG} provides the \R users with access to the functionality of
#' the underlying TRNG C++ library in different ways and at different levels.
#' \itemize{
#'   \item
#'     Base-\R \link{Random}-like usage via \link{TRNG.Random} functions.
#'     This is the simplest and more immediate way for \R users to use
#'     \pkg{rTRNG}.
#'   \item
#'     \link[=TRNG.Engine]{Reference Objects} wrapping the underlying C++ TRNG
#'     random number engines can be created and manipulated in OOP-style. This
#'     allows greater flexibility in using TRNG engines in \R.
#'   \item
#'     TRNG C++ library and headers are made available to other \R projects
#'     and packages using C++.
#'     \itemize{
#'     \item
#'       Standalone C++ code sourced via \link[Rcpp]{sourceCpp} can rely on the
#'       \link[=dependsAttribute]{Rcpp::depends} attribute to correctly setup
#'       building against \pkg{rTRNG}.
#'       \preformatted{// [[Rcpp::depends(rTRNG)]]}
#'     \item
#'       Creating an \R package with C++ code using the TRNG library is achived
#'       by \code{LinkingTo: rTRNG} in the DESCRIPTION file and by setting the
#'       relevant linker flags in Makevars[.win] via \link[rTRNG]{LdFlags}.
#'     }
#' }
#' See the package vignette (\code{vignette("rTRNG-vignette")} for an overview
#' and refer to the examples in the documentation for further uses cases. Folder
#' \dQuote{inst/demos} contains additional demonstrative examples.
#'
#' @template trngReferences
#' @references Stephan Mertens, \emph{Random Number Generators: A Survival Guide
#'   for Large Scale Simulations}, 2009,
#'   \url{http://adsabs.harvard.edu/abs/2009arXiv0905.4238M}
#'
#' @useDynLib rTRNG
#' @import methods
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
"_PACKAGE"


# Some notes:
#
# Like for datasets, there isn’t a object that we can document directly. Use
# "_PACKAGE" to indicate that you are creating the package’s documentation. This
# will automatically add the corect aliases so that both ?pkgname and
# package?pkgname will find the package help. This also works if there’s already
# a function called pkgname().
#
# Use @references point to published material about the package that users might
# find helpful.
#
# Package documentation is a good place to list all options() that a package
# understands and to document their behaviour. Put in a section called “Package
# options”, as described below.
