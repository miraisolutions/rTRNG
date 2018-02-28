# TODO: to be part of the package and exposed
rTRNG.package.skeleton <- function(name = "anRpackage",
                                   path = ".", force = FALSE,
                                   code_files = character(),
                                   cpp_files = character(),
                                   example_code = TRUE,
                                   author = "Your Name",
                                   maintainer = author,
                                   email = "your@email.com",
                                   license = "GPL (>= 2)") {

  Rcpp::Rcpp.package.skeleton(
    name = name, path = path, force = force,
    code_files = code_files,
    environment = new.env(), # needed to prevent 'Rcpp.fake.fun' error
    cpp_files = c(
      cpp_files,
      file.path(
        demos, "skeletonFiles",
        c(# linker flags via rTRNG::LdFlags()
          "Makevars", "Makevars.win",
          # simple Rcpp function using TRNG
          if (example_code) "trng_hello_world.cpp"
        )
      )
    ),
    example_code = FALSE,
    author = author, maintainer = maintainer, email = email, license = license
  )

  # Imports and LinkingTo
  pkg <- file.path(path, name)
  message("\nAdding rTRNG settings")

  # update DESCRIPTION file
  desc <- read.dcf(file.path(pkg, "DESCRIPTION"), all = TRUE, keep.white = TRUE)
  desc$Imports <- paste0(desc$Imports, ", ", "rTRNG")
  message(" >> added Imports: rTRNG")
  desc$LinkingTo <- paste0(desc$LinkingTo, ", rTRNG")
  message(" >> added LinkingTo: rTRNG")
  desc$SystemRequirements <- "GNU make"
  message(" >> added SystemRequirements: GNU make")
  write.dcf(desc, file = file.path(pkg, "DESCRIPTION"), keep.white = TRUE)


  # import one symbol in the package NAMESPACE to ensure correct loading
  importFrom <- "importFrom(rTRNG, TRNG.Version)"
  cat(importFrom,
      file = file.path(pkg, "NAMESPACE"),
      sep = "\n", append = TRUE)
  message(" >> added ", importFrom, " directive to NAMESPACE")

}


demos <- "inst/demos"
pkgName <- "pkgUsingTRNG"
pkg <- file.path(tempdir(), pkgName)

rTRNG.package.skeleton(pkgName, dirname(pkg))

devtools::check(pkg)

devtools::install(pkg)

pkgUsingTRNG::trng_hello_world()

# cleanup
devtools::uninstall(pkg)
unlink(pkg, recursive = TRUE)
