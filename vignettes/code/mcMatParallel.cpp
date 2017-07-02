#include <Rcpp.h>
#include <RcppParallel.h>
#include <trng/normal_dist.hpp>
#include <trng/yarn2.hpp>

using namespace Rcpp;
using namespace RcppParallel;

// [[Rcpp::depends(rTRNG, RcppParallel)]]


// ----- mcMatRcppParallel
struct MCMatWorker : public Worker
{
  RMatrix<double> M;
  const RVector<int> subCols;

  // constructor
  MCMatWorker(NumericMatrix M,
              const IntegerVector subCols)
    : M(M), subCols(subCols) {}

  // operator processing an exclusive range of indices
  void operator()(std::size_t begin, std::size_t end) {
    trng::yarn2 r(12358), rj;
    trng::normal_dist<> normal(0.0, 1.0);
    r.jump((int)begin*M.ncol());
    for (IntegerVector::const_iterator jSub = subCols.begin();
         jSub < subCols.end(); jSub++) {
      int j = *jSub-1;
      rj = r;
      rj.split(M.ncol(), j);
      for (int i = (int)begin; i < (int)end; i++) {
        M(i, j) = normal(rj);
      }
    }
  }
};
// [[Rcpp::export]]
NumericMatrix mcMatRcppParallel(const int nrow, const int ncol,
                       const IntegerVector subCols) {
  NumericMatrix M(nrow, ncol);
  MCMatWorker w(M, subCols);
  parallelFor(0, M.nrow(), w);
  return M;
}
//----


/*** R
rows <- 9
cols <- 5
subCols <- c(2, 4:5)
# Consistent parallel full simulation
## ---- fullMatExampleRcppParallel
M <- mcMatRcpp(rows, cols)
Mp <- mcMatRcppParallel(rows, cols, seq_len(ncol(M)))
all.equal(M, Mp)
## ----
# Consistent parallel sub-simulation
## ---- subMatExampleRcppParallel
Sp <- mcMatRcppParallel(rows, cols, subCols)
all.equal(M[, subCols],
          Sp[, subCols])
# ----
View(cbind.data.frame(M = M, Sp = Sp),
     "Consistent parallel sub-simulation with RcppParallel")
print(rbind.data.frame(M = M, Sp = Sp))
*/