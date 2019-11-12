# rTRNG 4.20-1.9000

## Maintenance release

- Underlying TRNG C++ library upgraded to version 4.22 (#6). This mainly includes: Fixing numerical convergence problems in the inverse of the incomplete Beta function; Removing support for C++ language standards older than C++11.
- Documentation and examples updated to include enforcing the C++11 standard required by the updated TRNG C++ library.

# rTRNG 4.20-1

## Initial CRAN release

- Embed TRNG 4.20 C++ library.
- Expose parallel random number generators and distributions from the library to R. 
- Make TRNG accessible to other R projects' C++ code, via package dependency or `Rcpp::sourceCpp`.
- Vignettes and examples covering basic and advanced usage with both R and C++.
