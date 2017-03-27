
demos <- "inst/demos"
pkg <- "rTRNGinPkg"
pkgDir <- file.path(tempdir(), pkg)

# cleanup
on.exit({
  unlink(pkgDir, recursive = TRUE)
  remove.packages(pkg)
})


Rcpp::Rcpp.package.skeleton(
  pkg, path = dirname(pkgDir),
  cpp_files = file.path(demos, "skeletonFiles",
                        c(# linker flags via rTRNG::LdFlags()
                          "Makevars", "Makevars.win",
                          # simple Rcpp function using TRNG
                          "testUsingrTRNG.cpp")))

# Imports and LinkingTo
devtools::use_package(pkg = pkgDir, package = "rTRNG", type = "Imports")
devtools::use_package(pkg = pkgDir, package = "rTRNG", type = "LinkingTo")

# import one symbol in the package NAMESPACE to ensure correct loading
writeLines("importFrom(rTRNG, TRNG.Version)",
           file(file.path(pkgDir, "NAMESPACE"), "a"))

devtools::install(pkg = pkgDir)

rTRNGinPkg::testUsingrTRNG(10)
