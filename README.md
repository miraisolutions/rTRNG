
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/rTRNG.svg" align="right" width="15%" height="15%"/>

# rTRNG: R package providing access and examples to TRNG C++ library

[![CRAN
status](http://www.r-pkg.org/badges/version/rTRNG)](https://cran.r-project.org/package=rTRNG)
[![R-CMD-check](https://github.com/miraisolutions/rTRNG/workflows/R-CMD-check/badge.svg)](https://github.com/miraisolutions/rTRNG/actions?query=workflow%3AR-CMD-check)
[![valgrind](https://github.com/miraisolutions/rTRNG/workflows/valgrind/badge.svg)](https://github.com/miraisolutions/rTRNG/actions?query=workflow%3Avalgrind)
[![Codecov
coverage](https://codecov.io/gh/miraisolutions/rTRNG/branch/master/graph/badge.svg)](https://app.codecov.io/gh/miraisolutions/rTRNG/branch/master)

**[TRNG](https://www.numbercrunch.de/trng/)** (Tina’s Random Number
Generator) is a state-of-the-art C++ pseudo-random number generator
library for sequential and parallel Monte Carlo simulations. It provides
a variety of random number engines (pseudo-random number generators) and
distributions. In particular, *parallel* random number engines provided
by TRNG can be manipulated by `jump` and `split` operations. These allow
to `jump` ahead by an arbitrary number of steps and to `split` a
sequence into any desired sub-sequence(s), thus enabling techniques such
as *block-splitting* and *leapfrogging* suitable to parallel algorithms.

Package **rTRNG** provides the R user with access to the functionality
of the underlying TRNG C++ library, both in R directly or more typically
as part of other projects combining R with C++.

An [introduction to
**rTRNG**](https://user2017.sched.com/event/Axpj/rtrng-advanced-parallel-random-number-generation-in-r)
\[[pdf](http://schd.ws/hosted_files/user2017/93/Mirai.rTRNG.useR2017.pdf)\]
was given at the useR!2017 conference, and is also available as package
vignette:

``` r
vignette("rTRNG.useR2017", "rTRNG")
```

The *sub-matrix simulation* vignette shows **rTRNG** in action for a
flexible *and* consistent (parallel) simulation of a matrix of Monte
Carlo variates:

``` r
vignette("mcMat", "rTRNG")
```

A full applied example of using **rTRNG** for the simulation of credit
defaults was presented at the [R/Finance
2017](http://past.rinfinance.com/agenda/2017/talk/RiccardoPorreca.pdf)
conference. The underlying code and data are hosted on
[GitHub](https://github.com/miraisolutions/PortfolioRiskMC), as is the
corresponding [R Markdown
output](https://rawgit.com/miraisolutions/PortfolioRiskMC/master/RinFinance2017/PortfolioSimAndRiskBig.html).

For more information and references, you can consult the package
documentation page via `help("rTRNG-package")`.

## Installation

You can install the package from CRAN:

``` r
install.packages("rTRNG")
```

The development version of **rTRNG** can be installed from our [GitHub
repository](https://github.com/miraisolutions/rTRNG) with:

``` r
# install.packages("remotes")
remotes::install_github("miraisolutions/rTRNG")
# in order to also build the vignettes, you'll have to run below instead
remotes::install_github("miraisolutions/rTRNG", build_vignettes = TRUE)
```

------------------------------------------------------------------------

*Build note*

If you try to build the package yourself from source and run
`Rcpp::compileAttributes()` during the process, you need to use a
version of **Rcpp &gt;= 0.12.11.2**. Earlier versions like 0.12.11 will
not generate the desired `_rcpp_module_boot_trng` symbol in
*RcppExports.cpp*.

## Examples

### Use TRNG engines from R

Similar to base-R (`?Random`), **rTRNG** allows to select and manipulate
a *current* TRNG engine of a given *kind* (e.g. yarn2), and to draw from
it using any of the provided `r<dist>_trng` functions:

``` r
library(rTRNG)
TRNGkind("yarn2") 
TRNGseed(12358)
runif_trng(15)
#>  [1] 0.58025981 0.33943403 0.22139368 0.36940239 0.54267877
#>  [6] 0.00285146 0.12399649 0.34681378 0.12179942 0.94712445
#> [11] 0.33651657 0.12892618 0.38037989 0.55069238 0.43600265
```

The special `jump` and `split` operations can be applied to the current
engine in a similar way:

``` r
TRNGseed(12358)
TRNGjump(6) # advance by 6 the internal state
TRNGsplit(5, 3) # subsequence: one element every 5 starting from the 3rd
runif_trng(2)
#> [1] 0.121799 0.550692
#   => compare to the full sequence above
```

TRNG engines can also be created and manipulated directly as *Reference
Class* objects, and passed as `engine` argument to `r<dist>_trng`:

``` r
rng <- yarn2$new()
rng$seed(12358)
rng$jump(6)
rng$split(5, 3)
runif_trng(2, engine = rng)
#> [1] 0.121799 0.550692
```

In addition, parallel generation of random variates can be enabled in
`r<dist>_trng` via `RcppParallel` using argument `parallelGrain > 0`:

``` r
TRNGseed(12358)
RcppParallel::setThreadOptions(numThreads = 2)
x_parallel <- rnorm_trng(1e5L, parallelGrain = 100L)
TRNGseed(12358)
x_serial <- rnorm_trng(1e5L)
identical(x_serial, x_parallel)
#> [1] TRUE
```

### Use TRNG from standalone C++

The TRNG C++ library is made available by **rTRNG** to standalone C++
code compiled with `Rcpp::sourceCpp` thanks to the `Rcpp::depends`
attribute, with `Rcpp::plugins(cpp11)` enforcing the C++11 standard
required by TRNG &gt;= 4.22:

``` cpp
// [[Rcpp::depends(rTRNG)]]
// TRNG >= 4.22 requires C++11
// [[Rcpp::plugins(cpp11)]]
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
#> [1] 0.121799 0.550692
```

### Use TRNG from other R packages

Creating an R package with C++ code using the TRNG library and headers
through **rTRNG** is achieved by

-   adding `Imports: rTRNG` and `LinkingTo: rTRNG` to the DESCRIPTION
    file
-   importing one symbol in the NAMESPACE:
    `importFrom(rTRNG, TRNG.Version)`
-   enforcing compilation using C++11 in Makevars\[.win\] via
    `CXX_STD = CXX11`
-   setting the relevant linker flags in Makevars\[.win\] via
    `rTRNG::LdFlags()`
    -   Makevars:
        `PKG_LIBS += $(shell ${R_HOME}/bin/Rscript -e "rTRNG::LdFlags()")`
    -   Makevars.win:
        `PKG_LIBS += $(shell "${R_HOME}/bin${R_ARCH_BIN}/Rscript.exe" -e "rTRNG::LdFlags()")`

### Note about C++ code on macOS

C++ code using the TRNG library (sourced via `Rcpp::sourceCpp` or part
of an R package) might fail on certain systems due to issues with
building and linking against **rTRNG**. This is typically the case for
**macOS**, and can generally be checked by running

``` r
rTRNG::check_rTRNG_linking()
```
