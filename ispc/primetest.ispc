/* Copyright 2017-2018 Michael Bell
  
  This file contains code derived from GMP.  I believe that no code
  was directly copied from GMP so it could possibly be license permissively, 
  but as it follow the GMP implementation so closely, I can't be sure (and IANAL).
  
  Therefore this file is licensed under the LGPLv3 to ensure there is no legal issue.
  
  You may redistribute this and/or modify it under the terms of 
  the GNU Lesser General Public License as published by the Free
    Software Foundation; either version 3 of the License, or (at your
    option) any later version. */

#define MAX_N_SIZE 64

typedef unsigned int64 ulong;
typedef int64 long;

__declspec(safe)
static inline unsigned int64 mullo32(unsigned int64 a, unsigned int64 b) {
    unsigned int32 a32 = a;
    unsigned int32 b32 = b;
    return (unsigned int64)a32 * (unsigned int64)b32;
}

static unmasked void squareSimple(varying ulong* uniform P, varying const ulong* uniform R, uniform uint N_Size)
{
	ulong T[(MAX_N_SIZE - 1) * 2];

	{
		ulong cy = 0;
		for (uniform uint i = 0; i < N_Size - 1; ++i)
		{
			ulong p = mullo32(R[i + 1], R[0]) + cy;
			T[i] = (uint)p;
			cy = (p >> 32);
		}
		T[N_Size - 1] = cy;
	}

	for (uniform uint j = 2; j < N_Size; ++j)
	{
		ulong cy = 0;
		for (uniform uint i = j; i < N_Size; ++i)
		{
			ulong p = mullo32(R[i], R[j-1]);
			p += cy;
			p += T[i + j - 2];
			T[i + j - 2] = (uint)p;
			cy = (p >> 32);
		}
		T[N_Size + j - 2] = cy;
	}

	ulong p = mullo32(R[0], R[0]);
	P[0] = (uint)p;

	ulong cy = 0;
	for (uniform uint i = 0; i < N_Size - 1; ++i)
	{
		ulong t = T[2 * i];
		ulong a = (p >> 32) + cy;
		a += (uint)t << 1;
		P[2 * i + 1] = (uint)a;
		cy = (t >> 31) + (a >> 32);

		p = mullo32(R[i + 1], R[i + 1]);
		t = T[2 * i + 1];
		a = (uint)p + cy;
		a += (uint)t << 1;
		P[2 * i + 2] = (uint)a;
		cy = (t >> 31) + (a >> 32);
	}
	P[2 * N_Size - 1] = (p >> 32) + cy;
}

static inline ulong bigAdd(varying ulong* uniform R, varying const ulong* uniform A, varying const ulong* uniform B, uniform uint N_Size)
{
	ulong cy = 0;
	for (uniform uint i = 0; i < N_Size; ++i)
	{
		ulong a = A[i] + B[i];
		a += cy;
		R[i] = (uint)a;
		cy = (a >> 32);
	}
	return cy;
}

static inline long bigSub(varying ulong* uniform R, varying const ulong* uniform A, varying const ulong* uniform B, uniform uint N_Size)
{
	long cy = 0;
	for (uniform uint i = 0; i < N_Size; ++i)
	{
		long a = (long)A[i] - (long)B[i];
		a += cy;
		R[i] = (uint)a;
		cy = (a >> 32);
	}
	return cy;
}

static inline bool lessThan(varying const ulong* uniform A, varying const ulong* uniform B, uniform uint N_Size)
{
	for (uniform uint i = N_Size - 1; i >= 0; --i)
	{
#if 1
		if (A[i] < B[i]) return true;
		if (A[i] > B[i]) return false;
#else
		if ((uint)A[i] < (uint)B[i]) return true;
		if ((uint)A[i] > (uint)B[i]) return false;
#endif
	}
	return false;
}

