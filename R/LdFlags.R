# Adapted from RcppParallel

# LD flags for building against rTRNG. These flags are propagated to sourceCpp
# via the inlineCxxPlugin (defined in inline.R) and to packages via a line in
# Makevars[.win].

#' Linker flags for rTRNG.
#'
#' Output the linker flags required to build against \pkg{rTRNG}.
#'
#' @details \code{LdFlags} is typically called from Makevars as
#' \preformatted{PKG_LIBS += $(shell ${R_HOME}/bin/Rscript -e "rTRNG::LdFlags()")}
#' and from Makevars.win as
#' \preformatted{PKG_LIBS += $(shell "${R_HOME}/bin${R_ARCH_BIN}/Rscript.exe" -e "rTRNG::LdFlags()")}
#' @return Returns NULL invisibly. The function is not called for its return
#'   value rather for the side effect of outputting the flags.
#' @export
LdFlags <- function() {
  cat(rTRNGLdFlags())
}

# Return the linker flags required for rTRNG on this platform.
rTRNGLdFlags <- function() {
  LibPath <- rTRNGLib()
  # Option 1: => stopped working with recent Rcpp version
  # -l:filename (-l=namespec does not work on linux since it would look for
  # libnamespec.ext, whereas the library is built as rTRNG.ext)
  # flags <- paste("-L", asBuildPath(dirname(LibPath)), " -l:", basename(LibPath), sep = "")
  # Option 2:
  # directly link against the library providing its full path
  flags <- paste(asBuildPath(LibPath), sep = "")
  return(flags)
}

# Determine the platform-specific path to the rTRNG library.
rTRNGLib <- function() {
  libDir <- "libs"
  if (nchar(.Platform$r_arch)) {
    libDir <- paste(libDir, .Platform$r_arch, sep = "/")
  }
  system.file(
    paste(libDir, "/rTRNG", .Platform$dynlib.ext, sep = ""),
    package = "rTRNG"
  )
}

# Helper function to ape the behavior of the R build system when providing paths
# to libraries.
asBuildPath <- function(path) {
  if (.Platform$OS.type == "windows") {
    path <- normalizePath(path)
    if (grepl(" ", path, fixed = TRUE)) {
      path <- utils::shortPathName(path)
    }
    path <- gsub("\\\\", "/", path)
  }
  return(path)
}

sourceCpp_minimal_code <- '
// [[Rcpp::depends(rTRNG)]]
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <trng/yarn2.hpp>
// [[Rcpp::export]]
void exampleCpp() {
  trng::yarn2 rng;
}
'

#' Check rTRNG linking.
#'
#' Check whether C++ code using the TRNG library can be built and linked against
#' \pkg{rTRNG} on the current system.
#'
#' @inheritParams base::try
#'
#' @return A scalar logical with the result of the check. If \code{FALSE}, using
#'   the TRNG library from C++ code sourced via \code{\link[Rcpp]{sourceCpp}} or
#'   part of an \R package is not expected to work.
#'
#' @export
check_rTRNG_linking <- function(silent = FALSE) {
  check <- try(
    silent = silent,
    Rcpp::sourceCpp(code = sourceCpp_minimal_code)
  )
  !inherits(check, "try-error")
}
