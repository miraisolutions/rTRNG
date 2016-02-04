#include <Rcpp.h>
#include <trng/normal_dist.hpp>
#include <trng/yarn2.hpp>

using namespace Rcpp;


// [[Rcpp::export]]
int simTRNG(NumericMatrix ranMat){
  trng::yarn2 r;
  trng::normal_dist<> normal(0.0, 1.0);
  for (int i = 0; i < ranMat.nrow(); i++) {
    for (int j = 0; j < ranMat.ncol(); j++) {
      ranMat(i, j) = normal(r);
    }
  }
  return(0);
}

// [[Rcpp::export]]
int simTRNGsub(NumericMatrix ranMat, 
               const int startRow, const int endRow,
               const IntegerVector subCols){
  trng::yarn2 r0, r;
  trng::normal_dist<> normal(0.0, 1.0);
  r0.jump((startRow-1)*ranMat.ncol());
  for (IntegerVector::const_iterator jSub = subCols.begin();
       jSub < subCols.end(); jSub++) {
    int j = *jSub-1;
    r = r0;
    r.split(ranMat.ncol(), j);
    for (int i = startRow-1; i < endRow; i++) {
      ranMat(i, j) = normal(r);
    }
  }
  return(0);
}