#if 0
void toom2SquareHalf(varying uint* uniform P, varying const uint* uniform R, uniform uint N_Size)
{
	uniform uint s = N_Size >> 1;
	uniform uint n = N_Size - s;  // n==s or n==s+1

	varying const uint* uniform a0 = R;
	varying const uint* uniform a1 = R + n;
	varying uint* uniform asm1 = P;

	if (s == n)
	{
		if (lessThan(a0, a1, n))
			bigSub(asm1, a1, a0, n);
		else
			bigSub(asm1, a0, a1, n);
	}
	else
	{
		if (a0[s] == 0 && lessThan(a0, a1, s))
		{
			bigSub(asm1, a1, a0, s);
			asm1[s] = 0;
		}
		else
		{
			asm1[s] = a0[s] + bigSub(asm1, a0, a1, s);
		}
	}

	varying uint* uniform v0 = P;
	uint vm1[(MAX_N_SIZE >> 1) + 2];
	varying uint* uniform vinf = P + 2 * n;

	squareSimple(vm1, asm1, n);
	squareSimple(vinf, a1, s);
	squareSimple(v0, a0, n);

	int cy  = bigAdd(P + 2*n, v0 + n, vinf, n);
	uint cy2 = cy + bigAdd(P + n, P + 2*n, v0, n);
	uint cy3 = bigAdd(P + 2*n, P + 2*n, vinf + n, s + s - n);
	for (uint i = 2*n+s+s-n; i < 3*n && cy3 > 0; ++i)
	{
		ulong a = (ulong)P[i] + cy3;
		P[i] = (uint)a;
		cy3 = (uint)(a >> 32);
	}
	cy += cy3;

	cy += bigSub(P + n, P + n, vm1, 2*n);

	for (uniform uint i = 2*n; cy2 > 0; ++i)
	{
		ulong a = (ulong)P[i] + cy2;
		P[i] = (uint)a;
		cy2 = (uint)(a >> 32);
	}
	for (uniform uint i = 3*n; cy != 0; ++i)
	{
		long a = (long)P[i] + cy;
		P[i] = (uint)a;
		cy = (int)(a >> 32);
	}
}
#endif

static unmasked void toom2SquareFull(varying ulong* uniform P, varying const ulong* uniform R, uniform uint N_Size)
{
	uniform uint s = N_Size >> 1;
	uniform uint n = N_Size - s;  // n==s or n==s+1

	varying const ulong* uniform a0 = R;
	varying const ulong* uniform a1 = R + n;
	varying ulong* uniform asm1 = P;

	if (s == n)
	{
		if (lessThan(a0, a1, n))
			bigSub(asm1, a1, a0, n);
		else
			bigSub(asm1, a0, a1, n);
	}
	else
	{
		if (a0[s] == 0 && lessThan(a0, a1, s))
		{
			bigSub(asm1, a1, a0, s);
			asm1[s] = 0;
		}
		else
		{
			asm1[s] = a0[s] + bigSub(asm1, a0, a1, s);
		}
		P[4*n-2] = 0;
		P[4*n-1] = 0;
	}

	varying ulong* uniform v0 = P;
	varying ulong vm1[MAX_N_SIZE + 1];
	varying ulong* uniform vinf = P + 2 * n;

	squareSimple(vm1, asm1, n);
	squareSimple(vinf, a1, s);
	squareSimple(v0, a0, n);
	//toom2SquareHalf(vm1, asm1, n);
	//toom2SquareHalf(vinf, a1, s);
	//toom2SquareHalf(v0, a0, n);

	long cy  = bigAdd(P + 2*n, v0 + n, vinf, n);
	ulong cy2 = cy + bigAdd(P + n, P + 2*n, v0, n);
	cy += bigAdd(P + 2*n, P + 2*n, vinf + n, n);
	cy += bigSub(P + n, P + n, vm1, 2*n);

	for (uniform uint i = 2*n; cy2 > 0; ++i)
	{
		ulong a = P[i] + cy2;
		P[i] = (uint)a;
		cy2 = (a >> 32);
	}
	for (uniform uint i = 3*n; cy != 0; ++i)
	{
		long a = (long)P[i] + cy;
		P[i] = (uint)a;
		cy = (a >> 32);
	}
}

