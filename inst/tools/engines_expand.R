enginesH <- sort(c(sub("\\.cc$", "", list.files("src/trng", "(yarn|mrg|lcg|mt|xoshiro).*\\.cc$")),
                  sub("\\.hpp$", "", list.files("inst/include/trng", "lagfib.*\\.hpp$"))))
engines <- sub("^(lagfib.*)$", "\\1_19937_64", enginesH)
# R/TRNG.Engine.R
cat("#' @aliases ", engines)
cat(paste0("#'     \\code{", engines, "}", collapse = ",\n"), ".", sep = "")
cat(paste0("#' @export ", engines, collapse = "\n"))

# man-roxygen/details-engines.R
# => update manually based on TRNG docs

# src/Engine_as_wrap.h
cat(paste0("  WRAP_DECLARE(", engines, ");", collapse = "\n"))

# src/Engine_as_wrap.cpp
cat(paste0("WRAP_IMPLEMENT(", engines, ");", collapse = "\n"))

# src/Engine.h
cat(paste0("#include <trng/", enginesH, ".hpp>", collapse = "\n"))
# src/Engine.cpp
cat(paste0("template class Engine<", engines, ">;", collapse = "\n"))
# src/EngineModule.cpp
cat(paste0("  PARALLEL_ENGINE_MODULE(", engines, ");", collapse = "\n"))

# src/rdist.cpp
cat(paste0("  PARALLEL_ENGINE_DISPATCH(", engines, ")", collapse = "\n"))

# tests/testthat/test-TRNG.Engine.R
cat(paste0("  ", engines, collapse = ",\n"))
