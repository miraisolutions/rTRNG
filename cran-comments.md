## Test environments

* local ubuntu 18.04, R 4.0.3
* ubuntu 20.04 (on GitHub Actions), R-oldrel 3.6.3, R-release 4.0.3, R-devel
* macOS (on GitHub Actions), R-oldrel 3.6.3, R-release 4.0.3, R-devel
* windows (on GitHub Actions), R-oldrel 3.6.3, R-release 4.0.3, R-devel
* docker-based R-devel compiled with valgrind level 2 instrumentation (locally and on GitHub Actions)
* win-builder R-oldrelease 3.6.3, R-release 4.0.3, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 2 NOTEs

* checking installed package size ... NOTE
    * Compiled code in the libs/ directory.
    * Package vignettes in the doc/ directory.
* checking for GNU extensions in Makefiles ... NOTE
    * GNU make is a SystemRequirements.

## CRAN checks problems

Note that there was an explicitly request by the CRAN team to fix by 2021-01-29 the problems shown on <https://cran.r-project.org/web/checks/check_results_rTRNG.html> in order to retain the package on CRAN. This submission is meant to address all issues, as detailed in the NEWS.md file and supported by the broad scope of the 'Test environments' above.
    
## Reverse dependencies

The package has no reverse dependencies.
