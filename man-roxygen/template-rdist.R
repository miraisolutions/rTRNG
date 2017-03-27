#' @title <%= distTitle %> random numbers via TRNG.
#' @description Random number generation for the <%= distDesc %> distribution
#'   using the TRNG C++ library.
#'
#' @param <%= n %> Number of observations.
#' @param <%= distparam %> Parameters of the distribution, with the same meaning as in
#'   \code{\link{<%= rdist %>}}. Note however that only scalar values are
#'   accepted.
#' @param engine Optional \link[=TRNG.Engine]{TRNG engine object}; if missing or
#'   \code{NULL}, the current engine controlled via \link{TRNG.Random} is used.
#' @param parallelGrain Optional argument controlling the parallel simulation of
#'   random variates (see \sQuote{Parallel Simulation} below for details).
#'
#' @return Numeric vector of random variates generated with the given
#'   parameters. The length is determined by \code{n}.
#'
#' @section Parallel Simulation: When a positive value of argument
#'   \code{parallelGrain} is supplied, random variates are simulated in
#'   parallel, provided a \emph{parallel} random number \code{engine} is
#'   selected. This is done using \pkg{\link{RcppParallel}} via
#'   \code{parallelFor}, which uses the supplied \code{parallelGrain} to control
#'   the grain size (the number of threads being controlled by
#'   \code{\link{setThreadOptions}}). The grain size can greatly affect the overhead of
#'   performing the required \emph{block splitting} \code{jump} operations and
#'   should be selected carefully. Note that TRNG guarantees the outcome of such
#'   parallel execution to be equivalent to a purely sequential simulation.
#'
#' @seealso \code{\link{<%= rdist %>}}, \code{\link{TRNG.Engine}},
#'   \code{\link{TRNG.Random}}.
#' @family TRNG distributions
