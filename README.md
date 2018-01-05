# rTRNG: R package providing access and examples to TRNG C++ library

[TRNG](https://numbercrunch.de/trng/) (Tina's Random Number Generator) is a state
of the art C++ pseudo-random number generator library for sequential and
parallel Monte Carlo simulations. It provides a variety of random number engines
(pseudo-random number generators) and distributions. In particular, *parallel*
random number engines provided by TRNG can be manipulated by `jump` and `split`
operations and hence are suitable to parallel algorithms.

Package **rTRNG** provides the R users with access to the 
functionality of the underlying TRNG C++ library, both in R as part of other 
projects combining R with C++.

The package can easily be installed from our [github repository](https://github.com/miraisolutions/rTRNG) using the
excellent [devtools](https://github.com/hadley/devtools) package:

```r
devtools::install_github("miraisolutions/rTRNG")

# in order to also build the vignettes, you'll have to run below instead
devtools::install_github("miraisolutions/rTRNG", build_vignettes = TRUE)
```

For an introduction to the package, refer to the package documentation page via
`help("rTRNG-package")`.

-----------------

### Build note

If you try to build the package yourself from source and run `Rcpp::compileAttributes()` during the process, you
need to use a version of **Rcpp >= 0.12.11.2**. Earlier versions like 0.12.11 will not generate the desired
`_rcpp_module_boot_trng` symbol in *RcppExports.cpp*.
