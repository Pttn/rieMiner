	.text
	.file	"primetest.ispc"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
.LCPI0_0:
	.quad	1                       # 0x1
.LCPI0_1:
	.quad	4294967294              # 0xfffffffe
	.text
	.p2align	4, 0x90
	.type	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu,@function
squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu: # @squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
# %bb.0:                                # %allocas
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-128, %rsp
	subq	$16384, %rsp            # imm = 0x4000
                                        # kill: def $edx killed $edx def $rdx
	movl	%edx, %r11d
	addl	$-1, %r11d
	je	.LBB0_1
# %bb.3:                                # %for_loop.lr.ph
	vpxor	%xmm4, %xmm4, %xmm4
	vpblendd	$85, 96(%rsi), %ymm4, %ymm0 # ymm0 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	vpblendd	$85, 64(%rsi), %ymm4, %ymm1 # ymm1 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	vpblendd	$85, 32(%rsi), %ymm4, %ymm2 # ymm2 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	vpblendd	$85, (%rsi), %ymm4, %ymm3 # ymm3 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	leal	-2(%rdx), %r14d
	movl	%r11d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r14d
	jae	.LBB0_5
# %bb.4:
	xorl	%eax, %eax
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	testl	%ecx, %ecx
	jne	.LBB0_8
	jmp	.LBB0_10
.LBB0_1:                                # %for_loop75.lr.ph.thread
	movl	%r11d, %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%ymm0, 224(%rsp,%rax)
	vmovdqa	%ymm0, 192(%rsp,%rax)
	vmovdqa	%ymm0, 160(%rsp,%rax)
	vmovdqa	%ymm0, 128(%rsp,%rax)
	movl	%edx, %r8d
	andl	$1, %r8d
	xorl	%r15d, %r15d
	xorl	%r10d, %r10d
	jmp	.LBB0_2
