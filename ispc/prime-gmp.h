/* This is a cut down version of mini-gmp, to provide enough functionality
 * to set up Fermat tests on ISPC/OpenCL.
 
 Copyright 1991-1997, 1999-2016 Free Software Foundation, Inc.

This file is part of the GNU MP Library.

The GNU MP Library is free software; you can redistribute it and/or modify
it under the terms of either:

  * the GNU Lesser General Public License as published by the Free
    Software Foundation; either version 3 of the License, or (at your
    option) any later version.

or

  * the GNU General Public License as published by the Free Software
    Foundation; either version 2 of the License, or (at your option) any
    later version.

or both in parallel, as here. */ 

#pragma once

typedef uint32_t mp_limb_t;
typedef int32_t mp_size_t;
typedef uint32_t mp_bitcnt_t;

typedef mp_limb_t *mp_ptr;
typedef const mp_limb_t *mp_srcptr;

typedef struct
{
	int _mp_alloc;		/* Number of *limbs* allocated and pointed
						to by the _mp_d field.  */
	int _mp_size;			/* abs(_mp_size) is the number of limbs the
							last field points to.  If _mp_size is
							negative this is a negative number.  */
	mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
} __mpz_struct;

typedef __mpz_struct mpz_t[1];

typedef __mpz_struct *mpz_ptr;
typedef const __mpz_struct *mpz_srcptr;


struct gmp_div_inverse
{
	/* Normalization shift count. */
	unsigned shift;
	/* Normalized divisor (d0 unused for mpn_div_qr_1) */
	mp_limb_t d1, d0;
	/* Inverse, for 2/1 or 3/2. */
	mp_limb_t di;
};

/* Macros */
#define GMP_LIMB_BITS (sizeof(mp_limb_t) * CHAR_BIT)

#define GMP_LIMB_MAX (~ (mp_limb_t) 0)
#define GMP_LIMB_HIGHBIT ((mp_limb_t) 1 << (GMP_LIMB_BITS - 1))

#define GMP_HLIMB_BIT ((mp_limb_t) 1 << (GMP_LIMB_BITS / 2))
#define GMP_LLIMB_MASK (GMP_HLIMB_BIT - 1)

#define GMP_ULONG_BITS (sizeof(unsigned long) * CHAR_BIT)
#define GMP_ULONG_HIGHBIT ((unsigned long) 1 << (GMP_ULONG_BITS - 1))

#define GMP_ABS(x) ((x) >= 0 ? (x) : -(x))
#define GMP_NEG_CAST(T,x) (-((T)((x) + 1) - 1))

#define GMP_MIN(a, b) ((a) < (b) ? (a) : (b))
#define GMP_MAX(a, b) ((a) > (b) ? (a) : (b))

#define GMP_CMP(a,b) (((a) > (b)) - ((a) < (b)))

#define gmp_assert_nocarry(x) do { \
    mp_limb_t __cy = (x);	   \
    assert (__cy == 0);		   \
  } while (0)

#define gmp_clz(count, x) do {						\
    mp_limb_t __clz_x = (x);						\
    unsigned __clz_c;							\
    for (__clz_c = 0;							\
	 (__clz_x & ((mp_limb_t) 0xff << (GMP_LIMB_BITS - 8))) == 0;	\
	 __clz_c += 8)							\
      __clz_x <<= 8;							\
    for (; (__clz_x & GMP_LIMB_HIGHBIT) == 0; __clz_c++)		\
      __clz_x <<= 1;							\
    (count) = __clz_c;							\
  } while (0)

#define gmp_ctz(count, x) do {						\
    mp_limb_t __ctz_x = (x);						\
    unsigned __ctz_c = 0;						\
    gmp_clz (__ctz_c, __ctz_x & - __ctz_x);				\
    (count) = GMP_LIMB_BITS - 1 - __ctz_c;				\
  } while (0)

#define gmp_add_ssaaaa(sh, sl, ah, al, bh, bl) \
  do {									\
    mp_limb_t __x;							\
    __x = (al) + (bl);							\
    (sh) = (ah) + (bh) + (__x < (al));					\
    (sl) = __x;								\
  } while (0)

#define gmp_sub_ddmmss(sh, sl, ah, al, bh, bl) \
  do {									\
    mp_limb_t __x;							\
    __x = (al) - (bl);							\
    (sh) = (ah) - (bh) - ((al) < (bl));					\
    (sl) = __x;								\
  } while (0)

