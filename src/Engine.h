#if !(defined RTRNG_ENGINE_H)

#define RTRNG_ENGINE_H


#include <Rcpp.h>
#include <trng/lagfib2plus.hpp>
#include <trng/lagfib2xor.hpp>
#include <trng/lagfib4plus.hpp>
#include <trng/lagfib4xor.hpp>
#include <trng/lcg64.hpp>
#include <trng/lcg64_shift.hpp>
#include <trng/mrg2.hpp>
#include <trng/mrg3.hpp>
#include <trng/mrg3s.hpp>
#include <trng/mrg4.hpp>
#include <trng/mrg5.hpp>
#include <trng/mrg5s.hpp>
#include <trng/mt19937.hpp>
#include <trng/mt19937_64.hpp>
#include <trng/yarn2.hpp>
#include <trng/yarn3.hpp>
#include <trng/yarn3s.hpp>
#include <trng/yarn4.hpp>
#include <trng/yarn5.hpp>
#include <trng/yarn5s.hpp>


template<typename R>
R stringToRNG(const std::string);

template<typename R>
std::string RNGToString(R);


// Wrapper class whose members will be exposed to R via RCPP_MODULE.
// NOTE that jump and split will be defined and exposed as free functions to be
// used in RCPP_MODULE, in order to have the Engine class template wrapping both
// conventional and parallel TRNG engines
template<typename R>
class Engine {

private:

  R rng;
  // name/kind as exposed to R
  const static std::string rTRNGname;
  // handle the lagfib* name to align it with the name/kind exposed to R
  static std::string getrTRNGname();

public:

  Engine(const Engine&); // copy constructor
  Engine();
  Engine(unsigned long);
  Engine(std::string);
  Engine(SEXP);

  Engine copy();

  R* getRNGptr();
  void seed(unsigned long);
  std::string name();
  std::string toString();
  Rcpp::CharacterVector _Random_seed();
  void show();

};


template<typename R>
Engine<R>* S4ToEnginePtr(Rcpp::S4 obj);


#endif
