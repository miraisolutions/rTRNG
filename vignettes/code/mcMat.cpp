// ----- depends-h-ns
// [[Rcpp::depends(rTRNG)]]
#include <Rcpp.h>
#include <trng/normal_dist.hpp>
#include <trng/yarn2.hpp>
using namespace Rcpp;


// ----- mcMatRcpp
// [[Rcpp::export]]
NumericMatrix mcMatRcpp(const int nrow, const int ncol) {
  NumericMatrix M(nrow, ncol);
  trng::yarn2 r(12358);
  trng::normal_dist<> normal(0.0, 1.0);
  for (int i = 0; i < nrow; i++) {
    for (int j = 0; j < ncol; j++) {
      M(i, j) = normal(r);
    }
  }
  return M;
}
// -----

// ----- mcSubMatRcpp
// [[Rcpp::export]]
NumericMatrix mcSubMatRcpp(const int nrow, const int ncol,
                           const int startRow,
                           const int endRow,
                           const IntegerVector subCols) {
  NumericMatrix M(nrow, ncol);
  trng::yarn2 r(12358), rj;
  trng::normal_dist<> normal(0.0, 1.0);
  r.jump((startRow - 1) * ncol);
  for (IntegerVector::const_iterator jSub = subCols.begin();
       jSub < subCols.end(); jSub++) {
    int j = *jSub - 1;
    rj = r;
    rj.split(ncol, j);
    for (int i = startRow - 1; i < endRow; i++) {
      M(i, j) = normal(rj);
    }
  }
  return M;
}
// -----


/*** R
# Consistent sub-simulation
## ---- subMatExampleRcpp
rows <- 9
cols <- 5
startRow <- 4
endRow <- 6
subCols <- c(2, 4:5)
M <- mcMatRcpp(rows, cols)
S <- mcSubMatRcpp(rows, cols, startRow, endRow, subCols)
identical(M[startRow:endRow, subCols],
          S[startRow:endRow, subCols])
## ----
View(cbind.data.frame(M = M, S = S),
     "Consistent sub-simulation with Rcpp")
print(rbind.data.frame(M = M, S = S))
*/