#define gmp_umul_ppmm(w1, w0, u, v)					\
  do {									\
    static_assert(GMP_LIMB_BITS == 32, "Incorrect number of limb bits"); \
	uint64_t __w = uint64_t(u) * uint64_t(v); \
	(w0) = mp_limb_t(__w); \
    (w1) = mp_limb_t(__w >> 32); \
  } while (0)

#define gmp_udiv_qrnnd_preinv(q, r, nh, nl, d, di)			\
  do {									\
    mp_limb_t _qh, _ql, _r, _mask;					\
    gmp_umul_ppmm (_qh, _ql, (nh), (di));				\
    gmp_add_ssaaaa (_qh, _ql, _qh, _ql, (nh) + 1, (nl));		\
    _r = (nl) - _qh * (d);						\
    _mask = -(mp_limb_t) (_r > _ql); /* both > and >= are OK */		\
    _qh += _mask;							\
    _r += _mask & (d);							\
    if (_r >= (d))							\
      {									\
	_r -= (d);							\
	_qh++;								\
      }									\
									\
    (r) = _r;								\
    (q) = _qh;								\
  } while (0)

#define gmp_udiv_qr_3by2(q, r1, r0, n2, n1, n0, d1, d0, dinv)		\
  do {									\
    mp_limb_t _q0, _t1, _t0, _mask;					\
    gmp_umul_ppmm ((q), _q0, (n2), (dinv));				\
    gmp_add_ssaaaa ((q), _q0, (q), _q0, (n2), (n1));			\
									\
    /* Compute the two most significant limbs of n - q'd */		\
    (r1) = (n1) - (d1) * (q);						\
    gmp_sub_ddmmss ((r1), (r0), (r1), (n0), (d1), (d0));		\
    gmp_umul_ppmm (_t1, _t0, (d0), (q));				\
    gmp_sub_ddmmss ((r1), (r0), (r1), (r0), _t1, _t0);			\
    (q)++;								\
									\
    /* Conditionally adjust q and the remainders */			\
    _mask = - (mp_limb_t) ((r1) >= _q0);				\
    (q) += _mask;							\
    gmp_add_ssaaaa ((r1), (r0), (r1), (r0), _mask & (d1), _mask & (d0)); \
    if ((r1) >= (d1))							\
      {									\
	if ((r1) > (d1) || (r0) >= (d0))				\
	  {								\
	    (q)++;							\
	    gmp_sub_ddmmss ((r1), (r0), (r1), (r0), (d1), (d0));	\
	  }								\
      }									\
  } while (0)

/* Swap macros. */
#define MP_LIMB_T_SWAP(x, y)						\
  do {									\
    mp_limb_t __mp_limb_t_swap__tmp = (x);				\
    (x) = (y);								\
    (y) = __mp_limb_t_swap__tmp;					\
  } while (0)
#define MP_SIZE_T_SWAP(x, y)						\
  do {									\
    mp_size_t __mp_size_t_swap__tmp = (x);				\
    (x) = (y);								\
    (y) = __mp_size_t_swap__tmp;					\
  } while (0)
#define MP_BITCNT_T_SWAP(x,y)			\
  do {						\
    mp_bitcnt_t __mp_bitcnt_t_swap__tmp = (x);	\
    (x) = (y);					\
    (y) = __mp_bitcnt_t_swap__tmp;		\
  } while (0)
#define MP_PTR_SWAP(x, y)						\
  do {									\
    mp_ptr __mp_ptr_swap__tmp = (x);					\
    (x) = (y);								\
    (y) = __mp_ptr_swap__tmp;						\
  } while (0)
#define MP_SRCPTR_SWAP(x, y)						\
  do {									\
    mp_srcptr __mp_srcptr_swap__tmp = (x);				\
    (x) = (y);								\
    (y) = __mp_srcptr_swap__tmp;					\
  } while (0)

#define MPN_PTR_SWAP(xp,xs, yp,ys)					\
  do {									\
    MP_PTR_SWAP (xp, yp);						\
    MP_SIZE_T_SWAP (xs, ys);						\
  } while(0)
#define MPN_SRCPTR_SWAP(xp,xs, yp,ys)					\
  do {									\
    MP_SRCPTR_SWAP (xp, yp);						\
    MP_SIZE_T_SWAP (xs, ys);						\
  } while(0)

#define MPZ_PTR_SWAP(x, y)						\
  do {									\
    mpz_ptr __mpz_ptr_swap__tmp = (x);					\
    (x) = (y);								\
    (y) = __mpz_ptr_swap__tmp;						\
  } while (0)
