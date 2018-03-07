#' @title TRNG random number engines.
#' @description
#' \link[=ReferenceClasses]{Reference Classes} exposing random number engines
#' (pseudo-random number generators) in the TRNG C++ library. Engine objects of
#' a class \code{engineClass} are created as \code{x <- engineClass$new(\dots)},
#' and a method \code{m} is invoked as \code{x$m(\dots)}.
#'
#' @name TRNG.Engine
#'
#' @aliases lagfib2plus_19937_64 lagfib2xor_19937_64 lagfib4plus_19937_64
#' lagfib4xor_19937_64 lcg64 lcg64_shift mrg2 mrg3 mrg3s mrg4 mrg5 mrg5s mt19937
#' mt19937_64 yarn2 yarn3 yarn3s yarn4 yarn5 yarn5s
#'
#' @section Classes:
#'
#' \describe{
#'   \item{\emph{Parallel} random number engines}{
#'   \code{lcg64}, \code{lcg64_shift}, \code{mrg2}, \code{mrg3}, \code{mrg3s},
#'   \code{mrg4}, \code{mrg5}, \code{mrg5s}, \code{yarn2}, \code{yarn3},
#'   \code{yarn3s}, \code{yarn4}, \code{yarn5}, \code{yarn5s}.
#'   }
#'   \item{\emph{Conventional} random number engines}{
#'   \code{lagfib2plus_19937_64}, \code{lagfib2xor_19937_64},
#'   \code{lagfib4plus_19937_64}, \code{lagfib4xor_19937_64}, \code{mt19937_64},
#'   \code{mt19937}.
#'   }
#' }
#'
#' @section Constructors:
#' \describe{
#'   \item{\code{$new()}}{
#'   Construct a random engine object using default seed and internal parameters.
#'   }
#'   \item{\code{$new(seed)}}{
#'   Construct a random engine object with default internal parameters using the
#'   provided \code{seed}.
#'   }
#'   \item{\code{$new(string)}}{
#'   Construct a random engine object restoring its internal state and
#'   parameters from a character \code{string}, falling back to \code{$new()}
#'   for empty strings. See method \code{$toString()}.
#'   }
#' }
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$seed(seed)}}{
#'   Use the scalar integer \code{seed} to set the engine's internal state.
#'   }
#'   \item{\code{$jump(steps)}}{
#'   Advance by \code{steps} the internal state of the engine. Applies to
#'   \emph{parallel} engines only.
#'   }
#'   \item{\code{$split(p, s)}}{
#'   Update the internal state and parameters of the engine for generating
#'   directly the \code{s}th of \code{p} subsequences, with \code{s} in
#'   [\code{1}, \code{p}], producing one element every \code{s} starting from
#'   the \code{p}th. Applies to \emph{parallel} engines only.
#'   }
#'   \item{\code{$name()}, \code{$kind()}}{
#'   Return the name of the random number engine (e.g., \code{"yarn2"}), also
#'   referred to as \code{kind} in \pkg{rTRNG} similarly to \link[=Random]{base}
#'   \R.
#'   }
#'   \item{\code{$toString()}}{
#'   Return a character representation of the engine's internal state and
#'   parameters.
#'   }
#'   \item{\code{$copy()}}{
#'   Specialization of the generic method for \link[=ReferenceClasses]{Reference
#'   Classes}, ensuring the underlying C++ engine object is properly copied.
#'   }
#'   \item{\code{$show()}}{
#'   Specialization of the generic \link[methods]{show}, displaying
#'   \code{$toString()} (truncated to 80 characters).
#'   }
#'   \item{\code{$.Random.seed()}}{
#'   Return a two-element character vector with elements \code{$kind()} and
#'   \code{$toString()}, suitable for use in \code{\link{TRNG.Random.seed}} (and
#'   by a possible function returning an engine object given a
#'   \code{TRNG.Random.seed}).
#'   }
#' }
#'
#' @template details-TRNG
#'
#' @section Details:
#'
#' Random number engines from the C++ TRNG library are exposed to \R using
#' \pkg{\link{Rcpp}} \code{\linkS4class{Module}}s. As a consequence, the
#' arguments to all Constructors and Methods above are not passed by name but by
#' order. Morever, arguments and return values are both defined in terms of C++
#' data types. Details can be displayed via the standard
#' \link[=ReferenceClasses]{Reference Class} documentation method \code{$help}
#' (e.g., \code{yarn2$help(split)}).
#'
#' Most of the Methods above are simple wrappers of analogous methods in the
#' corresponding C++ class provided by the TRNG library. A few
#' differences/details are worth being mentioned.
#' \itemize{
#'   \item
#'     Argument \code{s} of the \code{split} method is exposed to \R according
#'     to \R's \code{1}-based indexing, thus in the [\code{1}, \code{p}]
#'     interval, whereas the TRNG C++ implementation follows C++ \code{0}-based
#'     indexing, thus allowing values in [\code{0}, \code{p-1}].
#'   \item
#'     Constructor \code{new(string)} and method \code{toString()} rely on
#'     streaming operators \code{>>} and \code{<<} available for all C++ TRNG
#'     classes.
#'   \item
#'     TRNG C++ random number engine objects are \emph{copy-constructible} and
#'     \emph{assignable}, whereas their \R counterparts in \pkg{rTRNG} are
#'     purely reference-based. In particular, as for any \R
#'     \link[=ReferenceClasses]{Reference Object}, engines are not copied upon
#'     assignment but via the \code{$copy()} method.
#' }
#'
#' @template details-engines
#'
#' @template references-TRNG
#'
#' @seealso \code{\link{ReferenceClasses}}, \code{\link{TRNG.Random}}.
#'
#' @example man-roxygen/example-TRNG.Engine.R
#'
#' @export lagfib2plus_19937_64
#' @export lagfib2xor_19937_64
#' @export lagfib4plus_19937_64
#' @export lagfib4xor_19937_64
#' @export lcg64
#' @export lcg64_shift
#' @export mrg2
#' @export mrg3
#' @export mrg3s
#' @export mrg4
#' @export mrg5
#' @export mrg5s
#' @export mt19937
#' @export mt19937_64
#' @export yarn2
#' @export yarn3
#' @export yarn3s
#' @export yarn4
#' @export yarn5
#' @export yarn5s
NULL
