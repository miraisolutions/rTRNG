# rTRNG 4.22-0.9000

## Maintenance release

- Underlying TRNG C++ library upgraded to version 4.22 (#6). This mainly includes: Fixing numerical convergence problems in the inverse of the incomplete Beta function; Removing support for C++ language standards older than C++11.
- Documentation and examples updated to include enforcing the C++11 standard required by the updated TRNG C++ library.
- New function `check_rTRNG_linking()` allows checking whether C++ code using the TRNG library can be built and linked against rTRNG (#10).
- Package vignettes now use `check_rTRNG_linking()` to build C++ code using TRNG only on systems supporting it. This addresses the issues with re-building vignette outputs in the CRAN package checks on macOS (and Solaris), and is broadly documented in the package, including README and vignettes (#10).

# rTRNG 4.20-1

## Initial CRAN release

- Embed TRNG 4.20 C++ library.
- Expose parallel random number generators and distributions from the library to R. 
- Make TRNG accessible to other R projects' C++ code, via package dependency or `Rcpp::sourceCpp`.
- Vignettes and examples covering basic and advanced usage with both R and C++.