#define MPZ_SRCPTR_SWAP(x, y)						\
  do {									\
    mpz_srcptr __mpz_srcptr_swap__tmp = (x);				\
    (x) = (y);								\
    (y) = __mpz_srcptr_swap__tmp;					\
  } while (0)

#define mpn_invert_limb(x) mpn_invert_3by2 ((x), 0)

/* Memory allocation and other helper functions. */
static void
gmp_die(const char *msg)
{
	fprintf(stderr, "%s\n", msg);
	abort();
}

static void *
gmp_default_alloc(size_t size)
{
	void *p;

	assert(size > 0);

	p = malloc(size);
	if (!p)
		gmp_die("gmp_default_alloc: Virtual memory exhausted.");

	return p;
}

static void *
gmp_default_realloc(void *old, size_t old_size, size_t new_size)
{
	void * p;

	p = realloc(old, new_size);

	if (!p)
		gmp_die("gmp_default_realloc: Virtual memory exhausted.");

	return p;
}

static void
gmp_default_free(void *p, size_t size)
{
	free(p);
}

static void * (*gmp_allocate_func) (size_t) = gmp_default_alloc;
static void * (*gmp_reallocate_func) (void *, size_t, size_t) = gmp_default_realloc;
static void(*gmp_free_func) (void *, size_t) = gmp_default_free;

static void
mp_get_memory_functions(void *(**alloc_func) (size_t),
						void *(**realloc_func) (void *, size_t, size_t),
						void(**free_func) (void *, size_t))
{
	if (alloc_func)
		*alloc_func = gmp_allocate_func;

	if (realloc_func)
		*realloc_func = gmp_reallocate_func;

	if (free_func)
		*free_func = gmp_free_func;
}

static void
mp_set_memory_functions(void *(*alloc_func) (size_t),
						void *(*realloc_func) (void *, size_t, size_t),
						void(*free_func) (void *, size_t))
{
	if (!alloc_func)
		alloc_func = gmp_default_alloc;
	if (!realloc_func)
		realloc_func = gmp_default_realloc;
	if (!free_func)
		free_func = gmp_default_free;

	gmp_allocate_func = alloc_func;
	gmp_reallocate_func = realloc_func;
	gmp_free_func = free_func;
}

#define gmp_xalloc(size) ((*gmp_allocate_func)((size)))
#define gmp_free(p) ((*gmp_free_func) ((p), 0))

static mp_ptr
gmp_xalloc_limbs(mp_size_t size)
{
	return (mp_ptr)gmp_xalloc(size * sizeof(mp_limb_t));
}

static mp_ptr
gmp_xrealloc_limbs(mp_ptr old, mp_size_t size)
{
	assert(size > 0);
	return (mp_ptr)(*gmp_reallocate_func) (old, 0, size * sizeof(mp_limb_t));
}


/* MPN interface */

static void
mpn_copyi(mp_ptr d, mp_srcptr s, mp_size_t n)
{
	mp_size_t i;
	for (i = 0; i < n; i++)
		d[i] = s[i];
}

static void
mpn_copyd(mp_ptr d, mp_srcptr s, mp_size_t n)
{
	while (--n >= 0)
		d[n] = s[n];
}

static int
mpn_cmp(mp_srcptr ap, mp_srcptr bp, mp_size_t n)
{
	while (--n >= 0)
	{
		if (ap[n] != bp[n])
			return ap[n] > bp[n] ? 1 : -1;
	}
	return 0;
}