.LBB0_5:                                # %for_loop.lr.ph.new
	movl	%r11d, %r9d
	subl	%ecx, %r9d
	vpxor	%xmm5, %xmm5, %xmm5
	movl	$384, %ebx              # imm = 0x180
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB0_6:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vpmuludq	-160(%rsi,%rbx), %ymm0, %ymm9
	vpmuludq	-192(%rsi,%rbx), %ymm1, %ymm10
	vpaddq	%ymm8, %ymm9, %ymm8
	vpaddq	%ymm7, %ymm10, %ymm7
	vpmuludq	-256(%rsi,%rbx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	-224(%rsi,%rbx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqa	%ymm12, -224(%rsp,%rbx)
	vmovdqa	%ymm11, -256(%rsp,%rbx)
	vmovdqa	%ymm10, -192(%rsp,%rbx)
	vmovdqa	%ymm9, -160(%rsp,%rbx)
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	-64(%rsi,%rbx), %ymm1, %ymm9
	vpmuludq	-128(%rsi,%rbx), %ymm3, %ymm10
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm4, %ymm10, %ymm4
	vpmuludq	-96(%rsi,%rbx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpmuludq	-32(%rsi,%rbx), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqa	%ymm12, -32(%rsp,%rbx)
	vmovdqa	%ymm11, -96(%rsp,%rbx)
	vmovdqa	%ymm10, -128(%rsp,%rbx)
	vmovdqa	%ymm9, -64(%rsp,%rbx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpmuludq	96(%rsi,%rbx), %ymm0, %ymm9
	vpmuludq	64(%rsi,%rbx), %ymm1, %ymm10
	vpaddq	%ymm8, %ymm9, %ymm8
	vpaddq	%ymm7, %ymm10, %ymm7
	vpmuludq	(%rsi,%rbx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	32(%rsi,%rbx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqa	%ymm12, 32(%rsp,%rbx)
	vmovdqa	%ymm11, (%rsp,%rbx)
	vmovdqa	%ymm10, 64(%rsp,%rbx)
	vmovdqa	%ymm9, 96(%rsp,%rbx)
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	addq	$4, %rax
	vpmuludq	192(%rsi,%rbx), %ymm1, %ymm9
	vpaddq	%ymm7, %ymm9, %ymm7
	vpmuludq	128(%rsi,%rbx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	160(%rsi,%rbx), %ymm2, %ymm9
	vpmuludq	224(%rsi,%rbx), %ymm0, %ymm10
	vpaddq	%ymm6, %ymm9, %ymm6
	vpaddq	%ymm8, %ymm10, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqa	%ymm12, 224(%rsp,%rbx)
	vmovdqa	%ymm11, 160(%rsp,%rbx)
	vmovdqa	%ymm10, 128(%rsp,%rbx)
	vmovdqa	%ymm9, 192(%rsp,%rbx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	addq	$512, %rbx              # imm = 0x200
	cmpl	%eax, %r9d
	jne	.LBB0_6
# %bb.7:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB0_10
.LBB0_8:                                # %for_loop.epil.preheader
	shlq	$7, %rax
	negl	%ecx
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB0_9:                                # %for_loop.epil
                                        # =>This Inner Loop Header: Depth=1
	vpmuludq	224(%rsi,%rax), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpmuludq	192(%rsi,%rax), %ymm1, %ymm9
	vpaddq	%ymm7, %ymm9, %ymm7
	vpmuludq	128(%rsi,%rax), %ymm3, %ymm9
	vpmuludq	160(%rsi,%rax), %ymm2, %ymm10
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqa	%ymm12, 160(%rsp,%rax)
	vmovdqa	%ymm11, 128(%rsp,%rax)
	vmovdqa	%ymm10, 192(%rsp,%rax)
	vmovdqa	%ymm9, 224(%rsp,%rax)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	subq	$-128, %rax
	addl	$1, %ecx
	jne	.LBB0_9
.LBB0_10:                               # %for_exit
	movl	%r11d, 108(%rsp)        # 4-byte Spill
	movl	%r11d, %r15d
	movq	%r15, %rax
	shlq	$7, %rax
	vmovdqa	%ymm8, 224(%rsp,%rax)
	vmovdqa	%ymm7, 192(%rsp,%rax)
	vmovdqa	%ymm6, 160(%rsp,%rax)
	vmovdqa	%ymm4, 128(%rsp,%rax)
	cmpl	$3, %edx
	jb	.LBB0_19
# %bb.11:                               # %for_test30.preheader.lr.ph
	leal	-3(%rdx), %r9d
	movl	%edx, %eax
	movq	%rax, 120(%rsp)         # 8-byte Spill
	movq	%rsi, %rax
	subq	$-128, %rax
	movq	%rax, 112(%rsp)         # 8-byte Spill
	movl	$2, %r13d
	xorl	%r12d, %r12d
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rdx, %r11
	.p2align	4, 0x90
.LBB0_12:                               # %for_loop32.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_17 Depth 2
	movl	%r14d, %ebx
	subl	%r12d, %ebx
	movq	%r13, %rax
	shlq	$7, %rax
	vpblendd	$85, -32(%rsi,%rax), %ymm0, %ymm1 # ymm1 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -64(%rsi,%rax), %ymm0, %ymm2 # ymm2 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -96(%rsi,%rax), %ymm0, %ymm3 # ymm3 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -128(%rsi,%rax), %ymm0, %ymm4 # ymm4 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	leaq	-2(%r13), %rcx
	testb	$1, %bl
	jne	.LBB0_14
# %bb.13:                               #   in Loop: Header=BB0_12 Depth=1
	movq	%r13, %rbx
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm5, %xmm5, %xmm5
	cmpl	%r12d, %r9d
	jne	.LBB0_16
	jmp	.LBB0_18
	.p2align	4, 0x90
.LBB0_14:                               # %for_loop32.prol.preheader
                                        #   in Loop: Header=BB0_12 Depth=1
	vpmuludq	(%rsi,%rax), %ymm4, %ymm5
	vpmuludq	32(%rsi,%rax), %ymm3, %ymm6
	vpmuludq	64(%rsi,%rax), %ymm2, %ymm7
	vpmuludq	96(%rsi,%rax), %ymm1, %ymm8
	leal	(%rcx,%r13), %eax
	shlq	$7, %rax
	vpaddq	224(%rsp,%rax), %ymm8, %ymm8
	vpaddq	192(%rsp,%rax), %ymm7, %ymm7
	vpaddq	160(%rsp,%rax), %ymm6, %ymm9
	vpaddq	128(%rsp,%rax), %ymm5, %ymm10
	vpblendd	$170, %ymm0, %ymm9, %ymm5 # ymm5 = ymm9[0],ymm0[1],ymm9[2],ymm0[3],ymm9[4],ymm0[5],ymm9[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm7, %ymm6 # ymm6 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vmovdqa	%ymm11, 224(%rsp,%rax)
	vmovdqa	%ymm6, 192(%rsp,%rax)
	vmovdqa	%ymm5, 160(%rsp,%rax)
	vpblendd	$170, %ymm0, %ymm10, %ymm5 # ymm5 = ymm10[0],ymm0[1],ymm10[2],ymm0[3],ymm10[4],ymm0[5],ymm10[6],ymm0[7]
	vmovdqa	%ymm5, 128(%rsp,%rax)
	vpsrlq	$32, %ymm8, %ymm5
	vpsrlq	$32, %ymm7, %ymm6
	vpsrlq	$32, %ymm9, %ymm7
	vpsrlq	$32, %ymm10, %ymm8
	leaq	1(%r13), %rbx
	cmpl	%r12d, %r9d
	je	.LBB0_18
.LBB0_16:                               # %for_loop32.preheader
                                        #   in Loop: Header=BB0_12 Depth=1
	movq	120(%rsp), %rax         # 8-byte Reload
	subq	%rbx, %rax
	leaq	(%rbx,%r12), %r8
	shlq	$7, %rbx
	addq	112(%rsp), %rbx         # 8-byte Folded Reload
	.p2align	4, 0x90
.LBB0_17:                               # %for_loop32
                                        #   Parent Loop BB0_12 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmuludq	-128(%rbx), %ymm4, %ymm9
	vpmuludq	-96(%rbx), %ymm3, %ymm10
	vpmuludq	-64(%rbx), %ymm2, %ymm11
	vpmuludq	-32(%rbx), %ymm1, %ymm12
	movl	%r8d, %r10d
	shlq	$7, %r10
	vpaddq	128(%rsp,%r10), %ymm8, %ymm8
	vpaddq	%ymm9, %ymm8, %ymm8
	vpaddq	160(%rsp,%r10), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	192(%rsp,%r10), %ymm6, %ymm6
	vpaddq	224(%rsp,%r10), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm6, %ymm6
	vpaddq	%ymm12, %ymm5, %ymm5
	vpblendd	$170, %ymm0, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm0[1],ymm6[2],ymm0[3],ymm6[4],ymm0[5],ymm6[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm5, %ymm12 # ymm12 = ymm5[0],ymm0[1],ymm5[2],ymm0[3],ymm5[4],ymm0[5],ymm5[6],ymm0[7]
	vmovdqa	%ymm12, 224(%rsp,%r10)
	vmovdqa	%ymm11, 192(%rsp,%r10)
	vmovdqa	%ymm10, 160(%rsp,%r10)
	vmovdqa	%ymm9, 128(%rsp,%r10)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	(%rbx), %ymm4, %ymm9
	vpmuludq	32(%rbx), %ymm3, %ymm10
	vpmuludq	96(%rbx), %ymm1, %ymm11
	vpmuludq	64(%rbx), %ymm2, %ymm12
	leal	1(%r8), %edx
	shlq	$7, %rdx
	vpaddq	128(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	160(%rsp,%rdx), %ymm7, %ymm7
	vpaddq	%ymm9, %ymm8, %ymm8
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	224(%rsp,%rdx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	192(%rsp,%rdx), %ymm6, %ymm6
	vpaddq	%ymm12, %ymm6, %ymm6
	vpblendd	$170, %ymm0, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm0[1],ymm5[2],ymm0[3],ymm5[4],ymm0[5],ymm5[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm0[1],ymm6[2],ymm0[3],ymm6[4],ymm0[5],ymm6[6],ymm0[7]
	vmovdqa	%ymm12, 192(%rsp,%rdx)
	vmovdqa	%ymm11, 224(%rsp,%rdx)
	vmovdqa	%ymm10, 160(%rsp,%rdx)
	vmovdqa	%ymm9, 128(%rsp,%rdx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %r8
	addq	$256, %rbx              # imm = 0x100
	addq	$-2, %rax
	jne	.LBB0_17
.LBB0_18:                               # %for_exit33
                                        #   in Loop: Header=BB0_12 Depth=1
	movq	%r11, %rdx
	addl	%edx, %ecx
	shlq	$7, %rcx
	vmovdqa	%ymm5, 224(%rsp,%rcx)
	vmovdqa	%ymm6, 192(%rsp,%rcx)
	vmovdqa	%ymm7, 160(%rsp,%rcx)
	vmovdqa	%ymm8, 128(%rsp,%rcx)
	addq	$1, %r13
	addq	$1, %r12
	cmpl	%r14d, %r12d
	jne	.LBB0_12
.LBB0_19:                               # %for_test73.preheader
	testl	%edx, %edx
	je	.LBB0_20
# %bb.21:                               # %for_loop75.lr.ph
	movl	108(%rsp), %r11d        # 4-byte Reload
	testl	%r11d, %r11d
	je	.LBB0_22
# %bb.26:                               # %for_loop75.lr.ph.new
	movl	%edx, %r8d
	andl	$1, %r8d
	movl	%edx, %r9d
	subl	%r8d, %r9d
	movq	%rsi, %rcx
	subq	$-128, %rcx
	movl	$3, %ebx
	xorl	%r10d, %r10d
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB0_27:                               # %for_loop75
                                        # =>This Inner Loop Header: Depth=1
	vpblendd	$85, -128(%rcx), %ymm0, %ymm1 # ymm1 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -96(%rcx), %ymm0, %ymm2 # ymm2 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -64(%rcx), %ymm0, %ymm3 # ymm3 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -32(%rcx), %ymm0, %ymm4 # ymm4 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpmuludq	%ymm4, %ymm4, %ymm4
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm1, %ymm1
	leal	-3(%rbx), %eax
	shlq	$7, %rax
	vpblendd	$170, %ymm0, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vmovdqu	%ymm8, 96(%rdi,%rax)
	vmovdqu	%ymm7, 64(%rdi,%rax)
	vmovdqu	%ymm6, 32(%rdi,%rax)
	vmovdqu	%ymm5, (%rdi,%rax)
	leal	-2(%rbx), %eax
	shlq	$7, %rax
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm4, %ymm4
	vmovdqu	%ymm4, 96(%rdi,%rax)
	vmovdqu	%ymm2, 32(%rdi,%rax)
	vmovdqu	%ymm1, (%rdi,%rax)
	vmovdqu	%ymm3, 64(%rdi,%rax)
	vpblendd	$85, 64(%rcx), %ymm0, %ymm1 # ymm1 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, (%rcx), %ymm0, %ymm2 # ymm2 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, 32(%rcx), %ymm0, %ymm3 # ymm3 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, 96(%rcx), %ymm0, %ymm4 # ymm4 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpmuludq	%ymm4, %ymm4, %ymm4
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm1, %ymm1
	leal	-1(%rbx), %eax
	shlq	$7, %rax
	vpblendd	$170, %ymm0, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vmovdqu	%ymm8, 96(%rdi,%rax)
	vmovdqu	%ymm7, 32(%rdi,%rax)
	vmovdqu	%ymm6, (%rdi,%rax)
	vmovdqu	%ymm5, 64(%rdi,%rax)
	movl	%ebx, %eax
	shlq	$7, %rax
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vmovdqu	%ymm4, 96(%rdi,%rax)
	vmovdqu	%ymm1, 64(%rdi,%rax)
	vmovdqu	%ymm3, 32(%rdi,%rax)
	vmovdqu	%ymm2, (%rdi,%rax)
	addq	$2, %r10
	addq	$256, %rcx              # imm = 0x100
	addl	$4, %ebx
	cmpl	%r10d, %r9d
	jne	.LBB0_27
.LBB0_2:                                # %for_test73.for_test107.preheader_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	jne	.LBB0_23
# %bb.24:                               # %for_test107.preheader
	testl	%r11d, %r11d
	je	.LBB0_25
.LBB0_28:                               # %for_loop109.preheader
	vpxor	%xmm0, %xmm0, %xmm0
	movl	$1, %eax
	vpbroadcastq	.LCPI0_0(%rip), %ymm1 # ymm1 = [1,1,1,1]
	vpbroadcastq	.LCPI0_1(%rip), %ymm2 # ymm2 = [4294967294,4294967294,4294967294,4294967294]
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB0_29:                               # %for_loop109
                                        # =>This Inner Loop Header: Depth=1
	leal	-1(%rax), %ebx
	movl	%eax, %ecx
	cltq
	movq	%rax, %rsi
	shlq	$7, %rsi
	vpaddq	64(%rdi,%rsi), %ymm5, %ymm7
	vpaddq	(%rdi,%rsi), %ymm3, %ymm8
	vpaddq	32(%rdi,%rsi), %ymm4, %ymm9
	vpaddq	96(%rdi,%rsi), %ymm6, %ymm6
	shlq	$7, %rbx
	vmovdqa	128(%rsp,%rbx), %ymm3
	vmovdqa	160(%rsp,%rbx), %ymm4
	vmovdqa	192(%rsp,%rbx), %ymm5
	vmovdqa	224(%rsp,%rbx), %ymm10
	vpaddq	%ymm10, %ymm10, %ymm11
	vpaddq	%ymm4, %ymm4, %ymm12
	vpaddq	%ymm3, %ymm3, %ymm13
	vpaddq	%ymm5, %ymm5, %ymm14
	vpand	%ymm2, %ymm14, %ymm14
	vpaddq	%ymm14, %ymm7, %ymm7
	vpand	%ymm2, %ymm13, %ymm13
	vpaddq	%ymm13, %ymm8, %ymm8
	vpand	%ymm2, %ymm12, %ymm12
	vpaddq	%ymm12, %ymm9, %ymm9
	vpand	%ymm2, %ymm11, %ymm11
	vpaddq	%ymm11, %ymm6, %ymm6
	shlq	$7, %rcx
	vpblendd	$170, %ymm0, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm9, %ymm13 # ymm13 = ymm9[0],ymm0[1],ymm9[2],ymm0[3],ymm9[4],ymm0[5],ymm9[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm6, %ymm14 # ymm14 = ymm6[0],ymm0[1],ymm6[2],ymm0[3],ymm6[4],ymm0[5],ymm6[6],ymm0[7]
	vmovdqu	%ymm14, 96(%rdi,%rcx)
	vmovdqu	%ymm13, 32(%rdi,%rcx)
	vmovdqu	%ymm12, (%rdi,%rcx)
	vmovdqu	%ymm11, 64(%rdi,%rcx)
	vpsrlq	$31, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsrlq	$32, %ymm6, %ymm11
	vpsrlq	$32, %ymm7, %ymm12
	vpsrlq	$32, %ymm9, %ymm13
	vpsrlq	$32, %ymm8, %ymm14
	vmovdqa	128(%rsp,%rcx), %ymm9
	vmovdqa	160(%rsp,%rcx), %ymm8
	vmovdqa	192(%rsp,%rcx), %ymm7
	vmovdqa	224(%rsp,%rcx), %ymm6
	leal	1(%rax), %ecx
	movslq	%ecx, %rsi
	shlq	$7, %rsi
	vpaddq	%ymm9, %ymm9, %ymm15
	vpand	%ymm2, %ymm15, %ymm15
	vpaddq	%ymm15, %ymm14, %ymm14
	vpaddq	%ymm8, %ymm8, %ymm15
	vpand	%ymm2, %ymm15, %ymm15
	vpaddq	%ymm15, %ymm13, %ymm13
	vpaddq	%ymm7, %ymm7, %ymm15
	vpand	%ymm2, %ymm15, %ymm15
	vpaddq	%ymm15, %ymm12, %ymm12
	vpaddq	%ymm6, %ymm6, %ymm15
	vpand	%ymm2, %ymm15, %ymm15
	vpaddq	96(%rdi,%rsi), %ymm10, %ymm10
	vpaddq	%ymm15, %ymm11, %ymm11
	vpaddq	%ymm11, %ymm10, %ymm10
	vpsrlq	$31, %ymm5, %ymm5
	vpand	%ymm1, %ymm5, %ymm5
	vpaddq	64(%rdi,%rsi), %ymm5, %ymm5
	vpaddq	%ymm12, %ymm5, %ymm5
	vpsrlq	$31, %ymm4, %ymm4
	vpsrlq	$31, %ymm3, %ymm3
	vpand	%ymm1, %ymm4, %ymm4
	vpaddq	32(%rdi,%rsi), %ymm4, %ymm4
	vpand	%ymm1, %ymm3, %ymm3
	vpaddq	%ymm13, %ymm4, %ymm4
	vpaddq	(%rdi,%rsi), %ymm3, %ymm3
	shlq	$7, %rcx
	vpblendd	$170, %ymm0, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm0[1],ymm10[2],ymm0[3],ymm10[4],ymm0[5],ymm10[6],ymm0[7]
	vmovdqu	%ymm11, 96(%rdi,%rcx)
	vpaddq	%ymm14, %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm0[1],ymm5[2],ymm0[3],ymm5[4],ymm0[5],ymm5[6],ymm0[7]
	vmovdqu	%ymm11, 64(%rdi,%rcx)
	vpblendd	$170, %ymm0, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vmovdqu	%ymm11, 32(%rdi,%rcx)
	vpblendd	$170, %ymm0, %ymm3, %ymm11 # ymm11 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqu	%ymm11, (%rdi,%rcx)
	vpsrlq	$31, %ymm9, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$31, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpsrlq	$32, %ymm4, %ymm4
	vpaddq	%ymm8, %ymm4, %ymm4
	vpsrlq	$31, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpsrlq	$31, %ymm6, %ymm6
	vpand	%ymm1, %ymm6, %ymm6
	vpsrlq	$32, %ymm10, %ymm7
	vpaddq	%ymm6, %ymm7, %ymm6
	addl	$2, %eax
	addq	$-1, %r15
	jne	.LBB0_29
	jmp	.LBB0_30
.LBB0_20:
	movl	108(%rsp), %r11d        # 4-byte Reload
	testl	%r11d, %r11d
	jne	.LBB0_28
	jmp	.LBB0_25
.LBB0_22:
	xorl	%r10d, %r10d
.LBB0_23:                               # %for_loop75.epil.preheader
	movq	%r10, %rcx
	shlq	$7, %rcx
	vpxor	%xmm0, %xmm0, %xmm0
	vpblendd	$85, 64(%rsi,%rcx), %ymm0, %ymm1 # ymm1 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, (%rsi,%rcx), %ymm0, %ymm2 # ymm2 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, 32(%rsi,%rcx), %ymm0, %ymm3 # ymm3 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, 96(%rsi,%rcx), %ymm0, %ymm4 # ymm4 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpmuludq	%ymm4, %ymm4, %ymm4
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm1, %ymm1
	leal	(%r10,%r10), %ecx
	shlq	$7, %rcx
	vpblendd	$170, %ymm0, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm0 # ymm0 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vmovdqu	%ymm0, 96(%rdi,%rcx)
	vmovdqu	%ymm7, 32(%rdi,%rcx)
	vmovdqu	%ymm6, (%rdi,%rcx)
	vmovdqu	%ymm5, 64(%rdi,%rcx)
	leal	(%r10,%r10), %eax
	addl	$1, %eax
	shlq	$7, %rax
	vpsrlq	$32, %ymm2, %ymm0
	vpsrlq	$32, %ymm3, %ymm2
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm3
	vmovdqu	%ymm3, 96(%rdi,%rax)
	vmovdqu	%ymm1, 64(%rdi,%rax)
	vmovdqu	%ymm2, 32(%rdi,%rax)
	vmovdqu	%ymm0, (%rdi,%rax)
	testl	%r11d, %r11d
	jne	.LBB0_28
.LBB0_25:
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
.LBB0_30:                               # %for_exit110
	leal	(%rdx,%rdx), %eax
	addl	$-1, %eax
	shlq	$7, %rax
	vpaddq	(%rdi,%rax), %ymm3, %ymm0
	vpaddq	32(%rdi,%rax), %ymm4, %ymm1
	vpaddq	64(%rdi,%rax), %ymm5, %ymm2
	vpaddq	96(%rdi,%rax), %ymm6, %ymm3
	vmovdqu	%ymm3, 96(%rdi,%rax)
	vmovdqu	%ymm2, 64(%rdi,%rax)
	vmovdqu	%ymm1, 32(%rdi,%rax)
	vmovdqu	%ymm0, (%rdi,%rax)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end0:
	.size	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu, .Lfunc_end0-squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
.LCPI1_0:
	.quad	-9223372036854775808    # 0x8000000000000000
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI1_1:
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	3                       # 0x3
.LCPI1_2:
	.long	4                       # 0x4
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
	.long	7                       # 0x7
.LCPI1_3:
	.zero	32
	.text
	.p2align	4, 0x90
	.type	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu,@function
toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu: # @toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
# %bb.0:                                # %allocas
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-128, %rsp
	subq	$8832, %rsp             # imm = 0x2280
                                        # kill: def $edx killed $edx def $rdx
	movq	%rsi, %r13
	movq	%rdi, %rbx
	movl	%edx, %r9d
	shrl	%r9d
	movq	%rdx, %rax
	movq	%rdx, 56(%rsp)          # 8-byte Spill
	subl	%r9d, %eax
	movq	%rax, %rcx
	shlq	$7, %rcx
	movq	%rcx, 48(%rsp)          # 8-byte Spill
	leaq	(%rsi,%rcx), %r10
	movq	%rax, %r12
	cmpl	%eax, %r9d
	jne	.LBB1_20
# %bb.1:                                # %for_test.i.preheader
	leal	-1(%r9), %eax
	vbroadcastsd	.LCPI1_0(%rip), %ymm0 # ymm0 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
	vmovaps	%ymm0, 160(%rsp)        # 32-byte Spill
                                        # implicit-def: $ymm0
                                        # kill: killed $ymm0
                                        # implicit-def: $ymm14
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vmovdqa	%ymm0, 64(%rsp)         # 32-byte Spill
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	jmp	.LBB1_2
	.p2align	4, 0x90
.LBB1_19:                               # %no_return43.i
                                        #   in Loop: Header=BB1_2 Depth=1
	vmovaps	%ymm1, %ymm14
	vmovaps	%ymm15, 128(%rsp)       # 32-byte Spill
	vmovaps	64(%rsp), %ymm0         # 32-byte Reload
	vandnps	%ymm0, %ymm7, %ymm0
	vmovaps	%ymm0, 64(%rsp)         # 32-byte Spill
	vmovaps	96(%rsp), %ymm1         # 32-byte Reload
	vandnps	%ymm1, %ymm8, %ymm1
	addl	$-1, %eax
.LBB1_2:                                # %for_test.i
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa	160(%rsp), %ymm0        # 32-byte Reload
	vpxor	32(%r13,%rcx), %ymm0, %ymm9
	vpxor	32(%r10,%rcx), %ymm0, %ymm10
	vpcmpgtq	%ymm9, %ymm10, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpxor	(%r13,%rcx), %ymm0, %ymm11
	vpxor	(%r10,%rcx), %ymm0, %ymm12
	vpcmpgtq	%ymm11, %ymm12, %ymm3
	vextracti128	$1, %ymm3, %xmm5
	vpackssdw	%xmm5, %xmm3, %xmm3
	vinserti128	$1, %xmm2, %ymm3, %ymm3
	vpxor	96(%r13,%rcx), %ymm0, %ymm13
	vpxor	96(%r10,%rcx), %ymm0, %ymm4
	vpcmpgtq	%ymm13, %ymm4, %ymm2
	vextracti128	$1, %ymm2, %xmm5
	vpxor	64(%r13,%rcx), %ymm0, %ymm15
	vpackssdw	%xmm5, %xmm2, %xmm5
	vpxor	64(%r10,%rcx), %ymm0, %ymm2
	vpcmpgtq	%ymm15, %ymm2, %ymm6
	vextracti128	$1, %ymm6, %xmm0
	vpackssdw	%xmm0, %xmm6, %xmm0
	vinserti128	$1, %xmm5, %ymm0, %ymm0
	vmovdqa	%ymm1, 96(%rsp)         # 32-byte Spill
	vpand	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm14, %ymm1
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vblendvps	%ymm0, %ymm5, %ymm14, %ymm1
	vorps	%ymm8, %ymm0, %ymm8
	vpand	64(%rsp), %ymm3, %ymm0  # 32-byte Folded Reload
	vmovaps	128(%rsp), %ymm14       # 32-byte Reload
	vblendvps	%ymm0, %ymm5, %ymm14, %ymm14
	vorps	%ymm7, %ymm0, %ymm7
	vmovmskps	%ymm7, %ecx
	vmovmskps	%ymm8, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	cmpl	$65535, %edx            # imm = 0xFFFF
	je	.LBB1_3
# %bb.18:                               # %no_return.i
                                        #   in Loop: Header=BB1_2 Depth=1
	vpcmpgtq	%ymm10, %ymm9, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpackssdw	%xmm3, %xmm0, %xmm0
	vpcmpgtq	%ymm12, %ymm11, %ymm3
	vextracti128	$1, %ymm3, %xmm5
	vpackssdw	%xmm5, %xmm3, %xmm3
	vpcmpgtq	%ymm4, %ymm13, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpgtq	%ymm2, %ymm15, %ymm2
	vextracti128	$1, %ymm2, %xmm6
	vpackssdw	%xmm6, %xmm2, %xmm2
	vinserti128	$1, %xmm5, %ymm2, %ymm2
	vandnps	96(%rsp), %ymm8, %ymm5  # 32-byte Folded Reload
	vpxor	%xmm4, %xmm4, %xmm4
	vblendvps	%ymm2, %ymm5, %ymm4, %ymm2
	vinserti128	$1, %xmm0, %ymm3, %ymm0
	vandnps	64(%rsp), %ymm7, %ymm3  # 32-byte Folded Reload
	vblendvps	%ymm0, %ymm3, %ymm4, %ymm0
	vblendvps	%ymm0, %ymm4, %ymm14, %ymm14
	vorps	%ymm7, %ymm0, %ymm7
	vblendvps	%ymm2, %ymm4, %ymm1, %ymm1
	vorps	%ymm8, %ymm2, %ymm8
	vmovmskps	%ymm7, %ecx
	vmovmskps	%ymm8, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	cmpl	$65535, %edx            # imm = 0xFFFF
	vmovaps	%ymm14, %ymm15
	jne	.LBB1_19
	jmp	.LBB1_4
.LBB1_20:                               # %if_else
	movl	%r9d, %eax
	shlq	$7, %rax
	vmovdqu	(%r13,%rax), %ymm4
	vmovdqu	32(%r13,%rax), %ymm5
	vmovdqu	64(%r13,%rax), %ymm2
	vmovdqu	96(%r13,%rax), %ymm0
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqa	%ymm0, 192(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm6, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm1
	vmovdqa	%ymm2, 224(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm6, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm3
	vinserti128	$1, %xmm1, %ymm3, %ymm12
	vmovdqa	%ymm5, 256(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm6, %ymm5, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpackssdw	%xmm3, %xmm1, %xmm3
	vmovdqa	%ymm4, 288(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm6, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm5
	vinserti128	$1, %xmm3, %ymm5, %ymm11
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpackssdw	%xmm3, %xmm0, %xmm0
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm0, %ymm2, %ymm0
	vpxor	%ymm5, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpxor	%ymm5, %ymm4, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovmskps	%ymm1, %ecx
	vmovmskps	%ymm0, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	cmpl	$65535, %edx            # imm = 0xFFFF
	je	.LBB1_25
# %bb.21:                               # %for_test.i528.preheader
	vmovdqa	%ymm11, 160(%rsp)       # 32-byte Spill
	vmovmskps	%ymm11, %edx
	vmovdqa	%ymm12, 352(%rsp)       # 32-byte Spill
	vmovmskps	%ymm12, %ecx
	shll	$8, %ecx
	orl	%edx, %ecx
	leal	-1(%r9), %edx
	vpbroadcastq	.LCPI1_0(%rip), %ymm0 # ymm0 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
	vmovdqa	%ymm0, 320(%rsp)        # 32-byte Spill
                                        # implicit-def: $ymm8
                                        # implicit-def: $ymm9
	vxorps	%xmm13, %xmm13, %xmm13
	vxorps	%xmm14, %xmm14, %xmm14
	vpcmpeqd	%ymm10, %ymm10, %ymm10
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vmovdqa	%ymm0, 64(%rsp)         # 32-byte Spill
	jmp	.LBB1_22
	.p2align	4, 0x90
.LBB1_89:                               # %no_return43.i552
                                        #   in Loop: Header=BB1_22 Depth=1
	vmovaps	96(%rsp), %ymm10        # 32-byte Reload
	vandnps	%ymm10, %ymm13, %ymm10
	vmovaps	64(%rsp), %ymm0         # 32-byte Reload
	vandnps	%ymm0, %ymm14, %ymm0
	vmovaps	%ymm0, 64(%rsp)         # 32-byte Spill
	addl	$-1, %edx
.LBB1_22:                               # %for_test.i528
                                        # =>This Inner Loop Header: Depth=1
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	320(%rsp), %ymm6        # 32-byte Reload
	vpxor	32(%r13,%rsi), %ymm6, %ymm15
	vpxor	32(%r10,%rsi), %ymm6, %ymm0
	vpcmpgtq	%ymm15, %ymm0, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm3
	vpxor	(%r13,%rsi), %ymm6, %ymm1
	vpxor	(%r10,%rsi), %ymm6, %ymm2
	vpcmpgtq	%ymm1, %ymm2, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vpxor	96(%r13,%rsi), %ymm6, %ymm3
	vpxor	96(%r10,%rsi), %ymm6, %ymm4
	vpcmpgtq	%ymm3, %ymm4, %ymm11
	vextracti128	$1, %ymm11, %xmm12
	vpxor	64(%r13,%rsi), %ymm6, %ymm5
	vpxor	64(%r10,%rsi), %ymm6, %ymm7
	vpackssdw	%xmm12, %xmm11, %xmm11
	vpcmpgtq	%ymm5, %ymm7, %ymm12
	vextracti128	$1, %ymm12, %xmm6
	vpackssdw	%xmm6, %xmm12, %xmm6
	vinserti128	$1, %xmm11, %ymm6, %ymm6
	vmovdqa	%ymm10, 96(%rsp)        # 32-byte Spill
	vpand	128(%rsp), %ymm10, %ymm12 # 32-byte Folded Reload
	vpcmpeqd	%ymm11, %ymm11, %ymm11
	vblendvps	%ymm12, %ymm11, %ymm8, %ymm8
	vpand	64(%rsp), %ymm6, %ymm6  # 32-byte Folded Reload
	vblendvps	%ymm6, %ymm11, %ymm9, %ymm9
	vmovaps	352(%rsp), %ymm10       # 32-byte Reload
	vandps	%ymm10, %ymm6, %ymm6
	vorps	%ymm14, %ymm6, %ymm14
	vmovaps	160(%rsp), %ymm11       # 32-byte Reload
	vandps	%ymm11, %ymm12, %ymm6
	vorps	%ymm13, %ymm6, %ymm13
	vmovmskps	%ymm13, %esi
	vmovmskps	%ymm14, %edi
	shll	$8, %edi
	orl	%esi, %edi
	cmpl	%edi, %ecx
	je	.LBB1_24
# %bb.23:                               # %no_return.i547
                                        #   in Loop: Header=BB1_22 Depth=1
	vpcmpgtq	%ymm0, %ymm15, %ymm0
	vextracti128	$1, %ymm0, %xmm6
	vpackssdw	%xmm6, %xmm0, %xmm0
	vpcmpgtq	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpcmpgtq	%ymm4, %ymm3, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpgtq	%ymm7, %ymm5, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vandnps	64(%rsp), %ymm14, %ymm2 # 32-byte Folded Reload
	vpxor	%xmm3, %xmm3, %xmm3
	vblendvps	%ymm1, %ymm2, %ymm3, %ymm1
	vandnps	96(%rsp), %ymm13, %ymm2 # 32-byte Folded Reload
	vblendvps	%ymm0, %ymm2, %ymm3, %ymm0
	vblendvps	%ymm0, %ymm3, %ymm8, %ymm8
	vblendvps	%ymm1, %ymm3, %ymm9, %ymm9
	vandps	%ymm11, %ymm0, %ymm0
	vorps	%ymm13, %ymm0, %ymm13
	vandps	%ymm10, %ymm1, %ymm0
	vorps	%ymm14, %ymm0, %ymm14
	vmovmskps	%ymm13, %esi
	vmovmskps	%ymm14, %edi
	shll	$8, %edi
	orl	%esi, %edi
	cmpl	%edi, %ecx
	jne	.LBB1_89
.LBB1_24:
	vmovdqa	%ymm10, %ymm12
	vandps	%ymm11, %ymm8, %ymm11
	vandps	%ymm10, %ymm9, %ymm12
.LBB1_25:                               # %logical_op_done
	vmovmskps	%ymm11, %ecx
	vmovmskps	%ymm12, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	je	.LBB1_73
# %bb.26:                               # %for_test.i453.preheader
	vmovaps	.LCPI1_1(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm11, %ymm0, %ymm6
	vmovaps	.LCPI1_2(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm11, %ymm1, %ymm7
	vpermps	%ymm12, %ymm0, %ymm8
	vmovaps	%ymm12, %ymm10
	vpermps	%ymm12, %ymm1, %ymm9
	testl	%r9d, %r9d
	je	.LBB1_79
# %bb.27:                               # %for_loop.i465.lr.ph
	vpxor	%xmm4, %xmm4, %xmm4
	cmpl	$1, %r9d
	jne	.LBB1_75
# %bb.28:
	xorl	%ecx, %ecx
	vpxor	%xmm12, %xmm12, %xmm12
	vxorps	%xmm13, %xmm13, %xmm13
	vxorps	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	jmp	.LBB1_78
.LBB1_3:                                # %do_return.i
	vmovaps	%ymm14, %ymm15
.LBB1_4:                                # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vmovmskps	%ymm15, %eax
	vmovmskps	%ymm1, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB1_10
# %bb.5:                                # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	testl	%r9d, %r9d
	je	.LBB1_10
# %bb.6:                                # %for_loop.i482.lr.ph
	vmovaps	.LCPI1_1(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm15, %ymm0, %ymm2
	vmovaps	.LCPI1_2(%rip), %ymm5   # ymm5 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm15, %ymm5, %ymm3
	vpermps	%ymm1, %ymm0, %ymm4
	vpermps	%ymm1, %ymm5, %ymm5
	movl	%r9d, %eax
	notl	%eax
	movl	%r9d, %ecx
	andl	$1, %ecx
	addl	56(%rsp), %eax          # 4-byte Folded Reload
	jne	.LBB1_69
# %bb.7:
	vxorps	%xmm7, %xmm7, %xmm7
	xorl	%eax, %eax
	vxorps	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	testl	%ecx, %ecx
	jne	.LBB1_9
	jmp	.LBB1_10
.LBB1_69:                               # %for_loop.i482.lr.ph.new
	movq	48(%rsp), %rax          # 8-byte Reload
	leaq	(%rax,%r13), %rdx
	addq	$128, %rdx
	movl	%r9d, %esi
	subl	%ecx, %esi
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edi, %edi
	xorl	%eax, %eax
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB1_70:                               # %for_loop.i482
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	-128(%rdx,%rdi), %ymm0
	vmovdqu	-96(%rdx,%rdi), %ymm11
	vmovdqu	-64(%rdx,%rdi), %ymm12
	vmovdqu	-32(%rdx,%rdi), %ymm13
	vpsubq	96(%r13,%rdi), %ymm13, %ymm13
	vpsubq	64(%r13,%rdi), %ymm12, %ymm12
	vpaddq	%ymm10, %ymm13, %ymm10
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	32(%r13,%rdi), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpsubq	(%r13,%rdi), %ymm0, %ymm0
	vpaddq	%ymm7, %ymm0, %ymm0
	vpblendd	$170, %ymm6, %ymm10, %ymm7 # ymm7 = ymm10[0],ymm6[1],ymm10[2],ymm6[3],ymm10[4],ymm6[5],ymm10[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm0, %ymm13 # ymm13 = ymm0[0],ymm6[1],ymm0[2],ymm6[3],ymm0[4],ymm6[5],ymm0[6],ymm6[7]
	vmaskmovpd	%ymm13, %ymm2, (%rbx,%rdi)
	vmaskmovpd	%ymm12, %ymm3, 32(%rbx,%rdi)
	vmaskmovpd	%ymm11, %ymm4, 64(%rbx,%rdi)
	vmaskmovpd	%ymm7, %ymm5, 96(%rbx,%rdi)
	vpsrad	$31, %ymm10, %ymm7
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm7, %ymm10, %ymm7 # ymm7 = ymm10[0],ymm7[1],ymm10[2],ymm7[3],ymm10[4],ymm7[5],ymm10[6],ymm7[7]
	vpsrad	$31, %ymm9, %ymm10
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpsrad	$31, %ymm8, %ymm10
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm10[1],ymm8[2],ymm10[3],ymm8[4],ymm10[5],ymm8[6],ymm10[7]
	vpsrad	$31, %ymm0, %ymm10
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vmovdqu	(%rdx,%rdi), %ymm10
	vmovdqu	32(%rdx,%rdi), %ymm11
	vmovdqu	64(%rdx,%rdi), %ymm12
	vmovdqu	96(%rdx,%rdi), %ymm13
	vpsubq	224(%r13,%rdi), %ymm13, %ymm13
	vpsubq	192(%r13,%rdi), %ymm12, %ymm12
	vpaddq	%ymm7, %ymm13, %ymm7
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	160(%r13,%rdi), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpsubq	128(%r13,%rdi), %ymm10, %ymm10
	vpaddq	%ymm0, %ymm10, %ymm0
	vpblendd	$170, %ymm6, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm6[1],ymm7[2],ymm6[3],ymm7[4],ymm6[5],ymm7[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm0, %ymm13 # ymm13 = ymm0[0],ymm6[1],ymm0[2],ymm6[3],ymm0[4],ymm6[5],ymm0[6],ymm6[7]
	vmaskmovpd	%ymm13, %ymm2, 128(%rbx,%rdi)
	vmaskmovpd	%ymm12, %ymm3, 160(%rbx,%rdi)
	vmaskmovpd	%ymm11, %ymm4, 192(%rbx,%rdi)
	vmaskmovpd	%ymm10, %ymm5, 224(%rbx,%rdi)
	vpsrad	$31, %ymm7, %ymm10
	vpshufd	$245, %ymm7, %ymm7      # ymm7 = ymm7[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm10[1],ymm7[2],ymm10[3],ymm7[4],ymm10[5],ymm7[6],ymm10[7]
	vpsrad	$31, %ymm9, %ymm7
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm7, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm7[1],ymm9[2],ymm7[3],ymm9[4],ymm7[5],ymm9[6],ymm7[7]
	vpsrad	$31, %ymm8, %ymm7
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm7, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm7[1],ymm8[2],ymm7[3],ymm8[4],ymm7[5],ymm8[6],ymm7[7]
	vpsrad	$31, %ymm0, %ymm7
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm7, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm7[1],ymm0[2],ymm7[3],ymm0[4],ymm7[5],ymm0[6],ymm7[7]
	addq	$2, %rax
	addq	$256, %rdi              # imm = 0x100
	cmpl	%eax, %esi
	jne	.LBB1_70
# %bb.8:                                # %for_test.i470.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_10
.LBB1_9:                                # %for_loop.i482.epil.preheader
	shlq	$7, %rax
	vmovdqu	(%r10,%rax), %ymm0
	vmovdqu	32(%r10,%rax), %ymm6
	vmovdqu	96(%r10,%rax), %ymm11
	vpsubq	96(%r13,%rax), %ymm11, %ymm11
	vmovdqu	64(%r10,%rax), %ymm12
	vpaddq	%ymm10, %ymm11, %ymm10
	vpsubq	64(%r13,%rax), %ymm12, %ymm11
	vpaddq	%ymm9, %ymm11, %ymm9
	vpsubq	32(%r13,%rax), %ymm6, %ymm6
	vpaddq	%ymm8, %ymm6, %ymm6
	vpsubq	(%r13,%rax), %ymm0, %ymm0
	vpaddq	%ymm7, %ymm0, %ymm0
	vpxor	%xmm7, %xmm7, %xmm7
	vpblendd	$170, %ymm7, %ymm10, %ymm8 # ymm8 = ymm10[0],ymm7[1],ymm10[2],ymm7[3],ymm10[4],ymm7[5],ymm10[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm7[1],ymm9[2],ymm7[3],ymm9[4],ymm7[5],ymm9[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm6, %ymm6 # ymm6 = ymm6[0],ymm7[1],ymm6[2],ymm7[3],ymm6[4],ymm7[5],ymm6[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm7[1],ymm0[2],ymm7[3],ymm0[4],ymm7[5],ymm0[6],ymm7[7]
	vmaskmovpd	%ymm0, %ymm2, (%rbx,%rax)
	vmaskmovpd	%ymm6, %ymm3, 32(%rbx,%rax)
	vmaskmovpd	%ymm9, %ymm4, 64(%rbx,%rax)
	vmaskmovpd	%ymm8, %ymm5, 96(%rbx,%rax)
.LBB1_10:                               # %safe_if_after_true
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vxorps	%ymm0, %ymm15, %ymm2
	vxorps	%ymm0, %ymm1, %ymm3
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB1_16
# %bb.11:                               # %safe_if_after_true
	testl	%r9d, %r9d
	je	.LBB1_16
# %bb.12:                               # %for_loop.i499.lr.ph
	vmovaps	.LCPI1_1(%rip), %ymm4   # ymm4 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm2, %ymm4, %ymm0
	vmovaps	.LCPI1_2(%rip), %ymm5   # ymm5 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm2, %ymm5, %ymm1
	vpermps	%ymm3, %ymm4, %ymm2
	vpermps	%ymm3, %ymm5, %ymm3
	movl	%r9d, %eax
	notl	%eax
	movl	%r9d, %ecx
	andl	$1, %ecx
	addl	56(%rsp), %eax          # 4-byte Folded Reload
	jne	.LBB1_71
# %bb.13:
	vxorps	%xmm5, %xmm5, %xmm5
	xorl	%eax, %eax
	vpxor	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	testl	%ecx, %ecx
	jne	.LBB1_15
	jmp	.LBB1_16
.LBB1_71:                               # %for_loop.i499.lr.ph.new
	movq	48(%rsp), %rax          # 8-byte Reload
	leaq	(%rax,%r13), %rdx
	addq	$128, %rdx
	movl	%r9d, %esi
	subl	%ecx, %esi
	vxorps	%xmm4, %xmm4, %xmm4
	xorl	%edi, %edi
	xorl	%eax, %eax
	vxorps	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB1_72:                               # %for_loop.i499
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%r13,%rdi), %ymm9
	vmovdqu	32(%r13,%rdi), %ymm10
	vmovdqu	64(%r13,%rdi), %ymm11
	vmovdqu	96(%r13,%rdi), %ymm12
	vpsubq	-32(%rdx,%rdi), %ymm12, %ymm12
	vpsubq	-64(%rdx,%rdi), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm12, %ymm8
	vpaddq	%ymm7, %ymm11, %ymm7
	vpsubq	-96(%rdx,%rdi), %ymm10, %ymm10
	vpaddq	%ymm6, %ymm10, %ymm6
	vpsubq	-128(%rdx,%rdi), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm9, %ymm5
	vpblendd	$170, %ymm4, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm4[1],ymm8[2],ymm4[3],ymm8[4],ymm4[5],ymm8[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm4[1],ymm7[2],ymm4[3],ymm7[4],ymm4[5],ymm7[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm4[1],ymm6[2],ymm4[3],ymm6[4],ymm4[5],ymm6[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm5, %ymm12 # ymm12 = ymm5[0],ymm4[1],ymm5[2],ymm4[3],ymm5[4],ymm4[5],ymm5[6],ymm4[7]
	vmaskmovpd	%ymm12, %ymm0, (%rbx,%rdi)
	vmaskmovpd	%ymm11, %ymm1, 32(%rbx,%rdi)
	vmaskmovpd	%ymm10, %ymm2, 64(%rbx,%rdi)
	vmaskmovpd	%ymm9, %ymm3, 96(%rbx,%rdi)
	vpsrad	$31, %ymm8, %ymm9
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm9[1],ymm8[2],ymm9[3],ymm8[4],ymm9[5],ymm8[6],ymm9[7]
	vpsrad	$31, %ymm7, %ymm9
	vpshufd	$245, %ymm7, %ymm7      # ymm7 = ymm7[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm7, %ymm7 # ymm7 = ymm7[0],ymm9[1],ymm7[2],ymm9[3],ymm7[4],ymm9[5],ymm7[6],ymm9[7]
	vpsrad	$31, %ymm6, %ymm9
	vpshufd	$245, %ymm6, %ymm6      # ymm6 = ymm6[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm6, %ymm6 # ymm6 = ymm6[0],ymm9[1],ymm6[2],ymm9[3],ymm6[4],ymm9[5],ymm6[6],ymm9[7]
	vpsrad	$31, %ymm5, %ymm9
	vpshufd	$245, %ymm5, %ymm5      # ymm5 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm5, %ymm5 # ymm5 = ymm5[0],ymm9[1],ymm5[2],ymm9[3],ymm5[4],ymm9[5],ymm5[6],ymm9[7]
	vmovdqu	128(%r13,%rdi), %ymm9
	vmovdqu	160(%r13,%rdi), %ymm10
	vmovdqu	192(%r13,%rdi), %ymm11
	vmovdqu	224(%r13,%rdi), %ymm12
	vpsubq	96(%rdx,%rdi), %ymm12, %ymm12
	vpsubq	64(%rdx,%rdi), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm12, %ymm8
	vpaddq	%ymm7, %ymm11, %ymm7
	vpsubq	32(%rdx,%rdi), %ymm10, %ymm10
	vpaddq	%ymm6, %ymm10, %ymm6
	vpsubq	(%rdx,%rdi), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm9, %ymm5
	vpblendd	$170, %ymm4, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm4[1],ymm8[2],ymm4[3],ymm8[4],ymm4[5],ymm8[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm4[1],ymm7[2],ymm4[3],ymm7[4],ymm4[5],ymm7[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm4[1],ymm6[2],ymm4[3],ymm6[4],ymm4[5],ymm6[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm5, %ymm12 # ymm12 = ymm5[0],ymm4[1],ymm5[2],ymm4[3],ymm5[4],ymm4[5],ymm5[6],ymm4[7]
	vmaskmovpd	%ymm12, %ymm0, 128(%rbx,%rdi)
	vmaskmovpd	%ymm11, %ymm1, 160(%rbx,%rdi)
	vmaskmovpd	%ymm10, %ymm2, 192(%rbx,%rdi)
	vmaskmovpd	%ymm9, %ymm3, 224(%rbx,%rdi)
	vpsrad	$31, %ymm8, %ymm9
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm9[1],ymm8[2],ymm9[3],ymm8[4],ymm9[5],ymm8[6],ymm9[7]
	vpsrad	$31, %ymm7, %ymm9
	vpshufd	$245, %ymm7, %ymm7      # ymm7 = ymm7[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm7, %ymm7 # ymm7 = ymm7[0],ymm9[1],ymm7[2],ymm9[3],ymm7[4],ymm9[5],ymm7[6],ymm9[7]
	vpsrad	$31, %ymm6, %ymm9
	vpshufd	$245, %ymm6, %ymm6      # ymm6 = ymm6[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm6, %ymm6 # ymm6 = ymm6[0],ymm9[1],ymm6[2],ymm9[3],ymm6[4],ymm9[5],ymm6[6],ymm9[7]
	vpsrad	$31, %ymm5, %ymm9
	vpshufd	$245, %ymm5, %ymm5      # ymm5 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm5, %ymm5 # ymm5 = ymm5[0],ymm9[1],ymm5[2],ymm9[3],ymm5[4],ymm9[5],ymm5[6],ymm9[7]
	addq	$2, %rax
	addq	$256, %rdi              # imm = 0x100
	cmpl	%eax, %esi
	jne	.LBB1_72
# %bb.14:                               # %for_test.i487.if_exit.loopexit_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_16
.LBB1_15:                               # %for_loop.i499.epil.preheader
	shlq	$7, %rax
	vmovdqu	(%r13,%rax), %ymm4
	vmovdqu	32(%r13,%rax), %ymm9
	vmovdqu	96(%r13,%rax), %ymm10
	vpsubq	96(%r10,%rax), %ymm10, %ymm10
	vmovdqu	64(%r13,%rax), %ymm11
	vpaddq	%ymm8, %ymm10, %ymm8
	vpsubq	64(%r10,%rax), %ymm11, %ymm10
	vpaddq	%ymm7, %ymm10, %ymm7
	vpsubq	32(%r10,%rax), %ymm9, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpsubq	(%r10,%rax), %ymm4, %ymm4
	vpaddq	%ymm5, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpblendd	$170, %ymm5, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm7 # ymm7 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm6 # ymm6 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm4 # ymm4 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmaskmovpd	%ymm4, %ymm0, (%rbx,%rax)
	vmaskmovpd	%ymm6, %ymm1, 32(%rbx,%rax)
	vmaskmovpd	%ymm7, %ymm2, 64(%rbx,%rax)
	vmaskmovpd	%ymm8, %ymm3, 96(%rbx,%rax)
	jmp	.LBB1_16
.LBB1_75:                               # %for_loop.i465.lr.ph.new
	vmovaps	%ymm11, 160(%rsp)       # 32-byte Spill
	movl	%r9d, %r8d
	andl	$1, %r8d
	movq	48(%rsp), %rcx          # 8-byte Reload
	leaq	(%rcx,%r13), %rsi
	addq	$128, %rsi
	movl	%r9d, %edi
	subl	%r8d, %edi
	vpxor	%xmm11, %xmm11, %xmm11
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	vpxor	%xmm12, %xmm12, %xmm12
	vxorps	%xmm13, %xmm13, %xmm13
	vxorps	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	.p2align	4, 0x90
.LBB1_76:                               # %for_loop.i465
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	-128(%rsi,%rdx), %ymm0
	vmovdqu	-96(%rsi,%rdx), %ymm1
	vmovdqu	-64(%rsi,%rdx), %ymm2
	vmovdqu	-32(%rsi,%rdx), %ymm3
	vpsubq	96(%r13,%rdx), %ymm3, %ymm3
	vpsubq	64(%r13,%rdx), %ymm2, %ymm2
	vpaddq	%ymm15, %ymm3, %ymm3
	vpaddq	%ymm14, %ymm2, %ymm2
	vpsubq	32(%r13,%rdx), %ymm1, %ymm1
	vpaddq	%ymm13, %ymm1, %ymm1
	vpsubq	(%r13,%rdx), %ymm0, %ymm0
	vpaddq	%ymm12, %ymm0, %ymm0
	vpblendd	$170, %ymm11, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm11[1],ymm3[2],ymm11[3],ymm3[4],ymm11[5],ymm3[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm0, %ymm13 # ymm13 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vmaskmovpd	%ymm13, %ymm6, (%rbx,%rdx)
	vmaskmovpd	%ymm12, %ymm7, 32(%rbx,%rdx)
	vmaskmovpd	%ymm5, %ymm8, 64(%rbx,%rdx)
	vmaskmovpd	%ymm4, %ymm9, 96(%rbx,%rdx)
	vpsrad	$31, %ymm3, %ymm4
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpsrad	$31, %ymm2, %ymm4
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	vpsrad	$31, %ymm1, %ymm4
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm4[1],ymm1[2],ymm4[3],ymm1[4],ymm4[5],ymm1[6],ymm4[7]
	vpsrad	$31, %ymm0, %ymm4
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vmovdqu	(%rsi,%rdx), %ymm4
	vmovdqu	32(%rsi,%rdx), %ymm5
	vmovdqu	64(%rsi,%rdx), %ymm12
	vmovdqu	96(%rsi,%rdx), %ymm13
	vpsubq	224(%r13,%rdx), %ymm13, %ymm13
	vpsubq	192(%r13,%rdx), %ymm12, %ymm12
	vpaddq	%ymm3, %ymm13, %ymm3
	vpaddq	%ymm2, %ymm12, %ymm2
	vpsubq	160(%r13,%rdx), %ymm5, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpsubq	128(%r13,%rdx), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpblendd	$170, %ymm11, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm11[1],ymm3[2],ymm11[3],ymm3[4],ymm11[5],ymm3[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm0, %ymm13 # ymm13 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vmaskmovpd	%ymm13, %ymm6, 128(%rbx,%rdx)
	vmaskmovpd	%ymm12, %ymm7, 160(%rbx,%rdx)
	vmaskmovpd	%ymm5, %ymm8, 192(%rbx,%rdx)
	vmaskmovpd	%ymm4, %ymm9, 224(%rbx,%rdx)
	vpsrad	$31, %ymm3, %ymm4
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm3, %ymm15 # ymm15 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpsrad	$31, %ymm2, %ymm3
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm2, %ymm14 # ymm14 = ymm2[0],ymm3[1],ymm2[2],ymm3[3],ymm2[4],ymm3[5],ymm2[6],ymm3[7]
	vpsrad	$31, %ymm1, %ymm2
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpsrad	$31, %ymm0, %ymm1
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm1, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
	addq	$2, %rcx
	addq	$256, %rdx              # imm = 0x100
	cmpl	%ecx, %edi
	jne	.LBB1_76
# %bb.77:                               # %for_test.i453.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit466_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	vmovaps	160(%rsp), %ymm11       # 32-byte Reload
	vpxor	%xmm4, %xmm4, %xmm4
	je	.LBB1_79
.LBB1_78:                               # %for_loop.i465.epil.preheader
	shlq	$7, %rcx
	vmovdqu	(%r10,%rcx), %ymm0
	vmovdqu	32(%r10,%rcx), %ymm1
	vmovdqu	64(%r10,%rcx), %ymm2
	vmovdqu	96(%r10,%rcx), %ymm3
	vpsubq	96(%r13,%rcx), %ymm3, %ymm3
	vpsubq	64(%r13,%rcx), %ymm2, %ymm2
	vpaddq	%ymm15, %ymm3, %ymm3
	vpaddq	%ymm14, %ymm2, %ymm2
	vpsubq	32(%r13,%rcx), %ymm1, %ymm1
	vpaddq	%ymm13, %ymm1, %ymm1
	vpsubq	(%r13,%rcx), %ymm0, %ymm0
	vpaddq	%ymm12, %ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm4[1],ymm1[2],ymm4[3],ymm1[4],ymm4[5],ymm1[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vmaskmovpd	%ymm0, %ymm6, (%rbx,%rcx)
	vmaskmovpd	%ymm1, %ymm7, 32(%rbx,%rcx)
	vmaskmovpd	%ymm2, %ymm8, 64(%rbx,%rcx)
	vmaskmovpd	%ymm3, %ymm9, 96(%rbx,%rcx)
.LBB1_79:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit466
	vxorpd	%xmm0, %xmm0, %xmm0
	vmaskmovpd	%ymm0, %ymm6, (%rbx,%rax)
	vmaskmovpd	%ymm0, %ymm7, 32(%rbx,%rax)
	vmaskmovpd	%ymm0, %ymm8, 64(%rbx,%rax)
	vmaskmovpd	%ymm0, %ymm9, 96(%rbx,%rax)
	vmovaps	%ymm10, %ymm12
.LBB1_73:                               # %safe_if_after_true57
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpxor	%ymm0, %ymm11, %ymm1
	vpxor	%ymm0, %ymm12, %ymm0
	vmovmskps	%ymm1, %ecx
	vmovmskps	%ymm0, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	je	.LBB1_74
# %bb.80:                               # %safe_if_run_false75
	addq	%rbx, %rax
	vmovaps	.LCPI1_1(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm1, %ymm2, %ymm4
	vmovaps	.LCPI1_2(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm1, %ymm3, %ymm5
	vpermps	%ymm0, %ymm2, %ymm6
	vpermps	%ymm0, %ymm3, %ymm7
	testl	%r9d, %r9d
	je	.LBB1_81
# %bb.82:                               # %for_loop.i.lr.ph
	vxorps	%xmm8, %xmm8, %xmm8
	cmpl	$1, %r9d
	jne	.LBB1_84
# %bb.83:
	xorl	%ecx, %ecx
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vxorps	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	jmp	.LBB1_87
.LBB1_81:
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vxorps	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	jmp	.LBB1_88
.LBB1_84:                               # %for_loop.i.lr.ph.new
	movl	%r9d, %r8d
	andl	$1, %r8d
	movq	48(%rsp), %rcx          # 8-byte Reload
	leaq	(%rcx,%r13), %rsi
	addq	$128, %rsi
	movl	%r9d, %edi
	subl	%r8d, %edi
	vxorps	%xmm9, %xmm9, %xmm9
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vxorps	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	.p2align	4, 0x90
.LBB1_85:                               # %for_loop.i
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%r13,%rdx), %ymm0
	vmovdqu	32(%r13,%rdx), %ymm1
	vmovdqu	64(%r13,%rdx), %ymm2
	vmovdqu	96(%r13,%rdx), %ymm3
	vpsubq	-32(%rsi,%rdx), %ymm3, %ymm3
	vpsubq	-64(%rsi,%rdx), %ymm2, %ymm2
	vpaddq	%ymm12, %ymm3, %ymm3
	vpaddq	%ymm13, %ymm2, %ymm2
	vpsubq	-96(%rsi,%rdx), %ymm1, %ymm1
	vpaddq	%ymm11, %ymm1, %ymm1
	vpsubq	-128(%rsi,%rdx), %ymm0, %ymm0
	vpaddq	%ymm10, %ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm3, %ymm10 # ymm10 = ymm3[0],ymm9[1],ymm3[2],ymm9[3],ymm3[4],ymm9[5],ymm3[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm11 # ymm11 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm0, %ymm13 # ymm13 = ymm0[0],ymm9[1],ymm0[2],ymm9[3],ymm0[4],ymm9[5],ymm0[6],ymm9[7]
	vmaskmovpd	%ymm13, %ymm4, (%rbx,%rdx)
	vmaskmovpd	%ymm12, %ymm5, 32(%rbx,%rdx)
	vmaskmovpd	%ymm11, %ymm6, 64(%rbx,%rdx)
	vmaskmovpd	%ymm10, %ymm7, 96(%rbx,%rdx)
	vpsrad	$31, %ymm3, %ymm10
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm10[1],ymm3[2],ymm10[3],ymm3[4],ymm10[5],ymm3[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm10
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm10[1],ymm2[2],ymm10[3],ymm2[4],ymm10[5],ymm2[6],ymm10[7]
	vpsrad	$31, %ymm1, %ymm10
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpsrad	$31, %ymm0, %ymm10
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vmovdqu	128(%r13,%rdx), %ymm10
	vmovdqu	160(%r13,%rdx), %ymm11
	vmovdqu	192(%r13,%rdx), %ymm12
	vmovdqu	224(%r13,%rdx), %ymm13
	vpsubq	96(%rsi,%rdx), %ymm13, %ymm13
	vpsubq	64(%rsi,%rdx), %ymm12, %ymm12
	vpaddq	%ymm3, %ymm13, %ymm3
	vpaddq	%ymm2, %ymm12, %ymm2
	vpsubq	32(%rsi,%rdx), %ymm11, %ymm11
	vpaddq	%ymm1, %ymm11, %ymm1
	vpsubq	(%rsi,%rdx), %ymm10, %ymm10
	vpaddq	%ymm0, %ymm10, %ymm0
	vpblendd	$170, %ymm9, %ymm3, %ymm10 # ymm10 = ymm3[0],ymm9[1],ymm3[2],ymm9[3],ymm3[4],ymm9[5],ymm3[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm11 # ymm11 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm0, %ymm13 # ymm13 = ymm0[0],ymm9[1],ymm0[2],ymm9[3],ymm0[4],ymm9[5],ymm0[6],ymm9[7]
	vmaskmovpd	%ymm13, %ymm4, 128(%rbx,%rdx)
	vmaskmovpd	%ymm12, %ymm5, 160(%rbx,%rdx)
	vmaskmovpd	%ymm11, %ymm6, 192(%rbx,%rdx)
	vmaskmovpd	%ymm10, %ymm7, 224(%rbx,%rdx)
	vpsrad	$31, %ymm3, %ymm10
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm10[1],ymm3[2],ymm10[3],ymm3[4],ymm10[5],ymm3[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm3
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm3[1],ymm2[2],ymm3[3],ymm2[4],ymm3[5],ymm2[6],ymm3[7]
	vpsrad	$31, %ymm1, %ymm2
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpsrad	$31, %ymm0, %ymm1
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm1, %ymm0, %ymm10 # ymm10 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
	addq	$2, %rcx
	addq	$256, %rdx              # imm = 0x100
	cmpl	%ecx, %edi
	jne	.LBB1_85
# %bb.86:                               # %for_test.i371.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_88
.LBB1_87:                               # %for_loop.i.epil.preheader
	shlq	$7, %rcx
	vmovdqu	(%r13,%rcx), %ymm0
	vmovdqu	32(%r13,%rcx), %ymm1
	vmovdqu	64(%r13,%rcx), %ymm2
	vmovdqu	96(%r13,%rcx), %ymm3
	vpsubq	96(%r10,%rcx), %ymm3, %ymm3
	vpsubq	64(%r10,%rcx), %ymm2, %ymm2
	vpaddq	%ymm12, %ymm3, %ymm3
	vpaddq	%ymm13, %ymm2, %ymm2
	vpsubq	32(%r10,%rcx), %ymm1, %ymm1
	vpaddq	%ymm11, %ymm1, %ymm1
	vpsubq	(%r10,%rcx), %ymm0, %ymm0
	vpaddq	%ymm10, %ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm8[1],ymm3[2],ymm8[3],ymm3[4],ymm8[5],ymm3[6],ymm8[7]
	vpblendd	$170, %ymm8, %ymm2, %ymm10 # ymm10 = ymm2[0],ymm8[1],ymm2[2],ymm8[3],ymm2[4],ymm8[5],ymm2[6],ymm8[7]
	vpblendd	$170, %ymm8, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm8[1],ymm1[2],ymm8[3],ymm1[4],ymm8[5],ymm1[6],ymm8[7]
	vpblendd	$170, %ymm8, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm8[1],ymm0[2],ymm8[3],ymm0[4],ymm8[5],ymm0[6],ymm8[7]
	vmaskmovpd	%ymm8, %ymm4, (%rbx,%rcx)
	vmaskmovpd	%ymm11, %ymm5, 32(%rbx,%rcx)
	vmaskmovpd	%ymm10, %ymm6, 64(%rbx,%rcx)
	vmaskmovpd	%ymm9, %ymm7, 96(%rbx,%rcx)
	vpsrad	$31, %ymm3, %ymm8
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm8, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm8[1],ymm3[2],ymm8[3],ymm3[4],ymm8[5],ymm3[6],ymm8[7]
	vpsrad	$31, %ymm2, %ymm3
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm3[1],ymm2[2],ymm3[3],ymm2[4],ymm3[5],ymm2[6],ymm3[7]
	vpsrad	$31, %ymm1, %ymm2
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpsrad	$31, %ymm0, %ymm1
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm1, %ymm0, %ymm10 # ymm10 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
.LBB1_88:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vpaddq	192(%rsp), %ymm12, %ymm0 # 32-byte Folded Reload
	vpaddq	224(%rsp), %ymm13, %ymm1 # 32-byte Folded Reload
	vpaddq	256(%rsp), %ymm11, %ymm2 # 32-byte Folded Reload
	vpaddq	288(%rsp), %ymm10, %ymm3 # 32-byte Folded Reload
	vmaskmovpd	%ymm3, %ymm4, (%rax)
	vmaskmovpd	%ymm2, %ymm5, 32(%rax)
	vmaskmovpd	%ymm1, %ymm6, 64(%rax)
	vmaskmovpd	%ymm0, %ymm7, 96(%rax)
.LBB1_74:                               # %if_done56
	movq	%r12, %rcx
	leal	-2(,%r12,4), %eax
	shlq	$7, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 96(%rbx,%rax)
	vmovups	%ymm0, 64(%rbx,%rax)
	vmovups	%ymm0, 32(%rbx,%rax)
	vmovups	%ymm0, (%rbx,%rax)
	leal	-1(,%r12,4), %eax
	shlq	$7, %rax
	vmovups	%ymm0, 96(%rbx,%rax)
	vmovups	%ymm0, 64(%rbx,%rax)
	vmovups	%ymm0, 32(%rbx,%rax)
	vmovups	%ymm0, (%rbx,%rax)
.LBB1_16:                               # %if_exit
	leal	(%r12,%r12), %r15d
	movq	%r15, %rax
	shlq	$7, %rax
	movq	%r9, 64(%rsp)           # 8-byte Spill
	movq	%rax, 128(%rsp)         # 8-byte Spill
	leaq	(%rbx,%rax), %r14
	leaq	384(%rsp), %rdi
	movq	%rbx, %rsi
	movl	%r12d, %edx
	movq	%r10, 96(%rsp)          # 8-byte Spill
	vzeroupper
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%r14, %rdi
	movq	96(%rsp), %rsi          # 8-byte Reload
	movq	64(%rsp), %rdx          # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%rbx, %rdi
	movq	%r13, %rsi
	movq	%r12, %r13
	movl	%r13d, %edx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	vxorps	%xmm14, %xmm14, %xmm14
	testl	%r13d, %r13d
	je	.LBB1_17
# %bb.29:                               # %for_loop.i390.lr.ph
	movq	48(%rsp), %rax          # 8-byte Reload
	leaq	(%rbx,%rax), %rax
	movabsq	$8589934592, %r10       # imm = 0x200000000
	movabsq	$4294967296, %r11       # imm = 0x100000000
	movq	64(%rsp), %rcx          # 8-byte Reload
	movl	%ecx, %r8d
	notl	%r8d
	movl	%r13d, %r9d
	andl	$1, %r9d
	movl	%r8d, %ecx
	addl	56(%rsp), %ecx          # 4-byte Folded Reload
	jne	.LBB1_38
# %bb.30:
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edi, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	testl	%r9d, %r9d
	jne	.LBB1_32
	jmp	.LBB1_33
.LBB1_17:
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	vpxor	%xmm1, %xmm1, %xmm1
	vxorps	%xmm9, %xmm9, %xmm9
	jmp	.LBB1_35
.LBB1_38:                               # %for_loop.i390.lr.ph.new
	movl	%r13d, %r12d
	subl	%r9d, %r12d
	movq	128(%rsp), %rcx         # 8-byte Reload
	addq	%rbx, %rcx
	addq	$128, %rcx
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%esi, %esi
	xorl	%edi, %edi
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB1_39:                               # %for_loop.i390
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rdx
	sarq	$25, %rdx
	vpaddq	96(%rax,%rdx), %ymm4, %ymm4
	vpaddq	64(%rax,%rdx), %ymm3, %ymm3
	vpaddq	(%rax,%rdx), %ymm6, %ymm1
	vpaddq	32(%rax,%rdx), %ymm2, %ymm2
	vpaddq	32(%r14,%rdx), %ymm2, %ymm2
	vpaddq	(%r14,%rdx), %ymm1, %ymm1
	vpaddq	64(%r14,%rdx), %ymm3, %ymm3
	vpaddq	96(%r14,%rdx), %ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vmovdqu	%ymm9, -96(%rcx)
	vmovdqu	%ymm8, -128(%rcx)
	vmovdqu	%ymm7, -64(%rcx)
	vmovdqu	%ymm6, -32(%rcx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm1
	leaq	(%rsi,%r11), %rdx
	sarq	$25, %rdx
	vpaddq	(%rax,%rdx), %ymm1, %ymm1
	vpaddq	32(%rax,%rdx), %ymm2, %ymm2
	vpaddq	64(%rax,%rdx), %ymm3, %ymm3
	vpaddq	96(%rax,%rdx), %ymm4, %ymm4
	vpaddq	96(%r14,%rdx), %ymm4, %ymm4
	vpaddq	64(%r14,%rdx), %ymm3, %ymm3
	vpaddq	32(%r14,%rdx), %ymm2, %ymm2
	vpaddq	(%r14,%rdx), %ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmovdqu	%ymm9, 96(%rcx)
	vmovdqu	%ymm8, 64(%rcx)
	vmovdqu	%ymm7, 32(%rcx)
	vmovdqu	%ymm6, (%rcx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm6
	addq	$2, %rdi
	addq	$256, %rcx              # imm = 0x100
	addq	%r10, %rsi
	cmpl	%edi, %r12d
	jne	.LBB1_39
# %bb.31:                               # %for_test.i379.for_test.i394.preheader_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_33
.LBB1_32:                               # %for_loop.i390.epil.preheader
	movslq	%edi, %rcx
	shlq	$7, %rcx
	vpaddq	(%rax,%rcx), %ymm6, %ymm1
	vpaddq	32(%rax,%rcx), %ymm2, %ymm2
	vpaddq	64(%rax,%rcx), %ymm3, %ymm3
	vpaddq	96(%rax,%rcx), %ymm4, %ymm4
	vpaddq	96(%r14,%rcx), %ymm4, %ymm4
	vpaddq	64(%r14,%rcx), %ymm3, %ymm3
	vpaddq	32(%r14,%rcx), %ymm2, %ymm2
	vpaddq	(%r14,%rcx), %ymm1, %ymm1
	shlq	$7, %rdi
	vpxor	%xmm5, %xmm5, %xmm5
	vpblendd	$170, %ymm5, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm5 # ymm5 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmovdqu	%ymm5, 96(%r14,%rdi)
	vmovdqu	%ymm8, 64(%r14,%rdi)
	vmovdqu	%ymm7, 32(%r14,%rdi)
	vmovdqu	%ymm6, (%r14,%rdi)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm6
.LBB1_33:                               # %for_test.i394.preheader
	testl	%r13d, %r13d
	je	.LBB1_34
# %bb.36:                               # %for_loop.i406.lr.ph
	vmovdqa	%ymm6, %ymm0
	movl	%r13d, %r9d
	andl	$1, %r9d
	movl	%r8d, %ecx
	addl	56(%rsp), %ecx          # 4-byte Folded Reload
	jne	.LBB1_40
# %bb.37:
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edi, %edi
	vpxor	%xmm7, %xmm7, %xmm7
	vxorps	%xmm9, %xmm9, %xmm9
	vxorps	%xmm8, %xmm8, %xmm8
	testl	%r9d, %r9d
	jne	.LBB1_43
	jmp	.LBB1_44
.LBB1_34:
	vxorps	%xmm9, %xmm9, %xmm9
	vmovdqa	%ymm6, %ymm15
	vmovdqa	%ymm2, %ymm7
	vmovdqa	%ymm3, %ymm8
	vmovdqa	%ymm4, %ymm1
.LBB1_35:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit441
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vxorps	%xmm13, %xmm13, %xmm13
	jmp	.LBB1_62
.LBB1_40:                               # %for_loop.i406.lr.ph.new
	movl	%r13d, %r12d
	subl	%r9d, %r12d
	movq	48(%rsp), %rcx          # 8-byte Reload
	addq	%rbx, %rcx
	addq	$128, %rcx
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%esi, %esi
	xorl	%edi, %edi
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vxorps	%xmm9, %xmm9, %xmm9
	vxorps	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB1_41:                               # %for_loop.i406
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rdx
	sarq	$25, %rdx
	vpaddq	96(%r14,%rdx), %ymm8, %ymm8
	vpaddq	64(%r14,%rdx), %ymm9, %ymm9
	vpaddq	(%r14,%rdx), %ymm6, %ymm6
	vpaddq	32(%r14,%rdx), %ymm7, %ymm7
	vpaddq	32(%rbx,%rdx), %ymm7, %ymm7
	vpaddq	(%rbx,%rdx), %ymm6, %ymm6
	vpaddq	64(%rbx,%rdx), %ymm9, %ymm9
	vpaddq	96(%rbx,%rdx), %ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm13 # ymm13 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vmovdqu	%ymm13, -96(%rcx)
	vmovdqu	%ymm12, -128(%rcx)
	vmovdqu	%ymm11, -64(%rcx)
	vmovdqu	%ymm10, -32(%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	leaq	(%rsi,%r11), %rdx
	sarq	$25, %rdx
	vpaddq	(%r14,%rdx), %ymm6, %ymm6
	vpaddq	32(%r14,%rdx), %ymm7, %ymm7
	vpaddq	64(%r14,%rdx), %ymm9, %ymm9
	vpaddq	96(%r14,%rdx), %ymm8, %ymm8
	vpaddq	96(%rbx,%rdx), %ymm8, %ymm8
	vpaddq	64(%rbx,%rdx), %ymm9, %ymm9
	vpaddq	32(%rbx,%rdx), %ymm7, %ymm7
	vpaddq	(%rbx,%rdx), %ymm6, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqu	%ymm13, 96(%rcx)
	vmovdqu	%ymm12, 64(%rcx)
	vmovdqu	%ymm11, 32(%rcx)
	vmovdqu	%ymm10, (%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	addq	$2, %rdi
	addq	$256, %rcx              # imm = 0x100
	addq	%r10, %rsi
	cmpl	%edi, %r12d
	jne	.LBB1_41
# %bb.42:                               # %for_test.i394.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit407_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_44
.LBB1_43:                               # %for_loop.i406.epil.preheader
	movslq	%edi, %rcx
	shlq	$7, %rcx
	vpaddq	(%r14,%rcx), %ymm6, %ymm5
	vpaddq	32(%r14,%rcx), %ymm7, %ymm6
	vpaddq	64(%r14,%rcx), %ymm9, %ymm7
	vpaddq	96(%r14,%rcx), %ymm8, %ymm8
	vpaddq	96(%rbx,%rcx), %ymm8, %ymm8
	vpaddq	64(%rbx,%rcx), %ymm7, %ymm7
	vpaddq	32(%rbx,%rcx), %ymm6, %ymm6
	vpaddq	(%rbx,%rcx), %ymm5, %ymm5
	shlq	$7, %rdi
	vpxor	%xmm9, %xmm9, %xmm9
	vpblendd	$170, %ymm9, %ymm5, %ymm10 # ymm10 = ymm5[0],ymm9[1],ymm5[2],ymm9[3],ymm5[4],ymm9[5],ymm5[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm9[1],ymm6[2],ymm9[3],ymm6[4],ymm9[5],ymm6[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm9[1],ymm7[2],ymm9[3],ymm7[4],ymm9[5],ymm7[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm9[1],ymm8[2],ymm9[3],ymm8[4],ymm9[5],ymm8[6],ymm9[7]
	vmovdqu	%ymm9, 96(%rax,%rdi)
	vmovdqu	%ymm12, 64(%rax,%rdi)
	vmovdqu	%ymm11, 32(%rax,%rdi)
	vmovdqu	%ymm10, (%rax,%rdi)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm9
	vpsrlq	$32, %ymm6, %ymm7
	vpsrlq	$32, %ymm5, %ymm6
.LBB1_44:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit407
	vpaddq	%ymm0, %ymm6, %ymm15
	vmovdqa	%ymm0, %ymm6
	vpaddq	%ymm2, %ymm7, %ymm7
	vpaddq	%ymm3, %ymm9, %ymm0
	vpaddq	%ymm4, %ymm8, %ymm1
	testl	%r13d, %r13d
	movq	48(%rsp), %rsi          # 8-byte Reload
	je	.LBB1_45
# %bb.46:                               # %for_loop.i423.lr.ph
	addq	%r14, %rsi
	movl	%r13d, %r9d
	andl	$1, %r9d
	addl	56(%rsp), %r8d          # 4-byte Folded Reload
	vmovdqa	%ymm1, 96(%rsp)         # 32-byte Spill
	vmovdqa	%ymm15, %ymm5
	jne	.LBB1_48
# %bb.47:
	vpxor	%xmm10, %xmm10, %xmm10
	xorl	%r12d, %r12d
	vpxor	%xmm12, %xmm12, %xmm12
	vxorps	%xmm13, %xmm13, %xmm13
	vpxor	%xmm11, %xmm11, %xmm11
	vmovdqa	%ymm0, %ymm8
	testl	%r9d, %r9d
	jne	.LBB1_51
	jmp	.LBB1_52
.LBB1_45:
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vxorps	%xmm13, %xmm13, %xmm13
	vmovdqa	%ymm0, %ymm8
	jmp	.LBB1_62
.LBB1_48:                               # %for_loop.i423.lr.ph.new
	movl	%r13d, %r8d
	subl	%r9d, %r8d
	movq	128(%rsp), %rcx         # 8-byte Reload
	addq	%rbx, %rcx
	addq	$128, %rcx
	vpxor	%xmm9, %xmm9, %xmm9
	xorl	%edi, %edi
	xorl	%r12d, %r12d
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm12, %xmm12, %xmm12
	vxorps	%xmm13, %xmm13, %xmm13
	vpxor	%xmm11, %xmm11, %xmm11
	vmovdqa	%ymm0, %ymm8
	.p2align	4, 0x90
.LBB1_49:                               # %for_loop.i423
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rdx
	sarq	$25, %rdx
	vpaddq	96(%r14,%rdx), %ymm11, %ymm11
	vpaddq	64(%r14,%rdx), %ymm13, %ymm13
	vpaddq	(%r14,%rdx), %ymm10, %ymm10
	vpaddq	32(%r14,%rdx), %ymm12, %ymm12
	vpaddq	32(%rsi,%rdx), %ymm12, %ymm12
	vpaddq	(%rsi,%rdx), %ymm10, %ymm10
	vpaddq	64(%rsi,%rdx), %ymm13, %ymm13
	vpaddq	96(%rsi,%rdx), %ymm11, %ymm11
	vpblendd	$170, %ymm9, %ymm11, %ymm14 # ymm14 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm13, %ymm15 # ymm15 = ymm13[0],ymm9[1],ymm13[2],ymm9[3],ymm13[4],ymm9[5],ymm13[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm10, %ymm0 # ymm0 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm12, %ymm1 # ymm1 = ymm12[0],ymm9[1],ymm12[2],ymm9[3],ymm12[4],ymm9[5],ymm12[6],ymm9[7]
	vmovdqu	%ymm1, -96(%rcx)
	vmovdqu	%ymm0, -128(%rcx)
	vmovdqu	%ymm15, -64(%rcx)
	vmovdqu	%ymm14, -32(%rcx)
	vpsrlq	$32, %ymm11, %ymm0
	vpsrlq	$32, %ymm13, %ymm1
	vpsrlq	$32, %ymm12, %ymm11
	vpsrlq	$32, %ymm10, %ymm10
	leaq	(%rdi,%r11), %rdx
	sarq	$25, %rdx
	vpaddq	(%r14,%rdx), %ymm10, %ymm10
	vpaddq	32(%r14,%rdx), %ymm11, %ymm11
	vpaddq	64(%r14,%rdx), %ymm1, %ymm1
	vpaddq	96(%r14,%rdx), %ymm0, %ymm0
	vpaddq	96(%rsi,%rdx), %ymm0, %ymm0
	vpaddq	64(%rsi,%rdx), %ymm1, %ymm1
	vpaddq	32(%rsi,%rdx), %ymm11, %ymm12
	vpaddq	(%rsi,%rdx), %ymm10, %ymm10
	vpblendd	$170, %ymm9, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm12, %ymm13 # ymm13 = ymm12[0],ymm9[1],ymm12[2],ymm9[3],ymm12[4],ymm9[5],ymm12[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm14 # ymm14 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm0, %ymm15 # ymm15 = ymm0[0],ymm9[1],ymm0[2],ymm9[3],ymm0[4],ymm9[5],ymm0[6],ymm9[7]
	vmovdqu	%ymm15, 96(%rcx)
	vmovdqu	%ymm14, 64(%rcx)
	vmovdqu	%ymm13, 32(%rcx)
	vmovdqu	%ymm11, (%rcx)
	vpsrlq	$32, %ymm0, %ymm11
	vpsrlq	$32, %ymm1, %ymm13
	vpsrlq	$32, %ymm12, %ymm12
	vpsrlq	$32, %ymm10, %ymm10
	addq	$2, %r12
	addq	$256, %rcx              # imm = 0x100
	addq	%r10, %rdi
	cmpl	%r12d, %r8d
	jne	.LBB1_49
# %bb.50:                               # %for_test.i411.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit424_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_52
.LBB1_51:                               # %for_loop.i423.epil.preheader
	movslq	%r12d, %rcx
	shlq	$7, %rcx
	vpaddq	(%r14,%rcx), %ymm10, %ymm0
	vpaddq	32(%r14,%rcx), %ymm12, %ymm1
	vpaddq	64(%r14,%rcx), %ymm13, %ymm9
	vpaddq	96(%r14,%rcx), %ymm11, %ymm10
	vpaddq	96(%rsi,%rcx), %ymm10, %ymm10
	vpaddq	64(%rsi,%rcx), %ymm9, %ymm9
	vpaddq	32(%rsi,%rcx), %ymm1, %ymm1
	vpaddq	(%rsi,%rcx), %ymm0, %ymm0
	shlq	$7, %r12
	vpxor	%xmm11, %xmm11, %xmm11
	vpblendd	$170, %ymm11, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm9, %ymm14 # ymm14 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpblendd	$170, %ymm11, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vmovdqu	%ymm11, 96(%r14,%r12)
	vmovdqu	%ymm14, 64(%r14,%r12)
	vmovdqu	%ymm13, 32(%r14,%r12)
	vmovdqu	%ymm12, (%r14,%r12)
	vpsrlq	$32, %ymm10, %ymm11
	vpsrlq	$32, %ymm9, %ymm13
	vpsrlq	$32, %ymm1, %ymm12
	vpsrlq	$32, %ymm0, %ymm10
.LBB1_52:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit424
	vpaddq	%ymm6, %ymm10, %ymm6
	vpaddq	%ymm2, %ymm12, %ymm2
	vpaddq	%ymm3, %ymm13, %ymm3
	vpaddq	%ymm4, %ymm11, %ymm4
	testl	%r15d, %r15d
	je	.LBB1_53
# %bb.54:                               # %for_loop.i440.lr.ph
	movq	56(%rsp), %rcx          # 8-byte Reload
	leal	(%rcx,%rcx), %esi
	orl	$1, %ecx
	movl	%esi, %edx
	subl	%ecx, %edx
	movl	%r15d, %ecx
	andl	$2, %ecx
	cmpl	$3, %edx
	jae	.LBB1_56
# %bb.55:
	vpxor	%xmm9, %xmm9, %xmm9
	xorl	%edx, %edx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm13, %xmm13, %xmm13
	testl	%ecx, %ecx
	jne	.LBB1_59
	jmp	.LBB1_61
.LBB1_53:
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm13, %xmm13, %xmm13
	jmp	.LBB1_61
.LBB1_56:                               # %for_loop.i440.lr.ph.new
	movq	64(%rsp), %rdx          # 8-byte Reload
	leal	(%rcx,%rdx,2), %edx
	subl	%edx, %esi
	vpxor	%xmm10, %xmm10, %xmm10
	movl	$384, %edi              # imm = 0x180
	xorl	%edx, %edx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm13, %xmm13, %xmm13
	.p2align	4, 0x90
.LBB1_57:                               # %for_loop.i440
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	-384(%rax,%rdi), %ymm0
	vmovdqu	-352(%rax,%rdi), %ymm1
	vmovdqu	-320(%rax,%rdi), %ymm14
	vmovdqu	-288(%rax,%rdi), %ymm15
	vpsubq	96(%rsp,%rdi), %ymm15, %ymm15
	vpsubq	(%rsp,%rdi), %ymm0, %ymm0
	vpaddq	%ymm13, %ymm15, %ymm13
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsubq	32(%rsp,%rdi), %ymm1, %ymm1
	vpaddq	%ymm12, %ymm1, %ymm1
	vpsubq	64(%rsp,%rdi), %ymm14, %ymm9
	vpaddq	%ymm11, %ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm13, %ymm11 # ymm11 = ymm13[0],ymm10[1],ymm13[2],ymm10[3],ymm13[4],ymm10[5],ymm13[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm1, %ymm14 # ymm14 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm9, %ymm15 # ymm15 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vmovdqu	%ymm15, -320(%rax,%rdi)
	vmovdqu	%ymm14, -352(%rax,%rdi)
	vmovdqu	%ymm12, -384(%rax,%rdi)
	vmovdqu	%ymm11, -288(%rax,%rdi)
	vpsrad	$31, %ymm0, %ymm11
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vpsrad	$31, %ymm1, %ymm11
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpsrad	$31, %ymm13, %ymm11
	vpshufd	$245, %ymm13, %ymm12    # ymm12 = ymm13[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm12, %ymm11 # ymm11 = ymm12[0],ymm11[1],ymm12[2],ymm11[3],ymm12[4],ymm11[5],ymm12[6],ymm11[7]
	vmovdqu	-160(%rax,%rdi), %ymm12
	vmovdqu	-192(%rax,%rdi), %ymm13
	vmovdqu	-224(%rax,%rdi), %ymm14
	vmovdqu	-256(%rax,%rdi), %ymm15
	vpsubq	128(%rsp,%rdi), %ymm15, %ymm15
	vpsubq	160(%rsp,%rdi), %ymm14, %ymm14
	vpaddq	%ymm0, %ymm15, %ymm0
	vpaddq	%ymm1, %ymm14, %ymm1
	vpsubq	192(%rsp,%rdi), %ymm13, %ymm13
	vpaddq	%ymm9, %ymm13, %ymm9
	vpsubq	224(%rsp,%rdi), %ymm12, %ymm12
	vpaddq	%ymm11, %ymm12, %ymm11
	vpblendd	$170, %ymm10, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm9, %ymm14 # ymm14 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm11, %ymm15 # ymm15 = ymm11[0],ymm10[1],ymm11[2],ymm10[3],ymm11[4],ymm10[5],ymm11[6],ymm10[7]
	vmovdqu	%ymm15, -160(%rax,%rdi)
	vmovdqu	%ymm14, -192(%rax,%rdi)
	vmovdqu	%ymm13, -224(%rax,%rdi)
	vmovdqu	%ymm12, -256(%rax,%rdi)
	vpsrad	$31, %ymm0, %ymm12
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm12[1],ymm0[2],ymm12[3],ymm0[4],ymm12[5],ymm0[6],ymm12[7]
	vpsrad	$31, %ymm1, %ymm12
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm12[1],ymm1[2],ymm12[3],ymm1[4],ymm12[5],ymm1[6],ymm12[7]
	vpsrad	$31, %ymm9, %ymm12
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm12[1],ymm9[2],ymm12[3],ymm9[4],ymm12[5],ymm9[6],ymm12[7]
	vpsrad	$31, %ymm11, %ymm12
	vpshufd	$245, %ymm11, %ymm11    # ymm11 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm11, %ymm11 # ymm11 = ymm11[0],ymm12[1],ymm11[2],ymm12[3],ymm11[4],ymm12[5],ymm11[6],ymm12[7]
	vmovdqu	-32(%rax,%rdi), %ymm12
	vmovdqu	-64(%rax,%rdi), %ymm13
	vmovdqu	-96(%rax,%rdi), %ymm14
	vmovdqu	-128(%rax,%rdi), %ymm15
	vpsubq	256(%rsp,%rdi), %ymm15, %ymm15
	vpsubq	288(%rsp,%rdi), %ymm14, %ymm14
	vpaddq	%ymm0, %ymm15, %ymm0
	vpaddq	%ymm1, %ymm14, %ymm1
	vpsubq	320(%rsp,%rdi), %ymm13, %ymm13
	vpaddq	%ymm9, %ymm13, %ymm9
	vpsubq	352(%rsp,%rdi), %ymm12, %ymm12
	vpaddq	%ymm11, %ymm12, %ymm11
	vpblendd	$170, %ymm10, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm9, %ymm14 # ymm14 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm11, %ymm15 # ymm15 = ymm11[0],ymm10[1],ymm11[2],ymm10[3],ymm11[4],ymm10[5],ymm11[6],ymm10[7]
	vmovdqu	%ymm15, -32(%rax,%rdi)
	vmovdqu	%ymm14, -64(%rax,%rdi)
	vmovdqu	%ymm13, -96(%rax,%rdi)
	vmovdqu	%ymm12, -128(%rax,%rdi)
	vpsrad	$31, %ymm0, %ymm12
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm12[1],ymm0[2],ymm12[3],ymm0[4],ymm12[5],ymm0[6],ymm12[7]
	vpsrad	$31, %ymm1, %ymm12
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm12[1],ymm1[2],ymm12[3],ymm1[4],ymm12[5],ymm1[6],ymm12[7]
	vpsrad	$31, %ymm9, %ymm12
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm12[1],ymm9[2],ymm12[3],ymm9[4],ymm12[5],ymm9[6],ymm12[7]
	vpsrad	$31, %ymm11, %ymm12
	vpshufd	$245, %ymm11, %ymm11    # ymm11 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm11, %ymm11 # ymm11 = ymm11[0],ymm12[1],ymm11[2],ymm12[3],ymm11[4],ymm12[5],ymm11[6],ymm12[7]
	vmovdqu	96(%rax,%rdi), %ymm12
	vmovdqu	64(%rax,%rdi), %ymm13
	vmovdqu	32(%rax,%rdi), %ymm14
	vmovdqu	(%rax,%rdi), %ymm15
	vpsubq	384(%rsp,%rdi), %ymm15, %ymm15
	vpsubq	416(%rsp,%rdi), %ymm14, %ymm14
	vpaddq	%ymm0, %ymm15, %ymm0
	vpaddq	%ymm1, %ymm14, %ymm1
	vpsubq	448(%rsp,%rdi), %ymm13, %ymm13
	vpaddq	%ymm9, %ymm13, %ymm9
	vpsubq	480(%rsp,%rdi), %ymm12, %ymm12
	vpaddq	%ymm11, %ymm12, %ymm11
	vpblendd	$170, %ymm10, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm9, %ymm14 # ymm14 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm11, %ymm15 # ymm15 = ymm11[0],ymm10[1],ymm11[2],ymm10[3],ymm11[4],ymm10[5],ymm11[6],ymm10[7]
	vmovdqu	%ymm15, 96(%rax,%rdi)
	vmovdqu	%ymm14, 64(%rax,%rdi)
	vmovdqu	%ymm13, 32(%rax,%rdi)
	vmovdqu	%ymm12, (%rax,%rdi)
	vpsrad	$31, %ymm11, %ymm12
	vpshufd	$245, %ymm11, %ymm11    # ymm11 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm12, %ymm11, %ymm13 # ymm13 = ymm11[0],ymm12[1],ymm11[2],ymm12[3],ymm11[4],ymm12[5],ymm11[6],ymm12[7]
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpsrad	$31, %ymm1, %ymm9
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpsrad	$31, %ymm0, %ymm1
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm1, %ymm0, %ymm9 # ymm9 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
	addq	$4, %rdx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%edx, %esi
	jne	.LBB1_57
# %bb.58:                               # %for_test.i428.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit441_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_61
.LBB1_59:                               # %for_loop.i440.epil.preheader
	shlq	$7, %rdx
	negl	%ecx
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB1_60:                               # %for_loop.i440.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%rax,%rdx), %ymm0
	vmovdqu	32(%rax,%rdx), %ymm1
	vmovdqu	64(%rax,%rdx), %ymm14
	vmovdqu	96(%rax,%rdx), %ymm15
	vpsubq	480(%rsp,%rdx), %ymm15, %ymm15
	vpaddq	%ymm13, %ymm15, %ymm13
	vpsubq	384(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsubq	416(%rsp,%rdx), %ymm1, %ymm1
	vpsubq	448(%rsp,%rdx), %ymm14, %ymm9
	vpaddq	%ymm12, %ymm1, %ymm1
	vpaddq	%ymm11, %ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm13, %ymm11 # ymm11 = ymm13[0],ymm10[1],ymm13[2],ymm10[3],ymm13[4],ymm10[5],ymm13[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm10[1],ymm0[2],ymm10[3],ymm0[4],ymm10[5],ymm0[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm1, %ymm14 # ymm14 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm9, %ymm15 # ymm15 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vmovdqu	%ymm15, 64(%rax,%rdx)
	vmovdqu	%ymm14, 32(%rax,%rdx)
	vmovdqu	%ymm12, (%rax,%rdx)
	vmovdqu	%ymm11, 96(%rax,%rdx)
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpsrad	$31, %ymm1, %ymm9
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpsrad	$31, %ymm0, %ymm1
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm1, %ymm0, %ymm9 # ymm9 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
	vpsrad	$31, %ymm13, %ymm0
	vpshufd	$245, %ymm13, %ymm1     # ymm1 = ymm13[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	subq	$-128, %rdx
	addl	$1, %ecx
	jne	.LBB1_60
.LBB1_61:
	vxorps	%xmm14, %xmm14, %xmm14
	vmovdqa	%ymm5, %ymm15
	vmovdqa	96(%rsp), %ymm1         # 32-byte Reload
.LBB1_62:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit441
	vpaddq	%ymm13, %ymm4, %ymm0
	vmovdqa	%ymm0, 64(%rsp)         # 32-byte Spill
	vpaddq	%ymm11, %ymm3, %ymm0
	vmovdqa	%ymm0, 96(%rsp)         # 32-byte Spill
	vpaddq	%ymm12, %ymm2, %ymm0
	vmovdqa	%ymm0, 128(%rsp)        # 32-byte Spill
	vpaddq	%ymm9, %ymm6, %ymm0
	vmovdqa	%ymm0, 160(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm14, %ymm1, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vmovdqa	%ymm1, %ymm9
	vpxor	%ymm2, %ymm0, %ymm10
	vextracti128	$1, %ymm10, %xmm0
	vpackssdw	%xmm0, %xmm10, %xmm11
	vpcmpeqq	%ymm14, %ymm8, %ymm10
	vpxor	%ymm2, %ymm10, %ymm10
	vextracti128	$1, %ymm10, %xmm0
	vpackssdw	%xmm0, %xmm10, %xmm0
	vinserti128	$1, %xmm11, %ymm0, %ymm1
	vpcmpeqq	%ymm14, %ymm7, %ymm0
	vpxor	%ymm2, %ymm0, %ymm11
	vextracti128	$1, %ymm11, %xmm0
	vpackssdw	%xmm0, %xmm11, %xmm12
	vpcmpeqq	%ymm14, %ymm15, %ymm11
	vpxor	%ymm2, %ymm11, %ymm11
	vextracti128	$1, %ymm11, %xmm0
	vpackssdw	%xmm0, %xmm11, %xmm0
	vinserti128	$1, %xmm12, %ymm0, %ymm0
	vmovmskps	%ymm0, %eax
	vmovmskps	%ymm1, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB1_65
# %bb.63:
	vmovdqa	%ymm7, %ymm2
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB1_64:                               # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	movl	%r15d, %eax
	movslq	%r15d, %r15
	movq	%r15, %rcx
	shlq	$7, %rcx
	vpaddq	(%rbx,%rcx), %ymm15, %ymm14
	vmovdqa	%ymm15, %ymm4
	vpaddq	32(%rbx,%rcx), %ymm2, %ymm15
	vpaddq	64(%rbx,%rcx), %ymm8, %ymm11
	vpaddq	96(%rbx,%rcx), %ymm9, %ymm12
	shlq	$7, %rax
	vpblendd	$170, %ymm10, %ymm14, %ymm13 # ymm13 = ymm14[0],ymm10[1],ymm14[2],ymm10[3],ymm14[4],ymm10[5],ymm14[6],ymm10[7]
	vmovaps	.LCPI1_1(%rip), %ymm3   # ymm3 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm0, %ymm3, %ymm5
	vmaskmovpd	%ymm13, %ymm5, (%rbx,%rax)
	vpblendd	$170, %ymm10, %ymm11, %ymm13 # ymm13 = ymm11[0],ymm10[1],ymm11[2],ymm10[3],ymm11[4],ymm10[5],ymm11[6],ymm10[7]
	vpblendd	$170, %ymm10, %ymm15, %ymm6 # ymm6 = ymm15[0],ymm10[1],ymm15[2],ymm10[3],ymm15[4],ymm10[5],ymm15[6],ymm10[7]
	vmovaps	.LCPI1_2(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm0, %ymm3, %ymm7
	vmovdqa	%ymm8, %ymm3
	vmovaps	.LCPI1_1(%rip), %ymm8   # ymm8 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm1, %ymm8, %ymm8
	vmaskmovpd	%ymm6, %ymm7, 32(%rbx,%rax)
	vmaskmovpd	%ymm13, %ymm8, 64(%rbx,%rax)
	vpblendd	$170, %ymm10, %ymm12, %ymm6 # ymm6 = ymm12[0],ymm10[1],ymm12[2],ymm10[3],ymm12[4],ymm10[5],ymm12[6],ymm10[7]
	vmovaps	.LCPI1_2(%rip), %ymm13  # ymm13 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm1, %ymm13, %ymm13
	vmaskmovpd	%ymm6, %ymm13, 96(%rbx,%rax)
	vpsrlq	$32, %ymm14, %ymm6
	vblendvpd	%ymm5, %ymm6, %ymm4, %ymm4
	vpsrlq	$32, %ymm15, %ymm5
	vmovapd	%ymm4, %ymm15
	vblendvpd	%ymm7, %ymm5, %ymm2, %ymm2
	vpsrlq	$32, %ymm12, %ymm5
	vpsrlq	$32, %ymm11, %ymm6
	vblendvpd	%ymm8, %ymm6, %ymm3, %ymm3
	vmovapd	%ymm3, %ymm8
	vblendvpd	%ymm13, %ymm5, %ymm9, %ymm9
	vpcmpeqq	%ymm10, %ymm2, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	%ymm10, %ymm4, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	%ymm10, %ymm9, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vpcmpeqq	%ymm10, %ymm3, %ymm7
	vextracti128	$1, %ymm7, %xmm3
	vpackssdw	%xmm3, %xmm7, %xmm3
	vinserti128	$1, %xmm4, %ymm3, %ymm3
	vblendvps	%ymm3, %ymm10, %ymm1, %ymm1
	vinserti128	$1, %xmm5, %ymm6, %ymm3
	vblendvps	%ymm3, %ymm10, %ymm0, %ymm0
	addl	$1, %r15d
	vmovmskps	%ymm0, %eax
	vmovmskps	%ymm1, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	jne	.LBB1_64
.LBB1_65:                               # %for_exit
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	64(%rsp), %ymm1         # 32-byte Reload
	vpcmpeqq	%ymm0, %ymm1, %ymm3
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqa	96(%rsp), %ymm10        # 32-byte Reload
	vpcmpeqq	%ymm0, %ymm10, %ymm4
	vpxor	%ymm2, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm5
	vmovdqa	128(%rsp), %ymm7        # 32-byte Reload
	vpcmpeqq	%ymm0, %ymm7, %ymm3
	vpxor	%ymm2, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqa	160(%rsp), %ymm12       # 32-byte Reload
	vpcmpeqq	%ymm0, %ymm12, %ymm4
	vpxor	%ymm2, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm6
	vmovmskps	%ymm6, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB1_68
# %bb.66:                               # %for_loop202.lr.ph
	leal	(%r13,%r13,2), %eax
	vmovaps	.LCPI1_1(%rip), %ymm8   # ymm8 = [0,0,1,1,2,2,3,3]
	.p2align	4, 0x90
.LBB1_67:                               # %for_loop202
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpaddq	(%rbx,%rcx), %ymm12, %ymm3
	vpaddq	32(%rbx,%rcx), %ymm7, %ymm4
	vpaddq	64(%rbx,%rcx), %ymm10, %ymm9
	vmovdqa	%ymm10, %ymm2
	vpaddq	96(%rbx,%rcx), %ymm1, %ymm10
	vpblendd	$170, %ymm0, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm15 # ymm15 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpermps	%ymm6, %ymm8, %ymm13
	vmovaps	.LCPI1_2(%rip), %ymm0   # ymm0 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm6, %ymm0, %ymm14
	vmaskmovpd	%ymm15, %ymm13, (%rbx,%rcx)
	vmaskmovpd	%ymm11, %ymm14, 32(%rbx,%rcx)
	vpblendd	$170, .LCPI1_3, %ymm9, %ymm11 # ymm11 = ymm9[0],mem[1],ymm9[2],mem[3],ymm9[4],mem[5],ymm9[6],mem[7]
	vpermps	%ymm5, %ymm8, %ymm15
	vmaskmovpd	%ymm11, %ymm15, 64(%rbx,%rcx)
	vpsrad	$31, %ymm3, %ymm11
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm11[1],ymm3[2],ymm11[3],ymm3[4],ymm11[5],ymm3[6],ymm11[7]
	vblendvpd	%ymm13, %ymm3, %ymm12, %ymm12
	vpblendd	$170, .LCPI1_3, %ymm10, %ymm3 # ymm3 = ymm10[0],mem[1],ymm10[2],mem[3],ymm10[4],mem[5],ymm10[6],mem[7]
	vpermps	%ymm5, %ymm0, %ymm11
	vxorps	%xmm0, %xmm0, %xmm0
	vmaskmovpd	%ymm3, %ymm11, 96(%rbx,%rcx)
	vpsrad	$31, %ymm4, %ymm3
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm3 # ymm3 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vblendvpd	%ymm14, %ymm3, %ymm7, %ymm7
	vpsrad	$31, %ymm10, %ymm3
	vpshufd	$245, %ymm10, %ymm4     # ymm4 = ymm10[1,1,3,3,5,5,7,7]
	vmovdqa	%ymm2, %ymm10
	vpblendd	$170, %ymm3, %ymm4, %ymm3 # ymm3 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm9, %ymm4
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm9, %ymm4 # ymm4 = ymm9[0],ymm4[1],ymm9[2],ymm4[3],ymm9[4],ymm4[5],ymm9[6],ymm4[7]
	vblendvpd	%ymm15, %ymm4, %ymm2, %ymm10
	vblendvpd	%ymm11, %ymm3, %ymm1, %ymm1
	vpcmpeqq	%ymm0, %ymm7, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	%ymm0, %ymm12, %ymm4
	vmovapd	%ymm7, %ymm11
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vpcmpeqq	%ymm0, %ymm1, %ymm7
	vextracti128	$1, %ymm7, %xmm2
	vpackssdw	%xmm2, %xmm7, %xmm2
	vpcmpeqq	%ymm0, %ymm10, %ymm7
	vmovapd	%ymm1, %ymm9
	vextracti128	$1, %ymm7, %xmm1
	vpackssdw	%xmm1, %xmm7, %xmm1
	vmovapd	%ymm11, %ymm7
	vinserti128	$1, %xmm2, %ymm1, %ymm1
	vblendvps	%ymm1, %ymm0, %ymm5, %ymm5
	vinserti128	$1, %xmm3, %ymm4, %ymm1
	vblendvps	%ymm1, %ymm0, %ymm6, %ymm6
	vmovapd	%ymm9, %ymm1
	addl	$1, %eax
	vmovmskps	%ymm6, %ecx
	vmovmskps	%ymm5, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	jne	.LBB1_67
.LBB1_68:                               # %for_exit203
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end1:
	.size	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu, .Lfunc_end1-toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
.LCPI2_0:
	.long	8                       # 0x8
	.long	9                       # 0x9
	.long	10                      # 0xa
	.long	11                      # 0xb
	.long	12                      # 0xc
	.long	13                      # 0xd
	.long	14                      # 0xe
	.long	15                      # 0xf
.LCPI2_1:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI2_2:
	.long	0                       # 0x0
	.long	2                       # 0x2
	.long	4                       # 0x4
	.long	6                       # 0x6
	.long	4                       # 0x4
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI2_3:
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	3                       # 0x3
.LCPI2_4:
	.long	4                       # 0x4
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
	.long	7                       # 0x7
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2
.LCPI2_5:
	.long	1                       # float 1.40129846E-45
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI2_6:
	.quad	1                       # 0x1
	.text
	.globl	fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
	.p2align	4, 0x90
	.type	fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu,@function
fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu: # @fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
# %bb.0:                                # %allocas
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-128, %rsp
	subq	$90880, %rsp            # imm = 0x16300
	vmovaps	%ymm1, %ymm10
	vmovaps	%ymm0, %ymm15
	movl	%r9d, 76(%rsp)          # 4-byte Spill
                                        # kill: def $r8d killed $r8d def $r8
	movq	%rcx, %r11
	vmovmskps	%ymm0, %eax
	vmovmskps	%ymm1, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	movq	%r8, %rax
	movq	%r8, 64(%rsp)           # 8-byte Spill
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm1
	vpmulld	.LCPI2_0(%rip), %ymm1, %ymm0
	vpmulld	.LCPI2_1(%rip), %ymm1, %ymm1
	cmpl	$65535, %ecx            # imm = 0xFFFF
	jne	.LBB2_1
# %bb.5:                                # %for_test.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_6
# %bb.7:                                # %for_loop.lr.ph
	movq	64(%rsp), %rax          # 8-byte Reload
	movl	%eax, %r9d
	andl	$1, %r9d
	cmpl	$1, %eax
	movq	%r11, 80(%rsp)          # 8-byte Spill
	movl	%r9d, 224(%rsp)         # 4-byte Spill
	jne	.LBB2_9
# %bb.8:
	xorl	%eax, %eax
	jmp	.LBB2_12
.LBB2_1:                                # %for_test487.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_2
# %bb.3:                                # %for_loop489.lr.ph
	movq	64(%rsp), %rax          # 8-byte Reload
	movl	%eax, %r9d
	andl	$1, %r9d
	cmpl	$1, %eax
	movq	%r11, 80(%rsp)          # 8-byte Spill
	movl	%r9d, 92(%rsp)          # 4-byte Spill
	jne	.LBB2_75
# %bb.4:
	xorl	%eax, %eax
	jmp	.LBB2_78
.LBB2_9:                                # %for_loop.lr.ph.new
	movq	64(%rsp), %r8           # 8-byte Reload
                                        # kill: def $r8d killed $r8d killed $r8 def $r8
	subl	%r9d, %r8d
	movl	$64, %ebx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB2_10:                               # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vpslld	$2, %ymm2, %ymm2
	vpslld	$2, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm3), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm2), %ymm5
	vmovdqa	%ymm5, 21088(%rsp,%rbx)
	vmovdqa	%ymm4, 21056(%rsp,%rbx)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm3), %ymm4
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm2), %ymm3
	vpmovzxdq	%xmm4, %ymm2    # ymm2 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 8768(%rsp,%rbx,2)
	leal	1(%rax), %ecx
	vmovd	%ecx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vmovdqa	%ymm2, 8704(%rsp,%rbx,2)
	vpaddd	%ymm1, %ymm5, %ymm2
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovdqa	%ymm3, 8800(%rsp,%rbx,2)
	vpslld	$2, %ymm5, %ymm3
	vpslld	$2, %ymm2, %ymm2
	vmovdqa	%ymm4, 8736(%rsp,%rbx,2)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm2), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm3), %ymm5
	vmovdqa	%ymm5, 21152(%rsp,%rbx)
	vmovdqa	%ymm4, 21120(%rsp,%rbx)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm2), %ymm4
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm3), %ymm2
	vpmovzxdq	%xmm4, %ymm3    # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm2, %ymm5    # ymm5 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vmovdqa	%ymm5, 8896(%rsp,%rbx,2)
	vmovdqa	%ymm2, 8928(%rsp,%rbx,2)
	vmovdqa	%ymm3, 8832(%rsp,%rbx,2)
	vmovdqa	%ymm4, 8864(%rsp,%rbx,2)
	addq	$2, %rax
	subq	$-128, %rbx
	cmpl	%eax, %r8d
	jne	.LBB2_10
# %bb.11:                               # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB2_13
.LBB2_12:                               # %for_loop.epil.preheader
	movq	%rax, %rcx
	shlq	$6, %rcx
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vpaddd	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm0, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpgatherdd	%ymm3, (%rdi,%ymm1), %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpgatherdd	%ymm4, (%rdi,%ymm0), %ymm3
	vmovdqa	%ymm3, 21152(%rsp,%rcx)
	vmovdqa	%ymm2, 21120(%rsp,%rcx)
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpgatherdd	%ymm3, (%rdx,%ymm1), %ymm2
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm1, (%rdx,%ymm0), %ymm3
	shlq	$7, %rax
	vpmovzxdq	%xmm2, %ymm0    # ymm0 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpmovzxdq	%xmm3, %ymm2    # ymm2 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm3, 8928(%rsp,%rax)
	vmovdqa	%ymm2, 8896(%rsp,%rax)
	vmovdqa	%ymm1, 8864(%rsp,%rax)
	vmovdqa	%ymm0, 8832(%rsp,%rax)
.LBB2_13:                               # %for_exit
	vmovups	(%rsi), %ymm0
	vmovaps	%ymm0, 416(%rsp)        # 32-byte Spill
	vmovdqu	32(%rsi), %ymm0
	vmovdqa	%ymm0, 384(%rsp)        # 32-byte Spill
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	jle	.LBB2_19
# %bb.14:                               # %for_loop34.lr.ph
	movabsq	$4294967296, %r15       # imm = 0x100000000
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	76(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %r8d
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm6
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm5
	movq	64(%rsp), %rax          # 8-byte Reload
	movslq	%eax, %rcx
	leaq	21184(%rsp), %r13
	movl	%eax, %r12d
	subl	224(%rsp), %r12d        # 4-byte Folded Reload
	movl	%eax, %r14d
	leaq	8832(%rsp), %rsi
	vmovdqa	%ymm6, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm5, 128(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_15:                               # %for_loop34
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_42 Depth 2
                                        #       Child Loop BB2_43 Depth 3
                                        #         Child Loop BB2_31 Depth 4
                                        #       Child Loop BB2_36 Depth 3
                                        #       Child Loop BB2_38 Depth 3
                                        #         Child Loop BB2_39 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 352(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB2_17
# %bb.16:                               # %for_loop34
                                        #   in Loop: Header=BB2_15 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_17:                               # %for_loop34
                                        #   in Loop: Header=BB2_15 Depth=1
	vpaddd	21152(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 256(%rsp)        # 32-byte Spill
	vpaddd	21120(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 320(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_42:                               # %for_loop51.lr.ph.split.us
                                        #   Parent Loop BB2_15 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_43 Depth 3
                                        #         Child Loop BB2_31 Depth 4
                                        #       Child Loop BB2_36 Depth 3
                                        #       Child Loop BB2_38 Depth 3
                                        #         Child Loop BB2_39 Depth 4
	leaq	74368(%rsp), %rdi
	movq	64(%rsp), %rdx          # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	movl	%r8d, %ebx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	vpxor	%xmm15, %xmm15, %xmm15
	movl	%ebx, %r8d
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa	416(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	384(%rsp), %ymm13       # 32-byte Reload
	vmovdqa	.LCPI2_2(%rip), %ymm14  # ymm14 = [0,2,4,6,4,6,6,7]
	.p2align	4, 0x90
.LBB2_43:                               # %for_loop62.lr.ph.us
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_42 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_31 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpermd	74432(%rsp,%rdx), %ymm14, %ymm0
	vpermd	74464(%rsp,%rdx), %ymm14, %ymm1
	vpermd	74368(%rsp,%rdx), %ymm14, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	74400(%rsp,%rdx), %ymm14, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	%ymm1, %ymm12, %ymm3
	vpmulld	%ymm0, %ymm13, %ymm1
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	jne	.LBB2_30
# %bb.44:                               #   in Loop: Header=BB2_43 Depth=3
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	jmp	.LBB2_33
	.p2align	4, 0x90
.LBB2_30:                               # %for_loop62.lr.ph.us.new
                                        #   in Loop: Header=BB2_43 Depth=3
	vpxor	%xmm5, %xmm5, %xmm5
	movq	%r13, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_31:                               # %for_loop62.us
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_42 Depth=2
                                        #       Parent Loop BB2_43 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-16(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	vpmuludq	%ymm1, %ymm9, %ymm9
	vpmuludq	%ymm0, %ymm8, %ymm8
	leal	(%rcx,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	74368(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	74400(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	74432(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	74464(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm4, %ymm4
	vpblendd	$170, %ymm15, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vmovdqa	%ymm11, 74464(%rsp,%rbx)
	vmovdqa	%ymm10, 74432(%rsp,%rbx)
	vmovdqa	%ymm9, 74400(%rsp,%rbx)
	vmovdqa	%ymm8, 74368(%rsp,%rbx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm7, %ymm7
	vpmovzxdq	(%rdi), %ymm8   # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm0, %ymm10, %ymm10
	vpmuludq	%ymm1, %ymm9, %ymm9
	vpmuludq	%ymm3, %ymm8, %ymm8
	leal	(%rax,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	74400(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	74464(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpaddq	74432(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	74368(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm8, %ymm5, %ymm5
	vpblendd	$170, %ymm15, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 74368(%rsp,%rbx)
	vmovdqa	%ymm10, 74432(%rsp,%rbx)
	vmovdqa	%ymm9, 74464(%rsp,%rbx)
	vmovdqa	%ymm8, 74400(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r12d
	jne	.LBB2_31
# %bb.32:                               # %for_test60.for_exit63_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_43 Depth=3
	testb	$1, 64(%rsp)            # 1-byte Folded Reload
	je	.LBB2_34
.LBB2_33:                               # %for_loop62.us.epil.preheader
                                        #   in Loop: Header=BB2_43 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	21168(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21152(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21136(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21120(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	vpmuludq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	74368(%rsp,%rsi), %ymm5, %ymm5
	vpaddq	74400(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm5, %ymm3
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	74432(%rsp,%rsi), %ymm6, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpaddq	74464(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpblendd	$170, %ymm15, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqa	%ymm7, 74464(%rsp,%rsi)
	vmovdqa	%ymm6, 74432(%rsp,%rsi)
	vmovdqa	%ymm5, 74400(%rsp,%rsi)
	vmovdqa	%ymm4, 74368(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm4
	vpsrlq	$32, %ymm1, %ymm6
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm5
.LBB2_34:                               # %for_exit63.us
                                        #   in Loop: Header=BB2_43 Depth=3
	vmovdqa	%ymm7, 8864(%rsp,%rdx)
	vmovdqa	%ymm5, 8832(%rsp,%rdx)
	vmovdqa	%ymm6, 8896(%rsp,%rdx)
	vmovdqa	%ymm4, 8928(%rsp,%rdx)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r14, %rcx
	jne	.LBB2_43
# %bb.35:                               # %for_loop92.lr.ph
                                        #   in Loop: Header=BB2_42 Depth=2
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	320(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	256(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpxor	%xmm11, %xmm11, %xmm11
	vpcmpeqd	%ymm11, %ymm0, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm11, %ymm1, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI2_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	xorl	%eax, %eax
	leaq	8832(%rsp), %rsi
	movq	%rsi, %rcx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm12, %xmm12, %xmm12
	.p2align	4, 0x90
.LBB2_36:                               # %for_loop92
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_42 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	movq	64(%rsp), %rdi          # 8-byte Reload
	leal	(%rdi,%rax), %ebx
	movslq	%ebx, %rbx
	shlq	$7, %rbx
	vmovdqa	74368(%rsp,%rbx), %ymm0
	vmovdqa	74400(%rsp,%rbx), %ymm1
	vmovdqa	74432(%rsp,%rbx), %ymm8
	vmovdqa	74464(%rsp,%rbx), %ymm9
	vpaddq	8832(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	8864(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	8896(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	8928(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	%ymm0, %ymm0, %ymm10
	vblendvpd	%ymm4, %ymm10, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm10
	vblendvpd	%ymm5, %ymm10, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm8, %ymm10
	vblendvpd	%ymm6, %ymm10, %ymm8, %ymm8
	vpaddq	%ymm9, %ymm9, %ymm10
	vblendvpd	%ymm7, %ymm10, %ymm9, %ymm9
	vpaddq	%ymm9, %ymm12, %ymm3
	vpblendd	$170, %ymm15, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vmovdqa	%ymm9, 96(%rcx)
	vpaddq	%ymm8, %ymm14, %ymm2
	vpblendd	$170, %ymm15, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vmovdqa	%ymm8, 64(%rcx)
	vpaddq	%ymm1, %ymm13, %ymm1
	vpblendd	$170, %ymm15, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm8, 32(%rcx)
	vpaddq	%ymm0, %ymm11, %ymm0
	vpblendd	$170, %ymm15, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqa	%ymm8, (%rcx)
	vpsrlq	$32, %ymm3, %ymm12
	vpsrlq	$32, %ymm2, %ymm14
	vpsrlq	$32, %ymm1, %ymm13
	vpsrlq	$32, %ymm0, %ymm11
	addl	$1, %eax
	subq	$-128, %rcx
	cmpl	%eax, %edi
	jne	.LBB2_36
# %bb.37:                               # %for_test126.preheader
                                        #   in Loop: Header=BB2_42 Depth=2
	vpcmpeqq	%ymm15, %ymm12, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm14, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm3
	vpcmpeqq	%ymm15, %ymm13, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm11, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	160(%rsp), %ymm6        # 32-byte Reload
	je	.LBB2_41
	.p2align	4, 0x90
.LBB2_38:                               # %for_loop142.lr.ph
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_42 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_39 Depth 4
	vmovdqa	%ymm12, 544(%rsp)       # 32-byte Spill
	vmovdqa	%ymm14, 576(%rsp)       # 32-byte Spill
	vmovdqa	%ymm13, 608(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 448(%rsp)       # 32-byte Spill
	vmovaps	.LCPI2_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm2, %ymm0, %ymm1
	vmovaps	%ymm1, 96(%rsp)         # 32-byte Spill
	vmovaps	.LCPI2_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovaps	%ymm2, 480(%rsp)        # 32-byte Spill
	vpermps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm2, 192(%rsp)        # 32-byte Spill
	vpermps	%ymm3, %ymm0, %ymm8
	vmovaps	%ymm3, 512(%rsp)        # 32-byte Spill
	vpermps	%ymm3, %ymm1, %ymm9
	vpxor	%xmm12, %xmm12, %xmm12
	movq	%r14, %rax
	movq	%rsi, %rcx
	movl	$0, %edx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB2_39:                               # %for_loop142
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_42 Depth=2
                                        #       Parent Loop BB2_38 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	(%rcx), %ymm0
	vmovdqa	32(%rcx), %ymm1
	movq	%rdx, %rdi
	sarq	$26, %rdi
	vmovdqa	21120(%rsp,%rdi), %ymm4
	vmovdqa	21152(%rsp,%rdi), %ymm5
	vpsllvd	%ymm6, %ymm4, %ymm2
	vpor	%ymm15, %ymm2, %ymm2
	vpsllvd	%ymm6, %ymm5, %ymm15
	vpor	%ymm14, %ymm15, %ymm14
	vextracti128	$1, %ymm2, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm1, %ymm3
	vpaddq	%ymm13, %ymm3, %ymm3
	vmovdqa	64(%rcx), %ymm13
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm2, %ymm0, %ymm2
	vpaddq	%ymm12, %ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm12 # ymm12 = ymm2[0],ymm7[1],ymm2[2],ymm7[3],ymm2[4],ymm7[5],ymm2[6],ymm7[7]
	vmovapd	96(%rsp), %ymm6         # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm7[1],ymm3[2],ymm7[3],ymm3[4],ymm7[5],ymm3[6],ymm7[7]
	vmovapd	192(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm1, %ymm1
	vpmovzxdq	%xmm14, %ymm12  # ymm12 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm12, %ymm13, %ymm12
	vpaddq	%ymm11, %ymm12, %ymm11
	vpblendd	$170, %ymm7, %ymm11, %ymm12 # ymm12 = ymm11[0],ymm7[1],ymm11[2],ymm7[3],ymm11[4],ymm7[5],ymm11[6],ymm7[7]
	vblendvpd	%ymm8, %ymm12, %ymm13, %ymm12
	vmovdqa	96(%rcx), %ymm13
	vextracti128	$1, %ymm14, %xmm6
	vpmovzxdq	%xmm6, %ymm6    # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
	vpsubq	%ymm6, %ymm13, %ymm6
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm7[1],ymm6[2],ymm7[3],ymm6[4],ymm7[5],ymm6[6],ymm7[7]
	vblendvpd	%ymm9, %ymm10, %ymm13, %ymm10
	vmovapd	%ymm10, 96(%rcx)
	vmovapd	%ymm12, 64(%rcx)
	vpsrlvd	128(%rsp), %ymm5, %ymm14 # 32-byte Folded Reload
	vmovdqa	128(%rsp), %ymm5        # 32-byte Reload
	vpsrlvd	%ymm5, %ymm4, %ymm15
	vmovapd	%ymm1, 32(%rcx)
	vmovapd	%ymm0, (%rcx)
	vpsrad	$31, %ymm6, %ymm0
	vpshufd	$245, %ymm6, %ymm1      # ymm1 = ymm6[1,1,3,3,5,5,7,7]
	vmovdqa	160(%rsp), %ymm6        # 32-byte Reload
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm1      # ymm1 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm2, %ymm0
	vpshufd	$245, %ymm2, %ymm1      # ymm1 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	%r15, %rdx
	subq	$-128, %rcx
	addq	$-1, %rax
	jne	.LBB2_39
# %bb.40:                               # %for_exit143
                                        #   in Loop: Header=BB2_38 Depth=3
	vmovdqa	544(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm10, %ymm0
	vmovdqa	576(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm11, %ymm1
	vmovdqa	608(%rsp), %ymm3        # 32-byte Reload
	vpaddq	%ymm3, %ymm13, %ymm2
	vmovdqa	%ymm3, %ymm13
	vmovdqa	448(%rsp), %ymm11       # 32-byte Reload
	vpaddq	%ymm11, %ymm12, %ymm3
	vmovdqa	%ymm4, %ymm12
	vmovapd	96(%rsp), %ymm4         # 32-byte Reload
	vblendvpd	%ymm4, %ymm3, %ymm11, %ymm11
	vmovapd	192(%rsp), %ymm3        # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm13, %ymm13
	vblendvpd	%ymm8, %ymm1, %ymm14, %ymm14
	vblendvpd	%ymm9, %ymm0, %ymm12, %ymm12
	vpcmpeqq	%ymm7, %ymm13, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm7, %ymm11, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpcmpeqq	%ymm7, %ymm12, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm7, %ymm14, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovdqa	512(%rsp), %ymm3        # 32-byte Reload
	vpandn	%ymm3, %ymm1, %ymm3
	vmovdqa	480(%rsp), %ymm2        # 32-byte Reload
	vpandn	%ymm2, %ymm0, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	jne	.LBB2_38
.LBB2_41:                               # %for_exit129
                                        #   in Loop: Header=BB2_42 Depth=2
	shrl	%r8d
	jne	.LBB2_42
# %bb.18:                               # %for_test32.loopexit
                                        #   in Loop: Header=BB2_15 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	352(%rsp), %rcx         # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB2_15
.LBB2_19:                               # %for_test188.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_20
# %bb.21:                               # %for_loop190.lr.ph
	movq	64(%rsp), %rax          # 8-byte Reload
	leal	-1(%rax), %ecx
                                        # kill: def $eax killed $eax killed $rax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB2_53
# %bb.22:
	xorl	%ecx, %ecx
	movq	80(%rsp), %r11          # 8-byte Reload
	movl	224(%rsp), %r14d        # 4-byte Reload
	jmp	.LBB2_23
.LBB2_75:                               # %for_loop489.lr.ph.new
	movq	64(%rsp), %r8           # 8-byte Reload
                                        # kill: def $r8d killed $r8d killed $r8 def $r8
	subl	%r9d, %r8d
	movl	$64, %ebx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB2_76:                               # %for_loop489
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vpslld	$2, %ymm3, %ymm3
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdi,%ymm3), %ymm5
	vpslld	$2, %ymm2, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vmovaps	%ymm10, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm2), %ymm4
	vmovdqa	%ymm4, 16992(%rsp,%rbx)
	vmovdqa	%ymm5, 16960(%rsp,%rbx)
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vpxor	%xmm3, %xmm3, %xmm3
	vmovaps	%ymm10, %ymm4
	vpgatherdd	%ymm4, (%rdx,%ymm2), %ymm3
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 576(%rsp,%rbx,2)
	vmovdqa	%ymm2, 512(%rsp,%rbx,2)
	leal	1(%rax), %ecx
	vmovd	%ecx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vmovdqa	%ymm3, 608(%rsp,%rbx,2)
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vmovdqa	%ymm4, 544(%rsp,%rbx,2)
	vpslld	$2, %ymm3, %ymm3
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdi,%ymm3), %ymm5
	vpslld	$2, %ymm2, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vmovaps	%ymm10, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm2), %ymm4
	vmovdqa	%ymm4, 17056(%rsp,%rbx)
	vmovdqa	%ymm5, 17024(%rsp,%rbx)
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vpxor	%xmm3, %xmm3, %xmm3
	vmovaps	%ymm10, %ymm4
	vpgatherdd	%ymm4, (%rdx,%ymm2), %ymm3
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 704(%rsp,%rbx,2)
	vmovdqa	%ymm3, 736(%rsp,%rbx,2)
	vmovdqa	%ymm2, 640(%rsp,%rbx,2)
	vmovdqa	%ymm4, 672(%rsp,%rbx,2)
	addq	$2, %rax
	subq	$-128, %rbx
	cmpl	%eax, %r8d
	jne	.LBB2_76
# %bb.77:                               # %for_test487.for_exit490_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB2_79
.LBB2_78:                               # %for_loop489.epil.preheader
	movq	%rax, %rcx
	shlq	$6, %rcx
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vpaddd	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vmovaps	%ymm15, %ymm3
	vpgatherdd	%ymm3, (%rdi,%ymm1), %ymm2
	vpslld	$2, %ymm0, %ymm0
	vpxor	%xmm3, %xmm3, %xmm3
	vmovaps	%ymm10, %ymm4
	vpgatherdd	%ymm4, (%rdi,%ymm0), %ymm3
	vmovdqa	%ymm3, 17056(%rsp,%rcx)
	vmovdqa	%ymm2, 17024(%rsp,%rcx)
	vpxor	%xmm2, %xmm2, %xmm2
	vmovaps	%ymm15, %ymm3
	vpgatherdd	%ymm3, (%rdx,%ymm1), %ymm2
	vpxor	%xmm1, %xmm1, %xmm1
	vmovaps	%ymm10, %ymm3
	vpgatherdd	%ymm3, (%rdx,%ymm0), %ymm1
	shlq	$7, %rax
	vpmovzxdq	%xmm2, %ymm0    # ymm0 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm1, %ymm3    # ymm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vmovdqa	%ymm1, 736(%rsp,%rax)
	vmovdqa	%ymm3, 704(%rsp,%rax)
	vmovdqa	%ymm2, 672(%rsp,%rax)
	vmovdqa	%ymm0, 640(%rsp,%rax)
.LBB2_79:                               # %for_exit490
	vmaskmovps	(%rsi), %ymm15, %ymm0
	vmovaps	%ymm0, 352(%rsp)        # 32-byte Spill
	vmaskmovps	32(%rsi), %ymm10, %ymm0
	vmovaps	%ymm0, 224(%rsp)        # 32-byte Spill
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	jle	.LBB2_85
# %bb.80:                               # %for_loop529.lr.ph
	movabsq	$4294967296, %r15       # imm = 0x100000000
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	76(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %r8d
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm6
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm5
	movq	64(%rsp), %rax          # 8-byte Reload
	movslq	%eax, %rcx
	leaq	17088(%rsp), %r13
	movl	%eax, %r14d
	subl	92(%rsp), %r14d         # 4-byte Folded Reload
	movl	%eax, %r12d
	leaq	640(%rsp), %rsi
	vmovaps	%ymm10, 256(%rsp)       # 32-byte Spill
	vmovaps	%ymm15, 320(%rsp)       # 32-byte Spill
	vmovdqa	%ymm6, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm5, 128(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_81:                               # %for_loop529
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_108 Depth 2
                                        #       Child Loop BB2_109 Depth 3
                                        #         Child Loop BB2_97 Depth 4
                                        #       Child Loop BB2_102 Depth 3
                                        #       Child Loop BB2_104 Depth 3
                                        #         Child Loop BB2_105 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 312(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB2_83
# %bb.82:                               # %for_loop529
                                        #   in Loop: Header=BB2_81 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_83:                               # %for_loop529
                                        #   in Loop: Header=BB2_81 Depth=1
	vpaddd	17056(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 416(%rsp)        # 32-byte Spill
	vpaddd	17024(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 384(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_108:                              # %for_loop559.lr.ph.split.us
                                        #   Parent Loop BB2_81 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_109 Depth 3
                                        #         Child Loop BB2_97 Depth 4
                                        #       Child Loop BB2_102 Depth 3
                                        #       Child Loop BB2_104 Depth 3
                                        #         Child Loop BB2_105 Depth 4
	leaq	57984(%rsp), %rdi
	movq	64(%rsp), %rdx          # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	movl	%r8d, %ebx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movl	%ebx, %r8d
	vmovdqa	320(%rsp), %ymm15       # 32-byte Reload
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa	352(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	224(%rsp), %ymm13       # 32-byte Reload
	.p2align	4, 0x90
.LBB2_109:                              # %for_loop575.lr.ph.us
                                        #   Parent Loop BB2_81 Depth=1
                                        #     Parent Loop BB2_108 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_97 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vmovdqa	%ymm0, %ymm3
	vpermd	58048(%rsp,%rdx), %ymm0, %ymm0
	vpermd	58080(%rsp,%rdx), %ymm3, %ymm1
	vpermd	57984(%rsp,%rdx), %ymm3, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	58016(%rsp,%rdx), %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	%ymm12, %ymm1, %ymm3
	vpmulld	%ymm13, %ymm0, %ymm1
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	jne	.LBB2_96
# %bb.110:                              #   in Loop: Header=BB2_109 Depth=3
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	jmp	.LBB2_99
	.p2align	4, 0x90
.LBB2_96:                               # %for_loop575.lr.ph.us.new
                                        #   in Loop: Header=BB2_109 Depth=3
	vpxor	%xmm5, %xmm5, %xmm5
	movq	%r13, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB2_97:                               # %for_loop575.us
                                        #   Parent Loop BB2_81 Depth=1
                                        #     Parent Loop BB2_108 Depth=2
                                        #       Parent Loop BB2_109 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-16(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	vpmuludq	%ymm1, %ymm9, %ymm9
	vpmuludq	%ymm0, %ymm8, %ymm8
	leal	(%rcx,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	57984(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	58016(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	58048(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	58080(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm4, %ymm4
	vpblendd	$170, %ymm14, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm14[1],ymm5[2],ymm14[3],ymm5[4],ymm14[5],ymm5[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm14[1],ymm7[2],ymm14[3],ymm7[4],ymm14[5],ymm7[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm14[1],ymm6[2],ymm14[3],ymm6[4],ymm14[5],ymm6[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm14[1],ymm4[2],ymm14[3],ymm4[4],ymm14[5],ymm4[6],ymm14[7]
	vmovdqa	%ymm11, 58080(%rsp,%rbx)
	vmovdqa	%ymm10, 58048(%rsp,%rbx)
	vmovdqa	%ymm9, 58016(%rsp,%rbx)
	vmovdqa	%ymm8, 57984(%rsp,%rbx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm7, %ymm7
	vpmovzxdq	(%rdi), %ymm8   # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm0, %ymm10, %ymm10
	vpmuludq	%ymm1, %ymm9, %ymm9
	vpmuludq	%ymm3, %ymm8, %ymm8
	leal	(%rax,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	58016(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	58080(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpaddq	58048(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	57984(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm8, %ymm5, %ymm5
	vpblendd	$170, %ymm14, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm14[1],ymm7[2],ymm14[3],ymm7[4],ymm14[5],ymm7[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm14[1],ymm4[2],ymm14[3],ymm4[4],ymm14[5],ymm4[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm14[1],ymm6[2],ymm14[3],ymm6[4],ymm14[5],ymm6[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm14[1],ymm5[2],ymm14[3],ymm5[4],ymm14[5],ymm5[6],ymm14[7]
	vmovdqa	%ymm11, 57984(%rsp,%rbx)
	vmovdqa	%ymm10, 58048(%rsp,%rbx)
	vmovdqa	%ymm9, 58080(%rsp,%rbx)
	vmovdqa	%ymm8, 58016(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r14d
	jne	.LBB2_97
# %bb.98:                               # %for_test573.for_exit576_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_109 Depth=3
	testb	$1, 64(%rsp)            # 1-byte Folded Reload
	je	.LBB2_100
.LBB2_99:                               # %for_loop575.us.epil.preheader
                                        #   in Loop: Header=BB2_109 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	17072(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17056(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17040(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17024(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	vpmuludq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	57984(%rsp,%rsi), %ymm5, %ymm5
	vpaddq	58016(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm5, %ymm3
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	58048(%rsp,%rsi), %ymm6, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpaddq	58080(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpxor	%xmm7, %xmm7, %xmm7
	vpblendd	$170, %ymm7, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm7[1],ymm3[2],ymm7[3],ymm3[4],ymm7[5],ymm3[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm7[1],ymm2[2],ymm7[3],ymm2[4],ymm7[5],ymm2[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm7[1],ymm1[2],ymm7[3],ymm1[4],ymm7[5],ymm1[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm7[1],ymm0[2],ymm7[3],ymm0[4],ymm7[5],ymm0[6],ymm7[7]
	vmovdqa	%ymm7, 58080(%rsp,%rsi)
	vmovdqa	%ymm6, 58048(%rsp,%rsi)
	vmovdqa	%ymm5, 58016(%rsp,%rsi)
	vmovdqa	%ymm4, 57984(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm4
	vpsrlq	$32, %ymm1, %ymm6
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm5
.LBB2_100:                              # %for_exit576.us
                                        #   in Loop: Header=BB2_109 Depth=3
	vmovdqa	%ymm7, 672(%rsp,%rdx)
	vmovdqa	%ymm5, 640(%rsp,%rdx)
	vmovdqa	%ymm6, 704(%rsp,%rdx)
	vmovdqa	%ymm4, 736(%rsp,%rdx)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r12, %rcx
	jne	.LBB2_109
# %bb.101:                              # %for_loop608.lr.ph
                                        #   in Loop: Header=BB2_108 Depth=2
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	384(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	416(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpxor	%xmm13, %xmm13, %xmm13
	vpcmpeqd	%ymm13, %ymm0, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm13, %ymm1, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI2_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	xorl	%eax, %eax
	leaq	640(%rsp), %rsi
	movq	%rsi, %rcx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm11, %xmm11, %xmm11
	.p2align	4, 0x90
.LBB2_102:                              # %for_loop608
                                        #   Parent Loop BB2_81 Depth=1
                                        #     Parent Loop BB2_108 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	movq	64(%rsp), %rdi          # 8-byte Reload
	leal	(%rdi,%rax), %ebx
	movslq	%ebx, %rbx
	shlq	$7, %rbx
	vmovdqa	57984(%rsp,%rbx), %ymm0
	vmovdqa	58016(%rsp,%rbx), %ymm1
	vmovdqa	58048(%rsp,%rbx), %ymm8
	vmovdqa	58080(%rsp,%rbx), %ymm9
	vpaddq	640(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	672(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	704(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	736(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	%ymm0, %ymm0, %ymm10
	vblendvpd	%ymm4, %ymm10, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm10
	vblendvpd	%ymm5, %ymm10, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm8, %ymm10
	vblendvpd	%ymm6, %ymm10, %ymm8, %ymm8
	vpaddq	%ymm9, %ymm9, %ymm10
	vblendvpd	%ymm7, %ymm10, %ymm9, %ymm9
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm11, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm11[1],ymm3[2],ymm11[3],ymm3[4],ymm11[5],ymm3[6],ymm11[7]
	vmovdqa	%ymm9, 96(%rcx)
	vpaddq	%ymm8, %ymm14, %ymm2
	vpblendd	$170, %ymm11, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vmovdqa	%ymm8, 64(%rcx)
	vpaddq	%ymm1, %ymm12, %ymm1
	vpblendd	$170, %ymm11, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vmovdqa	%ymm8, 32(%rcx)
	vpaddq	%ymm0, %ymm13, %ymm0
	vpblendd	$170, %ymm11, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vmovdqa	%ymm8, (%rcx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm14
	vpsrlq	$32, %ymm1, %ymm12
	vpsrlq	$32, %ymm0, %ymm13
	addl	$1, %eax
	subq	$-128, %rcx
	cmpl	%eax, %edi
	jne	.LBB2_102
# %bb.103:                              # %for_test648.preheader
                                        #   in Loop: Header=BB2_108 Depth=2
	vmovdqa	%ymm3, 448(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm11, %ymm3, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm11, %ymm14, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm3
	vpcmpeqq	%ymm11, %ymm12, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm11, %ymm13, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm2
	vpand	%ymm15, %ymm2, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	256(%rsp), %ymm10       # 32-byte Reload
	vpand	%ymm10, %ymm3, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	160(%rsp), %ymm6        # 32-byte Reload
	je	.LBB2_107
	.p2align	4, 0x90
.LBB2_104:                              # %for_loop668.lr.ph
                                        #   Parent Loop BB2_81 Depth=1
                                        #     Parent Loop BB2_108 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_105 Depth 4
	vmovdqa	%ymm14, 544(%rsp)       # 32-byte Spill
	vmovdqa	%ymm12, 576(%rsp)       # 32-byte Spill
	vmovdqa	%ymm13, 608(%rsp)       # 32-byte Spill
	vmovdqa	.LCPI2_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm2, %ymm0, %ymm1
	vmovdqa	%ymm1, 96(%rsp)         # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovdqa	%ymm2, 480(%rsp)        # 32-byte Spill
	vpermd	%ymm2, %ymm1, %ymm2
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	vpermd	%ymm3, %ymm0, %ymm8
	vmovdqa	%ymm3, 512(%rsp)        # 32-byte Spill
	vpermd	%ymm3, %ymm1, %ymm9
	vpxor	%xmm14, %xmm14, %xmm14
	movq	%r12, %rax
	movq	%rsi, %rcx
	movl	$0, %edx
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB2_105:                              # %for_loop668
                                        #   Parent Loop BB2_81 Depth=1
                                        #     Parent Loop BB2_108 Depth=2
                                        #       Parent Loop BB2_104 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	(%rcx), %ymm0
	vmovdqa	32(%rcx), %ymm1
	movq	%rdx, %rdi
	sarq	$26, %rdi
	vmovdqa	17024(%rsp,%rdi), %ymm4
	vmovdqa	17056(%rsp,%rdi), %ymm5
	vpsllvd	%ymm6, %ymm4, %ymm2
	vpor	%ymm14, %ymm2, %ymm2
	vpsllvd	%ymm6, %ymm5, %ymm14
	vpor	%ymm15, %ymm14, %ymm14
	vextracti128	$1, %ymm2, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm1, %ymm3
	vpaddq	%ymm12, %ymm3, %ymm3
	vmovdqa	64(%rcx), %ymm12
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm2, %ymm0, %ymm2
	vpaddq	%ymm13, %ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm7[1],ymm2[2],ymm7[3],ymm2[4],ymm7[5],ymm2[6],ymm7[7]
	vmovapd	96(%rsp), %ymm6         # 32-byte Reload
	vblendvpd	%ymm6, %ymm13, %ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm3, %ymm13 # ymm13 = ymm3[0],ymm7[1],ymm3[2],ymm7[3],ymm3[4],ymm7[5],ymm3[6],ymm7[7]
	vmovapd	192(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm13, %ymm1, %ymm1
	vpmovzxdq	%xmm14, %ymm13  # ymm13 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm13, %ymm12, %ymm13
	vpaddq	%ymm11, %ymm13, %ymm11
	vpblendd	$170, %ymm7, %ymm11, %ymm13 # ymm13 = ymm11[0],ymm7[1],ymm11[2],ymm7[3],ymm11[4],ymm7[5],ymm11[6],ymm7[7]
	vblendvpd	%ymm8, %ymm13, %ymm12, %ymm12
	vmovdqa	96(%rcx), %ymm13
	vextracti128	$1, %ymm14, %xmm6
	vpmovzxdq	%xmm6, %ymm6    # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
	vpsubq	%ymm6, %ymm13, %ymm6
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm7[1],ymm6[2],ymm7[3],ymm6[4],ymm7[5],ymm6[6],ymm7[7]
	vblendvpd	%ymm9, %ymm10, %ymm13, %ymm10
	vmovapd	%ymm10, 96(%rcx)
	vmovapd	%ymm12, 64(%rcx)
	vpsrlvd	128(%rsp), %ymm5, %ymm15 # 32-byte Folded Reload
	vmovdqa	128(%rsp), %ymm5        # 32-byte Reload
	vpsrlvd	%ymm5, %ymm4, %ymm14
	vmovapd	%ymm1, 32(%rcx)
	vmovapd	%ymm0, (%rcx)
	vpsrad	$31, %ymm6, %ymm0
	vpshufd	$245, %ymm6, %ymm1      # ymm1 = ymm6[1,1,3,3,5,5,7,7]
	vmovdqa	160(%rsp), %ymm6        # 32-byte Reload
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm1      # ymm1 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm2, %ymm0
	vpshufd	$245, %ymm2, %ymm1      # ymm1 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	%r15, %rdx
	subq	$-128, %rcx
	addq	$-1, %rax
	jne	.LBB2_105
# %bb.106:                              # %for_exit669
                                        #   in Loop: Header=BB2_104 Depth=3
	vmovdqa	608(%rsp), %ymm1        # 32-byte Reload
	vpaddq	%ymm1, %ymm13, %ymm0
	vmovdqa	%ymm1, %ymm13
	vmovapd	96(%rsp), %ymm1         # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm13, %ymm13
	vmovdqa	576(%rsp), %ymm1        # 32-byte Reload
	vpaddq	%ymm1, %ymm12, %ymm0
	vmovdqa	%ymm1, %ymm12
	vmovapd	192(%rsp), %ymm1        # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm12, %ymm12
	vmovdqa	448(%rsp), %ymm3        # 32-byte Reload
	vpaddq	%ymm3, %ymm10, %ymm0
	vmovdqa	544(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm11, %ymm1
	vblendvpd	%ymm8, %ymm1, %ymm14, %ymm14
	vblendvpd	%ymm9, %ymm0, %ymm3, %ymm3
	vpcmpeqq	%ymm7, %ymm12, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm7, %ymm13, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vmovapd	%ymm3, 448(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm7, %ymm3, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm7, %ymm14, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovdqa	512(%rsp), %ymm3        # 32-byte Reload
	vpandn	%ymm3, %ymm1, %ymm3
	vmovdqa	480(%rsp), %ymm2        # 32-byte Reload
	vpandn	%ymm2, %ymm0, %ymm2
	vmovdqa	320(%rsp), %ymm15       # 32-byte Reload
	vpand	%ymm15, %ymm2, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	256(%rsp), %ymm10       # 32-byte Reload
	vpand	%ymm10, %ymm3, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	jne	.LBB2_104
.LBB2_107:                              # %for_exit651
                                        #   in Loop: Header=BB2_108 Depth=2
	shrl	%r8d
	jne	.LBB2_108
# %bb.84:                               # %for_test527.loopexit
                                        #   in Loop: Header=BB2_81 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	312(%rsp), %rcx         # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB2_81
.LBB2_85:                               # %for_test720.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_86
# %bb.87:                               # %for_loop722.lr.ph
	movq	64(%rsp), %rax          # 8-byte Reload
	leal	-1(%rax), %ecx
                                        # kill: def $eax killed $eax killed $rax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB2_119
# %bb.88:
	xorl	%ecx, %ecx
	movq	80(%rsp), %r11          # 8-byte Reload
	movl	92(%rsp), %r14d         # 4-byte Reload
	jmp	.LBB2_89
.LBB2_20:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	80(%rsp), %r11          # 8-byte Reload
	jmp	.LBB2_60
.LBB2_86:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	80(%rsp), %r11          # 8-byte Reload
	jmp	.LBB2_126
.LBB2_53:                               # %for_loop190.lr.ph.new
	movq	64(%rsp), %rcx          # 8-byte Reload
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%ecx, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	movq	80(%rsp), %r11          # 8-byte Reload
	movl	224(%rsp), %r14d        # 4-byte Reload
	.p2align	4, 0x90
.LBB2_54:                               # %for_loop190
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	8480(%rsp,%rdi), %ymm1
	vmovaps	8512(%rsp,%rdi), %ymm2
	vmovaps	8544(%rsp,%rdi), %ymm3
	vmovaps	%ymm3, 41312(%rsp,%rdi)
	vmovaps	%ymm2, 41280(%rsp,%rdi)
	vmovaps	%ymm1, 41248(%rsp,%rdi)
	vmovaps	8448(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 41216(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41696(%rsp,%rsi)
	vmovdqa	%ymm0, 41664(%rsp,%rsi)
	vmovdqa	%ymm0, 41632(%rsp,%rsi)
	vmovdqa	%ymm0, 41600(%rsp,%rsi)
	vmovaps	8576(%rsp,%rdi), %ymm1
	vmovaps	8608(%rsp,%rdi), %ymm2
	vmovaps	8640(%rsp,%rdi), %ymm3
	vmovaps	8672(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 41440(%rsp,%rdi)
	vmovaps	%ymm3, 41408(%rsp,%rdi)
	vmovaps	%ymm2, 41376(%rsp,%rdi)
	vmovaps	%ymm1, 41344(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41664(%rsp,%rsi)
	vmovdqa	%ymm0, 41600(%rsp,%rsi)
	vmovdqa	%ymm0, 41696(%rsp,%rsi)
	vmovdqa	%ymm0, 41632(%rsp,%rsi)
	vmovaps	8704(%rsp,%rdi), %ymm1
	vmovaps	8736(%rsp,%rdi), %ymm2
	vmovaps	8768(%rsp,%rdi), %ymm3
	vmovaps	8800(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 41568(%rsp,%rdi)
	vmovaps	%ymm3, 41536(%rsp,%rdi)
	vmovaps	%ymm2, 41504(%rsp,%rdi)
	vmovaps	%ymm1, 41472(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41696(%rsp,%rsi)
	vmovdqa	%ymm0, 41664(%rsp,%rsi)
	vmovdqa	%ymm0, 41632(%rsp,%rsi)
	vmovdqa	%ymm0, 41600(%rsp,%rsi)
	vmovdqa	8832(%rsp,%rdi), %ymm1
	vmovdqa	8864(%rsp,%rdi), %ymm2
	vmovdqa	8896(%rsp,%rdi), %ymm3
	vmovdqa	8928(%rsp,%rdi), %ymm4
	vmovdqa	%ymm4, 41696(%rsp,%rdi)
	vmovdqa	%ymm3, 41664(%rsp,%rdi)
	vmovdqa	%ymm2, 41632(%rsp,%rdi)
	vmovdqa	%ymm1, 41600(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 41696(%rsp,%rbx)
	vmovdqa	%ymm0, 41664(%rsp,%rbx)
	vmovdqa	%ymm0, 41632(%rsp,%rbx)
	vmovdqa	%ymm0, 41600(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB2_54
.LBB2_23:                               # %for_test188.for_test206.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	vmovdqa	416(%rsp), %ymm14       # 32-byte Reload
	vmovdqa	384(%rsp), %ymm15       # 32-byte Reload
	je	.LBB2_26
# %bb.24:                               # %for_loop190.epil.preheader
	movq	64(%rsp), %rdx          # 8-byte Reload
	leal	(%rdx,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_25:                               # %for_loop190.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	8832(%rsp,%rcx), %ymm1
	vmovdqa	8864(%rsp,%rcx), %ymm2
	vmovdqa	8896(%rsp,%rcx), %ymm3
	vmovdqa	8928(%rsp,%rcx), %ymm4
	vmovdqa	%ymm4, 41696(%rsp,%rcx)
	vmovdqa	%ymm3, 41664(%rsp,%rcx)
	vmovdqa	%ymm2, 41632(%rsp,%rcx)
	vmovdqa	%ymm1, 41600(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41696(%rsp,%rsi)
	vmovdqa	%ymm0, 41664(%rsp,%rsi)
	vmovdqa	%ymm0, 41632(%rsp,%rsi)
	vmovdqa	%ymm0, 41600(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB2_25
.LBB2_26:                               # %for_test206.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_6
# %bb.27:                               # %for_loop224.lr.ph.us.preheader
	leaq	21184(%rsp), %r8
	movq	64(%rsp), %rax          # 8-byte Reload
	movl	%eax, %r10d
	subl	%r14d, %r10d
	movl	$1, %edx
	xorl	%esi, %esi
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	movl	%eax, %r9d
	.p2align	4, 0x90
.LBB2_28:                               # %for_loop224.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_46 Depth 2
	movq	%rsi, %rbx
	shlq	$7, %rbx
	vpermd	41664(%rsp,%rbx), %ymm0, %ymm2
	vpermd	41696(%rsp,%rbx), %ymm0, %ymm3
	vpermd	41600(%rsp,%rbx), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	41632(%rsp,%rbx), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	%ymm3, %ymm14, %ymm5
	vpmulld	%ymm2, %ymm15, %ymm3
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	jne	.LBB2_45
# %bb.29:                               #   in Loop: Header=BB2_28 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	jmp	.LBB2_48
	.p2align	4, 0x90
.LBB2_45:                               # %for_loop224.lr.ph.us.new
                                        #   in Loop: Header=BB2_28 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	movq	%r8, %rdi
	xorl	%ecx, %ecx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB2_46:                               # %for_loop224.us
                                        #   Parent Loop BB2_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-16(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm13
	vpmuludq	%ymm4, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	leal	(%rsi,%rcx), %eax
	shlq	$7, %rax
	vpaddq	41600(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	41632(%rsp,%rax), %ymm9, %ymm9
	vpaddq	%ymm12, %ymm9, %ymm9
	vpaddq	41664(%rsp,%rax), %ymm7, %ymm7
	vpaddq	41696(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 41696(%rsp,%rax)
	vmovdqa	%ymm12, 41664(%rsp,%rax)
	vmovdqa	%ymm11, 41632(%rsp,%rax)
	vmovdqa	%ymm10, 41600(%rsp,%rax)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	(%rdi), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm2, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm5, %ymm10, %ymm10
	leal	(%rdx,%rcx), %eax
	shlq	$7, %rax
	vpaddq	41632(%rsp,%rax), %ymm9, %ymm9
	vpaddq	41696(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm12, %ymm6, %ymm6
	vpaddq	41664(%rsp,%rax), %ymm7, %ymm7
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	41600(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm10, %ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vmovdqa	%ymm13, 41600(%rsp,%rax)
	vmovdqa	%ymm12, 41664(%rsp,%rax)
	vmovdqa	%ymm11, 41696(%rsp,%rax)
	vmovdqa	%ymm10, 41632(%rsp,%rax)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %rcx
	subq	$-128, %rdi
	cmpl	%ecx, %r10d
	jne	.LBB2_46
# %bb.47:                               # %for_test222.for_exit225_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_28 Depth=1
	testb	$1, 64(%rsp)            # 1-byte Folded Reload
	je	.LBB2_49
.LBB2_48:                               # %for_loop224.us.epil.preheader
                                        #   in Loop: Header=BB2_28 Depth=1
	movq	%rcx, %rax
	shlq	$6, %rax
	vpmovzxdq	21168(%rsp,%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21152(%rsp,%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21136(%rsp,%rax), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21120(%rsp,%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm5
	vpmuludq	%ymm4, %ymm12, %ymm4
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	addl	%esi, %ecx
	shlq	$7, %rcx
	vpaddq	41600(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	41632(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	41664(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm7, %ymm3
	vpaddq	41696(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm2, %ymm6, %ymm2
	vpblendd	$170, %ymm1, %ymm5, %ymm6 # ymm6 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm9, 41696(%rsp,%rcx)
	vmovdqa	%ymm8, 41664(%rsp,%rcx)
	vmovdqa	%ymm7, 41632(%rsp,%rcx)
	vmovdqa	%ymm6, 41600(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm6
	vpsrlq	$32, %ymm3, %ymm7
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm8
.LBB2_49:                               # %for_exit225.us
                                        #   in Loop: Header=BB2_28 Depth=1
	vmovdqa	%ymm9, 8864(%rsp,%rbx)
	vmovdqa	%ymm8, 8832(%rsp,%rbx)
	vmovdqa	%ymm7, 8896(%rsp,%rbx)
	vmovdqa	%ymm6, 8928(%rsp,%rbx)
	addq	$1, %rsi
	addq	$1, %rdx
	cmpq	%r9, %rsi
	jne	.LBB2_28
# %bb.50:                               # %for_test255.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_6
# %bb.51:                               # %for_loop257.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	jne	.LBB2_55
# %bb.52:
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB2_58
.LBB2_6:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB2_60
.LBB2_119:                              # %for_loop722.lr.ph.new
	movq	64(%rsp), %rcx          # 8-byte Reload
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%ecx, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vxorps	%xmm0, %xmm0, %xmm0
	movq	80(%rsp), %r11          # 8-byte Reload
	movl	92(%rsp), %r14d         # 4-byte Reload
	.p2align	4, 0x90
.LBB2_120:                              # %for_loop722
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	288(%rsp,%rdi), %ymm1
	vmovaps	320(%rsp,%rdi), %ymm2
	vmovaps	352(%rsp,%rdi), %ymm3
	vmovaps	%ymm3, 24928(%rsp,%rdi)
	vmovaps	%ymm2, 24896(%rsp,%rdi)
	vmovaps	%ymm1, 24864(%rsp,%rdi)
	vmovaps	256(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 24832(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25312(%rsp,%rsi)
	vmovaps	%ymm0, 25280(%rsp,%rsi)
	vmovaps	%ymm0, 25248(%rsp,%rsi)
	vmovaps	%ymm0, 25216(%rsp,%rsi)
	vmovaps	384(%rsp,%rdi), %ymm1
	vmovaps	416(%rsp,%rdi), %ymm2
	vmovaps	448(%rsp,%rdi), %ymm3
	vmovaps	480(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 25056(%rsp,%rdi)
	vmovaps	%ymm3, 25024(%rsp,%rdi)
	vmovaps	%ymm2, 24992(%rsp,%rdi)
	vmovaps	%ymm1, 24960(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25280(%rsp,%rsi)
	vmovaps	%ymm0, 25216(%rsp,%rsi)
	vmovaps	%ymm0, 25312(%rsp,%rsi)
	vmovaps	%ymm0, 25248(%rsp,%rsi)
	vmovaps	512(%rsp,%rdi), %ymm1
	vmovaps	544(%rsp,%rdi), %ymm2
	vmovaps	576(%rsp,%rdi), %ymm3
	vmovaps	608(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 25184(%rsp,%rdi)
	vmovaps	%ymm3, 25152(%rsp,%rdi)
	vmovaps	%ymm2, 25120(%rsp,%rdi)
	vmovaps	%ymm1, 25088(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25312(%rsp,%rsi)
	vmovaps	%ymm0, 25280(%rsp,%rsi)
	vmovaps	%ymm0, 25248(%rsp,%rsi)
	vmovaps	%ymm0, 25216(%rsp,%rsi)
	vmovdqa	640(%rsp,%rdi), %ymm1
	vmovdqa	672(%rsp,%rdi), %ymm2
	vmovdqa	704(%rsp,%rdi), %ymm3
	vmovdqa	736(%rsp,%rdi), %ymm4
	vmovdqa	%ymm4, 25312(%rsp,%rdi)
	vmovdqa	%ymm3, 25280(%rsp,%rdi)
	vmovdqa	%ymm2, 25248(%rsp,%rdi)
	vmovdqa	%ymm1, 25216(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovaps	%ymm0, 25312(%rsp,%rbx)
	vmovaps	%ymm0, 25280(%rsp,%rbx)
	vmovaps	%ymm0, 25248(%rsp,%rbx)
	vmovaps	%ymm0, 25216(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB2_120
.LBB2_89:                               # %for_test720.for_test738.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	vmovdqa	352(%rsp), %ymm5        # 32-byte Reload
	vmovdqa	224(%rsp), %ymm6        # 32-byte Reload
	je	.LBB2_92
# %bb.90:                               # %for_loop722.epil.preheader
	movq	64(%rsp), %rdx          # 8-byte Reload
	leal	(%rdx,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_91:                               # %for_loop722.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rcx), %ymm1
	vmovdqa	672(%rsp,%rcx), %ymm2
	vmovdqa	704(%rsp,%rcx), %ymm3
	vmovdqa	736(%rsp,%rcx), %ymm4
	vmovdqa	%ymm4, 25312(%rsp,%rcx)
	vmovdqa	%ymm3, 25280(%rsp,%rcx)
	vmovdqa	%ymm2, 25248(%rsp,%rcx)
	vmovdqa	%ymm1, 25216(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25312(%rsp,%rsi)
	vmovaps	%ymm0, 25280(%rsp,%rsi)
	vmovaps	%ymm0, 25248(%rsp,%rsi)
	vmovaps	%ymm0, 25216(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB2_91
.LBB2_92:                               # %for_test738.preheader
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_2
# %bb.93:                               # %for_loop756.lr.ph.us.preheader
	leaq	17088(%rsp), %r8
	movq	64(%rsp), %rax          # 8-byte Reload
	movl	%eax, %r10d
	subl	%r14d, %r10d
	movl	$1, %edx
	xorl	%esi, %esi
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	movl	%eax, %r9d
	vmovaps	%ymm10, %ymm14
	.p2align	4, 0x90
.LBB2_94:                               # %for_loop756.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_112 Depth 2
	movq	%rsi, %rbx
	shlq	$7, %rbx
	vpermd	25280(%rsp,%rbx), %ymm0, %ymm2
	vpermd	25312(%rsp,%rbx), %ymm0, %ymm3
	vpermd	25216(%rsp,%rbx), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	25248(%rsp,%rbx), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	%ymm5, %ymm3, %ymm5
	vpmulld	%ymm6, %ymm2, %ymm3
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	jne	.LBB2_111
# %bb.95:                               #   in Loop: Header=BB2_94 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	jmp	.LBB2_114
	.p2align	4, 0x90
.LBB2_111:                              # %for_loop756.lr.ph.us.new
                                        #   in Loop: Header=BB2_94 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	movq	%r8, %rdi
	xorl	%ecx, %ecx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB2_112:                              # %for_loop756.us
                                        #   Parent Loop BB2_94 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-16(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm13
	vpmuludq	%ymm4, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	leal	(%rsi,%rcx), %eax
	shlq	$7, %rax
	vpaddq	25216(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	25248(%rsp,%rax), %ymm9, %ymm9
	vpaddq	%ymm12, %ymm9, %ymm9
	vpaddq	25280(%rsp,%rax), %ymm7, %ymm7
	vpaddq	25312(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 25312(%rsp,%rax)
	vmovdqa	%ymm12, 25280(%rsp,%rax)
	vmovdqa	%ymm11, 25248(%rsp,%rax)
	vmovdqa	%ymm10, 25216(%rsp,%rax)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	(%rdi), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm2, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm5, %ymm10, %ymm10
	leal	(%rdx,%rcx), %eax
	shlq	$7, %rax
	vpaddq	25248(%rsp,%rax), %ymm9, %ymm9
	vpaddq	25312(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm12, %ymm6, %ymm6
	vpaddq	25280(%rsp,%rax), %ymm7, %ymm7
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	25216(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm10, %ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vmovdqa	%ymm13, 25216(%rsp,%rax)
	vmovdqa	%ymm12, 25280(%rsp,%rax)
	vmovdqa	%ymm11, 25312(%rsp,%rax)
	vmovdqa	%ymm10, 25248(%rsp,%rax)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %rcx
	subq	$-128, %rdi
	cmpl	%ecx, %r10d
	jne	.LBB2_112
# %bb.113:                              # %for_test754.for_exit757_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_94 Depth=1
	testb	$1, 64(%rsp)            # 1-byte Folded Reload
	je	.LBB2_115
.LBB2_114:                              # %for_loop756.us.epil.preheader
                                        #   in Loop: Header=BB2_94 Depth=1
	movq	%rcx, %rax
	shlq	$6, %rax
	vpmovzxdq	17072(%rsp,%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17056(%rsp,%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17040(%rsp,%rax), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17024(%rsp,%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm5
	vpmuludq	%ymm4, %ymm12, %ymm4
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	addl	%esi, %ecx
	shlq	$7, %rcx
	vpaddq	25216(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	25248(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	25280(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm7, %ymm3
	vpaddq	25312(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm2, %ymm6, %ymm2
	vpblendd	$170, %ymm1, %ymm5, %ymm6 # ymm6 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm9, 25312(%rsp,%rcx)
	vmovdqa	%ymm8, 25280(%rsp,%rcx)
	vmovdqa	%ymm7, 25248(%rsp,%rcx)
	vmovdqa	%ymm6, 25216(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm6
	vpsrlq	$32, %ymm3, %ymm7
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm8
.LBB2_115:                              # %for_exit757.us
                                        #   in Loop: Header=BB2_94 Depth=1
	vmovdqa	%ymm9, 672(%rsp,%rbx)
	vmovdqa	%ymm8, 640(%rsp,%rbx)
	vmovdqa	%ymm7, 704(%rsp,%rbx)
	vmovdqa	%ymm6, 736(%rsp,%rbx)
	addq	$1, %rsi
	addq	$1, %rdx
	cmpq	%r9, %rsi
	vmovdqa	352(%rsp), %ymm5        # 32-byte Reload
	vmovdqa	224(%rsp), %ymm6        # 32-byte Reload
	jne	.LBB2_94
# %bb.116:                              # %for_test787.preheader
	vmovaps	%ymm14, %ymm10
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_2
# %bb.117:                              # %for_loop789.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	jne	.LBB2_121
# %bb.118:
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB2_124
.LBB2_2:                                # %for_test720.preheader.thread
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB2_126
.LBB2_55:                               # %for_loop257.lr.ph.new
	movabsq	$8589934592, %r8        # imm = 0x200000000
	movabsq	$4294967296, %rsi       # imm = 0x100000000
	leaq	8960(%rsp), %rdi
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%ebx, %ebx
	movq	64(%rsp), %rdx          # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_56:                               # %for_loop257
                                        # =>This Inner Loop Header: Depth=1
	movq	%rbx, %rax
	sarq	$25, %rax
	vpaddq	8896(%rsp,%rax), %ymm1, %ymm1
	vpaddq	8864(%rsp,%rax), %ymm5, %ymm5
	vpaddq	8832(%rsp,%rax), %ymm4, %ymm4
	vpaddq	8928(%rsp,%rax), %ymm3, %ymm3
	movl	%edx, %eax
	shlq	$7, %rax
	vpaddq	41696(%rsp,%rax), %ymm3, %ymm3
	vpaddq	41600(%rsp,%rax), %ymm4, %ymm4
	vpaddq	41632(%rsp,%rax), %ymm5, %ymm5
	vpaddq	41664(%rsp,%rax), %ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm9, -32(%rdi)
	vmovdqa	%ymm8, -128(%rdi)
	vmovdqa	%ymm7, -96(%rdi)
	vmovdqa	%ymm6, -64(%rdi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	leaq	(%rbx,%rsi), %rax
	sarq	$25, %rax
	vpaddq	8928(%rsp,%rax), %ymm3, %ymm3
	vpaddq	8832(%rsp,%rax), %ymm4, %ymm4
	vpaddq	8864(%rsp,%rax), %ymm5, %ymm5
	vpaddq	8896(%rsp,%rax), %ymm1, %ymm1
	leal	1(%rdx), %eax
	shlq	$7, %rax
	vpaddq	41664(%rsp,%rax), %ymm1, %ymm1
	vpaddq	41632(%rsp,%rax), %ymm5, %ymm5
	vpaddq	41600(%rsp,%rax), %ymm4, %ymm4
	vpaddq	41696(%rsp,%rax), %ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vmovdqa	%ymm8, 64(%rdi)
	vmovdqa	%ymm7, 32(%rdi)
	vmovdqa	%ymm6, (%rdi)
	vpblendd	$170, %ymm2, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm6, 96(%rdi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	addq	$2, %rcx
	addl	$2, %edx
	addq	$256, %rdi              # imm = 0x100
	addq	%r8, %rbx
	cmpl	%ecx, %r10d
	jne	.LBB2_56
# %bb.57:                               # %for_test255.for_exit258_crit_edge.unr-lcssa
	testl	%r14d, %r14d
	je	.LBB2_59
.LBB2_58:                               # %for_loop257.epil.preheader
	movslq	%ecx, %rax
	movq	%rax, %rdx
	shlq	$7, %rdx
	vpaddq	8832(%rsp,%rdx), %ymm4, %ymm2
	vpaddq	8864(%rsp,%rdx), %ymm5, %ymm4
	vpaddq	8896(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	8928(%rsp,%rdx), %ymm3, %ymm3
	addl	64(%rsp), %eax          # 4-byte Folded Reload
	shlq	$7, %rax
	vpaddq	41696(%rsp,%rax), %ymm3, %ymm3
	vpaddq	41664(%rsp,%rax), %ymm1, %ymm1
	vpaddq	41632(%rsp,%rax), %ymm4, %ymm4
	vpaddq	41600(%rsp,%rax), %ymm2, %ymm2
	shlq	$7, %rcx
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm0 # ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm0, 8928(%rsp,%rcx)
	vmovdqa	%ymm7, 8896(%rsp,%rcx)
	vmovdqa	%ymm6, 8864(%rsp,%rcx)
	vmovdqa	%ymm5, 8832(%rsp,%rcx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm5
	vpsrlq	$32, %ymm2, %ymm4
.LBB2_59:                               # %for_test255.for_exit258_crit_edge
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	%ymm0, %ymm5, %ymm2
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm6
	vpackssdw	%xmm6, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm4, %ymm4
	vpxor	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm4
	vpcmpeqq	%ymm0, %ymm3, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm1, %ymm0
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm5
.LBB2_60:                               # %for_exit258
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_64
# %bb.61:                               # %for_exit258
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_64
# %bb.62:                               # %for_loop292.lr.ph
	movabsq	$4294967296, %rax       # imm = 0x100000000
	movl	76(%rsp), %edx          # 4-byte Reload
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %ecx
	subl	%edx, %ecx
	vmovd	%ecx, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovaps	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm4, %ymm2, %ymm3
	vmovaps	%ymm3, 128(%rsp)        # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm6   # ymm6 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm6, %ymm3
	vmovdqa	%ymm3, 96(%rsp)         # 32-byte Spill
	vpermps	%ymm5, %ymm2, %ymm2
	vmovaps	%ymm2, 192(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 160(%rsp)        # 32-byte Spill
	movl	64(%rsp), %ecx          # 4-byte Reload
	shlq	$7, %rcx
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	xorl	%esi, %esi
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm9, %xmm9, %xmm9
	vxorps	%xmm10, %xmm10, %xmm10
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB2_63:                               # %for_loop292
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	8832(%rsp,%rdx), %ymm15
	vmovdqa	8864(%rsp,%rdx), %ymm2
	movq	%rsi, %rdi
	sarq	$26, %rdi
	vmovdqa	21120(%rsp,%rdi), %ymm13
	vmovdqa	21152(%rsp,%rdi), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm3
	vpor	%ymm12, %ymm3, %ymm3
	vpsllvd	%ymm0, %ymm14, %ymm12
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm3, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm10, %ymm4, %ymm4
	vmovdqa	8896(%rsp,%rdx), %ymm10
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vmovapd	128(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm9, %ymm15, %ymm9
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vmovapd	96(%rsp), %ymm5         # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm2, %ymm2
	vpmovzxdq	%xmm11, %ymm12  # ymm12 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm12, %ymm10, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	192(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm10, %ymm10
	vmovdqa	8928(%rsp,%rdx), %ymm12
	vextracti128	$1, %ymm11, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm12, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm6[1],ymm5[2],ymm6[3],ymm5[4],ymm6[5],ymm5[6],ymm6[7]
	vmovapd	160(%rsp), %ymm11       # 32-byte Reload
	vblendvpd	%ymm11, %ymm7, %ymm12, %ymm7
	vmovapd	%ymm7, 8928(%rsp,%rdx)
	vmovapd	%ymm10, 8896(%rsp,%rdx)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm2, 8864(%rsp,%rdx)
	vmovapd	%ymm9, 8832(%rsp,%rdx)
	vpsrad	$31, %ymm5, %ymm2
	vpshufd	$245, %ymm5, %ymm5      # ymm5 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpsrad	$31, %ymm8, %ymm2
	vpshufd	$245, %ymm8, %ymm5      # ymm5 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpsrad	$31, %ymm4, %ymm2
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpsrad	$31, %ymm3, %ymm2
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	addq	%rax, %rsi
	subq	$-128, %rdx
	cmpq	%rdx, %rcx
	jne	.LBB2_63
.LBB2_64:                               # %safe_if_after_true
	movq	64(%rsp), %rax          # 8-byte Reload
	leal	-1(%rax), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	8928(%rsp,%rax), %ymm0, %ymm1
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpcmpeqq	8896(%rsp,%rax), %ymm0, %ymm4
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpxor	%ymm2, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vinserti128	$1, %xmm1, %ymm3, %ymm3
	vpcmpeqq	8864(%rsp,%rax), %ymm0, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpcmpeqq	8832(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm4
	vpackssdw	%xmm4, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm1
	vmovmskps	%ymm1, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovaps	%ymm3, 128(%rsp)        # 32-byte Spill
	vmovaps	%ymm1, 96(%rsp)         # 32-byte Spill
	je	.LBB2_65
# %bb.72:                               # %for_test349.preheader
	movq	64(%rsp), %rax          # 8-byte Reload
                                        # kill: def $eax killed $eax killed $rax
	negl	%eax
	sbbl	%eax, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	%ymm3, %ymm0, %ymm5
	vpand	%ymm1, %ymm0, %ymm6
	vmovmskps	%ymm6, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_65
# %bb.73:                               # %for_loop351.preheader
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vbroadcastss	.LCPI2_5(%rip), %ymm11 # ymm11 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vpbroadcastd	.LCPI2_5(%rip), %ymm15 # ymm15 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	xorl	%eax, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	vmovdqa	%ymm15, %ymm9
	vmovdqa	%ymm15, %ymm10
	vmovaps	%ymm11, %ymm12
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	.p2align	4, 0x90
.LBB2_74:                               # %for_loop351
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	21120(%rsp,%rdx), %ymm9, %ymm13
	vpaddd	21152(%rsp,%rdx), %ymm10, %ymm14
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpmaxud	21152(%rsp,%rdx), %ymm14, %ymm9
	vpcmpeqd	%ymm9, %ymm14, %ymm9
	vpandn	%ymm15, %ymm9, %ymm10
	vpmaxud	21120(%rsp,%rdx), %ymm13, %ymm9
	vpcmpeqd	%ymm9, %ymm13, %ymm9
	vpandn	%ymm15, %ymm9, %ymm9
	vblendvps	%ymm6, %ymm9, %ymm11, %ymm9
	vblendvps	%ymm5, %ymm10, %ymm12, %ymm10
	shlq	$7, %rcx
	vpmovzxdq	%xmm14, %ymm11  # ymm11 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm13, %ymm12  # ymm12 = xmm13[0],zero,xmm13[1],zero,xmm13[2],zero,xmm13[3],zero
	vextracti128	$1, %ymm13, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpcmpeqq	8864(%rsp,%rcx), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	8832(%rsp,%rcx), %ymm12, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpcmpeqq	8928(%rsp,%rcx), %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm4
	vpackssdw	%xmm4, %xmm2, %xmm2
	vpcmpeqq	8896(%rsp,%rcx), %ymm11, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm2
	vpandn	%ymm5, %ymm2, %ymm2
	vpandn	%ymm6, %ymm3, %ymm3
	vblendvps	%ymm3, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	64(%rsp), %eax          # 4-byte Folded Reload
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpand	%ymm2, %ymm5, %ymm3
	vandps	%ymm3, %ymm1, %ymm5
	vpand	%ymm2, %ymm6, %ymm2
	vandps	%ymm2, %ymm0, %ymm6
	vmovmskps	%ymm6, %ecx
	vmovmskps	%ymm5, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	vmovaps	%ymm9, %ymm11
	vmovaps	%ymm10, %ymm12
	jne	.LBB2_74
	jmp	.LBB2_66
.LBB2_65:
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
.LBB2_66:                               # %safe_if_after_true341
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	96(%rsp), %ymm2, %ymm4  # 32-byte Folded Reload
	vpxor	128(%rsp), %ymm2, %ymm2 # 32-byte Folded Reload
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_70
# %bb.67:                               # %safe_if_run_false407
	vpbroadcastq	.LCPI2_6(%rip), %ymm3 # ymm3 = [1,1,1,1]
	vpcmpeqq	8928(%rsp), %ymm3, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	8896(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	8864(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	8832(%rsp), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm7
	vpackssdw	%xmm7, %xmm3, %xmm3
	vinserti128	$1, %xmm6, %ymm3, %ymm3
	vblendvps	%ymm4, %ymm3, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm5, %ymm1, %ymm1
	xorl	%eax, %eax
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	seta	%al
	negl	%eax
	vmovd	%eax, %xmm3
	vpbroadcastd	%xmm3, %ymm3
	vandps	%ymm0, %ymm4, %ymm4
	vandps	%ymm1, %ymm2, %ymm2
	vandps	%ymm3, %ymm2, %ymm2
	vandps	%ymm3, %ymm4, %ymm3
	vmovmskps	%ymm3, %eax
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_70
# %bb.68:                               # %for_loop419.preheader
	movl	$1, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB2_69:                               # %for_loop419
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	8864(%rsp,%rcx), %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	8832(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	8928(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	8896(%rsp,%rcx), %ymm8, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vinserti128	$1, %xmm6, %ymm4, %ymm4
	vpandn	%ymm2, %ymm4, %ymm4
	vpandn	%ymm3, %ymm5, %ymm5
	vblendvps	%ymm5, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm4, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	64(%rsp), %eax          # 4-byte Folded Reload
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpand	%ymm4, %ymm2, %ymm2
	vandps	%ymm2, %ymm1, %ymm2
	vpand	%ymm4, %ymm3, %ymm3
	vandps	%ymm3, %ymm0, %ymm3
	vmovmskps	%ymm3, %ecx
	vmovmskps	%ymm2, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	jne	.LBB2_69
.LBB2_70:                               # %if_done340
	vbroadcastss	.LCPI2_5(%rip), %ymm2 # ymm2 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vandps	%ymm2, %ymm1, %ymm1
	vandps	%ymm2, %ymm0, %ymm0
	vmovups	%ymm0, (%r11)
	vmovups	%ymm1, 32(%r11)
	jmp	.LBB2_71
.LBB2_121:                              # %for_loop789.lr.ph.new
	movabsq	$8589934592, %r8        # imm = 0x200000000
	movabsq	$4294967296, %rsi       # imm = 0x100000000
	leaq	768(%rsp), %rdi
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%ebx, %ebx
	movq	64(%rsp), %rdx          # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_122:                              # %for_loop789
                                        # =>This Inner Loop Header: Depth=1
	movq	%rbx, %rax
	sarq	$25, %rax
	vpaddq	704(%rsp,%rax), %ymm1, %ymm1
	vpaddq	672(%rsp,%rax), %ymm5, %ymm5
	vpaddq	640(%rsp,%rax), %ymm4, %ymm4
	vpaddq	736(%rsp,%rax), %ymm3, %ymm3
	movl	%edx, %eax
	shlq	$7, %rax
	vpaddq	25312(%rsp,%rax), %ymm3, %ymm3
	vpaddq	25216(%rsp,%rax), %ymm4, %ymm4
	vpaddq	25248(%rsp,%rax), %ymm5, %ymm5
	vpaddq	25280(%rsp,%rax), %ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm9, -32(%rdi)
	vmovdqa	%ymm8, -128(%rdi)
	vmovdqa	%ymm7, -96(%rdi)
	vmovdqa	%ymm6, -64(%rdi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	leaq	(%rbx,%rsi), %rax
	sarq	$25, %rax
	vpaddq	736(%rsp,%rax), %ymm3, %ymm3
	vpaddq	640(%rsp,%rax), %ymm4, %ymm4
	vpaddq	672(%rsp,%rax), %ymm5, %ymm5
	vpaddq	704(%rsp,%rax), %ymm1, %ymm1
	leal	1(%rdx), %eax
	shlq	$7, %rax
	vpaddq	25280(%rsp,%rax), %ymm1, %ymm1
	vpaddq	25248(%rsp,%rax), %ymm5, %ymm5
	vpaddq	25216(%rsp,%rax), %ymm4, %ymm4
	vpaddq	25312(%rsp,%rax), %ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vmovdqa	%ymm8, 64(%rdi)
	vmovdqa	%ymm7, 32(%rdi)
	vmovdqa	%ymm6, (%rdi)
	vpblendd	$170, %ymm2, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm6, 96(%rdi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	addq	$2, %rcx
	addl	$2, %edx
	addq	$256, %rdi              # imm = 0x100
	addq	%r8, %rbx
	cmpl	%ecx, %r10d
	jne	.LBB2_122
# %bb.123:                              # %for_test787.for_exit790_crit_edge.unr-lcssa
	testl	%r14d, %r14d
	je	.LBB2_125
.LBB2_124:                              # %for_loop789.epil.preheader
	movslq	%ecx, %rax
	movq	%rax, %rdx
	shlq	$7, %rdx
	vpaddq	640(%rsp,%rdx), %ymm4, %ymm2
	vpaddq	672(%rsp,%rdx), %ymm5, %ymm4
	vpaddq	704(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	736(%rsp,%rdx), %ymm3, %ymm3
	addl	64(%rsp), %eax          # 4-byte Folded Reload
	shlq	$7, %rax
	vpaddq	25312(%rsp,%rax), %ymm3, %ymm3
	vpaddq	25280(%rsp,%rax), %ymm1, %ymm1
	vpaddq	25248(%rsp,%rax), %ymm4, %ymm4
	vpaddq	25216(%rsp,%rax), %ymm2, %ymm2
	shlq	$7, %rcx
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm0 # ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm0, 736(%rsp,%rcx)
	vmovdqa	%ymm7, 704(%rsp,%rcx)
	vmovdqa	%ymm6, 672(%rsp,%rcx)
	vmovdqa	%ymm5, 640(%rsp,%rcx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm5
	vpsrlq	$32, %ymm2, %ymm4
.LBB2_125:                              # %for_test787.for_exit790_crit_edge
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	%ymm0, %ymm5, %ymm2
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm6
	vpackssdw	%xmm6, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm4, %ymm4
	vpxor	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm4
	vpcmpeqq	%ymm0, %ymm3, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm1, %ymm0
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm5
.LBB2_126:                              # %for_exit790
	vmovaps	%ymm15, 320(%rsp)       # 32-byte Spill
	vpand	%ymm15, %ymm4, %ymm0
	vmovmskps	%ymm0, %eax
	vmovaps	%ymm10, 256(%rsp)       # 32-byte Spill
	vpand	%ymm10, %ymm5, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_130
# %bb.127:                              # %for_exit790
	cmpl	$0, 64(%rsp)            # 4-byte Folded Reload
	je	.LBB2_130
# %bb.128:                              # %for_loop827.lr.ph
	movabsq	$4294967296, %rax       # imm = 0x100000000
	movl	76(%rsp), %edx          # 4-byte Reload
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %ecx
	subl	%edx, %ecx
	vmovd	%ecx, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm4, %ymm2, %ymm3
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm6   # ymm6 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm6, %ymm3
	vmovdqa	%ymm3, 96(%rsp)         # 32-byte Spill
	vpermd	%ymm5, %ymm2, %ymm2
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 160(%rsp)        # 32-byte Spill
	movl	64(%rsp), %ecx          # 4-byte Reload
	shlq	$7, %rcx
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	xorl	%esi, %esi
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB2_129:                              # %for_loop827
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rdx), %ymm15
	vmovdqa	672(%rsp,%rdx), %ymm2
	movq	%rsi, %rdi
	sarq	$26, %rdi
	vmovdqa	17024(%rsp,%rdi), %ymm13
	vmovdqa	17056(%rsp,%rdi), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm3
	vpor	%ymm12, %ymm3, %ymm3
	vpsllvd	%ymm0, %ymm14, %ymm12
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm3, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm10, %ymm4, %ymm4
	vmovdqa	704(%rsp,%rdx), %ymm10
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vmovapd	128(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm9, %ymm15, %ymm9
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vmovapd	96(%rsp), %ymm5         # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm2, %ymm2
	vpmovzxdq	%xmm11, %ymm12  # ymm12 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm12, %ymm10, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	192(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm10, %ymm10
	vmovdqa	736(%rsp,%rdx), %ymm12
	vextracti128	$1, %ymm11, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm12, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm6[1],ymm5[2],ymm6[3],ymm5[4],ymm6[5],ymm5[6],ymm6[7]
	vmovapd	160(%rsp), %ymm11       # 32-byte Reload
	vblendvpd	%ymm11, %ymm7, %ymm12, %ymm7
	vmovapd	%ymm7, 736(%rsp,%rdx)
	vmovapd	%ymm10, 704(%rsp,%rdx)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm2, 672(%rsp,%rdx)
	vmovapd	%ymm9, 640(%rsp,%rdx)
	vpsrad	$31, %ymm5, %ymm2
	vpshufd	$245, %ymm5, %ymm5      # ymm5 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpsrad	$31, %ymm8, %ymm2
	vpshufd	$245, %ymm8, %ymm5      # ymm5 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpsrad	$31, %ymm4, %ymm2
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpsrad	$31, %ymm3, %ymm2
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	addq	%rax, %rsi
	subq	$-128, %rdx
	cmpq	%rdx, %rcx
	jne	.LBB2_129
.LBB2_130:                              # %safe_if_after_true816
	movq	64(%rsp), %rax          # 8-byte Reload
	leal	-1(%rax), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	736(%rsp,%rax), %ymm0, %ymm1
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpcmpeqq	704(%rsp,%rax), %ymm0, %ymm3
	vpxor	%ymm2, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	672(%rsp,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm1, %ymm3, %ymm3
	vpxor	%ymm2, %ymm4, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpcmpeqq	640(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm4
	vpackssdw	%xmm4, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm1
	vmovdqa	320(%rsp), %ymm8        # 32-byte Reload
	vpand	%ymm8, %ymm1, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	256(%rsp), %ymm14       # 32-byte Reload
	vpand	%ymm14, %ymm3, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 96(%rsp)         # 32-byte Spill
	je	.LBB2_131
# %bb.134:                              # %for_test888.preheader
	movq	64(%rsp), %rax          # 8-byte Reload
                                        # kill: def $eax killed $eax killed $rax
	negl	%eax
	sbbl	%eax, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	%ymm3, %ymm0, %ymm5
	vpand	%ymm1, %ymm0, %ymm6
	vpand	%ymm8, %ymm6, %ymm0
	vmovmskps	%ymm0, %eax
	vpand	%ymm14, %ymm5, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_131
# %bb.135:                              # %for_loop890.preheader
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vbroadcastss	.LCPI2_5(%rip), %ymm11 # ymm11 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vpbroadcastd	.LCPI2_5(%rip), %ymm15 # ymm15 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	xorl	%eax, %eax
	vmovdqa	%ymm15, %ymm9
	vmovdqa	%ymm15, %ymm10
	vmovaps	%ymm11, %ymm12
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	.p2align	4, 0x90
.LBB2_136:                              # %for_loop890
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	17024(%rsp,%rdx), %ymm9, %ymm13
	vpaddd	17056(%rsp,%rdx), %ymm10, %ymm14
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpmaxud	17056(%rsp,%rdx), %ymm14, %ymm9
	vpcmpeqd	%ymm9, %ymm14, %ymm10
	vpmaxud	17024(%rsp,%rdx), %ymm13, %ymm9
	vpcmpeqd	%ymm9, %ymm13, %ymm9
	vpandn	%ymm15, %ymm9, %ymm9
	vblendvps	%ymm6, %ymm9, %ymm11, %ymm9
	vpandn	%ymm15, %ymm10, %ymm10
	vblendvps	%ymm5, %ymm10, %ymm12, %ymm10
	shlq	$7, %rcx
	vpmovzxdq	%xmm14, %ymm11  # ymm11 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm2
	vmovaps	256(%rsp), %ymm14       # 32-byte Reload
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm13, %ymm12  # ymm12 = xmm13[0],zero,xmm13[1],zero,xmm13[2],zero,xmm13[3],zero
	vextracti128	$1, %ymm13, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpcmpeqq	672(%rsp,%rcx), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	640(%rsp,%rcx), %ymm12, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vpcmpeqq	736(%rsp,%rcx), %ymm2, %ymm2
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vextracti128	$1, %ymm2, %xmm4
	vpcmpeqq	704(%rsp,%rcx), %ymm11, %ymm7
	vpackssdw	%xmm4, %xmm2, %xmm2
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm2
	vpandn	%ymm5, %ymm2, %ymm2
	vpandn	%ymm6, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vblendvps	%ymm3, %ymm4, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm4, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	64(%rsp), %eax          # 4-byte Folded Reload
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpand	%ymm2, %ymm5, %ymm3
	vandps	%ymm3, %ymm1, %ymm5
	vpand	%ymm2, %ymm6, %ymm2
	vandps	%ymm2, %ymm0, %ymm6
	vandps	%ymm8, %ymm6, %ymm2
	vmovmskps	%ymm2, %ecx
	vandps	%ymm14, %ymm5, %ymm2
	vmovmskps	%ymm2, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	vmovaps	%ymm9, %ymm11
	vmovaps	%ymm10, %ymm12
	jne	.LBB2_136
	jmp	.LBB2_132
.LBB2_131:
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
.LBB2_132:                              # %safe_if_after_true880
	vmovaps	96(%rsp), %ymm4         # 32-byte Reload
	vandnps	%ymm8, %ymm4, %ymm5
	vmovmskps	%ymm5, %eax
	vmovdqa	128(%rsp), %ymm3        # 32-byte Reload
	vpandn	%ymm14, %ymm3, %ymm5
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovaps	%ymm8, %ymm9
	je	.LBB2_133
# %bb.137:                              # %safe_if_run_false952
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vxorps	%ymm2, %ymm4, %ymm4
	vpxor	%ymm2, %ymm3, %ymm2
	vpbroadcastq	.LCPI2_6(%rip), %ymm3 # ymm3 = [1,1,1,1]
	vpcmpeqq	736(%rsp), %ymm3, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	704(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	672(%rsp), %ymm3, %ymm7
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vextracti128	$1, %ymm7, %xmm6
	vpcmpeqq	640(%rsp), %ymm3, %ymm3
	vpackssdw	%xmm6, %xmm7, %xmm6
	vextracti128	$1, %ymm3, %xmm7
	vpackssdw	%xmm7, %xmm3, %xmm3
	vinserti128	$1, %xmm6, %ymm3, %ymm3
	vblendvps	%ymm4, %ymm3, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm5, %ymm1, %ymm1
	xorl	%eax, %eax
	cmpl	$1, 64(%rsp)            # 4-byte Folded Reload
	seta	%al
	negl	%eax
	vmovd	%eax, %xmm3
	vpbroadcastd	%xmm3, %ymm3
	vandps	%ymm0, %ymm4, %ymm4
	vandps	%ymm1, %ymm2, %ymm2
	vandps	%ymm3, %ymm2, %ymm2
	vandps	%ymm3, %ymm4, %ymm3
	vandps	%ymm9, %ymm3, %ymm4
	vmovmskps	%ymm4, %eax
	vandps	%ymm14, %ymm2, %ymm4
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_133
# %bb.138:                              # %for_loop964.preheader
	movl	$1, %eax
	vxorps	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_139:                              # %for_loop964
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	672(%rsp,%rcx), %ymm4, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	640(%rsp,%rcx), %ymm4, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	736(%rsp,%rcx), %ymm4, %ymm7
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vextracti128	$1, %ymm7, %xmm6
	vpcmpeqq	704(%rsp,%rcx), %ymm4, %ymm8
	vpackssdw	%xmm6, %xmm7, %xmm6
	vextracti128	$1, %ymm8, %xmm7
	vpackssdw	%xmm7, %xmm8, %xmm7
	vinserti128	$1, %xmm6, %ymm7, %ymm6
	vpandn	%ymm2, %ymm6, %ymm6
	vpandn	%ymm3, %ymm5, %ymm5
	vblendvps	%ymm5, %ymm4, %ymm0, %ymm0
	vblendvps	%ymm6, %ymm4, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	64(%rsp), %eax          # 4-byte Folded Reload
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpand	%ymm5, %ymm2, %ymm2
	vandps	%ymm2, %ymm1, %ymm2
	vpand	%ymm5, %ymm3, %ymm3
	vandps	%ymm3, %ymm0, %ymm3
	vandps	%ymm9, %ymm3, %ymm5
	vmovmskps	%ymm5, %ecx
	vandps	%ymm14, %ymm2, %ymm5
	vmovmskps	%ymm5, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	jne	.LBB2_139
.LBB2_133:                              # %if_done879
	vbroadcastss	.LCPI2_5(%rip), %ymm2 # ymm2 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vandps	%ymm2, %ymm0, %ymm0
	vandps	%ymm2, %ymm1, %ymm1
	vmaskmovps	%ymm0, %ymm9, (%r11)
	vmaskmovps	%ymm1, %ymm14, 32(%r11)
.LBB2_71:                               # %if_done340
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end2:
	.size	fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu, .Lfunc_end2-fermat_test___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function fermat_test
.LCPI3_0:
	.long	8                       # 0x8
	.long	9                       # 0x9
	.long	10                      # 0xa
	.long	11                      # 0xb
	.long	12                      # 0xc
	.long	13                      # 0xd
	.long	14                      # 0xe
	.long	15                      # 0xf
.LCPI3_1:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI3_2:
	.long	0                       # 0x0
	.long	2                       # 0x2
	.long	4                       # 0x4
	.long	6                       # 0x6
	.long	4                       # 0x4
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI3_3:
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	3                       # 0x3
.LCPI3_4:
	.long	4                       # 0x4
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
	.long	7                       # 0x7
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2
.LCPI3_5:
	.long	1                       # float 1.40129846E-45
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI3_6:
	.quad	1                       # 0x1
	.text
	.globl	fermat_test
	.p2align	4, 0x90
	.type	fermat_test,@function
fermat_test:                            # @fermat_test
# %bb.0:                                # %allocas
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-128, %rsp
	subq	$45696, %rsp            # imm = 0xB280
	movl	%r9d, 36(%rsp)          # 4-byte Spill
	movl	%r8d, %r13d
	movq	%rcx, %r11
	testl	%r8d, %r8d
	je	.LBB3_1
# %bb.2:                                # %for_loop.lr.ph
	vmovd	%r13d, %xmm0
	vpbroadcastd	%xmm0, %ymm1
	vpmulld	.LCPI3_0(%rip), %ymm1, %ymm0
	vpmulld	.LCPI3_1(%rip), %ymm1, %ymm1
	movl	%r13d, %r9d
	andl	$1, %r9d
	cmpl	$1, %r13d
	movq	%r11, 40(%rsp)          # 8-byte Spill
	movl	%r9d, 32(%rsp)          # 4-byte Spill
	jne	.LBB3_4
# %bb.3:
	xorl	%eax, %eax
	jmp	.LBB3_7
.LBB3_4:                                # %for_loop.lr.ph.new
	movl	%r13d, %r8d
	subl	%r9d, %r8d
	movl	$64, %ebx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB3_5:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vpslld	$2, %ymm2, %ymm2
	vpslld	$2, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm3), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm2), %ymm5
	vmovdqa	%ymm5, 8672(%rsp,%rbx)
	vmovdqa	%ymm4, 8640(%rsp,%rbx)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm3), %ymm4
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm2), %ymm3
	vpmovzxdq	%xmm4, %ymm2    # ymm2 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 448(%rsp,%rbx,2)
	leal	1(%rax), %ecx
	vmovd	%ecx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vmovdqa	%ymm2, 384(%rsp,%rbx,2)
	vpaddd	%ymm1, %ymm5, %ymm2
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovdqa	%ymm3, 480(%rsp,%rbx,2)
	vpslld	$2, %ymm5, %ymm3
	vpslld	$2, %ymm2, %ymm2
	vmovdqa	%ymm4, 416(%rsp,%rbx,2)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm2), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm3), %ymm5
	vmovdqa	%ymm5, 8736(%rsp,%rbx)
	vmovdqa	%ymm4, 8704(%rsp,%rbx)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm2), %ymm4
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm3), %ymm2
	vpmovzxdq	%xmm4, %ymm3    # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm2, %ymm5    # ymm5 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vmovdqa	%ymm5, 576(%rsp,%rbx,2)
	vmovdqa	%ymm2, 608(%rsp,%rbx,2)
	vmovdqa	%ymm3, 512(%rsp,%rbx,2)
	vmovdqa	%ymm4, 544(%rsp,%rbx,2)
	addq	$2, %rax
	subq	$-128, %rbx
	cmpl	%eax, %r8d
	jne	.LBB3_5
# %bb.6:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB3_8
.LBB3_7:                                # %for_loop.epil.preheader
	movq	%rax, %rcx
	shlq	$6, %rcx
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vpaddd	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm0, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpgatherdd	%ymm3, (%rdi,%ymm1), %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpgatherdd	%ymm4, (%rdi,%ymm0), %ymm3
	vmovdqa	%ymm3, 8736(%rsp,%rcx)
	vmovdqa	%ymm2, 8704(%rsp,%rcx)
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpgatherdd	%ymm3, (%rdx,%ymm1), %ymm2
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm1, (%rdx,%ymm0), %ymm3
	shlq	$7, %rax
	vpmovzxdq	%xmm2, %ymm0    # ymm0 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpmovzxdq	%xmm3, %ymm2    # ymm2 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm3, 608(%rsp,%rax)
	vmovdqa	%ymm2, 576(%rsp,%rax)
	vmovdqa	%ymm1, 544(%rsp,%rax)
	vmovdqa	%ymm0, 512(%rsp,%rax)
.LBB3_8:                                # %for_exit
	vmovups	(%rsi), %ymm0
	vmovaps	%ymm0, 224(%rsp)        # 32-byte Spill
	vmovdqu	32(%rsi), %ymm0
	vmovdqa	%ymm0, 192(%rsp)        # 32-byte Spill
	testl	%r13d, %r13d
	jle	.LBB3_14
# %bb.9:                                # %for_loop34.lr.ph
	movabsq	$4294967296, %r15       # imm = 0x100000000
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	36(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %r8d
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm6
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm5
	movslq	%r13d, %rcx
	leaq	8768(%rsp), %r9
	movl	%r13d, %r14d
	subl	32(%rsp), %r14d         # 4-byte Folded Reload
	movl	%r13d, %r12d
	leaq	512(%rsp), %rsi
	vmovdqa	%ymm6, 128(%rsp)        # 32-byte Spill
	vmovdqa	%ymm5, 96(%rsp)         # 32-byte Spill
	movq	%r13, 56(%rsp)          # 8-byte Spill
	.p2align	4, 0x90
.LBB3_10:                               # %for_loop34
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_37 Depth 2
                                        #       Child Loop BB3_38 Depth 3
                                        #         Child Loop BB3_26 Depth 4
                                        #       Child Loop BB3_31 Depth 3
                                        #       Child Loop BB3_33 Depth 3
                                        #         Child Loop BB3_34 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 48(%rsp)          # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB3_12
# %bb.11:                               # %for_loop34
                                        #   in Loop: Header=BB3_10 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB3_12:                               # %for_loop34
                                        #   in Loop: Header=BB3_10 Depth=1
	vpaddd	8736(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 288(%rsp)        # 32-byte Spill
	vpaddd	8704(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 256(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB3_37:                               # %for_loop51.lr.ph.split.us
                                        #   Parent Loop BB3_10 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_38 Depth 3
                                        #         Child Loop BB3_26 Depth 4
                                        #       Child Loop BB3_31 Depth 3
                                        #       Child Loop BB3_33 Depth 3
                                        #         Child Loop BB3_34 Depth 4
	leaq	29184(%rsp), %rdi
	movl	%r13d, %edx
	movl	%r8d, %ebx
	movq	%r9, %r13
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	vpxor	%xmm15, %xmm15, %xmm15
	movq	%r13, %r9
	movq	56(%rsp), %r13          # 8-byte Reload
	movl	%ebx, %r8d
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa	224(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	192(%rsp), %ymm13       # 32-byte Reload
	vmovdqa	.LCPI3_2(%rip), %ymm14  # ymm14 = [0,2,4,6,4,6,6,7]
	.p2align	4, 0x90
.LBB3_38:                               # %for_loop62.lr.ph.us
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_37 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_26 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpermd	29248(%rsp,%rdx), %ymm14, %ymm0
	vpermd	29280(%rsp,%rdx), %ymm14, %ymm1
	vpermd	29184(%rsp,%rdx), %ymm14, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	29216(%rsp,%rdx), %ymm14, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	%ymm1, %ymm12, %ymm3
	vpmulld	%ymm0, %ymm13, %ymm1
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpxor	%xmm5, %xmm5, %xmm5
	cmpl	$1, %r13d
	jne	.LBB3_25
# %bb.39:                               #   in Loop: Header=BB3_38 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	jmp	.LBB3_28
	.p2align	4, 0x90
.LBB3_25:                               # %for_loop62.lr.ph.us.new
                                        #   in Loop: Header=BB3_38 Depth=3
	movq	%r9, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB3_26:                               # %for_loop62.us
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_37 Depth=2
                                        #       Parent Loop BB3_38 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-16(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	vpmuludq	%ymm1, %ymm9, %ymm9
	vpmuludq	%ymm0, %ymm8, %ymm8
	leal	(%rcx,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	29184(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	29216(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	29248(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	29280(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm4, %ymm4
	vpblendd	$170, %ymm15, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vmovdqa	%ymm11, 29280(%rsp,%rbx)
	vmovdqa	%ymm10, 29248(%rsp,%rbx)
	vmovdqa	%ymm9, 29216(%rsp,%rbx)
	vmovdqa	%ymm8, 29184(%rsp,%rbx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm7, %ymm7
	vpmovzxdq	(%rdi), %ymm8   # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm0, %ymm10, %ymm10
	vpmuludq	%ymm1, %ymm9, %ymm9
	vpmuludq	%ymm3, %ymm8, %ymm8
	leal	(%rax,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	29216(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	29280(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpaddq	29248(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	29184(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm8, %ymm5, %ymm5
	vpblendd	$170, %ymm15, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 29184(%rsp,%rbx)
	vmovdqa	%ymm10, 29248(%rsp,%rbx)
	vmovdqa	%ymm9, 29280(%rsp,%rbx)
	vmovdqa	%ymm8, 29216(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r14d
	jne	.LBB3_26
# %bb.27:                               # %for_test60.for_exit63_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_38 Depth=3
	testb	$1, %r13b
	je	.LBB3_29
.LBB3_28:                               # %for_loop62.us.epil.preheader
                                        #   in Loop: Header=BB3_38 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	8752(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8736(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8720(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8704(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	vpmuludq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29184(%rsp,%rsi), %ymm5, %ymm5
	vpaddq	29216(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm5, %ymm3
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	29248(%rsp,%rsi), %ymm6, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpaddq	29280(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpblendd	$170, %ymm15, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqa	%ymm7, 29280(%rsp,%rsi)
	vmovdqa	%ymm6, 29248(%rsp,%rsi)
	vmovdqa	%ymm5, 29216(%rsp,%rsi)
	vmovdqa	%ymm4, 29184(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm4
	vpsrlq	$32, %ymm1, %ymm6
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm5
.LBB3_29:                               # %for_exit63.us
                                        #   in Loop: Header=BB3_38 Depth=3
	vmovdqa	%ymm7, 544(%rsp,%rdx)
	vmovdqa	%ymm5, 512(%rsp,%rdx)
	vmovdqa	%ymm6, 576(%rsp,%rdx)
	vmovdqa	%ymm4, 608(%rsp,%rdx)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r12, %rcx
	jne	.LBB3_38
# %bb.30:                               # %for_loop92.lr.ph
                                        #   in Loop: Header=BB3_37 Depth=2
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	256(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	288(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpxor	%xmm11, %xmm11, %xmm11
	vpcmpeqd	%ymm11, %ymm0, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm11, %ymm1, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI3_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI3_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	xorl	%eax, %eax
	leaq	512(%rsp), %rsi
	movq	%rsi, %rcx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm12, %xmm12, %xmm12
	.p2align	4, 0x90
.LBB3_31:                               # %for_loop92
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_37 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	leal	(%rax,%r13), %edi
	movslq	%edi, %rdi
	shlq	$7, %rdi
	vmovdqa	29184(%rsp,%rdi), %ymm0
	vmovdqa	29216(%rsp,%rdi), %ymm1
	vmovdqa	29248(%rsp,%rdi), %ymm8
	vmovdqa	29280(%rsp,%rdi), %ymm9
	vpaddq	512(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	544(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	576(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	608(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	%ymm0, %ymm0, %ymm10
	vblendvpd	%ymm4, %ymm10, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm10
	vblendvpd	%ymm5, %ymm10, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm8, %ymm10
	vblendvpd	%ymm6, %ymm10, %ymm8, %ymm8
	vpaddq	%ymm9, %ymm9, %ymm10
	vblendvpd	%ymm7, %ymm10, %ymm9, %ymm9
	vpaddq	%ymm9, %ymm12, %ymm3
	vpblendd	$170, %ymm15, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vmovdqa	%ymm9, 96(%rcx)
	vpaddq	%ymm8, %ymm14, %ymm2
	vpblendd	$170, %ymm15, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vmovdqa	%ymm8, 64(%rcx)
	vpaddq	%ymm1, %ymm13, %ymm1
	vpblendd	$170, %ymm15, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm8, 32(%rcx)
	vpaddq	%ymm0, %ymm11, %ymm0
	vpblendd	$170, %ymm15, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqa	%ymm8, (%rcx)
	vpsrlq	$32, %ymm3, %ymm12
	vpsrlq	$32, %ymm2, %ymm14
	vpsrlq	$32, %ymm1, %ymm13
	vpsrlq	$32, %ymm0, %ymm11
	addl	$1, %eax
	subq	$-128, %rcx
	cmpl	%eax, %r13d
	jne	.LBB3_31
# %bb.32:                               # %for_test126.preheader
                                        #   in Loop: Header=BB3_37 Depth=2
	vpcmpeqq	%ymm15, %ymm12, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm14, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm3
	vpcmpeqq	%ymm15, %ymm13, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm11, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	128(%rsp), %ymm6        # 32-byte Reload
	je	.LBB3_36
	.p2align	4, 0x90
.LBB3_33:                               # %for_loop142.lr.ph
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_37 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_34 Depth 4
	vmovdqa	%ymm12, 384(%rsp)       # 32-byte Spill
	vmovdqa	%ymm14, 416(%rsp)       # 32-byte Spill
	vmovdqa	%ymm13, 448(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 480(%rsp)       # 32-byte Spill
	vmovaps	.LCPI3_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm2, %ymm0, %ymm1
	vmovaps	%ymm1, 64(%rsp)         # 32-byte Spill
	vmovaps	.LCPI3_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovaps	%ymm2, 320(%rsp)        # 32-byte Spill
	vpermps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm2, 160(%rsp)        # 32-byte Spill
	vpermps	%ymm3, %ymm0, %ymm8
	vmovaps	%ymm3, 352(%rsp)        # 32-byte Spill
	vpermps	%ymm3, %ymm1, %ymm9
	vpxor	%xmm12, %xmm12, %xmm12
	movq	%r12, %rax
	movq	%rsi, %rcx
	movl	$0, %edx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB3_34:                               # %for_loop142
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_37 Depth=2
                                        #       Parent Loop BB3_33 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	(%rcx), %ymm0
	vmovdqa	32(%rcx), %ymm1
	movq	%rdx, %rdi
	sarq	$26, %rdi
	vmovdqa	8704(%rsp,%rdi), %ymm4
	vmovdqa	8736(%rsp,%rdi), %ymm5
	vpsllvd	%ymm6, %ymm4, %ymm2
	vpor	%ymm15, %ymm2, %ymm2
	vpsllvd	%ymm6, %ymm5, %ymm15
	vpor	%ymm14, %ymm15, %ymm14
	vextracti128	$1, %ymm2, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm1, %ymm3
	vpaddq	%ymm13, %ymm3, %ymm3
	vmovdqa	64(%rcx), %ymm13
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm2, %ymm0, %ymm2
	vpaddq	%ymm12, %ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm12 # ymm12 = ymm2[0],ymm7[1],ymm2[2],ymm7[3],ymm2[4],ymm7[5],ymm2[6],ymm7[7]
	vmovapd	64(%rsp), %ymm6         # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm7[1],ymm3[2],ymm7[3],ymm3[4],ymm7[5],ymm3[6],ymm7[7]
	vmovapd	160(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm1, %ymm1
	vpmovzxdq	%xmm14, %ymm12  # ymm12 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm12, %ymm13, %ymm12
	vpaddq	%ymm11, %ymm12, %ymm11
	vpblendd	$170, %ymm7, %ymm11, %ymm12 # ymm12 = ymm11[0],ymm7[1],ymm11[2],ymm7[3],ymm11[4],ymm7[5],ymm11[6],ymm7[7]
	vblendvpd	%ymm8, %ymm12, %ymm13, %ymm12
	vmovdqa	96(%rcx), %ymm13
	vextracti128	$1, %ymm14, %xmm6
	vpmovzxdq	%xmm6, %ymm6    # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
	vpsubq	%ymm6, %ymm13, %ymm6
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm7[1],ymm6[2],ymm7[3],ymm6[4],ymm7[5],ymm6[6],ymm7[7]
	vblendvpd	%ymm9, %ymm10, %ymm13, %ymm10
	vmovapd	%ymm10, 96(%rcx)
	vmovapd	%ymm12, 64(%rcx)
	vpsrlvd	96(%rsp), %ymm5, %ymm14 # 32-byte Folded Reload
	vmovdqa	96(%rsp), %ymm5         # 32-byte Reload
	vpsrlvd	%ymm5, %ymm4, %ymm15
	vmovapd	%ymm1, 32(%rcx)
	vmovapd	%ymm0, (%rcx)
	vpsrad	$31, %ymm6, %ymm0
	vpshufd	$245, %ymm6, %ymm1      # ymm1 = ymm6[1,1,3,3,5,5,7,7]
	vmovdqa	128(%rsp), %ymm6        # 32-byte Reload
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm1      # ymm1 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm2, %ymm0
	vpshufd	$245, %ymm2, %ymm1      # ymm1 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	%r15, %rdx
	subq	$-128, %rcx
	addq	$-1, %rax
	jne	.LBB3_34
# %bb.35:                               # %for_exit143
                                        #   in Loop: Header=BB3_33 Depth=3
	vmovdqa	384(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm10, %ymm0
	vmovdqa	416(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm11, %ymm1
	vmovdqa	448(%rsp), %ymm3        # 32-byte Reload
	vpaddq	%ymm3, %ymm13, %ymm2
	vmovdqa	%ymm3, %ymm13
	vmovdqa	480(%rsp), %ymm11       # 32-byte Reload
	vpaddq	%ymm11, %ymm12, %ymm3
	vmovdqa	%ymm4, %ymm12
	vmovapd	64(%rsp), %ymm4         # 32-byte Reload
	vblendvpd	%ymm4, %ymm3, %ymm11, %ymm11
	vmovapd	160(%rsp), %ymm3        # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm13, %ymm13
	vblendvpd	%ymm8, %ymm1, %ymm14, %ymm14
	vblendvpd	%ymm9, %ymm0, %ymm12, %ymm12
	vpcmpeqq	%ymm7, %ymm13, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm7, %ymm11, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpcmpeqq	%ymm7, %ymm12, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm7, %ymm14, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovdqa	352(%rsp), %ymm3        # 32-byte Reload
	vpandn	%ymm3, %ymm1, %ymm3
	vmovdqa	320(%rsp), %ymm2        # 32-byte Reload
	vpandn	%ymm2, %ymm0, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	jne	.LBB3_33
.LBB3_36:                               # %for_exit129
                                        #   in Loop: Header=BB3_37 Depth=2
	shrl	%r8d
	jne	.LBB3_37
# %bb.13:                               # %for_test32.loopexit
                                        #   in Loop: Header=BB3_10 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	48(%rsp), %rcx          # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB3_10
.LBB3_14:                               # %for_test188.preheader
	testl	%r13d, %r13d
	je	.LBB3_15
# %bb.16:                               # %for_loop190.lr.ph
	leal	-1(%r13), %ecx
	movl	%r13d, %eax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB3_48
# %bb.17:
	xorl	%ecx, %ecx
	movq	40(%rsp), %r11          # 8-byte Reload
	movl	32(%rsp), %r14d         # 4-byte Reload
	jmp	.LBB3_18
.LBB3_15:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	40(%rsp), %r11          # 8-byte Reload
	jmp	.LBB3_55
.LBB3_48:                               # %for_loop190.lr.ph.new
	movl	%r13d, %edx
	subl	%eax, %edx
	movl	%r13d, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	movq	40(%rsp), %r11          # 8-byte Reload
	movl	32(%rsp), %r14d         # 4-byte Reload
	.p2align	4, 0x90
.LBB3_49:                               # %for_loop190
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	160(%rsp,%rdi), %ymm1
	vmovaps	192(%rsp,%rdi), %ymm2
	vmovaps	224(%rsp,%rdi), %ymm3
	vmovaps	%ymm3, 12512(%rsp,%rdi)
	vmovaps	%ymm2, 12480(%rsp,%rdi)
	vmovaps	%ymm1, 12448(%rsp,%rdi)
	vmovaps	128(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 12416(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 12896(%rsp,%rsi)
	vmovdqa	%ymm0, 12864(%rsp,%rsi)
	vmovdqa	%ymm0, 12832(%rsp,%rsi)
	vmovdqa	%ymm0, 12800(%rsp,%rsi)
	vmovaps	256(%rsp,%rdi), %ymm1
	vmovaps	288(%rsp,%rdi), %ymm2
	vmovaps	320(%rsp,%rdi), %ymm3
	vmovaps	352(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 12640(%rsp,%rdi)
	vmovaps	%ymm3, 12608(%rsp,%rdi)
	vmovaps	%ymm2, 12576(%rsp,%rdi)
	vmovaps	%ymm1, 12544(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 12864(%rsp,%rsi)
	vmovdqa	%ymm0, 12800(%rsp,%rsi)
	vmovdqa	%ymm0, 12896(%rsp,%rsi)
	vmovdqa	%ymm0, 12832(%rsp,%rsi)
	vmovaps	384(%rsp,%rdi), %ymm1
	vmovaps	416(%rsp,%rdi), %ymm2
	vmovaps	448(%rsp,%rdi), %ymm3
	vmovaps	480(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 12768(%rsp,%rdi)
	vmovaps	%ymm3, 12736(%rsp,%rdi)
	vmovaps	%ymm2, 12704(%rsp,%rdi)
	vmovaps	%ymm1, 12672(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 12896(%rsp,%rsi)
	vmovdqa	%ymm0, 12864(%rsp,%rsi)
	vmovdqa	%ymm0, 12832(%rsp,%rsi)
	vmovdqa	%ymm0, 12800(%rsp,%rsi)
	vmovdqa	512(%rsp,%rdi), %ymm1
	vmovdqa	544(%rsp,%rdi), %ymm2
	vmovdqa	576(%rsp,%rdi), %ymm3
	vmovdqa	608(%rsp,%rdi), %ymm4
	vmovdqa	%ymm4, 12896(%rsp,%rdi)
	vmovdqa	%ymm3, 12864(%rsp,%rdi)
	vmovdqa	%ymm2, 12832(%rsp,%rdi)
	vmovdqa	%ymm1, 12800(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 12896(%rsp,%rbx)
	vmovdqa	%ymm0, 12864(%rsp,%rbx)
	vmovdqa	%ymm0, 12832(%rsp,%rbx)
	vmovdqa	%ymm0, 12800(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB3_49
.LBB3_18:                               # %for_test188.for_test206.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	vmovdqa	224(%rsp), %ymm14       # 32-byte Reload
	vmovdqa	192(%rsp), %ymm15       # 32-byte Reload
	je	.LBB3_21
# %bb.19:                               # %for_loop190.epil.preheader
	leal	(%rcx,%r13), %edx
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_20:                               # %for_loop190.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	512(%rsp,%rcx), %ymm1
	vmovdqa	544(%rsp,%rcx), %ymm2
	vmovdqa	576(%rsp,%rcx), %ymm3
	vmovdqa	608(%rsp,%rcx), %ymm4
	vmovdqa	%ymm4, 12896(%rsp,%rcx)
	vmovdqa	%ymm3, 12864(%rsp,%rcx)
	vmovdqa	%ymm2, 12832(%rsp,%rcx)
	vmovdqa	%ymm1, 12800(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 12896(%rsp,%rsi)
	vmovdqa	%ymm0, 12864(%rsp,%rsi)
	vmovdqa	%ymm0, 12832(%rsp,%rsi)
	vmovdqa	%ymm0, 12800(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB3_20
.LBB3_21:                               # %for_test206.preheader
	testl	%r13d, %r13d
	je	.LBB3_1
# %bb.22:                               # %for_loop224.lr.ph.us.preheader
	leaq	8768(%rsp), %r8
	movl	%r13d, %r10d
	subl	%r14d, %r10d
	movl	$1, %edx
	xorl	%esi, %esi
	vmovdqa	.LCPI3_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	movl	%r13d, %r9d
	.p2align	4, 0x90
.LBB3_23:                               # %for_loop224.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_41 Depth 2
	movq	%rsi, %rbx
	shlq	$7, %rbx
	vpermd	12864(%rsp,%rbx), %ymm0, %ymm2
	vpermd	12896(%rsp,%rbx), %ymm0, %ymm3
	vpermd	12800(%rsp,%rbx), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	12832(%rsp,%rbx), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	%ymm3, %ymm14, %ymm5
	vpmulld	%ymm2, %ymm15, %ymm3
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpxor	%xmm8, %xmm8, %xmm8
	cmpl	$1, %r13d
	jne	.LBB3_40
# %bb.24:                               #   in Loop: Header=BB3_23 Depth=1
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	jmp	.LBB3_43
	.p2align	4, 0x90
.LBB3_40:                               # %for_loop224.lr.ph.us.new
                                        #   in Loop: Header=BB3_23 Depth=1
	movq	%r8, %rdi
	xorl	%ecx, %ecx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB3_41:                               # %for_loop224.us
                                        #   Parent Loop BB3_23 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-16(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm13
	vpmuludq	%ymm4, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	leal	(%rsi,%rcx), %eax
	shlq	$7, %rax
	vpaddq	12800(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	12832(%rsp,%rax), %ymm9, %ymm9
	vpaddq	%ymm12, %ymm9, %ymm9
	vpaddq	12864(%rsp,%rax), %ymm7, %ymm7
	vpaddq	12896(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 12896(%rsp,%rax)
	vmovdqa	%ymm12, 12864(%rsp,%rax)
	vmovdqa	%ymm11, 12832(%rsp,%rax)
	vmovdqa	%ymm10, 12800(%rsp,%rax)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	(%rdi), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm2, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm5, %ymm10, %ymm10
	leal	(%rdx,%rcx), %eax
	shlq	$7, %rax
	vpaddq	12832(%rsp,%rax), %ymm9, %ymm9
	vpaddq	12896(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm12, %ymm6, %ymm6
	vpaddq	12864(%rsp,%rax), %ymm7, %ymm7
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	12800(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm10, %ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vmovdqa	%ymm13, 12800(%rsp,%rax)
	vmovdqa	%ymm12, 12864(%rsp,%rax)
	vmovdqa	%ymm11, 12896(%rsp,%rax)
	vmovdqa	%ymm10, 12832(%rsp,%rax)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %rcx
	subq	$-128, %rdi
	cmpl	%ecx, %r10d
	jne	.LBB3_41
# %bb.42:                               # %for_test222.for_exit225_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_23 Depth=1
	testb	$1, %r13b
	je	.LBB3_44
.LBB3_43:                               # %for_loop224.us.epil.preheader
                                        #   in Loop: Header=BB3_23 Depth=1
	movq	%rcx, %rax
	shlq	$6, %rax
	vpmovzxdq	8752(%rsp,%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8736(%rsp,%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8720(%rsp,%rax), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8704(%rsp,%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm5
	vpmuludq	%ymm4, %ymm12, %ymm4
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	addl	%esi, %ecx
	shlq	$7, %rcx
	vpaddq	12800(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	12832(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	12864(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm7, %ymm3
	vpaddq	12896(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm2, %ymm6, %ymm2
	vpblendd	$170, %ymm1, %ymm5, %ymm6 # ymm6 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm9, 12896(%rsp,%rcx)
	vmovdqa	%ymm8, 12864(%rsp,%rcx)
	vmovdqa	%ymm7, 12832(%rsp,%rcx)
	vmovdqa	%ymm6, 12800(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm6
	vpsrlq	$32, %ymm3, %ymm7
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm8
.LBB3_44:                               # %for_exit225.us
                                        #   in Loop: Header=BB3_23 Depth=1
	vmovdqa	%ymm9, 544(%rsp,%rbx)
	vmovdqa	%ymm8, 512(%rsp,%rbx)
	vmovdqa	%ymm7, 576(%rsp,%rbx)
	vmovdqa	%ymm6, 608(%rsp,%rbx)
	addq	$1, %rsi
	addq	$1, %rdx
	cmpq	%r9, %rsi
	jne	.LBB3_23
# %bb.45:                               # %for_test255.preheader
	testl	%r13d, %r13d
	je	.LBB3_1
# %bb.46:                               # %for_loop257.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, %r13d
	jne	.LBB3_50
# %bb.47:
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB3_53
.LBB3_1:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB3_55
.LBB3_50:                               # %for_loop257.lr.ph.new
	movabsq	$4294967296, %r8        # imm = 0x100000000
	leaq	640(%rsp), %rsi
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%edi, %edi
	movabsq	$8589934592, %rbx       # imm = 0x200000000
	movl	%r13d, %edx
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_51:                               # %for_loop257
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rax
	sarq	$25, %rax
	vpaddq	576(%rsp,%rax), %ymm2, %ymm2
	vpaddq	544(%rsp,%rax), %ymm5, %ymm5
	vpaddq	512(%rsp,%rax), %ymm4, %ymm4
	vpaddq	608(%rsp,%rax), %ymm3, %ymm3
	movl	%edx, %eax
	shlq	$7, %rax
	vpaddq	12896(%rsp,%rax), %ymm3, %ymm3
	vpaddq	12800(%rsp,%rax), %ymm4, %ymm4
	vpaddq	12832(%rsp,%rax), %ymm5, %ymm5
	vpaddq	12864(%rsp,%rax), %ymm2, %ymm2
	vpblendd	$170, %ymm1, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm9, -32(%rsi)
	vmovdqa	%ymm8, -128(%rsi)
	vmovdqa	%ymm7, -96(%rsi)
	vmovdqa	%ymm6, -64(%rsi)
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	leaq	(%rdi,%r8), %rax
	sarq	$25, %rax
	vpaddq	608(%rsp,%rax), %ymm3, %ymm3
	vpaddq	512(%rsp,%rax), %ymm4, %ymm4
	vpaddq	544(%rsp,%rax), %ymm5, %ymm5
	vpaddq	576(%rsp,%rax), %ymm2, %ymm2
	leal	1(%rdx), %eax
	shlq	$7, %rax
	vpaddq	12864(%rsp,%rax), %ymm2, %ymm2
	vpaddq	12832(%rsp,%rax), %ymm5, %ymm5
	vpaddq	12800(%rsp,%rax), %ymm4, %ymm4
	vpaddq	12896(%rsp,%rax), %ymm3, %ymm3
	vpblendd	$170, %ymm1, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm8, 64(%rsi)
	vmovdqa	%ymm7, 32(%rsi)
	vmovdqa	%ymm6, (%rsi)
	vpblendd	$170, %ymm1, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm6, 96(%rsi)
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	addq	$2, %rcx
	addl	$2, %edx
	addq	$256, %rsi              # imm = 0x100
	addq	%rbx, %rdi
	cmpl	%ecx, %r10d
	jne	.LBB3_51
# %bb.52:                               # %for_test255.for_exit258_crit_edge.unr-lcssa
	testl	%r14d, %r14d
	je	.LBB3_54
.LBB3_53:                               # %for_loop257.epil.preheader
	movslq	%ecx, %rax
	movq	%rax, %rdx
	shlq	$7, %rdx
	vpaddq	512(%rsp,%rdx), %ymm4, %ymm1
	vpaddq	544(%rsp,%rdx), %ymm5, %ymm4
	vpaddq	576(%rsp,%rdx), %ymm2, %ymm2
	vpaddq	608(%rsp,%rdx), %ymm3, %ymm3
	addl	%r13d, %eax
	shlq	$7, %rax
	vpaddq	12896(%rsp,%rax), %ymm3, %ymm3
	vpaddq	12864(%rsp,%rax), %ymm2, %ymm2
	vpaddq	12832(%rsp,%rax), %ymm4, %ymm4
	vpaddq	12800(%rsp,%rax), %ymm1, %ymm1
	shlq	$7, %rcx
	vpblendd	$170, %ymm0, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm0 # ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm0, 608(%rsp,%rcx)
	vmovdqa	%ymm7, 576(%rsp,%rcx)
	vmovdqa	%ymm6, 544(%rsp,%rcx)
	vmovdqa	%ymm5, 512(%rsp,%rcx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm4, %ymm5
	vpsrlq	$32, %ymm1, %ymm4
.LBB3_54:                               # %for_test255.for_exit258_crit_edge
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	%ymm0, %ymm5, %ymm1
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vpcmpeqq	%ymm0, %ymm4, %ymm4
	vpxor	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vinserti128	$1, %xmm1, %ymm4, %ymm4
	vpcmpeqq	%ymm0, %ymm3, %ymm1
	vpxor	%ymm5, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpcmpeqq	%ymm0, %ymm2, %ymm0
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm2
	vpackssdw	%xmm2, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm5
.LBB3_55:                               # %for_exit258
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_59
# %bb.56:                               # %for_exit258
	testl	%r13d, %r13d
	je	.LBB3_59
# %bb.57:                               # %for_loop292.lr.ph
	movabsq	$4294967296, %rax       # imm = 0x100000000
	movl	36(%rsp), %edx          # 4-byte Reload
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %ecx
	subl	%edx, %ecx
	vmovd	%ecx, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovaps	.LCPI3_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm4, %ymm2, %ymm3
	vmovaps	%ymm3, 96(%rsp)         # 32-byte Spill
	vmovdqa	.LCPI3_4(%rip), %ymm6   # ymm6 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm6, %ymm3
	vmovdqa	%ymm3, 64(%rsp)         # 32-byte Spill
	vpermps	%ymm5, %ymm2, %ymm2
	vmovaps	%ymm2, 160(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 128(%rsp)        # 32-byte Spill
	movl	%r13d, %ecx
	shlq	$7, %rcx
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	xorl	%esi, %esi
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB3_58:                               # %for_loop292
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	512(%rsp,%rdx), %ymm15
	vmovdqa	544(%rsp,%rdx), %ymm2
	movq	%rsi, %rdi
	sarq	$26, %rdi
	vmovdqa	8704(%rsp,%rdi), %ymm13
	vmovdqa	8736(%rsp,%rdi), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm3
	vpor	%ymm12, %ymm3, %ymm3
	vpsllvd	%ymm0, %ymm14, %ymm12
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm3, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm10, %ymm4, %ymm4
	vmovdqa	576(%rsp,%rdx), %ymm10
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vmovapd	96(%rsp), %ymm5         # 32-byte Reload
	vblendvpd	%ymm5, %ymm9, %ymm15, %ymm9
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vmovapd	64(%rsp), %ymm5         # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm2, %ymm2
	vpmovzxdq	%xmm11, %ymm12  # ymm12 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm12, %ymm10, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	160(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm10, %ymm10
	vmovdqa	608(%rsp,%rdx), %ymm12
	vextracti128	$1, %ymm11, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm12, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm6[1],ymm5[2],ymm6[3],ymm5[4],ymm6[5],ymm5[6],ymm6[7]
	vmovapd	128(%rsp), %ymm11       # 32-byte Reload
	vblendvpd	%ymm11, %ymm7, %ymm12, %ymm7
	vmovapd	%ymm7, 608(%rsp,%rdx)
	vmovapd	%ymm10, 576(%rsp,%rdx)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm2, 544(%rsp,%rdx)
	vmovapd	%ymm9, 512(%rsp,%rdx)
	vpsrad	$31, %ymm5, %ymm2
	vpshufd	$245, %ymm5, %ymm5      # ymm5 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpsrad	$31, %ymm8, %ymm2
	vpshufd	$245, %ymm8, %ymm5      # ymm5 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpsrad	$31, %ymm4, %ymm2
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpsrad	$31, %ymm3, %ymm2
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	addq	%rax, %rsi
	subq	$-128, %rdx
	cmpq	%rdx, %rcx
	jne	.LBB3_58
.LBB3_59:                               # %safe_if_after_true
	leal	-1(%r13), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	608(%rsp,%rax), %ymm0, %ymm1
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpcmpeqq	576(%rsp,%rax), %ymm0, %ymm4
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpxor	%ymm2, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vinserti128	$1, %xmm1, %ymm3, %ymm3
	vpcmpeqq	544(%rsp,%rax), %ymm0, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpcmpeqq	512(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm4
	vpackssdw	%xmm4, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm1
	vmovmskps	%ymm1, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovaps	%ymm3, 96(%rsp)         # 32-byte Spill
	vmovaps	%ymm1, 64(%rsp)         # 32-byte Spill
	je	.LBB3_60
# %bb.63:                               # %for_test349.preheader
	movl	%r13d, %eax
	negl	%eax
	sbbl	%eax, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	%ymm3, %ymm0, %ymm5
	vpand	%ymm1, %ymm0, %ymm6
	vmovmskps	%ymm6, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_60
# %bb.64:                               # %for_loop351.preheader
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vbroadcastss	.LCPI3_5(%rip), %ymm11 # ymm11 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vpbroadcastd	.LCPI3_5(%rip), %ymm15 # ymm15 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	xorl	%eax, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	vmovdqa	%ymm15, %ymm9
	vmovdqa	%ymm15, %ymm10
	vmovaps	%ymm11, %ymm12
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	.p2align	4, 0x90
.LBB3_65:                               # %for_loop351
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	8704(%rsp,%rdx), %ymm9, %ymm13
	vpaddd	8736(%rsp,%rdx), %ymm10, %ymm14
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpmaxud	8736(%rsp,%rdx), %ymm14, %ymm9
	vpcmpeqd	%ymm9, %ymm14, %ymm9
	vpandn	%ymm15, %ymm9, %ymm10
	vpmaxud	8704(%rsp,%rdx), %ymm13, %ymm9
	vpcmpeqd	%ymm9, %ymm13, %ymm9
	vpandn	%ymm15, %ymm9, %ymm9
	vblendvps	%ymm6, %ymm9, %ymm11, %ymm9
	vblendvps	%ymm5, %ymm10, %ymm12, %ymm10
	shlq	$7, %rcx
	vpmovzxdq	%xmm14, %ymm11  # ymm11 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm13, %ymm12  # ymm12 = xmm13[0],zero,xmm13[1],zero,xmm13[2],zero,xmm13[3],zero
	vextracti128	$1, %ymm13, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpcmpeqq	544(%rsp,%rcx), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	512(%rsp,%rcx), %ymm12, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpcmpeqq	608(%rsp,%rcx), %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm4
	vpackssdw	%xmm4, %xmm2, %xmm2
	vpcmpeqq	576(%rsp,%rcx), %ymm11, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm2
	vpandn	%ymm5, %ymm2, %ymm2
	vpandn	%ymm6, %ymm3, %ymm3
	vblendvps	%ymm3, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r13d, %eax
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpand	%ymm2, %ymm5, %ymm3
	vandps	%ymm3, %ymm1, %ymm5
	vpand	%ymm2, %ymm6, %ymm2
	vandps	%ymm2, %ymm0, %ymm6
	vmovmskps	%ymm6, %ecx
	vmovmskps	%ymm5, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	vmovaps	%ymm9, %ymm11
	vmovaps	%ymm10, %ymm12
	jne	.LBB3_65
	jmp	.LBB3_61
.LBB3_60:
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
.LBB3_61:                               # %safe_if_after_true341
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	64(%rsp), %ymm2, %ymm4  # 32-byte Folded Reload
	vpxor	96(%rsp), %ymm2, %ymm2  # 32-byte Folded Reload
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_62
# %bb.66:                               # %safe_if_run_false407
	vpbroadcastq	.LCPI3_6(%rip), %ymm3 # ymm3 = [1,1,1,1]
	vpcmpeqq	608(%rsp), %ymm3, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	576(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	544(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	512(%rsp), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm7
	vpackssdw	%xmm7, %xmm3, %xmm3
	vinserti128	$1, %xmm6, %ymm3, %ymm3
	vblendvps	%ymm4, %ymm3, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm5, %ymm1, %ymm1
	xorl	%eax, %eax
	cmpl	$1, %r13d
	seta	%al
	negl	%eax
	vmovd	%eax, %xmm3
	vpbroadcastd	%xmm3, %ymm3
	vandps	%ymm0, %ymm4, %ymm4
	vandps	%ymm1, %ymm2, %ymm2
	vandps	%ymm3, %ymm2, %ymm2
	vandps	%ymm3, %ymm4, %ymm3
	vmovmskps	%ymm3, %eax
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_62
# %bb.67:                               # %for_loop419.preheader
	movl	$1, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB3_68:                               # %for_loop419
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	544(%rsp,%rcx), %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	512(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	608(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	576(%rsp,%rcx), %ymm8, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vinserti128	$1, %xmm6, %ymm4, %ymm4
	vpandn	%ymm2, %ymm4, %ymm4
	vpandn	%ymm3, %ymm5, %ymm5
	vblendvps	%ymm5, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm4, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r13d, %eax
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpand	%ymm4, %ymm2, %ymm2
	vandps	%ymm2, %ymm1, %ymm2
	vpand	%ymm4, %ymm3, %ymm3
	vandps	%ymm3, %ymm0, %ymm3
	vmovmskps	%ymm3, %ecx
	vmovmskps	%ymm2, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	jne	.LBB3_68
.LBB3_62:                               # %if_done340
	vbroadcastss	.LCPI3_5(%rip), %ymm2 # ymm2 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vandps	%ymm2, %ymm1, %ymm1
	vandps	%ymm2, %ymm0, %ymm0
	vmovups	%ymm0, (%r11)
	vmovups	%ymm1, 32(%r11)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end3:
	.size	fermat_test, .Lfunc_end3-fermat_test
                                        # -- End function

	.ident	"clang version 8.0.0 (http://llvm.org/git/clang.git 2d5099826365b50ff253e48c0832255600e68202) (http://llvm.org/git/llvm.git 498b7f9b57123ce661e075ae584876be72852506)"
	.section	".note.GNU-stack","",@progbits
