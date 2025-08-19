# rTRNG (development version)

- Fix missing package anchors in the documentation (#33).
- Fix Mirai.rTRNG.useR2017.pdf URL in the README (#34).

# rTRNG 4.23.1-2

## Patch release

- Fix invalid image height property attribute in the documentation (#25).
- Fix redirected URLs in documentation (#28).
- Remove unnecessary `LazyData` in DESCRIPTION (#28).
- Maintenance of Continuous Integration GitHub Actions workflow (#26, #24).

# rTRNG 4.23.1-1

## Maintenance release

- Underlying TRNG C++ library upgraded to version 4.23.1 (#20). This is a maintenance release, mainly including: Enhanced numerical accuracy of several special mathematical functions; Re-implementation of the discard method of the lagged Fibonacci generators with logarithmic asymptotic complexity. The release also fixes the uninitialized-memory problems reported as `valgrind` issues in the CRAN package checks for rTRNG 4.20-1 (#16).
- Unit tests for "invalid argument" errors are now robust to systems where the error class does not propagate correctly to R, such as R 3.6.3 on macOS (#15). This addresses the errors running tests in the CRAN package checks on macOS.
- Continuous integration is now based on GitHub Actions and covers R-release, R-oldrel and R-devel on Ubuntu, macOS and Windows (#14), as well as running checks with `valgrind` (#20).

# rTRNG 4.22-1

## Maintenance release (GitHub only)

- Underlying TRNG C++ library upgraded to version 4.22 (#6). This mainly includes: Fixing numerical convergence problems in the inverse of the incomplete Beta function; Removing support for C++ language standards older than C++11.
- Documentation and examples updated to include enforcing the C++11 standard required by the updated TRNG C++ library.
- New function `check_rTRNG_linking()` allows checking whether C++ code using the TRNG library can be built and linked against rTRNG (#10).
- Package vignettes now use `check_rTRNG_linking()` to build C++ code using TRNG only on systems supporting it. This addresses the vignette re-building issues in the CRAN package checks on macOS (and Solaris), and is broadly documented in the package, including README and vignettes (#10).

# rTRNG 4.20-1

## Initial CRAN release

- Embed TRNG 4.20 C++ library.
- Expose parallel random number generators and distributions from the library to R. 
- Make TRNG accessible to other R projects' C++ code, via package dependency or `Rcpp::sourceCpp`.
- Vignettes and examples covering basic and advanced usage with both R and C++.