/* The 3/2 inverse is defined as

m = floor( (B^3-1) / (B u1 + u0)) - B
*/
static mp_limb_t
mpn_invert_3by2(mp_limb_t u1, mp_limb_t u0)
{
	mp_limb_t r, p, m, ql;
	unsigned ul, uh, qh;

	assert(u1 >= GMP_LIMB_HIGHBIT);

	/* For notation, let b denote the half-limb base, so that B = b^2.
	Split u1 = b uh + ul. */
	ul = u1 & GMP_LLIMB_MASK;
	uh = u1 >> (GMP_LIMB_BITS / 2);

	/* Approximation of the high half of quotient. Differs from the 2/1
	inverse of the half limb uh, since we have already subtracted
	u0. */
	qh = ~u1 / uh;

	/* Adjust to get a half-limb 3/2 inverse, i.e., we want

	qh' = floor( (b^3 - 1) / u) - b = floor ((b^3 - b u - 1) / u
	= floor( (b (~u) + b-1) / u),

	and the remainder

	r = b (~u) + b-1 - qh (b uh + ul)
	= b (~u - qh uh) + b-1 - qh ul

	Subtraction of qh ul may underflow, which implies adjustments.
	But by normalization, 2 u >= B > qh ul, so we need to adjust by
	at most 2.
	*/

	r = ((~u1 - (mp_limb_t)qh * uh) << (GMP_LIMB_BITS / 2)) | GMP_LLIMB_MASK;

	p = (mp_limb_t)qh * ul;
	/* Adjustment steps taken from udiv_qrnnd_c */
	if (r < p)
	{
		qh--;
		r += u1;
		if (r >= u1) /* i.e. we didn't get carry when adding to r */
			if (r < p)
			{
				qh--;
				r += u1;
			}
	}
	r -= p;

	/* Low half of the quotient is

	ql = floor ( (b r + b-1) / u1).

	This is a 3/2 division (on half-limbs), for which qh is a
	suitable inverse. */

	p = (r >> (GMP_LIMB_BITS / 2)) * qh + r;
	/* Unlike full-limb 3/2, we can add 1 without overflow. For this to
	work, it is essential that ql is a full mp_limb_t. */
	ql = (p >> (GMP_LIMB_BITS / 2)) + 1;

	/* By the 3/2 trick, we don't need the high half limb. */
	r = (r << (GMP_LIMB_BITS / 2)) + GMP_LLIMB_MASK - ql * u1;

	if (r >= (p << (GMP_LIMB_BITS / 2)))
	{
		ql--;
		r += u1;
	}
	m = ((mp_limb_t)qh << (GMP_LIMB_BITS / 2)) + ql;
	if (r >= u1)
	{
		m++;
		r -= u1;
	}

	/* Now m is the 2/1 invers of u1. If u0 > 0, adjust it to become a
	3/2 inverse. */
	if (u0 > 0)
	{
		mp_limb_t th, tl;
		r = ~r;
		r += u0;
		if (r < u0)
		{
			m--;
			if (r >= u1)
			{
				m--;
				r -= u1;
			}
			r -= u1;
		}
		gmp_umul_ppmm(th, tl, u0, m);
		r += th;
		if (r < th)
		{
			m--;
			m -= ((r > u1) | ((r == u1) & (tl > u0)));
		}
	}

	return m;
}

static void
mpn_div_qr_1_invert(struct gmp_div_inverse *inv, mp_limb_t d)
{
	unsigned shift;

	assert(d > 0);
	gmp_clz(shift, d);
	inv->shift = shift;
	inv->d1 = d << shift;
	inv->di = mpn_invert_limb(inv->d1);
}

static void
mpn_div_qr_2_invert(struct gmp_div_inverse *inv,
					mp_limb_t d1, mp_limb_t d0)
{
	unsigned shift;

	assert(d1 > 0);
	gmp_clz(shift, d1);
	inv->shift = shift;
	if (shift > 0)
	{
		d1 = (d1 << shift) | (d0 >> (GMP_LIMB_BITS - shift));
		d0 <<= shift;
	}
	inv->d1 = d1;
	inv->d0 = d0;
	inv->di = mpn_invert_3by2(d1, d0);
}

static void
mpn_div_qr_invert(struct gmp_div_inverse *inv,
				  mp_srcptr dp, mp_size_t dn)
{
	assert(dn > 0);

	if (dn == 1)
		mpn_div_qr_1_invert(inv, dp[0]);
	else if (dn == 2)
		mpn_div_qr_2_invert(inv, dp[1], dp[0]);
	else
	{
		unsigned shift;
		mp_limb_t d1, d0;

		d1 = dp[dn - 1];
		d0 = dp[dn - 2];
		assert(d1 > 0);
		gmp_clz(shift, d1);
		inv->shift = shift;
		if (shift > 0)
		{
			d1 = (d1 << shift) | (d0 >> (GMP_LIMB_BITS - shift));
			d0 = (d0 << shift) | (dp[dn - 3] >> (GMP_LIMB_BITS - shift));
		}
		inv->d1 = d1;
		inv->d0 = d0;
		inv->di = mpn_invert_3by2(d1, d0);
	}
}

static mp_limb_t
mpn_lshift(mp_ptr rp, mp_srcptr up, mp_size_t n, unsigned int cnt)
{
	mp_limb_t high_limb, low_limb;
	unsigned int tnc;
	mp_limb_t retval;

	assert(n >= 1);
	assert(cnt >= 1);
	assert(cnt < GMP_LIMB_BITS);

	up += n;
	rp += n;

	tnc = GMP_LIMB_BITS - cnt;
	low_limb = *--up;
	retval = low_limb >> tnc;
	high_limb = (low_limb << cnt);

	while (--n != 0)
	{
		low_limb = *--up;
		*--rp = high_limb | (low_limb >> tnc);
		high_limb = (low_limb << cnt);
	}
	*--rp = high_limb;

	return retval;
}

