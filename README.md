
<!-- README.md is generated from README.Rmd. Please edit that file -->
rTRNG: R package providing access and examples to TRNG C++ library
==================================================================

[![Travis-CI Build Status](https://travis-ci.org/miraisolutions/rTRNG.svg?branch=master)](https://travis-ci.org/miraisolutions/rTRNG) <!-- 
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/rTRNG)](https://cran.r-project.org/package=rTRNG)
-->

**[TRNG](https://numbercrunch.de/trng/)** (Tina's Random Number Generator) is a state of the art C++ pseudo-random number generator library for sequential and parallel Monte Carlo simulations. It provides a variety of random number engines (pseudo-random number generators) and distributions. In particular, *parallel* random number engines provided by TRNG can be manipulated by `jump` and `split` operations, thus enabling techniques such as *block-splitting* and *leapfrogging* suitable to parallel algorithms.

Package **rTRNG** provides the R users with access to the functionality of the underlying TRNG C++ library, both in R and as part of other projects combining R with C++.

An [introduction to **rTRNG**](https://user2017.sched.com/event/Axpj/rtrng-advanced-parallel-random-number-generation-in-r) \[[pdf](http://schd.ws/hosted_files/user2017/93/Mirai.rTRNG.useR2017.pdf)\] was presented at the useR!2017 conference, and is also available as package vignette:

``` r
vignette("rTRNG.useR2017", "rTRNG")
```

For more information and references, you can consult the package documentation page via `help("rTRNG-package")`.

Installation
------------

The package can be installed from our [github repository](https://github.com/miraisolutions/rTRNG) with:

``` r
# install.packages("devtools")
devtools::install_github("miraisolutions/rTRNG")
# in order to also build the vignettes, you'll have to run below instead
devtools::install_github("miraisolutions/rTRNG", build_vignettes = TRUE)
```

Examples
--------

### Use TRNG engines from R

Similar to base-R (`?Random`), **rTRNG** allows to select and manipulate a *current* TRNG engine of a given *kind* (e.g. yarn2), and to draw from it using any of the provided `r<dist>_trng` functions:

``` r
library(rTRNG)
TRNGkind("yarn2") 
TRNGseed(12358)
runif_trng(15)
#>  [1] 0.580259813 0.339434026 0.221393682 0.369402388 0.542678773
#>  [6] 0.002851459 0.123996486 0.346813776 0.121799416 0.947124450
#> [11] 0.336516569 0.128926181 0.380379891 0.550692382 0.436002654
```

The special `jump` and `split` operations can be applied to the current engine in a similar way:

``` r
TRNGseed(12358)
TRNGjump(6) # advance by 6 the internal state
TRNGsplit(5, 3) # generate one element every 5 starting from the 3rd
runif_trng(2)
#> [1] 0.1217994 0.5506924
#   => compare to the full sequence above
```

TRNG engines can also be created and manipulated directly as *Reference Class* objects, and passed as `engine` argument to `r<dist>_trng`:

``` r
rng <- yarn2$new()
rng$seed(12358)
rng$jump(6)
rng$split(5, 3)
runif_trng(2, engine = rng)
#> [1] 0.1217994 0.5506924
```

### Use TRNG from standalone C++

The TRNG C++ library is made available by **rTRNG** to standalone C++ code sourced with `Rcpp::sourceCpp` thanks to the `Rcpp::depends` attribute:

``` cpp
// [[Rcpp::depends(rTRNG)]]
#include <Rcpp.h>
#include <trng/yarn2.hpp>
#include <trng/uniform_dist.hpp>
// [[Rcpp::export]]
Rcpp::NumericVector exampleCpp() {
  trng::yarn2 rng(12358);
  rng.jump(6);
  rng.split(5, 2); // 0-based index
  Rcpp::NumericVector x(2);
  trng::uniform_dist<>unif(0, 1);
  for (unsigned int i = 0; i < 2; i++) {
    x[i] = unif(rng);
  }
  return x;
}
```

``` r
exampleCpp()
#> [1] 0.1217994 0.5506924
```

### Use TRNG from other R packges

Creating an R package with C++ code using the TRNG library via **rTRNG** is achieved by

-   adding `Imports: rTRNG` and `LinkingTo: rTRNG` to the DESCRIPTION file
-   importing one symbol in the NAMESPACE: `importFrom(rTRNG, TRNG.Version)`
-   setting the relevant linker flags in Makevars\[.win\] via `rTRNG::LdFlags()`
    -   Makevars: `PKG_LIBS += $(shell ${R_HOME}/bin/Rscript -e "rTRNG::LdFlags()")`
    -   Makevars.win: `PKG_LIBS += $(shell "${R_HOME}/bin${R_ARCH_BIN}/Rscript.exe" -e "rTRNG::LdFlags()")`

Build note
----------

If you try to build the package yourself from source and run `Rcpp::compileAttributes()` during the process, you need to use a version of **Rcpp &gt;= 0.12.11.2**. Earlier versions like 0.12.11 will not generate the desired `_rcpp_module_boot_trng` symbol in *RcppExports.cpp*.
