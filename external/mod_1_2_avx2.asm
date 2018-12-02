dnl  AMD64 mpn_mod_1s_2p

dnl  Contributed to the GNU project by Torbjorn Granlund.

dnl  Copyright 2009-2012, 2014 Free Software Foundation, Inc.
dnl  AVX implementation copyright 2018 Michael Bell

dnl  This file is derived from the GNU MP Library.
dnl
dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of either:
dnl
dnl    * the GNU Lesser General Public License as published by the Free
dnl      Software Foundation; either version 3 of the License, or (at your
dnl      option) any later version.
dnl
dnl  or
dnl
dnl    * the GNU General Public License as published by the Free Software
dnl      Foundation; either version 2 of the License, or (at your option) any
dnl      later version.
dnl
dnl  or both in parallel, as here.
dnl
dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
dnl  for more details.
dnl
dnl  You should have received copies of the GNU General Public License and the
dnl  GNU Lesser General Public License along with the GNU MP Library.  If not,
dnl  see https://www.gnu.org/licenses/.

define(`R32',
        `ifelse($1,`%rax',`%eax',
                $1,`%rbx',`%ebx',
                $1,`%rcx',`%ecx',
                $1,`%rdx',`%edx',
                $1,`%rsi',`%esi',
                $1,`%rdi',`%edi',
                $1,`%rbp',`%ebp',
                $1,`%r8',`%r8d',
                $1,`%r9',`%r9d',
                $1,`%r10',`%r10d',
                $1,`%r11',`%r11d',
                $1,`%r12',`%r12d',
                $1,`%r13',`%r13d',
                $1,`%r14',`%r14d',
                $1,`%r15',`%r15d')')
define(`R8',
        `ifelse($1,`%rax',`%al',
                $1,`%rbx',`%bl',
                $1,`%rcx',`%cl',
                $1,`%rdx',`%dl',
                $1,`%rsi',`%sil',
                $1,`%rdi',`%dil',
                $1,`%rbp',`%bpl',
                $1,`%r8',`%r8b',
                $1,`%r9',`%r9b',
                $1,`%r10',`%r10b',
                $1,`%r11',`%r11b',
                $1,`%r12',`%r12b',
                $1,`%r13',`%r13b',
                $1,`%r14',`%r14b',
                $1,`%r15',`%r15b')')

define(`PROLOGUE',
`       .globl   $1
        .type	$1,function
$1:
')

define(C, `
dnl')

define(`L',
`.L$1')

define(ALIGN,
`.align eval($1), 0x90')

C Compute a % p for 4 values of p, where a is arbitrary length > 2^256 and p < 2^32
C
C On entry:
C rdi: uint64_t* a
C rsi: uint64_t  n (length of a in 64-bit limbs)
C rdx: uint32_t* ps (array of 8 p values, each shifted left by clz(p))
C rcx: uint32_t  cnt (the shift amount referenced above, which must be the same for each p)
C r8:  uint64_t* cps (array of 8 precomputed invert_limb values correspeonding to each p)
C r9:  uint64_t* inverts in/indexes out (array of 8 inverts to multiply remainder results by to get indexes to return)
C
C During operation:
C ymm10, ymm11: B1modb
C ymm12, ymm13: B2modb
C ymm8, ymm9: B3modb

	.text
	ALIGN(32)
.LCP0:	.long 0, 2, 4, 6, 1, 3, 5, 7
PROLOGUE(rie_mod_1s_2p_8times)

	vpcmpeqd	%ymm15, %ymm15, %ymm15
	vpsrld		$31, %ymm15, %ymm14
	vpsllq		$32, %ymm14, %ymm14

	shl	$1, %rsi

	mov	$32, %r10
	sub	%rcx, %r10
	vpmovzxdq	(%rdx), %ymm0
	vpmovzxdq	16(%rdx), %ymm1
	vmovdqu		(%r8), %ymm2
	vmovdqu		32(%r8), %ymm3
	vpsrlq		$32, %ymm2, %ymm2
	vpsrlq		$32, %ymm3, %ymm3
	vmovq		%rcx, %xmm4
	vmovq		%r10, %xmm5
	vpor		%ymm14, %ymm2, %ymm6
	vpor		%ymm14, %ymm3, %ymm7
	vpsrlq		%xmm5, %ymm6, %ymm6	C ((bi >> (GMP_LIMB_BITS-cnt)) | (CNST_LIMB(1) << cnt));
	vpsrlq		%xmm5, %ymm7, %ymm7
	vpxor		%ymm5, %ymm5, %ymm5
	vpsubd		%ymm0, %ymm5, %ymm8	C -b
	vpsubd		%ymm1, %ymm5, %ymm9
	vpmulld		%ymm8, %ymm6, %ymm6   C B1modb
	vpmulld		%ymm9, %ymm7, %ymm7
	vpsrld		%xmm4, %ymm6, %ymm10
	vpsrld		%xmm4, %ymm7, %ymm11

C ymm0, ymm1: ps
C ymm2, ymm3: cps
C ymm4: cnt
C ymm5: 32-cnt
C ymm6, ymm7: B1modb
C ymm8, ymm9: Q
C ymm14: {1,0,1,0}
C ymm15: all 1s

	vpermq		$0xD8, (%rdx), %ymm0
	vpmuludq	%ymm2, %ymm6, %ymm8
	vpmuludq	%ymm3, %ymm7, %ymm9
	vshufps		$0xDD, %ymm9, %ymm8, %ymm5 # ymm5 = ymm8[1], ymm8[3], ymm9[1], ymm9[3], ymm8[5], ymm8[7], ymm9[5], ymm9[7]
	vshufps		$0x88, %ymm7, %ymm6, %ymm6 # ymm6 = ymm6[0], ymm6[2], ymm7[0], ymm7[2]
	vshufps		$0x88, %ymm9, %ymm8, %ymm8 # ymm8 = ymm8[0], ymm8[2], ymm9[0], ymm9[2]
	
	vpaddd		%ymm6, %ymm5, %ymm5
	vpxor		%ymm15, %ymm5, %ymm5
	vpmulld		%ymm0, %ymm5, %ymm5
	vpmaxud		%ymm8, %ymm5, %ymm6
	vpcmpeqd	%ymm5, %ymm6, %ymm6
	vpand		%ymm0, %ymm6, %ymm6
	vpaddd		%ymm6, %ymm5, %ymm6   C B2modb
	vpermq		$0xD8, %ymm6, %ymm12
	vextracti128	$1, %ymm12, %xmm13
	vpmovzxdq	%xmm12, %ymm12
	vpmovzxdq	%xmm13, %ymm13

	vpmuludq	%ymm2, %ymm12, %ymm8
	vpmuludq	%ymm3, %ymm13, %ymm9
	vpsrld		%xmm4, %ymm12, %ymm12
	vpsrld		%xmm4, %ymm13, %ymm13

	vshufps		$0xDD, %ymm9, %ymm8, %ymm5
	vshufps		$0x88, %ymm9, %ymm8, %ymm8
	vpaddd		%ymm6, %ymm5, %ymm5
	vpxor		%ymm15, %ymm5, %ymm5
	vpmulld		%ymm0, %ymm5, %ymm5
	vpmaxud		%ymm8, %ymm5, %ymm6
	vpcmpeqd	%ymm5, %ymm6, %ymm6
	vpand		%ymm0, %ymm6, %ymm6
	vpaddd		%ymm6, %ymm5, %ymm6   C B3modb
	vpsrld		%xmm4, %ymm6, %ymm8
	vpermq		$0xD8, %ymm8, %ymm8
	vextracti128	$1, %ymm8, %xmm9
	vpmovzxdq	%xmm8, %ymm8
	vpmovzxdq	%xmm9, %ymm9

	xor	%rax, %rax
	cmp	%rax, -4(%rdi,%rsi,4)
	jnz	L(b0)

L(b1):	lea	-16(%rdi,%rsi,4), %rdi
	vpbroadcastd	4(%rdi), %ymm0
	vmovdqa		%ymm0, %ymm1
	vpmuludq	%ymm0, %ymm10, %ymm0
	vpmuludq	%ymm1, %ymm11, %ymm1

	vpbroadcastd	(%rdi), %xmm2
	vpmovzxdq	%xmm2, %ymm2
	vmovdqa		%ymm2, %ymm3
	vpaddq		%ymm0, %ymm2, %ymm2
	vpaddq		%ymm1, %ymm3, %ymm3
	
	vpbroadcastd	8(%rdi), %ymm0
	vmovdqa		%ymm0, %ymm1
	vpmuludq	%ymm0, %ymm12, %ymm0
	vpmuludq	%ymm1, %ymm13, %ymm1
	
	sub	$3, %rsi
	test	%rcx, %rcx
	jz	L(m2)
	jmp	L(m0)

	ALIGN(8)
L(b0):	lea	-8(%rdi,%rsi,4), %rdi
	vpbroadcastq	(%rdi), %ymm4
	vmovdqa         %ymm4, %ymm5
	test	%rcx, %rcx
	jz	L(m3)
	jmp	L(m1)

C ymm6, ymm7: ph/pl
C ymm4, ymm5: rh/rl

	ALIGN(16)
L(top):	vpbroadcastd	-4(%rdi), %ymm0
	vmovdqa		%ymm0, %ymm1
	vpmuludq	%ymm0, %ymm10, %ymm0
	vpmuludq	%ymm1, %ymm11, %ymm1

	vpbroadcastd	-8(%rdi), %xmm2
	vpmovzxdq	%xmm2, %ymm2
	vmovdqa		%ymm2, %ymm3
	vpaddq		%ymm0, %ymm2, %ymm2
	vpaddq		%ymm1, %ymm3, %ymm3
	
	sub	$8, %rdi

	vpmuludq	%ymm4, %ymm12, %ymm0
	vpmuludq	%ymm5, %ymm13, %ymm1
	vpaddq		%ymm0, %ymm2, %ymm2
	vpaddq		%ymm1, %ymm3, %ymm3

	vpshufd		$0xF5, %ymm4, %ymm0
	vpshufd		$0xF5, %ymm5, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	vpmuludq	%ymm1, %ymm9, %ymm1

L(m0):	vpaddq		%ymm0, %ymm2, %ymm4
	vpaddq		%ymm1, %ymm3, %ymm5
L(m1):	sub	$2, %rsi
	ja	L(top)
	jmp 	L(end)

	ALIGN(16)
L(top32): vpbroadcastd	-4(%rdi), %ymm0
	vmovdqa		%ymm0, %ymm1
	vpmuludq	%ymm0, %ymm10, %ymm0
	vpmuludq	%ymm1, %ymm11, %ymm1

	vpbroadcastd	-8(%rdi), %xmm2
	vpmovzxdq	%xmm2, %ymm2
	vmovdqa		%ymm2, %ymm3
	vpaddq		%ymm0, %ymm2, %ymm2
	vpaddq		%ymm1, %ymm3, %ymm3

	sub	$8, %rdi

	vpmuludq	%ymm4, %ymm12, %ymm0
	vpmuludq	%ymm5, %ymm13, %ymm1
	vpaddq		%ymm0, %ymm2, %ymm2
	vpaddq		%ymm1, %ymm3, %ymm3

	vpmaxud		%ymm2, %ymm0, %ymm0
	vpmaxud		%ymm3, %ymm1, %ymm1
	vpcmpeqd	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm3, %ymm1, %ymm1
	vpshufd		$0xF5, %ymm0, %ymm0
	vpshufd		$0xF5, %ymm1, %ymm1
	vpandn		%ymm12, %ymm0, %ymm0
	vpandn		%ymm13, %ymm1, %ymm1
	vpaddq		%ymm0, %ymm2, %ymm2
	vpaddq		%ymm1, %ymm3, %ymm3

	vpshufd		$0xF5, %ymm4, %ymm0
	vpshufd		$0xF5, %ymm5, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	vpmuludq	%ymm1, %ymm9, %ymm1

L(m2):	vpaddq		%ymm0, %ymm2, %ymm4
	vpaddq		%ymm1, %ymm3, %ymm5

	vpmaxud		%ymm4, %ymm0, %ymm0
	vpmaxud		%ymm5, %ymm1, %ymm1
	vpcmpeqd	%ymm4, %ymm0, %ymm0
	vpcmpeqd	%ymm5, %ymm1, %ymm1
	vpshufd		$0xF5, %ymm0, %ymm0
	vpshufd		$0xF5, %ymm1, %ymm1
	vpandn		%ymm12, %ymm0, %ymm0
	vpandn		%ymm13, %ymm1, %ymm1
	vpaddq		%ymm0, %ymm4, %ymm4
	vpaddq		%ymm1, %ymm5, %ymm5

L(m3):	sub	$2, %rsi
	ja	L(top32)

L(end):	vpshufd         $0xF5, %ymm4, %ymm0
	vpshufd         $0xF5, %ymm5, %ymm1
	vpmuludq	%ymm0, %ymm10, %ymm0
	vpmuludq	%ymm1, %ymm11, %ymm1
	vpsrlq		$32, %ymm15, %ymm6
	vpand		%ymm6, %ymm4, %ymm4
	vpand		%ymm6, %ymm5, %ymm5
	vpaddq		%ymm0, %ymm4, %ymm4
	vpaddq		%ymm1, %ymm5, %ymm5

	vmovq		%rcx, %xmm0
	vpsllq		%xmm0, %ymm4, %ymm4
	vpsllq		%xmm0, %ymm5, %ymm5
	vpshufd         $0xF5, %ymm4, %ymm6 C ymm4/ymm5 have rl << cnt
	vpshufd         $0xF5, %ymm5, %ymm7 C ymm6/ymm7 have r

	vmovdqu		(%r8), %ymm8
	vmovdqu		32(%r8), %ymm9
	vpshufd		$0xF5, %ymm8, %ymm8
	vpshufd		$0xF5, %ymm9, %ymm9

	vpmuludq	%ymm6, %ymm8, %ymm2
	vpmuludq	%ymm7, %ymm9, %ymm3 C ymm2/ymm3 have qh/ql

	vpaddd		%ymm14, %ymm4, %ymm4
	vpaddd		%ymm14, %ymm5, %ymm5
	vpaddq		%ymm4, %ymm2, %ymm2
	vpaddq		%ymm5, %ymm3, %ymm3

	vshufps		$0xDD, %ymm3, %ymm2, %ymm6
	vshufps		$0x88, %ymm3, %ymm2, %ymm2
	vshufps		$0x88, %ymm5, %ymm4, %ymm4
	vpermq		$0xD8, (%rdx), %ymm0
	vpmulld		%ymm0, %ymm6, %ymm6
	vpsubd		%ymm6, %ymm4, %ymm4
	vpmaxud		%ymm2, %ymm4, %ymm6
	vpcmpeqd	%ymm4, %ymm6, %ymm6
	vpand		%ymm0, %ymm6, %ymm6
	vpaddd		%ymm6, %ymm4, %ymm4
	vpmaxud		%ymm4, %ymm0, %ymm6
	vpcmpeqd	%ymm0, %ymm6, %ymm6
	vpandn		%ymm0, %ymm6, %ymm6
	vpsubd		%ymm6, %ymm4, %ymm4

	vpsubd		%ymm4, %ymm0, %ymm4
	vpermq		$0xD8, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpmovzxdq	%xmm4, %ymm4
	vpmovzxdq	%xmm5, %ymm5

	vpmuludq	(%r9), %ymm4, %ymm4
	vpmuludq	32(%r9), %ymm5, %ymm5

	vpshufd		$0xF5, %ymm4, %ymm6
	vpshufd		$0xF5, %ymm5, %ymm7
	vpmuludq	%ymm6, %ymm8, %ymm2
	vpmuludq	%ymm7, %ymm9, %ymm3 C ymm2/ymm3 have qh/ql

	vpaddd		%ymm14, %ymm4, %ymm4
	vpaddd		%ymm14, %ymm5, %ymm5
	vpaddq		%ymm4, %ymm2, %ymm2
	vpaddq		%ymm5, %ymm3, %ymm3

	vshufps		$0xDD, %ymm3, %ymm2, %ymm6 C ymm6 = qh
	vshufps		$0x88, %ymm3, %ymm2, %ymm2 C ymm2 = ql
	vshufps		$0x88, %ymm5, %ymm4, %ymm4 C ymm4 = nl
	vpmulld		%ymm0, %ymm6, %ymm6
	vpsubd		%ymm6, %ymm4, %ymm4
	vpmaxud		%ymm2, %ymm4, %ymm6
	vpcmpeqd	%ymm4, %ymm6, %ymm6
	vpand		%ymm0, %ymm6, %ymm6
	vpaddd		%ymm6, %ymm4, %ymm4
	vpmaxud		%ymm4, %ymm0, %ymm6
	vpcmpeqd	%ymm0, %ymm6, %ymm6
	vpandn		%ymm0, %ymm6, %ymm6
	vpsubd		%ymm6, %ymm4, %ymm4

	vmovq		%rcx, %xmm0
	vpsrld		%xmm0, %ymm4, %ymm4
	vpermq		$0xD8, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpmovzxdq	%xmm4, %ymm4
	vpmovzxdq	%xmm5, %ymm5
	vmovdqu		%ymm4, (%r9)
	vmovdqu		%ymm5, 32(%r9)
	vzeroupper
	ret
