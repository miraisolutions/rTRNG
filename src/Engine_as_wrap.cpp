#include "Engine_as_wrap.h"


using namespace Rcpp;
using namespace trng;


template <typename R>
SEXP wrap(const Engine<R>& obj) {
  XPtr<Engine<R> > xp(new Engine<R>(obj), true); // copy and mark as finalizable
  Function maker = Environment::Rcpp_namespace()["cpp_object_maker"];
  return maker(typeid(Engine<R>).name(), xp);
}

#define WRAP_IMPLEMENT(engine)                                   \
template<> SEXP Rcpp::wrap(const Engine<trng::engine>& obj) {    \
  return wrap<engine>(obj);                                      \
}
// no partial specialization of wrap => need full specialization
WRAP_IMPLEMENT(lagfib2plus_19937_64);
WRAP_IMPLEMENT(lagfib2xor_19937_64);
WRAP_IMPLEMENT(lagfib4plus_19937_64);
WRAP_IMPLEMENT(lagfib4xor_19937_64);
WRAP_IMPLEMENT(lcg64);
WRAP_IMPLEMENT(lcg64_shift);
WRAP_IMPLEMENT(mrg2);
WRAP_IMPLEMENT(mrg3);
WRAP_IMPLEMENT(mrg3s);
WRAP_IMPLEMENT(mrg4);
WRAP_IMPLEMENT(mrg5);
WRAP_IMPLEMENT(mrg5s);
WRAP_IMPLEMENT(mt19937);
WRAP_IMPLEMENT(mt19937_64);
WRAP_IMPLEMENT(yarn2);
WRAP_IMPLEMENT(yarn3);
WRAP_IMPLEMENT(yarn3s);
WRAP_IMPLEMENT(yarn4);
WRAP_IMPLEMENT(yarn5);
WRAP_IMPLEMENT(yarn5s);

template <typename R>
Rcpp::traits::Exporter<Engine<R> >::Exporter(SEXP x) : t(x){}

template <typename R>
inline Engine<R> Rcpp::traits::Exporter<Engine<R> >::get(){
  return t;
}
