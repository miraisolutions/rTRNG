## CRAN submission request

This submission addresses an explicit request by the CRAN Team to fix by 2026-03-02 the R-devel WARNINGs about "ciso646 is not a standard header since C++20".

## Test environments

* local ubuntu 24.04, R 4.5.2
* local Fedora 42 (Docker container), R-devel, gcc 15.2.1
* ubuntu 24.04 (on GitHub Actions), R-oldrel 4.4.3, R-release 4.5.2, R-devel
* macOS (on GitHub Actions), R-oldrel 4.4.3, R-release 4.5.2, R-devel
* windows (on GitHub Actions), R-oldrel 4.4.3, R-release 4.5.2, R-devel
* docker-based R-devel compiled with valgrind level 2 instrumentation (on GitHub Actions)
* win-builder R-oldrelease 4.4.3, R-release 4.5.2, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTEs

## Reverse dependencies

The package has no reverse dependencies.
