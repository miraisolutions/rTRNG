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

#if !(defined TRNG_INT_MATH_HPP)

#define TRNG_INT_MATH_HPP

#include <trng/cuda.hpp>
#include <trng/int_types.hpp>
#include <cmath>
#include <cassert>
#include <algorithm>
#include <stdexcept>
#include <ciso646>

namespace trng {

  namespace int_math {

    TRNG_CUDA_ENABLE
    inline int32_t modulo_invers(int32_t a, int32_t m) {
#if !(defined __CUDA_ARCH__)
      if (a <= 0 or m <= 1)
        utility::throw_this(
            std::invalid_argument("invalid argument in trng::int_math::modulo_invers"));
#endif
      int32_t flast{0}, f{1}, m1{m};
      while (a > 1) {
        int32_t temp{m1 % a};
        int32_t q{m1 / a};
        m1 = a;
        a = temp;
        temp = f;
        f = flast - q * f;
        flast = temp;
      }
#if !(defined __CUDA_ARCH__)
      if (a == 0)
        utility::throw_this(
            std::runtime_error("no inversive in trng::int_math::modulo_invers"));
#endif
      return f >= 0 ? f : f + m;
    }

    //------------------------------------------------------------------

    template<int n>
    TRNG_CUDA_ENABLE void gauss(int32_t a[n * n], int32_t b[n], int32_t m) {
      // initialize indices
      int rank{0};
      int32_t p[n];
      for (int i{0}; i < n; ++i)
        p[i] = i;
      // make matrix triangular
      for (int i{0}; i < n; ++i) {
        // search for a pivot element
        if (a[n * p[i] + i] == 0) {
          // swap rows
          int j = i + 1;
          while (j < n and a[n * p[j] + i] == 0)
            j++;
          if (j < n) {
            int32_t t = p[i];
            p[i] = p[j];
            p[j] = t;
          }
        }
        // is rank small?
        if (a[n * p[i] + i] == 0)
          break;
        ++rank;
        int32_t t = modulo_invers(a[n * p[i] + i], m);
        for (int j{i}; j < n; ++j)
          a[n * p[i] + j] = static_cast<int32_t>(
              (static_cast<int64_t>(a[n * p[i] + j]) * static_cast<int64_t>(t)) % m);
        b[p[i]] =
            static_cast<int32_t>((static_cast<int64_t>(b[p[i]]) * static_cast<int64_t>(t)) % m);
        for (int j{i + 1}; j < n; ++j) {
          if (a[n * p[j] + i] != 0) {
            t = modulo_invers(a[n * p[j] + i], m);
            for (int k{i}; k < n; ++k) {
              a[n * p[j] + k] = static_cast<int32_t>(
                  (static_cast<int64_t>(a[n * p[j] + k]) * static_cast<int64_t>(t)) % m);
              a[n * p[j] + k] -= a[n * p[i] + k];
              if (a[n * p[j] + k] < 0)
                a[n * p[j] + k] += m;
            }
            b[p[j]] = static_cast<int32_t>(
                (static_cast<int64_t>(b[p[j]]) * static_cast<int64_t>(t)) % m);
            b[p[j]] -= b[p[i]];
            if (b[p[j]] < 0)
              b[p[j]] += m;
          }
        }
      }
      // test if a solution exists
#if !(defined __CUDA_ARCH__)
      for (int i{rank}; i < n; ++i)
        if (b[p[i]] != 0)
          utility::throw_this(
              std::runtime_error("equations system has no solution trng::int_math::gauss"));
#endif
      // solve triangular system
      for (int i{n - 2}; i >= 0; --i)
        for (int j{i + 1}; j < n; ++j) {
          b[p[i]] -= static_cast<int32_t>(
              (static_cast<int64_t>(a[n * p[i] + j]) * static_cast<int64_t>(b[p[j]])) % m);
          if (b[p[i]] < 0)
            b[p[i]] += m;
        }
      // sort
      for (int i{0}; i < n; ++i)
        p[i] = b[p[i]];
      for (int i{0}; i < n; ++i)
        b[i] = p[i];
    }

    //------------------------------------------------------------------

    template<int n>
    TRNG_CUDA_ENABLE void matrix_mult(const int32_t (&a)[n * n], const int32_t (&b)[n * n],
                                      int32_t (&c)[n * n], int32_t m) {
      for (int i{0}; i < n; ++i)
        for (int j{0}; j < n; ++j) {
          int64_t t{0};
          for (int k{0}; k < n; ++k) {
            t += (static_cast<int64_t>(a[j * n + k]) * static_cast<int64_t>(b[k * n + i])) % m;
            if (t >= m)
              t -= m;
          }
          c[j * n + i] = static_cast<int32_t>(t);
        }
    }

    //------------------------------------------------------------------

    template<int n>
    TRNG_CUDA_ENABLE void matrix_vec_mult(const int32_t (&a)[n * n], const int32_t (&b)[n],
                                          int32_t (&c)[n], int32_t m) {
      for (int j{0}; j < n; ++j) {
        int64_t t{0};
        for (int k{0}; k < n; ++k) {
          t += (static_cast<int64_t>(a[j * n + k]) * static_cast<int64_t>(b[k])) % m;
          if (t >= m)
            t -= m;
        }
        c[j] = static_cast<int32_t>(t);
      }
    }

    // ---------------------------------------------------------------

    template<typename T>
    constexpr T pow2(const T x) {
      return T(1) << x;
    }

    template<typename T>
    constexpr T log2_floor(const T x) {
      return x <= T(1) ? T(0) : T(1) + log2_floor(x / T(2));
    }

