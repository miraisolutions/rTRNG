#include <Rcpp.h>
#include <trng/yarn2.hpp>
#include <trng/uniform_dist.hpp>

using namespace Rcpp;
using namespace trng;

// [[Rcpp::export]]
List trng_hello_world() {

  yarn2 rngx, rngy, rngz;
  uniform_dist<> unif(0, 1);

  // full sequential simulation
  NumericVector x = NumericVector(15);
  for (NumericVector::iterator it = x.begin(); it < x.end(); it++) {
    *it = unif(rngx);
  }

  // jump and simulate
  NumericVector y = NumericVector(10);
  rngy.jump(5);
  for (NumericVector::iterator it = y.begin(); it < y.end(); it++) {
    *it = unif(rngy);
  }

  // split and simulate a subsequence
  NumericVector z = NumericVector(3);
  rngz.split(5, 3);
  for (NumericVector::iterator it = z.begin(); it < z.end(); it++) {
    *it = unif(rngz);
  }

  List out = List::create(x, y, z) ;
  out.names() = CharacterVector::create("full", "jump", "split");

  return out;
}
