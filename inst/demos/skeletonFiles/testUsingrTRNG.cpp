#include <Rcpp.h>
#include <trng/yarn2.hpp>
#include <trng/uniform_dist.hpp>
using namespace Rcpp;
using namespace trng;

// [[Rcpp::export]]
NumericVector testUsingrTRNG(const long n) {
  yarn2 rng;
  uniform_dist<> unif(0, 1);
  NumericVector x = NumericVector(n);
  NumericVector::iterator end = x.end();
  for (NumericVector::iterator it = x.begin(); it < end; it++) {
    *it = unif(rng);
  }
  return x;

}
