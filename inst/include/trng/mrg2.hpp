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

#if !(defined TRNG_MRG2_HPP)

#define TRNG_MRG2_HPP

#include <trng/cuda.hpp>
#include <trng/utility.hpp>
#include <trng/int_types.hpp>
#include <trng/int_math.hpp>
#include <trng/mrg_parameter.hpp>
#include <trng/mrg_status.hpp>
#include <ostream>
#include <istream>
#include <stdexcept>
#include <ciso646>

namespace trng {

  class mrg2 {
  public:
    // Uniform random number generator concept
    using result_type = int32_t;
    TRNG_CUDA_ENABLE
    result_type operator()();

  private:
    static constexpr result_type modulus = 2147483647;
    static constexpr result_type min_ = 0;
    static constexpr result_type max_ = modulus - 1;

  public:
    static constexpr result_type min() { return min_; }
    static constexpr result_type max() { return max_; }

    // Parameter and status classes
    using parameter_type = mrg_parameter<result_type, 2, mrg2>;
    using status_type = mrg_status<result_type, 2, mrg2>;

    static const parameter_type LEcuyer1;
    static const parameter_type LEcuyer2;

    // Random number engine concept
    explicit mrg2(parameter_type = LEcuyer1);
    explicit mrg2(unsigned long, parameter_type = LEcuyer1);
    template<typename gen>
    explicit mrg2(gen &g, parameter_type P = LEcuyer1) : P{P} {
      seed(g);
    }

    void seed();
    void seed(unsigned long);
    template<typename gen>
    void seed(gen &g) {
      const uint32_t r1{static_cast<uint32_t>(g()) % static_cast<uint32_t>(modulus)};
      const uint32_t r2{static_cast<uint32_t>(g()) % static_cast<uint32_t>(modulus)};
      S.r[0] = r1;
      S.r[1] = r2;
    }
    void seed(result_type, result_type);

    // Equality comparable concept
    friend bool operator==(const mrg2 &, const mrg2 &);
    friend bool operator!=(const mrg2 &, const mrg2 &);

    // Streamable concept
    template<typename char_t, typename traits_t>
    friend std::basic_ostream<char_t, traits_t> &operator<<(
        std::basic_ostream<char_t, traits_t> &out, const mrg2 &R) {
      std::ios_base::fmtflags flags(out.flags());
      out.flags(std::ios_base::dec | std::ios_base::fixed | std::ios_base::left);
      out << '[' << mrg2::name() << ' ' << R.P << ' ' << R.S << ']';
      out.flags(flags);
      return out;
    }

    template<typename char_t, typename traits_t>
    friend std::basic_istream<char_t, traits_t> &operator>>(
        std::basic_istream<char_t, traits_t> &in, mrg2 &R) {
      mrg2::parameter_type P_new;
      mrg2::status_type S_new;
      std::ios_base::fmtflags flags(in.flags());
      in.flags(std::ios_base::dec | std::ios_base::fixed | std::ios_base::left);
      in >> utility::ignore_spaces();
      in >> utility::delim('[') >> utility::delim(mrg2::name()) >> utility::delim(' ') >>
          P_new >> utility::delim(' ') >> S_new >> utility::delim(']');
      if (in) {
        R.P = P_new;
        R.S = S_new;
      }
      in.flags(flags);
      return in;
    }

    // Parallel random number generator concept
    TRNG_CUDA_ENABLE
    void split(unsigned int, unsigned int);
    TRNG_CUDA_ENABLE
    void jump2(unsigned int);
    TRNG_CUDA_ENABLE
    void jump(unsigned long long);
    TRNG_CUDA_ENABLE
    void discard(unsigned long long);

    // Other useful methods
    static const char *name();
    TRNG_CUDA_ENABLE
    long operator()(long);

  private:
    parameter_type P;
    status_type S;
    static const char *const name_str;

    TRNG_CUDA_ENABLE
    void backward();
    TRNG_CUDA_ENABLE
    void step();
  };

  // Inline and template methods

