## CRAN resubmission

In this resubmission I have dropped the C++11 specification to fix the remaining NOTE from "checking C++ specification".

The original submission addressed an explicit request by the CRAN Team to fix by 2025-09-01 the NOTEs about Rd file(s) with Rd \link{} targets missing package anchors in the "Rd cross-references" check.

## Test environments

* local ubuntu 22.04, R 4.5.1
* ubuntu 24.04 (on GitHub Actions), R-oldrel 4.4.3, R-release 4.5.1, R-devel
* macOS (on GitHub Actions), R-oldrel 4.4.3, R-release 4.5.1, R-devel
* windows (on GitHub Actions), R-oldrel 4.4.3, R-release 4.5.1, R-devel
* docker-based R-devel compiled with valgrind level 2 instrumentation (on GitHub Actions)
* win-builder R-oldrelease 4.4.3, R-release 4.5.1, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTEs

On win-builder R-release and R-devel, there are URLs in the README occasionally reported as possibly invalid in an additional NOTE:

* checking CRAN incoming feasibility ... NOTE
  Found the following (possibly) invalid URLs:
  URL: https://static.sched.com/hosted_files/user2017/93/Mirai.rTRNG.useR2017.pdf
  URL: https://user2017.sched.com/event/Axpj/rtrng-advanced-parallel-random-number-generation-in-r

These are false positives, as the URLs are valid.

## Reverse dependencies

The package has no reverse dependencies.
