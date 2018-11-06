/* Useful utilities, copied from GMP
   GMP code is used under the GNU GPLv2 license. */

#pragma once

#define add_ssaaaa(sh, sl, ah, al, bh, bl) \
  __asm__ ("addq %5,%q1\n\tadcq %3,%q0"                                 \
           : "=r" (sh), "=&r" (sl)                                      \
           : "0"  ((uint64_t)(ah)), "rme" ((uint64_t)(bh)),             \
             "%1" ((uint64_t)(al)), "rme" ((uint64_t)(bl)))
#define sub_ddmmss(sh, sl, ah, al, bh, bl) \
  __asm__ ("subq %5,%q1\n\tsbbq %3,%q0"                                 \
           : "=r" (sh), "=&r" (sl)                                      \
           : "0" ((uint64_t)(ah)), "rme" ((uint64_t)(bh)),              \
             "1" ((uint64_t)(al)), "rme" ((uint64_t)(bl)))
#define umul_ppmm(w1, w0, u, v) \
  __asm__ ("mulq %3"                                                    \
           : "=a" (w0), "=d" (w1)                                       \
           : "%0" ((uint64_t)(u)), "rm" ((uint64_t)(v)))
#define udiv_qrnnd(q, r, n1, n0, dx) /* d renamed to dx avoiding "=d" */\
  __asm__ ("divq %4"                 /* stringification in K&R C */     \
           : "=a" (q), "=d" (r)                                         \
           : "0" ((uint64_t)(n0)), "1" ((uint64_t)(n1)), "rm" ((uint64_t)(dx)))

/* Dividing (NH, NL) by D, returning the remainder only. Unlike
   udiv_qrnnd_preinv, works also for the case NH == D, where the
   quotient doesn't quite fit in a single limb. */
#define udiv_rnnd_preinv(r, nh, nl, d, di)                              \
  do {                                                                  \
    mp_limb_t _qh, _ql, _r, _mask;                                      \
    umul_ppmm (_qh, _ql, (nh), (di));                                   \
    if (__builtin_constant_p (nl) && (nl) == 0)                         \
      {                                                                 \
        _r = ~(_qh + (nh)) * (d);                                       \
        _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */     \
        _r += _mask & (d);                                              \
      }                                                                 \
    else                                                                \
      {                                                                 \
        add_ssaaaa (_qh, _ql, _qh, _ql, (nh) + 1, (nl));                \
        _r = (nl) - _qh * (d);                                          \
        _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */     \
        _r += _mask & (d);                                              \
        if (__GMP_UNLIKELY (_r >= (d)))                                 \
          _r -= (d);                                                    \
      }                                                                 \
    (r) = _r;                                                           \
  } while (0)

