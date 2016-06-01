

enginesH <- sort(c(sub("\\.cc$", "", list.files("src/trng", "(yarn|mrg|lcg|mt).*\\.cc$")),
                  sub("\\.hpp$", "", list.files("inst/include/trng", "lagfib.*\\.hpp$"))))
engines <- sub("^(lagfib.*)$", "\\1_19937_64", enginesH)
cat(engines)
cat(deparse(engines))
cat(paste(engines, collapse = ", "))
cat(paste0("Rcpp_", engines, "-class"))
cat(paste0("\\code{", engines, "}", collapse = ", "))
cat(paste0("#' @export ", engines, collapse = "\n"))
cat(paste0("#include <trng/", enginesH, ".hpp>", collapse = "\n"))
cat(paste0("typedef Engine<", engines, "> ", engines, "_Engine;", collapse = "\n"))
cat(paste0("template class Engine<", engines, ">;", collapse = "\n"))
cat(paste0("PARALLEL_ENGINE_MODULE(", engines, ");", collapse = "\n"))
cat(paste0("PARALLEL_ENGINE_CASE(", engines, ")", collapse = "\n"))
cat(paste0("#define ", engines, "_ID ", seq_along(engines)-1, collapse = "\n"))
cat(paste0("engineIDMap[\"", engines, "\"] = ", engines, "_ID;", collapse = "\n"))