  TRNG_CUDA_ENABLE
  inline void mrg2::step() {
    const uint64_t t{static_cast<uint64_t>(P.a[0]) * static_cast<uint64_t>(S.r[0]) +
                     static_cast<uint64_t>(P.a[1]) * static_cast<uint64_t>(S.r[1])};
    S.r[1] = S.r[0];
    S.r[0] = int_math::modulo<modulus, 2>(t);
  }

  TRNG_CUDA_ENABLE
  inline mrg2::result_type mrg2::operator()() {
    step();
    return S.r[0];
  }

  TRNG_CUDA_ENABLE
  inline long mrg2::operator()(long x) {
    return static_cast<long>(utility::uniformco<double, mrg2>(*this) * x);
  }

  // Parallel random number generator concept
  TRNG_CUDA_ENABLE
  inline void mrg2::split(unsigned int s, unsigned int n) {
#if !(defined __CUDA_ARCH__)
    if (s < 1 or n >= s)
      utility::throw_this(std::invalid_argument("invalid argument for trng::mrg2::split"));
#endif
    if (s > 1) {
      jump(n + 1);
      const result_type q0{S.r[0]};
      jump(s);
      const result_type q1{S.r[0]};
      jump(s);
      const result_type q2{S.r[0]};
      jump(s);
      const result_type q3{S.r[0]};
      result_type a[2], b[4];
      a[0] = q2;
      b[0] = q1;
      b[1] = q0;
      a[1] = q3;
      b[2] = q2;
      b[3] = q1;
      int_math::gauss<2>(b, a, modulus);
      P.a[0] = a[0];
      P.a[1] = a[1];
      S.r[0] = q1;
      S.r[1] = q0;
      for (int i{0}; i < 2; ++i)
        backward();
    }
  }

  TRNG_CUDA_ENABLE
  inline void mrg2::jump2(unsigned int s) {
    result_type b[4], c[4]{};
    b[0] = P.a[0];
    b[1] = P.a[1];
    b[2] = 1;
    b[3] = 0;
    for (unsigned int i{0}; i < s; ++i) {
      int_math::matrix_mult<2>(b, b, c, modulus);
      ++i;
      if (not(i < s))
        break;
      int_math::matrix_mult<2>(c, c, b, modulus);
    }
    const result_type r[2]{S.r[0], S.r[1]};
    result_type d[2];
    if ((s & 1u) == 0)
      int_math::matrix_vec_mult<2>(b, r, d, modulus);
    else
      int_math::matrix_vec_mult<2>(c, r, d, modulus);
    S.r[0] = d[0];
    S.r[1] = d[1];
  }

  TRNG_CUDA_ENABLE
  inline void mrg2::jump(unsigned long long s) {
    if (s < 16) {
      for (unsigned int i{0}; i < s; ++i)
        step();
    } else {
      unsigned int i{0};
      while (s > 0) {
        if (s % 2 == 1)
          jump2(i);
        ++i;
        s >>= 1u;
      }
    }
  }

  TRNG_CUDA_ENABLE
  inline void mrg2::discard(unsigned long long n) { jump(n); }

  TRNG_CUDA_ENABLE
  inline void mrg2::backward() {
    result_type t;
    if (P.a[1] != 0) {
      t = S.r[0];
      t -= static_cast<result_type>(
          (static_cast<int64_t>(P.a[0]) * static_cast<int64_t>(S.r[1])) % modulus);
      if (t < 0)
        t += modulus;
      t = static_cast<result_type>(
          (static_cast<int64_t>(t) *
           static_cast<int64_t>(int_math::modulo_invers(P.a[1], modulus))) %
          modulus);
    } else if (P.a[0] != 0) {
      t = S.r[1];
      t = static_cast<result_type>(
          (static_cast<int64_t>(t) *
           static_cast<int64_t>(int_math::modulo_invers(P.a[0], modulus))) %
          modulus);
    } else
      t = 0;
    S.r[0] = S.r[1];
    S.r[1] = t;
  }

}  // namespace trng

#endif
