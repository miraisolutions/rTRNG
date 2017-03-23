#include "Engine.h"
#include "Engine_as_wrap.h"


using namespace Rcpp;


template<typename R>
R stringToRNG(std::string s) {
  R rng;
  std::istringstream is;
  is.str(s);
  is >> rng;
  if (is.fail()) {
    Rcpp::stop("failed to restore '" + std::string(rng.name()) + "' " +
      "random number engine from string: \"" + s + "\"");
  }
  return rng;
}

template<typename R>
std::string RNGToString(R rng) {
  std::ostringstream os;
  os << rng;
  return os.str();
}

template<typename R>
Engine<R>* S4ToEnginePtr(S4 obj) {
  Environment env(obj);
  XPtr<Engine<R> > xptr(env.get(".pointer"));
  Engine<R>* engineptr = static_cast<Engine<R>*>(R_ExternalPtrAddr(xptr));
  return engineptr;
}

// Implementation of Engine<R> class template

template<typename R>
std::string Engine<R>::getrTRNGname(){
  std::string name = R::name();
  // Special handling of lagfib* engines: reconstruct the typdef by keeping the
  // last token and appending the first (number of bits)
  if (name.find("lagfib") < std::string::npos) {
    size_t first_ = name.find("_");
    size_t last_ = name.rfind("_");
    std::string suffix = name.substr(first_+1);
    name = name.substr(0, first_) + name.substr(last_)+ "_" + suffix.substr(0, suffix.find("_"));
  }
  return name;
}

template<typename R>
const std::string Engine<R>::rTRNGname = Engine<R>::getrTRNGname();

// copy constructor
template<typename R>
Engine<R>::Engine(const Engine<R>& that) {
  rng = that.rng; // copies the underlying TRNG random engine
}

template<typename R>
Engine<R>::Engine() {
  rng = R();
}

template<typename R>
Engine<R>::Engine(unsigned long seed) {
  rng = R(seed);
}

template<typename R>
Engine<R>::Engine(std::string rng_string) {
  // in case of empty string use the default constructor
  if (rng_string.size() > 0) {
    rng = stringToRNG<R>(rng_string);
  } else {
    Engine();
  }
}

template<typename R>
Engine<R>::Engine(SEXP obj) {
  rng = S4ToEnginePtr<R>(obj)->rng; // implicit as<S4>
}

template<typename R>
Engine<R> Engine<R>::copy() {
  Engine<R> copied(*this);
  return copied;
}

template<typename R>
R* Engine<R>::getRNGptr() {
  return &rng;
}

template<typename R>
void Engine<R>::seed(unsigned long s){
  rng.seed(s);
}

template<typename R>
std::string Engine<R>::name(){
  return rTRNGname;
}

template<typename R>
std::string Engine<R>::toString(){
  return RNGToString(rng);
}

template<typename R>
CharacterVector Engine<R>::_Random_seed(){
  using namespace Rcpp;
  return CharacterVector::create(name(), toString());
}

#define MAX_SHOW 80
template<typename R>
void Engine<R>::show(){
  std::string s = toString();
  if (s.length() > MAX_SHOW) {
    s = s.substr(0, MAX_SHOW-4) + "..." + s.substr(s.length()-1, 1);
  }
  Rcpp::Rcout << s << std::endl;
}


// Declare all specializations of the class template Engine<R> to avoid linker
// errors
using namespace trng;
template class Engine<lagfib2plus_19937_64>;
template class Engine<lagfib2xor_19937_64>;
template class Engine<lagfib4plus_19937_64>;
template class Engine<lagfib4xor_19937_64>;
template class Engine<lcg64>;
template class Engine<lcg64_shift>;
template class Engine<mrg2>;
template class Engine<mrg3>;
template class Engine<mrg3s>;
template class Engine<mrg4>;
template class Engine<mrg5>;
template class Engine<mrg5s>;
template class Engine<mt19937>;
template class Engine<mt19937_64>;
template class Engine<yarn2>;
template class Engine<yarn3>;
template class Engine<yarn3s>;
template class Engine<yarn4>;
template class Engine<yarn5>;
template class Engine<yarn5s>;