static mp_limb_t
mpn_rshift(mp_ptr rp, mp_srcptr up, mp_size_t n, unsigned int cnt)
{
	mp_limb_t high_limb, low_limb;
	unsigned int tnc;
	mp_limb_t retval;

	assert(n >= 1);
	assert(cnt >= 1);
	assert(cnt < GMP_LIMB_BITS);

	tnc = GMP_LIMB_BITS - cnt;
	high_limb = *up++;
	retval = (high_limb << tnc);
	low_limb = high_limb >> cnt;

	while (--n != 0)
	{
		high_limb = *up++;
		*rp++ = low_limb | (high_limb << tnc);
		low_limb = high_limb >> cnt;
	}
	*rp = low_limb;

	return retval;
}

static mp_limb_t
mpn_submul_1(mp_ptr rp, mp_srcptr up, mp_size_t n, mp_limb_t vl)
{
	mp_limb_t ul, cl, hpl, lpl, rl;

	assert(n >= 1);

	cl = 0;
	do
	{
		ul = *up++;
		gmp_umul_ppmm(hpl, lpl, ul, vl);

		lpl += cl;
		cl = (lpl < cl) + hpl;

		rl = *rp;
		lpl = rl - lpl;
		cl += lpl > rl;
		*rp++ = lpl;
	} while (--n != 0);

	return cl;
}

static mp_limb_t
mpn_add_n(mp_ptr rp, mp_srcptr ap, mp_srcptr bp, mp_size_t n)
{
	mp_size_t i;
	mp_limb_t cy;

	for (i = 0, cy = 0; i < n; i++)
	{
		mp_limb_t a, b, r;
		a = ap[i]; b = bp[i];
		r = a + cy;
		cy = (r < cy);
		r += b;
		cy += (r < b);
		rp[i] = r;
	}
	return cy;
}

static void
mpn_div_r_pi1(mp_ptr np, mp_size_t nn, mp_limb_t n1,
			  mp_srcptr dp, mp_size_t dn,
			  mp_limb_t dinv)
{
	mp_size_t i;

	mp_limb_t d1, d0;
	mp_limb_t cy, cy1;
	mp_limb_t q;

	assert(dn > 2);
	assert(nn >= dn);

	d1 = dp[dn - 1];
	d0 = dp[dn - 2];

	assert((d1 & GMP_LIMB_HIGHBIT) != 0);
	/* Iteration variable is the index of the q limb.
	*
	* We divide <n1, np[dn-1+i], np[dn-2+i], np[dn-3+i],..., np[i]>
	* by            <d1,          d0,        dp[dn-3],  ..., dp[0] >
	*/

	i = nn - dn;
	do
	{
		mp_limb_t n0 = np[dn - 1 + i];

		if (n1 == d1 && n0 == d0)
		{
			q = GMP_LIMB_MAX;
			mpn_submul_1(np + i, dp, dn, q);
			n1 = np[dn - 1 + i];      /* update n1, last loop's value will now be invalid */
		}
		else
		{
			gmp_udiv_qr_3by2(q, n1, n0, n1, n0, np[dn - 2 + i], d1, d0, dinv);

			cy = mpn_submul_1(np + i, dp, dn - 2, q);

			cy1 = n0 < cy;
			n0 = n0 - cy;
			cy = n1 < cy1;
			n1 = n1 - cy1;
			np[dn - 2 + i] = n0;

			if (cy != 0)
			{
				n1 += d1 + mpn_add_n(np + i, np + i, dp, dn - 1);
				q--;
			}
		}
	} while (--i >= 0);

	np[dn - 1] = n1;
}

static void
mpn_div_r_preinv_ns(mp_ptr np, mp_size_t nn,
					mp_srcptr dp, mp_size_t dn,
					const struct gmp_div_inverse *inv)
{
	assert(dn > 2);
	assert(nn >= dn);

	{
		mp_limb_t nh;

		assert(inv->d1 == dp[dn - 1]);
		assert(inv->d0 == dp[dn - 2]);
		assert((inv->d1 & GMP_LIMB_HIGHBIT) != 0);

		nh = 0;

		mpn_div_r_pi1(np, nn, nh, dp, dn, inv->di);
	}
}