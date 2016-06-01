demos <- "inst/demos"
pkg <- "rTRNGinPkg"
pkgDir <- file.path(tempdir(), pkg)

Rcpp::Rcpp.package.skeleton(
  pkg, path = dirname(pkgDir),
  cpp_files = file.path(demos, "skeletonFiles",
                        c("Makevars", "Makevars.win",
                          "testUsingrTRNG.cpp")))

devtools::use_package(pkg = pkgDir, package = "rTRNG", type = "Imports")
devtools::use_package(pkg = pkgDir, package = "rTRNG", type = "LinkingTo")
devtools::install(pkg = pkgDir, quick = TRUE, quiet = TRUE)

rTRNGinPkg::testUsingrTRNG(10)

# cleanup
unlink(pkgDir, recursive = TRUE)
remove.packages(pkg)
