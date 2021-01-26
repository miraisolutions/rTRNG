# Work around the fact that, in certain circumstances (architectures /
# compilers), we cannot rely on errors propagating with proper
# `std::invalid_argument` class / error message.
#
# See https://github.com/miraisolutions/rTRNG/issues/15,
# https://github.com/RcppCore/Rcpp/issues/972
#
# Approach: Use a minimal example to test whether "std::invalid_argument" is
# correctly detected, otherwise just fall-back on "error" (the "c++ exception
# (unknown reason)" error inherits from it).

invalid_argument_thrower <- cppFunction('
  void invalid_argument_thrower() {
    throw std::invalid_argument("Invalid argument test");
  }
')

invalid_argument_error_class <- function() {
  error_class <- tryCatch(
    invalid_argument_thrower(),
    error = function(e) class(e)
  )
  error_class
}

supported_invalid_argument_class <- function() {
  if ("std::invalid_argument" %in% invalid_argument_error_class()) {
    "std::invalid_argument"
  } else {
    "error"
  }
}

expected_invalid_argument_class <- supported_invalid_argument_class()
