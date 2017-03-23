#include <Rcpp.h>
#include "Engine.h" // includes TRNG engine headers
#include "Engine_as_wrap.h"


using namespace Rcpp;
using namespace trng;


// Free functions for jump and split, to be exposed for parallel engines only.
// NOTE that we need signed types to handle negative values passed from R.
template<typename I>
void checkPositive(I x, std::string err_msg = "negative values not allowed") {
  if (x < 0) {
    stop(err_msg);
  }
}
template<typename R>
void jump(Engine<R>* e, long steps){
  checkPositive(steps, "negative values of steps in method jump not allowed");
  e->getRNGptr()->jump(steps);
}
template<typename R>
void split(Engine<R>* e, int p, int s){
  // R-style index s in [1,p] to be exposed to R, hence passed as s-1
  checkPositive(p, "negative values of p in method split not allowed");
  checkPositive(s, "negative values of s in method split not allowed");
  e->getRNGptr()->split(p, s-1);
}

// Validity check on constructor argument, required since we have two unary
// constructors.
bool validNonSTRSXP(SEXP* args, int nargs){
  return nargs == 1 && TYPEOF(args[0]) != STRSXP;
}
bool validSTRSXP(SEXP* args, int nargs){
  return nargs == 1 && TYPEOF(args[0]) == STRSXP;
}

#define DOCSTRING "?TRNG.Engine"
#define ENGINE_MODULE(R)                                        \
class_<Engine<R> >(#R)                                          \
  .constructor()                                                \
  .constructor<unsigned long>("", &validNonSTRSXP)              \
  .constructor<std::string>("", &validSTRSXP)                   \
  .method("copy", &Engine<R>::copy, DOCSTRING)                  \
  .method("seed", &Engine<R>::seed, DOCSTRING)                  \
  .method("toString", &Engine<R>::toString, DOCSTRING)          \
  .method("name", &Engine<R>::name, DOCSTRING)                  \
  .method("kind", &Engine<R>::name, DOCSTRING)                  \
  .method("show", &Engine<R>::show, DOCSTRING)                  \
  .method(".Random.seed", &Engine<R>::_Random_seed, DOCSTRING)

#define PARALLEL_ENGINE_MODULE(R)                               \
ENGINE_MODULE(R)                                                \
  .method("jump", &jump<R>, DOCSTRING)                          \
  .method("split", &split<R>, DOCSTRING)


RCPP_MODULE(trng){
  using namespace Rcpp;
  // only expose _19937_64 lagfib* generators
  ENGINE_MODULE(lagfib2plus_19937_64);
  ENGINE_MODULE(lagfib2xor_19937_64);
  ENGINE_MODULE(lagfib4plus_19937_64);
  ENGINE_MODULE(lagfib4xor_19937_64);
  PARALLEL_ENGINE_MODULE(lcg64);
  PARALLEL_ENGINE_MODULE(lcg64_shift);
  PARALLEL_ENGINE_MODULE(mrg2);
  PARALLEL_ENGINE_MODULE(mrg3);
  PARALLEL_ENGINE_MODULE(mrg3s);
  PARALLEL_ENGINE_MODULE(mrg4);
  PARALLEL_ENGINE_MODULE(mrg5);
  PARALLEL_ENGINE_MODULE(mrg5s);
  ENGINE_MODULE(mt19937);
  ENGINE_MODULE(mt19937_64);
  PARALLEL_ENGINE_MODULE(yarn2);
  PARALLEL_ENGINE_MODULE(yarn3);
  PARALLEL_ENGINE_MODULE(yarn3s);
  PARALLEL_ENGINE_MODULE(yarn4);
  PARALLEL_ENGINE_MODULE(yarn5);
  PARALLEL_ENGINE_MODULE(yarn5s);
}
