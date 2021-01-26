// Copyright (c) 2000-2020, Heiko Bauke
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
//   * Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//
//   * Redistributions in binary form must reproduce the above
//     copyright notice, this list of conditions and the following
//     disclaimer in the documentation and/or other materials provided
//     with the distribution.
//
//   * Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived
//     from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
// OF THE POSSIBILITY OF SUCH DAMAGE.

#if !(defined TRNG_PARETO_DIST_HPP)

#define TRNG_PARETO_DIST_HPP

#include <trng/cuda.hpp>
#include <trng/limits.hpp>
#include <trng/utility.hpp>
#include <trng/math.hpp>
#include <ostream>
#include <istream>
#include <iomanip>
#include <cerrno>
#include <ciso646>

namespace trng {

  // uniform random number generator class
  template<typename float_t = double>
  class pareto_dist {
  public:
    using result_type = float_t;

    class param_type {
    private:
      result_type gamma_{1}, theta_{1};

    public:
      TRNG_CUDA_ENABLE
      result_type gamma() const { return gamma_; }
      TRNG_CUDA_ENABLE
      void gamma(result_type gamma_new) { gamma_ = gamma_new; }
      TRNG_CUDA_ENABLE
      result_type theta() const { return theta_; }
      TRNG_CUDA_ENABLE
      void theta(result_type theta_new) { theta_ = theta_new; }
      TRNG_CUDA_ENABLE
      param_type() = default;
      TRNG_CUDA_ENABLE
      explicit param_type(result_type gamma, result_type theta)
          : gamma_{gamma}, theta_{theta} {}

      friend class pareto_dist;

      // Streamable concept
      template<typename char_t, typename traits_t>
      friend std::basic_ostream<char_t, traits_t> &operator<<(
          std::basic_ostream<char_t, traits_t> &out, const param_type &P) {
        std::ios_base::fmtflags flags(out.flags());
        out.flags(std::ios_base::dec | std::ios_base::fixed | std::ios_base::left);
        out << '(' << std::setprecision(math::numeric_limits<float_t>::digits10 + 1)
            << P.gamma() << ' ' << P.theta() << ')';
        out.flags(flags);
        return out;
      }

      template<typename char_t, typename traits_t>
      friend std::basic_istream<char_t, traits_t> &operator>>(
          std::basic_istream<char_t, traits_t> &in, param_type &P) {
        float_t gamma, theta;
        std::ios_base::fmtflags flags(in.flags());
        in.flags(std::ios_base::dec | std::ios_base::fixed | std::ios_base::left);
        in >> utility::delim('(') >> gamma >> utility::delim(' ') >> theta >>
            utility::delim(')');
        if (in)
          P = param_type(gamma, theta);
        in.flags(flags);
        return in;
      }
    };

  private:
    param_type P;

  public:
    // constructor
    TRNG_CUDA_ENABLE
    explicit pareto_dist(result_type gamma, result_type theta) : P{gamma, theta} {}
    TRNG_CUDA_ENABLE
    explicit pareto_dist(const param_type &P) : P{P} {}
    // reset internal state
    TRNG_CUDA_ENABLE
    void reset() {}
    // random numbers
    template<typename R>
    TRNG_CUDA_ENABLE result_type operator()(R &r) {
      return (math::pow(utility::uniformoo<result_type>(r), -1 / P.gamma()) - 1) * P.theta();
    }
    template<typename R>
    TRNG_CUDA_ENABLE result_type operator()(R &r, const param_type &p) {
      pareto_dist g(p);
      return g(r);
    }
    // property methods
    TRNG_CUDA_ENABLE
    result_type min() const { return 0; }
    TRNG_CUDA_ENABLE
    result_type max() const { return math::numeric_limits<result_type>::infinity(); }
    TRNG_CUDA_ENABLE
    param_type param() const { return P; }
    TRNG_CUDA_ENABLE
    void param(const param_type &P_new) { P = P_new; }
    TRNG_CUDA_ENABLE
    result_type gamma() const { return P.gamma(); }
    TRNG_CUDA_ENABLE
    void gamma(result_type gamma_new) { P.gamma(gamma_new); }
    TRNG_CUDA_ENABLE
    result_type theta() const { return P.theta(); }
    TRNG_CUDA_ENABLE
    void theta(result_type theta_new) { P.theta(theta_new); }
    // probability density function
    TRNG_CUDA_ENABLE
    result_type pdf(result_type x) const {
      if (x < 0)
        return 0;
      return P.gamma() / P.theta() * math::pow(1 + x / P.theta(), -P.gamma() - 1);
    }
    // cumulative density function
    result_type cdf(result_type x) const {
      if (x <= 0)
        return 0;
      return 1 - math::pow(1 + x / P.theta(), -P.gamma());
    }
    // inverse cumulative density function
    result_type icdf(result_type x) const {
      if (x <= 0 or x >= 1) {
#if !(defined __CUDA_ARCH__)
        errno = EDOM;
#endif
        return math::numeric_limits<result_type>::quiet_NaN();
      }
      if (x == 0)
        return 0;
      if (x == 1)
        return math::numeric_limits<result_type>::infinity();
      return (math::pow((1 - x), -1 / P.gamma()) - 1) * P.theta();
    }
  };

  // -------------------------------------------------------------------

  // EqualityComparable concept
  template<typename float_t>
  TRNG_CUDA_ENABLE inline bool operator==(const typename pareto_dist<float_t>::param_type &P1,
                                          const typename pareto_dist<float_t>::param_type &P2) {
    return P1.gamma() == P2.gamma() and P1.theta() == P2.theta();
  }

  template<typename float_t>
  TRNG_CUDA_ENABLE inline bool operator!=(const typename pareto_dist<float_t>::param_type &P1,
                                          const typename pareto_dist<float_t>::param_type &P2) {
    return not(P1 == P2);
  }

  // -------------------------------------------------------------------

  // EqualityComparable concept
  template<typename float_t>
  TRNG_CUDA_ENABLE inline bool operator==(const pareto_dist<float_t> &g1,
                                          const pareto_dist<float_t> &g2) {
    return g1.param() == g2.param();
  }

  template<typename float_t>
  TRNG_CUDA_ENABLE inline bool operator!=(const pareto_dist<float_t> &g1,
                                          const pareto_dist<float_t> &g2) {
    return g1.param() != g2.param();
  }

  // Streamable concept
  template<typename char_t, typename traits_t, typename float_t>
  std::basic_ostream<char_t, traits_t> &operator<<(std::basic_ostream<char_t, traits_t> &out,
                                                   const pareto_dist<float_t> &g) {
    std::ios_base::fmtflags flags(out.flags());
    out.flags(std::ios_base::dec | std::ios_base::fixed | std::ios_base::left);
    out << "[pareto " << g.param() << ']';
    out.flags(flags);
    return out;
  }

  template<typename char_t, typename traits_t, typename float_t>
  std::basic_istream<char_t, traits_t> &operator>>(std::basic_istream<char_t, traits_t> &in,
                                                   pareto_dist<float_t> &g) {
    typename pareto_dist<float_t>::param_type P;
    std::ios_base::fmtflags flags(in.flags());
    in.flags(std::ios_base::dec | std::ios_base::fixed | std::ios_base::left);
    in >> utility::ignore_spaces() >> utility::delim("[pareto ") >> P >> utility::delim(']');
    if (in)
      g.param(P);
    in.flags(flags);
    return in;
  }

}  // namespace trng

#endif
