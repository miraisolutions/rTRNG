#include <trng/uniform_dist.hpp>
#include <trng/normal_dist.hpp>
#include <Rcpp.h>
#include <RcppParallel.h>

#include "Engine.h" // includes TRNG engine headers


using namespace Rcpp;
using namespace RcppParallel;
using namespace trng;


template<typename D, typename R>
struct TRNGWorker : public Worker {

  RVector<double> x;
  D dist;
  R rng0;

  // constructor
  TRNGWorker(D dist, R rng, NumericVector x)
    : x(x), dist(dist) {
    rng0 = rng; // DO NOT construct TRNG engines from existing ones!
  }

  // operator processing an exclusive range of indices
  void operator()(std::size_t begin, std::size_t end) {
    R rng = rng0;
    rng.jump(begin);
    std::size_t max = end; // good practice
    for (std::size_t i = begin; i < max; i++) {
      x[i] = dist(rng);
    }
  }

};

template<typename D, typename R>
NumericVector rdist(const int n, D dist, R& rng) {
  NumericVector x = NumericVector(n);
  NumericVector::iterator end = x.end();
  for (NumericVector::iterator it = x.begin(); it < end; it++) {
    *it = dist(rng);
  }
  return x;
}

// To be used with parallel random number engines only as they support the jump
// operation in the TRNGWorker
template<typename D, typename R>
NumericVector rdist(const int n, D dist, R& rng,
                    const long parallelGrain) {
  if (parallelGrain > 0) {
    NumericVector x = NumericVector(n);
    TRNGWorker<D,R> w(dist, rng, x);
    parallelFor(0, x.length(), w, parallelGrain);
    // align the incoming engine to what has been simulated in parallel
    rng.jump(x.length());
    return x;
  } else {
    // Note that one could call the Worker's operator() on the full range
    // TRNGWorker<D,R> w(dist, rng, x);
    // w(0, x.length());
    return rdist(n, dist, rng);
  }
}

template<typename D, typename R>
NumericVector rdist_S4(const int n, D dist, S4 engine,
                       const long parallelGrain) {
  // Extract a pointer to the underlying C++ Engine<R> object and then a pointer
  // to the underlying random number engine (we need a pointer in both cases to
  // keep updating the engine in the wrapper class).
  // Ideally, we would like to use Rcpp::as (constructor from SEXP), but it
  // makes a copy of the underlying rng
  R* rngptr = S4ToEnginePtr<R>(engine)->getRNGptr();
  return rdist(n, dist, *rngptr, parallelGrain);
}

template<typename D, typename R>
NumericVector rdist_S4(const int n, D dist, S4 engine) {
  R* rngptr = S4ToEnginePtr<R>(engine)->getRNGptr();
  return rdist(n, dist, *rngptr);
}


// The actual class of the R reference object is Rcpp_<engine_name>
#define ENGINE_DISPATCH(engine_class)                                       \
if (engine.is("Rcpp_" #engine_class)) {                                     \
  return rdist_S4<D,engine_class>(n, dist, engine);                         \
} else

#define PARALLEL_ENGINE_DISPATCH(engine_class)                              \
if (engine.is("Rcpp_" #engine_class)) {                                     \
  return rdist_S4<D,engine_class>(n, dist, engine, parallelGrain);          \
} else

// Check the R class and dispatch to the corresponding template function
template<typename D>
NumericVector rdist_dispatch(const int n, D dist,
                             S4 engine, const long parallelGrain = 0) {
  ENGINE_DISPATCH(lagfib2plus_19937_64)
  ENGINE_DISPATCH(lagfib2xor_19937_64)
  ENGINE_DISPATCH(lagfib4plus_19937_64)
  ENGINE_DISPATCH(lagfib4xor_19937_64)
  PARALLEL_ENGINE_DISPATCH(lcg64)
  PARALLEL_ENGINE_DISPATCH(lcg64_shift)
  PARALLEL_ENGINE_DISPATCH(mrg2)
  PARALLEL_ENGINE_DISPATCH(mrg3)
  PARALLEL_ENGINE_DISPATCH(mrg3s)
  PARALLEL_ENGINE_DISPATCH(mrg4)
  PARALLEL_ENGINE_DISPATCH(mrg5)
  PARALLEL_ENGINE_DISPATCH(mrg5s)
  ENGINE_DISPATCH(mt19937)
  ENGINE_DISPATCH(mt19937_64)
  PARALLEL_ENGINE_DISPATCH(yarn2)
  PARALLEL_ENGINE_DISPATCH(yarn3)
  PARALLEL_ENGINE_DISPATCH(yarn3s)
  PARALLEL_ENGINE_DISPATCH(yarn4)
  PARALLEL_ENGINE_DISPATCH(yarn5)
  PARALLEL_ENGINE_DISPATCH(yarn5s)
  {
    Rcpp::stop("supplied object is not of a valid wrapper class of a TRNG random number engine.");
    return -1;
  }
}


// [[Rcpp::export]]
NumericVector C_runif_trng(
    const int n, const double min, const double max,
    S4 engine, const long parallelGrain = 0) {
  uniform_dist<> dist(min, max);
  return rdist_dispatch(n, dist, engine, parallelGrain);
}

// [[Rcpp::export]]
NumericVector C_rnorm_trng(
    const int n, const double mean, const double sd,
    S4 engine, const long parallelGrain = 0) {
  normal_dist<> dist(mean, sd);
  return rdist_dispatch(n, dist, engine, parallelGrain);
}
