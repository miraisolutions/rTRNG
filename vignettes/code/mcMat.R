
# Simulation functions ----

## ---- mcMatR
mcMatR <- function(nrow, ncol) {
  r <- yarn2$new(12345)
  M <- matrix(rnorm.trng(nrow*ncol, engine = r),
              nrow = nrow, ncol = ncol, byrow = TRUE)
  M
}
## ----

## ---- mcSubMatR
mcSubMatR <- function(nrow, ncol,
                      startRow, endRow, subCols) {
  r <- yarn2$new(12345)
  r$jump((startRow-1)*ncol)
  nSubCols <- endRow-startRow+1
  S <- matrix(0.0, nrow, ncol)
  S[startRow:endRow, subCols] <-
    vapply(subCols,
           function(j) {
             rj = r$copy()
             rj$split(ncol, j)
             rnorm.trng(nSubCols, engine = rj)
           },
           FUN.VALUE = numeric(nSubCols))
  S
}
## ----

# Consistent sub-simulation ----
library(rTRNG)
## ---- subMatExampleR
rows <- 9
cols <- 5
M <- mcMatR(rows, cols)
startRow <- 4
endRow <- 6
subCols <- c(2, 4:5)
S <- mcSubMatR(rows, cols,
               startRow, endRow, subCols)
all.equal(M[startRow:endRow, subCols],
          S[startRow:endRow, subCols])
## ----
View(cbind.data.frame(M = M, S = S),
     "Consistent sub-simulation in R")
print(rbind.data.frame(M = M, S = S))
