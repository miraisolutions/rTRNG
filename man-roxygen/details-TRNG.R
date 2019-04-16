#' @section Details:
#' The TRNG C++ library provides a collection of random number engines
#' (pseudo-random number generators). In particular, compared to
#' \emph{conventional} engines working in a purely sequential manner,
#' \emph{parallel} engines can be manipulated via \code{jump} and \code{split}
#' operations. Jumping allows to advance the internal state by a number of steps
#' without generating all intermediate states, whereas split operations allow to
#' generate directly a subsequence obtained by decimating the original sequence.
#' Please consult the TRNG C++ library documentation (see \sQuote{References})
#' for an introduction to the concepts and details around (parallel) random
#' number generation and engines, including details about the state size and
#' period of the TRNG generators.
