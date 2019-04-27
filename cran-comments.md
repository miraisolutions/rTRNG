## Resubmission (2)

This is a second resubmission. Requests and comments were addressed as follows.

* 'TRNG' was added in parentheses after "Tina's Random Number Generator" in the
Description field for clarification.

* The Description field mentions package vignettes and examples illustrating the methods behind 'TRNG', and includes a reference to the PDF manual or 'TRNG'.

* Note that all relevant exported functionality is covered by extensive examples (in the Rd files) and unit tests, and is described in action in the automatically-built R-markdown vignettes. Exceptions are the simple, zero-argument, constant-return functions defaultKind() and TRNG.Version(). A special case is function LdFlags(), which is meant for usage in Makevars.[win] of other packages, as described in the Rd file similar to other Rcpp packages (e.g. 'RcppParallel'). The effectiveness of the underlying internal function rTRNGLdFlags() is indirectly covered by the R-markdown vignettes using Rcpp::sourceCpp().


## Resubmission

This is a resubmission. In this version I have:
* Single-quoted software names 'TRNG' and 'RcppParallel' in both Title and Description fields.

Note that no reference about the methods behind 'TRNG' is available in the form Authors (year) <doi:.....>, to be included in the Description field. The main reference is the PDF manual of 'TRNG', which is listed among the References in the relevant man pages of the package.



This is a new release.

## Test environments
* local ubuntu 18.04, R 3.5.3
* ubuntu 14.04 (on travis-ci), R-oldrel 3.4.4, R-release 3.5.3, R-devel
* win-builder R-oldrelease 3.4.4, R-release 3.5.3, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 3 NOTEs

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Riccardo Porreca <riccardo.porreca@mirai-solutions.com>’
    * New submission, the maintainer address is correct
* checking installed package size ... NOTE
    * Compiled code in the libs/ directory.
    * Package vignettes in the doc/ directory.
* checking for GNU extensions in Makefiles ... NOTE
    * GNU make is a SystemRequirements.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.
