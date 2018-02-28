# source("inst/tools/upgradeTRNG.R")

upgradeTRNG <- function(version, cleanTmp = TRUE) {

  lib.tar.gz <- sprintf("trng-%s.tar.gz", version)
  libURL <- sprintf("https://numbercrunch.de/trng/%s", lib.tar.gz)
  tmpDir <- tempdir()
  lib.tar.gz.path <- file.path(tmpDir, lib.tar.gz)

  download.file(libURL, lib.tar.gz.path, mode = "wb")

  # list.files(tmpDir, recursive = TRUE)
  lib.path <- tempfile(sub(".tar.gz", "_", lib.tar.gz, fixed = TRUE))
  untar(lib.tar.gz.path, exdir = lib.path)
  lib.src.path <- list.files(lib.path, "^src$", recursive = TRUE, include.dirs = TRUE, full.names = TRUE)

  .message <- function(msg, dir, files) {
    message(msg, "'",paste(unique(dir), collapse = "','"), "':\n",
            paste("  >>", files, collapse = "\n"))
  }

  .cleanAndCopy <- function(path, pattern, from, what = "files") {
    files.to.clean <- list.files(path = path, pattern = pattern, full.names = TRUE)
    .message(paste0("Cleaning ", what, " in "), path, basename(files.to.clean))
    file.remove(files.to.clean)
    files.to.copy <- list.files(path = from, pattern = pattern, full.names = TRUE)
    .message(paste0("Copying ", what, " to "), path, basename(files.to.copy))
    file.copy(files.to.copy, path)
  }

  # Clean and copy. Assumption: all and only .cc and .hpp files are from the
  # TRNG library

  # Clean and copy *.cc from src directory
  .cleanAndCopy("src/trng", "\\.cc$", lib.src.path,
                "TRNG source files")
  # Clean and copy *.hpp from inst/include/trng
  .cleanAndCopy(file.path("inst", "include", "trng"), "\\.hpp$", lib.src.path,
                "TRNG header files")

  # Update copyright information
  rTRNG.copyright <- file.path("inst/COPYRIGHTS")
  TRNG.copyright <- list.files(lib.path, "^COPYING$", full.names = TRUE, recursive = TRUE)
  message("Copying ", TRNG.copyright, " -> ", rTRNG.copyright)
  message("Prepend extra line to COPYRIGHTS")
  extraLine <- "** rTRNG includes source code from Tina's Random Number Generator C++ Library **"
  writeLines(c(extraLine, "",
               readLines(TRNG.copyright)),
             rTRNG.copyright)

  if (cleanTmp) {
    message("Deleting ", lib.tar.gz.path)
    unlink(lib.tar.gz.path)
    message("Deleting ", lib.path)
    unlink(lib.path, recursive = TRUE)
  }

  version.file <- "TRNG.Version.R"
  message("Update ", version.file, " source file")
  version.code <- sub("(return\\(\")([^\"]+)(\"\\))", paste0("\\1", version, "\\3"),
                      readLines(file.path("R", version.file)))
  writeLines(version.code, file.path("R", version.file))

  rTRNG.version <- sprintf("%s-0.9000", version)
  message("Update DESCRIPTION with version ", rTRNG.version)
  description.text <- sub("(Version: ).*$", paste0("\\1", rTRNG.version),
                          readLines("DESCRIPTION"))
  writeLines(description.text, "DESCRIPTION")

  invisible()

}
