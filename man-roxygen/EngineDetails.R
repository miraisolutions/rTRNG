#' @section Random number engines details:
#' \subsection{Parallel engines}{
#'   \describe{
#'     \item{\code{lcg64}}{
#'       Linear congruential generator with modulus \eqn{2^{64}}{2^64}.
#'     }
#'     \item{\code{lcg64_shift}}{
#'       Linear congruential generator with modulus \eqn{2^{64}}{2^64} and
#'       bit-shift transformation.
#'     }
#'     \item{\code{mrg2}, \code{mrg3}, \code{mrg4}, \code{mrg5}}{
#'       Multiple recurrence generators based on a linear feedback shift
#'       register sequence with prime modulus \eqn{2^{31}-1}{2^31-1}.
#'     }
#'     \item{\code{mrg3s}, \code{mrg5s}}{
#'       Multiple recurrence generators based on a linear feedback shift
#'       register with Sophie-Germain prime modulus.
#'     }
#'     \item{\code{yarn2}, \code{yarn3}, \code{yarn4}, \code{yarn5}}{
#'       YARN generators based on the delinearization of a linear feedback shift
#'       register sequence with prime modulus \eqn{2^{31}-1}{2^31-1}.
#'     }
#'     \item{\code{yarn3s}, \code{yarn5s}}{
#'       YARN generators based on the delinearization of a linear feedback shift
#'       register sequence with Sophie-Germain prime modulus.
#'     }
#'   }
#' }
#'
#' \subsection{Conventional engines}{
#'   \describe{
#'     \item{\code{lagfib2plus_19937_64}, \code{lagfib4plus_19937_64}}{
#'       Lagged Fibonacci generator with \code{2} or \code{4} feedback taps and
#'       addition.
#'     }
#'     \item{\code{lagfib2xor_19937_64}, \code{lagfib4xor_19937_64}}{
#'       Lagged Fibonacci generator with \code{2} or \code{4} feedback taps and
#'       exclusive-or operation.
#'     }
#'     \item{\code{mt19937}}{
#'       Mersenne-Twister generating 32 random bit.
#'     }
#'     \item{\code{mt19937_64}}{
#'       Mersenne-Twister generating 64 random bit.
#'     }
#'   }
#' }
