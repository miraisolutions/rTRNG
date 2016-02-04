// [[Rcpp::depends(RcppParallel)]]
#include <Rcpp.h>
#include <RcppParallel.h>
#include <trng/normal_dist.hpp>
#include <trng/yarn2.hpp>
using namespace Rcpp;
using namespace RcppParallel;

struct simTRNGWorker : public Worker
{
  RMatrix<double> ranMat;
  const RVector<int> subCols;
  
  // constructor
  simTRNGWorker(NumericMatrix ranMat, 
                const IntegerVector subCols) 
    : ranMat(ranMat), subCols(subCols) {}
  
  // operator processing an exclusive range of indices
  void operator()(std::size_t begin, std::size_t end) {
    trng::yarn2 r0, r;
    trng::normal_dist<> normal(0.0, 1.0);
    r0.jump((int)begin*ranMat.ncol());
    for (IntegerVector::const_iterator jSub = subCols.begin();
         jSub < subCols.end(); jSub++) {
      int j = *jSub-1;
      r = r0;
      r.split(ranMat.ncol(), j);
      for (int i = (int)begin; i < (int)end; i++) {
        ranMat(i, j) = normal(r);
      }
    }
  }
};

// [[Rcpp::export]]
int simTRNGParallel(NumericMatrix ranMat, 
               const IntegerVector subCols){
  simTRNGWorker w(ranMat, subCols);
  parallelFor(0, ranMat.nrow(), w);
  return(0);
}

