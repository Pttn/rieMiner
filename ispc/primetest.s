	.text
	.file	"primetest.ispc"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
.LCPI0_0:
	.long	0                       # 0x0
	.long	2                       # 0x2
	.long	4                       # 0x4
	.long	6                       # 0x6
	.long	4                       # 0x4
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
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
	movl	%edx, %r8d
	decl	%r8d
	je	.LBB0_1
# %bb.2:                                # %for_loop.lr.ph
	vpxor	%xmm4, %xmm4, %xmm4
	vpblendd	$85, 96(%rsi), %ymm4, %ymm0 # ymm0 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	vpblendd	$85, 64(%rsi), %ymm4, %ymm1 # ymm1 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	vpblendd	$85, 32(%rsi), %ymm4, %ymm2 # ymm2 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	vpblendd	$85, (%rsi), %ymm4, %ymm3 # ymm3 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
	leal	-2(%rdx), %r15d
	movl	%r8d, %eax
	andl	$3, %eax
	cmpl	$3, %r15d
	jae	.LBB0_4
# %bb.3:
	xorl	%ebx, %ebx
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	jmp	.LBB0_6
.LBB0_1:                                # %for_exit24.thread
	movl	%r8d, %eax
	shlq	$7, %rax
	vpxor	%xmm15, %xmm15, %xmm15
	vmovdqa	%ymm15, 224(%rsp,%rax)
	vmovdqa	%ymm15, 192(%rsp,%rax)
	vmovdqa	%ymm15, 160(%rsp,%rax)
	vmovdqa	%ymm15, 128(%rsp,%rax)
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	96(%rsi), %ymm1
	vpmuludq	%ymm0, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm1, %ymm14
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpblendd	$170, %ymm15, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm14, %ymm7 # ymm7 = ymm14[0],ymm15[1],ymm14[2],ymm15[3],ymm14[4],ymm15[5],ymm14[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqu	%ymm8, 64(%rdi)
	vmovdqu	%ymm7, 96(%rdi)
	vmovdqu	%ymm5, (%rdi)
	vmovdqu	%ymm4, 32(%rdi)
	jmp	.LBB0_19
