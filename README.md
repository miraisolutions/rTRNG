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

```
devtools::install_github("miraisolutions/rTRNG")
```

For an introduction to the package, refer to the package documentation page via
`help("rTRNG-package")`.
