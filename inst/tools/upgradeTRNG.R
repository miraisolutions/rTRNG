if (FALSE) {
  source("inst/tools/upgradeTRNG.R")
  upgradeTRNG(version = "4.23.1", year = "2021")
  # with patch, packported from trng4 @22cc3b6:
  patch_file <- file.path(getwd(), "inst", "tools", "fix_uninitialized-memory_read_access-backport-v4.23.patch")
  system(paste0("cd ~/GitHubProjects/trng4/ && git diff v4.23..22cc3b6 trng/utility.hpp > ", patch_file))
  upgradeTRNG(version = "4.23", patch = patch_file)
  # off-line:
  upgradeTRNG(version = "4.23", sprintf("file://%s", normalizePath("~/Downloads")))
}

upgradeTRNG <- function(version, base_url = "https://numbercrunch.de/trng",
                        year = "0000",
                        patch = NULL,
                        cleanTmp = TRUE) {

  pre_4.22 <- package_version(version) < package_version("4.22")
  gh_only <- package_version(version) >= package_version("4.23")
  lib.tar.gz <- sprintf("trng-%s.tar.gz", version)
  if (gh_only) {
    gh_base_url <- "https://github.com/rabauke/trng4"
    libURL <- sprintf("%s/archive/v%s.tar.gz", gh_base_url, version)
    docURL <- sprintf("%s/blob/v%s/doc/trng.pdf", gh_base_url, version)
  } else {
    libURL <- sprintf("%s/%s", base_url, lib.tar.gz)
    docURL <- "https://numbercrunch.de/trng/trng.pdf"
  }
  tmpDir <- tempdir()
  lib.tar.gz.path <- file.path(tmpDir, lib.tar.gz)

  download.file(libURL, lib.tar.gz.path, mode = "wb")

  lib.path <- tempfile(sub(".tar.gz", "_", lib.tar.gz, fixed = TRUE))
  untar(lib.tar.gz.path, exdir = lib.path)
  src.dir <- if (pre_4.22) "src" else "trng"
  lib.src.path <- file.path(
    list.dirs(lib.path, recursive = FALSE, full.names = TRUE)[1L],
    src.dir
  )
  stopifnot(dir.exists(lib.src.path))
  version_info <- version
  if (!is.null(patch)) {
    message("Apply patch ", patch)
    patch_file <- normalizePath(patch)
    stopifnot(
      0 == system(paste("cd", dirname(lib.src.path),  "&& git apply -v", patch_file))
    )
    # add a patch component to the version, and include an explicit information
    # in `TRNG.Version()` about this being a version patched inside rTRNG
    version <- paste(version, "1", sep = ".")
    version_info <- paste(version, "(patched in rTRNG)")
    message("  >> using patch version: ", version_info)
  }

  .message <- function(msg, dir, files) {
    message(
      msg, toString(sQuote(unique(dir), FALSE)), ":\n",
      paste("  >>", files, collapse = "\n")
    )
  }

  .cleanAndCopy <- function(path, pattern, from, what = "files") {
    files.to.clean <- list.files(path = path, pattern = pattern, full.names = TRUE)
    .message(paste0("Cleaning ", what, " in "), path, basename(files.to.clean))
    file.remove(files.to.clean)
    files.to.copy <- list.files(path = from, pattern = pattern, full.names = TRUE)
    .message(paste0("Copying ", what, " from ", from, " to "), path, basename(files.to.copy))
    file.copy(files.to.copy, path)
  }

  # Clean and copy. Assumption: all and only .cc and .hpp files are from the
  # TRNG library

  # Clean and copy *.cc from src directory
  .cleanAndCopy(
    file.path("src", "trng"), "\\.cc$",
    lib.src.path, "TRNG source files"
  )
  # Clean and copy *.hpp from inst/include/trng
  .cleanAndCopy(
    file.path("inst", "include", "trng"), "\\.hpp$",
    lib.src.path, "TRNG header files"
  )

  # Update copyright information
  rTRNG.copyright <- file.path("inst", "COPYRIGHTS")
  TRNG.copyright <- list.files(lib.path, "^COPYING$", full.names = TRUE, recursive = TRUE)
  message("Copying ", TRNG.copyright, " -> ", rTRNG.copyright)
  message("Prepend extra line to ", rTRNG.copyright)
  extraLine <- "** rTRNG includes source code from Tina's Random Number Generator C++ Library **"
  writeLines(c(extraLine, "", readLines(TRNG.copyright)), rTRNG.copyright)

  if (cleanTmp) {
    message("Deleting ", lib.tar.gz.path)
    unlink(lib.tar.gz.path)
    message("Deleting ", lib.path)
    unlink(lib.path, recursive = TRUE)
  }

  version.file <- file.path("R", "TRNG.Version.R")
  message("Update ", version.file, " source file")
  version.code <- sub(
    "(return\\(\")([^\"]+)(\"\\))",
    paste0("\\1", version_info, "\\3"),
    readLines(version.file)
  )
  writeLines(version.code, version.file)

  rTRNG.version <- sprintf("%s-0.9000", version)
  message("Update DESCRIPTION with version ", rTRNG.version)
  description.text <- sub("(Version: ).*$", paste0("\\1", rTRNG.version),
                          readLines("DESCRIPTION"))
  message("Update DESCRIPTION with documentation year ", year)
  description.text <- sub("Bauke \\(\\d{4}\\)$",
                          sprintf("Bauke (%s)", year),
                          description.text)
  message("Update DESCRIPTION with documentation URL <", docURL, ">")
  description.text <- sub("<.*/trng[.]pdf>",
                          sprintf("<%s>", docURL),
                          description.text)
  writeLines(description.text, "DESCRIPTION")

  message("Update TRNG reference URL <", docURL, ">")
  reference.text <- sub("url\\{.*trng[.]pdf\\}",
                        sprintf("url{%s}", docURL),
                        readLines("man-roxygen/references-TRNG.R"))
  writeLines(reference.text, "man-roxygen/references-TRNG.R")


  invisible()

}
