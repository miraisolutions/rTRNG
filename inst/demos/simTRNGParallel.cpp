#include <Rcpp.h>
#include <RcppParallel.h>
#include <trng/normal_dist.hpp>
#include <trng/yarn2.hpp>


using namespace Rcpp;
using namespace RcppParallel;


// [[Rcpp::depends(rTRNG,RcppParallel)]]


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


/*** R

# Multi-Thread fair-playing full simulation
X <- (matrix(0.0, 9, 5))
res <- simTRNG(X)
for (nThread in 1:4) {
  RcppParallel::setThreadOptions(nThread)
  parX <- (matrix(0.0, 9, 5))
  res <- simTRNGParallel(parX, subCols = c(1:5))
  print(paste(nThread, "threads, all.equal?", all.equal(X, parX)))
}
X <- (matrix(0.0, 9, 5))
res <- simTRNG(X)
parSubX <- (matrix(0.0, 9, 5))
res <- simTRNGParallel(parSubX, subCols = c(2, 4:5))
View(cbind.data.frame(X = X, parSubX = parSubX), "Consistent parallel sub-simulation")
print(rbind.data.frame(X = X, parSubX = parSubX))

*/
