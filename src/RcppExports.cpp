// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// C_runif_trng
NumericVector C_runif_trng(const int n, const double min, const double max, S4 engine, const long parallelGrain);
RcppExport SEXP rTRNG_C_runif_trng(SEXP nSEXP, SEXP minSEXP, SEXP maxSEXP, SEXP engineSEXP, SEXP parallelGrainSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const double >::type min(minSEXP);
    Rcpp::traits::input_parameter< const double >::type max(maxSEXP);
    Rcpp::traits::input_parameter< S4 >::type engine(engineSEXP);
    Rcpp::traits::input_parameter< const long >::type parallelGrain(parallelGrainSEXP);
    rcpp_result_gen = Rcpp::wrap(C_runif_trng(n, min, max, engine, parallelGrain));
    return rcpp_result_gen;
END_RCPP
}
// C_rnorm_trng
NumericVector C_rnorm_trng(const int n, const double mean, const double sd, S4 engine, const long parallelGrain);
RcppExport SEXP rTRNG_C_rnorm_trng(SEXP nSEXP, SEXP meanSEXP, SEXP sdSEXP, SEXP engineSEXP, SEXP parallelGrainSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const double >::type mean(meanSEXP);
    Rcpp::traits::input_parameter< const double >::type sd(sdSEXP);
    Rcpp::traits::input_parameter< S4 >::type engine(engineSEXP);
    Rcpp::traits::input_parameter< const long >::type parallelGrain(parallelGrainSEXP);
    rcpp_result_gen = Rcpp::wrap(C_rnorm_trng(n, mean, sd, engine, parallelGrain));
    return rcpp_result_gen;
END_RCPP
}

RcppExport SEXP _rcpp_module_boot_trng();

static const R_CallMethodDef CallEntries[] = {
    {"rTRNG_C_runif_trng", (DL_FUNC) &rTRNG_C_runif_trng, 5},
    {"rTRNG_C_rnorm_trng", (DL_FUNC) &rTRNG_C_rnorm_trng, 5},
    {"_rcpp_module_boot_trng", (DL_FUNC) &_rcpp_module_boot_trng, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_rTRNG(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}