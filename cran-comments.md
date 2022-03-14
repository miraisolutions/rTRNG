## CRAN submission request

This submission addresses an explicit request by the CRAN team to fix by 2022-03-16 a small issue in an Rd file which, when converted to HTML, has invalid image height attribute.
    
## Test environments

* local ubuntu 20.04, R 4.1.3
* ubuntu 20.04 (on GitHub Actions), R-oldrel 4.0.5, R-release 4.1.3, R-devel
* macOS (on GitHub Actions), R-oldrel 4.0.5, R-release 4.1.3, R-devel
* windows (on GitHub Actions), R-oldrel 4.0.5, R-release 4.1.3, R-devel
* docker-based R-devel compiled with valgrind level 2 instrumentation (on GitHub Actions)
* win-builder R-oldrelease 4.0.5, R-release 4.1.3, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 2 NOTEs

* checking installed package size ... NOTE
    * Compiled code in the libs/ directory.
    * Package vignettes in the doc/ directory.
* checking for GNU extensions in Makefiles ... NOTE
    * GNU make is a SystemRequirements.

## Reverse dependencies

The package has no reverse dependencies.