export void fermat_test(uniform uint M_in[], uniform uint Mi_in[], uniform uint R_in[], uniform uint is_prime[], uniform uint N_Size, uniform uint shft) {

	ulong R[MAX_N_SIZE];
	uint M[MAX_N_SIZE];

	{
		// Get the index of the current element to be processed
		const int offset = programIndex * N_Size;

		for (uniform uint i = 0; i < N_Size; ++i)
		{
			M[i] = M_in[offset + i];
			R[i] = R_in[offset + i];
		}
	}


	//const uint shift = __clz(M[N_Size - 1]);
	const uniform uint highbit = ((uint)1) << 31;
	uniform uint startbit;
	uniform int en = N_Size;
	if (shft < 24)
	{
		startbit = highbit >> (shft + 8);
	}
	else
	{
		startbit = highbit >> (shft - 24);
		en--;
	}

	const uint mi = Mi_in[programIndex];

	while (en-- > 0)
	{
		uniform uint bit = startbit;
		startbit = highbit;
		uint E = M[en];
		if (en == 0) E--;

		do
		{
			{
				ulong P[MAX_N_SIZE * 2];
				//mpn_sqr(pp, rp, mn);
				//squareSimple(P, R, N_Size);
				toom2SquareFull(P, R, N_Size);

				//if (mpn_redc_1(rp, pp, mp, mn, mi) != 0) 
				//  mpn_sub_n(rp, rp, mshifted, n);
				for (uniform uint j = 0; j < N_Size; ++j)
				{
					ulong cy = 0;
					uint v = (uint)P[j] * mi;
					for (uniform uint i = 0; i < N_Size; ++i)
					{
						ulong p = (ulong)M[i] * (ulong)v + cy;
						p += P[i + j];
						P[i + j] = (uint)p;
						cy = (p >> 32);
					}
					R[j] = cy;
				}

				{
					ulong cy = 0;
					for (uniform uint i = 0; i < N_Size; ++i)
					{
						ulong a = R[i] + P[i + N_Size];
						if (E & bit) a <<= 1;
						a += cy;
						R[i] = (uint)a;
						cy = (a >> 32);
					}

					while (cy != 0)
					{
						long borrow = 0;
						uint last_shifted = 0;
						for (uniform uint i = 0; i < N_Size; ++i)
						{
							int64 a = R[i];
							uint b = (M[i] << shft) | last_shifted;
							last_shifted = M[i] >> (32 - shft);
							a = a - (int64)b + borrow;
							R[i] = (uint)a;
							borrow = (a >> 32);
						}
						cy += borrow;
					}
				}
			}
			bit >>= 1;
		} while (bit > 0);

	}

	// DeREDCify - necessary as rp can have a large
	//             multiple of m in it (although I'm not 100% sure
	//             why it can't after this redc!)
	{
		ulong T[MAX_N_SIZE * 2];
		for (uniform uint i = 0; i < N_Size; ++i)
		{
			T[i] = R[i];
			T[N_Size + i] = 0;
		}

		// MPN_REDC_1(rp, tp, mp, mn, mi);
		for (uniform uint j = 0; j < N_Size; ++j)
		{
			ulong cy = 0;
			uint v = (uint)T[j] * mi;
			for (uniform uint i = 0; i < N_Size; ++i)
			{
				ulong p = (ulong)M[i] * (ulong)v + cy;
				p += T[i + j];
				T[i + j] = (uint)p;
				cy = (p >> 32);
			}
			R[j] = cy;
		}

		{
			ulong cy = 0;
			for (uniform uint i = 0; i < N_Size; ++i)
			{
				ulong a = R[i] + cy;
				a += T[i + N_Size];
				R[i] = (uint)a;
				cy = (a >> 32);
			}

			if (cy != 0)
			{
				long borrow = 0;
				uint last_shifted = 0;
				for (uniform uint i = 0; i < N_Size; ++i)
				{
					int64 a = R[i];
					uint b = (M[i] << shft) | last_shifted;
					last_shifted = M[i] >> (32 - shft);
					a = a - (int64)b + borrow;
					R[i] = (uint)a;
					borrow = (a >> 32);
				}
			}
		}
//		print("R = %, M = %\n", R[N_Size - 1], M[N_Size - 1]);
	}

	bool result = true;
	if (R[N_Size - 1] != 0)
	{
		// Compare to m+1
		uint cy = 1;
		for (uniform uint i = 0; i < N_Size && result; ++i)
		{
			uint a = M[i] + cy;
			cy = a < M[i];
			if (R[i] != a) result = false;
		}
	}
	else
	{
		// Compare to 1
		result = R[0] == 1;
		for (uniform uint i = 1; i < N_Size && result; ++i)
		{
			if (R[i] != 0) result = false;
		}
	}

	is_prime[programIndex] = result;
}
