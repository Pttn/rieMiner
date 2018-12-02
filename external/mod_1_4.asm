dnl  AMD64 mpn_mod_1s_4p

dnl  Contributed to the GNU project by Torbjorn Granlund.

dnl  Copyright 2009-2012, 2014 Free Software Foundation, Inc.

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

C	     cycles/limb
C AMD K8,K9	 3
C AMD K10	 3
C Intel P4	15.5
C Intel core2	 5
C Intel corei	 4
C Intel atom	23
C VIA nano	 4.75

	.text
	ALIGN(16)
PROLOGUE(rie_mod_1s_4p)
	push	%r14
	push	%r13
	push	%r12
	push	%rbp
	push	%rbx

	push	%rdx
	mov	%r8, %r14

	mov	(%r8), %rax
	mov	%rdx, %r8

	neg	%r8
	mov	%rdx, %r12
	mov	%rax, %r9
	mov	$1, R32(%r10)
	shld	R8(%rcx), %rax, %r10
	imul	%r8, %r10
	mul	%r10

	add	%r10, %rdx
	shr	R8(%rcx), %r10
	mov	%r10, %r11			C B1modb

	not	%rdx
	imul	%r12, %rdx
	lea	(%rdx,%r12), %r10
	cmp	%rdx, %rax
	cmovnc	%rdx, %r10
	mov	%r9, %rax
	mul	%r10

	add	%r10, %rdx
	shr	R8(%rcx), %r10
	mov	%r10, %rbx			C B2modb

	not	%rdx
	imul	%r12, %rdx
	lea	(%rdx,%r12), %r10
	cmp	%rdx, %rax
	cmovnc	%rdx, %r10
	mov	%r9, %rax
	mul	%r10

	add	%r10, %rdx
	shr	R8(%rcx), %r10
	mov	%r10, %rbp			C B3modb

	not	%rdx
	imul	%r12, %rdx
	lea	(%rdx,%r12), %r10
	cmp	%rdx, %rax
	cmovnc	%rdx, %r10
	mov	%r9, %rax
	mul	%r10

	add	%r10, %rdx
	shr	R8(%rcx), %r10
	mov	%r10, %r13			C B4modb

	not	%rdx
	imul	%r12, %rdx
	add	%rdx, %r12
	cmp	%rdx, %rax
	cmovnc	%rdx, %r12

	shr	R8(%rcx), %r12			C B5modb
	push	%rcx

	xor	R32(%r8), R32(%r8)
	mov	R32(%rsi), R32(%rdx)
	and	$3, R32(%rdx)
	je	L(b0)
	cmp	$2, R32(%rdx)
	jc	L(b1)
	je	L(b2)

L(b3):	lea	-24(%rdi,%rsi,8), %rdi
	mov	8(%rdi), %rax
	mul	%r11
	mov	(%rdi), %r9
	add	%rax, %r9
	adc	%rdx, %r8
	mov	16(%rdi), %rax
	mul	%rbx
	jmp	L(m0)

	ALIGN(8)
L(b0):	lea	-32(%rdi,%rsi,8), %rdi
	mov	8(%rdi), %rax
	mul	%r11
	mov	(%rdi), %r9
	add	%rax, %r9
	adc	%rdx, %r8
	mov	16(%rdi), %rax
	mul	%rbx
	add	%rax, %r9
	adc	%rdx, %r8
	mov	24(%rdi), %rax
	mul	%rbp
	jmp	L(m0)

	ALIGN(8)
L(b1):	lea	-8(%rdi,%rsi,8), %rdi
	mov	(%rdi), %r9
	jmp	L(m1)

	ALIGN(8)
L(b2):	lea	-16(%rdi,%rsi,8), %rdi
	mov	8(%rdi), %r8
	mov	(%rdi), %r9
	jmp	L(m1)

	ALIGN(16)
L(top):	mov	-24(%rdi), %rax
	mov	-32(%rdi), %r10
	mul	%r11			C up[1] * B1modb
	add	%rax, %r10
	mov	-16(%rdi), %rax
	mov	$0, R32(%rcx)
	adc	%rdx, %rcx
	mul	%rbx			C up[2] * B2modb
	add	%rax, %r10
	mov	-8(%rdi), %rax
	adc	%rdx, %rcx
	sub	$32, %rdi
	mul	%rbp			C up[3] * B3modb
	add	%rax, %r10
	mov	%r13, %rax
	adc	%rdx, %rcx
	mul	%r9			C rl * B4modb
	add	%rax, %r10
	mov	%r12, %rax
	adc	%rdx, %rcx
	mul	%r8			C rh * B5modb
	mov	%r10, %r9
	mov	%rcx, %r8
L(m0):	add	%rax, %r9
	adc	%rdx, %r8
L(m1):	sub	$4, %rsi
	ja	L(top)

L(end):	pop	%rsi
	mov	%r8, %rax
	mul	%r11
	mov	%rax, %r8
	add	%r9, %r8
	adc	$0, %rdx
	xor	R32(%rcx), R32(%rcx)
	sub	R32(%rsi), R32(%rcx)
	mov	%r8, %rdi
	shr	R8(%rcx), %rdi
	mov	R32(%rsi), R32(%rcx)
	sal	R8(%rcx), %rdx
	or	%rdx, %rdi
	mov	%rdi, %rax
	mulq	(%r14)
	pop	%rbx
	mov	%rax, %r9
	sal	R8(%rcx), %r8
	inc	%rdi
	add	%r8, %r9
	adc	%rdi, %rdx
	imul	%rbx, %rdx
	sub	%rdx, %r8
	lea	(%r8,%rbx), %rax
	cmp	%r8, %r9
	cmovc	%rax, %r8
	mov	%r8, %rax
	sub	%rbx, %rax
	cmovc	%r8, %rax
dnl	shr	R8(%rcx), %rax
	pop	%rbx
	pop	%rbp
	pop	%r12
	pop	%r13
	pop	%r14
	ret

	ALIGN(16)
PROLOGUE(rie_mod_1s_4p_cps)
	bsr	%rsi, %rcx
	push	%rbx
	mov	%rdi, %rbx
	xor	$63, R32(%rcx)
	mov	%rsi, %rdi
	sal	R8(%rcx), %rdi		C b << cnt
dnl	ASSERT(nz, `test $15, %rsp')
	call	__gmpn_invert_limb
	mov	%rax, (%rbx)		C store bi

	pop	%rbx
	ret