    template<typename T>
    constexpr T log2_ceil(const T x) {
      return pow2(log2_floor(x)) < x ? log2_floor(x) + 1 : log2_floor(x);
    }

    // round upwards to next power of 2
    template<typename T>
    constexpr T ceil2(const T x) {
      return x <= T(1) ? x : T(2) * ceil2((x + T(1)) / T(2));
    }

    // sets all bits below the argument's most significant bit to one
    template<typename T>
    constexpr T mask(const T x) {
      return ceil2(x + T(1)) - T(1);
    }

    // ---------------------------------------------------------------

    template<int32_t m, int32_t r>
    class modulo_helper;

    template<int32_t m>
    class modulo_helper<m, 0> {
      static constexpr int32_t e = log2_ceil(m);
      static constexpr int32_t k = (1ul << e) - m;
      static constexpr uint32_t mask = (1ul << e) - 1ul;

    public:
      TRNG_CUDA_ENABLE
      static int32_t modulo(uint64_t x) {
        if (mask == m) {
          uint32_t y{static_cast<uint32_t>((x & mask) + (x >> e))};
          if (y >= m)
            y -= m;
          return y;
        }
        if (static_cast<int64_t>(k) * (static_cast<int64_t>(k) + 2) <= m) {
          x = (x & mask) + (x >> e) * k;
          x = (x & mask) + (x >> e) * k;
          if (x >= m)
            x -= m;
          return static_cast<int32_t>(x);
        }
        return static_cast<int32_t>(x % m);
      }
    };

    template<int32_t m>
    class modulo_helper<m, 1> {
      static constexpr int32_t e = log2_ceil(m);
      static constexpr int32_t k = (static_cast<uint32_t>(1) << e) - m;
      static constexpr uint32_t mask = (static_cast<uint32_t>(1) << e) - 1u;

    public:
      TRNG_CUDA_ENABLE
      static int32_t modulo(uint64_t x) {
        if (mask == m) {
          uint64_t y{(x & mask) + (x >> e)};
          if (y >= static_cast<uint64_t>(2u) * m)
            y -= static_cast<uint64_t>(2u) * m;
          if (y >= m)
            y -= m;
          return static_cast<int32_t>(y);
        }
        if (static_cast<int64_t>(k) * (static_cast<int64_t>(k) + 2) <= m) {
          x = (x & mask) + (x >> e) * k;
          x = (x & mask) + (x >> e) * k;
          if (x >= static_cast<uint64_t>(2u) * m)
            x -= static_cast<uint64_t>(2u) * m;
          if (x >= m)
            x -= m;
          return static_cast<int32_t>(x);
        }
        return static_cast<int32_t>(x % m);
      }
    };

    template<int32_t m>
    class modulo_helper<m, 2> {
      static constexpr int32_t e = log2_ceil(m);
      static constexpr int32_t k = (static_cast<uint32_t>(1) << e) - m;
      static constexpr uint32_t mask = (static_cast<uint32_t>(1) << e) - 1u;

    public:
      TRNG_CUDA_ENABLE
      static int32_t modulo(uint64_t x) {
        if (mask == m) {
          uint64_t y{(x & mask) + (x >> e)};
          if (y >= static_cast<uint64_t>(4u) * m)
            y -= static_cast<uint64_t>(4u) * m;
          if (y >= static_cast<uint64_t>(2u) * m)
            y -= static_cast<uint64_t>(2u) * m;
          if (y >= m)
            y -= m;
          return static_cast<int32_t>(y);
        }
        if (static_cast<int64_t>(k) * (static_cast<int64_t>(k) + 2) <= m) {
          x = (x & mask) + (x >> e) * k;
          x = (x & mask) + (x >> e) * k;
          if (x >= static_cast<uint64_t>(4u) * m)
            x -= static_cast<uint64_t>(4u) * m;
          if (x >= static_cast<uint64_t>(2u) * m)
            x -= static_cast<uint64_t>(2u) * m;
          if (x >= m)
            x -= m;
          return static_cast<int32_t>(x);
        }
        return static_cast<int32_t>(x % m);
      }
    };

    template<int32_t m, int32_t r>
    TRNG_CUDA_ENABLE inline int32_t modulo(uint64_t x) {
      static_assert(m > 0, "must be positive");
      static_assert(r > 0, "must be positive");
      return modulo_helper<m, log2_floor(r)>::modulo(x);
    }

    //------------------------------------------------------------------

    template<int32_t m, int32_t b>
    class power {
      uint32_t b_power0[0x10000], b_power1[0x08000];

      int32_t pow(int32_t n) {
        int64_t p{1}, t{b};
        while (n > 0) {
          if ((n & 0x1) == 0x1)
            p = modulo<m, 1>(p * t);
          t = modulo<m, 1>(t * t);
          n /= 2;
        }
        return static_cast<int32_t>(p);
      }

    public:
      // make it non-copyable
      power &operator=(const power &) = delete;
      power(const power &) = delete;

      power() {
        for (int32_t i{0}; i < 0x10000; ++i)
          b_power0[i] = pow(i);
        for (int32_t i{0}; i < 0x08000; ++i)
          b_power1[i] = pow(i * 0x10000);
      }
      int32_t operator()(int32_t n) const {
        return modulo<m, 1>(static_cast<uint64_t>(b_power1[n >> 16]) *
                            static_cast<uint64_t>(b_power0[n & 0xffff]));
      }
    };

  }  // namespace int_math

}  // namespace trng

#endif
