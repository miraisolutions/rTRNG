#include <RcppCommon.h>
#include "Engine.h" // includes TRNG engine headers


#define WRAP_DECLARE(engine) template<> SEXP wrap(const Engine<trng::engine>& obj)

namespace Rcpp {

  // no partial specialization of wrap => need full specialization
  WRAP_DECLARE(lagfib2plus_19937_64);
  WRAP_DECLARE(lagfib2xor_19937_64);
  WRAP_DECLARE(lagfib4plus_19937_64);
  WRAP_DECLARE(lagfib4xor_19937_64);
  WRAP_DECLARE(lcg64);
  WRAP_DECLARE(lcg64_shift);
  WRAP_DECLARE(mrg2);
  WRAP_DECLARE(mrg3);
  WRAP_DECLARE(mrg3s);
  WRAP_DECLARE(mrg4);
  WRAP_DECLARE(mrg5);
  WRAP_DECLARE(mrg5s);
  WRAP_DECLARE(mt19937);
  WRAP_DECLARE(mt19937_64);
  WRAP_DECLARE(yarn2);
  WRAP_DECLARE(yarn3);
  WRAP_DECLARE(yarn3s);
  WRAP_DECLARE(yarn4);
  WRAP_DECLARE(yarn5);
  WRAP_DECLARE(yarn5s);

  namespace traits {

  // no way to template wrap via partial specialization
  // template <typename R> SEXP wrap(const Engine<R>& obj);

    template <typename R> class Exporter<Engine<R> > {
    public:
      Exporter( SEXP x );
      inline Engine<R> get();
    private:
      Engine<R> t ;
    };
  }
}

#include <Rcpp.h>
