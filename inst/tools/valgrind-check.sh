#!/bin/bash

# Run R CMD check with valgrind to collect and detect reported errors.
#
# It is used by the valgrind GH actions workflow and can also be run locally,
# provided Docker is available.

mkdir -p valgrind-check

# Note that we use -l and --install-args="--clean" in order to not have in the
# valgrind-check directory (uploaded as artifact in GH actions) some large
# directories and files produced as part of R CMD check
docker run --rm -v $(pwd):/rTRNG wch1/r-debug bash -c ' \
  RDvalgrind -e "install.packages(\"remotes\"); remotes::install_deps(\"rTRNG\", dependencies = TRUE)" \
  && RDvalgrind CMD build /rTRNG \
  && mkdir valgrind-check-lib \
  && RDvalgrind -d "valgrind --track-origins=yes" CMD check \
    -o /rTRNG/valgrind-check \
    -l valgrind-check-lib \
    --install-args="--clean" \
    --use-valgrind --no-stop-on-test-error \
    $(ls rTRNG_*.tar.gz) \
  '

# Collect valgrind "ERROR SUMMARY" lines from all log files
grep -ri "ERROR SUMMARY" valgrind-check/rTRNG.Rcheck --exclude-dir=*pkg_src > valgrind-check/valgrind-summary
cat valgrind-check/valgrind-summary