.LBB0_4:                                # %for_loop.lr.ph.new
	movl	%r8d, %r9d
	subl	%eax, %r9d
	vpxor	%xmm5, %xmm5, %xmm5
	movl	$384, %ecx              # imm = 0x180
	xorl	%ebx, %ebx
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB0_5:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vpmuludq	-160(%rsi,%rcx), %ymm0, %ymm9
	vpmuludq	-192(%rsi,%rcx), %ymm1, %ymm10
	vpaddq	%ymm8, %ymm9, %ymm8
	vpaddq	%ymm7, %ymm10, %ymm7
	vpmuludq	-224(%rsi,%rcx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpmuludq	-256(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmovdqa	%ymm12, -256(%rsp,%rcx)
	vmovdqa	%ymm11, -224(%rsp,%rcx)
	vmovdqa	%ymm10, -192(%rsp,%rcx)
	vmovdqa	%ymm9, -160(%rsp,%rcx)
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	-64(%rsi,%rcx), %ymm1, %ymm9
	vpmuludq	-96(%rsi,%rcx), %ymm2, %ymm10
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm6, %ymm10, %ymm6
	vpmuludq	-128(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	-32(%rsi,%rcx), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqa	%ymm12, -32(%rsp,%rcx)
	vmovdqa	%ymm11, -128(%rsp,%rcx)
	vmovdqa	%ymm10, -96(%rsp,%rcx)
	vmovdqa	%ymm9, -64(%rsp,%rcx)
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	64(%rsi,%rcx), %ymm1, %ymm9
	vpmuludq	32(%rsi,%rcx), %ymm2, %ymm10
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm6, %ymm10, %ymm6
	vpmuludq	(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	96(%rsi,%rcx), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqa	%ymm12, 96(%rsp,%rcx)
	vmovdqa	%ymm11, (%rsp,%rcx)
	vmovdqa	%ymm10, 32(%rsp,%rcx)
	vmovdqa	%ymm9, 64(%rsp,%rcx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	addq	$4, %rbx
	vpmuludq	160(%rsi,%rcx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpmuludq	128(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	224(%rsi,%rcx), %ymm0, %ymm9
	vpmuludq	192(%rsi,%rcx), %ymm1, %ymm10
	vpaddq	%ymm8, %ymm9, %ymm8
	vpaddq	%ymm7, %ymm10, %ymm7
	vpblendd	$170, %ymm5, %ymm6, %ymm9 # ymm9 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vmovdqa	%ymm12, 192(%rsp,%rcx)
	vmovdqa	%ymm11, 224(%rsp,%rcx)
	vmovdqa	%ymm10, 128(%rsp,%rcx)
	vmovdqa	%ymm9, 160(%rsp,%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	addq	$512, %rcx              # imm = 0x200
	cmpl	%ebx, %r9d
	jne	.LBB0_5
.LBB0_6:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%eax, %eax
	je	.LBB0_9
# %bb.7:                                # %for_loop.epil.preheader
	shlq	$7, %rbx
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB0_8:                                # %for_loop.epil
                                        # =>This Inner Loop Header: Depth=1
	vpmuludq	224(%rsi,%rbx), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpmuludq	192(%rsi,%rbx), %ymm1, %ymm9
	vpaddq	%ymm7, %ymm9, %ymm7
	vpmuludq	160(%rsi,%rbx), %ymm2, %ymm9
	vpmuludq	128(%rsi,%rbx), %ymm3, %ymm10
	vpaddq	%ymm6, %ymm9, %ymm6
	vpaddq	%ymm4, %ymm10, %ymm4
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmovdqa	%ymm12, 128(%rsp,%rbx)
	vmovdqa	%ymm11, 160(%rsp,%rbx)
	vmovdqa	%ymm10, 192(%rsp,%rbx)
	vmovdqa	%ymm9, 224(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	subq	$-128, %rbx
	decl	%eax
	jne	.LBB0_8
.LBB0_9:                                # %for_exit
	movl	%r8d, (%rsp)            # 4-byte Spill
	movl	%r8d, %r9d
	movq	%r9, %rax
	shlq	$7, %rax
	vmovdqa	%ymm8, 224(%rsp,%rax)
	vmovdqa	%ymm7, 192(%rsp,%rax)
	vmovdqa	%ymm6, 160(%rsp,%rax)
	vmovdqa	%ymm4, 128(%rsp,%rax)
	cmpl	$3, %edx
	jb	.LBB0_18
# %bb.10:                               # %for_test30.preheader.lr.ph
	leal	-3(%rdx), %r14d
	movl	%edx, %eax
	movq	%rax, 64(%rsp)          # 8-byte Spill
	leaq	128(%rsi), %rax
	movq	%rax, 32(%rsp)          # 8-byte Spill
	movl	$2, %r13d
	xorl	%r12d, %r12d
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rdx, %r10
	jmp	.LBB0_11
	.p2align	4, 0x90
.LBB0_17:                               # %for_exit33
                                        #   in Loop: Header=BB0_11 Depth=1
	movq	%r10, %rdx
	addl	%edx, %ecx
	shlq	$7, %rcx
	vmovdqa	%ymm5, 224(%rsp,%rcx)
	vmovdqa	%ymm6, 192(%rsp,%rcx)
	vmovdqa	%ymm7, 160(%rsp,%rcx)
	vmovdqa	%ymm8, 128(%rsp,%rcx)
	incq	%r13
	incq	%r12
	cmpl	%r15d, %r12d
	je	.LBB0_18
.LBB0_11:                               # %for_loop31.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_16 Depth 2
	movl	%r15d, %ebx
	subl	%r12d, %ebx
	movq	%r13, %rax
	shlq	$7, %rax
	vpblendd	$85, -32(%rax,%rsi), %ymm0, %ymm1 # ymm1 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -64(%rax,%rsi), %ymm0, %ymm2 # ymm2 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -96(%rax,%rsi), %ymm0, %ymm3 # ymm3 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	vpblendd	$85, -128(%rax,%rsi), %ymm0, %ymm4 # ymm4 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
	leaq	-2(%r13), %rcx
	testb	$1, %bl
	jne	.LBB0_13
# %bb.12:                               #   in Loop: Header=BB0_11 Depth=1
	movq	%r13, %rbx
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm5, %xmm5, %xmm5
	cmpl	%r12d, %r14d
	je	.LBB0_17
	jmp	.LBB0_15
	.p2align	4, 0x90
.LBB0_13:                               # %for_loop31.prol.preheader
                                        #   in Loop: Header=BB0_11 Depth=1
	vpmuludq	32(%rsi,%rax), %ymm3, %ymm5
	vpmuludq	(%rsi,%rax), %ymm4, %ymm6
	vpmuludq	96(%rsi,%rax), %ymm1, %ymm7
	vpmuludq	64(%rsi,%rax), %ymm2, %ymm8
	leal	(%rcx,%r13), %eax
	shlq	$7, %rax
	vpaddq	192(%rsp,%rax), %ymm8, %ymm8
	vpaddq	224(%rsp,%rax), %ymm7, %ymm7
	vpaddq	128(%rsp,%rax), %ymm6, %ymm9
	vpaddq	160(%rsp,%rax), %ymm5, %ymm10
	vpblendd	$170, %ymm0, %ymm9, %ymm5 # ymm5 = ymm9[0],ymm0[1],ymm9[2],ymm0[3],ymm9[4],ymm0[5],ymm9[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm7, %ymm6 # ymm6 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vmovdqa	%ymm11, 192(%rsp,%rax)
	vmovdqa	%ymm6, 224(%rsp,%rax)
	vmovdqa	%ymm5, 128(%rsp,%rax)
	vpblendd	$170, %ymm0, %ymm10, %ymm5 # ymm5 = ymm10[0],ymm0[1],ymm10[2],ymm0[3],ymm10[4],ymm0[5],ymm10[6],ymm0[7]
	vmovdqa	%ymm5, 160(%rsp,%rax)
	vpsrlq	$32, %ymm7, %ymm5
	vpsrlq	$32, %ymm8, %ymm6
	vpsrlq	$32, %ymm10, %ymm7
	vpsrlq	$32, %ymm9, %ymm8
	leaq	1(%r13), %rbx
	cmpl	%r12d, %r14d
	je	.LBB0_17
.LBB0_15:                               # %for_loop31.preheader
                                        #   in Loop: Header=BB0_11 Depth=1
	movq	64(%rsp), %rax          # 8-byte Reload
	subq	%rbx, %rax
	leaq	(%rbx,%r12), %r8
	shlq	$7, %rbx
	addq	32(%rsp), %rbx          # 8-byte Folded Reload
	.p2align	4, 0x90
.LBB0_16:                               # %for_loop31
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmuludq	-128(%rbx), %ymm4, %ymm9
	vpmuludq	-96(%rbx), %ymm3, %ymm10
	vpmuludq	-64(%rbx), %ymm2, %ymm11
	vpmuludq	-32(%rbx), %ymm1, %ymm12
	movl	%r8d, %r11d
	shlq	$7, %r11
	vpaddq	128(%rsp,%r11), %ymm8, %ymm8
	vpaddq	%ymm9, %ymm8, %ymm8
	vpaddq	160(%rsp,%r11), %ymm7, %ymm7
	vpaddq	%ymm7, %ymm10, %ymm7
	vpaddq	192(%rsp,%r11), %ymm6, %ymm6
	vpaddq	224(%rsp,%r11), %ymm5, %ymm5
	vpaddq	%ymm6, %ymm11, %ymm6
	vpaddq	%ymm5, %ymm12, %ymm5
	vpblendd	$170, %ymm0, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm0[1],ymm6[2],ymm0[3],ymm6[4],ymm0[5],ymm6[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm5, %ymm12 # ymm12 = ymm5[0],ymm0[1],ymm5[2],ymm0[3],ymm5[4],ymm0[5],ymm5[6],ymm0[7]
	vmovdqa	%ymm12, 224(%rsp,%r11)
	vmovdqa	%ymm11, 192(%rsp,%r11)
	vmovdqa	%ymm10, 160(%rsp,%r11)
	vmovdqa	%ymm9, 128(%rsp,%r11)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	(%rbx), %ymm4, %ymm9
	vpmuludq	32(%rbx), %ymm3, %ymm10
	vpmuludq	64(%rbx), %ymm2, %ymm11
	vpmuludq	96(%rbx), %ymm1, %ymm12
	leal	1(%r8), %edx
	shlq	$7, %rdx
	vpaddq	128(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	160(%rsp,%rdx), %ymm7, %ymm7
	vpaddq	%ymm9, %ymm8, %ymm8
	vpaddq	%ymm7, %ymm10, %ymm7
	vpaddq	192(%rsp,%rdx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm11, %ymm6
	vpaddq	224(%rsp,%rdx), %ymm5, %ymm5
	vpaddq	%ymm5, %ymm12, %ymm5
	vpblendd	$170, %ymm0, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm0[1],ymm6[2],ymm0[3],ymm6[4],ymm0[5],ymm6[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm5, %ymm12 # ymm12 = ymm5[0],ymm0[1],ymm5[2],ymm0[3],ymm5[4],ymm0[5],ymm5[6],ymm0[7]
	vmovdqa	%ymm12, 224(%rsp,%rdx)
	vmovdqa	%ymm11, 192(%rsp,%rdx)
	vmovdqa	%ymm10, 160(%rsp,%rdx)
	vmovdqa	%ymm9, 128(%rsp,%rdx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %r8
	addq	$256, %rbx              # imm = 0x100
	addq	$-2, %rax
	jne	.LBB0_16
	jmp	.LBB0_17
.LBB0_18:                               # %for_exit24
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	96(%rsi), %ymm1
	vpmuludq	%ymm0, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm1, %ymm14
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpxor	%xmm15, %xmm15, %xmm15
	vpblendd	$170, %ymm15, %ymm2, %ymm4 # ymm4 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm14, %ymm5 # ymm5 = ymm14[0],ymm15[1],ymm14[2],ymm15[3],ymm14[4],ymm15[5],ymm14[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqu	%ymm7, 64(%rdi)
	vmovdqu	%ymm5, 96(%rdi)
	vmovdqu	%ymm4, (%rdi)
	vpblendd	$170, %ymm15, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vmovdqu	%ymm4, 32(%rdi)
	cmpl	$0, (%rsp)              # 4-byte Folded Reload
	je	.LBB0_19
# %bb.20:                               # %for_loop88.preheader
	addq	%r9, %r9
	subq	$-128, %rsi
	xorl	%eax, %eax
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB0_21:                               # %for_loop88
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa	128(%rsp,%rcx), %ymm5
	vmovdqa	160(%rsp,%rcx), %ymm12
	vmovdqa	192(%rsp,%rcx), %ymm11
	vmovdqa	224(%rsp,%rcx), %ymm13
	vpsrlq	$32, %ymm14, %ymm1
	vpaddq	%ymm1, %ymm9, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm15, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	%ymm7, %ymm3, %ymm3
	vpsrlq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm8, %ymm0
	vmovdqa	.LCPI0_0(%rip), %ymm10  # ymm10 = [0,2,4,6,4,6,6,7]
	vpermd	%ymm13, %ymm10, %ymm6
	vpermd	%ymm5, %ymm10, %ymm8
	vpermd	%ymm12, %ymm10, %ymm9
	vpermd	%ymm11, %ymm10, %ymm7
	vpaddd	%xmm7, %xmm7, %xmm7
	vpmovzxdq	%xmm7, %ymm7    # ymm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
	vpaddq	%ymm7, %ymm0, %ymm7
	vmovdqa	%ymm7, 96(%rsp)         # 32-byte Spill
	vpaddd	%xmm9, %xmm9, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpaddq	%ymm0, %ymm3, %ymm0
	vpaddd	%xmm8, %xmm8, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpaddq	%ymm3, %ymm2, %ymm2
	vpaddd	%xmm6, %xmm6, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpaddq	%ymm3, %ymm1, %ymm6
	vmovdqa	%ymm6, 64(%rsp)         # 32-byte Spill
	leal	1(%rax), %ecx
	shlq	$7, %rcx
	vpblendd	$170, %ymm4, %ymm0, %ymm1 # ymm1 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm2, %ymm3 # ymm3 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm6, %ymm8 # ymm8 = ymm6[0],ymm4[1],ymm6[2],ymm4[3],ymm6[4],ymm4[5],ymm6[6],ymm4[7]
	vmovdqu	%ymm8, 96(%rdi,%rcx)
	vmovdqu	%ymm3, (%rdi,%rcx)
	vmovdqu	%ymm1, 32(%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm7, %ymm1 # ymm1 = ymm7[0],ymm4[1],ymm7[2],ymm4[3],ymm7[4],ymm4[5],ymm7[6],ymm4[7]
	vmovdqu	%ymm1, 64(%rdi,%rcx)
	vpsrlq	$31, %ymm12, %ymm12
	vpsrlq	$31, %ymm5, %ymm14
	vpsrlq	$31, %ymm13, %ymm13
	vpsrlq	$31, %ymm11, %ymm11
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm0, %ymm15
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	96(%rsi), %ymm1
	vpmuludq	%ymm0, %ymm0, %ymm6
	vmovdqa	%ymm6, (%rsp)           # 32-byte Spill
	vpmuludq	%ymm1, %ymm1, %ymm0
	vpmuludq	%ymm2, %ymm2, %ymm1
	vmovdqa	%ymm1, 32(%rsp)         # 32-byte Spill
	vpmuludq	%ymm3, %ymm3, %ymm3
	vmovdqa	128(%rsp,%rcx), %ymm9
	vmovdqa	160(%rsp,%rcx), %ymm8
	vpblendd	$170, %ymm4, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpaddq	%ymm5, %ymm12, %ymm5
	vpblendd	$170, %ymm4, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm4[1],ymm1[2],ymm4[3],ymm1[4],ymm4[5],ymm1[6],ymm4[7]
	vpaddq	%ymm14, %ymm12, %ymm12
	vpblendd	$170, %ymm4, %ymm0, %ymm14 # ymm14 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vpaddq	%ymm13, %ymm14, %ymm14
	vpblendd	$170, %ymm4, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm4[1],ymm6[2],ymm4[3],ymm6[4],ymm4[5],ymm6[6],ymm4[7]
	vpaddq	%ymm11, %ymm13, %ymm6
	vpermd	%ymm8, %ymm10, %ymm11
	vpaddd	%xmm11, %xmm11, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpaddq	%ymm1, %ymm5, %ymm1
	vmovdqa	192(%rsp,%rcx), %ymm11
	vpaddq	%ymm1, %ymm15, %ymm13
	vpermd	%ymm9, %ymm10, %ymm1
	vpaddd	%xmm1, %xmm1, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpaddq	%ymm1, %ymm12, %ymm1
	vmovdqa	224(%rsp,%rcx), %ymm12
	vpaddq	%ymm1, %ymm7, %ymm1
	vpermd	%ymm12, %ymm10, %ymm5
	vpaddd	%xmm5, %xmm5, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpaddq	%ymm5, %ymm14, %ymm5
	vmovdqa	%ymm0, %ymm14
	vpermd	%ymm11, %ymm10, %ymm10
	vpaddd	%xmm10, %xmm10, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpaddq	%ymm2, %ymm6, %ymm0
	vmovdqa	96(%rsp), %ymm2         # 32-byte Reload
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	%ymm0, %ymm2, %ymm0
	addq	$2, %rax
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpblendd	$170, %ymm4, %ymm0, %ymm2 # ymm2 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vmovdqu	%ymm2, 64(%rdi,%rcx)
	vmovdqa	64(%rsp), %ymm2         # 32-byte Reload
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	vmovdqu	%ymm5, 96(%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm4[1],ymm1[2],ymm4[3],ymm1[4],ymm4[5],ymm1[6],ymm4[7]
	vmovdqu	%ymm5, (%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm13, %ymm5 # ymm5 = ymm13[0],ymm4[1],ymm13[2],ymm4[3],ymm13[4],ymm4[5],ymm13[6],ymm4[7]
	vmovdqu	%ymm5, 32(%rdi,%rcx)
	vpsrlq	$31, %ymm9, %ymm5
	vpsrlq	$32, %ymm1, %ymm1
	vpaddq	%ymm5, %ymm1, %ymm15
	vpsrlq	$31, %ymm8, %ymm1
	vpsrlq	$32, %ymm13, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm7
	vpsrlq	$31, %ymm11, %ymm1
	vpsrlq	$32, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm0, %ymm8
	vpsrlq	$31, %ymm12, %ymm0
	vpsrlq	$32, %ymm2, %ymm1
	vmovdqa	32(%rsp), %ymm2         # 32-byte Reload
	vpaddq	%ymm0, %ymm1, %ymm9
	vmovdqa	(%rsp), %ymm0           # 32-byte Reload
	subq	$-128, %rsi
	cmpq	%rax, %r9
	jne	.LBB0_21
	jmp	.LBB0_22
.LBB0_19:
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
.LBB0_22:                               # %for_exit90
	leal	(%rdx,%rdx), %eax
	decl	%eax
	shlq	$7, %rax
	vpsrlq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm8, %ymm0
	vpsrlq	$32, %ymm3, %ymm1
	vpaddq	%ymm7, %ymm1, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm15, %ymm2
	vpsrlq	$32, %ymm14, %ymm3
	vpaddq	%ymm3, %ymm9, %ymm3
	vmovdqu	%ymm0, 64(%rdi,%rax)
	vmovdqu	%ymm1, 32(%rdi,%rax)
	vmovdqu	%ymm2, (%rdi,%rax)
	vmovdqu	%ymm3, 96(%rdi,%rax)
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
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI1_1:
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.byte	0                       # 0x0
	.byte	4                       # 0x4
	.byte	8                       # 0x8
	.byte	12                      # 0xc
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI1_2:
	.byte	0                       # 0x0
	.byte	4                       # 0x4
	.byte	8                       # 0x8
	.byte	12                      # 0xc
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI1_3:
	.zero	16,128
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI1_4:
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	3                       # 0x3
.LCPI1_5:
	.long	4                       # 0x4
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	6                       # 0x6
	.long	7                       # 0x7
	.long	7                       # 0x7
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
	movl	%edx, %r14d
	shrl	%r14d
	movq	%rdx, %rax
	movq	%rdx, 160(%rsp)         # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	subl	%r14d, %edx
	movq	%rdx, %r15
	shlq	$7, %r15
	leaq	(%rsi,%r15), %r12
	cmpl	%edx, %r14d
	jne	.LBB1_19
# %bb.1:                                # %for_test.i.preheader
	leal	-1(%r14), %eax
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpbroadcastq	.LCPI1_0(%rip), %ymm0 # ymm0 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
	vmovdqa	%ymm0, 96(%rsp)         # 32-byte Spill
                                        # implicit-def: $xmm1
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vmovdqa	%ymm0, 128(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB1_2:                                # %for_test.i
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa	96(%rsp), %ymm0         # 32-byte Reload
	vpxor	96(%r13,%rcx), %ymm0, %ymm11
	vpxor	96(%r12,%rcx), %ymm0, %ymm12
	vpcmpgtq	%ymm11, %ymm12, %ymm2
	vextracti128	$1, %ymm2, %xmm4
	vpxor	64(%r13,%rcx), %ymm0, %ymm13
	vpackssdw	%xmm4, %xmm2, %xmm2
	vpxor	64(%r12,%rcx), %ymm0, %ymm14
	vpcmpgtq	%ymm13, %ymm14, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vpxor	32(%r13,%rcx), %ymm0, %ymm15
	vinserti128	$1, %xmm2, %ymm4, %ymm5
	vpxor	32(%r12,%rcx), %ymm0, %ymm2
	vpcmpgtq	%ymm15, %ymm2, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm7
	vpxor	(%r13,%rcx), %ymm0, %ymm6
	vpxor	(%r12,%rcx), %ymm0, %ymm4
	vpcmpgtq	%ymm6, %ymm4, %ymm0
	vextracti128	$1, %ymm0, %xmm8
	vpackssdw	%xmm8, %xmm0, %xmm0
	vinserti128	$1, %xmm7, %ymm0, %ymm0
	vmovdqa	%ymm3, 64(%rsp)         # 32-byte Spill
	vpand	%ymm3, %ymm0, %ymm0
	vpand	128(%rsp), %ymm5, %ymm5 # 32-byte Folded Reload
	vextracti128	$1, %ymm5, %xmm7
	vmovdqa	.LCPI1_1(%rip), %xmm3   # xmm3 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vpshufb	%xmm3, %xmm7, %xmm7
	vpshufb	%xmm3, %xmm5, %xmm3
	vpunpckldq	%xmm7, %xmm3, %xmm8 # xmm8 = xmm3[0],xmm7[0],xmm3[1],xmm7[1]
	vextracti128	$1, %ymm0, %xmm7
	vmovdqa	.LCPI1_2(%rip), %xmm3   # xmm3 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm3, %xmm7, %xmm7
	vpshufb	%xmm3, %xmm0, %xmm3
	vpunpckldq	%xmm7, %xmm3, %xmm3 # xmm3 = xmm3[0],xmm7[0],xmm3[1],xmm7[1]
	vpblendd	$12, %xmm8, %xmm3, %xmm3 # xmm3 = xmm3[0,1],xmm8[2,3]
	vpsllw	$7, %xmm3, %xmm3
	vpand	.LCPI1_3(%rip), %xmm3, %xmm3
	vpxor	%xmm7, %xmm7, %xmm7
	vpcmpgtb	%xmm3, %xmm7, %xmm3
	vpor	%xmm1, %xmm3, %xmm1
	vpor	%ymm5, %ymm10, %ymm10
	vpor	%ymm0, %ymm9, %ymm9
	vmovmskps	%ymm9, %ecx
	vmovmskps	%ymm10, %esi
	shll	$8, %esi
	orl	%ecx, %esi
	cmpl	$65535, %esi            # imm = 0xFFFF
	je	.LBB1_5
# %bb.3:                                # %no_return.i
                                        #   in Loop: Header=BB1_2 Depth=1
	vpcmpgtq	%ymm2, %ymm15, %ymm0
	vextracti128	$1, %ymm0, %xmm2
	vpackssdw	%xmm2, %xmm0, %xmm0
	vpcmpgtq	%ymm4, %ymm6, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vandnps	64(%rsp), %ymm9, %ymm3  # 32-byte Folded Reload
	vpcmpgtq	%ymm12, %ymm11, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vandnps	128(%rsp), %ymm10, %ymm5 # 32-byte Folded Reload
	vpcmpgtq	%ymm14, %ymm13, %ymm6
	vpxor	%xmm11, %xmm11, %xmm11
	vinserti128	$1, %xmm0, %ymm2, %ymm7
	vpxor	%xmm8, %xmm8, %xmm8
	vblendvps	%ymm7, %ymm3, %ymm8, %ymm7
	vblendvps	%xmm2, %xmm3, %xmm11, %xmm2
	vextractf128	$1, %ymm3, %xmm3
	vblendvps	%xmm0, %xmm3, %xmm11, %xmm0
	vextracti128	$1, %ymm6, %xmm3
	vpackssdw	%xmm3, %xmm6, %xmm3
	vinserti128	$1, %xmm4, %ymm3, %ymm6
	vblendvps	%ymm6, %ymm5, %ymm8, %ymm6
	vblendvps	%xmm3, %xmm5, %xmm11, %xmm3
	vextractf128	$1, %ymm5, %xmm5
	vblendvps	%xmm4, %xmm5, %xmm11, %xmm4
	vmovdqa	.LCPI1_2(%rip), %xmm5   # xmm5 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm5, %xmm2, %xmm2
	vpshufb	%xmm5, %xmm0, %xmm0
	vpunpckldq	%xmm0, %xmm2, %xmm0 # xmm0 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
	vmovdqa	.LCPI1_1(%rip), %xmm5   # xmm5 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vpshufb	%xmm5, %xmm3, %xmm2
	vpshufb	%xmm5, %xmm4, %xmm3
	vpunpckldq	%xmm3, %xmm2, %xmm2 # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
	vpblendd	$12, %xmm2, %xmm0, %xmm0 # xmm0 = xmm0[0,1],xmm2[2,3]
	vpsllw	$7, %xmm0, %xmm0
	vpand	.LCPI1_3(%rip), %xmm0, %xmm0
	vpcmpgtb	%xmm0, %xmm11, %xmm0
	vpandn	%xmm1, %xmm0, %xmm1
	vorps	%ymm7, %ymm9, %ymm9
	vorps	%ymm6, %ymm10, %ymm10
	vmovmskps	%ymm9, %ecx
	vmovmskps	%ymm10, %esi
	shll	$8, %esi
	orl	%ecx, %esi
	cmpl	$65535, %esi            # imm = 0xFFFF
	je	.LBB1_5
# %bb.4:                                # %no_return43.i
                                        #   in Loop: Header=BB1_2 Depth=1
	vmovaps	64(%rsp), %ymm3         # 32-byte Reload
	vandnps	%ymm3, %ymm9, %ymm3
	vmovaps	128(%rsp), %ymm0        # 32-byte Reload
	vandnps	%ymm0, %ymm10, %ymm0
	vmovaps	%ymm0, 128(%rsp)        # 32-byte Spill
	decl	%eax
	jmp	.LBB1_2
.LBB1_19:                               # %if_else
	movl	%r14d, %r9d
	shlq	$7, %r9
	vmovdqu	(%r13,%r9), %ymm14
	vmovdqu	32(%r13,%r9), %ymm15
	vmovdqu	64(%r13,%r9), %ymm2
	vmovdqu	96(%r13,%r9), %ymm0
	vpxor	%xmm4, %xmm4, %xmm4
	vmovdqa	%ymm0, 288(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm4, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm1
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm4, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm3
	vinserti128	$1, %xmm1, %ymm3, %ymm7
	vpcmpeqq	%ymm4, %ymm15, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpackssdw	%xmm3, %xmm1, %xmm3
	vpcmpeqq	%ymm4, %ymm14, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm5
	vinserti128	$1, %xmm3, %ymm5, %ymm6
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
	vmovmskps	%ymm1, %eax
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	cmpl	$65535, %ecx            # imm = 0xFFFF
	je	.LBB1_23
# %bb.20:                               # %for_test.i377.preheader
	vmovdqa	%ymm15, 256(%rsp)       # 32-byte Spill
	vmovdqa	%ymm14, 224(%rsp)       # 32-byte Spill
	vmovdqa	%ymm6, 320(%rsp)        # 32-byte Spill
	vmovmskps	%ymm6, %eax
	vmovdqa	%ymm7, 96(%rsp)         # 32-byte Spill
	vmovmskps	%ymm7, %ecx
	shlq	$8, %rcx
	orq	%rax, %rcx
	leal	-1(%r14), %edi
	vpbroadcastq	.LCPI1_0(%rip), %ymm0 # ymm0 = [9223372036854775808,9223372036854775808,9223372036854775808,9223372036854775808]
	vmovdqa	%ymm0, 352(%rsp)        # 32-byte Spill
                                        # implicit-def: $xmm8
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm10, %xmm10, %xmm10
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vmovdqa	%ymm0, 128(%rsp)        # 32-byte Spill
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vmovdqa	%ymm0, 64(%rsp)         # 32-byte Spill
	.p2align	4, 0x90
.LBB1_21:                               # %for_test.i377
                                        # =>This Inner Loop Header: Depth=1
	movl	%edi, %eax
	shlq	$7, %rax
	vmovdqa	352(%rsp), %ymm0        # 32-byte Reload
	vpxor	96(%r13,%rax), %ymm0, %ymm11
	vpxor	96(%r12,%rax), %ymm0, %ymm12
	vpcmpgtq	%ymm11, %ymm12, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpxor	64(%r13,%rax), %ymm0, %ymm13
	vpxor	64(%r12,%rax), %ymm0, %ymm9
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpcmpgtq	%ymm13, %ymm9, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm5
	vpxor	32(%r13,%rax), %ymm0, %ymm3
	vpxor	32(%r12,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vpcmpgtq	%ymm3, %ymm4, %ymm1
	vextracti128	$1, %ymm1, %xmm5
	vpackssdw	%xmm5, %xmm1, %xmm6
	vpxor	(%r13,%rax), %ymm0, %ymm5
	vpxor	(%r12,%rax), %ymm0, %ymm1
	vpcmpgtq	%ymm5, %ymm1, %ymm7
	vextracti128	$1, %ymm7, %xmm14
	vpackssdw	%xmm14, %xmm7, %xmm7
	vinserti128	$1, %xmm6, %ymm7, %ymm6
	vpand	64(%rsp), %ymm6, %ymm6  # 32-byte Folded Reload
	vpand	128(%rsp), %ymm2, %ymm2 # 32-byte Folded Reload
	vextracti128	$1, %ymm2, %xmm7
	vmovdqa	.LCPI1_1(%rip), %xmm0   # xmm0 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vpshufb	%xmm0, %xmm7, %xmm7
	vpshufb	%xmm0, %xmm2, %xmm0
	vpunpckldq	%xmm7, %xmm0, %xmm14 # xmm14 = xmm0[0],xmm7[0],xmm0[1],xmm7[1]
	vextracti128	$1, %ymm6, %xmm7
	vmovdqa	.LCPI1_2(%rip), %xmm0   # xmm0 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm0, %xmm7, %xmm7
	vpshufb	%xmm0, %xmm6, %xmm0
	vpunpckldq	%xmm7, %xmm0, %xmm0 # xmm0 = xmm0[0],xmm7[0],xmm0[1],xmm7[1]
	vpblendd	$12, %xmm14, %xmm0, %xmm0 # xmm0 = xmm0[0,1],xmm14[2,3]
	vpsllw	$7, %xmm0, %xmm0
	vmovdqa	.LCPI1_3(%rip), %xmm14  # xmm14 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpand	%xmm0, %xmm14, %xmm0
	vpxor	%xmm14, %xmm14, %xmm14
	vpcmpgtb	%xmm0, %xmm14, %xmm0
	vpor	%xmm0, %xmm8, %xmm8
	vmovdqa	96(%rsp), %ymm7         # 32-byte Reload
	vpand	%ymm7, %ymm2, %ymm0
	vpor	%ymm0, %ymm10, %ymm10
	vmovdqa	320(%rsp), %ymm2        # 32-byte Reload
	vpand	%ymm2, %ymm6, %ymm0
	vmovdqa	%ymm2, %ymm6
	vpor	%ymm0, %ymm15, %ymm15
	vmovmskps	%ymm15, %eax
	vmovmskps	%ymm10, %esi
	shlq	$8, %rsi
	orq	%rax, %rsi
	cmpq	%rsi, %rcx
	je	.LBB1_22
# %bb.27:                               # %no_return.i394
                                        #   in Loop: Header=BB1_21 Depth=1
	vpcmpgtq	%ymm4, %ymm3, %ymm0
	vextracti128	$1, %ymm0, %xmm2
	vpackssdw	%xmm2, %xmm0, %xmm0
	vpcmpgtq	%ymm1, %ymm5, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpgtq	%ymm12, %ymm11, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vmovaps	64(%rsp), %ymm11        # 32-byte Reload
	vandnps	%ymm11, %ymm15, %ymm3
	vpcmpgtq	%ymm9, %ymm13, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vinserti128	$1, %xmm0, %ymm1, %ymm5
	vpxor	%xmm9, %xmm9, %xmm9
	vblendvps	%ymm5, %ymm3, %ymm9, %ymm5
	vblendvps	%xmm1, %xmm3, %xmm14, %xmm1
	vextractf128	$1, %ymm3, %xmm3
	vblendvps	%xmm0, %xmm3, %xmm14, %xmm0
	vandnps	128(%rsp), %ymm10, %ymm3 # 32-byte Folded Reload
	vmovdqa	%ymm7, %ymm12
	vmovdqa	.LCPI1_2(%rip), %xmm7   # xmm7 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm7, %xmm1, %xmm1
	vpshufb	%xmm7, %xmm0, %xmm0
	vpunpckldq	%xmm0, %xmm1, %xmm0 # xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
	vinserti128	$1, %xmm2, %ymm4, %ymm1
	vblendvps	%ymm1, %ymm3, %ymm9, %ymm1
	vblendvps	%xmm4, %xmm3, %xmm14, %xmm4
	vextractf128	$1, %ymm3, %xmm3
	vblendvps	%xmm2, %xmm3, %xmm14, %xmm2
	vmovdqa	.LCPI1_1(%rip), %xmm3   # xmm3 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vmovdqa	%ymm6, %ymm9
	vmovdqa	%xmm3, %xmm6
	vpshufb	%xmm3, %xmm4, %xmm3
	vpshufb	%xmm6, %xmm2, %xmm2
	vpunpckldq	%xmm2, %xmm3, %xmm2 # xmm2 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
	vpblendd	$12, %xmm2, %xmm0, %xmm0 # xmm0 = xmm0[0,1],xmm2[2,3]
	vpsllw	$7, %xmm0, %xmm0
	vpand	.LCPI1_3(%rip), %xmm0, %xmm0
	vpcmpgtb	%xmm0, %xmm14, %xmm0
	vpandn	%xmm8, %xmm0, %xmm8
	vandps	%ymm5, %ymm9, %ymm0
	vorps	%ymm0, %ymm15, %ymm15
	vandps	%ymm1, %ymm12, %ymm0
	vorps	%ymm0, %ymm10, %ymm10
	vmovmskps	%ymm15, %eax
	vmovmskps	%ymm10, %esi
	shlq	$8, %rsi
	orq	%rax, %rsi
	cmpq	%rsi, %rcx
	je	.LBB1_28
# %bb.29:                               # %no_return43.i400
                                        #   in Loop: Header=BB1_21 Depth=1
	vmovaps	%ymm11, %ymm0
	vandnps	%ymm11, %ymm15, %ymm0
	vmovaps	%ymm0, 64(%rsp)         # 32-byte Spill
	vmovaps	128(%rsp), %ymm1        # 32-byte Reload
	vandnps	%ymm1, %ymm10, %ymm1
	vmovaps	%ymm1, 128(%rsp)        # 32-byte Spill
	decl	%edi
	jmp	.LBB1_21
.LBB1_5:                                # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vpshufd	$78, %xmm1, %xmm0       # xmm0 = xmm1[2,3,0,1]
	vpmovsxbd	%xmm0, %ymm0
	vpmovsxbd	%xmm1, %ymm1
	vmovmskps	%ymm1, %r9d
	vmovmskps	%ymm0, %r10d
	movl	%r10d, %eax
	shll	$8, %eax
	orl	%r9d, %eax
	je	.LBB1_11
# %bb.6:                                # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	testl	%r14d, %r14d
	je	.LBB1_11
# %bb.7:                                # %for_loop.i548.lr.ph
	vmovaps	.LCPI1_4(%rip), %ymm4   # ymm4 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm1, %ymm4, %ymm2
	vmovaps	.LCPI1_5(%rip), %ymm5   # ymm5 = [4,4,5,5,6,6,7,7]
	vpermps	%ymm1, %ymm5, %ymm3
	vpermps	%ymm0, %ymm4, %ymm4
	vpermps	%ymm0, %ymm5, %ymm5
	movl	%r14d, %eax
	notl	%eax
	movl	%r14d, %r8d
	andl	$1, %r8d
	addl	160(%rsp), %eax         # 4-byte Folded Reload
	jne	.LBB1_75
# %bb.8:
	vxorps	%xmm7, %xmm7, %xmm7
	xorl	%ecx, %ecx
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	jmp	.LBB1_9
.LBB1_75:                               # %for_loop.i548.lr.ph.new
	leaq	(%r15,%r13), %rdi
	addq	$128, %rdi
	movl	%r14d, %esi
	subl	%r8d, %esi
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	vxorps	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB1_76:                               # %for_loop.i548
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	-128(%rdi,%rax), %ymm11
	vmovdqu	-96(%rdi,%rax), %ymm12
	vmovdqu	-64(%rdi,%rax), %ymm13
	vmovdqu	-32(%rdi,%rax), %ymm14
	vpsubq	96(%r13,%rax), %ymm14, %ymm14
	vpsubq	64(%r13,%rax), %ymm13, %ymm13
	vpaddq	%ymm10, %ymm14, %ymm10
	vpaddq	%ymm9, %ymm13, %ymm9
	vpsubq	32(%r13,%rax), %ymm12, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpsubq	(%r13,%rax), %ymm11, %ymm11
	vpaddq	%ymm7, %ymm11, %ymm7
	vpblendd	$170, %ymm6, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm6[1],ymm10[2],ymm6[3],ymm10[4],ymm6[5],ymm10[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm7, %ymm14 # ymm14 = ymm7[0],ymm6[1],ymm7[2],ymm6[3],ymm7[4],ymm6[5],ymm7[6],ymm6[7]
	vmaskmovpd	%ymm14, %ymm2, (%rbx,%rax)
	vmaskmovpd	%ymm13, %ymm3, 32(%rbx,%rax)
	vmaskmovpd	%ymm12, %ymm4, 64(%rbx,%rax)
	vmaskmovpd	%ymm11, %ymm5, 96(%rbx,%rax)
	vpsrad	$31, %ymm10, %ymm11
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm10, %ymm10 # ymm10 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpsrad	$31, %ymm8, %ymm11
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm11[1],ymm8[2],ymm11[3],ymm8[4],ymm11[5],ymm8[6],ymm11[7]
	vpsrad	$31, %ymm7, %ymm11
	vpshufd	$245, %ymm7, %ymm7      # ymm7 = ymm7[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm7, %ymm7 # ymm7 = ymm7[0],ymm11[1],ymm7[2],ymm11[3],ymm7[4],ymm11[5],ymm7[6],ymm11[7]
	vmovdqu	(%rdi,%rax), %ymm11
	vmovdqu	32(%rdi,%rax), %ymm12
	vmovdqu	64(%rdi,%rax), %ymm13
	vmovdqu	96(%rdi,%rax), %ymm14
	vpsubq	224(%r13,%rax), %ymm14, %ymm14
	vpsubq	192(%r13,%rax), %ymm13, %ymm13
	vpaddq	%ymm10, %ymm14, %ymm10
	vpaddq	%ymm9, %ymm13, %ymm9
	vpsubq	160(%r13,%rax), %ymm12, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpsubq	128(%r13,%rax), %ymm11, %ymm11
	vpaddq	%ymm7, %ymm11, %ymm7
	vpblendd	$170, %ymm6, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm6[1],ymm10[2],ymm6[3],ymm10[4],ymm6[5],ymm10[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm7, %ymm14 # ymm14 = ymm7[0],ymm6[1],ymm7[2],ymm6[3],ymm7[4],ymm6[5],ymm7[6],ymm6[7]
	vmaskmovpd	%ymm14, %ymm2, 128(%rbx,%rax)
	vmaskmovpd	%ymm13, %ymm3, 160(%rbx,%rax)
	vmaskmovpd	%ymm12, %ymm4, 192(%rbx,%rax)
	vmaskmovpd	%ymm11, %ymm5, 224(%rbx,%rax)
	vpsrad	$31, %ymm10, %ymm11
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm10, %ymm10 # ymm10 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpsrad	$31, %ymm8, %ymm11
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm11[1],ymm8[2],ymm11[3],ymm8[4],ymm11[5],ymm8[6],ymm11[7]
	vpsrad	$31, %ymm7, %ymm11
	vpshufd	$245, %ymm7, %ymm7      # ymm7 = ymm7[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm7, %ymm7 # ymm7 = ymm7[0],ymm11[1],ymm7[2],ymm11[3],ymm7[4],ymm11[5],ymm7[6],ymm11[7]
	addq	$2, %rcx
	addq	$256, %rax              # imm = 0x100
	cmpl	%ecx, %esi
	jne	.LBB1_76
.LBB1_9:                                # %for_test.i536.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_11
# %bb.10:                               # %for_loop.i548.epil.preheader
	shlq	$7, %rcx
	vmovdqu	(%r12,%rcx), %ymm6
	vmovdqu	32(%r12,%rcx), %ymm11
	vmovdqu	96(%r12,%rcx), %ymm12
	vpsubq	96(%r13,%rcx), %ymm12, %ymm12
	vmovdqu	64(%r12,%rcx), %ymm13
	vpaddq	%ymm10, %ymm12, %ymm10
	vpsubq	64(%r13,%rcx), %ymm13, %ymm12
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	32(%r13,%rcx), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpsubq	(%r13,%rcx), %ymm6, %ymm6
	vpaddq	%ymm7, %ymm6, %ymm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpblendd	$170, %ymm7, %ymm10, %ymm10 # ymm10 = ymm10[0],ymm7[1],ymm10[2],ymm7[3],ymm10[4],ymm7[5],ymm10[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm7[1],ymm9[2],ymm7[3],ymm9[4],ymm7[5],ymm9[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm7[1],ymm8[2],ymm7[3],ymm8[4],ymm7[5],ymm8[6],ymm7[7]
	vpblendd	$170, %ymm7, %ymm6, %ymm6 # ymm6 = ymm6[0],ymm7[1],ymm6[2],ymm7[3],ymm6[4],ymm7[5],ymm6[6],ymm7[7]
	vmaskmovpd	%ymm6, %ymm2, (%rbx,%rcx)
	vmaskmovpd	%ymm8, %ymm3, 32(%rbx,%rcx)
	vmaskmovpd	%ymm9, %ymm4, 64(%rbx,%rcx)
	vmaskmovpd	%ymm10, %ymm5, 96(%rbx,%rcx)
.LBB1_11:                               # %safe_if_after_true
	xorl	$255, %r9d
	xorl	$255, %r10d
	shll	$8, %r10d
	orl	%r9d, %r10d
	je	.LBB1_17
# %bb.12:                               # %safe_if_after_true
	testl	%r14d, %r14d
	je	.LBB1_17
# %bb.13:                               # %for_loop.i525.lr.ph
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vpxor	%ymm2, %ymm0, %ymm3
	vmovdqa	.LCPI1_4(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm0
	vmovdqa	.LCPI1_5(%rip), %ymm4   # ymm4 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm4, %ymm1
	vpermd	%ymm3, %ymm2, %ymm2
	vpermd	%ymm3, %ymm4, %ymm3
	movl	%r14d, %eax
	notl	%eax
	movl	%r14d, %r8d
	andl	$1, %r8d
	addl	160(%rsp), %eax         # 4-byte Folded Reload
	jne	.LBB1_77
# %bb.14:
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%eax, %eax
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	jmp	.LBB1_15
.LBB1_77:                               # %for_loop.i525.lr.ph.new
	leaq	(%r15,%r13), %rcx
	addq	$128, %rcx
	movl	%r14d, %esi
	subl	%r8d, %esi
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%edi, %edi
	xorl	%eax, %eax
	vpxor	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB1_78:                               # %for_loop.i525
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%r13,%rdi), %ymm9
	vmovdqu	32(%r13,%rdi), %ymm10
	vmovdqu	64(%r13,%rdi), %ymm11
	vmovdqu	96(%r13,%rdi), %ymm12
	vpsubq	-32(%rcx,%rdi), %ymm12, %ymm12
	vpsubq	-64(%rcx,%rdi), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm12, %ymm8
	vpaddq	%ymm7, %ymm11, %ymm7
	vpsubq	-96(%rcx,%rdi), %ymm10, %ymm10
	vpaddq	%ymm6, %ymm10, %ymm6
	vpsubq	-128(%rcx,%rdi), %ymm9, %ymm9
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
	vpsubq	96(%rcx,%rdi), %ymm12, %ymm12
	vpsubq	64(%rcx,%rdi), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm12, %ymm8
	vpaddq	%ymm7, %ymm11, %ymm7
	vpsubq	32(%rcx,%rdi), %ymm10, %ymm10
	vpaddq	%ymm6, %ymm10, %ymm6
	vpsubq	(%rcx,%rdi), %ymm9, %ymm9
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
	jne	.LBB1_78
.LBB1_15:                               # %for_test.i513.if_exit.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_17
# %bb.16:                               # %for_loop.i525.epil.preheader
	shlq	$7, %rax
	vmovdqu	(%r13,%rax), %ymm4
	vmovdqu	32(%r13,%rax), %ymm9
	vmovdqu	96(%r13,%rax), %ymm10
	vpsubq	96(%r12,%rax), %ymm10, %ymm10
	vmovdqu	64(%r13,%rax), %ymm11
	vpaddq	%ymm8, %ymm10, %ymm8
	vpsubq	64(%r12,%rax), %ymm11, %ymm10
	vpaddq	%ymm7, %ymm10, %ymm7
	vpsubq	32(%r12,%rax), %ymm9, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpsubq	(%r12,%rax), %ymm4, %ymm4
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
	jmp	.LBB1_17
.LBB1_28:
	vmovaps	%ymm12, %ymm7
	vmovaps	%ymm9, %ymm6
.LBB1_22:
	vmovdqa	224(%rsp), %ymm14       # 32-byte Reload
	vmovdqa	256(%rsp), %ymm15       # 32-byte Reload
	vpshufd	$78, %xmm8, %xmm0       # xmm0 = xmm8[2,3,0,1]
	vpmovsxbd	%xmm0, %ymm0
	vpmovsxbd	%xmm8, %ymm1
	vpand	%ymm6, %ymm1, %ymm6
	vpand	%ymm7, %ymm0, %ymm7
.LBB1_23:                               # %logical_op_done
	vmovmskps	%ymm6, %r10d
	vmovmskps	%ymm7, %r11d
	movl	%r11d, %eax
	shll	$8, %eax
	orl	%r10d, %eax
	je	.LBB1_79
# %bb.24:                               # %for_test.i484.preheader
	vmovdqa	.LCPI1_4(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vmovdqa	%ymm6, %ymm3
	vpermd	%ymm6, %ymm0, %ymm6
	vmovdqa	.LCPI1_5(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovdqa	%ymm7, %ymm2
	vmovdqa	%ymm3, 320(%rsp)        # 32-byte Spill
	vpermd	%ymm3, %ymm1, %ymm7
	vpermd	%ymm2, %ymm0, %ymm8
	vmovdqa	%ymm2, 96(%rsp)         # 32-byte Spill
	vpermd	%ymm2, %ymm1, %ymm9
	testl	%r14d, %r14d
	je	.LBB1_85
# %bb.25:                               # %for_loop.i496.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, %r14d
	jne	.LBB1_81
# %bb.26:
	xorl	%esi, %esi
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm10, %xmm10, %xmm10
	vxorps	%xmm11, %xmm11, %xmm11
	jmp	.LBB1_84
.LBB1_81:                               # %for_loop.i496.lr.ph.new
	movl	%r14d, %r8d
	andl	$1, %r8d
	leaq	(%r15,%r13), %rdi
	addq	$128, %rdi
	movl	%r14d, %eax
	subl	%r8d, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm10, %xmm10, %xmm10
	vxorps	%xmm11, %xmm11, %xmm11
	.p2align	4, 0x90
.LBB1_82:                               # %for_loop.i496
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	-128(%rdi,%rcx), %ymm4
	vmovdqu	-96(%rdi,%rcx), %ymm5
	vmovdqu	-64(%rdi,%rcx), %ymm12
	vmovdqu	-32(%rdi,%rcx), %ymm13
	vpsubq	96(%r13,%rcx), %ymm13, %ymm13
	vpsubq	64(%r13,%rcx), %ymm12, %ymm12
	vpaddq	%ymm11, %ymm13, %ymm11
	vpaddq	%ymm10, %ymm12, %ymm10
	vpsubq	32(%r13,%rcx), %ymm5, %ymm5
	vpaddq	%ymm3, %ymm5, %ymm3
	vpsubq	(%r13,%rcx), %ymm4, %ymm4
	vpaddq	%ymm2, %ymm4, %ymm2
	vpblendd	$170, %ymm1, %ymm11, %ymm4 # ymm4 = ymm11[0],ymm1[1],ymm11[2],ymm1[3],ymm11[4],ymm1[5],ymm11[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm10, %ymm5 # ymm5 = ymm10[0],ymm1[1],ymm10[2],ymm1[3],ymm10[4],ymm1[5],ymm10[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmaskmovpd	%ymm13, %ymm6, (%rbx,%rcx)
	vmaskmovpd	%ymm12, %ymm7, 32(%rbx,%rcx)
	vmaskmovpd	%ymm5, %ymm8, 64(%rbx,%rcx)
	vmaskmovpd	%ymm4, %ymm9, 96(%rbx,%rcx)
	vpsrad	$31, %ymm11, %ymm4
	vpshufd	$245, %ymm11, %ymm5     # ymm5 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm5, %ymm4 # ymm4 = ymm5[0],ymm4[1],ymm5[2],ymm4[3],ymm5[4],ymm4[5],ymm5[6],ymm4[7]
	vpsrad	$31, %ymm10, %ymm5
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm5, %ymm10, %ymm5 # ymm5 = ymm10[0],ymm5[1],ymm10[2],ymm5[3],ymm10[4],ymm5[5],ymm10[6],ymm5[7]
	vpsrad	$31, %ymm3, %ymm10
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm10[1],ymm3[2],ymm10[3],ymm3[4],ymm10[5],ymm3[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm10
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm10[1],ymm2[2],ymm10[3],ymm2[4],ymm10[5],ymm2[6],ymm10[7]
	vmovdqu	(%rdi,%rcx), %ymm10
	vmovdqu	32(%rdi,%rcx), %ymm11
	vmovdqu	64(%rdi,%rcx), %ymm12
	vmovdqu	96(%rdi,%rcx), %ymm13
	vpsubq	224(%r13,%rcx), %ymm13, %ymm13
	vpsubq	192(%r13,%rcx), %ymm12, %ymm12
	vpaddq	%ymm4, %ymm13, %ymm4
	vpaddq	%ymm5, %ymm12, %ymm5
	vpsubq	160(%r13,%rcx), %ymm11, %ymm11
	vpaddq	%ymm3, %ymm11, %ymm3
	vpsubq	128(%r13,%rcx), %ymm10, %ymm10
	vpaddq	%ymm2, %ymm10, %ymm2
	vpblendd	$170, %ymm1, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmaskmovpd	%ymm13, %ymm6, 128(%rbx,%rcx)
	vmaskmovpd	%ymm12, %ymm7, 160(%rbx,%rcx)
	vmaskmovpd	%ymm11, %ymm8, 192(%rbx,%rcx)
	vmaskmovpd	%ymm10, %ymm9, 224(%rbx,%rcx)
	vpsrad	$31, %ymm4, %ymm10
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm10[1],ymm4[2],ymm10[3],ymm4[4],ymm10[5],ymm4[6],ymm10[7]
	vpsrad	$31, %ymm5, %ymm4
	vpshufd	$245, %ymm5, %ymm5      # ymm5 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm5, %ymm10 # ymm10 = ymm5[0],ymm4[1],ymm5[2],ymm4[3],ymm5[4],ymm4[5],ymm5[6],ymm4[7]
	vpsrad	$31, %ymm3, %ymm4
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpsrad	$31, %ymm2, %ymm4
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm4, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	addq	$2, %rsi
	addq	$256, %rcx              # imm = 0x100
	cmpl	%esi, %eax
	jne	.LBB1_82
# %bb.83:                               # %for_test.i484.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit497_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_85
.LBB1_84:                               # %for_loop.i496.epil.preheader
	shlq	$7, %rsi
	vmovdqu	(%r12,%rsi), %ymm1
	vmovdqu	32(%r12,%rsi), %ymm4
	vmovdqu	64(%r12,%rsi), %ymm5
	vmovdqu	96(%r12,%rsi), %ymm12
	vpsubq	96(%r13,%rsi), %ymm12, %ymm12
	vpsubq	64(%r13,%rsi), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm12, %ymm11
	vpaddq	%ymm5, %ymm10, %ymm5
	vpsubq	32(%r13,%rsi), %ymm4, %ymm4
	vpaddq	%ymm3, %ymm4, %ymm3
	vpsubq	(%r13,%rsi), %ymm1, %ymm1
	vpaddq	%ymm2, %ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm11, %ymm2 # ymm2 = ymm11[0],ymm0[1],ymm11[2],ymm0[3],ymm11[4],ymm0[5],ymm11[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm5, %ymm4 # ymm4 = ymm5[0],ymm0[1],ymm5[2],ymm0[3],ymm5[4],ymm0[5],ymm5[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm0 # ymm0 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmaskmovpd	%ymm0, %ymm6, (%rbx,%rsi)
	vmaskmovpd	%ymm3, %ymm7, 32(%rbx,%rsi)
	vmaskmovpd	%ymm4, %ymm8, 64(%rbx,%rsi)
	vmaskmovpd	%ymm2, %ymm9, 96(%rbx,%rsi)
.LBB1_85:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit497
	vxorpd	%xmm0, %xmm0, %xmm0
	vmaskmovpd	%ymm0, %ymm6, (%rbx,%r9)
	vmaskmovpd	%ymm0, %ymm7, 32(%rbx,%r9)
	vmaskmovpd	%ymm0, %ymm8, 64(%rbx,%r9)
	vmaskmovpd	%ymm0, %ymm9, 96(%rbx,%r9)
	vmovaps	96(%rsp), %ymm7         # 32-byte Reload
	vmovaps	320(%rsp), %ymm6        # 32-byte Reload
.LBB1_79:                               # %safe_if_after_true57
	xorl	$255, %r10d
	xorl	$255, %r11d
	shll	$8, %r11d
	orl	%r10d, %r11d
	je	.LBB1_80
# %bb.86:                               # %safe_if_run_false75
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpxor	%ymm0, %ymm6, %ymm1
	vpxor	%ymm0, %ymm7, %ymm0
	addq	%rbx, %r9
	vmovdqa	.LCPI1_4(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI1_5(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	testl	%r14d, %r14d
	je	.LBB1_87
# %bb.88:                               # %for_loop.i.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, %r14d
	jne	.LBB1_90
# %bb.89:
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm8, %xmm8, %xmm8
	jmp	.LBB1_93
.LBB1_87:
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm8, %xmm8, %xmm8
	jmp	.LBB1_94
.LBB1_90:                               # %for_loop.i.lr.ph.new
	movl	%r14d, %r8d
	andl	$1, %r8d
	leaq	(%r15,%r13), %rax
	addq	$128, %rax
	movl	%r14d, %esi
	subl	%r8d, %esi
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%edi, %edi
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB1_91:                               # %for_loop.i
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%r13,%rdi), %ymm10
	vmovdqu	32(%r13,%rdi), %ymm11
	vmovdqu	64(%r13,%rdi), %ymm12
	vmovdqu	96(%r13,%rdi), %ymm13
	vpsubq	-32(%rax,%rdi), %ymm13, %ymm13
	vpsubq	-64(%rax,%rdi), %ymm12, %ymm12
	vpaddq	%ymm8, %ymm13, %ymm8
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	-96(%rax,%rdi), %ymm11, %ymm11
	vpaddq	%ymm3, %ymm11, %ymm3
	vpsubq	-128(%rax,%rdi), %ymm10, %ymm10
	vpaddq	%ymm2, %ymm10, %ymm2
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmaskmovpd	%ymm13, %ymm4, (%rbx,%rdi)
	vmaskmovpd	%ymm12, %ymm5, 32(%rbx,%rdi)
	vmaskmovpd	%ymm11, %ymm6, 64(%rbx,%rdi)
	vmaskmovpd	%ymm10, %ymm7, 96(%rbx,%rdi)
	vpsrad	$31, %ymm8, %ymm10
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm10[1],ymm8[2],ymm10[3],ymm8[4],ymm10[5],ymm8[6],ymm10[7]
	vpsrad	$31, %ymm9, %ymm10
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpsrad	$31, %ymm3, %ymm10
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm10[1],ymm3[2],ymm10[3],ymm3[4],ymm10[5],ymm3[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm10
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm10[1],ymm2[2],ymm10[3],ymm2[4],ymm10[5],ymm2[6],ymm10[7]
	vmovdqu	128(%r13,%rdi), %ymm10
	vmovdqu	160(%r13,%rdi), %ymm11
	vmovdqu	192(%r13,%rdi), %ymm12
	vmovdqu	224(%r13,%rdi), %ymm13
	vpsubq	96(%rax,%rdi), %ymm13, %ymm13
	vpsubq	64(%rax,%rdi), %ymm12, %ymm12
	vpaddq	%ymm8, %ymm13, %ymm8
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	32(%rax,%rdi), %ymm11, %ymm11
	vpaddq	%ymm3, %ymm11, %ymm3
	vpsubq	(%rax,%rdi), %ymm10, %ymm10
	vpaddq	%ymm2, %ymm10, %ymm2
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm12 # ymm12 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmaskmovpd	%ymm13, %ymm4, 128(%rbx,%rdi)
	vmaskmovpd	%ymm12, %ymm5, 160(%rbx,%rdi)
	vmaskmovpd	%ymm11, %ymm6, 192(%rbx,%rdi)
	vmaskmovpd	%ymm10, %ymm7, 224(%rbx,%rdi)
	vpsrad	$31, %ymm8, %ymm10
	vpshufd	$245, %ymm8, %ymm8      # ymm8 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm8, %ymm8 # ymm8 = ymm8[0],ymm10[1],ymm8[2],ymm10[3],ymm8[4],ymm10[5],ymm8[6],ymm10[7]
	vpsrad	$31, %ymm9, %ymm10
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpsrad	$31, %ymm3, %ymm10
	vpshufd	$245, %ymm3, %ymm3      # ymm3 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm3, %ymm3 # ymm3 = ymm3[0],ymm10[1],ymm3[2],ymm10[3],ymm3[4],ymm10[5],ymm3[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm10
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm10[1],ymm2[2],ymm10[3],ymm2[4],ymm10[5],ymm2[6],ymm10[7]
	addq	$2, %rcx
	addq	$256, %rdi              # imm = 0x100
	cmpl	%ecx, %esi
	jne	.LBB1_91
# %bb.92:                               # %for_test.i353.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_94
.LBB1_93:                               # %for_loop.i.epil.preheader
	shlq	$7, %rcx
	vmovdqu	(%r13,%rcx), %ymm1
	vmovdqu	32(%r13,%rcx), %ymm10
	vmovdqu	64(%r13,%rcx), %ymm11
	vmovdqu	96(%r13,%rcx), %ymm12
	vpsubq	96(%r12,%rcx), %ymm12, %ymm12
	vpsubq	64(%r12,%rcx), %ymm11, %ymm11
	vpaddq	%ymm8, %ymm12, %ymm8
	vpaddq	%ymm9, %ymm11, %ymm9
	vpsubq	32(%r12,%rcx), %ymm10, %ymm10
	vpaddq	%ymm3, %ymm10, %ymm3
	vpsubq	(%r12,%rcx), %ymm1, %ymm1
	vpaddq	%ymm2, %ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm8, %ymm2 # ymm2 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm0[1],ymm9[2],ymm0[3],ymm9[4],ymm0[5],ymm9[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm11 # ymm11 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm0 # ymm0 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmaskmovpd	%ymm0, %ymm4, (%rbx,%rcx)
	vmaskmovpd	%ymm11, %ymm5, 32(%rbx,%rcx)
	vmaskmovpd	%ymm10, %ymm6, 64(%rbx,%rcx)
	vmaskmovpd	%ymm2, %ymm7, 96(%rbx,%rcx)
	vpsrad	$31, %ymm8, %ymm0
	vpshufd	$245, %ymm8, %ymm2      # ymm2 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpsrad	$31, %ymm9, %ymm0
	vpshufd	$245, %ymm9, %ymm2      # ymm2 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm2      # ymm2 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm2, %ymm3 # ymm3 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpsrad	$31, %ymm1, %ymm0
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm2 # ymm2 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
.LBB1_94:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vpaddq	288(%rsp), %ymm8, %ymm0 # 32-byte Folded Reload
	vpaddq	192(%rsp), %ymm9, %ymm1 # 32-byte Folded Reload
	vpaddq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm2, %ymm14, %ymm2
	vmaskmovpd	%ymm2, %ymm4, (%r9)
	vmaskmovpd	%ymm3, %ymm5, 32(%r9)
	vmaskmovpd	%ymm1, %ymm6, 64(%r9)
	vmaskmovpd	%ymm0, %ymm7, 96(%r9)
.LBB1_80:                               # %if_done56
	leal	-2(,%rdx,4), %eax
	shlq	$7, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 96(%rbx,%rax)
	vmovups	%ymm0, 64(%rbx,%rax)
	vmovups	%ymm0, 32(%rbx,%rax)
	vmovups	%ymm0, (%rbx,%rax)
	leal	-1(,%rdx,4), %eax
	shlq	$7, %rax
	vmovups	%ymm0, 64(%rbx,%rax)
	vmovups	%ymm0, 96(%rbx,%rax)
	vmovups	%ymm0, (%rbx,%rax)
	vmovups	%ymm0, 32(%rbx,%rax)
.LBB1_17:                               # %if_exit
	leal	(%rdx,%rdx), %eax
	movq	%r12, 64(%rsp)          # 8-byte Spill
	movq	%rax, 256(%rsp)         # 8-byte Spill
	movq	%rax, %r12
	shlq	$7, %r12
	leaq	(%rbx,%r12), %rax
	movq	%rax, 96(%rsp)          # 8-byte Spill
	leaq	384(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rdx, 128(%rsp)         # 8-byte Spill
	vzeroupper
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	96(%rsp), %rdi          # 8-byte Reload
	movq	64(%rsp), %rsi          # 8-byte Reload
	movq	%r14, 192(%rsp)         # 8-byte Spill
	movl	%r14d, %edx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%rbx, %rdi
	movq	%r13, %rsi
	movq	128(%rsp), %rdx         # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	128(%rsp), %r14         # 8-byte Reload
	vxorps	%xmm0, %xmm0, %xmm0
	testl	%r14d, %r14d
	je	.LBB1_18
# %bb.30:                               # %for_loop.i423.lr.ph
	movq	192(%rsp), %rax         # 8-byte Reload
	movq	%rax, %r8
                                        # kill: def $eax killed $eax killed $rax
	notl	%eax
	addl	160(%rsp), %eax         # 4-byte Folded Reload
	movl	%r14d, %ecx
	andl	$3, %ecx
	cmpl	$3, %eax
	jae	.LBB1_39
# %bb.31:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%edx, %edx
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	jmp	.LBB1_32
.LBB1_18:
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 320(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 352(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 64(%rsp)         # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 96(%rsp)         # 32-byte Spill
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	jmp	.LBB1_48
.LBB1_39:                               # %for_loop.i423.lr.ph.new
	movl	%r14d, %esi
	subl	%ecx, %esi
	leaq	384(%rbx), %rdi
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%edx, %edx
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB1_40:                               # %for_loop.i423
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-288(%rdi,%r15), %ymm4, %ymm4
	vpaddq	-320(%rdi,%r15), %ymm3, %ymm3
	vpaddq	-384(%rdi,%r15), %ymm1, %ymm1
	vpaddq	-352(%rdi,%r15), %ymm2, %ymm2
	vpaddq	-352(%rdi,%r12), %ymm2, %ymm2
	vpaddq	-384(%rdi,%r12), %ymm1, %ymm1
	vpaddq	-320(%rdi,%r12), %ymm3, %ymm3
	vpaddq	-288(%rdi,%r12), %ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vmovdqu	%ymm9, -352(%rdi,%r12)
	vmovdqu	%ymm8, -384(%rdi,%r12)
	vmovdqu	%ymm7, -320(%rdi,%r12)
	vmovdqu	%ymm6, -288(%rdi,%r12)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm1
	vpaddq	-256(%rdi,%r15), %ymm1, %ymm1
	vpaddq	-224(%rdi,%r15), %ymm2, %ymm2
	vpaddq	-192(%rdi,%r15), %ymm3, %ymm3
	vpaddq	-160(%rdi,%r15), %ymm4, %ymm4
	vpaddq	-160(%rdi,%r12), %ymm4, %ymm4
	vpaddq	-192(%rdi,%r12), %ymm3, %ymm3
	vpaddq	-224(%rdi,%r12), %ymm2, %ymm2
	vpaddq	-256(%rdi,%r12), %ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmovdqu	%ymm9, -160(%rdi,%r12)
	vmovdqu	%ymm8, -192(%rdi,%r12)
	vmovdqu	%ymm7, -224(%rdi,%r12)
	vmovdqu	%ymm6, -256(%rdi,%r12)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm1
	vpaddq	-128(%rdi,%r15), %ymm1, %ymm1
	vpaddq	-96(%rdi,%r15), %ymm2, %ymm2
	vpaddq	-64(%rdi,%r15), %ymm3, %ymm3
	vpaddq	-32(%rdi,%r15), %ymm4, %ymm4
	vpaddq	-32(%rdi,%r12), %ymm4, %ymm4
	vpaddq	-64(%rdi,%r12), %ymm3, %ymm3
	vpaddq	-96(%rdi,%r12), %ymm2, %ymm2
	vpaddq	-128(%rdi,%r12), %ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vmovdqu	%ymm9, -32(%rdi,%r12)
	vmovdqu	%ymm8, -64(%rdi,%r12)
	vmovdqu	%ymm7, -96(%rdi,%r12)
	vmovdqu	%ymm6, -128(%rdi,%r12)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	32(%rdi,%r15), %ymm2, %ymm2
	vpaddq	(%rdi,%r15), %ymm1, %ymm1
	vpaddq	96(%rdi,%r15), %ymm4, %ymm4
	vpaddq	64(%rdi,%r15), %ymm3, %ymm3
	vpaddq	64(%rdi,%r12), %ymm3, %ymm3
	vpaddq	96(%rdi,%r12), %ymm4, %ymm4
	vpaddq	(%rdi,%r12), %ymm1, %ymm1
	vpaddq	32(%rdi,%r12), %ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vmovdqu	%ymm9, 64(%rdi,%r12)
	vmovdqu	%ymm8, 96(%rdi,%r12)
	vmovdqu	%ymm7, (%rdi,%r12)
	vmovdqu	%ymm6, 32(%rdi,%r12)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm1
	addq	$4, %rdx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%edx, %esi
	jne	.LBB1_40
.LBB1_32:                               # %for_test.i412.for_test.i427.preheader_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_35
# %bb.33:                               # %for_loop.i423.epil.preheader
	shlq	$7, %rdx
	addq	%rbx, %rdx
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB1_34:                               # %for_loop.i423.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	96(%rdx,%r15), %ymm4, %ymm4
	vpaddq	64(%rdx,%r15), %ymm3, %ymm3
	vpaddq	32(%rdx,%r15), %ymm2, %ymm2
	vpaddq	(%rdx,%r15), %ymm1, %ymm1
	vpaddq	(%rdx,%r12), %ymm1, %ymm1
	vpaddq	32(%rdx,%r12), %ymm2, %ymm2
	vpaddq	64(%rdx,%r12), %ymm3, %ymm3
	vpaddq	96(%rdx,%r12), %ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm5[1],ymm3[2],ymm5[3],ymm3[4],ymm5[5],ymm3[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm5[1],ymm2[2],ymm5[3],ymm2[4],ymm5[5],ymm2[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm1, %ymm9 # ymm9 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vmovdqu	%ymm9, (%rdx,%r12)
	vmovdqu	%ymm8, 32(%rdx,%r12)
	vmovdqu	%ymm7, 64(%rdx,%r12)
	vmovdqu	%ymm6, 96(%rdx,%r12)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm4, %ymm4
	subq	$-128, %rdx
	decl	%ecx
	jne	.LBB1_34
.LBB1_35:                               # %for_test.i427.preheader
	testl	%r14d, %r14d
	vmovdqa	%ymm3, 64(%rsp)         # 32-byte Spill
	vmovdqa	%ymm4, 96(%rsp)         # 32-byte Spill
	je	.LBB1_36
# %bb.37:                               # %for_loop.i439.lr.ph
	movl	%r14d, %ecx
	andl	$3, %ecx
	cmpl	$3, %eax
	jae	.LBB1_41
# %bb.38:
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	jmp	.LBB1_43
.LBB1_36:
	vpxor	%xmm5, %xmm5, %xmm5
	vmovdqa	%ymm5, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 320(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, %ymm5
	vmovdqa	%ymm2, 352(%rsp)        # 32-byte Spill
	vmovdqa	%ymm2, %ymm6
	vmovdqa	%ymm3, %ymm7
	vmovdqa	%ymm4, %ymm8
	jmp	.LBB1_49
.LBB1_41:                               # %for_loop.i439.lr.ph.new
	movl	%r14d, %esi
	subl	%ecx, %esi
	leaq	384(%rbx), %rdi
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%edx, %edx
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB1_42:                               # %for_loop.i439
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-288(%rdi,%r12), %ymm9, %ymm9
	vpaddq	-320(%rdi,%r12), %ymm8, %ymm8
	vpaddq	-352(%rdi,%r12), %ymm7, %ymm7
	vpaddq	-384(%rdi,%r12), %ymm6, %ymm6
	vpaddq	-384(%rdi), %ymm6, %ymm6
	vpaddq	-352(%rdi), %ymm7, %ymm7
	vpaddq	-320(%rdi), %ymm8, %ymm8
	vpaddq	-288(%rdi), %ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqu	%ymm13, -384(%rdi,%r15)
	vmovdqu	%ymm12, -352(%rdi,%r15)
	vmovdqu	%ymm11, -320(%rdi,%r15)
	vmovdqu	%ymm10, -288(%rdi,%r15)
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpaddq	-192(%rdi,%r12), %ymm8, %ymm8
	vpaddq	-224(%rdi,%r12), %ymm7, %ymm7
	vpaddq	-256(%rdi,%r12), %ymm6, %ymm6
	vpaddq	-160(%rdi,%r12), %ymm9, %ymm9
	vpaddq	-160(%rdi), %ymm9, %ymm9
	vpaddq	-256(%rdi), %ymm6, %ymm6
	vpaddq	-224(%rdi), %ymm7, %ymm7
	vpaddq	-192(%rdi), %ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm9, %ymm13 # ymm13 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vmovdqu	%ymm13, -160(%rdi,%r15)
	vmovdqu	%ymm12, -256(%rdi,%r15)
	vmovdqu	%ymm11, -224(%rdi,%r15)
	vmovdqu	%ymm10, -192(%rdi,%r15)
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpaddq	-64(%rdi,%r12), %ymm8, %ymm8
	vpaddq	-96(%rdi,%r12), %ymm7, %ymm7
	vpaddq	-128(%rdi,%r12), %ymm6, %ymm6
	vpaddq	-32(%rdi,%r12), %ymm9, %ymm9
	vpaddq	-32(%rdi), %ymm9, %ymm9
	vpaddq	-128(%rdi), %ymm6, %ymm6
	vpaddq	-96(%rdi), %ymm7, %ymm7
	vpaddq	-64(%rdi), %ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm9, %ymm13 # ymm13 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vmovdqu	%ymm13, -32(%rdi,%r15)
	vmovdqu	%ymm12, -128(%rdi,%r15)
	vmovdqu	%ymm11, -96(%rdi,%r15)
	vmovdqu	%ymm10, -64(%rdi,%r15)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpaddq	32(%rdi,%r12), %ymm7, %ymm7
	vpaddq	(%rdi,%r12), %ymm6, %ymm6
	vpaddq	96(%rdi,%r12), %ymm9, %ymm9
	vpaddq	64(%rdi,%r12), %ymm8, %ymm8
	vpaddq	64(%rdi), %ymm8, %ymm8
	vpaddq	96(%rdi), %ymm9, %ymm9
	vpaddq	(%rdi), %ymm6, %ymm6
	vpaddq	32(%rdi), %ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqu	%ymm13, 64(%rdi,%r15)
	vmovdqu	%ymm12, 96(%rdi,%r15)
	vmovdqu	%ymm11, (%rdi,%r15)
	vmovdqu	%ymm10, 32(%rdi,%r15)
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	addq	$4, %rdx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%edx, %esi
	jne	.LBB1_42
.LBB1_43:                               # %for_test.i427.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit440_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_46
# %bb.44:                               # %for_loop.i439.epil.preheader
	shlq	$7, %rdx
	addq	%rbx, %rdx
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB1_45:                               # %for_loop.i439.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	96(%rdx,%r12), %ymm9, %ymm9
	vpaddq	32(%rdx,%r12), %ymm7, %ymm7
	vpaddq	(%rdx,%r12), %ymm6, %ymm6
	vpaddq	64(%rdx,%r12), %ymm8, %ymm8
	vpaddq	64(%rdx), %ymm8, %ymm8
	vpaddq	(%rdx), %ymm6, %ymm6
	vpaddq	32(%rdx), %ymm7, %ymm7
	vpaddq	96(%rdx), %ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm5[1],ymm9[2],ymm5[3],ymm9[4],ymm5[5],ymm9[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqu	%ymm13, 64(%rdx,%r15)
	vmovdqu	%ymm12, (%rdx,%r15)
	vmovdqu	%ymm11, 32(%rdx,%r15)
	vmovdqu	%ymm10, 96(%rdx,%r15)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm9, %ymm9
	subq	$-128, %rdx
	decl	%ecx
	jne	.LBB1_45
.LBB1_46:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit440
	vpaddq	%ymm1, %ymm6, %ymm5
	vpaddq	%ymm2, %ymm7, %ymm6
	vpaddq	%ymm3, %ymm8, %ymm7
	vpaddq	%ymm4, %ymm9, %ymm8
	testl	%r14d, %r14d
	je	.LBB1_47
# %bb.50:                               # %for_loop.i456.lr.ph
	movl	%r14d, %ecx
	andl	$3, %ecx
	vmovdqa	%ymm2, %ymm4
	vmovdqa	%ymm1, %ymm3
	cmpl	$3, %eax
	jae	.LBB1_52
# %bb.51:
	vpxor	%xmm10, %xmm10, %xmm10
	xorl	%eax, %eax
	vpxor	%xmm12, %xmm12, %xmm12
	vxorps	%xmm11, %xmm11, %xmm11
	vpxor	%xmm13, %xmm13, %xmm13
	movq	256(%rsp), %rdi         # 8-byte Reload
	jmp	.LBB1_54
.LBB1_47:
	vmovdqa	%ymm2, 352(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 320(%rsp)        # 32-byte Spill
.LBB1_48:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit474
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 160(%rsp)        # 32-byte Spill
.LBB1_49:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit474
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 288(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 192(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 224(%rsp)        # 32-byte Spill
	movq	256(%rsp), %rdi         # 8-byte Reload
.LBB1_68:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit474
	vpcmpeqd	%ymm15, %ymm15, %ymm15
	vmovaps	.LCPI1_4(%rip), %ymm13  # ymm13 = [0,0,1,1,2,2,3,3]
	vmovaps	.LCPI1_5(%rip), %ymm14  # ymm14 = [4,4,5,5,6,6,7,7]
	vpcmpeqd	%ymm9, %ymm9, %ymm9
	.p2align	4, 0x90
.LBB1_69:                               # %for_test
                                        # =>This Inner Loop Header: Depth=1
	vpcmpeqq	%ymm0, %ymm6, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm0, %ymm5, %ymm2
	vextracti128	$1, %ymm2, %xmm10
	vpackssdw	%xmm10, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpandn	%ymm15, %ymm1, %ymm15
	vpcmpeqq	%ymm0, %ymm8, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm0, %ymm7, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpandn	%ymm9, %ymm1, %ymm9
	vmovmskps	%ymm15, %eax
	vmovmskps	%ymm9, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB1_71
# %bb.70:                               # %for_loop
                                        #   in Loop: Header=BB1_69 Depth=1
	movl	%edi, %eax
	shlq	$7, %rax
	vpaddq	(%rbx,%rax), %ymm5, %ymm1
	vpaddq	32(%rbx,%rax), %ymm6, %ymm2
	vpaddq	64(%rbx,%rax), %ymm7, %ymm3
	vpaddq	96(%rbx,%rax), %ymm8, %ymm10
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpermps	%ymm15, %ymm13, %ymm12
	vmaskmovpd	%ymm11, %ymm12, (%rbx,%rax)
	vpblendd	$170, %ymm0, %ymm2, %ymm11 # ymm11 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpermps	%ymm15, %ymm14, %ymm4
	vmaskmovpd	%ymm11, %ymm4, 32(%rbx,%rax)
	vpsrlq	$32, %ymm1, %ymm1
	vblendvpd	%ymm12, %ymm1, %ymm5, %ymm5
	vpblendd	$170, %ymm0, %ymm3, %ymm1 # ymm1 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpermps	%ymm9, %ymm13, %ymm11
	vmaskmovpd	%ymm1, %ymm11, 64(%rbx,%rax)
	vpsrlq	$32, %ymm2, %ymm1
	vblendvpd	%ymm4, %ymm1, %ymm6, %ymm6
	vpsrlq	$32, %ymm3, %ymm1
	vblendvpd	%ymm11, %ymm1, %ymm7, %ymm7
	vpblendd	$170, %ymm0, %ymm10, %ymm1 # ymm1 = ymm10[0],ymm0[1],ymm10[2],ymm0[3],ymm10[4],ymm0[5],ymm10[6],ymm0[7]
	vpermps	%ymm9, %ymm14, %ymm2
	vmaskmovpd	%ymm1, %ymm2, 96(%rbx,%rax)
	vpsrlq	$32, %ymm10, %ymm1
	vblendvpd	%ymm2, %ymm1, %ymm8, %ymm8
	incl	%edi
	jmp	.LBB1_69
.LBB1_71:                               # %for_exit
	vmovdqa	160(%rsp), %ymm0        # 32-byte Reload
	vpaddq	320(%rsp), %ymm0, %ymm8 # 32-byte Folded Reload
	vmovdqa	288(%rsp), %ymm0        # 32-byte Reload
	vpaddq	352(%rsp), %ymm0, %ymm9 # 32-byte Folded Reload
	vmovdqa	192(%rsp), %ymm0        # 32-byte Reload
	vpaddq	64(%rsp), %ymm0, %ymm2  # 32-byte Folded Reload
	vmovdqa	224(%rsp), %ymm0        # 32-byte Reload
	vpaddq	96(%rsp), %ymm0, %ymm3  # 32-byte Folded Reload
	leal	(%r14,%r14,2), %eax
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	.p2align	4, 0x90
.LBB1_72:                               # %for_test200
                                        # =>This Inner Loop Header: Depth=1
	vpcmpeqq	%ymm5, %ymm9, %ymm7
	vextracti128	$1, %ymm7, %xmm0
	vpackssdw	%xmm0, %xmm7, %xmm0
	vpcmpeqq	%ymm5, %ymm8, %ymm7
	vextracti128	$1, %ymm7, %xmm1
	vpackssdw	%xmm1, %xmm7, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm4, %ymm0, %ymm4
	vpcmpeqq	%ymm5, %ymm3, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm5, %ymm2, %ymm1
	vextracti128	$1, %ymm1, %xmm7
	vpackssdw	%xmm7, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm6, %ymm0, %ymm6
	vmovmskps	%ymm4, %ecx
	vmovmskps	%ymm6, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	je	.LBB1_74
# %bb.73:                               # %for_loop201
                                        #   in Loop: Header=BB1_72 Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpaddq	(%rbx,%rcx), %ymm8, %ymm0
	vpaddq	32(%rbx,%rcx), %ymm9, %ymm1
	vpaddq	64(%rbx,%rcx), %ymm2, %ymm7
	vpaddq	96(%rbx,%rcx), %ymm3, %ymm10
	vpblendd	$170, %ymm5, %ymm0, %ymm11 # ymm11 = ymm0[0],ymm5[1],ymm0[2],ymm5[3],ymm0[4],ymm5[5],ymm0[6],ymm5[7]
	vpermps	%ymm4, %ymm13, %ymm12
	vmaskmovpd	%ymm11, %ymm12, (%rbx,%rcx)
	vpblendd	$170, %ymm5, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm5[1],ymm1[2],ymm5[3],ymm1[4],ymm5[5],ymm1[6],ymm5[7]
	vpermps	%ymm4, %ymm14, %ymm15
	vmaskmovpd	%ymm11, %ymm15, 32(%rbx,%rcx)
	vpsrad	$31, %ymm0, %ymm11
	vpshufd	$245, %ymm0, %ymm0      # ymm0 = ymm0[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm0, %ymm0 # ymm0 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vblendvpd	%ymm12, %ymm0, %ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm0 # ymm0 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpermps	%ymm6, %ymm13, %ymm11
	vmaskmovpd	%ymm0, %ymm11, 64(%rbx,%rcx)
	vpsrad	$31, %ymm1, %ymm0
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm0 # ymm0 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vblendvpd	%ymm15, %ymm0, %ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm10, %ymm0 # ymm0 = ymm10[0],ymm5[1],ymm10[2],ymm5[3],ymm10[4],ymm5[5],ymm10[6],ymm5[7]
	vpermps	%ymm6, %ymm14, %ymm1
	vmaskmovpd	%ymm0, %ymm1, 96(%rbx,%rcx)
	vpsrad	$31, %ymm7, %ymm0
	vpshufd	$245, %ymm7, %ymm7      # ymm7 = ymm7[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm7, %ymm0 # ymm0 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vblendvpd	%ymm11, %ymm0, %ymm2, %ymm2
	vpsrad	$31, %ymm10, %ymm0
	vpshufd	$245, %ymm10, %ymm7     # ymm7 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm7, %ymm0 # ymm0 = ymm7[0],ymm0[1],ymm7[2],ymm0[3],ymm7[4],ymm0[5],ymm7[6],ymm0[7]
	vblendvpd	%ymm1, %ymm0, %ymm3, %ymm3
	incl	%eax
	jmp	.LBB1_72
.LBB1_74:                               # %for_exit203
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.LBB1_52:                               # %for_loop.i456.lr.ph.new
	movl	%r14d, %edx
	subl	%ecx, %edx
	leaq	(%r12,%rbx), %rsi
	addq	$384, %rsi              # imm = 0x180
	vpxor	%xmm9, %xmm9, %xmm9
	xorl	%eax, %eax
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm12, %xmm12, %xmm12
	vxorps	%xmm11, %xmm11, %xmm11
	vpxor	%xmm13, %xmm13, %xmm13
	movq	256(%rsp), %rdi         # 8-byte Reload
	.p2align	4, 0x90
.LBB1_53:                               # %for_loop.i456
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-288(%rsi), %ymm13, %ymm13
	vpaddq	-384(%rsi), %ymm10, %ymm10
	vpaddq	-352(%rsi), %ymm12, %ymm12
	vpaddq	-320(%rsi), %ymm11, %ymm11
	vpaddq	-320(%rsi,%r15), %ymm11, %ymm11
	vpaddq	-352(%rsi,%r15), %ymm12, %ymm12
	vpaddq	-384(%rsi,%r15), %ymm10, %ymm10
	vpaddq	-288(%rsi,%r15), %ymm13, %ymm13
	vpblendd	$170, %ymm9, %ymm13, %ymm14 # ymm14 = ymm13[0],ymm9[1],ymm13[2],ymm9[3],ymm13[4],ymm9[5],ymm13[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm10, %ymm15 # ymm15 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm12, %ymm1 # ymm1 = ymm12[0],ymm9[1],ymm12[2],ymm9[3],ymm12[4],ymm9[5],ymm12[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm11, %ymm2 # ymm2 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vmovdqu	%ymm2, -320(%rsi)
	vmovdqu	%ymm1, -352(%rsi)
	vmovdqu	%ymm15, -384(%rsi)
	vmovdqu	%ymm14, -288(%rsi)
	vpsrlq	$32, %ymm13, %ymm1
	vpsrlq	$32, %ymm11, %ymm2
	vpsrlq	$32, %ymm12, %ymm11
	vpsrlq	$32, %ymm10, %ymm10
	vpaddq	-256(%rsi), %ymm10, %ymm10
	vpaddq	-224(%rsi), %ymm11, %ymm11
	vpaddq	-192(%rsi), %ymm2, %ymm2
	vpaddq	-160(%rsi), %ymm1, %ymm1
	vpaddq	-160(%rsi,%r15), %ymm1, %ymm1
	vpaddq	-192(%rsi,%r15), %ymm2, %ymm2
	vpaddq	-224(%rsi,%r15), %ymm11, %ymm11
	vpaddq	-256(%rsi,%r15), %ymm10, %ymm10
	vpblendd	$170, %ymm9, %ymm10, %ymm12 # ymm12 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm11, %ymm13 # ymm13 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm14 # ymm14 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm15 # ymm15 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vmovdqu	%ymm15, -160(%rsi)
	vmovdqu	%ymm14, -192(%rsi)
	vmovdqu	%ymm13, -224(%rsi)
	vmovdqu	%ymm12, -256(%rsi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm11, %ymm11
	vpsrlq	$32, %ymm10, %ymm10
	vpaddq	-128(%rsi), %ymm10, %ymm10
	vpaddq	-96(%rsi), %ymm11, %ymm11
	vpaddq	-64(%rsi), %ymm2, %ymm2
	vpaddq	-32(%rsi), %ymm1, %ymm1
	vpaddq	-32(%rsi,%r15), %ymm1, %ymm1
	vpaddq	-64(%rsi,%r15), %ymm2, %ymm2
	vpaddq	-96(%rsi,%r15), %ymm11, %ymm11
	vpaddq	-128(%rsi,%r15), %ymm10, %ymm10
	vpblendd	$170, %ymm9, %ymm10, %ymm12 # ymm12 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm11, %ymm13 # ymm13 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm14 # ymm14 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm15 # ymm15 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vmovdqu	%ymm15, -32(%rsi)
	vmovdqu	%ymm14, -64(%rsi)
	vmovdqu	%ymm13, -96(%rsi)
	vmovdqu	%ymm12, -128(%rsi)
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm10, %ymm10
	vpsrlq	$32, %ymm11, %ymm11
	vpaddq	32(%rsi), %ymm11, %ymm11
	vpaddq	(%rsi), %ymm10, %ymm10
	vpaddq	96(%rsi), %ymm1, %ymm1
	vpaddq	64(%rsi), %ymm2, %ymm2
	vpaddq	64(%rsi,%r15), %ymm2, %ymm2
	vpaddq	96(%rsi,%r15), %ymm1, %ymm1
	vpaddq	(%rsi,%r15), %ymm10, %ymm10
	vpaddq	32(%rsi,%r15), %ymm11, %ymm12
	vpblendd	$170, %ymm9, %ymm12, %ymm11 # ymm11 = ymm12[0],ymm9[1],ymm12[2],ymm9[3],ymm12[4],ymm9[5],ymm12[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm10, %ymm13 # ymm13 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm14 # ymm14 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm15 # ymm15 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vmovdqu	%ymm15, 64(%rsi)
	vmovdqu	%ymm14, 96(%rsi)
	vmovdqu	%ymm13, (%rsi)
	vmovdqu	%ymm11, 32(%rsi)
	vpsrlq	$32, %ymm1, %ymm13
	vpsrlq	$32, %ymm2, %ymm11
	vpsrlq	$32, %ymm12, %ymm12
	vpsrlq	$32, %ymm10, %ymm10
	addq	$4, %rax
	addq	$512, %rsi              # imm = 0x200
	cmpl	%eax, %edx
	jne	.LBB1_53
.LBB1_54:                               # %for_test.i444.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit457_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_57
# %bb.55:                               # %for_loop.i456.epil.preheader
	addq	%rdi, %rax
	shlq	$7, %rax
	addq	%rbx, %rax
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB1_56:                               # %for_loop.i456.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	96(%rax), %ymm13, %ymm1
	vpaddq	32(%rax), %ymm12, %ymm2
	vpaddq	(%rax), %ymm10, %ymm10
	vpaddq	64(%rax), %ymm11, %ymm11
	vpaddq	64(%rax,%r15), %ymm11, %ymm11
	vpaddq	(%rax,%r15), %ymm10, %ymm10
	vpaddq	32(%rax,%r15), %ymm2, %ymm2
	vpaddq	96(%rax,%r15), %ymm1, %ymm1
	vpblendd	$170, %ymm9, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm10, %ymm14 # ymm14 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm11, %ymm15 # ymm15 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vmovdqu	%ymm15, 64(%rax)
	vmovdqu	%ymm14, (%rax)
	vmovdqu	%ymm13, 32(%rax)
	vmovdqu	%ymm12, 96(%rax)
	vpsrlq	$32, %ymm10, %ymm10
	vpsrlq	$32, %ymm2, %ymm12
	vpsrlq	$32, %ymm11, %ymm11
	vpsrlq	$32, %ymm1, %ymm13
	subq	$-128, %rax
	decl	%ecx
	jne	.LBB1_56
.LBB1_57:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit457
	vpaddq	%ymm3, %ymm10, %ymm3
	vpaddq	%ymm4, %ymm12, %ymm4
	vmovdqa	64(%rsp), %ymm1         # 32-byte Reload
	vpaddq	%ymm1, %ymm11, %ymm1
	vmovdqa	%ymm1, 64(%rsp)         # 32-byte Spill
	vmovdqa	96(%rsp), %ymm1         # 32-byte Reload
	vpaddq	%ymm1, %ymm13, %ymm1
	testl	%edi, %edi
	vmovdqa	%ymm3, 320(%rsp)        # 32-byte Spill
	vmovdqa	%ymm4, 352(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 96(%rsp)         # 32-byte Spill
	je	.LBB1_58
# %bb.59:                               # %for_loop.i473.lr.ph
	addq	%rbx, %r15
	movq	160(%rsp), %rax         # 8-byte Reload
	leal	(%rax,%rax), %ecx
	orl	$1, %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%edi, %eax
	andl	$2, %eax
	cmpl	$3, %edx
	jae	.LBB1_61
# %bb.60:
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%ecx, %ecx
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm11, %xmm11, %xmm11
	testl	%eax, %eax
	jne	.LBB1_65
	jmp	.LBB1_67
.LBB1_58:
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 160(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 288(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 192(%rsp)        # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm1, 224(%rsp)        # 32-byte Spill
	jmp	.LBB1_68
.LBB1_61:                               # %for_loop.i473.lr.ph.new
	leal	(%rax,%r8,2), %edx
	subl	%ecx, %edx
	vpxor	%xmm13, %xmm13, %xmm13
	movl	$384, %esi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm11, %xmm11, %xmm11
	.p2align	4, 0x90
.LBB1_62:                               # %for_loop.i473
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	-384(%r15,%rsi), %ymm1
	vmovdqu	-352(%r15,%rsi), %ymm2
	vmovdqu	-320(%r15,%rsi), %ymm9
	vmovdqu	-288(%r15,%rsi), %ymm14
	vpsubq	96(%rsp,%rsi), %ymm14, %ymm14
	vpsubq	(%rsp,%rsi), %ymm1, %ymm1
	vpaddq	%ymm11, %ymm14, %ymm12
	vpaddq	%ymm3, %ymm1, %ymm1
	vpsubq	32(%rsp,%rsi), %ymm2, %ymm2
	vpaddq	%ymm2, %ymm10, %ymm2
	vpsubq	64(%rsp,%rsi), %ymm9, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm9
	vpblendd	$170, %ymm13, %ymm12, %ymm10 # ymm10 = ymm12[0],ymm13[1],ymm12[2],ymm13[3],ymm12[4],ymm13[5],ymm12[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm13[1],ymm1[2],ymm13[3],ymm1[4],ymm13[5],ymm1[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm2, %ymm14 # ymm14 = ymm2[0],ymm13[1],ymm2[2],ymm13[3],ymm2[4],ymm13[5],ymm2[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm9, %ymm15 # ymm15 = ymm9[0],ymm13[1],ymm9[2],ymm13[3],ymm9[4],ymm13[5],ymm9[6],ymm13[7]
	vmovdqu	%ymm15, -320(%r15,%rsi)
	vmovdqu	%ymm14, -352(%r15,%rsi)
	vmovdqu	%ymm11, -384(%r15,%rsi)
	vmovdqu	%ymm10, -288(%r15,%rsi)
	vpsrad	$31, %ymm1, %ymm10
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm10[1],ymm1[2],ymm10[3],ymm1[4],ymm10[5],ymm1[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm10
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm10[1],ymm2[2],ymm10[3],ymm2[4],ymm10[5],ymm2[6],ymm10[7]
	vpsrad	$31, %ymm9, %ymm10
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpsrad	$31, %ymm12, %ymm10
	vpshufd	$245, %ymm12, %ymm11    # ymm11 = ymm12[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm11, %ymm10 # ymm10 = ymm11[0],ymm10[1],ymm11[2],ymm10[3],ymm11[4],ymm10[5],ymm11[6],ymm10[7]
	vmovdqu	-160(%r15,%rsi), %ymm11
	vmovdqu	-192(%r15,%rsi), %ymm12
	vmovdqu	-224(%r15,%rsi), %ymm14
	vmovdqu	-256(%r15,%rsi), %ymm15
	vpsubq	128(%rsp,%rsi), %ymm15, %ymm15
	vpsubq	160(%rsp,%rsi), %ymm14, %ymm14
	vpaddq	%ymm1, %ymm15, %ymm1
	vpaddq	%ymm2, %ymm14, %ymm2
	vpsubq	192(%rsp,%rsi), %ymm12, %ymm12
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	224(%rsp,%rsi), %ymm11, %ymm11
	vpaddq	%ymm10, %ymm11, %ymm10
	vpblendd	$170, %ymm13, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm13[1],ymm1[2],ymm13[3],ymm1[4],ymm13[5],ymm1[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm2, %ymm12 # ymm12 = ymm2[0],ymm13[1],ymm2[2],ymm13[3],ymm2[4],ymm13[5],ymm2[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm9, %ymm14 # ymm14 = ymm9[0],ymm13[1],ymm9[2],ymm13[3],ymm9[4],ymm13[5],ymm9[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm10, %ymm15 # ymm15 = ymm10[0],ymm13[1],ymm10[2],ymm13[3],ymm10[4],ymm13[5],ymm10[6],ymm13[7]
	vmovdqu	%ymm15, -160(%r15,%rsi)
	vmovdqu	%ymm14, -192(%r15,%rsi)
	vmovdqu	%ymm12, -224(%r15,%rsi)
	vmovdqu	%ymm11, -256(%r15,%rsi)
	vpsrad	$31, %ymm1, %ymm11
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vpsrad	$31, %ymm2, %ymm11
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vpsrad	$31, %ymm10, %ymm11
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm10, %ymm10 # ymm10 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vmovdqu	-32(%r15,%rsi), %ymm11
	vmovdqu	-64(%r15,%rsi), %ymm12
	vmovdqu	-96(%r15,%rsi), %ymm14
	vmovdqu	-128(%r15,%rsi), %ymm15
	vpsubq	256(%rsp,%rsi), %ymm15, %ymm15
	vpsubq	288(%rsp,%rsi), %ymm14, %ymm14
	vpaddq	%ymm1, %ymm15, %ymm1
	vpaddq	%ymm2, %ymm14, %ymm2
	vpsubq	320(%rsp,%rsi), %ymm12, %ymm12
	vpaddq	%ymm9, %ymm12, %ymm9
	vpsubq	352(%rsp,%rsi), %ymm11, %ymm11
	vpaddq	%ymm10, %ymm11, %ymm10
	vpblendd	$170, %ymm13, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm13[1],ymm1[2],ymm13[3],ymm1[4],ymm13[5],ymm1[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm2, %ymm12 # ymm12 = ymm2[0],ymm13[1],ymm2[2],ymm13[3],ymm2[4],ymm13[5],ymm2[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm9, %ymm14 # ymm14 = ymm9[0],ymm13[1],ymm9[2],ymm13[3],ymm9[4],ymm13[5],ymm9[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm10, %ymm15 # ymm15 = ymm10[0],ymm13[1],ymm10[2],ymm13[3],ymm10[4],ymm13[5],ymm10[6],ymm13[7]
	vmovdqu	%ymm15, -32(%r15,%rsi)
	vmovdqu	%ymm14, -64(%r15,%rsi)
	vmovdqu	%ymm12, -96(%r15,%rsi)
	vmovdqu	%ymm11, -128(%r15,%rsi)
	vpsrad	$31, %ymm2, %ymm11
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm2, %ymm2 # ymm2 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vpsrad	$31, %ymm1, %ymm11
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm1, %ymm1 # ymm1 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vpsrad	$31, %ymm10, %ymm11
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm10, %ymm10 # ymm10 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vpsrad	$31, %ymm9, %ymm11
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm9, %ymm9 # ymm9 = ymm9[0],ymm11[1],ymm9[2],ymm11[3],ymm9[4],ymm11[5],ymm9[6],ymm11[7]
	vmovdqu	64(%r15,%rsi), %ymm11
	vmovdqu	96(%r15,%rsi), %ymm12
	vmovdqu	(%r15,%rsi), %ymm14
	vmovdqu	32(%r15,%rsi), %ymm15
	vpsubq	416(%rsp,%rsi), %ymm15, %ymm15
	vpsubq	384(%rsp,%rsi), %ymm14, %ymm14
	vpaddq	%ymm2, %ymm15, %ymm2
	vpaddq	%ymm1, %ymm14, %ymm1
	vpsubq	480(%rsp,%rsi), %ymm12, %ymm12
	vpaddq	%ymm10, %ymm12, %ymm10
	vpsubq	448(%rsp,%rsi), %ymm11, %ymm11
	vpaddq	%ymm9, %ymm11, %ymm9
	vpblendd	$170, %ymm13, %ymm2, %ymm11 # ymm11 = ymm2[0],ymm13[1],ymm2[2],ymm13[3],ymm2[4],ymm13[5],ymm2[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm13[1],ymm1[2],ymm13[3],ymm1[4],ymm13[5],ymm1[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm10, %ymm14 # ymm14 = ymm10[0],ymm13[1],ymm10[2],ymm13[3],ymm10[4],ymm13[5],ymm10[6],ymm13[7]
	vpblendd	$170, %ymm13, %ymm9, %ymm15 # ymm15 = ymm9[0],ymm13[1],ymm9[2],ymm13[3],ymm9[4],ymm13[5],ymm9[6],ymm13[7]
	vmovdqu	%ymm15, 64(%r15,%rsi)
	vmovdqu	%ymm14, 96(%r15,%rsi)
	vmovdqu	%ymm12, (%r15,%rsi)
	vmovdqu	%ymm11, 32(%r15,%rsi)
	vpsrad	$31, %ymm10, %ymm11
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vpsrad	$31, %ymm9, %ymm10
	vpshufd	$245, %ymm9, %ymm9      # ymm9 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm10, %ymm9, %ymm4 # ymm4 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7]
	vpsrad	$31, %ymm2, %ymm9
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm9, %ymm2, %ymm10 # ymm10 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpsrad	$31, %ymm1, %ymm2
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm1, %ymm3 # ymm3 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	addq	$512, %rsi              # imm = 0x200
	addq	$-4, %rcx
	cmpl	%ecx, %edx
	jne	.LBB1_62
# %bb.63:                               # %for_test.i461.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit474_crit_edge.unr-lcssa.loopexit
	negq	%rcx
	testl	%eax, %eax
	je	.LBB1_67
.LBB1_65:                               # %for_loop.i473.epil.preheader
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB1_66:                               # %for_loop.i473.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%r15,%rcx), %ymm1
	vmovdqu	32(%r15,%rcx), %ymm2
	vmovdqu	64(%r15,%rcx), %ymm13
	vmovdqu	96(%r15,%rcx), %ymm14
	vpsubq	480(%rsp,%rcx), %ymm14, %ymm14
	vpaddq	%ymm11, %ymm14, %ymm12
	vpsubq	416(%rsp,%rcx), %ymm2, %ymm2
	vpaddq	%ymm2, %ymm10, %ymm2
	vpsubq	384(%rsp,%rcx), %ymm1, %ymm1
	vpsubq	448(%rsp,%rcx), %ymm13, %ymm11
	vpaddq	%ymm3, %ymm1, %ymm1
	vpaddq	%ymm4, %ymm11, %ymm10
	vpblendd	$170, %ymm9, %ymm12, %ymm11 # ymm11 = ymm12[0],ymm9[1],ymm12[2],ymm9[3],ymm12[4],ymm9[5],ymm12[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm2, %ymm13 # ymm13 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm1, %ymm14 # ymm14 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vpblendd	$170, %ymm9, %ymm10, %ymm15 # ymm15 = ymm10[0],ymm9[1],ymm10[2],ymm9[3],ymm10[4],ymm9[5],ymm10[6],ymm9[7]
	vmovdqu	%ymm15, 64(%r15,%rcx)
	vmovdqu	%ymm14, (%r15,%rcx)
	vmovdqu	%ymm13, 32(%r15,%rcx)
	vmovdqu	%ymm11, 96(%r15,%rcx)
	vpsrad	$31, %ymm10, %ymm11
	vpshufd	$245, %ymm10, %ymm10    # ymm10 = ymm10[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm10, %ymm4 # ymm4 = ymm10[0],ymm11[1],ymm10[2],ymm11[3],ymm10[4],ymm11[5],ymm10[6],ymm11[7]
	vpsrad	$31, %ymm2, %ymm11
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm11, %ymm2, %ymm10 # ymm10 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vpsrad	$31, %ymm1, %ymm2
	vpshufd	$245, %ymm1, %ymm1      # ymm1 = ymm1[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm1, %ymm3 # ymm3 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpsrad	$31, %ymm12, %ymm1
	vpshufd	$245, %ymm12, %ymm2     # ymm2 = ymm12[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm1, %ymm2, %ymm11 # ymm11 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	subq	$-128, %rcx
	incl	%eax
	jne	.LBB1_66
.LBB1_67:
	vmovdqa	%ymm11, 224(%rsp)       # 32-byte Spill
	vmovdqa	%ymm10, 288(%rsp)       # 32-byte Spill
	vmovdqa	%ymm4, 192(%rsp)        # 32-byte Spill
	vmovdqa	%ymm3, 160(%rsp)        # 32-byte Spill
	jmp	.LBB1_68
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
	.long	1                       # 0x1
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI2_6:
	.byte	0                       # 0x0
	.byte	4                       # 0x4
	.byte	8                       # 0x8
	.byte	12                      # 0xc
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI2_7:
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.byte	0                       # 0x0
	.byte	4                       # 0x4
	.byte	8                       # 0x8
	.byte	12                      # 0xc
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI2_8:
	.zero	16,128
.LCPI2_10:
	.zero	16,1
.LCPI2_11:
	.zero	16
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI2_9:
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
	vmovaps	%ymm1, %ymm9
	vmovaps	%ymm0, %ymm15
	movl	%r9d, 20(%rsp)          # 4-byte Spill
	movl	%r8d, %r11d
	movq	%rcx, %rbx
	vmovmskps	%ymm0, %eax
	vmovmskps	%ymm1, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm1
	vpmulld	.LCPI2_0(%rip), %ymm1, %ymm0
	vpmulld	.LCPI2_1(%rip), %ymm1, %ymm1
	cmpl	$65535, %ecx            # imm = 0xFFFF
	movq	%r11, 24(%rsp)          # 8-byte Spill
	jne	.LBB2_1
# %bb.5:                                # %for_test.preheader
	testl	%r11d, %r11d
	je	.LBB2_6
# %bb.7:                                # %for_loop.lr.ph
	cmpl	$1, %r11d
	movq	%rbx, 8(%rsp)           # 8-byte Spill
	jne	.LBB2_9
# %bb.8:
	xorl	%eax, %eax
	jmp	.LBB2_12
.LBB2_1:                                # %for_test488.preheader
	movl	%r11d, %r15d
	testl	%r11d, %r11d
	vmovaps	%ymm9, 192(%rsp)        # 32-byte Spill
	vmovaps	%ymm15, 160(%rsp)       # 32-byte Spill
	je	.LBB2_2
# %bb.3:                                # %for_loop489.lr.ph
	cmpl	$1, %r11d
	movq	%rbx, 8(%rsp)           # 8-byte Spill
	jne	.LBB2_71
# %bb.4:
	xorl	%r10d, %r10d
	jmp	.LBB2_74
.LBB2_6:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB2_62
.LBB2_2:                                # %for_test720.preheader.thread
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB2_124
.LBB2_9:                                # %for_loop.lr.ph.new
	movl	%r11d, %r8d
	andl	$1, %r8d
	movl	%r11d, %r9d
	subl	%r8d, %r9d
	movl	$64, %ecx
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
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdi,%ymm3), %ymm5
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm4, (%rdi,%ymm2), %ymm6
	vmovdqa	%ymm6, 21088(%rsp,%rcx)
	vmovdqa	%ymm5, 21056(%rsp,%rcx)
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm4
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm3
	vpmovzxdq	%xmm4, %ymm5    # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	leal	1(%rax), %ebx
	vmovdqa	%ymm5, 8768(%rsp,%rcx,2)
	vmovd	%ebx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vmovdqa	%ymm2, 8704(%rsp,%rcx,2)
	vpaddd	%ymm1, %ymm5, %ymm2
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovdqa	%ymm4, 8800(%rsp,%rcx,2)
	vpslld	$2, %ymm5, %ymm4
	vpslld	$2, %ymm2, %ymm2
	vmovdqa	%ymm3, 8736(%rsp,%rcx,2)
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm3, (%rdi,%ymm2), %ymm5
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm3, (%rdi,%ymm4), %ymm6
	vmovdqa	%ymm6, 21152(%rsp,%rcx)
	vmovdqa	%ymm5, 21120(%rsp,%rcx)
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm5
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm4), %ymm3
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 8896(%rsp,%rcx,2)
	vmovdqa	%ymm3, 8928(%rsp,%rcx,2)
	vmovdqa	%ymm2, 8832(%rsp,%rcx,2)
	vmovdqa	%ymm4, 8864(%rsp,%rcx,2)
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %r9d
	jne	.LBB2_10
# %bb.11:                               # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
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
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdi,%ymm1), %ymm3
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm2, (%rdi,%ymm0), %ymm4
	vmovdqa	%ymm4, 21152(%rsp,%rcx)
	vmovdqa	%ymm3, 21120(%rsp,%rcx)
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm1), %ymm3
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	%ymm1, (%rdx,%ymm0), %ymm2
	shlq	$7, %rax
	vpmovzxdq	%xmm3, %ymm0    # ymm0 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpmovzxdq	%xmm2, %ymm3    # ymm3 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vmovdqa	%ymm2, 8928(%rsp,%rax)
	vmovdqa	%ymm3, 8896(%rsp,%rax)
	vmovdqa	%ymm1, 8864(%rsp,%rax)
	vmovdqa	%ymm0, 8832(%rsp,%rax)
.LBB2_13:                               # %for_exit
	vmovups	(%rsi), %ymm0
	vmovaps	%ymm0, 320(%rsp)        # 32-byte Spill
	vmovdqu	32(%rsi), %ymm0
	vmovdqa	%ymm0, 288(%rsp)        # 32-byte Spill
	testl	%r11d, %r11d
	jle	.LBB2_19
# %bb.14:                               # %for_loop33.lr.ph
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	20(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %esi
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm2
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm7
	movl	%r11d, %r15d
	leaq	21184(%rsp), %r8
	movl	%r11d, %r13d
	andl	$-2, %r13d
	movq	%r15, %r12
	shlq	$7, %r12
	movq	%r15, %r14
	shlq	$6, %r14
	movq	%r15, %rax
	vmovdqa	%ymm2, 256(%rsp)        # 32-byte Spill
	vmovdqa	%ymm7, 224(%rsp)        # 32-byte Spill
	jmp	.LBB2_15
	.p2align	4, 0x90
.LBB2_18:                               # %for_test32.loopexit
                                        #   in Loop: Header=BB2_15 Depth=1
	movl	$-2147483648, %esi      # imm = 0x80000000
	cmpq	$1, 384(%rsp)           # 8-byte Folded Reload
	movq	352(%rsp), %rax         # 8-byte Reload
	jle	.LBB2_19
.LBB2_15:                               # %for_loop33
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_43 Depth 2
                                        #       Child Loop BB2_44 Depth 3
                                        #         Child Loop BB2_31 Depth 4
                                        #       Child Loop BB2_36 Depth 3
                                        #       Child Loop BB2_38 Depth 3
                                        #         Child Loop BB2_40 Depth 4
	movq	%rax, 384(%rsp)         # 8-byte Spill
	leaq	-1(%rax), %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 352(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB2_17
# %bb.16:                               # %for_loop33
                                        #   in Loop: Header=BB2_15 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_17:                               # %for_loop33
                                        #   in Loop: Header=BB2_15 Depth=1
	vpaddd	21152(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 160(%rsp)        # 32-byte Spill
	vpaddd	21120(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 416(%rsp)        # 32-byte Spill
	jmp	.LBB2_43
	.p2align	4, 0x90
.LBB2_42:                               # %for_exit129
                                        #   in Loop: Header=BB2_43 Depth=2
	shrl	%esi
	je	.LBB2_18
.LBB2_43:                               # %for_loop50.lr.ph.split.us
                                        #   Parent Loop BB2_15 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_44 Depth 3
                                        #         Child Loop BB2_31 Depth 4
                                        #       Child Loop BB2_36 Depth 3
                                        #       Child Loop BB2_38 Depth 3
                                        #         Child Loop BB2_40 Depth 4
	movl	%esi, 192(%rsp)         # 4-byte Spill
	leaq	74368(%rsp), %rdi
	leaq	8832(%rsp), %rsi
	movl	%r11d, %edx
	movq	%r8, %rbx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	vpxor	%xmm15, %xmm15, %xmm15
	movq	%rbx, %r8
	movq	24(%rsp), %r11          # 8-byte Reload
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa	320(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	288(%rsp), %ymm13       # 32-byte Reload
	vmovdqa	.LCPI2_2(%rip), %ymm14  # ymm14 = [0,2,4,6,4,6,6,7]
	jmp	.LBB2_44
	.p2align	4, 0x90
.LBB2_45:                               #   in Loop: Header=BB2_44 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%esi, %esi
.LBB2_33:                               # %for_loop61.us.epil.preheader
                                        #   in Loop: Header=BB2_44 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	21152(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21168(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21120(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21136(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm2
	vpmuludq	%ymm3, %ymm10, %ymm3
	vpmuludq	%ymm0, %ymm9, %ymm0
	vpmuludq	%ymm1, %ymm8, %ymm1
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	74400(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	74368(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	%ymm3, %ymm4, %ymm3
	vpaddq	74464(%rsp,%rsi), %ymm6, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpaddq	74432(%rsp,%rsi), %ymm5, %ymm4
	vpaddq	%ymm1, %ymm4, %ymm1
	vpblendd	$170, %ymm15, %ymm2, %ymm4 # ymm4 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm6 # ymm6 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm7, 74432(%rsp,%rsi)
	vmovdqa	%ymm6, 74464(%rsp,%rsi)
	vmovdqa	%ymm5, 74368(%rsp,%rsi)
	vmovdqa	%ymm4, 74400(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm6
	vpsrlq	$32, %ymm1, %ymm5
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm4
.LBB2_34:                               # %for_exit63.us
                                        #   in Loop: Header=BB2_44 Depth=3
	vmovdqa	%ymm7, 8864(%rsp,%rdx)
	vmovdqa	%ymm4, 8832(%rsp,%rdx)
	vmovdqa	%ymm5, 8896(%rsp,%rdx)
	vmovdqa	%ymm6, 8928(%rsp,%rdx)
	incq	%rcx
	incq	%rax
	cmpq	%r15, %rcx
	je	.LBB2_35
.LBB2_44:                               # %for_loop61.lr.ph.us
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_43 Depth=2
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
	vpxor	%xmm4, %xmm4, %xmm4
	cmpl	$1, %r11d
	je	.LBB2_45
# %bb.30:                               # %for_loop61.lr.ph.us.new
                                        #   in Loop: Header=BB2_44 Depth=3
	movq	%r8, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB2_31:                               # %for_loop61.us
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_43 Depth=2
                                        #       Parent Loop BB2_44 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-32(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm0, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	vpmuludq	%ymm2, %ymm9, %ymm9
	vpmuludq	%ymm1, %ymm8, %ymm8
	leal	(%rcx,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	74464(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm11, %ymm6
	vpaddq	74368(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm4, %ymm10, %ymm4
	vpaddq	74400(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	74432(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm5, %ymm8, %ymm5
	vpblendd	$170, %ymm15, %ymm6, %ymm8 # ymm8 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 74432(%rsp,%rbx)
	vmovdqa	%ymm10, 74400(%rsp,%rbx)
	vmovdqa	%ymm9, 74368(%rsp,%rbx)
	vmovdqa	%ymm8, 74464(%rsp,%rbx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm7, %ymm7
	vpmovzxdq	32(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	(%rdi), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	vpmuludq	%ymm0, %ymm9, %ymm9
	vpmuludq	%ymm1, %ymm8, %ymm8
	leal	(%rax,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	74400(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	74368(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm7, %ymm11, %ymm7
	vpaddq	%ymm4, %ymm10, %ymm4
	vpaddq	74464(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm9, %ymm6
	vpaddq	74432(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm5, %ymm8, %ymm5
	vpblendd	$170, %ymm15, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 74432(%rsp,%rbx)
	vmovdqa	%ymm10, 74464(%rsp,%rbx)
	vmovdqa	%ymm9, 74368(%rsp,%rbx)
	vmovdqa	%ymm8, 74400(%rsp,%rbx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r13d
	jne	.LBB2_31
# %bb.32:                               # %for_test60.for_exit63_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_44 Depth=3
	testb	$1, %r11b
	jne	.LBB2_33
	jmp	.LBB2_34
	.p2align	4, 0x90
.LBB2_35:                               # %for_loop91.lr.ph
                                        #   in Loop: Header=BB2_43 Depth=2
	movl	192(%rsp), %esi         # 4-byte Reload
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	416(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	160(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpcmpeqd	%ymm0, %ymm15, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm15, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI2_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	vpxor	%xmm11, %xmm11, %xmm11
	movl	%r11d, %eax
	xorl	%ecx, %ecx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm13, %xmm13, %xmm13
	.p2align	4, 0x90
.LBB2_36:                               # %for_loop91
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_43 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%eax, %edx
	shlq	$7, %rdx
	vmovdqa	74368(%rsp,%rdx), %ymm0
	vmovdqa	74400(%rsp,%rdx), %ymm1
	vmovdqa	74432(%rsp,%rdx), %ymm8
	vmovdqa	74464(%rsp,%rdx), %ymm9
	vpaddq	8832(%rsp,%rcx), %ymm0, %ymm0
	vpaddq	8864(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	8896(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	8928(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm0, %ymm0, %ymm10
	vblendvpd	%ymm4, %ymm10, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm10
	vblendvpd	%ymm5, %ymm10, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm8, %ymm10
	vblendvpd	%ymm6, %ymm10, %ymm8, %ymm8
	vpaddq	%ymm9, %ymm9, %ymm10
	vblendvpd	%ymm7, %ymm10, %ymm9, %ymm9
	vpaddq	%ymm8, %ymm14, %ymm3
	vpblendd	$170, %ymm15, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vmovdqa	%ymm8, 8896(%rsp,%rcx)
	vpaddq	%ymm9, %ymm13, %ymm2
	vpblendd	$170, %ymm15, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vmovdqa	%ymm8, 8928(%rsp,%rcx)
	vpaddq	%ymm0, %ymm11, %ymm0
	vpblendd	$170, %ymm15, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqa	%ymm8, 8832(%rsp,%rcx)
	vpaddq	%ymm1, %ymm12, %ymm1
	vpblendd	$170, %ymm15, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm8, 8864(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm13
	vpsrlq	$32, %ymm3, %ymm14
	vpsrlq	$32, %ymm1, %ymm12
	vpsrlq	$32, %ymm0, %ymm11
	subq	$-128, %rcx
	incl	%eax
	cmpq	%rcx, %r12
	jne	.LBB2_36
# %bb.37:                               # %for_test126.preheader
                                        #   in Loop: Header=BB2_43 Depth=2
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vmovdqa	256(%rsp), %ymm2        # 32-byte Reload
	vmovdqa	224(%rsp), %ymm7        # 32-byte Reload
	.p2align	4, 0x90
.LBB2_38:                               # %for_test126
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_43 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_40 Depth 4
	vpcmpeqq	%ymm15, %ymm12, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm11, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm3, %ymm0, %ymm3
	vpcmpeqq	%ymm15, %ymm13, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm14, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm4, %ymm0, %ymm4
	vmovmskps	%ymm3, %eax
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_42
# %bb.39:                               # %for_loop141.lr.ph
                                        #   in Loop: Header=BB2_38 Depth=3
	vmovdqa	%ymm14, 512(%rsp)       # 32-byte Spill
	vmovdqa	%ymm13, 544(%rsp)       # 32-byte Spill
	vmovdqa	%ymm12, 576(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 608(%rsp)       # 32-byte Spill
	vmovaps	.LCPI2_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm3, %ymm0, %ymm1
	vmovaps	%ymm1, 64(%rsp)         # 32-byte Spill
	vmovaps	.LCPI2_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovaps	%ymm3, 480(%rsp)        # 32-byte Spill
	vpermps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm3, 32(%rsp)         # 32-byte Spill
	vpermps	%ymm4, %ymm0, %ymm0
	vmovaps	%ymm0, 96(%rsp)         # 32-byte Spill
	vmovaps	%ymm4, 448(%rsp)        # 32-byte Spill
	vpermps	%ymm4, %ymm1, %ymm9
	vmovdqa	%ymm2, %ymm6
	vpxor	%xmm11, %xmm11, %xmm11
	movl	$0, %eax
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB2_40:                               # %for_loop141
                                        #   Parent Loop BB2_15 Depth=1
                                        #     Parent Loop BB2_43 Depth=2
                                        #       Parent Loop BB2_38 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	8832(%rsp,%rax,2), %ymm2
	vmovdqa	21120(%rsp,%rax), %ymm0
	vmovdqa	21152(%rsp,%rax), %ymm1
	vpsllvd	%ymm6, %ymm0, %ymm3
	vpor	%ymm3, %ymm15, %ymm3
	vpsllvd	%ymm6, %ymm1, %ymm15
	vmovdqa	8928(%rsp,%rax,2), %ymm4
	vpor	%ymm14, %ymm15, %ymm14
	vextracti128	$1, %ymm14, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm4, %ymm5
	vpaddq	%ymm5, %ymm13, %ymm5
	vmovdqa	8896(%rsp,%rax,2), %ymm13
	vpmovzxdq	%xmm14, %ymm14  # ymm14 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm14, %ymm13, %ymm14
	vpaddq	%ymm12, %ymm14, %ymm12
	vpmovzxdq	%xmm3, %ymm14   # ymm14 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm14, %ymm2, %ymm14
	vpaddq	%ymm11, %ymm14, %ymm11
	vpblendd	$170, %ymm8, %ymm11, %ymm14 # ymm14 = ymm11[0],ymm8[1],ymm11[2],ymm8[3],ymm11[4],ymm8[5],ymm11[6],ymm8[7]
	vmovapd	64(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm14, %ymm2, %ymm2
	vmovdqa	8864(%rsp,%rax,2), %ymm14
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm14, %ymm3
	vpaddq	%ymm3, %ymm10, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm10 # ymm10 = ymm3[0],ymm8[1],ymm3[2],ymm8[3],ymm3[4],ymm8[5],ymm3[6],ymm8[7]
	vmovapd	32(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm10, %ymm14, %ymm10
	vpblendd	$170, %ymm8, %ymm12, %ymm14 # ymm14 = ymm12[0],ymm8[1],ymm12[2],ymm8[3],ymm12[4],ymm8[5],ymm12[6],ymm8[7]
	vmovapd	96(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm14, %ymm13, %ymm13
	vpblendd	$170, %ymm8, %ymm5, %ymm14 # ymm14 = ymm5[0],ymm8[1],ymm5[2],ymm8[3],ymm5[4],ymm8[5],ymm5[6],ymm8[7]
	vblendvpd	%ymm9, %ymm14, %ymm4, %ymm4
	vmovapd	%ymm13, 8896(%rsp,%rax,2)
	vmovapd	%ymm4, 8928(%rsp,%rax,2)
	vmovapd	%ymm2, 8832(%rsp,%rax,2)
	vpsrlvd	%ymm7, %ymm1, %ymm14
	vpsrlvd	%ymm7, %ymm0, %ymm15
	vmovapd	%ymm10, 8864(%rsp,%rax,2)
	vpsrad	$31, %ymm5, %ymm0
	vpshufd	$245, %ymm5, %ymm1      # ymm1 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm12, %ymm0
	vpshufd	$245, %ymm12, %ymm1     # ymm1 = ymm12[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm1      # ymm1 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	$64, %rax
	cmpq	%rax, %r14
	jne	.LBB2_40
# %bb.41:                               # %for_exit143
                                        #   in Loop: Header=BB2_38 Depth=3
	vmovdqa	544(%rsp), %ymm1        # 32-byte Reload
	vpaddq	%ymm1, %ymm13, %ymm0
	vmovdqa	%ymm1, %ymm13
	vmovdqa	512(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm12, %ymm1
	vmovdqa	576(%rsp), %ymm12       # 32-byte Reload
	vpaddq	%ymm12, %ymm10, %ymm2
	vmovdqa	608(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm11, %ymm3
	vmovdqa	%ymm4, %ymm11
	vmovapd	64(%rsp), %ymm4         # 32-byte Reload
	vblendvpd	%ymm4, %ymm3, %ymm11, %ymm11
	vmovapd	32(%rsp), %ymm3         # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm12, %ymm12
	vmovapd	96(%rsp), %ymm2         # 32-byte Reload
	vblendvpd	%ymm2, %ymm1, %ymm14, %ymm14
	vblendvpd	%ymm9, %ymm0, %ymm13, %ymm13
	vmovdqa	%ymm6, %ymm2
	vpxor	%xmm15, %xmm15, %xmm15
	vmovaps	480(%rsp), %ymm3        # 32-byte Reload
	vmovaps	448(%rsp), %ymm4        # 32-byte Reload
	jmp	.LBB2_38
.LBB2_19:                               # %for_test188.preheader
	testl	%r11d, %r11d
	je	.LBB2_20
# %bb.21:                               # %for_loop189.lr.ph
	leal	-1(%r11), %r8d
	movl	%r11d, %eax
	andl	$3, %eax
	cmpl	$3, %r8d
	jae	.LBB2_54
# %bb.22:
	xorl	%ecx, %ecx
	jmp	.LBB2_23
.LBB2_71:                               # %for_loop489.lr.ph.new
	movl	%r11d, %r8d
	andl	$1, %r8d
	movl	%r11d, %r9d
	subl	%r8d, %r9d
	movl	$64, %ecx
	xorl	%r10d, %r10d
	.p2align	4, 0x90
.LBB2_72:                               # %for_loop489
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%r10d, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vpslld	$2, %ymm3, %ymm3
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdi,%ymm3), %ymm5
	vpslld	$2, %ymm2, %ymm2
	vmovaps	%ymm9, %ymm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm4, (%rdi,%ymm2), %ymm6
	vmovdqa	%ymm6, 16992(%rsp,%rcx)
	vmovdqa	%ymm5, 16960(%rsp,%rcx)
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vmovaps	%ymm9, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm4
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpmovzxdq	%xmm4, %ymm5    # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vmovdqa	%ymm5, 576(%rsp,%rcx,2)
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	leal	1(%r10), %eax
	vmovdqa	%ymm2, 512(%rsp,%rcx,2)
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vmovdqa	%ymm4, 608(%rsp,%rcx,2)
	vpaddd	%ymm1, %ymm2, %ymm4
	vpaddd	%ymm0, %ymm2, %ymm2
	vmovdqa	%ymm3, 544(%rsp,%rcx,2)
	vpslld	$2, %ymm4, %ymm3
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdi,%ymm3), %ymm5
	vpslld	$2, %ymm2, %ymm2
	vmovaps	%ymm9, %ymm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm4, (%rdi,%ymm2), %ymm6
	vmovdqa	%ymm6, 17056(%rsp,%rcx)
	vmovdqa	%ymm5, 17024(%rsp,%rcx)
	vmovaps	%ymm15, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vmovaps	%ymm9, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm4
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpmovzxdq	%xmm4, %ymm5    # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vmovdqa	%ymm5, 704(%rsp,%rcx,2)
	vmovdqa	%ymm4, 736(%rsp,%rcx,2)
	vmovdqa	%ymm2, 640(%rsp,%rcx,2)
	vmovdqa	%ymm3, 672(%rsp,%rcx,2)
	addq	$2, %r10
	subq	$-128, %rcx
	cmpl	%r10d, %r9d
	jne	.LBB2_72
# %bb.73:                               # %for_test488.for_exit491_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_75
.LBB2_74:                               # %for_loop489.epil.preheader
	movq	%r10, %rax
	shlq	$6, %rax
	vmovd	%r10d, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vpaddd	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vmovaps	%ymm15, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdi,%ymm1), %ymm3
	vpslld	$2, %ymm0, %ymm0
	vmovaps	%ymm9, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm2, (%rdi,%ymm0), %ymm4
	vmovdqa	%ymm4, 17056(%rsp,%rax)
	vmovdqa	%ymm3, 17024(%rsp,%rax)
	vmovaps	%ymm15, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm1), %ymm3
	vpxor	%xmm1, %xmm1, %xmm1
	vmovaps	%ymm9, %ymm2
	vpgatherdd	%ymm2, (%rdx,%ymm0), %ymm1
	shlq	$7, %r10
	vpmovzxdq	%xmm3, %ymm0    # ymm0 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm1, %ymm3    # ymm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vmovdqa	%ymm1, 736(%rsp,%r10)
	vmovdqa	%ymm3, 704(%rsp,%r10)
	vmovdqa	%ymm2, 672(%rsp,%r10)
	vmovdqa	%ymm0, 640(%rsp,%r10)
.LBB2_75:                               # %for_exit491
	vmaskmovps	(%rsi), %ymm15, %ymm0
	vmovaps	%ymm0, 256(%rsp)        # 32-byte Spill
	vmaskmovps	32(%rsi), %ymm9, %ymm0
	vmovaps	%ymm0, 224(%rsp)        # 32-byte Spill
	testl	%r11d, %r11d
	jle	.LBB2_81
# %bb.76:                               # %for_loop529.lr.ph
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	20(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %esi
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm2
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm3
	leaq	17088(%rsp), %r8
	movl	%r11d, %r12d
	andl	$-2, %r12d
	movq	%r15, %r14
	shlq	$7, %r14
	movq	%r15, %r13
	shlq	$6, %r13
	movq	%r15, %rax
	vmovdqa	%ymm2, 384(%rsp)        # 32-byte Spill
	vmovdqa	%ymm3, 352(%rsp)        # 32-byte Spill
	jmp	.LBB2_77
	.p2align	4, 0x90
.LBB2_80:                               # %for_test528.loopexit
                                        #   in Loop: Header=BB2_77 Depth=1
	movl	$-2147483648, %esi      # imm = 0x80000000
	cmpq	$1, 152(%rsp)           # 8-byte Folded Reload
	movq	144(%rsp), %rax         # 8-byte Reload
	jle	.LBB2_81
.LBB2_77:                               # %for_loop529
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_105 Depth 2
                                        #       Child Loop BB2_106 Depth 3
                                        #         Child Loop BB2_93 Depth 4
                                        #       Child Loop BB2_98 Depth 3
                                        #       Child Loop BB2_100 Depth 3
                                        #         Child Loop BB2_102 Depth 4
	movq	%rax, 152(%rsp)         # 8-byte Spill
	leaq	-1(%rax), %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 144(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB2_79
# %bb.78:                               # %for_loop529
                                        #   in Loop: Header=BB2_77 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_79:                               # %for_loop529
                                        #   in Loop: Header=BB2_77 Depth=1
	vpaddd	17056(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 320(%rsp)        # 32-byte Spill
	vpaddd	17024(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 288(%rsp)        # 32-byte Spill
	jmp	.LBB2_105
	.p2align	4, 0x90
.LBB2_104:                              # %for_exit651
                                        #   in Loop: Header=BB2_105 Depth=2
	shrl	%esi
	je	.LBB2_80
.LBB2_105:                              # %for_loop558.lr.ph.split.us
                                        #   Parent Loop BB2_77 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_106 Depth 3
                                        #         Child Loop BB2_93 Depth 4
                                        #       Child Loop BB2_98 Depth 3
                                        #       Child Loop BB2_100 Depth 3
                                        #         Child Loop BB2_102 Depth 4
	movl	%esi, 416(%rsp)         # 4-byte Spill
	leaq	57984(%rsp), %rdi
	leaq	640(%rsp), %rsi
	movl	%r11d, %edx
	movq	%r8, %rbx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%rbx, %r8
	movq	24(%rsp), %r11          # 8-byte Reload
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa	256(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	224(%rsp), %ymm13       # 32-byte Reload
	vmovdqa	.LCPI2_2(%rip), %ymm14  # ymm14 = [0,2,4,6,4,6,6,7]
	vxorps	%xmm15, %xmm15, %xmm15
	jmp	.LBB2_106
	.p2align	4, 0x90
.LBB2_107:                              #   in Loop: Header=BB2_106 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%esi, %esi
.LBB2_95:                               # %for_loop574.us.epil.preheader
                                        #   in Loop: Header=BB2_106 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	17056(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17072(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17024(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17040(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm2
	vpmuludq	%ymm3, %ymm10, %ymm3
	vpmuludq	%ymm0, %ymm9, %ymm0
	vpmuludq	%ymm1, %ymm8, %ymm1
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	58016(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	57984(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	%ymm3, %ymm4, %ymm3
	vpaddq	58080(%rsp,%rsi), %ymm6, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpaddq	58048(%rsp,%rsi), %ymm5, %ymm4
	vpaddq	%ymm1, %ymm4, %ymm1
	vpblendd	$170, %ymm15, %ymm2, %ymm4 # ymm4 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm6 # ymm6 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm7, 58048(%rsp,%rsi)
	vmovdqa	%ymm6, 58080(%rsp,%rsi)
	vmovdqa	%ymm5, 57984(%rsp,%rsi)
	vmovdqa	%ymm4, 58016(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm6
	vpsrlq	$32, %ymm1, %ymm5
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm4
.LBB2_96:                               # %for_exit576.us
                                        #   in Loop: Header=BB2_106 Depth=3
	vmovdqa	%ymm7, 672(%rsp,%rdx)
	vmovdqa	%ymm4, 640(%rsp,%rdx)
	vmovdqa	%ymm5, 704(%rsp,%rdx)
	vmovdqa	%ymm6, 736(%rsp,%rdx)
	incq	%rcx
	incq	%rax
	cmpq	%r15, %rcx
	je	.LBB2_97
.LBB2_106:                              # %for_loop574.lr.ph.us
                                        #   Parent Loop BB2_77 Depth=1
                                        #     Parent Loop BB2_105 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_93 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpermd	58048(%rsp,%rdx), %ymm14, %ymm0
	vpermd	58080(%rsp,%rdx), %ymm14, %ymm1
	vpermd	57984(%rsp,%rdx), %ymm14, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	58016(%rsp,%rdx), %ymm14, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	%ymm12, %ymm1, %ymm3
	vpmulld	%ymm13, %ymm0, %ymm1
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpxor	%xmm4, %xmm4, %xmm4
	cmpl	$1, %r11d
	je	.LBB2_107
# %bb.92:                               # %for_loop574.lr.ph.us.new
                                        #   in Loop: Header=BB2_106 Depth=3
	movq	%r8, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB2_93:                               # %for_loop574.us
                                        #   Parent Loop BB2_77 Depth=1
                                        #     Parent Loop BB2_105 Depth=2
                                        #       Parent Loop BB2_106 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-32(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm0, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	vpmuludq	%ymm2, %ymm9, %ymm9
	vpmuludq	%ymm1, %ymm8, %ymm8
	leal	(%rcx,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	58080(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm11, %ymm6
	vpaddq	57984(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm4, %ymm10, %ymm4
	vpaddq	58016(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	58048(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm5, %ymm8, %ymm5
	vpblendd	$170, %ymm15, %ymm6, %ymm8 # ymm8 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 58048(%rsp,%rbx)
	vmovdqa	%ymm10, 58016(%rsp,%rbx)
	vmovdqa	%ymm9, 57984(%rsp,%rbx)
	vmovdqa	%ymm8, 58080(%rsp,%rbx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm7, %ymm7
	vpmovzxdq	32(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	(%rdi), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	vpmuludq	%ymm0, %ymm9, %ymm9
	vpmuludq	%ymm1, %ymm8, %ymm8
	leal	(%rax,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	58016(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	57984(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm7, %ymm11, %ymm7
	vpaddq	%ymm4, %ymm10, %ymm4
	vpaddq	58080(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm9, %ymm6
	vpaddq	58048(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm5, %ymm8, %ymm5
	vpblendd	$170, %ymm15, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 58048(%rsp,%rbx)
	vmovdqa	%ymm10, 58080(%rsp,%rbx)
	vmovdqa	%ymm9, 57984(%rsp,%rbx)
	vmovdqa	%ymm8, 58016(%rsp,%rbx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r12d
	jne	.LBB2_93
# %bb.94:                               # %for_test573.for_exit576_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_106 Depth=3
	testb	$1, %r11b
	jne	.LBB2_95
	jmp	.LBB2_96
	.p2align	4, 0x90
.LBB2_97:                               # %for_loop607.lr.ph
                                        #   in Loop: Header=BB2_105 Depth=2
	movl	416(%rsp), %esi         # 4-byte Reload
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	288(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	320(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpcmpeqd	%ymm0, %ymm15, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm15, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI2_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	vpxor	%xmm12, %xmm12, %xmm12
	movl	%r11d, %eax
	xorl	%ecx, %ecx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm11, %xmm11, %xmm11
	vmovdqa	160(%rsp), %ymm15       # 32-byte Reload
	.p2align	4, 0x90
.LBB2_98:                               # %for_loop607
                                        #   Parent Loop BB2_77 Depth=1
                                        #     Parent Loop BB2_105 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%eax, %edx
	shlq	$7, %rdx
	vmovdqa	57984(%rsp,%rdx), %ymm0
	vmovdqa	58016(%rsp,%rdx), %ymm1
	vmovdqa	%ymm8, %ymm2
	vmovdqa	58048(%rsp,%rdx), %ymm8
	vmovdqa	58080(%rsp,%rdx), %ymm9
	vpaddq	640(%rsp,%rcx), %ymm0, %ymm0
	vpaddq	672(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	704(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	736(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm0, %ymm0, %ymm10
	vblendvpd	%ymm4, %ymm10, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm10
	vblendvpd	%ymm5, %ymm10, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm8, %ymm10
	vblendvpd	%ymm6, %ymm10, %ymm8, %ymm8
	vpaddq	%ymm9, %ymm9, %ymm10
	vblendvpd	%ymm7, %ymm10, %ymm9, %ymm9
	vpaddq	%ymm8, %ymm14, %ymm3
	vpblendd	$170, %ymm11, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm11[1],ymm3[2],ymm11[3],ymm3[4],ymm11[5],ymm3[6],ymm11[7]
	vmovdqa	%ymm8, 704(%rsp,%rcx)
	vpaddq	%ymm2, %ymm9, %ymm2
	vpblendd	$170, %ymm11, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm11[1],ymm2[2],ymm11[3],ymm2[4],ymm11[5],ymm2[6],ymm11[7]
	vmovdqa	%ymm8, 736(%rsp,%rcx)
	vpaddq	%ymm0, %ymm12, %ymm0
	vpblendd	$170, %ymm11, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm11[1],ymm0[2],ymm11[3],ymm0[4],ymm11[5],ymm0[6],ymm11[7]
	vmovdqa	%ymm8, 640(%rsp,%rcx)
	vpaddq	%ymm1, %ymm13, %ymm1
	vpblendd	$170, %ymm11, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm11[1],ymm1[2],ymm11[3],ymm1[4],ymm11[5],ymm1[6],ymm11[7]
	vmovdqa	%ymm8, 672(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm8
	vpsrlq	$32, %ymm3, %ymm14
	vpsrlq	$32, %ymm1, %ymm13
	vpsrlq	$32, %ymm0, %ymm12
	subq	$-128, %rcx
	incl	%eax
	cmpq	%rcx, %r14
	jne	.LBB2_98
# %bb.99:                               # %for_test648.preheader
                                        #   in Loop: Header=BB2_105 Depth=2
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpcmpeqd	%ymm7, %ymm7, %ymm7
	vmovdqa	384(%rsp), %ymm2        # 32-byte Reload
	vmovdqa	352(%rsp), %ymm3        # 32-byte Reload
	vmovdqa	192(%rsp), %ymm9        # 32-byte Reload
	.p2align	4, 0x90
.LBB2_100:                              # %for_test648
                                        #   Parent Loop BB2_77 Depth=1
                                        #     Parent Loop BB2_105 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_102 Depth 4
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqq	%ymm4, %ymm13, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm4, %ymm12, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm5, %ymm0, %ymm5
	vpcmpeqq	%ymm4, %ymm8, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm4, %ymm14, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm7, %ymm0, %ymm7
	vpand	%ymm5, %ymm15, %ymm0
	vmovmskps	%ymm0, %eax
	vpand	%ymm7, %ymm9, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_104
# %bb.101:                              # %for_loop667.lr.ph
                                        #   in Loop: Header=BB2_100 Depth=3
	vmovdqa	%ymm14, 512(%rsp)       # 32-byte Spill
	vmovdqa	%ymm8, 544(%rsp)        # 32-byte Spill
	vmovdqa	%ymm13, 576(%rsp)       # 32-byte Spill
	vmovdqa	%ymm12, 608(%rsp)       # 32-byte Spill
	vmovdqa	.LCPI2_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm5, %ymm0, %ymm1
	vmovdqa	%ymm1, 64(%rsp)         # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovdqa	%ymm5, 480(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm1, %ymm4
	vmovdqa	%ymm4, 32(%rsp)         # 32-byte Spill
	vpermd	%ymm7, %ymm0, %ymm0
	vmovdqa	%ymm0, 96(%rsp)         # 32-byte Spill
	vmovdqa	%ymm7, 448(%rsp)        # 32-byte Spill
	vpermd	%ymm7, %ymm1, %ymm9
	vpxor	%xmm14, %xmm14, %xmm14
	movl	$0, %eax
	vpxor	%xmm15, %xmm15, %xmm15
	vmovdqa	%ymm2, %ymm6
	vmovdqa	%ymm3, %ymm7
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB2_102:                              # %for_loop667
                                        #   Parent Loop BB2_77 Depth=1
                                        #     Parent Loop BB2_105 Depth=2
                                        #       Parent Loop BB2_100 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	640(%rsp,%rax,2), %ymm2
	vmovdqa	17024(%rsp,%rax), %ymm0
	vmovdqa	17056(%rsp,%rax), %ymm1
	vpsllvd	%ymm6, %ymm0, %ymm3
	vpor	%ymm3, %ymm14, %ymm3
	vpsllvd	%ymm6, %ymm1, %ymm14
	vmovdqa	736(%rsp,%rax,2), %ymm4
	vpor	%ymm15, %ymm14, %ymm14
	vextracti128	$1, %ymm14, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm4, %ymm5
	vpaddq	%ymm5, %ymm13, %ymm5
	vmovdqa	704(%rsp,%rax,2), %ymm13
	vpmovzxdq	%xmm14, %ymm14  # ymm14 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm14, %ymm13, %ymm14
	vpaddq	%ymm12, %ymm14, %ymm12
	vpmovzxdq	%xmm3, %ymm14   # ymm14 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm14, %ymm2, %ymm14
	vpaddq	%ymm11, %ymm14, %ymm11
	vpblendd	$170, %ymm8, %ymm11, %ymm14 # ymm14 = ymm11[0],ymm8[1],ymm11[2],ymm8[3],ymm11[4],ymm8[5],ymm11[6],ymm8[7]
	vmovapd	64(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm14, %ymm2, %ymm2
	vmovdqa	672(%rsp,%rax,2), %ymm14
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm14, %ymm3
	vpaddq	%ymm3, %ymm10, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm10 # ymm10 = ymm3[0],ymm8[1],ymm3[2],ymm8[3],ymm3[4],ymm8[5],ymm3[6],ymm8[7]
	vmovapd	32(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm10, %ymm14, %ymm10
	vpblendd	$170, %ymm8, %ymm12, %ymm14 # ymm14 = ymm12[0],ymm8[1],ymm12[2],ymm8[3],ymm12[4],ymm8[5],ymm12[6],ymm8[7]
	vmovapd	96(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm14, %ymm13, %ymm13
	vpblendd	$170, %ymm8, %ymm5, %ymm14 # ymm14 = ymm5[0],ymm8[1],ymm5[2],ymm8[3],ymm5[4],ymm8[5],ymm5[6],ymm8[7]
	vblendvpd	%ymm9, %ymm14, %ymm4, %ymm4
	vmovapd	%ymm13, 704(%rsp,%rax,2)
	vmovapd	%ymm4, 736(%rsp,%rax,2)
	vmovapd	%ymm2, 640(%rsp,%rax,2)
	vpsrlvd	%ymm7, %ymm1, %ymm15
	vpsrlvd	%ymm7, %ymm0, %ymm14
	vmovapd	%ymm10, 672(%rsp,%rax,2)
	vpsrad	$31, %ymm5, %ymm0
	vpshufd	$245, %ymm5, %ymm1      # ymm1 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm12, %ymm0
	vpshufd	$245, %ymm12, %ymm1     # ymm1 = ymm12[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm1      # ymm1 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	$64, %rax
	cmpq	%rax, %r13
	jne	.LBB2_102
# %bb.103:                              # %for_exit669
                                        #   in Loop: Header=BB2_100 Depth=3
	vmovdqa	544(%rsp), %ymm8        # 32-byte Reload
	vpaddq	%ymm8, %ymm13, %ymm0
	vmovdqa	512(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm12, %ymm1
	vmovdqa	576(%rsp), %ymm13       # 32-byte Reload
	vpaddq	%ymm13, %ymm10, %ymm2
	vmovdqa	608(%rsp), %ymm12       # 32-byte Reload
	vpaddq	%ymm12, %ymm11, %ymm3
	vmovapd	64(%rsp), %ymm4         # 32-byte Reload
	vblendvpd	%ymm4, %ymm3, %ymm12, %ymm12
	vmovapd	32(%rsp), %ymm3         # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm13, %ymm13
	vmovapd	96(%rsp), %ymm2         # 32-byte Reload
	vblendvpd	%ymm2, %ymm1, %ymm14, %ymm14
	vblendvpd	%ymm9, %ymm0, %ymm8, %ymm8
	vmovdqa	192(%rsp), %ymm9        # 32-byte Reload
	vmovdqa	160(%rsp), %ymm15       # 32-byte Reload
	vmovdqa	%ymm6, %ymm2
	vmovdqa	%ymm7, %ymm3
	vmovdqa	480(%rsp), %ymm5        # 32-byte Reload
	vmovdqa	448(%rsp), %ymm7        # 32-byte Reload
	jmp	.LBB2_100
.LBB2_81:                               # %for_test720.preheader
	testl	%r11d, %r11d
	je	.LBB2_82
# %bb.83:                               # %for_loop721.lr.ph
	leal	-1(%r11), %r8d
	movl	%r11d, %eax
	andl	$3, %eax
	cmpl	$3, %r8d
	jae	.LBB2_116
# %bb.84:
	xorl	%ecx, %ecx
	jmp	.LBB2_85
.LBB2_54:                               # %for_loop189.lr.ph.new
	movl	%r11d, %r9d
	movl	%r11d, %esi
	subl	%eax, %esi
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_55:                               # %for_loop189
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	8448(%rsp,%rdi), %ymm1
	vmovaps	8512(%rsp,%rdi), %ymm2
	vmovaps	8544(%rsp,%rdi), %ymm3
	vmovaps	%ymm1, 41216(%rsp,%rdi)
	vmovaps	%ymm3, 41312(%rsp,%rdi)
	vmovaps	%ymm2, 41280(%rsp,%rdi)
	vmovaps	8480(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 41248(%rsp,%rdi)
	leaq	(%r9,%rcx), %rbx
	movl	%ebx, %edx
	shlq	$7, %rdx
	vmovdqa	%ymm0, 41600(%rsp,%rdx)
	vmovdqa	%ymm0, 41696(%rsp,%rdx)
	vmovdqa	%ymm0, 41664(%rsp,%rdx)
	vmovdqa	%ymm0, 41632(%rsp,%rdx)
	vmovaps	8608(%rsp,%rdi), %ymm1
	vmovaps	8640(%rsp,%rdi), %ymm2
	vmovaps	8672(%rsp,%rdi), %ymm3
	vmovaps	8576(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 41344(%rsp,%rdi)
	vmovaps	%ymm3, 41440(%rsp,%rdi)
	vmovaps	%ymm2, 41408(%rsp,%rdi)
	vmovaps	%ymm1, 41376(%rsp,%rdi)
	leal	1(%rbx), %edx
	shlq	$7, %rdx
	vmovdqa	%ymm0, 41600(%rsp,%rdx)
	vmovdqa	%ymm0, 41696(%rsp,%rdx)
	vmovdqa	%ymm0, 41664(%rsp,%rdx)
	vmovdqa	%ymm0, 41632(%rsp,%rdx)
	vmovaps	8736(%rsp,%rdi), %ymm1
	vmovaps	8768(%rsp,%rdi), %ymm2
	vmovaps	8800(%rsp,%rdi), %ymm3
	vmovaps	8704(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 41472(%rsp,%rdi)
	vmovaps	%ymm3, 41568(%rsp,%rdi)
	vmovaps	%ymm2, 41536(%rsp,%rdi)
	vmovaps	%ymm1, 41504(%rsp,%rdi)
	leal	2(%rbx), %edx
	shlq	$7, %rdx
	vmovdqa	%ymm0, 41600(%rsp,%rdx)
	vmovdqa	%ymm0, 41696(%rsp,%rdx)
	vmovdqa	%ymm0, 41664(%rsp,%rdx)
	vmovdqa	%ymm0, 41632(%rsp,%rdx)
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
	cmpl	%ecx, %esi
	jne	.LBB2_55
.LBB2_23:                               # %for_test188.for_test206.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	vmovdqa	320(%rsp), %ymm14       # 32-byte Reload
	vmovdqa	288(%rsp), %ymm15       # 32-byte Reload
	je	.LBB2_26
# %bb.24:                               # %for_loop189.epil.preheader
	leal	(%r11,%rcx), %edx
	shlq	$7, %rcx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_25:                               # %for_loop189.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	8832(%rsp,%rcx), %ymm1
	vmovdqa	8864(%rsp,%rcx), %ymm2
	vmovdqa	8896(%rsp,%rcx), %ymm3
	vmovdqa	8928(%rsp,%rcx), %ymm4
	vmovdqa	%ymm3, 41664(%rsp,%rcx)
	vmovdqa	%ymm4, 41696(%rsp,%rcx)
	vmovdqa	%ymm1, 41600(%rsp,%rcx)
	vmovdqa	%ymm2, 41632(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41664(%rsp,%rsi)
	vmovdqa	%ymm0, 41696(%rsp,%rsi)
	vmovdqa	%ymm0, 41600(%rsp,%rsi)
	vmovdqa	%ymm0, 41632(%rsp,%rsi)
	incl	%edx
	subq	$-128, %rcx
	decl	%eax
	jne	.LBB2_25
.LBB2_26:                               # %for_test206.preheader
	testl	%r11d, %r11d
	je	.LBB2_20
# %bb.27:                               # %for_loop207.lr.ph.split.us
	movl	%r11d, %r10d
	leaq	21184(%rsp), %r9
	movl	%r11d, %esi
	andl	$-2, %esi
	movl	$1, %edi
	xorl	%ebx, %ebx
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB2_28
	.p2align	4, 0x90
.LBB2_29:                               #   in Loop: Header=BB2_28 Depth=1
	vpxor	%xmm7, %xmm7, %xmm7
	vxorps	%xmm9, %xmm9, %xmm9
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	xorl	%edx, %edx
.LBB2_49:                               # %for_loop223.us.epil.preheader
                                        #   in Loop: Header=BB2_28 Depth=1
	movq	%rdx, %rax
	shlq	$6, %rax
	vpmovzxdq	21152(%rsp,%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21168(%rsp,%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21120(%rsp,%rax), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21136(%rsp,%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm4
	vpmuludq	%ymm5, %ymm12, %ymm5
	vpmuludq	%ymm2, %ymm11, %ymm2
	vpmuludq	%ymm3, %ymm10, %ymm3
	addl	%ebx, %edx
	shlq	$7, %rdx
	vpaddq	41632(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	41600(%rsp,%rdx), %ymm7, %ymm7
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	%ymm5, %ymm7, %ymm5
	vpaddq	41696(%rsp,%rdx), %ymm8, %ymm7
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	41664(%rsp,%rdx), %ymm6, %ymm6
	vpaddq	%ymm3, %ymm6, %ymm3
	vpblendd	$170, %ymm1, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm9, 41664(%rsp,%rdx)
	vmovdqa	%ymm8, 41696(%rsp,%rdx)
	vmovdqa	%ymm7, 41600(%rsp,%rdx)
	vmovdqa	%ymm6, 41632(%rsp,%rdx)
	vpsrlq	$32, %ymm2, %ymm8
	vpsrlq	$32, %ymm3, %ymm6
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm7
.LBB2_50:                               # %for_exit225.us
                                        #   in Loop: Header=BB2_28 Depth=1
	vmovdqa	%ymm9, 8864(%rsp,%r11)
	vmovdqa	%ymm7, 8832(%rsp,%r11)
	vmovdqa	%ymm6, 8896(%rsp,%r11)
	vmovdqa	%ymm8, 8928(%rsp,%r11)
	incq	%rbx
	incq	%rdi
	cmpq	%r10, %rbx
	je	.LBB2_51
.LBB2_28:                               # %for_loop223.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_47 Depth 2
	movq	%rbx, %r11
	shlq	$7, %r11
	vpermd	41664(%rsp,%r11), %ymm0, %ymm2
	vpermd	41696(%rsp,%r11), %ymm0, %ymm3
	vpermd	41600(%rsp,%r11), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	41632(%rsp,%r11), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	%ymm3, %ymm14, %ymm5
	vpmulld	%ymm2, %ymm15, %ymm3
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	cmpl	$1, 24(%rsp)            # 4-byte Folded Reload
	je	.LBB2_29
# %bb.46:                               # %for_loop223.lr.ph.us.new
                                        #   in Loop: Header=BB2_28 Depth=1
	vpxor	%xmm7, %xmm7, %xmm7
	movq	%r9, %rcx
	xorl	%edx, %edx
	vxorps	%xmm9, %xmm9, %xmm9
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB2_47:                               # %for_loop223.us
                                        #   Parent Loop BB2_28 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-32(%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rcx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-16(%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm13, %ymm13
	vpmuludq	%ymm5, %ymm12, %ymm12
	vpmuludq	%ymm4, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	leal	(%rbx,%rdx), %eax
	shlq	$7, %rax
	vpaddq	41696(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	41600(%rsp,%rax), %ymm7, %ymm7
	vpaddq	%ymm7, %ymm12, %ymm7
	vpaddq	41632(%rsp,%rax), %ymm9, %ymm9
	vpaddq	41664(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm9, %ymm9
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 41664(%rsp,%rax)
	vmovdqa	%ymm12, 41632(%rsp,%rax)
	vmovdqa	%ymm11, 41600(%rsp,%rax)
	vmovdqa	%ymm10, 41696(%rsp,%rax)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	32(%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	(%rcx), %ymm12  # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm5, %ymm12, %ymm12
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	leal	(%rdi,%rdx), %eax
	shlq	$7, %rax
	vpaddq	41632(%rsp,%rax), %ymm9, %ymm9
	vpaddq	41600(%rsp,%rax), %ymm7, %ymm7
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm7, %ymm12, %ymm7
	vpaddq	41696(%rsp,%rax), %ymm8, %ymm8
	vpaddq	%ymm11, %ymm8, %ymm8
	vpaddq	41664(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 41664(%rsp,%rax)
	vmovdqa	%ymm12, 41696(%rsp,%rax)
	vmovdqa	%ymm11, 41600(%rsp,%rax)
	vmovdqa	%ymm10, 41632(%rsp,%rax)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	addq	$2, %rdx
	subq	$-128, %rcx
	cmpl	%edx, %esi
	jne	.LBB2_47
# %bb.48:                               # %for_test222.for_exit225_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_28 Depth=1
	testb	$1, 24(%rsp)            # 1-byte Folded Reload
	jne	.LBB2_49
	jmp	.LBB2_50
.LBB2_51:                               # %for_test255.preheader
	movq	24(%rsp), %r11          # 8-byte Reload
	testl	%r11d, %r11d
	je	.LBB2_20
# %bb.52:                               # %for_loop256.lr.ph
	movl	%r11d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB2_56
# %bb.53:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB2_58
.LBB2_20:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	8(%rsp), %rbx           # 8-byte Reload
	jmp	.LBB2_62
.LBB2_116:                              # %for_loop721.lr.ph.new
	movl	%r11d, %edx
	subl	%eax, %edx
	movl	$384, %esi              # imm = 0x180
	xorl	%ecx, %ecx
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_117:                              # %for_loop721
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	256(%rsp,%rsi), %ymm1
	vmovaps	320(%rsp,%rsi), %ymm2
	vmovaps	352(%rsp,%rsi), %ymm3
	vmovaps	%ymm1, 24832(%rsp,%rsi)
	vmovaps	%ymm3, 24928(%rsp,%rsi)
	vmovaps	%ymm2, 24896(%rsp,%rsi)
	vmovaps	288(%rsp,%rsi), %ymm1
	vmovaps	%ymm1, 24864(%rsp,%rsi)
	leaq	(%r15,%rcx), %rdi
	movl	%edi, %ebx
	shlq	$7, %rbx
	vmovaps	%ymm0, 25216(%rsp,%rbx)
	vmovaps	%ymm0, 25312(%rsp,%rbx)
	vmovaps	%ymm0, 25280(%rsp,%rbx)
	vmovaps	%ymm0, 25248(%rsp,%rbx)
	vmovaps	416(%rsp,%rsi), %ymm1
	vmovaps	448(%rsp,%rsi), %ymm2
	vmovaps	480(%rsp,%rsi), %ymm3
	vmovaps	384(%rsp,%rsi), %ymm4
	vmovaps	%ymm4, 24960(%rsp,%rsi)
	vmovaps	%ymm3, 25056(%rsp,%rsi)
	vmovaps	%ymm2, 25024(%rsp,%rsi)
	vmovaps	%ymm1, 24992(%rsp,%rsi)
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vmovaps	%ymm0, 25216(%rsp,%rbx)
	vmovaps	%ymm0, 25312(%rsp,%rbx)
	vmovaps	%ymm0, 25280(%rsp,%rbx)
	vmovaps	%ymm0, 25248(%rsp,%rbx)
	vmovaps	544(%rsp,%rsi), %ymm1
	vmovaps	576(%rsp,%rsi), %ymm2
	vmovaps	608(%rsp,%rsi), %ymm3
	vmovaps	512(%rsp,%rsi), %ymm4
	vmovaps	%ymm4, 25088(%rsp,%rsi)
	vmovaps	%ymm3, 25184(%rsp,%rsi)
	vmovaps	%ymm2, 25152(%rsp,%rsi)
	vmovaps	%ymm1, 25120(%rsp,%rsi)
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vmovaps	%ymm0, 25216(%rsp,%rbx)
	vmovaps	%ymm0, 25312(%rsp,%rbx)
	vmovaps	%ymm0, 25280(%rsp,%rbx)
	vmovaps	%ymm0, 25248(%rsp,%rbx)
	vmovdqa	640(%rsp,%rsi), %ymm1
	vmovdqa	672(%rsp,%rsi), %ymm2
	vmovdqa	704(%rsp,%rsi), %ymm3
	vmovdqa	736(%rsp,%rsi), %ymm4
	vmovdqa	%ymm4, 25312(%rsp,%rsi)
	vmovdqa	%ymm3, 25280(%rsp,%rsi)
	vmovdqa	%ymm2, 25248(%rsp,%rsi)
	vmovdqa	%ymm1, 25216(%rsp,%rsi)
	addl	$3, %edi
	shlq	$7, %rdi
	vmovaps	%ymm0, 25312(%rsp,%rdi)
	vmovaps	%ymm0, 25280(%rsp,%rdi)
	vmovaps	%ymm0, 25248(%rsp,%rdi)
	vmovaps	%ymm0, 25216(%rsp,%rdi)
	addq	$4, %rcx
	addq	$512, %rsi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB2_117
.LBB2_85:                               # %for_test720.for_test738.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	je	.LBB2_88
# %bb.86:                               # %for_loop721.epil.preheader
	leal	(%r11,%rcx), %edx
	shlq	$7, %rcx
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_87:                               # %for_loop721.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rcx), %ymm1
	vmovdqa	672(%rsp,%rcx), %ymm2
	vmovdqa	704(%rsp,%rcx), %ymm3
	vmovdqa	736(%rsp,%rcx), %ymm4
	vmovdqa	%ymm3, 25280(%rsp,%rcx)
	vmovdqa	%ymm4, 25312(%rsp,%rcx)
	vmovdqa	%ymm1, 25216(%rsp,%rcx)
	vmovdqa	%ymm2, 25248(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25280(%rsp,%rsi)
	vmovaps	%ymm0, 25312(%rsp,%rsi)
	vmovaps	%ymm0, 25216(%rsp,%rsi)
	vmovaps	%ymm0, 25248(%rsp,%rsi)
	incl	%edx
	subq	$-128, %rcx
	decl	%eax
	jne	.LBB2_87
.LBB2_88:                               # %for_test738.preheader
	testl	%r11d, %r11d
	je	.LBB2_82
# %bb.89:                               # %for_loop739.lr.ph.split.us
	leaq	17088(%rsp), %r9
	movl	%r11d, %edx
	andl	$-2, %edx
	movl	$1, %esi
	xorl	%edi, %edi
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	vmovaps	%ymm9, %ymm14
	jmp	.LBB2_90
	.p2align	4, 0x90
.LBB2_91:                               #   in Loop: Header=BB2_90 Depth=1
	vxorps	%xmm9, %xmm9, %xmm9
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	xorl	%ecx, %ecx
.LBB2_111:                              # %for_loop755.us.epil.preheader
                                        #   in Loop: Header=BB2_90 Depth=1
	movq	%rcx, %rax
	shlq	$6, %rax
	vpmovzxdq	17056(%rsp,%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17072(%rsp,%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17024(%rsp,%rax), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17040(%rsp,%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm4
	vpmuludq	%ymm5, %ymm12, %ymm5
	vpmuludq	%ymm2, %ymm11, %ymm2
	vpmuludq	%ymm3, %ymm10, %ymm3
	addl	%edi, %ecx
	shlq	$7, %rcx
	vpaddq	25248(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	25216(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	%ymm5, %ymm7, %ymm5
	vpaddq	25312(%rsp,%rcx), %ymm8, %ymm7
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	25280(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm3, %ymm6, %ymm3
	vpblendd	$170, %ymm1, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm9, 25280(%rsp,%rcx)
	vmovdqa	%ymm8, 25312(%rsp,%rcx)
	vmovdqa	%ymm7, 25216(%rsp,%rcx)
	vmovdqa	%ymm6, 25248(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm8
	vpsrlq	$32, %ymm3, %ymm6
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm7
.LBB2_112:                              # %for_exit757.us
                                        #   in Loop: Header=BB2_90 Depth=1
	vmovdqa	%ymm9, 672(%rsp,%r10)
	vmovdqa	%ymm7, 640(%rsp,%r10)
	vmovdqa	%ymm6, 704(%rsp,%r10)
	vmovdqa	%ymm8, 736(%rsp,%r10)
	incq	%rdi
	incq	%rsi
	cmpq	%r15, %rdi
	je	.LBB2_113
.LBB2_90:                               # %for_loop755.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_109 Depth 2
	movq	%rdi, %r10
	shlq	$7, %r10
	vpermd	25280(%rsp,%r10), %ymm0, %ymm2
	vpermd	25312(%rsp,%r10), %ymm0, %ymm3
	vpermd	25216(%rsp,%r10), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	25248(%rsp,%r10), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	256(%rsp), %ymm3, %ymm5 # 32-byte Folded Reload
	vpmulld	224(%rsp), %ymm2, %ymm3 # 32-byte Folded Reload
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpxor	%xmm7, %xmm7, %xmm7
	cmpl	$1, %r11d
	je	.LBB2_91
# %bb.108:                              # %for_loop755.lr.ph.us.new
                                        #   in Loop: Header=BB2_90 Depth=1
	movq	%r9, %rax
	xorl	%ecx, %ecx
	vxorps	%xmm9, %xmm9, %xmm9
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB2_109:                              # %for_loop755.us
                                        #   Parent Loop BB2_90 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-32(%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rax), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-16(%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm13, %ymm13
	vpmuludq	%ymm5, %ymm12, %ymm12
	vpmuludq	%ymm4, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	leal	(%rdi,%rcx), %ebx
	shlq	$7, %rbx
	vpaddq	25312(%rsp,%rbx), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	25216(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm7, %ymm12, %ymm7
	vpaddq	25248(%rsp,%rbx), %ymm9, %ymm9
	vpaddq	25280(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm9, %ymm9
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 25280(%rsp,%rbx)
	vmovdqa	%ymm12, 25248(%rsp,%rbx)
	vmovdqa	%ymm11, 25216(%rsp,%rbx)
	vmovdqa	%ymm10, 25312(%rsp,%rbx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	32(%rax), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rax), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	(%rax), %ymm12  # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rax), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm5, %ymm12, %ymm12
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	leal	(%rsi,%rcx), %ebx
	shlq	$7, %rbx
	vpaddq	25248(%rsp,%rbx), %ymm9, %ymm9
	vpaddq	25216(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm7, %ymm12, %ymm7
	vpaddq	25312(%rsp,%rbx), %ymm8, %ymm8
	vpaddq	%ymm11, %ymm8, %ymm8
	vpaddq	25280(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 25280(%rsp,%rbx)
	vmovdqa	%ymm12, 25312(%rsp,%rbx)
	vmovdqa	%ymm11, 25216(%rsp,%rbx)
	vmovdqa	%ymm10, 25248(%rsp,%rbx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	addq	$2, %rcx
	subq	$-128, %rax
	cmpl	%ecx, %edx
	jne	.LBB2_109
# %bb.110:                              # %for_test754.for_exit757_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_90 Depth=1
	testb	$1, %r11b
	jne	.LBB2_111
	jmp	.LBB2_112
.LBB2_113:                              # %for_test787.preheader
	vmovaps	%ymm14, %ymm9
	testl	%r11d, %r11d
	je	.LBB2_82
# %bb.114:                              # %for_loop788.lr.ph
	movl	%r11d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB2_118
# %bb.115:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB2_120
.LBB2_82:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	8(%rsp), %rbx           # 8-byte Reload
	jmp	.LBB2_124
.LBB2_56:                               # %for_loop256.lr.ph.new
	leaq	9216(%rsp), %rdx
	movl	%r11d, %esi
	subl	%ecx, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	movl	%r11d, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_57:                               # %for_loop256
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-288(%rdx), %ymm3, %ymm3
	vpaddq	-384(%rdx), %ymm2, %ymm2
	vpaddq	-352(%rdx), %ymm4, %ymm4
	vpaddq	-320(%rdx), %ymm1, %ymm1
	movl	%edi, %ebx
	shlq	$7, %rbx
	vpaddq	41664(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	41632(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	41600(%rsp,%rbx), %ymm2, %ymm2
	vpaddq	41696(%rsp,%rbx), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, -320(%rdx)
	vmovdqa	%ymm7, -352(%rdx)
	vmovdqa	%ymm6, -384(%rdx)
	vmovdqa	%ymm5, -288(%rdx)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	-160(%rdx), %ymm3, %ymm3
	vpaddq	-256(%rdx), %ymm2, %ymm2
	vpaddq	-224(%rdx), %ymm4, %ymm4
	vpaddq	-192(%rdx), %ymm1, %ymm1
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	41664(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	41632(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	41600(%rsp,%rbx), %ymm2, %ymm2
	vpaddq	41696(%rsp,%rbx), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, -192(%rdx)
	vmovdqa	%ymm7, -224(%rdx)
	vmovdqa	%ymm6, -256(%rdx)
	vmovdqa	%ymm5, -160(%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	-128(%rdx), %ymm2, %ymm2
	vpaddq	-96(%rdx), %ymm4, %ymm4
	vpaddq	-64(%rdx), %ymm1, %ymm1
	vpaddq	-32(%rdx), %ymm3, %ymm3
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	41696(%rsp,%rbx), %ymm3, %ymm3
	vpaddq	41664(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	41632(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	41600(%rsp,%rbx), %ymm2, %ymm2
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm8, -32(%rdx)
	vmovdqa	%ymm7, -64(%rdx)
	vmovdqa	%ymm6, -96(%rdx)
	vmovdqa	%ymm5, -128(%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	(%rdx), %ymm2, %ymm2
	vpaddq	32(%rdx), %ymm4, %ymm4
	vpaddq	64(%rdx), %ymm1, %ymm1
	vpaddq	96(%rdx), %ymm3, %ymm3
	leal	3(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	41696(%rsp,%rbx), %ymm3, %ymm3
	vpaddq	41664(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	41632(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	41600(%rsp,%rbx), %ymm2, %ymm2
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm8, 96(%rdx)
	vmovdqa	%ymm7, 64(%rdx)
	vmovdqa	%ymm6, 32(%rdx)
	vmovdqa	%ymm5, (%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	addq	$4, %rax
	addq	$512, %rdx              # imm = 0x200
	addl	$4, %edi
	cmpl	%eax, %esi
	jne	.LBB2_57
.LBB2_58:                               # %for_test255.for_exit258_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	movq	8(%rsp), %rbx           # 8-byte Reload
	je	.LBB2_61
# %bb.59:                               # %for_loop256.epil.preheader
	leal	(%r11,%rax), %edx
	shlq	$7, %rax
	addq	%rsp, %rax
	addq	$8832, %rax             # imm = 0x2280
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_60:                               # %for_loop256.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	96(%rax), %ymm3, %ymm3
	vpaddq	32(%rax), %ymm4, %ymm4
	vpaddq	(%rax), %ymm2, %ymm2
	vpaddq	64(%rax), %ymm1, %ymm1
	movl	%edx, %esi
	shlq	$7, %rsi
	vpaddq	41664(%rsp,%rsi), %ymm1, %ymm1
	vpaddq	41600(%rsp,%rsi), %ymm2, %ymm2
	vpaddq	41632(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	41696(%rsp,%rsi), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, 64(%rax)
	vmovdqa	%ymm7, (%rax)
	vmovdqa	%ymm6, 32(%rax)
	vmovdqa	%ymm5, 96(%rax)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	incl	%edx
	subq	$-128, %rax
	decl	%ecx
	jne	.LBB2_60
.LBB2_61:                               # %for_test255.for_exit258_crit_edge
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	%ymm0, %ymm4, %ymm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vpcmpeqq	%ymm0, %ymm2, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm6
	vpackssdw	%xmm6, %xmm2, %xmm2
	vinserti128	$1, %xmm4, %ymm2, %ymm4
	vpcmpeqq	%ymm0, %ymm3, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm1, %ymm0
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm5
.LBB2_62:                               # %for_exit258
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_66
# %bb.63:                               # %for_exit258
	testl	%r11d, %r11d
	je	.LBB2_66
# %bb.64:                               # %for_loop291.lr.ph
	movl	20(%rsp), %ecx          # 4-byte Reload
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm6   # ymm6 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm4, %ymm6, %ymm2
	vmovdqa	%ymm2, 64(%rsp)         # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm7   # ymm7 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm7, %ymm2
	vmovdqa	%ymm2, 32(%rsp)         # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 96(%rsp)         # 32-byte Spill
	vpermd	%ymm5, %ymm7, %ymm5
	movl	%r11d, %eax
	shlq	$6, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	vxorps	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB2_65:                               # %for_loop291
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	8832(%rsp,%rcx,2), %ymm15
	vmovdqa	21120(%rsp,%rcx), %ymm13
	vmovdqa	21152(%rsp,%rcx), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm2
	vpor	%ymm2, %ymm12, %ymm2
	vpsllvd	%ymm0, %ymm14, %ymm12
	vmovdqa	8928(%rsp,%rcx,2), %ymm3
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm11, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm3, %ymm4
	vpaddq	%ymm4, %ymm10, %ymm4
	vmovdqa	8896(%rsp,%rcx,2), %ymm10
	vpmovzxdq	%xmm11, %ymm11  # ymm11 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm11, %ymm10, %ymm11
	vpaddq	%ymm9, %ymm11, %ymm9
	vpmovzxdq	%xmm2, %ymm11   # ymm11 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm11, %ymm15, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	64(%rsp), %ymm12        # 32-byte Reload
	vblendvpd	%ymm12, %ymm11, %ymm15, %ymm11
	vmovdqa	8864(%rsp,%rcx,2), %ymm12
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm2, %ymm12, %ymm2
	vpaddq	%ymm7, %ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm6[1],ymm2[2],ymm6[3],ymm2[4],ymm6[5],ymm2[6],ymm6[7]
	vmovapd	32(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm7, %ymm12, %ymm7
	vpblendd	$170, %ymm6, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vmovapd	96(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm12, %ymm10, %ymm10
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vblendvpd	%ymm5, %ymm12, %ymm3, %ymm3
	vmovapd	%ymm10, 8896(%rsp,%rcx,2)
	vmovapd	%ymm3, 8928(%rsp,%rcx,2)
	vmovapd	%ymm11, 8832(%rsp,%rcx,2)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm7, 8864(%rsp,%rcx,2)
	vpsrad	$31, %ymm4, %ymm3
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm9, %ymm3
	vpshufd	$245, %ymm9, %ymm4      # ymm4 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm2, %ymm3
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm3[1],ymm2[2],ymm3[3],ymm2[4],ymm3[5],ymm2[6],ymm3[7]
	vpsrad	$31, %ymm8, %ymm2
	vpshufd	$245, %ymm8, %ymm3      # ymm3 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	addq	$64, %rcx
	cmpq	%rcx, %rax
	jne	.LBB2_65
.LBB2_66:                               # %safe_if_after_true
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	8928(%rsp,%rax), %ymm0, %ymm2
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpcmpeqq	8896(%rsp,%rax), %ymm0, %ymm4
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpxor	%ymm1, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vinserti128	$1, %xmm2, %ymm3, %ymm11
	vpcmpeqq	8864(%rsp,%rax), %ymm0, %ymm2
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	8832(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm1, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpackssdw	%xmm3, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm10
	vmovmskps	%ymm10, %eax
	vmovmskps	%ymm11, %ecx
	movl	%ecx, %edx
	shll	$8, %edx
	orl	%eax, %edx
	je	.LBB2_67
# %bb.132:                              # %for_test349.preheader
	vpbroadcastd	.LCPI2_5(%rip), %ymm4 # ymm4 = [1,1,1,1,1,1,1,1]
	xorl	%edx, %edx
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vmovdqa	.LCPI2_6(%rip), %xmm13  # xmm13 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vmovdqa	.LCPI2_7(%rip), %xmm12  # xmm12 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vmovdqa	%ymm4, %ymm9
	vmovaps	%ymm10, 32(%rsp)        # 32-byte Spill
	vmovaps	%ymm11, 64(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_133:                              # %for_test349
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%r11d, %edx
	sbbl	%esi, %esi
	vmovd	%esi, %xmm3
	vpbroadcastd	%xmm3, %ymm3
	vpshufd	$78, %xmm0, %xmm7       # xmm7 = xmm0[2,3,0,1]
	vpmovsxbd	%xmm7, %ymm7
	vpand	%ymm7, %ymm11, %ymm7
	vpmovsxbd	%xmm0, %ymm11
	vpand	%ymm11, %ymm10, %ymm10
	vpand	%ymm3, %ymm7, %ymm11
	vpand	%ymm3, %ymm10, %ymm10
	vmovmskps	%ymm10, %esi
	vmovmskps	%ymm11, %edi
	shll	$8, %edi
	orl	%esi, %edi
	je	.LBB2_134
# %bb.135:                              # %for_loop350
                                        #   in Loop: Header=BB2_133 Depth=1
	movl	%edx, %esi
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vmovdqa	21120(%rsp,%rdi), %ymm3
	vmovdqa	21152(%rsp,%rdi), %ymm7
	vpaddd	%ymm4, %ymm3, %ymm14
	vpaddd	%ymm7, %ymm9, %ymm15
	vpmaxud	%ymm7, %ymm15, %ymm7
	vpcmpeqd	%ymm7, %ymm15, %ymm7
	vpbroadcastd	.LCPI2_5(%rip), %ymm8 # ymm8 = [1,1,1,1,1,1,1,1]
	vpmaxud	%ymm3, %ymm14, %ymm3
	vpcmpeqd	%ymm3, %ymm14, %ymm3
	vpandn	%ymm8, %ymm3, %ymm3
	vblendvps	%ymm10, %ymm3, %ymm4, %ymm4
	vpandn	%ymm8, %ymm7, %ymm3
	vblendvps	%ymm11, %ymm3, %ymm9, %ymm9
	shlq	$7, %rsi
	vpmovzxdq	%xmm14, %ymm3   # ymm3 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm7
	vpmovzxdq	%xmm7, %ymm7    # ymm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
	vpmovzxdq	%xmm15, %ymm8   # ymm8 = xmm15[0],zero,xmm15[1],zero,xmm15[2],zero,xmm15[3],zero
	vextracti128	$1, %ymm15, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpcmpeqq	8928(%rsp,%rsi), %ymm2, %ymm2
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm5
	vpcmpeqq	8896(%rsp,%rsi), %ymm8, %ymm8
	vpackssdw	%xmm5, %xmm2, %xmm2
	vpxor	%ymm1, %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpackssdw	%xmm2, %xmm5, %xmm2
	vpcmpeqq	8864(%rsp,%rsi), %ymm7, %ymm5
	vpxor	%ymm1, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	8832(%rsp,%rsi), %ymm3, %ymm3
	vpxor	%ymm1, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm6
	vpackssdw	%xmm6, %xmm3, %xmm3
	vpackssdw	%xmm5, %xmm3, %xmm3
	vpacksswb	%xmm2, %xmm3, %xmm2
	vextracti128	$1, %ymm10, %xmm3
	vpshufb	%xmm13, %xmm3, %xmm3
	vpshufb	%xmm13, %xmm10, %xmm5
	vpunpckldq	%xmm3, %xmm5, %xmm3 # xmm3 = xmm5[0],xmm3[0],xmm5[1],xmm3[1]
	vextracti128	$1, %ymm11, %xmm5
	vpshufb	%xmm12, %xmm5, %xmm5
	vpshufb	%xmm12, %xmm11, %xmm6
	vpunpckldq	%xmm5, %xmm6, %xmm5 # xmm5 = xmm6[0],xmm5[0],xmm6[1],xmm5[1]
	vpblendd	$12, %xmm5, %xmm3, %xmm3 # xmm3 = xmm3[0,1],xmm5[2,3]
	vpand	%xmm3, %xmm2, %xmm2
	vpsllw	$7, %xmm2, %xmm2
	vpand	.LCPI2_8(%rip), %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpgtb	%xmm2, %xmm3, %xmm2
	vpandn	%xmm0, %xmm2, %xmm0
	incl	%edx
	jmp	.LBB2_133
.LBB2_134:
	vmovaps	64(%rsp), %ymm11        # 32-byte Reload
	vmovaps	32(%rsp), %ymm10        # 32-byte Reload
	jmp	.LBB2_68
.LBB2_67:
	vpcmpeqd	%xmm0, %xmm0, %xmm0
.LBB2_68:                               # %safe_if_after_true341
	xorl	$255, %eax
	xorl	$255, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_69
# %bb.136:                              # %safe_if_run_false407
	vpxor	%ymm1, %ymm10, %ymm3
	vpbroadcastq	.LCPI2_9(%rip), %ymm2 # ymm2 = [1,1,1,1]
	vpcmpeqq	8928(%rsp), %ymm2, %ymm4
	vpcmpeqq	8896(%rsp), %ymm2, %ymm5
	vpxor	%ymm1, %ymm11, %ymm1
	vpackssdw	%ymm4, %ymm5, %ymm4
	vpcmpeqq	8864(%rsp), %ymm2, %ymm5
	vpermq	$216, %ymm4, %ymm4      # ymm4 = ymm4[0,2,1,3]
	vpcmpeqq	8832(%rsp), %ymm2, %ymm2
	vpackssdw	%ymm5, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2      # ymm2 = ymm2[0,2,1,3]
	vpackssdw	%ymm4, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2      # ymm2 = ymm2[0,2,1,3]
	vextracti128	$1, %ymm2, %xmm4
	vpacksswb	%xmm4, %xmm2, %xmm8
	vextracti128	$1, %ymm3, %xmm4
	vmovdqa	.LCPI2_6(%rip), %xmm10  # xmm10 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm10, %xmm4, %xmm4
	vpshufb	%xmm10, %xmm3, %xmm6
	vpunpckldq	%xmm4, %xmm6, %xmm6 # xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
	vextracti128	$1, %ymm1, %xmm7
	vmovdqa	.LCPI2_7(%rip), %xmm12  # xmm12 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vpshufb	%xmm12, %xmm7, %xmm7
	vpshufb	%xmm12, %xmm1, %xmm5
	vpunpckldq	%xmm7, %xmm5, %xmm5 # xmm5 = xmm5[0],xmm7[0],xmm5[1],xmm7[1]
	vpblendd	$12, %xmm5, %xmm6, %xmm5 # xmm5 = xmm6[0,1],xmm5[2,3]
	vpsllw	$7, %xmm5, %xmm5
	vpblendvb	%xmm5, %xmm8, %xmm0, %xmm0
	movl	$1, %eax
	vpxor	%xmm13, %xmm13, %xmm13
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vmovdqa	.LCPI2_8(%rip), %xmm8   # xmm8 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vxorps	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB2_137:                              # %for_test417
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%r11d, %eax
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpshufd	$78, %xmm0, %xmm2       # xmm2 = xmm0[2,3,0,1]
	vpmovsxbd	%xmm2, %ymm2
	vpand	%ymm2, %ymm1, %ymm1
	vpmovsxbd	%xmm0, %ymm2
	vpand	%ymm2, %ymm3, %ymm2
	vpand	%ymm7, %ymm1, %ymm1
	vpand	%ymm7, %ymm2, %ymm3
	vmovmskps	%ymm3, %ecx
	vmovmskps	%ymm1, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	je	.LBB2_69
# %bb.138:                              # %for_loop418
                                        #   in Loop: Header=BB2_137 Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	8928(%rsp,%rcx), %ymm13, %ymm2
	vpxor	%ymm6, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm7
	vpcmpeqq	8896(%rsp,%rcx), %ymm13, %ymm11
	vpackssdw	%xmm7, %xmm2, %xmm2
	vpxor	%ymm6, %ymm11, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vpackssdw	%xmm2, %xmm4, %xmm2
	vpcmpeqq	8864(%rsp,%rcx), %ymm13, %ymm4
	vpxor	%ymm6, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vpcmpeqq	8832(%rsp,%rcx), %ymm13, %ymm7
	vpxor	%ymm6, %ymm7, %ymm7
	vextracti128	$1, %ymm7, %xmm5
	vpackssdw	%xmm5, %xmm7, %xmm5
	vpackssdw	%xmm4, %xmm5, %xmm4
	vpacksswb	%xmm2, %xmm4, %xmm2
	vextracti128	$1, %ymm3, %xmm4
	vpshufb	%xmm10, %xmm4, %xmm4
	vpshufb	%xmm10, %xmm3, %xmm5
	vpunpckldq	%xmm4, %xmm5, %xmm4 # xmm4 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
	vextracti128	$1, %ymm1, %xmm5
	vpshufb	%xmm12, %xmm5, %xmm5
	vpshufb	%xmm12, %xmm1, %xmm7
	vpunpckldq	%xmm5, %xmm7, %xmm5 # xmm5 = xmm7[0],xmm5[0],xmm7[1],xmm5[1]
	vpblendd	$12, %xmm5, %xmm4, %xmm4 # xmm4 = xmm4[0,1],xmm5[2,3]
	vpand	%xmm4, %xmm2, %xmm2
	vpsllw	$7, %xmm2, %xmm2
	vpand	%xmm2, %xmm8, %xmm2
	vpcmpgtb	%xmm2, %xmm9, %xmm2
	vpandn	%xmm0, %xmm2, %xmm0
	incl	%eax
	jmp	.LBB2_137
.LBB2_69:                               # %if_done340
	vpand	.LCPI2_10(%rip), %xmm0, %xmm0
	vpshufd	$78, %xmm0, %xmm1       # xmm1 = xmm0[2,3,0,1]
	vpmovzxbd	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
	vpmovzxbd	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero
	vmovdqu	%ymm0, (%rbx)
	vmovdqu	%ymm1, 32(%rbx)
	jmp	.LBB2_70
.LBB2_118:                              # %for_loop788.lr.ph.new
	leaq	1024(%rsp), %rdx
	movl	%r11d, %esi
	subl	%ecx, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	movl	%r11d, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_119:                              # %for_loop788
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-288(%rdx), %ymm3, %ymm3
	vpaddq	-384(%rdx), %ymm2, %ymm2
	vpaddq	-352(%rdx), %ymm4, %ymm4
	vpaddq	-320(%rdx), %ymm1, %ymm1
	movl	%edi, %ebx
	shlq	$7, %rbx
	vpaddq	25280(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	25248(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	25216(%rsp,%rbx), %ymm2, %ymm2
	vpaddq	25312(%rsp,%rbx), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, -320(%rdx)
	vmovdqa	%ymm7, -352(%rdx)
	vmovdqa	%ymm6, -384(%rdx)
	vmovdqa	%ymm5, -288(%rdx)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	-160(%rdx), %ymm3, %ymm3
	vpaddq	-256(%rdx), %ymm2, %ymm2
	vpaddq	-224(%rdx), %ymm4, %ymm4
	vpaddq	-192(%rdx), %ymm1, %ymm1
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	25280(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	25248(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	25216(%rsp,%rbx), %ymm2, %ymm2
	vpaddq	25312(%rsp,%rbx), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, -192(%rdx)
	vmovdqa	%ymm7, -224(%rdx)
	vmovdqa	%ymm6, -256(%rdx)
	vmovdqa	%ymm5, -160(%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	-128(%rdx), %ymm2, %ymm2
	vpaddq	-96(%rdx), %ymm4, %ymm4
	vpaddq	-64(%rdx), %ymm1, %ymm1
	vpaddq	-32(%rdx), %ymm3, %ymm3
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	25312(%rsp,%rbx), %ymm3, %ymm3
	vpaddq	25280(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	25248(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	25216(%rsp,%rbx), %ymm2, %ymm2
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm8, -32(%rdx)
	vmovdqa	%ymm7, -64(%rdx)
	vmovdqa	%ymm6, -96(%rdx)
	vmovdqa	%ymm5, -128(%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	(%rdx), %ymm2, %ymm2
	vpaddq	32(%rdx), %ymm4, %ymm4
	vpaddq	64(%rdx), %ymm1, %ymm1
	vpaddq	96(%rdx), %ymm3, %ymm3
	leal	3(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	25312(%rsp,%rbx), %ymm3, %ymm3
	vpaddq	25280(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	25248(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	25216(%rsp,%rbx), %ymm2, %ymm2
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm8, 96(%rdx)
	vmovdqa	%ymm7, 64(%rdx)
	vmovdqa	%ymm6, 32(%rdx)
	vmovdqa	%ymm5, (%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	addq	$4, %rax
	addq	$512, %rdx              # imm = 0x200
	addl	$4, %edi
	cmpl	%eax, %esi
	jne	.LBB2_119
.LBB2_120:                              # %for_test787.for_exit790_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	movq	8(%rsp), %rbx           # 8-byte Reload
	je	.LBB2_123
# %bb.121:                              # %for_loop788.epil.preheader
	leal	(%r11,%rax), %edx
	shlq	$7, %rax
	addq	%rsp, %rax
	addq	$640, %rax              # imm = 0x280
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_122:                              # %for_loop788.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	96(%rax), %ymm3, %ymm3
	vpaddq	32(%rax), %ymm4, %ymm4
	vpaddq	(%rax), %ymm2, %ymm2
	vpaddq	64(%rax), %ymm1, %ymm1
	movl	%edx, %esi
	shlq	$7, %rsi
	vpaddq	25280(%rsp,%rsi), %ymm1, %ymm1
	vpaddq	25216(%rsp,%rsi), %ymm2, %ymm2
	vpaddq	25248(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	25312(%rsp,%rsi), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, 64(%rax)
	vmovdqa	%ymm7, (%rax)
	vmovdqa	%ymm6, 32(%rax)
	vmovdqa	%ymm5, 96(%rax)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	incl	%edx
	subq	$-128, %rax
	decl	%ecx
	jne	.LBB2_122
.LBB2_123:                              # %for_test787.for_exit790_crit_edge
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	%ymm0, %ymm4, %ymm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vpcmpeqq	%ymm0, %ymm2, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm6
	vpackssdw	%xmm6, %xmm2, %xmm2
	vinserti128	$1, %xmm4, %ymm2, %ymm4
	vpcmpeqq	%ymm0, %ymm3, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm1, %ymm0
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm5
.LBB2_124:                              # %for_exit790
	vpand	%ymm4, %ymm15, %ymm0
	vmovmskps	%ymm0, %eax
	vpand	%ymm5, %ymm9, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_128
# %bb.125:                              # %for_exit790
	testl	%r11d, %r11d
	je	.LBB2_128
# %bb.126:                              # %for_loop826.lr.ph
	movl	20(%rsp), %ecx          # 4-byte Reload
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm6   # ymm6 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm4, %ymm6, %ymm2
	vmovdqa	%ymm2, 64(%rsp)         # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm7   # ymm7 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm7, %ymm2
	vmovdqa	%ymm2, 32(%rsp)         # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 96(%rsp)         # 32-byte Spill
	vpermd	%ymm5, %ymm7, %ymm5
	shlq	$6, %r15
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%eax, %eax
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB2_127:                              # %for_loop826
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rax,2), %ymm15
	vmovdqa	17024(%rsp,%rax), %ymm13
	vmovdqa	17056(%rsp,%rax), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm2
	vpor	%ymm2, %ymm12, %ymm2
	vpsllvd	%ymm0, %ymm14, %ymm12
	vmovdqa	736(%rsp,%rax,2), %ymm3
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm11, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm3, %ymm4
	vpaddq	%ymm4, %ymm10, %ymm4
	vmovdqa	704(%rsp,%rax,2), %ymm10
	vpmovzxdq	%xmm11, %ymm11  # ymm11 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm11, %ymm10, %ymm11
	vpaddq	%ymm9, %ymm11, %ymm9
	vpmovzxdq	%xmm2, %ymm11   # ymm11 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm11, %ymm15, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	64(%rsp), %ymm12        # 32-byte Reload
	vblendvpd	%ymm12, %ymm11, %ymm15, %ymm11
	vmovdqa	672(%rsp,%rax,2), %ymm12
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm2, %ymm12, %ymm2
	vpaddq	%ymm7, %ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm6[1],ymm2[2],ymm6[3],ymm2[4],ymm6[5],ymm2[6],ymm6[7]
	vmovapd	32(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm7, %ymm12, %ymm7
	vpblendd	$170, %ymm6, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vmovapd	96(%rsp), %ymm15        # 32-byte Reload
	vblendvpd	%ymm15, %ymm12, %ymm10, %ymm10
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vblendvpd	%ymm5, %ymm12, %ymm3, %ymm3
	vmovapd	%ymm10, 704(%rsp,%rax,2)
	vmovapd	%ymm3, 736(%rsp,%rax,2)
	vmovapd	%ymm11, 640(%rsp,%rax,2)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm7, 672(%rsp,%rax,2)
	vpsrad	$31, %ymm4, %ymm3
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm9, %ymm3
	vpshufd	$245, %ymm9, %ymm4      # ymm4 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm2, %ymm3
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm3[1],ymm2[2],ymm3[3],ymm2[4],ymm3[5],ymm2[6],ymm3[7]
	vpsrad	$31, %ymm8, %ymm2
	vpshufd	$245, %ymm8, %ymm3      # ymm3 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	addq	$64, %rax
	cmpq	%rax, %r15
	jne	.LBB2_127
.LBB2_128:                              # %safe_if_after_true816
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	736(%rsp,%rax), %ymm0, %ymm2
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	704(%rsp,%rax), %ymm0, %ymm3
	vpxor	%ymm1, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	672(%rsp,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm2, %ymm3, %ymm11
	vpxor	%ymm1, %ymm4, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	640(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm1, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpackssdw	%xmm3, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm10
	vmovdqa	160(%rsp), %ymm15       # 32-byte Reload
	vpand	%ymm15, %ymm10, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	192(%rsp), %ymm14       # 32-byte Reload
	vpand	%ymm14, %ymm11, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_129
# %bb.139:                              # %for_test888.preheader
	vpbroadcastd	.LCPI2_5(%rip), %ymm4 # ymm4 = [1,1,1,1,1,1,1,1]
	xorl	%eax, %eax
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vmovdqa	.LCPI2_6(%rip), %xmm13  # xmm13 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vmovdqa	.LCPI2_7(%rip), %xmm12  # xmm12 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vmovdqa	%ymm4, %ymm9
	vmovdqa	%ymm10, 32(%rsp)        # 32-byte Spill
	vmovdqa	%ymm11, 64(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_140:                              # %for_test888
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%r11d, %eax
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm3
	vpbroadcastd	%xmm3, %ymm3
	vpshufd	$78, %xmm0, %xmm7       # xmm7 = xmm0[2,3,0,1]
	vpmovsxbd	%xmm7, %ymm7
	vpand	%ymm7, %ymm11, %ymm7
	vpmovsxbd	%xmm0, %ymm11
	vpand	%ymm11, %ymm10, %ymm10
	vpand	%ymm3, %ymm7, %ymm11
	vpand	%ymm3, %ymm10, %ymm10
	vpand	%ymm15, %ymm10, %ymm3
	vmovmskps	%ymm3, %ecx
	vpand	%ymm14, %ymm11, %ymm3
	vmovmskps	%ymm3, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	je	.LBB2_141
# %bb.142:                              # %for_loop889
                                        #   in Loop: Header=BB2_140 Depth=1
	movl	%eax, %ecx
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vmovdqa	17024(%rsp,%rdx), %ymm3
	vmovdqa	17056(%rsp,%rdx), %ymm7
	vpaddd	%ymm4, %ymm3, %ymm14
	vpaddd	%ymm7, %ymm9, %ymm15
	vpmaxud	%ymm7, %ymm15, %ymm7
	vpcmpeqd	%ymm7, %ymm15, %ymm7
	vpbroadcastd	.LCPI2_5(%rip), %ymm8 # ymm8 = [1,1,1,1,1,1,1,1]
	vpmaxud	%ymm3, %ymm14, %ymm3
	vpcmpeqd	%ymm3, %ymm14, %ymm3
	vpandn	%ymm8, %ymm3, %ymm3
	vblendvps	%ymm10, %ymm3, %ymm4, %ymm4
	vpandn	%ymm8, %ymm7, %ymm3
	vblendvps	%ymm11, %ymm3, %ymm9, %ymm9
	shlq	$7, %rcx
	vpmovzxdq	%xmm14, %ymm3   # ymm3 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm7
	vmovdqa	192(%rsp), %ymm14       # 32-byte Reload
	vpmovzxdq	%xmm7, %ymm7    # ymm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
	vpmovzxdq	%xmm15, %ymm8   # ymm8 = xmm15[0],zero,xmm15[1],zero,xmm15[2],zero,xmm15[3],zero
	vextracti128	$1, %ymm15, %xmm2
	vmovdqa	160(%rsp), %ymm15       # 32-byte Reload
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpcmpeqq	736(%rsp,%rcx), %ymm2, %ymm2
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm5
	vpcmpeqq	704(%rsp,%rcx), %ymm8, %ymm8
	vpackssdw	%xmm5, %xmm2, %xmm2
	vpxor	%ymm1, %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpackssdw	%xmm2, %xmm5, %xmm2
	vpcmpeqq	672(%rsp,%rcx), %ymm7, %ymm5
	vpxor	%ymm1, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	640(%rsp,%rcx), %ymm3, %ymm3
	vpxor	%ymm1, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm6
	vpackssdw	%xmm6, %xmm3, %xmm3
	vpackssdw	%xmm5, %xmm3, %xmm3
	vpacksswb	%xmm2, %xmm3, %xmm2
	vextracti128	$1, %ymm10, %xmm3
	vpshufb	%xmm13, %xmm3, %xmm3
	vpshufb	%xmm13, %xmm10, %xmm5
	vpunpckldq	%xmm3, %xmm5, %xmm3 # xmm3 = xmm5[0],xmm3[0],xmm5[1],xmm3[1]
	vextracti128	$1, %ymm11, %xmm5
	vpshufb	%xmm12, %xmm5, %xmm5
	vpshufb	%xmm12, %xmm11, %xmm6
	vpunpckldq	%xmm5, %xmm6, %xmm5 # xmm5 = xmm6[0],xmm5[0],xmm6[1],xmm5[1]
	vpblendd	$12, %xmm5, %xmm3, %xmm3 # xmm3 = xmm3[0,1],xmm5[2,3]
	vpand	%xmm3, %xmm2, %xmm2
	vpsllw	$7, %xmm2, %xmm2
	vpand	.LCPI2_8(%rip), %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpgtb	%xmm2, %xmm3, %xmm2
	vpandn	%xmm0, %xmm2, %xmm0
	incl	%eax
	jmp	.LBB2_140
.LBB2_141:
	vmovdqa	64(%rsp), %ymm11        # 32-byte Reload
	vmovdqa	32(%rsp), %ymm10        # 32-byte Reload
	jmp	.LBB2_130
.LBB2_129:
	vpcmpeqd	%xmm0, %xmm0, %xmm0
.LBB2_130:                              # %safe_if_after_true880
	vpandn	%ymm15, %ymm10, %ymm2
	vmovmskps	%ymm2, %eax
	vpandn	%ymm14, %ymm11, %ymm2
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_131
# %bb.143:                              # %safe_if_run_false953
	vpxor	%ymm1, %ymm10, %ymm3
	vpbroadcastq	.LCPI2_9(%rip), %ymm2 # ymm2 = [1,1,1,1]
	vpcmpeqq	736(%rsp), %ymm2, %ymm4
	vpcmpeqq	704(%rsp), %ymm2, %ymm5
	vpxor	%ymm1, %ymm11, %ymm1
	vpackssdw	%ymm4, %ymm5, %ymm4
	vpcmpeqq	672(%rsp), %ymm2, %ymm5
	vpermq	$216, %ymm4, %ymm4      # ymm4 = ymm4[0,2,1,3]
	vpcmpeqq	640(%rsp), %ymm2, %ymm2
	vpackssdw	%ymm5, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2      # ymm2 = ymm2[0,2,1,3]
	vpackssdw	%ymm4, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2      # ymm2 = ymm2[0,2,1,3]
	vextracti128	$1, %ymm2, %xmm4
	vpacksswb	%xmm4, %xmm2, %xmm8
	vextracti128	$1, %ymm3, %xmm4
	vmovdqa	.LCPI2_6(%rip), %xmm10  # xmm10 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm10, %xmm4, %xmm4
	vpshufb	%xmm10, %xmm3, %xmm6
	vpunpckldq	%xmm4, %xmm6, %xmm6 # xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
	vextracti128	$1, %ymm1, %xmm7
	vmovdqa	.LCPI2_7(%rip), %xmm12  # xmm12 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vpshufb	%xmm12, %xmm7, %xmm7
	vpshufb	%xmm12, %xmm1, %xmm5
	vpunpckldq	%xmm7, %xmm5, %xmm5 # xmm5 = xmm5[0],xmm7[0],xmm5[1],xmm7[1]
	vpblendd	$12, %xmm5, %xmm6, %xmm5 # xmm5 = xmm6[0,1],xmm5[2,3]
	vpsllw	$7, %xmm5, %xmm5
	vpblendvb	%xmm5, %xmm8, %xmm0, %xmm0
	movl	$1, %eax
	vpxor	%xmm13, %xmm13, %xmm13
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vmovdqa	.LCPI2_8(%rip), %xmm8   # xmm8 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB2_144:                              # %for_test963
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%r11d, %eax
	sbbl	%ecx, %ecx
	vmovd	%ecx, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpshufd	$78, %xmm0, %xmm2       # xmm2 = xmm0[2,3,0,1]
	vpmovsxbd	%xmm2, %ymm2
	vpand	%ymm2, %ymm1, %ymm1
	vpmovsxbd	%xmm0, %ymm2
	vpand	%ymm2, %ymm3, %ymm2
	vpand	%ymm7, %ymm1, %ymm1
	vpand	%ymm7, %ymm2, %ymm3
	vpand	%ymm3, %ymm15, %ymm2
	vmovmskps	%ymm2, %ecx
	vpand	%ymm1, %ymm14, %ymm2
	vmovmskps	%ymm2, %edx
	shll	$8, %edx
	orl	%ecx, %edx
	je	.LBB2_131
# %bb.145:                              # %for_loop964
                                        #   in Loop: Header=BB2_144 Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	736(%rsp,%rcx), %ymm13, %ymm2
	vpxor	%ymm6, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm7
	vpcmpeqq	704(%rsp,%rcx), %ymm13, %ymm11
	vpackssdw	%xmm7, %xmm2, %xmm2
	vpxor	%ymm6, %ymm11, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vpackssdw	%xmm2, %xmm4, %xmm2
	vpcmpeqq	672(%rsp,%rcx), %ymm13, %ymm4
	vpxor	%ymm6, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vpcmpeqq	640(%rsp,%rcx), %ymm13, %ymm7
	vpxor	%ymm6, %ymm7, %ymm7
	vextracti128	$1, %ymm7, %xmm5
	vpackssdw	%xmm5, %xmm7, %xmm5
	vpackssdw	%xmm4, %xmm5, %xmm4
	vpacksswb	%xmm2, %xmm4, %xmm2
	vextracti128	$1, %ymm3, %xmm4
	vpshufb	%xmm10, %xmm4, %xmm4
	vpshufb	%xmm10, %xmm3, %xmm5
	vpunpckldq	%xmm4, %xmm5, %xmm4 # xmm4 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
	vextracti128	$1, %ymm1, %xmm5
	vpshufb	%xmm12, %xmm5, %xmm5
	vpshufb	%xmm12, %xmm1, %xmm7
	vpunpckldq	%xmm5, %xmm7, %xmm5 # xmm5 = xmm7[0],xmm5[0],xmm7[1],xmm5[1]
	vpblendd	$12, %xmm5, %xmm4, %xmm4 # xmm4 = xmm4[0,1],xmm5[2,3]
	vpand	%xmm4, %xmm2, %xmm2
	vpsllw	$7, %xmm2, %xmm2
	vpand	%xmm2, %xmm8, %xmm2
	vpcmpgtb	%xmm2, %xmm9, %xmm2
	vpandn	%xmm0, %xmm2, %xmm0
	incl	%eax
	jmp	.LBB2_144
.LBB2_131:                              # %if_done879
	vpand	.LCPI2_10(%rip), %xmm0, %xmm0
	vpshufd	$78, %xmm0, %xmm1       # xmm1 = xmm0[2,3,0,1]
	vpmovzxbd	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
	vpmovzxbd	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero
	vmaskmovps	%ymm0, %ymm15, (%rbx)
	vmaskmovps	%ymm1, %ymm14, 32(%rbx)
.LBB2_70:                               # %if_done340
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
	.long	1                       # 0x1
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI3_6:
	.byte	0                       # 0x0
	.byte	4                       # 0x4
	.byte	8                       # 0x8
	.byte	12                      # 0xc
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI3_7:
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.byte	0                       # 0x0
	.byte	4                       # 0x4
	.byte	8                       # 0x8
	.byte	12                      # 0xc
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI3_8:
	.zero	16,128
.LCPI3_10:
	.zero	16,1
.LCPI3_11:
	.zero	16
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI3_9:
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
	subq	$45824, %rsp            # imm = 0xB300
	movl	%r9d, 124(%rsp)         # 4-byte Spill
	movl	%r8d, %r12d
	movl	%r8d, %r11d
	testl	%r8d, %r8d
	je	.LBB3_1
# %bb.2:                                # %for_loop.lr.ph
	vmovd	%r12d, %xmm0
	vpbroadcastd	%xmm0, %ymm1
	vpmulld	.LCPI3_0(%rip), %ymm1, %ymm0
	vpmulld	.LCPI3_1(%rip), %ymm1, %ymm1
	cmpl	$1, %r12d
	movq	%r11, 112(%rsp)         # 8-byte Spill
	movq	%rcx, 128(%rsp)         # 8-byte Spill
	jne	.LBB3_4
# %bb.3:
	xorl	%eax, %eax
	jmp	.LBB3_7
.LBB3_1:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB3_58
.LBB3_4:                                # %for_loop.lr.ph.new
	movl	%r12d, %r8d
	andl	$1, %r8d
	movl	%r12d, %r9d
	subl	%r8d, %r9d
	movl	$64, %ecx
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
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdi,%ymm3), %ymm5
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm4, (%rdi,%ymm2), %ymm6
	vmovdqa	%ymm6, 8800(%rsp,%rcx)
	vmovdqa	%ymm5, 8768(%rsp,%rcx)
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm4
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm3
	vpmovzxdq	%xmm4, %ymm5    # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	leal	1(%rax), %ebx
	vmovdqa	%ymm5, 576(%rsp,%rcx,2)
	vmovd	%ebx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vmovdqa	%ymm2, 512(%rsp,%rcx,2)
	vpaddd	%ymm1, %ymm5, %ymm2
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovdqa	%ymm4, 608(%rsp,%rcx,2)
	vpslld	$2, %ymm5, %ymm4
	vpslld	$2, %ymm2, %ymm2
	vmovdqa	%ymm3, 544(%rsp,%rcx,2)
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm3, (%rdi,%ymm2), %ymm5
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm3, (%rdi,%ymm4), %ymm6
	vmovdqa	%ymm6, 8864(%rsp,%rcx)
	vmovdqa	%ymm5, 8832(%rsp,%rcx)
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm5
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm4), %ymm3
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 704(%rsp,%rcx,2)
	vmovdqa	%ymm3, 736(%rsp,%rcx,2)
	vmovdqa	%ymm2, 640(%rsp,%rcx,2)
	vmovdqa	%ymm4, 672(%rsp,%rcx,2)
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %r9d
	jne	.LBB3_5
# %bb.6:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
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
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdi,%ymm1), %ymm3
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm2, (%rdi,%ymm0), %ymm4
	vmovdqa	%ymm4, 8864(%rsp,%rcx)
	vmovdqa	%ymm3, 8832(%rsp,%rcx)
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm1), %ymm3
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	%ymm1, (%rdx,%ymm0), %ymm2
	shlq	$7, %rax
	vpmovzxdq	%xmm3, %ymm0    # ymm0 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpmovzxdq	%xmm2, %ymm3    # ymm3 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vmovdqa	%ymm2, 736(%rsp,%rax)
	vmovdqa	%ymm3, 704(%rsp,%rax)
	vmovdqa	%ymm1, 672(%rsp,%rax)
	vmovdqa	%ymm0, 640(%rsp,%rax)
.LBB3_8:                                # %for_exit
	vmovups	(%rsi), %ymm0
	vmovaps	%ymm0, 288(%rsp)        # 32-byte Spill
	vmovdqu	32(%rsi), %ymm0
	vmovdqa	%ymm0, 256(%rsp)        # 32-byte Spill
	testl	%r12d, %r12d
	jle	.LBB3_14
# %bb.9:                                # %for_loop33.lr.ph
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	124(%rsp), %ecx         # 4-byte Reload
	shrxl	%ecx, %eax, %esi
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm2
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm7
	leaq	8896(%rsp), %r9
	movl	%r12d, %r13d
	andl	$-2, %r13d
	movq	112(%rsp), %rax         # 8-byte Reload
	movq	%rax, %r14
	shlq	$7, %r14
	movq	%rax, %r15
	shlq	$6, %r15
	vmovdqa	%ymm2, 352(%rsp)        # 32-byte Spill
	vmovdqa	%ymm7, 320(%rsp)        # 32-byte Spill
	jmp	.LBB3_10
	.p2align	4, 0x90
.LBB3_13:                               # %for_test32.loopexit
                                        #   in Loop: Header=BB3_10 Depth=1
	movl	$-2147483648, %esi      # imm = 0x80000000
	cmpq	$1, 152(%rsp)           # 8-byte Folded Reload
	movq	144(%rsp), %rax         # 8-byte Reload
	jle	.LBB3_14
.LBB3_10:                               # %for_loop33
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_36 Depth 2
                                        #       Child Loop BB3_37 Depth 3
                                        #         Child Loop BB3_24 Depth 4
                                        #       Child Loop BB3_29 Depth 3
                                        #       Child Loop BB3_31 Depth 3
                                        #         Child Loop BB3_33 Depth 4
	movq	%rax, 152(%rsp)         # 8-byte Spill
	leaq	-1(%rax), %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 144(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB3_12
# %bb.11:                               # %for_loop33
                                        #   in Loop: Header=BB3_10 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB3_12:                               # %for_loop33
                                        #   in Loop: Header=BB3_10 Depth=1
	vpaddd	8864(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 416(%rsp)        # 32-byte Spill
	vpaddd	8832(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 384(%rsp)        # 32-byte Spill
	jmp	.LBB3_36
	.p2align	4, 0x90
.LBB3_35:                               # %for_exit129
                                        #   in Loop: Header=BB3_36 Depth=2
	shrl	%esi
	je	.LBB3_13
.LBB3_36:                               # %for_loop50.lr.ph.split.us
                                        #   Parent Loop BB3_10 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_37 Depth 3
                                        #         Child Loop BB3_24 Depth 4
                                        #       Child Loop BB3_29 Depth 3
                                        #       Child Loop BB3_31 Depth 3
                                        #         Child Loop BB3_33 Depth 4
	movl	%esi, 140(%rsp)         # 4-byte Spill
	leaq	29312(%rsp), %rdi
	leaq	640(%rsp), %rsi
	movl	%r12d, %edx
	movq	%r9, %rbx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	vpxor	%xmm15, %xmm15, %xmm15
	movq	%rbx, %r9
	movl	$1, %eax
	xorl	%ecx, %ecx
	movq	112(%rsp), %r8          # 8-byte Reload
	vmovdqa	288(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	256(%rsp), %ymm13       # 32-byte Reload
	vmovdqa	.LCPI3_2(%rip), %ymm14  # ymm14 = [0,2,4,6,4,6,6,7]
	jmp	.LBB3_37
	.p2align	4, 0x90
.LBB3_38:                               #   in Loop: Header=BB3_37 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%esi, %esi
.LBB3_26:                               # %for_loop61.us.epil.preheader
                                        #   in Loop: Header=BB3_37 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	8864(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8880(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8832(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8848(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm2
	vpmuludq	%ymm3, %ymm10, %ymm3
	vpmuludq	%ymm0, %ymm9, %ymm0
	vpmuludq	%ymm1, %ymm8, %ymm1
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29344(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	29312(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	%ymm3, %ymm4, %ymm3
	vpaddq	29408(%rsp,%rsi), %ymm6, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpaddq	29376(%rsp,%rsi), %ymm5, %ymm4
	vpaddq	%ymm1, %ymm4, %ymm1
	vpblendd	$170, %ymm15, %ymm2, %ymm4 # ymm4 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm0, %ymm6 # ymm6 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm7, 29376(%rsp,%rsi)
	vmovdqa	%ymm6, 29408(%rsp,%rsi)
	vmovdqa	%ymm5, 29312(%rsp,%rsi)
	vmovdqa	%ymm4, 29344(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm6
	vpsrlq	$32, %ymm1, %ymm5
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm4
.LBB3_27:                               # %for_exit63.us
                                        #   in Loop: Header=BB3_37 Depth=3
	vmovdqa	%ymm7, 672(%rsp,%rdx)
	vmovdqa	%ymm4, 640(%rsp,%rdx)
	vmovdqa	%ymm5, 704(%rsp,%rdx)
	vmovdqa	%ymm6, 736(%rsp,%rdx)
	incq	%rcx
	incq	%rax
	cmpq	%r8, %rcx
	je	.LBB3_28
.LBB3_37:                               # %for_loop61.lr.ph.us
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_36 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_24 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpermd	29376(%rsp,%rdx), %ymm14, %ymm0
	vpermd	29408(%rsp,%rdx), %ymm14, %ymm1
	vpermd	29312(%rsp,%rdx), %ymm14, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	29344(%rsp,%rdx), %ymm14, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	%ymm1, %ymm12, %ymm3
	vpmulld	%ymm0, %ymm13, %ymm1
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpxor	%xmm4, %xmm4, %xmm4
	cmpl	$1, %r12d
	je	.LBB3_38
# %bb.23:                               # %for_loop61.lr.ph.us.new
                                        #   in Loop: Header=BB3_37 Depth=3
	movq	%r9, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB3_24:                               # %for_loop61.us
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_36 Depth=2
                                        #       Parent Loop BB3_37 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-32(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm0, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	vpmuludq	%ymm2, %ymm9, %ymm9
	vpmuludq	%ymm1, %ymm8, %ymm8
	leal	(%rcx,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	29408(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm11, %ymm6
	vpaddq	29312(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm4, %ymm10, %ymm4
	vpaddq	29344(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	29376(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm5, %ymm8, %ymm5
	vpblendd	$170, %ymm15, %ymm6, %ymm8 # ymm8 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 29376(%rsp,%rbx)
	vmovdqa	%ymm10, 29344(%rsp,%rbx)
	vmovdqa	%ymm9, 29312(%rsp,%rbx)
	vmovdqa	%ymm8, 29408(%rsp,%rbx)
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm7, %ymm7
	vpmovzxdq	32(%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	(%rdi), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	vpmuludq	%ymm0, %ymm9, %ymm9
	vpmuludq	%ymm1, %ymm8, %ymm8
	leal	(%rax,%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	29344(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	29312(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm7, %ymm11, %ymm7
	vpaddq	%ymm4, %ymm10, %ymm4
	vpaddq	29408(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm9, %ymm6
	vpaddq	29376(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm5, %ymm8, %ymm5
	vpblendd	$170, %ymm15, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm15[1],ymm7[2],ymm15[3],ymm7[4],ymm15[5],ymm7[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm15[1],ymm4[2],ymm15[3],ymm4[4],ymm15[5],ymm4[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm15[1],ymm6[2],ymm15[3],ymm6[4],ymm15[5],ymm6[6],ymm15[7]
	vpblendd	$170, %ymm15, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm15[1],ymm5[2],ymm15[3],ymm5[4],ymm15[5],ymm5[6],ymm15[7]
	vmovdqa	%ymm11, 29376(%rsp,%rbx)
	vmovdqa	%ymm10, 29408(%rsp,%rbx)
	vmovdqa	%ymm9, 29312(%rsp,%rbx)
	vmovdqa	%ymm8, 29344(%rsp,%rbx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r13d
	jne	.LBB3_24
# %bb.25:                               # %for_test60.for_exit63_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_37 Depth=3
	testb	$1, %r12b
	jne	.LBB3_26
	jmp	.LBB3_27
	.p2align	4, 0x90
.LBB3_28:                               # %for_loop91.lr.ph
                                        #   in Loop: Header=BB3_36 Depth=2
	movl	140(%rsp), %esi         # 4-byte Reload
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	384(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	416(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpcmpeqd	%ymm0, %ymm15, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm15, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI3_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI3_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	vpxor	%xmm11, %xmm11, %xmm11
	movl	%r12d, %eax
	xorl	%ecx, %ecx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm13, %xmm13, %xmm13
	.p2align	4, 0x90
.LBB3_29:                               # %for_loop91
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_36 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%eax, %edx
	shlq	$7, %rdx
	vmovdqa	29312(%rsp,%rdx), %ymm0
	vmovdqa	29344(%rsp,%rdx), %ymm1
	vmovdqa	29376(%rsp,%rdx), %ymm8
	vmovdqa	29408(%rsp,%rdx), %ymm9
	vpaddq	640(%rsp,%rcx), %ymm0, %ymm0
	vpaddq	672(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	704(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	736(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm0, %ymm0, %ymm10
	vblendvpd	%ymm4, %ymm10, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm10
	vblendvpd	%ymm5, %ymm10, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm8, %ymm10
	vblendvpd	%ymm6, %ymm10, %ymm8, %ymm8
	vpaddq	%ymm9, %ymm9, %ymm10
	vblendvpd	%ymm7, %ymm10, %ymm9, %ymm9
	vpaddq	%ymm8, %ymm14, %ymm3
	vpblendd	$170, %ymm15, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm15[1],ymm3[2],ymm15[3],ymm3[4],ymm15[5],ymm3[6],ymm15[7]
	vmovdqa	%ymm8, 704(%rsp,%rcx)
	vpaddq	%ymm9, %ymm13, %ymm2
	vpblendd	$170, %ymm15, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm15[1],ymm2[2],ymm15[3],ymm2[4],ymm15[5],ymm2[6],ymm15[7]
	vmovdqa	%ymm8, 736(%rsp,%rcx)
	vpaddq	%ymm0, %ymm11, %ymm0
	vpblendd	$170, %ymm15, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm15[1],ymm0[2],ymm15[3],ymm0[4],ymm15[5],ymm0[6],ymm15[7]
	vmovdqa	%ymm8, 640(%rsp,%rcx)
	vpaddq	%ymm1, %ymm12, %ymm1
	vpblendd	$170, %ymm15, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm15[1],ymm1[2],ymm15[3],ymm1[4],ymm15[5],ymm1[6],ymm15[7]
	vmovdqa	%ymm8, 672(%rsp,%rcx)
	vpsrlq	$32, %ymm2, %ymm13
	vpsrlq	$32, %ymm3, %ymm14
	vpsrlq	$32, %ymm1, %ymm12
	vpsrlq	$32, %ymm0, %ymm11
	subq	$-128, %rcx
	incl	%eax
	cmpq	%rcx, %r14
	jne	.LBB3_29
# %bb.30:                               # %for_test126.preheader
                                        #   in Loop: Header=BB3_36 Depth=2
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vmovdqa	352(%rsp), %ymm2        # 32-byte Reload
	vmovdqa	320(%rsp), %ymm7        # 32-byte Reload
	.p2align	4, 0x90
.LBB3_31:                               # %for_test126
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_36 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_33 Depth 4
	vpcmpeqq	%ymm15, %ymm12, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm11, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm3, %ymm0, %ymm3
	vpcmpeqq	%ymm15, %ymm13, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm15, %ymm14, %ymm1
	vextracti128	$1, %ymm1, %xmm6
	vpackssdw	%xmm6, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vpandn	%ymm4, %ymm0, %ymm4
	vmovmskps	%ymm3, %eax
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_35
# %bb.32:                               # %for_loop141.lr.ph
                                        #   in Loop: Header=BB3_31 Depth=3
	vmovdqa	%ymm14, 512(%rsp)       # 32-byte Spill
	vmovdqa	%ymm13, 544(%rsp)       # 32-byte Spill
	vmovdqa	%ymm12, 576(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 608(%rsp)       # 32-byte Spill
	vmovaps	.LCPI3_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm3, %ymm0, %ymm1
	vmovaps	%ymm1, 192(%rsp)        # 32-byte Spill
	vmovaps	.LCPI3_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vmovaps	%ymm3, 480(%rsp)        # 32-byte Spill
	vpermps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm3, 160(%rsp)        # 32-byte Spill
	vpermps	%ymm4, %ymm0, %ymm0
	vmovaps	%ymm0, 224(%rsp)        # 32-byte Spill
	vmovaps	%ymm4, 448(%rsp)        # 32-byte Spill
	vpermps	%ymm4, %ymm1, %ymm9
	vmovdqa	%ymm2, %ymm6
	vpxor	%xmm11, %xmm11, %xmm11
	movl	$0, %eax
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB3_33:                               # %for_loop141
                                        #   Parent Loop BB3_10 Depth=1
                                        #     Parent Loop BB3_36 Depth=2
                                        #       Parent Loop BB3_31 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	640(%rsp,%rax,2), %ymm2
	vmovdqa	8832(%rsp,%rax), %ymm0
	vmovdqa	8864(%rsp,%rax), %ymm1
	vpsllvd	%ymm6, %ymm0, %ymm3
	vpor	%ymm3, %ymm15, %ymm3
	vpsllvd	%ymm6, %ymm1, %ymm15
	vmovdqa	736(%rsp,%rax,2), %ymm4
	vpor	%ymm14, %ymm15, %ymm14
	vextracti128	$1, %ymm14, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm4, %ymm5
	vpaddq	%ymm5, %ymm13, %ymm5
	vmovdqa	704(%rsp,%rax,2), %ymm13
	vpmovzxdq	%xmm14, %ymm14  # ymm14 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm14, %ymm13, %ymm14
	vpaddq	%ymm12, %ymm14, %ymm12
	vpmovzxdq	%xmm3, %ymm14   # ymm14 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm14, %ymm2, %ymm14
	vpaddq	%ymm11, %ymm14, %ymm11
	vpblendd	$170, %ymm8, %ymm11, %ymm14 # ymm14 = ymm11[0],ymm8[1],ymm11[2],ymm8[3],ymm11[4],ymm8[5],ymm11[6],ymm8[7]
	vmovapd	192(%rsp), %ymm15       # 32-byte Reload
	vblendvpd	%ymm15, %ymm14, %ymm2, %ymm2
	vmovdqa	672(%rsp,%rax,2), %ymm14
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm14, %ymm3
	vpaddq	%ymm3, %ymm10, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm10 # ymm10 = ymm3[0],ymm8[1],ymm3[2],ymm8[3],ymm3[4],ymm8[5],ymm3[6],ymm8[7]
	vmovapd	160(%rsp), %ymm15       # 32-byte Reload
	vblendvpd	%ymm15, %ymm10, %ymm14, %ymm10
	vpblendd	$170, %ymm8, %ymm12, %ymm14 # ymm14 = ymm12[0],ymm8[1],ymm12[2],ymm8[3],ymm12[4],ymm8[5],ymm12[6],ymm8[7]
	vmovapd	224(%rsp), %ymm15       # 32-byte Reload
	vblendvpd	%ymm15, %ymm14, %ymm13, %ymm13
	vpblendd	$170, %ymm8, %ymm5, %ymm14 # ymm14 = ymm5[0],ymm8[1],ymm5[2],ymm8[3],ymm5[4],ymm8[5],ymm5[6],ymm8[7]
	vblendvpd	%ymm9, %ymm14, %ymm4, %ymm4
	vmovapd	%ymm13, 704(%rsp,%rax,2)
	vmovapd	%ymm4, 736(%rsp,%rax,2)
	vmovapd	%ymm2, 640(%rsp,%rax,2)
	vpsrlvd	%ymm7, %ymm1, %ymm14
	vpsrlvd	%ymm7, %ymm0, %ymm15
	vmovapd	%ymm10, 672(%rsp,%rax,2)
	vpsrad	$31, %ymm5, %ymm0
	vpshufd	$245, %ymm5, %ymm1      # ymm1 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm12, %ymm0
	vpshufd	$245, %ymm12, %ymm1     # ymm1 = ymm12[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm3, %ymm0
	vpshufd	$245, %ymm3, %ymm1      # ymm1 = ymm3[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	$64, %rax
	cmpq	%rax, %r15
	jne	.LBB3_33
# %bb.34:                               # %for_exit143
                                        #   in Loop: Header=BB3_31 Depth=3
	vmovdqa	544(%rsp), %ymm1        # 32-byte Reload
	vpaddq	%ymm1, %ymm13, %ymm0
	vmovdqa	%ymm1, %ymm13
	vmovdqa	512(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm12, %ymm1
	vmovdqa	576(%rsp), %ymm12       # 32-byte Reload
	vpaddq	%ymm12, %ymm10, %ymm2
	vmovdqa	608(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm11, %ymm3
	vmovdqa	%ymm4, %ymm11
	vmovapd	192(%rsp), %ymm4        # 32-byte Reload
	vblendvpd	%ymm4, %ymm3, %ymm11, %ymm11
	vmovapd	160(%rsp), %ymm3        # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm12, %ymm12
	vmovapd	224(%rsp), %ymm2        # 32-byte Reload
	vblendvpd	%ymm2, %ymm1, %ymm14, %ymm14
	vblendvpd	%ymm9, %ymm0, %ymm13, %ymm13
	vmovdqa	%ymm6, %ymm2
	vpxor	%xmm15, %xmm15, %xmm15
	vmovaps	480(%rsp), %ymm3        # 32-byte Reload
	vmovaps	448(%rsp), %ymm4        # 32-byte Reload
	jmp	.LBB3_31
.LBB3_14:                               # %for_test188.preheader
	testl	%r12d, %r12d
	je	.LBB3_15
# %bb.16:                               # %for_loop189.lr.ph
	leal	-1(%r12), %r8d
	movl	%r12d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB3_50
# %bb.17:
	xorl	%eax, %eax
	movq	112(%rsp), %r11         # 8-byte Reload
	jmp	.LBB3_18
.LBB3_15:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	128(%rsp), %rcx         # 8-byte Reload
	movq	112(%rsp), %r11         # 8-byte Reload
	jmp	.LBB3_58
.LBB3_50:                               # %for_loop189.lr.ph.new
	movl	%r12d, %edx
	subl	%ecx, %edx
	movl	$384, %esi              # imm = 0x180
	xorl	%eax, %eax
	vpxor	%xmm0, %xmm0, %xmm0
	movq	112(%rsp), %r11         # 8-byte Reload
	.p2align	4, 0x90
.LBB3_51:                               # %for_loop189
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	256(%rsp,%rsi), %ymm1
	vmovaps	320(%rsp,%rsi), %ymm2
	vmovaps	352(%rsp,%rsi), %ymm3
	vmovaps	%ymm1, 12544(%rsp,%rsi)
	vmovaps	%ymm3, 12640(%rsp,%rsi)
	vmovaps	%ymm2, 12608(%rsp,%rsi)
	vmovaps	288(%rsp,%rsi), %ymm1
	vmovaps	%ymm1, 12576(%rsp,%rsi)
	leaq	(%r11,%rax), %rdi
	movl	%edi, %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 12928(%rsp,%rbx)
	vmovdqa	%ymm0, 13024(%rsp,%rbx)
	vmovdqa	%ymm0, 12992(%rsp,%rbx)
	vmovdqa	%ymm0, 12960(%rsp,%rbx)
	vmovaps	416(%rsp,%rsi), %ymm1
	vmovaps	448(%rsp,%rsi), %ymm2
	vmovaps	480(%rsp,%rsi), %ymm3
	vmovaps	384(%rsp,%rsi), %ymm4
	vmovaps	%ymm4, 12672(%rsp,%rsi)
	vmovaps	%ymm3, 12768(%rsp,%rsi)
	vmovaps	%ymm2, 12736(%rsp,%rsi)
	vmovaps	%ymm1, 12704(%rsp,%rsi)
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 12928(%rsp,%rbx)
	vmovdqa	%ymm0, 13024(%rsp,%rbx)
	vmovdqa	%ymm0, 12992(%rsp,%rbx)
	vmovdqa	%ymm0, 12960(%rsp,%rbx)
	vmovaps	544(%rsp,%rsi), %ymm1
	vmovaps	576(%rsp,%rsi), %ymm2
	vmovaps	608(%rsp,%rsi), %ymm3
	vmovaps	512(%rsp,%rsi), %ymm4
	vmovaps	%ymm4, 12800(%rsp,%rsi)
	vmovaps	%ymm3, 12896(%rsp,%rsi)
	vmovaps	%ymm2, 12864(%rsp,%rsi)
	vmovaps	%ymm1, 12832(%rsp,%rsi)
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 12928(%rsp,%rbx)
	vmovdqa	%ymm0, 13024(%rsp,%rbx)
	vmovdqa	%ymm0, 12992(%rsp,%rbx)
	vmovdqa	%ymm0, 12960(%rsp,%rbx)
	vmovdqa	640(%rsp,%rsi), %ymm1
	vmovdqa	672(%rsp,%rsi), %ymm2
	vmovdqa	704(%rsp,%rsi), %ymm3
	vmovdqa	736(%rsp,%rsi), %ymm4
	vmovdqa	%ymm4, 13024(%rsp,%rsi)
	vmovdqa	%ymm3, 12992(%rsp,%rsi)
	vmovdqa	%ymm2, 12960(%rsp,%rsi)
	vmovdqa	%ymm1, 12928(%rsp,%rsi)
	addl	$3, %edi
	shlq	$7, %rdi
	vmovdqa	%ymm0, 13024(%rsp,%rdi)
	vmovdqa	%ymm0, 12992(%rsp,%rdi)
	vmovdqa	%ymm0, 12960(%rsp,%rdi)
	vmovdqa	%ymm0, 12928(%rsp,%rdi)
	addq	$4, %rax
	addq	$512, %rsi              # imm = 0x200
	cmpl	%eax, %edx
	jne	.LBB3_51
.LBB3_18:                               # %for_test188.for_test206.preheader_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	vmovdqa	288(%rsp), %ymm14       # 32-byte Reload
	vmovdqa	256(%rsp), %ymm15       # 32-byte Reload
	je	.LBB3_21
# %bb.19:                               # %for_loop189.epil.preheader
	leal	(%r12,%rax), %edx
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_20:                               # %for_loop189.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rax), %ymm1
	vmovdqa	672(%rsp,%rax), %ymm2
	vmovdqa	704(%rsp,%rax), %ymm3
	vmovdqa	736(%rsp,%rax), %ymm4
	vmovdqa	%ymm3, 12992(%rsp,%rax)
	vmovdqa	%ymm4, 13024(%rsp,%rax)
	vmovdqa	%ymm1, 12928(%rsp,%rax)
	vmovdqa	%ymm2, 12960(%rsp,%rax)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 12992(%rsp,%rsi)
	vmovdqa	%ymm0, 13024(%rsp,%rsi)
	vmovdqa	%ymm0, 12928(%rsp,%rsi)
	vmovdqa	%ymm0, 12960(%rsp,%rsi)
	incl	%edx
	subq	$-128, %rax
	decl	%ecx
	jne	.LBB3_20
.LBB3_21:                               # %for_test206.preheader
	testl	%r12d, %r12d
	je	.LBB3_22
# %bb.39:                               # %for_loop207.lr.ph.split.us
	leaq	8896(%rsp), %r9
	movl	%r12d, %edx
	andl	$-2, %edx
	movl	$1, %esi
	xorl	%edi, %edi
	vmovdqa	.LCPI3_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB3_40
	.p2align	4, 0x90
.LBB3_41:                               #   in Loop: Header=BB3_40 Depth=1
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	xorl	%eax, %eax
.LBB3_45:                               # %for_loop223.us.epil.preheader
                                        #   in Loop: Header=BB3_40 Depth=1
	movq	%rax, %rcx
	shlq	$6, %rcx
	vpmovzxdq	8864(%rsp,%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8880(%rsp,%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8832(%rsp,%rcx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8848(%rsp,%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm4
	vpmuludq	%ymm5, %ymm12, %ymm5
	vpmuludq	%ymm2, %ymm11, %ymm2
	vpmuludq	%ymm3, %ymm10, %ymm3
	addl	%edi, %eax
	shlq	$7, %rax
	vpaddq	12960(%rsp,%rax), %ymm9, %ymm9
	vpaddq	12928(%rsp,%rax), %ymm7, %ymm7
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	%ymm5, %ymm7, %ymm5
	vpaddq	13024(%rsp,%rax), %ymm8, %ymm7
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	12992(%rsp,%rax), %ymm6, %ymm6
	vpaddq	%ymm3, %ymm6, %ymm3
	vpblendd	$170, %ymm1, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm9, 12992(%rsp,%rax)
	vmovdqa	%ymm8, 13024(%rsp,%rax)
	vmovdqa	%ymm7, 12928(%rsp,%rax)
	vmovdqa	%ymm6, 12960(%rsp,%rax)
	vpsrlq	$32, %ymm2, %ymm8
	vpsrlq	$32, %ymm3, %ymm6
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm7
.LBB3_46:                               # %for_exit225.us
                                        #   in Loop: Header=BB3_40 Depth=1
	vmovdqa	%ymm9, 672(%rsp,%r10)
	vmovdqa	%ymm7, 640(%rsp,%r10)
	vmovdqa	%ymm6, 704(%rsp,%r10)
	vmovdqa	%ymm8, 736(%rsp,%r10)
	incq	%rdi
	incq	%rsi
	cmpq	%r11, %rdi
	je	.LBB3_47
.LBB3_40:                               # %for_loop223.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_43 Depth 2
	movq	%rdi, %r10
	shlq	$7, %r10
	vpermd	12992(%rsp,%r10), %ymm0, %ymm2
	vpermd	13024(%rsp,%r10), %ymm0, %ymm3
	vpermd	12928(%rsp,%r10), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	12960(%rsp,%r10), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	%ymm3, %ymm14, %ymm5
	vpmulld	%ymm2, %ymm15, %ymm3
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpxor	%xmm7, %xmm7, %xmm7
	cmpl	$1, %r12d
	je	.LBB3_41
# %bb.42:                               # %for_loop223.lr.ph.us.new
                                        #   in Loop: Header=BB3_40 Depth=1
	movq	%r9, %rcx
	xorl	%eax, %eax
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB3_43:                               # %for_loop223.us
                                        #   Parent Loop BB3_40 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-32(%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rcx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-16(%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm2, %ymm13, %ymm13
	vpmuludq	%ymm5, %ymm12, %ymm12
	vpmuludq	%ymm4, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	leal	(%rdi,%rax), %ebx
	shlq	$7, %rbx
	vpaddq	13024(%rsp,%rbx), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	12928(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm7, %ymm12, %ymm7
	vpaddq	12960(%rsp,%rbx), %ymm9, %ymm9
	vpaddq	12992(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm9, %ymm9
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 12992(%rsp,%rbx)
	vmovdqa	%ymm12, 12960(%rsp,%rbx)
	vmovdqa	%ymm11, 12928(%rsp,%rbx)
	vmovdqa	%ymm10, 13024(%rsp,%rbx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	32(%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	(%rcx), %ymm12  # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm5, %ymm12, %ymm12
	vpmuludq	%ymm2, %ymm11, %ymm11
	vpmuludq	%ymm3, %ymm10, %ymm10
	leal	(%rsi,%rax), %ebx
	shlq	$7, %rbx
	vpaddq	12960(%rsp,%rbx), %ymm9, %ymm9
	vpaddq	12928(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm7, %ymm12, %ymm7
	vpaddq	13024(%rsp,%rbx), %ymm8, %ymm8
	vpaddq	%ymm11, %ymm8, %ymm8
	vpaddq	12992(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm11 # ymm11 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 12992(%rsp,%rbx)
	vmovdqa	%ymm12, 13024(%rsp,%rbx)
	vmovdqa	%ymm11, 12928(%rsp,%rbx)
	vmovdqa	%ymm10, 12960(%rsp,%rbx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %edx
	jne	.LBB3_43
# %bb.44:                               # %for_test222.for_exit225_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_40 Depth=1
	testb	$1, %r12b
	jne	.LBB3_45
	jmp	.LBB3_46
.LBB3_47:                               # %for_test255.preheader
	testl	%r12d, %r12d
	je	.LBB3_22
# %bb.48:                               # %for_loop256.lr.ph
	movl	%r12d, %r9d
	andl	$3, %r9d
	cmpl	$3, %r8d
	jae	.LBB3_52
# %bb.49:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB3_54
.LBB3_22:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	128(%rsp), %rcx         # 8-byte Reload
	jmp	.LBB3_58
.LBB3_52:                               # %for_loop256.lr.ph.new
	leaq	1024(%rsp), %rdx
	movl	%r12d, %esi
	subl	%r9d, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	movl	%r12d, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_53:                               # %for_loop256
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-288(%rdx), %ymm3, %ymm3
	vpaddq	-384(%rdx), %ymm2, %ymm2
	vpaddq	-352(%rdx), %ymm4, %ymm4
	vpaddq	-320(%rdx), %ymm1, %ymm1
	movl	%edi, %ebx
	shlq	$7, %rbx
	vpaddq	12992(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	12960(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	12928(%rsp,%rbx), %ymm2, %ymm2
	vpaddq	13024(%rsp,%rbx), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, -320(%rdx)
	vmovdqa	%ymm7, -352(%rdx)
	vmovdqa	%ymm6, -384(%rdx)
	vmovdqa	%ymm5, -288(%rdx)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	-160(%rdx), %ymm3, %ymm3
	vpaddq	-256(%rdx), %ymm2, %ymm2
	vpaddq	-224(%rdx), %ymm4, %ymm4
	vpaddq	-192(%rdx), %ymm1, %ymm1
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12992(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	12960(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	12928(%rsp,%rbx), %ymm2, %ymm2
	vpaddq	13024(%rsp,%rbx), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, -192(%rdx)
	vmovdqa	%ymm7, -224(%rdx)
	vmovdqa	%ymm6, -256(%rdx)
	vmovdqa	%ymm5, -160(%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	-128(%rdx), %ymm2, %ymm2
	vpaddq	-96(%rdx), %ymm4, %ymm4
	vpaddq	-64(%rdx), %ymm1, %ymm1
	vpaddq	-32(%rdx), %ymm3, %ymm3
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	13024(%rsp,%rbx), %ymm3, %ymm3
	vpaddq	12992(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	12960(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	12928(%rsp,%rbx), %ymm2, %ymm2
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm8, -32(%rdx)
	vmovdqa	%ymm7, -64(%rdx)
	vmovdqa	%ymm6, -96(%rdx)
	vmovdqa	%ymm5, -128(%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	(%rdx), %ymm2, %ymm2
	vpaddq	32(%rdx), %ymm4, %ymm4
	vpaddq	64(%rdx), %ymm1, %ymm1
	vpaddq	96(%rdx), %ymm3, %ymm3
	leal	3(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	13024(%rsp,%rbx), %ymm3, %ymm3
	vpaddq	12992(%rsp,%rbx), %ymm1, %ymm1
	vpaddq	12960(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	12928(%rsp,%rbx), %ymm2, %ymm2
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm8, 96(%rdx)
	vmovdqa	%ymm7, 64(%rdx)
	vmovdqa	%ymm6, 32(%rdx)
	vmovdqa	%ymm5, (%rdx)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	addq	$4, %rax
	addq	$512, %rdx              # imm = 0x200
	addl	$4, %edi
	cmpl	%eax, %esi
	jne	.LBB3_53
.LBB3_54:                               # %for_test255.for_exit258_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	movq	128(%rsp), %rcx         # 8-byte Reload
	je	.LBB3_57
# %bb.55:                               # %for_loop256.epil.preheader
	leal	(%r12,%rax), %edx
	shlq	$7, %rax
	addq	%rsp, %rax
	addq	$640, %rax              # imm = 0x280
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_56:                               # %for_loop256.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	96(%rax), %ymm3, %ymm3
	vpaddq	32(%rax), %ymm4, %ymm4
	vpaddq	(%rax), %ymm2, %ymm2
	vpaddq	64(%rax), %ymm1, %ymm1
	movl	%edx, %esi
	shlq	$7, %rsi
	vpaddq	12992(%rsp,%rsi), %ymm1, %ymm1
	vpaddq	12928(%rsp,%rsi), %ymm2, %ymm2
	vpaddq	12960(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	13024(%rsp,%rsi), %ymm3, %ymm3
	vpblendd	$170, %ymm0, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vmovdqa	%ymm8, 64(%rax)
	vmovdqa	%ymm7, (%rax)
	vmovdqa	%ymm6, 32(%rax)
	vmovdqa	%ymm5, 96(%rax)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	incl	%edx
	subq	$-128, %rax
	decl	%r9d
	jne	.LBB3_56
.LBB3_57:                               # %for_test255.for_exit258_crit_edge
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	%ymm0, %ymm4, %ymm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpxor	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm6
	vpackssdw	%xmm6, %xmm4, %xmm4
	vpcmpeqq	%ymm0, %ymm2, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm6
	vpackssdw	%xmm6, %xmm2, %xmm2
	vinserti128	$1, %xmm4, %ymm2, %ymm4
	vpcmpeqq	%ymm0, %ymm3, %ymm2
	vpxor	%ymm5, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	%ymm0, %ymm1, %ymm0
	vpxor	%ymm5, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm5
.LBB3_58:                               # %for_exit258
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm5, %edx
	shll	$8, %edx
	orl	%eax, %edx
	je	.LBB3_62
# %bb.59:                               # %for_exit258
	testl	%r12d, %r12d
	je	.LBB3_62
# %bb.60:                               # %for_loop291.lr.ph
	movl	124(%rsp), %edx         # 4-byte Reload
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %eax
	subl	%edx, %eax
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovdqa	.LCPI3_3(%rip), %ymm6   # ymm6 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm4, %ymm6, %ymm2
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	vmovdqa	.LCPI3_4(%rip), %ymm7   # ymm7 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm7, %ymm2
	vmovdqa	%ymm2, 160(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 224(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm7, %ymm5
	shlq	$6, %r11
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%eax, %eax
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB3_61:                               # %for_loop291
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rax,2), %ymm15
	vmovdqa	8832(%rsp,%rax), %ymm13
	vmovdqa	8864(%rsp,%rax), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm2
	vpor	%ymm2, %ymm12, %ymm2
	vpsllvd	%ymm0, %ymm14, %ymm12
	vmovdqa	736(%rsp,%rax,2), %ymm3
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm11, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm3, %ymm4
	vpaddq	%ymm4, %ymm10, %ymm4
	vmovdqa	704(%rsp,%rax,2), %ymm10
	vpmovzxdq	%xmm11, %ymm11  # ymm11 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm11, %ymm10, %ymm11
	vpaddq	%ymm9, %ymm11, %ymm9
	vpmovzxdq	%xmm2, %ymm11   # ymm11 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm11, %ymm15, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm11 # ymm11 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	192(%rsp), %ymm12       # 32-byte Reload
	vblendvpd	%ymm12, %ymm11, %ymm15, %ymm11
	vmovdqa	672(%rsp,%rax,2), %ymm12
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpsubq	%ymm2, %ymm12, %ymm2
	vpaddq	%ymm7, %ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm6[1],ymm2[2],ymm6[3],ymm2[4],ymm6[5],ymm2[6],ymm6[7]
	vmovapd	160(%rsp), %ymm15       # 32-byte Reload
	vblendvpd	%ymm15, %ymm7, %ymm12, %ymm7
	vpblendd	$170, %ymm6, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm6[1],ymm9[2],ymm6[3],ymm9[4],ymm6[5],ymm9[6],ymm6[7]
	vmovapd	224(%rsp), %ymm15       # 32-byte Reload
	vblendvpd	%ymm15, %ymm12, %ymm10, %ymm10
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vblendvpd	%ymm5, %ymm12, %ymm3, %ymm3
	vmovapd	%ymm10, 704(%rsp,%rax,2)
	vmovapd	%ymm3, 736(%rsp,%rax,2)
	vmovapd	%ymm11, 640(%rsp,%rax,2)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm7, 672(%rsp,%rax,2)
	vpsrad	$31, %ymm4, %ymm3
	vpshufd	$245, %ymm4, %ymm4      # ymm4 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm9, %ymm3
	vpshufd	$245, %ymm9, %ymm4      # ymm4 = ymm9[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm3[1],ymm4[2],ymm3[3],ymm4[4],ymm3[5],ymm4[6],ymm3[7]
	vpsrad	$31, %ymm2, %ymm3
	vpshufd	$245, %ymm2, %ymm2      # ymm2 = ymm2[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm3, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm3[1],ymm2[2],ymm3[3],ymm2[4],ymm3[5],ymm2[6],ymm3[7]
	vpsrad	$31, %ymm8, %ymm2
	vpshufd	$245, %ymm8, %ymm3      # ymm3 = ymm8[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm2, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	addq	$64, %rax
	cmpq	%rax, %r11
	jne	.LBB3_61
.LBB3_62:                               # %safe_if_after_true
	leal	-1(%r12), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	736(%rsp,%rax), %ymm0, %ymm2
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpcmpeqq	704(%rsp,%rax), %ymm0, %ymm4
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpxor	%ymm1, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vinserti128	$1, %xmm2, %ymm3, %ymm11
	vpcmpeqq	672(%rsp,%rax), %ymm0, %ymm2
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vpcmpeqq	640(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm1, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpackssdw	%xmm3, %xmm0, %xmm0
	vinserti128	$1, %xmm2, %ymm0, %ymm10
	vmovmskps	%ymm10, %eax
	vmovmskps	%ymm11, %ebx
	movl	%ebx, %edx
	shll	$8, %edx
	orl	%eax, %edx
	je	.LBB3_63
# %bb.66:                               # %for_test349.preheader
	vpbroadcastd	.LCPI3_5(%rip), %ymm4 # ymm4 = [1,1,1,1,1,1,1,1]
	xorl	%edx, %edx
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vmovdqa	.LCPI3_6(%rip), %xmm13  # xmm13 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vmovdqa	.LCPI3_7(%rip), %xmm12  # xmm12 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vmovdqa	%ymm4, %ymm9
	vmovaps	%ymm10, 160(%rsp)       # 32-byte Spill
	vmovaps	%ymm11, 192(%rsp)       # 32-byte Spill
	.p2align	4, 0x90
.LBB3_67:                               # %for_test349
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%r12d, %edx
	sbbl	%esi, %esi
	vmovd	%esi, %xmm3
	vpbroadcastd	%xmm3, %ymm3
	vpshufd	$78, %xmm0, %xmm7       # xmm7 = xmm0[2,3,0,1]
	vpmovsxbd	%xmm7, %ymm7
	vpand	%ymm7, %ymm11, %ymm7
	vpmovsxbd	%xmm0, %ymm11
	vpand	%ymm11, %ymm10, %ymm10
	vpand	%ymm3, %ymm7, %ymm11
	vpand	%ymm3, %ymm10, %ymm10
	vmovmskps	%ymm10, %esi
	vmovmskps	%ymm11, %edi
	shll	$8, %edi
	orl	%esi, %edi
	je	.LBB3_68
# %bb.69:                               # %for_loop350
                                        #   in Loop: Header=BB3_67 Depth=1
	movl	%edx, %esi
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vmovdqa	8832(%rsp,%rdi), %ymm3
	vmovdqa	8864(%rsp,%rdi), %ymm7
	vpaddd	%ymm4, %ymm3, %ymm14
	vpaddd	%ymm7, %ymm9, %ymm15
	vpmaxud	%ymm7, %ymm15, %ymm7
	vpcmpeqd	%ymm7, %ymm15, %ymm7
	vpbroadcastd	.LCPI3_5(%rip), %ymm8 # ymm8 = [1,1,1,1,1,1,1,1]
	vpmaxud	%ymm3, %ymm14, %ymm3
	vpcmpeqd	%ymm3, %ymm14, %ymm3
	vpandn	%ymm8, %ymm3, %ymm3
	vblendvps	%ymm10, %ymm3, %ymm4, %ymm4
	vpandn	%ymm8, %ymm7, %ymm3
	vblendvps	%ymm11, %ymm3, %ymm9, %ymm9
	shlq	$7, %rsi
	vpmovzxdq	%xmm14, %ymm3   # ymm3 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm7
	vpmovzxdq	%xmm7, %ymm7    # ymm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
	vpmovzxdq	%xmm15, %ymm8   # ymm8 = xmm15[0],zero,xmm15[1],zero,xmm15[2],zero,xmm15[3],zero
	vextracti128	$1, %ymm15, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpcmpeqq	736(%rsp,%rsi), %ymm2, %ymm2
	vpxor	%ymm1, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm5
	vpcmpeqq	704(%rsp,%rsi), %ymm8, %ymm8
	vpackssdw	%xmm5, %xmm2, %xmm2
	vpxor	%ymm1, %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpackssdw	%xmm2, %xmm5, %xmm2
	vpcmpeqq	672(%rsp,%rsi), %ymm7, %ymm5
	vpxor	%ymm1, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	640(%rsp,%rsi), %ymm3, %ymm3
	vpxor	%ymm1, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm6
	vpackssdw	%xmm6, %xmm3, %xmm3
	vpackssdw	%xmm5, %xmm3, %xmm3
	vpacksswb	%xmm2, %xmm3, %xmm2
	vextracti128	$1, %ymm10, %xmm3
	vpshufb	%xmm13, %xmm3, %xmm3
	vpshufb	%xmm13, %xmm10, %xmm5
	vpunpckldq	%xmm3, %xmm5, %xmm3 # xmm3 = xmm5[0],xmm3[0],xmm5[1],xmm3[1]
	vextracti128	$1, %ymm11, %xmm5
	vpshufb	%xmm12, %xmm5, %xmm5
	vpshufb	%xmm12, %xmm11, %xmm6
	vpunpckldq	%xmm5, %xmm6, %xmm5 # xmm5 = xmm6[0],xmm5[0],xmm6[1],xmm5[1]
	vpblendd	$12, %xmm5, %xmm3, %xmm3 # xmm3 = xmm3[0,1],xmm5[2,3]
	vpand	%xmm3, %xmm2, %xmm2
	vpsllw	$7, %xmm2, %xmm2
	vpand	.LCPI3_8(%rip), %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpgtb	%xmm2, %xmm3, %xmm2
	vpandn	%xmm0, %xmm2, %xmm0
	incl	%edx
	jmp	.LBB3_67
.LBB3_68:
	vmovaps	192(%rsp), %ymm11       # 32-byte Reload
	vmovaps	160(%rsp), %ymm10       # 32-byte Reload
	jmp	.LBB3_64
.LBB3_63:
	vpcmpeqd	%xmm0, %xmm0, %xmm0
.LBB3_64:                               # %safe_if_after_true341
	xorl	$255, %eax
	xorl	$255, %ebx
	shll	$8, %ebx
	orl	%eax, %ebx
	je	.LBB3_65
# %bb.70:                               # %safe_if_run_false407
	vpxor	%ymm1, %ymm10, %ymm3
	vpbroadcastq	.LCPI3_9(%rip), %ymm2 # ymm2 = [1,1,1,1]
	vpcmpeqq	736(%rsp), %ymm2, %ymm4
	vpcmpeqq	704(%rsp), %ymm2, %ymm5
	vpxor	%ymm1, %ymm11, %ymm1
	vpackssdw	%ymm4, %ymm5, %ymm4
	vpcmpeqq	672(%rsp), %ymm2, %ymm5
	vpermq	$216, %ymm4, %ymm4      # ymm4 = ymm4[0,2,1,3]
	vpcmpeqq	640(%rsp), %ymm2, %ymm2
	vpackssdw	%ymm5, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2      # ymm2 = ymm2[0,2,1,3]
	vpackssdw	%ymm4, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2      # ymm2 = ymm2[0,2,1,3]
	vextracti128	$1, %ymm2, %xmm4
	vpacksswb	%xmm4, %xmm2, %xmm8
	vextracti128	$1, %ymm3, %xmm4
	vmovdqa	.LCPI3_6(%rip), %xmm10  # xmm10 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
	vpshufb	%xmm10, %xmm4, %xmm4
	vpshufb	%xmm10, %xmm3, %xmm6
	vpunpckldq	%xmm4, %xmm6, %xmm6 # xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
	vextracti128	$1, %ymm1, %xmm7
	vmovdqa	.LCPI3_7(%rip), %xmm12  # xmm12 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
	vpshufb	%xmm12, %xmm7, %xmm7
	vpshufb	%xmm12, %xmm1, %xmm5
	vpunpckldq	%xmm7, %xmm5, %xmm5 # xmm5 = xmm5[0],xmm7[0],xmm5[1],xmm7[1]
	vpblendd	$12, %xmm5, %xmm6, %xmm5 # xmm5 = xmm6[0,1],xmm5[2,3]
	vpsllw	$7, %xmm5, %xmm5
	vpblendvb	%xmm5, %xmm8, %xmm0, %xmm0
	movl	$1, %eax
	vpxor	%xmm13, %xmm13, %xmm13
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vmovdqa	.LCPI3_8(%rip), %xmm8   # xmm8 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB3_71:                               # %for_test417
                                        # =>This Inner Loop Header: Depth=1
	cmpl	%r12d, %eax
	sbbl	%edx, %edx
	vmovd	%edx, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpshufd	$78, %xmm0, %xmm2       # xmm2 = xmm0[2,3,0,1]
	vpmovsxbd	%xmm2, %ymm2
	vpand	%ymm2, %ymm1, %ymm1
	vpmovsxbd	%xmm0, %ymm2
	vpand	%ymm2, %ymm3, %ymm2
	vpand	%ymm7, %ymm1, %ymm1
	vpand	%ymm7, %ymm2, %ymm3
	vmovmskps	%ymm3, %esi
	vmovmskps	%ymm1, %edx
	shll	$8, %edx
	orl	%esi, %edx
	je	.LBB3_65
# %bb.72:                               # %for_loop418
                                        #   in Loop: Header=BB3_71 Depth=1
	movl	%eax, %edx
	shlq	$7, %rdx
	vpcmpeqq	736(%rsp,%rdx), %ymm13, %ymm2
	vpxor	%ymm6, %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm7
	vpcmpeqq	704(%rsp,%rdx), %ymm13, %ymm11
	vpackssdw	%xmm7, %xmm2, %xmm2
	vpxor	%ymm6, %ymm11, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vpackssdw	%xmm2, %xmm4, %xmm2
	vpcmpeqq	672(%rsp,%rdx), %ymm13, %ymm4
	vpxor	%ymm6, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vpcmpeqq	640(%rsp,%rdx), %ymm13, %ymm7
	vpxor	%ymm6, %ymm7, %ymm7
	vextracti128	$1, %ymm7, %xmm5
	vpackssdw	%xmm5, %xmm7, %xmm5
	vpackssdw	%xmm4, %xmm5, %xmm4
	vpacksswb	%xmm2, %xmm4, %xmm2
	vextracti128	$1, %ymm3, %xmm4
	vpshufb	%xmm10, %xmm4, %xmm4
	vpshufb	%xmm10, %xmm3, %xmm5
	vpunpckldq	%xmm4, %xmm5, %xmm4 # xmm4 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
	vextracti128	$1, %ymm1, %xmm5
	vpshufb	%xmm12, %xmm5, %xmm5
	vpshufb	%xmm12, %xmm1, %xmm7
	vpunpckldq	%xmm5, %xmm7, %xmm5 # xmm5 = xmm7[0],xmm5[0],xmm7[1],xmm5[1]
	vpblendd	$12, %xmm5, %xmm4, %xmm4 # xmm4 = xmm4[0,1],xmm5[2,3]
	vpand	%xmm4, %xmm2, %xmm2
	vpsllw	$7, %xmm2, %xmm2
	vpand	%xmm2, %xmm8, %xmm2
	vpcmpgtb	%xmm2, %xmm9, %xmm2
	vpandn	%xmm0, %xmm2, %xmm0
	incl	%eax
	jmp	.LBB3_71
.LBB3_65:                               # %if_done340
	vpand	.LCPI3_10(%rip), %xmm0, %xmm0
	vpshufd	$78, %xmm0, %xmm1       # xmm1 = xmm0[2,3,0,1]
	vpmovzxbd	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
	vpmovzxbd	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	%ymm1, 32(%rcx)
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
	.ident	"clang version 10.0.1 (/usr/local/src/llvm/llvm-10.0/clang ef32c611aa214dea855364efd7ba451ec5ec3f74)"
	.section	".note.GNU-stack","",@progbits
