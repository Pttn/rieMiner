/* Copyright 2017-2018 Michael Bell

  This file contains code copied and derived from GMP.
  GMP code is Copyright 1991-1997, 1999-2016 Free Software Foundation, Inc.

  You may redistribute this and/or modify it under the terms of 
  the GNU Lesser General Public License as published by the Free
    Software Foundation; either version 3 of the License, or (at your
    option) any later version. */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <limits.h>

#include "primetest.h"
#include "primetest512.h"

#include "prime-gmp.h"

#include "fermat.h"

#define JOB_SIZE 16

const unsigned char  binvert_limb_table[128] = {
	0x01, 0xAB, 0xCD, 0xB7, 0x39, 0xA3, 0xC5, 0xEF,
	0xF1, 0x1B, 0x3D, 0xA7, 0x29, 0x13, 0x35, 0xDF,
	0xE1, 0x8B, 0xAD, 0x97, 0x19, 0x83, 0xA5, 0xCF,
	0xD1, 0xFB, 0x1D, 0x87, 0x09, 0xF3, 0x15, 0xBF,
	0xC1, 0x6B, 0x8D, 0x77, 0xF9, 0x63, 0x85, 0xAF,
	0xB1, 0xDB, 0xFD, 0x67, 0xE9, 0xD3, 0xF5, 0x9F,
	0xA1, 0x4B, 0x6D, 0x57, 0xD9, 0x43, 0x65, 0x8F,
	0x91, 0xBB, 0xDD, 0x47, 0xC9, 0xB3, 0xD5, 0x7F,
	0x81, 0x2B, 0x4D, 0x37, 0xB9, 0x23, 0x45, 0x6F,
	0x71, 0x9B, 0xBD, 0x27, 0xA9, 0x93, 0xB5, 0x5F,
	0x61, 0x0B, 0x2D, 0x17, 0x99, 0x03, 0x25, 0x4F,
	0x51, 0x7B, 0x9D, 0x07, 0x89, 0x73, 0x95, 0x3F,
	0x41, 0xEB, 0x0D, 0xF7, 0x79, 0xE3, 0x05, 0x2F,
	0x31, 0x5B, 0x7D, 0xE7, 0x69, 0x53, 0x75, 0x1F,
	0x21, 0xCB, 0xED, 0xD7, 0x59, 0xC3, 0xE5, 0x0F,
	0x11, 0x3B, 0x5D, 0xC7, 0x49, 0x33, 0x55, 0xFF
};

#define binvert_limb(inv,n)                                             \
  do {                                                                  \
    mp_limb_t  __n = (n);                                               \
    mp_limb_t  __inv;                                                   \
    assert ((__n & 1) == 1);                                            \
                                                                        \
    __inv = binvert_limb_table[(__n/2) & 0x7F]; /*  8 */                \
    if (GMP_LIMB_BITS > 8)   __inv = 2 * __inv - __inv * __inv * __n;   \
    if (GMP_LIMB_BITS > 16)  __inv = 2 * __inv - __inv * __inv * __n;   \
    if (GMP_LIMB_BITS > 32)  __inv = 2 * __inv - __inv * __inv * __n;   \
                                                                        \
    assert ((__inv * __n) == 1);                        \
    (inv) = __inv;                                      \
  } while (0)

thread_local bool inited = false;
static void checkStackSize() {
	volatile int foo[128 * 1024];
	for (int i = 0; i < 128*1024; ++i) {
		foo[i] = i;
		foo[i] = foo[i];
	}
}

static uint32_t setup_fermat(uint32_t N_Size, int num, const mp_limb_t* M, mp_limb_t* MI, mp_limb_t* R)
{
	assert(N_Size <= MAX_N_SIZE);
	struct gmp_div_inverse minv;
	for (int j = 0; j < num; ++j)
	{
		mp_size_t mn = N_Size;
		mp_limb_t mshifted[MAX_N_SIZE];
		mp_srcptr mp;
		mp_ptr rp;

		// REDCify: r = B^n * 2 % M
		mp = &M[j*N_Size];
		rp = &R[j*N_Size];
		mpn_div_qr_invert(&minv, mp, mn);

		if (minv.shift > 0)
		{
			mpn_lshift(mshifted, mp, mn, minv.shift);
			mp = mshifted;
		}

		for (int i = 0; i < mn + 9; ++i) rp[i] = 0;
		mp_limb_t x = mp[mn - 1] >> 24;
		x += minv.shift;
		int i = x >> 5;
		rp[mn + i] = 1 << (x & 0x1f);
		mpn_div_r_preinv_ns(rp, mn+i+1, mp, mn, &minv);

		if (minv.shift > 0)
		{
			mpn_rshift(rp, rp, mn, minv.shift);
			mp = &M[j*N_Size];
		}

		mp_limb_t mi;
		binvert_limb(mi, mp[0]);
		MI[j] = -mi;
	}
	return minv.shift;
}

#if DEBUG
#define DPRINTF(fmt, args...) do { printf("line %d: " fmt, __LINE__, ##args); fflush(stdout); } while(0)
#else
#define DPRINTF(fmt, ...) do { } while(0)
#endif

void fermatTest(int N_Size, int listSize, uint32_t* M, uint32_t* is_prime, bool use_avx512)
{
	// Because of the way the ISPC code uses the stack, we must ensure
	// enough stack is paged in before running the test.
	if (!inited) {
		checkStackSize();
		inited = true;
	}

	if (N_Size < 6 || N_Size > MAX_N_SIZE)
	{
		printf("N Size out of bounds\n");
		abort();
	}

	if (listSize % JOB_SIZE)
	{
		printf("Incorrect list size alignment\n");
		abort();
	}

	uint32_t MI[MAX_N_SIZE];
	uint32_t R[MAX_N_SIZE * JOB_SIZE + 9];

	while (listSize > 0)
	{
		uint32_t shift = setup_fermat(N_Size, JOB_SIZE, M, MI, R);
		if (use_avx512) ispc::fermat_test512(M, MI, R, is_prime, N_Size, shift);
		else ispc::fermat_test(M, MI, R, is_prime, N_Size, shift);
		M += JOB_SIZE*N_Size;
		is_prime += JOB_SIZE;
		listSize -= JOB_SIZE;
	}
}
