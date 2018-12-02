	.text
	.file	"primetest.ispc"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
.LCPI0_0:
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
	movl	%edx, %r8d
	addl	$-1, %r8d
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
	testl	%eax, %eax
	jne	.LBB0_7
	jmp	.LBB0_9
.LBB0_1:                                # %for_exit24.thread
	movl	%r8d, %eax
	shlq	$7, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqa	%ymm6, 224(%rsp,%rax)
	vmovdqa	%ymm6, 192(%rsp,%rax)
	vmovdqa	%ymm6, 160(%rsp,%rax)
	vmovdqa	%ymm6, 128(%rsp,%rax)
	vpblendd	$85, (%rsi), %ymm6, %ymm1 # ymm1 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpblendd	$85, 32(%rsi), %ymm6, %ymm3 # ymm3 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpblendd	$85, 64(%rsi), %ymm6, %ymm2 # ymm2 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpblendd	$85, 96(%rsi), %ymm6, %ymm0 # ymm0 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpmuludq	%ymm0, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm4 # ymm4 = ymm1[0],ymm6[1],ymm1[2],ymm6[3],ymm1[4],ymm6[5],ymm1[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm6[1],ymm2[2],ymm6[3],ymm2[4],ymm6[5],ymm2[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm6[1],ymm0[2],ymm6[3],ymm0[4],ymm6[5],ymm0[6],ymm6[7]
	vmovdqu	%ymm8, 96(%rdi)
	vmovdqu	%ymm7, 64(%rdi)
	vmovdqu	%ymm5, 32(%rdi)
	vmovdqu	%ymm4, (%rdi)
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
	vpmuludq	-256(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	-224(%rsi,%rcx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqa	%ymm12, -224(%rsp,%rcx)
	vmovdqa	%ymm11, -256(%rsp,%rcx)
	vmovdqa	%ymm10, -192(%rsp,%rcx)
	vmovdqa	%ymm9, -160(%rsp,%rcx)
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	-64(%rsi,%rcx), %ymm1, %ymm9
	vpmuludq	-128(%rsi,%rcx), %ymm3, %ymm10
	vpaddq	%ymm7, %ymm9, %ymm7
	vpaddq	%ymm4, %ymm10, %ymm4
	vpmuludq	-96(%rsi,%rcx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpmuludq	-32(%rsi,%rcx), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqa	%ymm12, -32(%rsp,%rcx)
	vmovdqa	%ymm11, -96(%rsp,%rcx)
	vmovdqa	%ymm10, -128(%rsp,%rcx)
	vmovdqa	%ymm9, -64(%rsp,%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpmuludq	96(%rsi,%rcx), %ymm0, %ymm9
	vpmuludq	64(%rsi,%rcx), %ymm1, %ymm10
	vpaddq	%ymm8, %ymm9, %ymm8
	vpaddq	%ymm7, %ymm10, %ymm7
	vpmuludq	(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	32(%rsi,%rcx), %ymm2, %ymm9
	vpaddq	%ymm6, %ymm9, %ymm6
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqa	%ymm12, 32(%rsp,%rcx)
	vmovdqa	%ymm11, (%rsp,%rcx)
	vmovdqa	%ymm10, 64(%rsp,%rcx)
	vmovdqa	%ymm9, 96(%rsp,%rcx)
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	addq	$4, %rbx
	vpmuludq	192(%rsi,%rcx), %ymm1, %ymm9
	vpaddq	%ymm7, %ymm9, %ymm7
	vpmuludq	128(%rsi,%rcx), %ymm3, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm4
	vpmuludq	160(%rsi,%rcx), %ymm2, %ymm9
	vpmuludq	224(%rsi,%rcx), %ymm0, %ymm10
	vpaddq	%ymm6, %ymm9, %ymm6
	vpaddq	%ymm8, %ymm10, %ymm8
	vpblendd	$170, %ymm5, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm10 # ymm10 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vmovdqa	%ymm12, 224(%rsp,%rcx)
	vmovdqa	%ymm11, 160(%rsp,%rcx)
	vmovdqa	%ymm10, 128(%rsp,%rcx)
	vmovdqa	%ymm9, 192(%rsp,%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm4, %ymm4
	addq	$512, %rcx              # imm = 0x200
	cmpl	%ebx, %r9d
	jne	.LBB0_5
# %bb.6:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%eax, %eax
	je	.LBB0_9
.LBB0_7:                                # %for_loop.epil.preheader
	shlq	$7, %rbx
	negl	%eax
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB0_8:                                # %for_loop.epil
                                        # =>This Inner Loop Header: Depth=1
	vpmuludq	224(%rsi,%rbx), %ymm0, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpmuludq	192(%rsi,%rbx), %ymm1, %ymm9
	vpaddq	%ymm7, %ymm9, %ymm7
	vpmuludq	128(%rsi,%rbx), %ymm3, %ymm9
	vpmuludq	160(%rsi,%rbx), %ymm2, %ymm10
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	%ymm6, %ymm10, %ymm6
	vpblendd	$170, %ymm5, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm5[1],ymm8[2],ymm5[3],ymm8[4],ymm5[5],ymm8[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm7, %ymm10 # ymm10 = ymm7[0],ymm5[1],ymm7[2],ymm5[3],ymm7[4],ymm5[5],ymm7[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm5[1],ymm4[2],ymm5[3],ymm4[4],ymm5[5],ymm4[6],ymm5[7]
	vpblendd	$170, %ymm5, %ymm6, %ymm12 # ymm12 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7]
	vmovdqa	%ymm12, 160(%rsp,%rbx)
	vmovdqa	%ymm11, 128(%rsp,%rbx)
	vmovdqa	%ymm10, 192(%rsp,%rbx)
	vmovdqa	%ymm9, 224(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	subq	$-128, %rbx
	addl	$1, %eax
	jne	.LBB0_8
.LBB0_9:                                # %for_exit
	movl	%r8d, 108(%rsp)         # 4-byte Spill
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
	movq	%rax, 120(%rsp)         # 8-byte Spill
	movq	%rsi, %rax
	subq	$-128, %rax
	movq	%rax, 112(%rsp)         # 8-byte Spill
	movl	$2, %r13d
	xorl	%r12d, %r12d
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rdx, %r11
	.p2align	4, 0x90
.LBB0_11:                               # %for_loop32.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_16 Depth 2
	movl	%r15d, %ebx
	subl	%r12d, %ebx
	movq	%r13, %rax
	shlq	$7, %rax
#	vpblendd	$85, -32(%rsi,%rax), %ymm0, %ymm1 # ymm1 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
#	vpblendd	$85, -64(%rsi,%rax), %ymm0, %ymm2 # ymm2 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
#	vpblendd	$85, -96(%rsi,%rax), %ymm0, %ymm3 # ymm3 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
#	vpblendd	$85, -128(%rsi,%rax), %ymm0, %ymm4 # ymm4 = mem[0],ymm0[1],mem[2],ymm0[3],mem[4],ymm0[5],mem[6],ymm0[7]
    vmovdqa -32(%rsi,%rax), %ymm1
    vmovdqa -64(%rsi,%rax), %ymm2
    vmovdqa -96(%rsi,%rax), %ymm3
    vmovdqa -128(%rsi,%rax), %ymm4
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
	jne	.LBB0_15
	jmp	.LBB0_17
	.p2align	4, 0x90
.LBB0_13:                               # %for_loop32.prol.preheader
                                        #   in Loop: Header=BB0_11 Depth=1
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
	cmpl	%r12d, %r14d
	je	.LBB0_17
.LBB0_15:                               # %for_loop32.preheader
                                        #   in Loop: Header=BB0_11 Depth=1
	movq	120(%rsp), %rax         # 8-byte Reload
	subq	%rbx, %rax
	leaq	(%rbx,%r12), %r8
	shlq	$7, %rbx
	addq	112(%rsp), %rbx         # 8-byte Folded Reload
	.p2align	4, 0x90
.LBB0_16:                               # %for_loop32
                                        #   Parent Loop BB0_11 Depth=1
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
#	vpsrlq	$32, %ymm7, %ymm7
#	vpsrlq	$32, %ymm8, %ymm8
	vpsrldq	$4, %ymm7, %ymm7
	vpsrldq	$4, %ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm7, %ymm7
	vpblendd	$170, %ymm0, %ymm8, %ymm8
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
#	vpsrlq	$32, %ymm7, %ymm7
#	vpsrlq	$32, %ymm8, %ymm8
	vpsrldq	$4, %ymm7, %ymm7
	vpsrldq	$4, %ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm7, %ymm7
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	addq	$2, %r8
	addq	$256, %rbx              # imm = 0x100
	addq	$-2, %rax
	jne	.LBB0_16
.LBB0_17:                               # %for_exit33
                                        #   in Loop: Header=BB0_11 Depth=1
	movq	%r11, %rdx
	addl	%edx, %ecx
	shlq	$7, %rcx
	vmovdqa	%ymm5, 224(%rsp,%rcx)
	vmovdqa	%ymm6, 192(%rsp,%rcx)
	vmovdqa	%ymm7, 160(%rsp,%rcx)
	vmovdqa	%ymm8, 128(%rsp,%rcx)
	addq	$1, %r13
	addq	$1, %r12
	cmpl	%r15d, %r12d
	jne	.LBB0_11
.LBB0_18:                               # %for_exit24
	vpxor	%xmm6, %xmm6, %xmm6
	vpblendd	$85, (%rsi), %ymm6, %ymm1 # ymm1 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpblendd	$85, 32(%rsi), %ymm6, %ymm3 # ymm3 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpblendd	$85, 64(%rsi), %ymm6, %ymm2 # ymm2 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpblendd	$85, 96(%rsi), %ymm6, %ymm0 # ymm0 = mem[0],ymm6[1],mem[2],ymm6[3],mem[4],ymm6[5],mem[6],ymm6[7]
	vpmuludq	%ymm0, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm6[1],ymm2[2],ymm6[3],ymm2[4],ymm6[5],ymm2[6],ymm6[7]
	vpblendd	$170, %ymm6, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm6[1],ymm0[2],ymm6[3],ymm0[4],ymm6[5],ymm0[6],ymm6[7]
	vmovdqu	%ymm7, 96(%rdi)
	vmovdqu	%ymm5, 64(%rdi)
	vmovdqu	%ymm4, 32(%rdi)
	vpblendd	$170, %ymm6, %ymm1, %ymm4 # ymm4 = ymm1[0],ymm6[1],ymm1[2],ymm6[3],ymm1[4],ymm6[5],ymm1[6],ymm6[7]
	vmovdqu	%ymm4, (%rdi)
	cmpl	$0, 108(%rsp)           # 4-byte Folded Reload
	je	.LBB0_19
# %bb.20:                               # %for_loop89.preheader
	addq	%r9, %r9
	subq	$-128, %rsi
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
	vpbroadcastq	.LCPI0_0(%rip), %ymm5 # ymm5 = [4294967294,4294967294,4294967294,4294967294]
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB0_21:                               # %for_loop89
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa	128(%rsp,%rcx), %ymm10
	vmovdqa	160(%rsp,%rcx), %ymm11
	vmovdqa	192(%rsp,%rcx), %ymm12
	vmovdqa	224(%rsp,%rcx), %ymm13
	vpsrlq	$32, %ymm0, %ymm0
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	%ymm7, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpaddq	%ymm6, %ymm1, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	%ymm8, %ymm2, %ymm2
#	vpaddq	%ymm13, %ymm13, %ymm6
#	vpaddq	%ymm11, %ymm11, %ymm7
#	vpaddq	%ymm10, %ymm10, %ymm8
#	vpaddq	%ymm12, %ymm12, %ymm9
	vpaddd	%ymm13, %ymm13, %ymm6
	vpaddd	%ymm11, %ymm11, %ymm7
	vpaddd	%ymm10, %ymm10, %ymm8
	vpaddd	%ymm12, %ymm12, %ymm9
#	vpand	%ymm5, %ymm9, %ymm9
	vpaddq	%ymm9, %ymm2, %ymm2
#	vpand	%ymm5, %ymm8, %ymm8
	vpaddq	%ymm8, %ymm1, %ymm1
#	vpand	%ymm5, %ymm7, %ymm7
	vpaddq	%ymm7, %ymm3, %ymm3
#	vpand	%ymm5, %ymm6, %ymm6
	vpaddq	%ymm6, %ymm0, %ymm0
	leal	1(%rax), %ecx
	shlq	$7, %rcx
	vpblendd	$170, %ymm4, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm4[1],ymm1[2],ymm4[3],ymm1[4],ymm4[5],ymm1[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpblendd	$170, %ymm4, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vmovdqu	%ymm8, 96(%rdi,%rcx)
	vmovdqu	%ymm7, 32(%rdi,%rcx)
	vmovdqu	%ymm6, (%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	vmovdqu	%ymm6, 64(%rdi,%rcx)
	vpsllq	$1, %ymm10, %ymm6
	vpsllq	$1, %ymm11, %ymm7
	vpsllq	$1, %ymm12, %ymm8
	vpsllq	$1, %ymm13, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm6
	vpaddd	%ymm7, %ymm3, %ymm7
	vpaddd	%ymm8, %ymm2, %ymm8
	vpaddd	%ymm9, %ymm0, %ymm9
	vpsrlq	$32, %ymm6, %ymm10
	vpsrlq	$32, %ymm7, %ymm11
#	vpsrlq	$32, %ymm8, %ymm12
#	vpsrlq	$32, %ymm9, %ymm13
	vpsrldq	$4, %ymm8, %ymm12
	vpsrldq	$4, %ymm9, %ymm13
	vpblendd	$170, %ymm4, %ymm12, %ymm12
	vpblendd	$170, %ymm4, %ymm13, %ymm13
#	vpblendd	$85, 96(%rsi), %ymm4, %ymm6 # ymm6 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
#	vpblendd	$85, 64(%rsi), %ymm4, %ymm2 # ymm2 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
#	vpblendd	$85, 32(%rsi), %ymm4, %ymm3 # ymm3 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
#	vpblendd	$85, (%rsi), %ymm4, %ymm0 # ymm0 = mem[0],ymm4[1],mem[2],ymm4[3],mem[4],ymm4[5],mem[6],ymm4[7]
    vmovdqa  (%rsi), %ymm0
    vmovdqa  32(%rsi), %ymm3
    vmovdqa  64(%rsi), %ymm2
    vmovdqa  96(%rsi), %ymm6
	vpmuludq	%ymm0, %ymm0, %ymm1
	vpmuludq	%ymm3, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm2, %ymm2
	vpmuludq	%ymm6, %ymm6, %ymm0
	vmovdqa	128(%rsp,%rcx), %ymm6
	vmovdqa	160(%rsp,%rcx), %ymm7
	vmovdqa	192(%rsp,%rcx), %ymm8
	vmovdqa	224(%rsp,%rcx), %ymm9
	vpaddd	%ymm6, %ymm6, %ymm14
	vpaddq	%ymm14, %ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm1, %ymm14 # ymm14 = ymm1[0],ymm4[1],ymm1[2],ymm4[3],ymm1[4],ymm4[5],ymm1[6],ymm4[7]
	vpaddq	%ymm10, %ymm14, %ymm10
	vpaddd	%ymm7, %ymm7, %ymm14
	vpaddq	%ymm14, %ymm11, %ymm11
	vpblendd	$170, %ymm4, %ymm3, %ymm14 # ymm14 = ymm3[0],ymm4[1],ymm3[2],ymm4[3],ymm3[4],ymm4[5],ymm3[6],ymm4[7]
	vpaddq	%ymm11, %ymm14, %ymm11
	vpaddd	%ymm8, %ymm8, %ymm14
	vpaddq	%ymm14, %ymm12, %ymm12
	vpaddd	%ymm9, %ymm9, %ymm14
	vpaddq	%ymm14, %ymm13, %ymm13
	vpblendd	$170, %ymm4, %ymm0, %ymm14 # ymm14 = ymm0[0],ymm4[1],ymm0[2],ymm4[3],ymm0[4],ymm4[5],ymm0[6],ymm4[7]
	vpaddq	%ymm13, %ymm14, %ymm13
	addq	$2, %rax
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpblendd	$170, %ymm4, %ymm13, %ymm14 # ymm14 = ymm13[0],ymm4[1],ymm13[2],ymm4[3],ymm13[4],ymm4[5],ymm13[6],ymm4[7]
	vmovdqu	%ymm14, 96(%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm2, %ymm14 # ymm14 = ymm2[0],ymm4[1],ymm2[2],ymm4[3],ymm2[4],ymm4[5],ymm2[6],ymm4[7]
	vpaddq	%ymm12, %ymm14, %ymm12
	vpblendd	$170, %ymm4, %ymm12, %ymm14 # ymm14 = ymm12[0],ymm4[1],ymm12[2],ymm4[3],ymm12[4],ymm4[5],ymm12[6],ymm4[7]
	vmovdqu	%ymm14, 64(%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm11, %ymm14 # ymm14 = ymm11[0],ymm4[1],ymm11[2],ymm4[3],ymm11[4],ymm4[5],ymm11[6],ymm4[7]
	vmovdqu	%ymm14, 32(%rdi,%rcx)
	vpblendd	$170, %ymm4, %ymm10, %ymm14 # ymm14 = ymm10[0],ymm4[1],ymm10[2],ymm4[3],ymm10[4],ymm4[5],ymm10[6],ymm4[7]
	vmovdqu	%ymm14, (%rdi,%rcx)
	vpsllq	$1, %ymm6, %ymm6
	vpsllq	$1, %ymm7, %ymm7
	vpsllq	$1, %ymm8, %ymm8
	vpsllq	$1, %ymm9, %ymm9
	vpaddd	%ymm6, %ymm10, %ymm6
	vpaddd	%ymm7, %ymm11, %ymm7
	vpaddd	%ymm8, %ymm12, %ymm8
	vpaddd	%ymm9, %ymm13, %ymm9
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
#	vpsrlq	$32, %ymm8, %ymm8
#	vpsrlq	$32, %ymm9, %ymm9
	vpsrldq	$4, %ymm8, %ymm8
	vpsrldq	$4, %ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm9, %ymm9
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
	addl	$-1, %eax
	shlq	$7, %rax
	vpsrlq	$32, %ymm2, %ymm2
	vpaddq	%ymm8, %ymm2, %ymm2
	vpsrlq	$32, %ymm3, %ymm3
	vpaddq	%ymm7, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpaddq	%ymm6, %ymm1, %ymm1
	vpsrlq	$32, %ymm0, %ymm0
	vpaddq	%ymm9, %ymm0, %ymm0
	vmovdqu	%ymm2, 64(%rdi,%rax)
	vmovdqu	%ymm3, 32(%rdi,%rax)
	vmovdqu	%ymm1, (%rdi,%rax)
	vmovdqu	%ymm0, 96(%rdi,%rax)
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
	subq	$91008, %rsp            # imm = 0x16380
	vmovaps	%ymm1, %ymm14
	vmovaps	%ymm0, %ymm15
                                        # kill: def $r9d killed $r9d def $r9
	movq	%r9, 112(%rsp)          # 8-byte Spill
	movl	%r8d, %r10d
	movabsq	$4294967296, %r14       # imm = 0x100000000
	vmovmskps	%ymm0, %eax
	vmovmskps	%ymm1, %ebx
	shll	$8, %ebx
	orl	%eax, %ebx
	vmovd	%r10d, %xmm0
	vpbroadcastd	%xmm0, %ymm1
	vpmulld	.LCPI2_0(%rip), %ymm1, %ymm0
	vpmulld	.LCPI2_1(%rip), %ymm1, %ymm1
	cmpl	$65535, %ebx            # imm = 0xFFFF
	movq	%r10, 104(%rsp)         # 8-byte Spill
	movq	%rcx, 120(%rsp)         # 8-byte Spill
	jne	.LBB2_1
# %bb.4:                                # %for_test.preheader
	testl	%r10d, %r10d
	je	.LBB2_11
# %bb.5:                                # %for_loop.lr.ph
	cmpl	$1, %r10d
	jne	.LBB2_7
# %bb.6:
	xorl	%r11d, %r11d
	jmp	.LBB2_10
.LBB2_1:                                # %for_test495.preheader
	testl	%r10d, %r10d
	je	.LBB2_84
# %bb.2:                                # %for_loop497.lr.ph
	cmpl	$1, %r10d
	jne	.LBB2_80
# %bb.3:
	xorl	%r11d, %r11d
	jmp	.LBB2_83
.LBB2_7:                                # %for_loop.lr.ph.new
	movl	%r10d, %r8d
	andl	$1, %r8d
	movl	%r10d, %r9d
	subl	%r8d, %r9d
	movl	$64, %eax
	xorl	%r11d, %r11d
	.p2align	4, 0x90
.LBB2_8:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%r11d, %xmm2
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
	vmovdqa	%ymm6, 21216(%rsp,%rax)
	vmovdqa	%ymm5, 21184(%rsp,%rax)
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm4, (%rdx,%ymm3), %ymm5
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm3, (%rdx,%ymm2), %ymm4
	vpmovzxdq	%xmm5, %ymm2    # ymm2 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vextracti128	$1, %ymm5, %xmm3
	vpmovzxdq	%xmm4, %ymm5    # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vmovdqa	%ymm5, 8896(%rsp,%rax,2)
	leal	1(%r11), %ebx
	vmovd	%ebx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vmovdqa	%ymm2, 8832(%rsp,%rax,2)
	vpaddd	%ymm1, %ymm5, %ymm2
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovdqa	%ymm4, 8928(%rsp,%rax,2)
	vpslld	$2, %ymm5, %ymm4
	vpslld	$2, %ymm2, %ymm2
	vmovdqa	%ymm3, 8864(%rsp,%rax,2)
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpgatherdd	%ymm3, (%rdi,%ymm2), %ymm5
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%xmm6, %xmm6, %xmm6
	vpgatherdd	%ymm3, (%rdi,%ymm4), %ymm6
	vmovdqa	%ymm6, 21280(%rsp,%rax)
	vmovdqa	%ymm5, 21248(%rsp,%rax)
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
	vmovdqa	%ymm5, 9024(%rsp,%rax,2)
	vmovdqa	%ymm3, 9056(%rsp,%rax,2)
	vmovdqa	%ymm2, 8960(%rsp,%rax,2)
	vmovdqa	%ymm4, 8992(%rsp,%rax,2)
	addq	$2, %r11
	subq	$-128, %rax
	cmpl	%r11d, %r9d
	jne	.LBB2_8
# %bb.9:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_11
.LBB2_10:                               # %for_loop.epil.preheader
	movq	%r11, %rbx
	shlq	$6, %rbx
	vmovd	%r11d, %xmm2
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
	vmovdqa	%ymm4, 21280(%rsp,%rbx)
	vmovdqa	%ymm3, 21248(%rsp,%rbx)
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm1), %ymm3
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	%ymm1, (%rdx,%ymm0), %ymm2
	shlq	$7, %r11
	vpmovzxdq	%xmm3, %ymm0    # ymm0 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vpmovzxdq	%xmm2, %ymm3    # ymm3 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vmovdqa	%ymm2, 9056(%rsp,%r11)
	vmovdqa	%ymm3, 9024(%rsp,%r11)
	vmovdqa	%ymm1, 8992(%rsp,%r11)
	vmovdqa	%ymm0, 8960(%rsp,%r11)
.LBB2_11:                               # %for_exit
	xorl	%ecx, %ecx
	cmpl	$23, 112(%rsp)          # 4-byte Folded Reload
	seta	%cl
	movl	%r10d, %eax
	subl	%ecx, %eax
	vmovups	(%rsi), %ymm0
	vmovaps	%ymm0, 288(%rsp)        # 32-byte Spill
	vmovdqu	32(%rsi), %ymm0
	vmovdqa	%ymm0, 256(%rsp)        # 32-byte Spill
	testl	%eax, %eax
	jle	.LBB2_19
# %bb.12:                               # %for_loop38.lr.ph
	movq	112(%rsp), %rsi         # 8-byte Reload
	cmpl	$24, %esi
	setb	%cl
	shlb	$5, %cl
	movzbl	%cl, %ecx
	leal	(%rcx,%rsi), %ecx
	addl	$-24, %ecx
	movl	$-2147483648, %edx      # imm = 0x80000000
	shrxl	%ecx, %edx, %r8d
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm10
	movl	$32, %ecx
	subl	%esi, %ecx
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm11
	movl	%r10d, %r9d
	movslq	%eax, %rcx
	leaq	21312(%rsp), %r15
	movl	%r10d, %eax
	andl	$1, %eax
	movl	%r10d, %r13d
	subl	%eax, %r13d
	movq	%r9, %r12
	shlq	$7, %r12
	vmovdqa	%ymm10, 384(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 352(%rsp)       # 32-byte Spill
	movq	%r9, 480(%rsp)          # 8-byte Spill
	.p2align	4, 0x90
.LBB2_13:                               # %for_loop38
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_16 Depth 2
                                        #       Child Loop BB2_29 Depth 3
                                        #         Child Loop BB2_32 Depth 4
                                        #       Child Loop BB2_42 Depth 3
                                        #       Child Loop BB2_39 Depth 3
                                        #         Child Loop BB2_44 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 544(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB2_15
# %bb.14:                               # %for_loop38
                                        #   in Loop: Header=BB2_13 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_15:                               # %for_loop38
                                        #   in Loop: Header=BB2_13 Depth=1
	vpaddd	21280(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 448(%rsp)        # 32-byte Spill
	vpaddd	21248(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 576(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_16:                               # %do_loop
                                        #   Parent Loop BB2_13 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_29 Depth 3
                                        #         Child Loop BB2_32 Depth 4
                                        #       Child Loop BB2_42 Depth 3
                                        #       Child Loop BB2_39 Depth 3
                                        #         Child Loop BB2_44 Depth 4
	movl	%r8d, %ebx
	leaq	74496(%rsp), %rdi
	leaq	8960(%rsp), %rsi
	movl	%r10d, %edx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	104(%rsp), %r10         # 8-byte Reload
	testl	%r10d, %r10d
	je	.LBB2_17
# %bb.28:                               # %for_loop70.lr.ph.us.preheader
                                        #   in Loop: Header=BB2_16 Depth=2
	movl	$1, %eax
	xorl	%ecx, %ecx
	movl	%ebx, %r8d
	movq	480(%rsp), %r9          # 8-byte Reload
	vpxor	%xmm12, %xmm12, %xmm12
	.p2align	4, 0x90
.LBB2_29:                               # %for_loop70.lr.ph.us
                                        #   Parent Loop BB2_13 Depth=1
                                        #     Parent Loop BB2_16 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_32 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vmovdqa	%ymm0, %ymm3
	vpermd	74560(%rsp,%rdx), %ymm0, %ymm0
	vpermd	74592(%rsp,%rdx), %ymm3, %ymm1
	vpermd	74496(%rsp,%rdx), %ymm3, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	74528(%rsp,%rdx), %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	288(%rsp), %ymm1, %ymm3 # 32-byte Folded Reload
	vpmulld	256(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpxor	%xmm5, %xmm5, %xmm5
	cmpl	$1, %r10d
	jne	.LBB2_31
# %bb.30:                               #   in Loop: Header=BB2_29 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	jmp	.LBB2_34
	.p2align	4, 0x90
.LBB2_31:                               # %for_loop70.lr.ph.us.new
                                        #   in Loop: Header=BB2_29 Depth=3
	movq	%r15, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_32:                               # %for_loop70.us
                                        #   Parent Loop BB2_13 Depth=1
                                        #     Parent Loop BB2_16 Depth=2
                                        #       Parent Loop BB2_29 Depth=3
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
	vpaddq	74496(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	74528(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	74560(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	74592(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm4, %ymm4
	vpblendd	$170, %ymm12, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm12[1],ymm5[2],ymm12[3],ymm5[4],ymm12[5],ymm5[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm12[1],ymm7[2],ymm12[3],ymm7[4],ymm12[5],ymm7[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm12[1],ymm6[2],ymm12[3],ymm6[4],ymm12[5],ymm6[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm12[1],ymm4[2],ymm12[3],ymm4[4],ymm12[5],ymm4[6],ymm12[7]
	vmovdqa	%ymm11, 74592(%rsp,%rbx)
	vmovdqa	%ymm10, 74560(%rsp,%rbx)
	vmovdqa	%ymm9, 74528(%rsp,%rbx)
	vmovdqa	%ymm8, 74496(%rsp,%rbx)
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
	vpaddq	74528(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	74592(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpaddq	74560(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	74496(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm8, %ymm5, %ymm5
	vpblendd	$170, %ymm12, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm12[1],ymm7[2],ymm12[3],ymm7[4],ymm12[5],ymm7[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm12[1],ymm4[2],ymm12[3],ymm4[4],ymm12[5],ymm4[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm12[1],ymm6[2],ymm12[3],ymm6[4],ymm12[5],ymm6[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm12[1],ymm5[2],ymm12[3],ymm5[4],ymm12[5],ymm5[6],ymm12[7]
	vmovdqa	%ymm11, 74496(%rsp,%rbx)
	vmovdqa	%ymm10, 74560(%rsp,%rbx)
	vmovdqa	%ymm9, 74592(%rsp,%rbx)
	vmovdqa	%ymm8, 74528(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r13d
	jne	.LBB2_32
# %bb.33:                               # %for_test68.for_exit71_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_29 Depth=3
	testb	$1, %r10b
	je	.LBB2_35
.LBB2_34:                               # %for_loop70.us.epil.preheader
                                        #   in Loop: Header=BB2_29 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	21296(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21280(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21264(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21248(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	vpmuludq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	74496(%rsp,%rsi), %ymm5, %ymm5
	vpaddq	74528(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm5, %ymm3
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	74560(%rsp,%rsi), %ymm6, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpaddq	74592(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpblendd	$170, %ymm12, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm12[1],ymm3[2],ymm12[3],ymm3[4],ymm12[5],ymm3[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm12[1],ymm2[2],ymm12[3],ymm2[4],ymm12[5],ymm2[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm12[1],ymm1[2],ymm12[3],ymm1[4],ymm12[5],ymm1[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm12[1],ymm0[2],ymm12[3],ymm0[4],ymm12[5],ymm0[6],ymm12[7]
	vmovdqa	%ymm7, 74592(%rsp,%rsi)
	vmovdqa	%ymm6, 74560(%rsp,%rsi)
	vmovdqa	%ymm5, 74528(%rsp,%rsi)
	vmovdqa	%ymm4, 74496(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm4
	vpsrlq	$32, %ymm1, %ymm6
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm5
.LBB2_35:                               # %for_exit71.us
                                        #   in Loop: Header=BB2_29 Depth=3
	vmovdqa	%ymm7, 8992(%rsp,%rdx)
	vmovdqa	%ymm5, 8960(%rsp,%rdx)
	vmovdqa	%ymm6, 9024(%rsp,%rdx)
	vmovdqa	%ymm4, 9056(%rsp,%rdx)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r9, %rcx
	jne	.LBB2_29
# %bb.36:                               # %for_test98.preheader
                                        #   in Loop: Header=BB2_16 Depth=2
	testl	%r10d, %r10d
	vmovdqa	384(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	352(%rsp), %ymm11       # 32-byte Reload
	je	.LBB2_37
# %bb.41:                               # %for_loop100.lr.ph
                                        #   in Loop: Header=BB2_16 Depth=2
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	576(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	448(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
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
	leaq	8960(%rsp), %rcx
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB2_42:                               # %for_loop100
                                        #   Parent Loop BB2_13 Depth=1
                                        #     Parent Loop BB2_16 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	leal	(%r10,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa	74496(%rsp,%rsi), %ymm0
	vmovdqa	74528(%rsp,%rsi), %ymm1
	vmovdqa	74560(%rsp,%rsi), %ymm2
	vmovdqa	74592(%rsp,%rsi), %ymm3
	vpaddq	8960(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	8992(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	9024(%rsp,%rdx), %ymm2, %ymm2
	vpaddq	9056(%rsp,%rdx), %ymm3, %ymm3
	vpaddq	%ymm0, %ymm0, %ymm8
	vblendvpd	%ymm4, %ymm8, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm8
	vblendvpd	%ymm5, %ymm8, %ymm1, %ymm1
	vpaddq	%ymm2, %ymm2, %ymm8
	vblendvpd	%ymm6, %ymm8, %ymm2, %ymm2
	vpaddq	%ymm3, %ymm3, %ymm8
	vblendvpd	%ymm7, %ymm8, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm9, %ymm3
	vpblendd	$170, %ymm12, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm12[1],ymm3[2],ymm12[3],ymm3[4],ymm12[5],ymm3[6],ymm12[7]
	vmovdqa	%ymm8, 96(%rcx)
	vpaddq	%ymm2, %ymm15, %ymm2
	vpblendd	$170, %ymm12, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm12[1],ymm2[2],ymm12[3],ymm2[4],ymm12[5],ymm2[6],ymm12[7]
	vmovdqa	%ymm8, 64(%rcx)
	vpaddq	%ymm1, %ymm14, %ymm1
	vpblendd	$170, %ymm12, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm12[1],ymm1[2],ymm12[3],ymm1[4],ymm12[5],ymm1[6],ymm12[7]
	vmovdqa	%ymm8, 32(%rcx)
	vpaddq	%ymm0, %ymm13, %ymm0
	vpblendd	$170, %ymm12, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm12[1],ymm0[2],ymm12[3],ymm0[4],ymm12[5],ymm0[6],ymm12[7]
	vmovdqa	%ymm8, (%rcx)
	vpsrlq	$32, %ymm3, %ymm9
	vpsrlq	$32, %ymm2, %ymm15
	vpsrlq	$32, %ymm1, %ymm14
	vpsrlq	$32, %ymm0, %ymm13
	addl	$1, %eax
	subq	$-128, %rcx
	cmpl	%eax, %r10d
	jne	.LBB2_42
	jmp	.LBB2_38
	.p2align	4, 0x90
.LBB2_17:                               #   in Loop: Header=BB2_16 Depth=2
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm9, %xmm9, %xmm9
	movl	%ebx, %r8d
	vmovdqa	384(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	352(%rsp), %ymm11       # 32-byte Reload
	vpxor	%xmm12, %xmm12, %xmm12
	jmp	.LBB2_38
	.p2align	4, 0x90
.LBB2_37:                               #   in Loop: Header=BB2_16 Depth=2
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm9, %xmm9, %xmm9
.LBB2_38:                               # %for_test134.preheader
                                        #   in Loop: Header=BB2_16 Depth=2
	vmovdqa	%ymm9, 416(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm12, %ymm9, %ymm0
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm12, %ymm15, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm4
	vpcmpeqq	%ymm12, %ymm14, %ymm0
	vpxor	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm12, %ymm13, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_46
	.p2align	4, 0x90
.LBB2_39:                               # %for_test148.preheader
                                        #   Parent Loop BB2_13 Depth=1
                                        #     Parent Loop BB2_16 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_44 Depth 4
	vmovdqa	.LCPI2_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm2, %ymm0, %ymm3
	vmovdqa	.LCPI2_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm2, %ymm1, %ymm5
	vpermd	%ymm4, %ymm0, %ymm0
	vpermd	%ymm4, %ymm1, %ymm1
	testl	%r10d, %r10d
	vmovdqa	%ymm13, 512(%rsp)       # 32-byte Spill
	vmovdqa	%ymm14, 704(%rsp)       # 32-byte Spill
	vmovdqa	%ymm15, 672(%rsp)       # 32-byte Spill
	vmovaps	%ymm4, 640(%rsp)        # 32-byte Spill
	vmovaps	%ymm2, 608(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm0, 128(%rsp)        # 32-byte Spill
	vmovdqa	%ymm5, 224(%rsp)        # 32-byte Spill
	vmovdqa	%ymm3, 192(%rsp)        # 32-byte Spill
	vmovdqa	%ymm11, %ymm8
	vpxor	%xmm11, %xmm11, %xmm11
	je	.LBB2_40
# %bb.43:                               # %for_loop150.preheader
                                        #   in Loop: Header=BB2_39 Depth=3
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vmovdqa	%ymm10, %ymm7
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB2_44:                               # %for_loop150
                                        #   Parent Loop BB2_13 Depth=1
                                        #     Parent Loop BB2_16 Depth=2
                                        #       Parent Loop BB2_39 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	8960(%rsp,%rax), %ymm2
	vmovdqa	8992(%rsp,%rax), %ymm3
	movq	%rcx, %rdx
	sarq	$26, %rdx
	vmovdqa	21248(%rsp,%rdx), %ymm0
	vmovdqa	21280(%rsp,%rdx), %ymm1
	vpsllvd	%ymm7, %ymm0, %ymm4
	vpor	%ymm15, %ymm4, %ymm4
	vpsllvd	%ymm7, %ymm1, %ymm15
	vpor	%ymm14, %ymm15, %ymm14
	vextracti128	$1, %ymm4, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm3, %ymm5
	vpaddq	%ymm13, %ymm5, %ymm5
	vmovdqa	9024(%rsp,%rax), %ymm13
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm11, %ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm9[1],ymm4[2],ymm9[3],ymm4[4],ymm9[5],ymm4[6],ymm9[7]
	vmovapd	192(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm11, %ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm9[1],ymm5[2],ymm9[3],ymm5[4],ymm9[5],ymm5[6],ymm9[7]
	vmovapd	224(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm11, %ymm3, %ymm3
	vpmovzxdq	%xmm14, %ymm11  # ymm11 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm11, %ymm13, %ymm11
	vpaddq	%ymm12, %ymm11, %ymm11
	vpblendd	$170, %ymm9, %ymm11, %ymm12 # ymm12 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vmovapd	128(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm13, %ymm12
	vmovdqa	9056(%rsp,%rax), %ymm13
	vextracti128	$1, %ymm14, %xmm6
	vpmovzxdq	%xmm6, %ymm6    # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
	vpsubq	%ymm6, %ymm13, %ymm6
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm9, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm9[1],ymm6[2],ymm9[3],ymm6[4],ymm9[5],ymm6[6],ymm9[7]
	vmovapd	160(%rsp), %ymm14       # 32-byte Reload
	vblendvpd	%ymm14, %ymm10, %ymm13, %ymm10
	vmovapd	%ymm10, 9056(%rsp,%rax)
	vmovapd	%ymm12, 9024(%rsp,%rax)
	vpsrlvd	%ymm8, %ymm1, %ymm14
	vpsrlvd	%ymm8, %ymm0, %ymm15
	vmovapd	%ymm3, 8992(%rsp,%rax)
	vmovapd	%ymm2, 8960(%rsp,%rax)
	vpsrad	$31, %ymm6, %ymm0
	vpshufd	$245, %ymm6, %ymm1      # ymm1 = ymm6[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm5, %ymm0
	vpshufd	$245, %ymm5, %ymm1      # ymm1 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm4, %ymm0
	vpshufd	$245, %ymm4, %ymm1      # ymm1 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	%r14, %rcx
	subq	$-128, %rax
	cmpq	%rax, %r12
	jne	.LBB2_44
	jmp	.LBB2_45
	.p2align	4, 0x90
.LBB2_40:                               #   in Loop: Header=BB2_39 Depth=3
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vmovdqa	%ymm10, %ymm7
	vpxor	%xmm10, %xmm10, %xmm10
.LBB2_45:                               # %for_exit151
                                        #   in Loop: Header=BB2_39 Depth=3
	vmovdqa	416(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm10, %ymm0
	vmovdqa	672(%rsp), %ymm15       # 32-byte Reload
	vpaddq	%ymm15, %ymm12, %ymm1
	vmovdqa	704(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm13, %ymm2
	vmovdqa	512(%rsp), %ymm13       # 32-byte Reload
	vpaddq	%ymm13, %ymm11, %ymm3
	vmovapd	192(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm3, %ymm13, %ymm13
	vmovapd	224(%rsp), %ymm3        # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm14, %ymm14
	vmovapd	128(%rsp), %ymm2        # 32-byte Reload
	vblendvpd	%ymm2, %ymm1, %ymm15, %ymm15
	vmovapd	160(%rsp), %ymm1        # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm4, %ymm4
	vpcmpeqq	%ymm9, %ymm14, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm9, %ymm13, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vmovapd	%ymm4, 416(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm9, %ymm4, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm9, %ymm15, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovdqa	640(%rsp), %ymm4        # 32-byte Reload
	vpandn	%ymm4, %ymm1, %ymm4
	vmovdqa	608(%rsp), %ymm2        # 32-byte Reload
	vpandn	%ymm2, %ymm0, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	%ymm7, %ymm10
	vmovdqa	%ymm8, %ymm11
	jne	.LBB2_39
.LBB2_46:                               # %for_exit137
                                        #   in Loop: Header=BB2_16 Depth=2
	shrl	%r8d
	jne	.LBB2_16
# %bb.18:                               # %for_test36.loopexit
                                        #   in Loop: Header=BB2_13 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	544(%rsp), %rcx         # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB2_13
.LBB2_19:                               # %for_test196.preheader
	testl	%r10d, %r10d
	je	.LBB2_20
# %bb.21:                               # %for_loop198.lr.ph
	leal	-1(%r10), %ecx
	movl	%r10d, %eax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB2_58
# %bb.22:
	xorl	%ecx, %ecx
	jmp	.LBB2_23
.LBB2_20:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	120(%rsp), %r15         # 8-byte Reload
	jmp	.LBB2_65
.LBB2_80:                               # %for_loop497.lr.ph.new
	movl	%r10d, %r8d
	andl	$1, %r8d
	movl	%r10d, %r9d
	subl	%r8d, %r9d
	movl	$64, %eax
	xorl	%r11d, %r11d
	.p2align	4, 0x90
.LBB2_81:                               # %for_loop497
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%r11d, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vpslld	$2, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vmovaps	%ymm15, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm3), %ymm4
	vpslld	$2, %ymm2, %ymm2
	vpxor	%xmm5, %xmm5, %xmm5
	vmovaps	%ymm14, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm2), %ymm5
	vmovdqa	%ymm5, 17120(%rsp,%rax)
	vmovdqa	%ymm4, 17088(%rsp,%rax)
	vpxor	%xmm4, %xmm4, %xmm4
	vmovaps	%ymm15, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm3), %ymm4
	vpxor	%xmm3, %xmm3, %xmm3
	vmovaps	%ymm14, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm2), %ymm3
	vpmovzxdq	%xmm4, %ymm2    # ymm2 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 704(%rsp,%rax,2)
	vmovdqa	%ymm2, 640(%rsp,%rax,2)
	leal	1(%r11), %ebx
	vmovd	%ebx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vmovdqa	%ymm3, 736(%rsp,%rax,2)
	vpaddd	%ymm1, %ymm2, %ymm3
	vpaddd	%ymm0, %ymm2, %ymm2
	vmovdqa	%ymm4, 672(%rsp,%rax,2)
	vpslld	$2, %ymm3, %ymm3
	vpxor	%xmm4, %xmm4, %xmm4
	vmovaps	%ymm15, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm3), %ymm4
	vpslld	$2, %ymm2, %ymm2
	vpxor	%xmm5, %xmm5, %xmm5
	vmovaps	%ymm14, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm2), %ymm5
	vmovdqa	%ymm5, 17184(%rsp,%rax)
	vmovdqa	%ymm4, 17152(%rsp,%rax)
	vpxor	%xmm4, %xmm4, %xmm4
	vmovaps	%ymm15, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm3), %ymm4
	vpxor	%xmm3, %xmm3, %xmm3
	vmovaps	%ymm14, %ymm5
	vpgatherdd	%ymm5, (%rdx,%ymm2), %ymm3
	vpmovzxdq	%xmm4, %ymm2    # ymm2 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm3, %ymm5    # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vmovdqa	%ymm5, 832(%rsp,%rax,2)
	vmovdqa	%ymm3, 864(%rsp,%rax,2)
	vmovdqa	%ymm2, 768(%rsp,%rax,2)
	vmovdqa	%ymm4, 800(%rsp,%rax,2)
	addq	$2, %r11
	subq	$-128, %rax
	cmpl	%r11d, %r9d
	jne	.LBB2_81
# %bb.82:                               # %for_test495.for_exit498_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_84
.LBB2_83:                               # %for_loop497.epil.preheader
	movq	%r11, %rcx
	shlq	$6, %rcx
	vmovd	%r11d, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vpaddd	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vmovaps	%ymm15, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdi,%ymm1), %ymm3
	vpslld	$2, %ymm0, %ymm0
	vmovaps	%ymm14, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpgatherdd	%ymm2, (%rdi,%ymm0), %ymm4
	vmovdqa	%ymm4, 17184(%rsp,%rcx)
	vmovdqa	%ymm3, 17152(%rsp,%rcx)
	vmovaps	%ymm15, %ymm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpgatherdd	%ymm2, (%rdx,%ymm1), %ymm3
	vpxor	%xmm1, %xmm1, %xmm1
	vmovaps	%ymm14, %ymm2
	vpgatherdd	%ymm2, (%rdx,%ymm0), %ymm1
	shlq	$7, %r11
	vpmovzxdq	%xmm3, %ymm0    # ymm0 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm1, %ymm3    # ymm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vmovdqa	%ymm1, 864(%rsp,%r11)
	vmovdqa	%ymm3, 832(%rsp,%r11)
	vmovdqa	%ymm2, 800(%rsp,%r11)
	vmovdqa	%ymm0, 768(%rsp,%r11)
.LBB2_84:                               # %for_exit498
	xorl	%ecx, %ecx
	cmpl	$23, 112(%rsp)          # 4-byte Folded Reload
	seta	%cl
	movl	%r10d, %eax
	subl	%ecx, %eax
	vmaskmovps	(%rsi), %ymm15, %ymm0
	vmovaps	%ymm0, 480(%rsp)        # 32-byte Spill
	vmaskmovps	32(%rsi), %ymm14, %ymm0
	vmovaps	%ymm0, 448(%rsp)        # 32-byte Spill
	testl	%eax, %eax
	vmovaps	%ymm14, 288(%rsp)       # 32-byte Spill
	vmovaps	%ymm15, 256(%rsp)       # 32-byte Spill
	jle	.LBB2_92
# %bb.85:                               # %for_loop545.lr.ph
	movq	112(%rsp), %rsi         # 8-byte Reload
	cmpl	$24, %esi
	setb	%cl
	shlb	$5, %cl
	movzbl	%cl, %ecx
	leal	(%rcx,%rsi), %ecx
	addl	$-24, %ecx
	movl	$-2147483648, %edx      # imm = 0x80000000
	shrxl	%ecx, %edx, %r8d
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm10
	movl	$32, %ecx
	subl	%esi, %ecx
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm11
	movl	%r10d, %r11d
	movslq	%eax, %rcx
	leaq	17216(%rsp), %r13
	movl	%r10d, %eax
	andl	$1, %eax
	movl	%r10d, %r15d
	subl	%eax, %r15d
	movq	%r11, %r12
	shlq	$7, %r12
	vmovdqa	%ymm10, 384(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 352(%rsp)       # 32-byte Spill
	movq	%r11, 576(%rsp)         # 8-byte Spill
	.p2align	4, 0x90
.LBB2_86:                               # %for_loop545
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_89 Depth 2
                                        #       Child Loop BB2_102 Depth 3
                                        #         Child Loop BB2_105 Depth 4
                                        #       Child Loop BB2_116 Depth 3
                                        #       Child Loop BB2_113 Depth 3
                                        #         Child Loop BB2_118 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 344(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB2_88
# %bb.87:                               # %for_loop545
                                        #   in Loop: Header=BB2_86 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_88:                               # %for_loop545
                                        #   in Loop: Header=BB2_86 Depth=1
	vpaddd	17184(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 544(%rsp)        # 32-byte Spill
	vpaddd	17152(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 736(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB2_89:                               # %do_loop563
                                        #   Parent Loop BB2_86 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_102 Depth 3
                                        #         Child Loop BB2_105 Depth 4
                                        #       Child Loop BB2_116 Depth 3
                                        #       Child Loop BB2_113 Depth 3
                                        #         Child Loop BB2_118 Depth 4
	movl	%r8d, %ebx
	leaq	58112(%rsp), %rdi
	leaq	768(%rsp), %rsi
	movl	%r10d, %edx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	104(%rsp), %r10         # 8-byte Reload
	testl	%r10d, %r10d
	je	.LBB2_90
# %bb.101:                              # %for_loop590.lr.ph.us.preheader
                                        #   in Loop: Header=BB2_89 Depth=2
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa	480(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	448(%rsp), %ymm13       # 32-byte Reload
	movl	%ebx, %r8d
	movq	576(%rsp), %r11         # 8-byte Reload
	vxorps	%xmm14, %xmm14, %xmm14
	vmovdqa	.LCPI2_2(%rip), %ymm15  # ymm15 = [0,2,4,6,4,6,6,7]
	.p2align	4, 0x90
.LBB2_102:                              # %for_loop590.lr.ph.us
                                        #   Parent Loop BB2_86 Depth=1
                                        #     Parent Loop BB2_89 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_105 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpermd	58176(%rsp,%rdx), %ymm15, %ymm0
	vpermd	58208(%rsp,%rdx), %ymm15, %ymm1
	vpermd	58112(%rsp,%rdx), %ymm15, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	58144(%rsp,%rdx), %ymm15, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	%ymm12, %ymm1, %ymm3
	vpmulld	%ymm13, %ymm0, %ymm1
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpxor	%xmm5, %xmm5, %xmm5
	cmpl	$1, %r10d
	jne	.LBB2_104
# %bb.103:                              #   in Loop: Header=BB2_102 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	jmp	.LBB2_107
	.p2align	4, 0x90
.LBB2_104:                              # %for_loop590.lr.ph.us.new
                                        #   in Loop: Header=BB2_102 Depth=3
	movq	%r13, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_105:                              # %for_loop590.us
                                        #   Parent Loop BB2_86 Depth=1
                                        #     Parent Loop BB2_89 Depth=2
                                        #       Parent Loop BB2_102 Depth=3
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
	vpaddq	58112(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	58144(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	58176(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	58208(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm4, %ymm4
	vpblendd	$170, %ymm14, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm14[1],ymm5[2],ymm14[3],ymm5[4],ymm14[5],ymm5[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm14[1],ymm7[2],ymm14[3],ymm7[4],ymm14[5],ymm7[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm14[1],ymm6[2],ymm14[3],ymm6[4],ymm14[5],ymm6[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm14[1],ymm4[2],ymm14[3],ymm4[4],ymm14[5],ymm4[6],ymm14[7]
	vmovdqa	%ymm11, 58208(%rsp,%rbx)
	vmovdqa	%ymm10, 58176(%rsp,%rbx)
	vmovdqa	%ymm9, 58144(%rsp,%rbx)
	vmovdqa	%ymm8, 58112(%rsp,%rbx)
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
	vpaddq	58144(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	58208(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpaddq	58176(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	58112(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm8, %ymm5, %ymm5
	vpblendd	$170, %ymm14, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm14[1],ymm7[2],ymm14[3],ymm7[4],ymm14[5],ymm7[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm14[1],ymm4[2],ymm14[3],ymm4[4],ymm14[5],ymm4[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm14[1],ymm6[2],ymm14[3],ymm6[4],ymm14[5],ymm6[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm14[1],ymm5[2],ymm14[3],ymm5[4],ymm14[5],ymm5[6],ymm14[7]
	vmovdqa	%ymm11, 58112(%rsp,%rbx)
	vmovdqa	%ymm10, 58176(%rsp,%rbx)
	vmovdqa	%ymm9, 58208(%rsp,%rbx)
	vmovdqa	%ymm8, 58144(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r15d
	jne	.LBB2_105
# %bb.106:                              # %for_test588.for_exit591_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_102 Depth=3
	testb	$1, %r10b
	je	.LBB2_108
.LBB2_107:                              # %for_loop590.us.epil.preheader
                                        #   in Loop: Header=BB2_102 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	17200(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17184(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17168(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17152(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	vpmuludq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	58112(%rsp,%rsi), %ymm5, %ymm5
	vpaddq	58144(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm5, %ymm3
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	58176(%rsp,%rsi), %ymm6, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpaddq	58208(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpblendd	$170, %ymm14, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm14[1],ymm3[2],ymm14[3],ymm3[4],ymm14[5],ymm3[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm14[1],ymm2[2],ymm14[3],ymm2[4],ymm14[5],ymm2[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm14[1],ymm1[2],ymm14[3],ymm1[4],ymm14[5],ymm1[6],ymm14[7]
	vpblendd	$170, %ymm14, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm14[1],ymm0[2],ymm14[3],ymm0[4],ymm14[5],ymm0[6],ymm14[7]
	vmovdqa	%ymm7, 58208(%rsp,%rsi)
	vmovdqa	%ymm6, 58176(%rsp,%rsi)
	vmovdqa	%ymm5, 58144(%rsp,%rsi)
	vmovdqa	%ymm4, 58112(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm4
	vpsrlq	$32, %ymm1, %ymm6
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm5
.LBB2_108:                              # %for_exit591.us
                                        #   in Loop: Header=BB2_102 Depth=3
	vmovdqa	%ymm7, 800(%rsp,%rdx)
	vmovdqa	%ymm5, 768(%rsp,%rdx)
	vmovdqa	%ymm6, 832(%rsp,%rdx)
	vmovdqa	%ymm4, 864(%rsp,%rdx)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r11, %rcx
	jne	.LBB2_102
# %bb.109:                              # %for_test621.preheader
                                        #   in Loop: Header=BB2_89 Depth=2
	testl	%r10d, %r10d
	je	.LBB2_110
# %bb.115:                              # %for_loop623.lr.ph
                                        #   in Loop: Header=BB2_89 Depth=2
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	736(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	544(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpxor	%xmm12, %xmm12, %xmm12
	vpcmpeqd	%ymm12, %ymm0, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm12, %ymm1, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI2_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	xorl	%eax, %eax
	leaq	768(%rsp), %rcx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	vmovdqa	384(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	352(%rsp), %ymm11       # 32-byte Reload
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB2_116:                              # %for_loop623
                                        #   Parent Loop BB2_86 Depth=1
                                        #     Parent Loop BB2_89 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	leal	(%r10,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa	58112(%rsp,%rsi), %ymm0
	vmovdqa	58144(%rsp,%rsi), %ymm1
	vmovdqa	58176(%rsp,%rsi), %ymm2
	vmovdqa	58208(%rsp,%rsi), %ymm3
	vpaddq	768(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	800(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	832(%rsp,%rdx), %ymm2, %ymm2
	vpaddq	864(%rsp,%rdx), %ymm3, %ymm3
	vpaddq	%ymm0, %ymm0, %ymm8
	vblendvpd	%ymm4, %ymm8, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm8
	vblendvpd	%ymm5, %ymm8, %ymm1, %ymm1
	vpaddq	%ymm2, %ymm2, %ymm8
	vblendvpd	%ymm6, %ymm8, %ymm2, %ymm2
	vpaddq	%ymm3, %ymm3, %ymm8
	vblendvpd	%ymm7, %ymm8, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm14, %ymm3
	vpblendd	$170, %ymm9, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm9[1],ymm3[2],ymm9[3],ymm3[4],ymm9[5],ymm3[6],ymm9[7]
	vmovdqa	%ymm8, 96(%rcx)
	vpaddq	%ymm2, %ymm15, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm9[1],ymm2[2],ymm9[3],ymm2[4],ymm9[5],ymm2[6],ymm9[7]
	vmovdqa	%ymm8, 64(%rcx)
	vpaddq	%ymm1, %ymm13, %ymm1
	vpblendd	$170, %ymm9, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm9[1],ymm1[2],ymm9[3],ymm1[4],ymm9[5],ymm1[6],ymm9[7]
	vmovdqa	%ymm8, 32(%rcx)
	vpaddq	%ymm0, %ymm12, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm9[1],ymm0[2],ymm9[3],ymm0[4],ymm9[5],ymm0[6],ymm9[7]
	vmovdqa	%ymm8, (%rcx)
	vpsrlq	$32, %ymm3, %ymm14
	vpsrlq	$32, %ymm2, %ymm15
	vpsrlq	$32, %ymm1, %ymm13
	vpsrlq	$32, %ymm0, %ymm12
	addl	$1, %eax
	subq	$-128, %rcx
	cmpl	%eax, %r10d
	jne	.LBB2_116
	jmp	.LBB2_112
	.p2align	4, 0x90
.LBB2_90:                               #   in Loop: Header=BB2_89 Depth=2
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vxorps	%xmm15, %xmm15, %xmm15
	vxorps	%xmm14, %xmm14, %xmm14
	movl	%ebx, %r8d
	jmp	.LBB2_111
	.p2align	4, 0x90
.LBB2_110:                              #   in Loop: Header=BB2_89 Depth=2
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm15, %xmm15, %xmm15
	vxorps	%xmm14, %xmm14, %xmm14
.LBB2_111:                              # %for_test663.preheader
                                        #   in Loop: Header=BB2_89 Depth=2
	vmovdqa	384(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	352(%rsp), %ymm11       # 32-byte Reload
	vpxor	%xmm9, %xmm9, %xmm9
.LBB2_112:                              # %for_test663.preheader
                                        #   in Loop: Header=BB2_89 Depth=2
	vmovdqa	%ymm14, 512(%rsp)       # 32-byte Spill
	vpcmpeqq	%ymm9, %ymm14, %ymm0
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vmovdqa	%ymm15, 416(%rsp)       # 32-byte Spill
	vpcmpeqq	%ymm9, %ymm15, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm4
	vpcmpeqq	%ymm9, %ymm13, %ymm0
	vpxor	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm9, %ymm12, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm2
	vmovdqa	256(%rsp), %ymm15       # 32-byte Reload
	vpand	%ymm15, %ymm2, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	288(%rsp), %ymm14       # 32-byte Reload
	vpand	%ymm14, %ymm4, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_120
	.p2align	4, 0x90
.LBB2_113:                              # %for_test681.preheader
                                        #   Parent Loop BB2_86 Depth=1
                                        #     Parent Loop BB2_89 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_118 Depth 4
	vmovdqa	.LCPI2_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm2, %ymm0, %ymm3
	vmovdqa	.LCPI2_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm2, %ymm1, %ymm5
	vpermd	%ymm4, %ymm0, %ymm0
	vpermd	%ymm4, %ymm1, %ymm1
	testl	%r10d, %r10d
	vmovdqa	%ymm12, 704(%rsp)       # 32-byte Spill
	vmovdqa	%ymm13, 672(%rsp)       # 32-byte Spill
	vmovdqa	%ymm4, 640(%rsp)        # 32-byte Spill
	vmovdqa	%ymm2, 608(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm0, 128(%rsp)        # 32-byte Spill
	vmovdqa	%ymm5, 224(%rsp)        # 32-byte Spill
	vmovdqa	%ymm3, 192(%rsp)        # 32-byte Spill
	je	.LBB2_114
# %bb.117:                              # %for_loop683.preheader
                                        #   in Loop: Header=BB2_113 Depth=3
	vpxor	%xmm14, %xmm14, %xmm14
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	vpxor	%xmm15, %xmm15, %xmm15
	vmovdqa	%ymm10, %ymm7
	vmovdqa	%ymm11, %ymm8
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB2_118:                              # %for_loop683
                                        #   Parent Loop BB2_86 Depth=1
                                        #     Parent Loop BB2_89 Depth=2
                                        #       Parent Loop BB2_113 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	768(%rsp,%rax), %ymm2
	vmovdqa	800(%rsp,%rax), %ymm3
	movq	%rcx, %rdx
	sarq	$26, %rdx
	vmovdqa	17152(%rsp,%rdx), %ymm0
	vmovdqa	17184(%rsp,%rdx), %ymm1
	vpsllvd	%ymm7, %ymm0, %ymm4
	vpor	%ymm14, %ymm4, %ymm4
	vpsllvd	%ymm7, %ymm1, %ymm14
	vpor	%ymm15, %ymm14, %ymm14
	vextracti128	$1, %ymm4, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm3, %ymm5
	vpaddq	%ymm13, %ymm5, %ymm5
	vmovdqa	832(%rsp,%rax), %ymm13
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm12, %ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm9[1],ymm4[2],ymm9[3],ymm4[4],ymm9[5],ymm4[6],ymm9[7]
	vmovapd	192(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm5, %ymm12 # ymm12 = ymm5[0],ymm9[1],ymm5[2],ymm9[3],ymm5[4],ymm9[5],ymm5[6],ymm9[7]
	vmovapd	224(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm3, %ymm3
	vpmovzxdq	%xmm14, %ymm12  # ymm12 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm12, %ymm13, %ymm12
	vpaddq	%ymm11, %ymm12, %ymm11
	vpblendd	$170, %ymm9, %ymm11, %ymm12 # ymm12 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vmovapd	128(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm13, %ymm12
	vmovdqa	864(%rsp,%rax), %ymm13
	vextracti128	$1, %ymm14, %xmm6
	vpmovzxdq	%xmm6, %ymm6    # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
	vpsubq	%ymm6, %ymm13, %ymm6
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm9, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm9[1],ymm6[2],ymm9[3],ymm6[4],ymm9[5],ymm6[6],ymm9[7]
	vmovapd	160(%rsp), %ymm14       # 32-byte Reload
	vblendvpd	%ymm14, %ymm10, %ymm13, %ymm10
	vmovapd	%ymm10, 864(%rsp,%rax)
	vmovapd	%ymm12, 832(%rsp,%rax)
	vpsrlvd	%ymm8, %ymm1, %ymm15
	vpsrlvd	%ymm8, %ymm0, %ymm14
	vmovapd	%ymm3, 800(%rsp,%rax)
	vmovapd	%ymm2, 768(%rsp,%rax)
	vpsrad	$31, %ymm6, %ymm0
	vpshufd	$245, %ymm6, %ymm1      # ymm1 = ymm6[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm5, %ymm0
	vpshufd	$245, %ymm5, %ymm1      # ymm1 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm4, %ymm0
	vpshufd	$245, %ymm4, %ymm1      # ymm1 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	%r14, %rcx
	subq	$-128, %rax
	cmpq	%rax, %r12
	jne	.LBB2_118
	jmp	.LBB2_119
	.p2align	4, 0x90
.LBB2_114:                              #   in Loop: Header=BB2_113 Depth=3
	vmovdqa	%ymm10, %ymm7
	vmovdqa	%ymm11, %ymm8
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm9, %xmm9, %xmm9
.LBB2_119:                              # %for_exit684
                                        #   in Loop: Header=BB2_113 Depth=3
	vmovdqa	704(%rsp), %ymm1        # 32-byte Reload
	vpaddq	%ymm1, %ymm12, %ymm0
	vmovdqa	%ymm1, %ymm12
	vmovapd	192(%rsp), %ymm1        # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm12, %ymm12
	vmovdqa	672(%rsp), %ymm1        # 32-byte Reload
	vpaddq	%ymm1, %ymm13, %ymm0
	vmovdqa	%ymm1, %ymm13
	vmovapd	224(%rsp), %ymm1        # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm13, %ymm13
	vmovdqa	512(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm10, %ymm0
	vmovdqa	416(%rsp), %ymm3        # 32-byte Reload
	vpaddq	%ymm3, %ymm11, %ymm1
	vmovapd	128(%rsp), %ymm2        # 32-byte Reload
	vblendvpd	%ymm2, %ymm1, %ymm3, %ymm3
	vmovapd	160(%rsp), %ymm1        # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm4, %ymm4
	vpcmpeqq	%ymm9, %ymm13, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm9, %ymm12, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vmovapd	%ymm4, 512(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm9, %ymm4, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vmovapd	%ymm3, 416(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm9, %ymm3, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovdqa	640(%rsp), %ymm4        # 32-byte Reload
	vpandn	%ymm4, %ymm1, %ymm4
	vmovdqa	608(%rsp), %ymm2        # 32-byte Reload
	vpandn	%ymm2, %ymm0, %ymm2
	vmovdqa	256(%rsp), %ymm15       # 32-byte Reload
	vpand	%ymm15, %ymm2, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	288(%rsp), %ymm14       # 32-byte Reload
	vpand	%ymm14, %ymm4, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	%ymm7, %ymm10
	vmovdqa	%ymm8, %ymm11
	jne	.LBB2_113
.LBB2_120:                              # %for_exit666
                                        #   in Loop: Header=BB2_89 Depth=2
	shrl	%r8d
	jne	.LBB2_89
# %bb.91:                               # %for_test543.loopexit
                                        #   in Loop: Header=BB2_86 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	344(%rsp), %rcx         # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB2_86
.LBB2_92:                               # %for_test735.preheader
	testl	%r10d, %r10d
	je	.LBB2_93
# %bb.94:                               # %for_loop737.lr.ph
	leal	-1(%r10), %ecx
	movl	%r10d, %eax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB2_132
# %bb.95:
	xorl	%ecx, %ecx
	jmp	.LBB2_96
.LBB2_93:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	120(%rsp), %r15         # 8-byte Reload
	jmp	.LBB2_139
.LBB2_58:                               # %for_loop198.lr.ph.new
	movl	%r10d, %edx
	subl	%eax, %edx
	movl	%r10d, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_59:                               # %for_loop198
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	8608(%rsp,%rdi), %ymm1
	vmovaps	8640(%rsp,%rdi), %ymm2
	vmovaps	8672(%rsp,%rdi), %ymm3
	vmovaps	%ymm3, 41440(%rsp,%rdi)
	vmovaps	%ymm2, 41408(%rsp,%rdi)
	vmovaps	%ymm1, 41376(%rsp,%rdi)
	vmovaps	8576(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 41344(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41824(%rsp,%rsi)
	vmovdqa	%ymm0, 41792(%rsp,%rsi)
	vmovdqa	%ymm0, 41760(%rsp,%rsi)
	vmovdqa	%ymm0, 41728(%rsp,%rsi)
	vmovaps	8704(%rsp,%rdi), %ymm1
	vmovaps	8736(%rsp,%rdi), %ymm2
	vmovaps	8768(%rsp,%rdi), %ymm3
	vmovaps	8800(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 41568(%rsp,%rdi)
	vmovaps	%ymm3, 41536(%rsp,%rdi)
	vmovaps	%ymm2, 41504(%rsp,%rdi)
	vmovaps	%ymm1, 41472(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41792(%rsp,%rsi)
	vmovdqa	%ymm0, 41728(%rsp,%rsi)
	vmovdqa	%ymm0, 41824(%rsp,%rsi)
	vmovdqa	%ymm0, 41760(%rsp,%rsi)
	vmovaps	8832(%rsp,%rdi), %ymm1
	vmovaps	8864(%rsp,%rdi), %ymm2
	vmovaps	8896(%rsp,%rdi), %ymm3
	vmovaps	8928(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 41696(%rsp,%rdi)
	vmovaps	%ymm3, 41664(%rsp,%rdi)
	vmovaps	%ymm2, 41632(%rsp,%rdi)
	vmovaps	%ymm1, 41600(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41824(%rsp,%rsi)
	vmovdqa	%ymm0, 41792(%rsp,%rsi)
	vmovdqa	%ymm0, 41760(%rsp,%rsi)
	vmovdqa	%ymm0, 41728(%rsp,%rsi)
	vmovdqa	8960(%rsp,%rdi), %ymm1
	vmovdqa	8992(%rsp,%rdi), %ymm2
	vmovdqa	9024(%rsp,%rdi), %ymm3
	vmovdqa	9056(%rsp,%rdi), %ymm4
	vmovdqa	%ymm4, 41824(%rsp,%rdi)
	vmovdqa	%ymm3, 41792(%rsp,%rdi)
	vmovdqa	%ymm2, 41760(%rsp,%rdi)
	vmovdqa	%ymm1, 41728(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 41824(%rsp,%rbx)
	vmovdqa	%ymm0, 41792(%rsp,%rbx)
	vmovdqa	%ymm0, 41760(%rsp,%rbx)
	vmovdqa	%ymm0, 41728(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB2_59
.LBB2_23:                               # %for_test196.for_test214.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	movq	120(%rsp), %r15         # 8-byte Reload
	je	.LBB2_26
# %bb.24:                               # %for_loop198.epil.preheader
	leal	(%r10,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_25:                               # %for_loop198.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	8960(%rsp,%rcx), %ymm1
	vmovdqa	8992(%rsp,%rcx), %ymm2
	vmovdqa	9024(%rsp,%rcx), %ymm3
	vmovdqa	9056(%rsp,%rcx), %ymm4
	vmovdqa	%ymm4, 41824(%rsp,%rcx)
	vmovdqa	%ymm3, 41792(%rsp,%rcx)
	vmovdqa	%ymm2, 41760(%rsp,%rcx)
	vmovdqa	%ymm1, 41728(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 41824(%rsp,%rsi)
	vmovdqa	%ymm0, 41792(%rsp,%rsi)
	vmovdqa	%ymm0, 41760(%rsp,%rsi)
	vmovdqa	%ymm0, 41728(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB2_25
.LBB2_26:                               # %for_test214.preheader
	testl	%r10d, %r10d
	je	.LBB2_27
# %bb.47:                               # %for_loop232.lr.ph.us.preheader
	leaq	21312(%rsp), %r9
	movl	%r10d, %r8d
	andl	$1, %r8d
	movl	%r10d, %r11d
	subl	%r8d, %r11d
	movl	$1, %esi
	xorl	%edi, %edi
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	movl	%r10d, %r10d
	.p2align	4, 0x90
.LBB2_48:                               # %for_loop232.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_51 Depth 2
	movq	%rdi, %rax
	shlq	$7, %rax
	vpermd	41792(%rsp,%rax), %ymm0, %ymm2
	vpermd	41824(%rsp,%rax), %ymm0, %ymm3
	vpermd	41728(%rsp,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	41760(%rsp,%rax), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	288(%rsp), %ymm3, %ymm5 # 32-byte Folded Reload
	vpmulld	256(%rsp), %ymm2, %ymm3 # 32-byte Folded Reload
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	cmpl	$1, 104(%rsp)           # 4-byte Folded Reload
	jne	.LBB2_50
# %bb.49:                               #   in Loop: Header=BB2_48 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	jmp	.LBB2_53
	.p2align	4, 0x90
.LBB2_50:                               # %for_loop232.lr.ph.us.new
                                        #   in Loop: Header=BB2_48 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	movq	%r9, %rbx
	xorl	%edx, %edx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB2_51:                               # %for_loop232.us
                                        #   Parent Loop BB2_48 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-16(%rbx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rbx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rbx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rbx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm13
	vpmuludq	%ymm4, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	leal	(%rdi,%rdx), %ecx
	shlq	$7, %rcx
	vpaddq	41728(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	41760(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm12, %ymm9, %ymm9
	vpaddq	41792(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	41824(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 41824(%rsp,%rcx)
	vmovdqa	%ymm12, 41792(%rsp,%rcx)
	vmovdqa	%ymm11, 41760(%rsp,%rcx)
	vmovdqa	%ymm10, 41728(%rsp,%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	(%rbx), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rbx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rbx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rbx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm2, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm5, %ymm10, %ymm10
	leal	(%rsi,%rdx), %ecx
	shlq	$7, %rcx
	vpaddq	41760(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	41824(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm12, %ymm6, %ymm6
	vpaddq	41792(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	41728(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	%ymm10, %ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vmovdqa	%ymm13, 41728(%rsp,%rcx)
	vmovdqa	%ymm12, 41792(%rsp,%rcx)
	vmovdqa	%ymm11, 41824(%rsp,%rcx)
	vmovdqa	%ymm10, 41760(%rsp,%rcx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %rdx
	subq	$-128, %rbx
	cmpl	%edx, %r11d
	jne	.LBB2_51
# %bb.52:                               # %for_test230.for_exit233_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_48 Depth=1
	testb	$1, 104(%rsp)           # 1-byte Folded Reload
	je	.LBB2_54
.LBB2_53:                               # %for_loop232.us.epil.preheader
                                        #   in Loop: Header=BB2_48 Depth=1
	movq	%rdx, %rcx
	shlq	$6, %rcx
	vpmovzxdq	21296(%rsp,%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21280(%rsp,%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21264(%rsp,%rcx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	21248(%rsp,%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm5
	vpmuludq	%ymm4, %ymm12, %ymm4
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	addl	%edi, %edx
	shlq	$7, %rdx
	vpaddq	41728(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	41760(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	41792(%rsp,%rdx), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm7, %ymm3
	vpaddq	41824(%rsp,%rdx), %ymm6, %ymm6
	vpaddq	%ymm2, %ymm6, %ymm2
	vpblendd	$170, %ymm1, %ymm5, %ymm6 # ymm6 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm9, 41824(%rsp,%rdx)
	vmovdqa	%ymm8, 41792(%rsp,%rdx)
	vmovdqa	%ymm7, 41760(%rsp,%rdx)
	vmovdqa	%ymm6, 41728(%rsp,%rdx)
	vpsrlq	$32, %ymm2, %ymm6
	vpsrlq	$32, %ymm3, %ymm7
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm8
.LBB2_54:                               # %for_exit233.us
                                        #   in Loop: Header=BB2_48 Depth=1
	vmovdqa	%ymm9, 8992(%rsp,%rax)
	vmovdqa	%ymm8, 8960(%rsp,%rax)
	vmovdqa	%ymm7, 9024(%rsp,%rax)
	vmovdqa	%ymm6, 9056(%rsp,%rax)
	addq	$1, %rdi
	addq	$1, %rsi
	cmpq	%r10, %rdi
	jne	.LBB2_48
# %bb.55:                               # %for_test263.preheader
	movq	104(%rsp), %r10         # 8-byte Reload
	testl	%r10d, %r10d
	je	.LBB2_27
# %bb.56:                               # %for_loop265.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, %r10d
	jne	.LBB2_60
# %bb.57:
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB2_63
.LBB2_27:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB2_65
.LBB2_132:                              # %for_loop737.lr.ph.new
	movl	%r10d, %edx
	subl	%eax, %edx
	movl	%r10d, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_133:                              # %for_loop737
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	416(%rsp,%rdi), %ymm1
	vmovaps	448(%rsp,%rdi), %ymm2
	vmovaps	480(%rsp,%rdi), %ymm3
	vmovaps	%ymm3, 25056(%rsp,%rdi)
	vmovaps	%ymm2, 25024(%rsp,%rdi)
	vmovaps	%ymm1, 24992(%rsp,%rdi)
	vmovaps	384(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 24960(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25440(%rsp,%rsi)
	vmovaps	%ymm0, 25408(%rsp,%rsi)
	vmovaps	%ymm0, 25376(%rsp,%rsi)
	vmovaps	%ymm0, 25344(%rsp,%rsi)
	vmovaps	512(%rsp,%rdi), %ymm1
	vmovaps	544(%rsp,%rdi), %ymm2
	vmovaps	576(%rsp,%rdi), %ymm3
	vmovaps	608(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 25184(%rsp,%rdi)
	vmovaps	%ymm3, 25152(%rsp,%rdi)
	vmovaps	%ymm2, 25120(%rsp,%rdi)
	vmovaps	%ymm1, 25088(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25408(%rsp,%rsi)
	vmovaps	%ymm0, 25344(%rsp,%rsi)
	vmovaps	%ymm0, 25440(%rsp,%rsi)
	vmovaps	%ymm0, 25376(%rsp,%rsi)
	vmovaps	640(%rsp,%rdi), %ymm1
	vmovaps	672(%rsp,%rdi), %ymm2
	vmovaps	704(%rsp,%rdi), %ymm3
	vmovaps	736(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 25312(%rsp,%rdi)
	vmovaps	%ymm3, 25280(%rsp,%rdi)
	vmovaps	%ymm2, 25248(%rsp,%rdi)
	vmovaps	%ymm1, 25216(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25440(%rsp,%rsi)
	vmovaps	%ymm0, 25408(%rsp,%rsi)
	vmovaps	%ymm0, 25376(%rsp,%rsi)
	vmovaps	%ymm0, 25344(%rsp,%rsi)
	vmovdqa	768(%rsp,%rdi), %ymm1
	vmovdqa	800(%rsp,%rdi), %ymm2
	vmovdqa	832(%rsp,%rdi), %ymm3
	vmovdqa	864(%rsp,%rdi), %ymm4
	vmovdqa	%ymm4, 25440(%rsp,%rdi)
	vmovdqa	%ymm3, 25408(%rsp,%rdi)
	vmovdqa	%ymm2, 25376(%rsp,%rdi)
	vmovdqa	%ymm1, 25344(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovaps	%ymm0, 25440(%rsp,%rbx)
	vmovaps	%ymm0, 25408(%rsp,%rbx)
	vmovaps	%ymm0, 25376(%rsp,%rbx)
	vmovaps	%ymm0, 25344(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB2_133
.LBB2_96:                               # %for_test735.for_test753.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	movq	120(%rsp), %r15         # 8-byte Reload
	je	.LBB2_99
# %bb.97:                               # %for_loop737.epil.preheader
	leal	(%r10,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_98:                               # %for_loop737.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	768(%rsp,%rcx), %ymm1
	vmovdqa	800(%rsp,%rcx), %ymm2
	vmovdqa	832(%rsp,%rcx), %ymm3
	vmovdqa	864(%rsp,%rcx), %ymm4
	vmovdqa	%ymm4, 25440(%rsp,%rcx)
	vmovdqa	%ymm3, 25408(%rsp,%rcx)
	vmovdqa	%ymm2, 25376(%rsp,%rcx)
	vmovdqa	%ymm1, 25344(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovaps	%ymm0, 25440(%rsp,%rsi)
	vmovaps	%ymm0, 25408(%rsp,%rsi)
	vmovaps	%ymm0, 25376(%rsp,%rsi)
	vmovaps	%ymm0, 25344(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB2_98
.LBB2_99:                               # %for_test753.preheader
	testl	%r10d, %r10d
	je	.LBB2_100
# %bb.121:                              # %for_loop771.lr.ph.us.preheader
	leaq	17216(%rsp), %r9
	movl	%r10d, %r8d
	andl	$1, %r8d
	movl	%r10d, %r11d
	subl	%r8d, %r11d
	movl	$1, %esi
	xorl	%edi, %edi
	vmovdqa	.LCPI2_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	movl	%r10d, %r10d
	.p2align	4, 0x90
.LBB2_122:                              # %for_loop771.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_125 Depth 2
	movq	%rdi, %rax
	shlq	$7, %rax
	vpermd	25408(%rsp,%rax), %ymm0, %ymm2
	vpermd	25440(%rsp,%rax), %ymm0, %ymm3
	vpermd	25344(%rsp,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	25376(%rsp,%rax), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	480(%rsp), %ymm3, %ymm5 # 32-byte Folded Reload
	vpmulld	448(%rsp), %ymm2, %ymm3 # 32-byte Folded Reload
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	cmpl	$1, 104(%rsp)           # 4-byte Folded Reload
	jne	.LBB2_124
# %bb.123:                              #   in Loop: Header=BB2_122 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	jmp	.LBB2_127
	.p2align	4, 0x90
.LBB2_124:                              # %for_loop771.lr.ph.us.new
                                        #   in Loop: Header=BB2_122 Depth=1
	vpxor	%xmm8, %xmm8, %xmm8
	movq	%r9, %rbx
	xorl	%edx, %edx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB2_125:                              # %for_loop771.us
                                        #   Parent Loop BB2_122 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-16(%rbx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rbx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rbx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rbx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm13
	vpmuludq	%ymm4, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	leal	(%rdi,%rdx), %ecx
	shlq	$7, %rcx
	vpaddq	25344(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	25376(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm12, %ymm9, %ymm9
	vpaddq	25408(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	25440(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 25440(%rsp,%rcx)
	vmovdqa	%ymm12, 25408(%rsp,%rcx)
	vmovdqa	%ymm11, 25376(%rsp,%rcx)
	vmovdqa	%ymm10, 25344(%rsp,%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	(%rbx), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rbx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rbx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rbx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm2, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm5, %ymm10, %ymm10
	leal	(%rsi,%rdx), %ecx
	shlq	$7, %rcx
	vpaddq	25376(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	25440(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm12, %ymm6, %ymm6
	vpaddq	25408(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	25344(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	%ymm10, %ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vmovdqa	%ymm13, 25344(%rsp,%rcx)
	vmovdqa	%ymm12, 25408(%rsp,%rcx)
	vmovdqa	%ymm11, 25440(%rsp,%rcx)
	vmovdqa	%ymm10, 25376(%rsp,%rcx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %rdx
	subq	$-128, %rbx
	cmpl	%edx, %r11d
	jne	.LBB2_125
# %bb.126:                              # %for_test769.for_exit772_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_122 Depth=1
	testb	$1, 104(%rsp)           # 1-byte Folded Reload
	je	.LBB2_128
.LBB2_127:                              # %for_loop771.us.epil.preheader
                                        #   in Loop: Header=BB2_122 Depth=1
	movq	%rdx, %rcx
	shlq	$6, %rcx
	vpmovzxdq	17200(%rsp,%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17184(%rsp,%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17168(%rsp,%rcx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	17152(%rsp,%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm5
	vpmuludq	%ymm4, %ymm12, %ymm4
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	addl	%edi, %edx
	shlq	$7, %rdx
	vpaddq	25344(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	25376(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	25408(%rsp,%rdx), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm7, %ymm3
	vpaddq	25440(%rsp,%rdx), %ymm6, %ymm6
	vpaddq	%ymm2, %ymm6, %ymm2
	vpblendd	$170, %ymm1, %ymm5, %ymm6 # ymm6 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm9, 25440(%rsp,%rdx)
	vmovdqa	%ymm8, 25408(%rsp,%rdx)
	vmovdqa	%ymm7, 25376(%rsp,%rdx)
	vmovdqa	%ymm6, 25344(%rsp,%rdx)
	vpsrlq	$32, %ymm2, %ymm6
	vpsrlq	$32, %ymm3, %ymm7
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm8
.LBB2_128:                              # %for_exit772.us
                                        #   in Loop: Header=BB2_122 Depth=1
	vmovdqa	%ymm9, 800(%rsp,%rax)
	vmovdqa	%ymm8, 768(%rsp,%rax)
	vmovdqa	%ymm7, 832(%rsp,%rax)
	vmovdqa	%ymm6, 864(%rsp,%rax)
	addq	$1, %rdi
	addq	$1, %rsi
	cmpq	%r10, %rdi
	jne	.LBB2_122
# %bb.129:                              # %for_test802.preheader
	movq	104(%rsp), %r10         # 8-byte Reload
	testl	%r10d, %r10d
	je	.LBB2_100
# %bb.130:                              # %for_loop804.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, %r10d
	jne	.LBB2_134
# %bb.131:
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB2_137
.LBB2_100:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB2_139
.LBB2_60:                               # %for_loop265.lr.ph.new
	movabsq	$8589934592, %rdx       # imm = 0x200000000
	leaq	9088(%rsp), %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%edi, %edi
	movl	%r10d, %ebx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_61:                               # %for_loop265
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rcx
	sarq	$25, %rcx
	vpaddq	9024(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	8992(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	8960(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	9056(%rsp,%rcx), %ymm3, %ymm3
	movl	%ebx, %ecx
	shlq	$7, %rcx
	vpaddq	41824(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	41728(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	41760(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	41792(%rsp,%rcx), %ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm9, -32(%rsi)
	vmovdqa	%ymm8, -128(%rsi)
	vmovdqa	%ymm7, -96(%rsi)
	vmovdqa	%ymm6, -64(%rsi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	leaq	(%rdi,%r14), %rcx
	sarq	$25, %rcx
	vpaddq	9056(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	8960(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	8992(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	9024(%rsp,%rcx), %ymm1, %ymm1
	leal	1(%rbx), %ecx
	shlq	$7, %rcx
	vpaddq	41792(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	41760(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	41728(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	41824(%rsp,%rcx), %ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vmovdqa	%ymm8, 64(%rsi)
	vmovdqa	%ymm7, 32(%rsi)
	vmovdqa	%ymm6, (%rsi)
	vpblendd	$170, %ymm2, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm6, 96(%rsi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	addq	$2, %rax
	addl	$2, %ebx
	addq	$256, %rsi              # imm = 0x100
	addq	%rdx, %rdi
	cmpl	%eax, %r11d
	jne	.LBB2_61
# %bb.62:                               # %for_test263.for_exit266_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_64
.LBB2_63:                               # %for_loop265.epil.preheader
	movslq	%eax, %rcx
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpaddq	8960(%rsp,%rdx), %ymm4, %ymm2
	vpaddq	8992(%rsp,%rdx), %ymm5, %ymm4
	vpaddq	9024(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	9056(%rsp,%rdx), %ymm3, %ymm3
	addl	%r10d, %ecx
	shlq	$7, %rcx
	vpaddq	41824(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	41792(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	41760(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	41728(%rsp,%rcx), %ymm2, %ymm2
	shlq	$7, %rax
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm0 # ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm0, 9056(%rsp,%rax)
	vmovdqa	%ymm7, 9024(%rsp,%rax)
	vmovdqa	%ymm6, 8992(%rsp,%rax)
	vmovdqa	%ymm5, 8960(%rsp,%rax)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm5
	vpsrlq	$32, %ymm2, %ymm4
.LBB2_64:                               # %for_test263.for_exit266_crit_edge
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
.LBB2_65:                               # %for_exit266
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_69
# %bb.66:                               # %for_exit266
	testl	%r10d, %r10d
	je	.LBB2_69
# %bb.67:                               # %for_loop300.lr.ph
	movq	112(%rsp), %rcx         # 8-byte Reload
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovaps	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm4, %ymm2, %ymm3
	vmovaps	%ymm3, 160(%rsp)        # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm6   # ymm6 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm6, %ymm3
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vpermps	%ymm5, %ymm2, %ymm2
	vmovaps	%ymm2, 224(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	movl	%r10d, %eax
	shlq	$7, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB2_68:                               # %for_loop300
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	8960(%rsp,%rcx), %ymm15
	vmovdqa	8992(%rsp,%rcx), %ymm2
	movq	%rdx, %rsi
	sarq	$26, %rsi
	vmovdqa	21248(%rsp,%rsi), %ymm13
	vmovdqa	21280(%rsp,%rsi), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm3
	vpor	%ymm12, %ymm3, %ymm3
	vpsllvd	%ymm0, %ymm14, %ymm12
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm3, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm10, %ymm4, %ymm4
	vmovdqa	9024(%rsp,%rcx), %ymm10
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vmovapd	160(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm9, %ymm15, %ymm9
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vmovapd	128(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm2, %ymm2
	vpmovzxdq	%xmm11, %ymm12  # ymm12 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm12, %ymm10, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	224(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm10, %ymm10
	vmovdqa	9056(%rsp,%rcx), %ymm12
	vextracti128	$1, %ymm11, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm12, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm6[1],ymm5[2],ymm6[3],ymm5[4],ymm6[5],ymm5[6],ymm6[7]
	vmovapd	192(%rsp), %ymm11       # 32-byte Reload
	vblendvpd	%ymm11, %ymm7, %ymm12, %ymm7
	vmovapd	%ymm7, 9056(%rsp,%rcx)
	vmovapd	%ymm10, 9024(%rsp,%rcx)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm2, 8992(%rsp,%rcx)
	vmovapd	%ymm9, 8960(%rsp,%rcx)
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
	addq	%r14, %rdx
	subq	$-128, %rcx
	cmpq	%rcx, %rax
	jne	.LBB2_68
.LBB2_69:                               # %safe_if_after_true
	leal	-1(%r10), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	9056(%rsp,%rax), %ymm0, %ymm1
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpcmpeqq	9024(%rsp,%rax), %ymm0, %ymm4
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpxor	%ymm2, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vinserti128	$1, %xmm1, %ymm3, %ymm3
	vpcmpeqq	8992(%rsp,%rax), %ymm0, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpcmpeqq	8960(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm4
	vpackssdw	%xmm4, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm1
	vmovmskps	%ymm1, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovaps	%ymm3, 160(%rsp)        # 32-byte Spill
	vmovaps	%ymm1, 128(%rsp)        # 32-byte Spill
	je	.LBB2_70
# %bb.77:                               # %for_test357.preheader
	movl	%r10d, %eax
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
	je	.LBB2_70
# %bb.78:                               # %for_loop359.preheader
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
.LBB2_79:                               # %for_loop359
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	21248(%rsp,%rdx), %ymm9, %ymm13
	vpaddd	21280(%rsp,%rdx), %ymm10, %ymm14
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpmaxud	21280(%rsp,%rdx), %ymm14, %ymm9
	vpcmpeqd	%ymm9, %ymm14, %ymm9
	vpandn	%ymm15, %ymm9, %ymm10
	vpmaxud	21248(%rsp,%rdx), %ymm13, %ymm9
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
	vpcmpeqq	8992(%rsp,%rcx), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	8960(%rsp,%rcx), %ymm12, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpcmpeqq	9056(%rsp,%rcx), %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm4
	vpackssdw	%xmm4, %xmm2, %xmm2
	vpcmpeqq	9024(%rsp,%rcx), %ymm11, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm2
	vpandn	%ymm5, %ymm2, %ymm2
	vpandn	%ymm6, %ymm3, %ymm3
	vblendvps	%ymm3, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r10d, %eax
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
	jne	.LBB2_79
	jmp	.LBB2_71
.LBB2_70:
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
.LBB2_71:                               # %safe_if_after_true349
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	128(%rsp), %ymm2, %ymm4 # 32-byte Folded Reload
	vpxor	160(%rsp), %ymm2, %ymm2 # 32-byte Folded Reload
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_75
# %bb.72:                               # %safe_if_run_false415
	vpbroadcastq	.LCPI2_6(%rip), %ymm3 # ymm3 = [1,1,1,1]
	vpcmpeqq	9056(%rsp), %ymm3, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	9024(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	8992(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	8960(%rsp), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm7
	vpackssdw	%xmm7, %xmm3, %xmm3
	vinserti128	$1, %xmm6, %ymm3, %ymm3
	vblendvps	%ymm4, %ymm3, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm5, %ymm1, %ymm1
	xorl	%eax, %eax
	cmpl	$1, %r10d
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
	je	.LBB2_75
# %bb.73:                               # %for_loop427.preheader
	movl	$1, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB2_74:                               # %for_loop427
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	8992(%rsp,%rcx), %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	8960(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	9056(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	9024(%rsp,%rcx), %ymm8, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vinserti128	$1, %xmm6, %ymm4, %ymm4
	vpandn	%ymm2, %ymm4, %ymm4
	vpandn	%ymm3, %ymm5, %ymm5
	vblendvps	%ymm5, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm4, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r10d, %eax
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
	jne	.LBB2_74
.LBB2_75:                               # %if_done348
	vbroadcastss	.LCPI2_5(%rip), %ymm2 # ymm2 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vandps	%ymm2, %ymm1, %ymm1
	vandps	%ymm2, %ymm0, %ymm0
	vmovups	%ymm0, (%r15)
	vmovups	%ymm1, 32(%r15)
	jmp	.LBB2_76
.LBB2_134:                              # %for_loop804.lr.ph.new
	movabsq	$8589934592, %rdx       # imm = 0x200000000
	leaq	896(%rsp), %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%edi, %edi
	movl	%r10d, %ebx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_135:                              # %for_loop804
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rcx
	sarq	$25, %rcx
	vpaddq	832(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	800(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	768(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	864(%rsp,%rcx), %ymm3, %ymm3
	movl	%ebx, %ecx
	shlq	$7, %rcx
	vpaddq	25440(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	25344(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	25376(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	25408(%rsp,%rcx), %ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm9, -32(%rsi)
	vmovdqa	%ymm8, -128(%rsi)
	vmovdqa	%ymm7, -96(%rsi)
	vmovdqa	%ymm6, -64(%rsi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	leaq	(%rdi,%r14), %rcx
	sarq	$25, %rcx
	vpaddq	864(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	768(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	800(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	832(%rsp,%rcx), %ymm1, %ymm1
	leal	1(%rbx), %ecx
	shlq	$7, %rcx
	vpaddq	25408(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	25376(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	25344(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	25440(%rsp,%rcx), %ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm2[1],ymm4[2],ymm2[3],ymm4[4],ymm2[5],ymm4[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm2[1],ymm5[2],ymm2[3],ymm5[4],ymm2[5],ymm5[6],ymm2[7]
	vpblendd	$170, %ymm2, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
	vmovdqa	%ymm8, 64(%rsi)
	vmovdqa	%ymm7, 32(%rsi)
	vmovdqa	%ymm6, (%rsi)
	vpblendd	$170, %ymm2, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm2[1],ymm3[2],ymm2[3],ymm3[4],ymm2[5],ymm3[6],ymm2[7]
	vmovdqa	%ymm6, 96(%rsi)
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	addq	$2, %rax
	addl	$2, %ebx
	addq	$256, %rsi              # imm = 0x100
	addq	%rdx, %rdi
	cmpl	%eax, %r11d
	jne	.LBB2_135
# %bb.136:                              # %for_test802.for_exit805_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_138
.LBB2_137:                              # %for_loop804.epil.preheader
	movslq	%eax, %rcx
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpaddq	768(%rsp,%rdx), %ymm4, %ymm2
	vpaddq	800(%rsp,%rdx), %ymm5, %ymm4
	vpaddq	832(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	864(%rsp,%rdx), %ymm3, %ymm3
	addl	%r10d, %ecx
	shlq	$7, %rcx
	vpaddq	25440(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	25408(%rsp,%rcx), %ymm1, %ymm1
	vpaddq	25376(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	25344(%rsp,%rcx), %ymm2, %ymm2
	shlq	$7, %rax
	vpblendd	$170, %ymm0, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm1, %ymm7 # ymm7 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm0 # ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm0, 864(%rsp,%rax)
	vmovdqa	%ymm7, 832(%rsp,%rax)
	vmovdqa	%ymm6, 800(%rsp,%rax)
	vmovdqa	%ymm5, 768(%rsp,%rax)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpsrlq	$32, %ymm4, %ymm5
	vpsrlq	$32, %ymm2, %ymm4
.LBB2_138:                              # %for_test802.for_exit805_crit_edge
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
.LBB2_139:                              # %for_exit805
	vpand	%ymm15, %ymm4, %ymm0
	vmovmskps	%ymm0, %eax
	vpand	%ymm14, %ymm5, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB2_143
# %bb.140:                              # %for_exit805
	testl	%r10d, %r10d
	je	.LBB2_143
# %bb.141:                              # %for_loop842.lr.ph
	movq	112(%rsp), %rcx         # 8-byte Reload
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovdqa	.LCPI2_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm4, %ymm2, %ymm3
	vmovdqa	%ymm3, 160(%rsp)        # 32-byte Spill
	vmovdqa	.LCPI2_4(%rip), %ymm6   # ymm6 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm6, %ymm3
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm2, %ymm2
	vmovdqa	%ymm2, 224(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	movl	%r10d, %eax
	shlq	$7, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB2_142:                              # %for_loop842
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	768(%rsp,%rcx), %ymm15
	vmovdqa	800(%rsp,%rcx), %ymm2
	movq	%rdx, %rsi
	sarq	$26, %rsi
	vmovdqa	17152(%rsp,%rsi), %ymm13
	vmovdqa	17184(%rsp,%rsi), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm3
	vpor	%ymm12, %ymm3, %ymm3
	vpsllvd	%ymm0, %ymm14, %ymm12
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm3, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm10, %ymm4, %ymm4
	vmovdqa	832(%rsp,%rcx), %ymm10
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vmovapd	160(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm9, %ymm15, %ymm9
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vmovapd	128(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm2, %ymm2
	vpmovzxdq	%xmm11, %ymm12  # ymm12 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm12, %ymm10, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	224(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm10, %ymm10
	vmovdqa	864(%rsp,%rcx), %ymm12
	vextracti128	$1, %ymm11, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm12, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm6[1],ymm5[2],ymm6[3],ymm5[4],ymm6[5],ymm5[6],ymm6[7]
	vmovapd	192(%rsp), %ymm11       # 32-byte Reload
	vblendvpd	%ymm11, %ymm7, %ymm12, %ymm7
	vmovapd	%ymm7, 864(%rsp,%rcx)
	vmovapd	%ymm10, 832(%rsp,%rcx)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm2, 800(%rsp,%rcx)
	vmovapd	%ymm9, 768(%rsp,%rcx)
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
	addq	%r14, %rdx
	subq	$-128, %rcx
	cmpq	%rcx, %rax
	jne	.LBB2_142
.LBB2_143:                              # %safe_if_after_true831
	leal	-1(%r10), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	864(%rsp,%rax), %ymm0, %ymm1
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpcmpeqq	832(%rsp,%rax), %ymm0, %ymm3
	vpxor	%ymm2, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	800(%rsp,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm1, %ymm3, %ymm3
	vpxor	%ymm2, %ymm4, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpcmpeqq	768(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm4
	vpackssdw	%xmm4, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm1
	vmovdqa	256(%rsp), %ymm8        # 32-byte Reload
	vpand	%ymm8, %ymm1, %ymm0
	vmovmskps	%ymm0, %eax
	vmovdqa	288(%rsp), %ymm14       # 32-byte Reload
	vpand	%ymm14, %ymm3, %ymm0
	vmovmskps	%ymm0, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	%ymm3, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 128(%rsp)        # 32-byte Spill
	je	.LBB2_144
# %bb.145:                              # %for_test903.preheader
	movl	%r10d, %eax
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
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	orl	%eax, %ecx
	je	.LBB2_146
# %bb.149:                              # %for_loop905.preheader
	vbroadcastss	.LCPI2_5(%rip), %ymm11 # ymm11 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vpbroadcastd	.LCPI2_5(%rip), %ymm15 # ymm15 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	xorl	%eax, %eax
	vmovdqa	%ymm15, %ymm9
	vmovdqa	%ymm15, %ymm10
	vmovaps	%ymm11, %ymm12
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vmovaps	256(%rsp), %ymm8        # 32-byte Reload
	.p2align	4, 0x90
.LBB2_150:                              # %for_loop905
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	17152(%rsp,%rdx), %ymm9, %ymm13
	vpaddd	17184(%rsp,%rdx), %ymm10, %ymm14
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpmaxud	17184(%rsp,%rdx), %ymm14, %ymm9
	vpcmpeqd	%ymm9, %ymm14, %ymm10
	vpmaxud	17152(%rsp,%rdx), %ymm13, %ymm9
	vpcmpeqd	%ymm9, %ymm13, %ymm9
	vpandn	%ymm15, %ymm9, %ymm9
	vblendvps	%ymm6, %ymm9, %ymm11, %ymm9
	vpandn	%ymm15, %ymm10, %ymm10
	vblendvps	%ymm5, %ymm10, %ymm12, %ymm10
	shlq	$7, %rcx
	vpmovzxdq	%xmm14, %ymm11  # ymm11 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vextracti128	$1, %ymm14, %xmm2
	vmovaps	288(%rsp), %ymm14       # 32-byte Reload
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm13, %ymm12  # ymm12 = xmm13[0],zero,xmm13[1],zero,xmm13[2],zero,xmm13[3],zero
	vextracti128	$1, %ymm13, %xmm3
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpcmpeqq	800(%rsp,%rcx), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	768(%rsp,%rcx), %ymm12, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vpcmpeqq	864(%rsp,%rcx), %ymm2, %ymm2
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vextracti128	$1, %ymm2, %xmm4
	vpcmpeqq	832(%rsp,%rcx), %ymm11, %ymm7
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
	cmpl	%r10d, %eax
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
	jne	.LBB2_150
	jmp	.LBB2_147
.LBB2_144:
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	jmp	.LBB2_147
.LBB2_146:
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vmovaps	256(%rsp), %ymm8        # 32-byte Reload
.LBB2_147:                              # %safe_if_after_true895
	vmovaps	128(%rsp), %ymm4        # 32-byte Reload
	vandnps	%ymm8, %ymm4, %ymm5
	vmovmskps	%ymm5, %eax
	vmovdqa	160(%rsp), %ymm3        # 32-byte Reload
	vpandn	%ymm14, %ymm3, %ymm5
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovaps	%ymm8, %ymm9
	je	.LBB2_148
# %bb.151:                              # %safe_if_run_false967
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vxorps	%ymm2, %ymm4, %ymm4
	vpxor	%ymm2, %ymm3, %ymm2
	vpbroadcastq	.LCPI2_6(%rip), %ymm3 # ymm3 = [1,1,1,1]
	vpcmpeqq	864(%rsp), %ymm3, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	832(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	800(%rsp), %ymm3, %ymm7
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vextracti128	$1, %ymm7, %xmm6
	vpcmpeqq	768(%rsp), %ymm3, %ymm3
	vpackssdw	%xmm6, %xmm7, %xmm6
	vextracti128	$1, %ymm3, %xmm7
	vpackssdw	%xmm7, %xmm3, %xmm3
	vinserti128	$1, %xmm6, %ymm3, %ymm3
	vblendvps	%ymm4, %ymm3, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm5, %ymm1, %ymm1
	xorl	%eax, %eax
	cmpl	$1, %r10d
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
	je	.LBB2_148
# %bb.152:                              # %for_loop979.preheader
	movl	$1, %eax
	vxorps	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_153:                              # %for_loop979
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	800(%rsp,%rcx), %ymm4, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	768(%rsp,%rcx), %ymm4, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	864(%rsp,%rcx), %ymm4, %ymm7
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vextracti128	$1, %ymm7, %xmm6
	vpcmpeqq	832(%rsp,%rcx), %ymm4, %ymm8
	vpackssdw	%xmm6, %xmm7, %xmm6
	vextracti128	$1, %ymm8, %xmm7
	vpackssdw	%xmm7, %xmm8, %xmm7
	vinserti128	$1, %xmm6, %ymm7, %ymm6
	vpandn	%ymm2, %ymm6, %ymm6
	vpandn	%ymm3, %ymm5, %ymm5
	vblendvps	%ymm5, %ymm4, %ymm0, %ymm0
	vblendvps	%ymm6, %ymm4, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r10d, %eax
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
	jne	.LBB2_153
.LBB2_148:                              # %if_done894
	vbroadcastss	.LCPI2_5(%rip), %ymm2 # ymm2 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vandps	%ymm2, %ymm0, %ymm0
	vandps	%ymm2, %ymm1, %ymm1
	vmaskmovps	%ymm0, %ymm9, (%r15)
	vmaskmovps	%ymm1, %ymm14, 32(%r15)
.LBB2_76:                               # %if_done348
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
	subq	$45824, %rsp            # imm = 0xB300
                                        # kill: def $r9d killed $r9d def $r9
	movq	%r9, 104(%rsp)          # 8-byte Spill
                                        # kill: def $r8d killed $r8d def $r8
	movq	%rcx, 96(%rsp)          # 8-byte Spill
	testl	%r8d, %r8d
	je	.LBB3_7
# %bb.1:                                # %for_loop.lr.ph
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm1
	vpmulld	.LCPI3_0(%rip), %ymm1, %ymm0
	vpmulld	.LCPI3_1(%rip), %ymm1, %ymm1
	cmpl	$1, %r8d
	jne	.LBB3_3
# %bb.2:
	xorl	%eax, %eax
	jmp	.LBB3_6
.LBB3_3:                                # %for_loop.lr.ph.new
	movl	%r8d, %r10d
	andl	$1, %r10d
	movl	%r8d, %r9d
	subl	%r10d, %r9d
	movl	$64, %ecx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB3_4:                                # %for_loop
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
	vmovdqa	%ymm5, 8800(%rsp,%rcx)
	vmovdqa	%ymm4, 8768(%rsp,%rcx)
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
	vmovdqa	%ymm5, 576(%rsp,%rcx,2)
	leal	1(%rax), %ebx
	vmovd	%ebx, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vmovdqa	%ymm2, 512(%rsp,%rcx,2)
	vpaddd	%ymm1, %ymm5, %ymm2
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovdqa	%ymm3, 608(%rsp,%rcx,2)
	vpslld	$2, %ymm5, %ymm3
	vpslld	$2, %ymm2, %ymm2
	vmovdqa	%ymm4, 544(%rsp,%rcx,2)
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vpgatherdd	%ymm5, (%rdi,%ymm2), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vpgatherdd	%ymm6, (%rdi,%ymm3), %ymm5
	vmovdqa	%ymm5, 8864(%rsp,%rcx)
	vmovdqa	%ymm4, 8832(%rsp,%rcx)
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
	vmovdqa	%ymm5, 704(%rsp,%rcx,2)
	vmovdqa	%ymm2, 736(%rsp,%rcx,2)
	vmovdqa	%ymm3, 640(%rsp,%rcx,2)
	vmovdqa	%ymm4, 672(%rsp,%rcx,2)
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %r9d
	jne	.LBB3_4
# %bb.5:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r10d, %r10d
	je	.LBB3_7
.LBB3_6:                                # %for_loop.epil.preheader
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
	vmovdqa	%ymm3, 8864(%rsp,%rcx)
	vmovdqa	%ymm2, 8832(%rsp,%rcx)
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
	vmovdqa	%ymm3, 736(%rsp,%rax)
	vmovdqa	%ymm2, 704(%rsp,%rax)
	vmovdqa	%ymm1, 672(%rsp,%rax)
	vmovdqa	%ymm0, 640(%rsp,%rax)
.LBB3_7:                                # %for_exit
	movabsq	$4294967296, %r14       # imm = 0x100000000
	xorl	%ecx, %ecx
	cmpl	$23, 104(%rsp)          # 4-byte Folded Reload
	seta	%cl
	movl	%r8d, %eax
	subl	%ecx, %eax
	vmovups	(%rsi), %ymm0
	vmovaps	%ymm0, 352(%rsp)        # 32-byte Spill
	vmovdqu	32(%rsi), %ymm0
	vmovdqa	%ymm0, 320(%rsp)        # 32-byte Spill
	testl	%eax, %eax
	jle	.LBB3_15
# %bb.8:                                # %for_loop38.lr.ph
	movq	104(%rsp), %rsi         # 8-byte Reload
	cmpl	$24, %esi
	setb	%cl
	shlb	$5, %cl
	movzbl	%cl, %ecx
	leal	(%rcx,%rsi), %ecx
	addl	$-24, %ecx
	movl	$-2147483648, %edx      # imm = 0x80000000
	shrxl	%ecx, %edx, %r10d
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm10
	movl	$32, %ecx
	subl	%esi, %ecx
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm11
	movl	%r8d, %r9d
	movslq	%eax, %rcx
	movl	%r8d, %eax
	andl	$1, %eax
	movl	%r8d, %r13d
	subl	%eax, %r13d
	movq	%r9, %r12
	shlq	$7, %r12
	vmovdqa	%ymm10, 288(%rsp)       # 32-byte Spill
	vmovdqa	%ymm11, 256(%rsp)       # 32-byte Spill
	movq	%r9, 120(%rsp)          # 8-byte Spill
	.p2align	4, 0x90
.LBB3_9:                                # %for_loop38
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_12 Depth 2
                                        #       Child Loop BB3_27 Depth 3
                                        #         Child Loop BB3_30 Depth 4
                                        #       Child Loop BB3_40 Depth 3
                                        #       Child Loop BB3_37 Depth 3
                                        #         Child Loop BB3_42 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	movq	%rcx, 112(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	je	.LBB3_11
# %bb.10:                               # %for_loop38
                                        #   in Loop: Header=BB3_9 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB3_11:                               # %for_loop38
                                        #   in Loop: Header=BB3_9 Depth=1
	vpaddd	8864(%rsp,%rax), %ymm0, %ymm1
	vmovdqa	%ymm1, 448(%rsp)        # 32-byte Spill
	vpaddd	8832(%rsp,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, 416(%rsp)        # 32-byte Spill
	.p2align	4, 0x90
.LBB3_12:                               # %do_loop
                                        #   Parent Loop BB3_9 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_27 Depth 3
                                        #         Child Loop BB3_30 Depth 4
                                        #       Child Loop BB3_40 Depth 3
                                        #       Child Loop BB3_37 Depth 3
                                        #         Child Loop BB3_42 Depth 4
	movq	%r8, %r15
	movl	%r10d, %ebx
	leaq	29312(%rsp), %rdi
	leaq	640(%rsp), %rsi
	movl	%r15d, %edx
	vzeroupper
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%r15, %r8
	testl	%r15d, %r15d
	je	.LBB3_13
# %bb.26:                               # %for_loop70.lr.ph.us.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	movl	$1, %eax
	xorl	%ecx, %ecx
	movl	%ebx, %r10d
	movq	120(%rsp), %r9          # 8-byte Reload
	leaq	8896(%rsp), %r11
	vpxor	%xmm12, %xmm12, %xmm12
	.p2align	4, 0x90
.LBB3_27:                               # %for_loop70.lr.ph.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_30 Depth 4
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vmovdqa	.LCPI3_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vmovdqa	%ymm0, %ymm3
	vpermd	29376(%rsp,%rdx), %ymm0, %ymm0
	vpermd	29408(%rsp,%rdx), %ymm3, %ymm1
	vpermd	29312(%rsp,%rdx), %ymm3, %ymm2
	vinserti128	$1, %xmm1, %ymm0, %ymm0
	vpermd	29344(%rsp,%rdx), %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vpmulld	352(%rsp), %ymm1, %ymm3 # 32-byte Folded Reload
	vpmulld	320(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vextracti128	$1, %ymm1, %xmm0
	vpmovzxdq	%xmm0, %ymm0    # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
	vpmovzxdq	%xmm1, %ymm1    # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpxor	%xmm5, %xmm5, %xmm5
	cmpl	$1, %r8d
	jne	.LBB3_29
# %bb.28:                               #   in Loop: Header=BB3_27 Depth=3
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	jmp	.LBB3_32
	.p2align	4, 0x90
.LBB3_29:                               # %for_loop70.lr.ph.us.new
                                        #   in Loop: Header=BB3_27 Depth=3
	movq	%r11, %rdi
	xorl	%esi, %esi
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB3_30:                               # %for_loop70.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        #       Parent Loop BB3_27 Depth=3
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
	vpaddq	29312(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm11, %ymm5, %ymm5
	vpaddq	29344(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	29376(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	29408(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm4, %ymm4
	vpblendd	$170, %ymm12, %ymm5, %ymm8 # ymm8 = ymm5[0],ymm12[1],ymm5[2],ymm12[3],ymm5[4],ymm12[5],ymm5[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm12[1],ymm7[2],ymm12[3],ymm7[4],ymm12[5],ymm7[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm12[1],ymm6[2],ymm12[3],ymm6[4],ymm12[5],ymm6[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm12[1],ymm4[2],ymm12[3],ymm4[4],ymm12[5],ymm4[6],ymm12[7]
	vmovdqa	%ymm11, 29408(%rsp,%rbx)
	vmovdqa	%ymm10, 29376(%rsp,%rbx)
	vmovdqa	%ymm9, 29344(%rsp,%rbx)
	vmovdqa	%ymm8, 29312(%rsp,%rbx)
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
	vpaddq	29344(%rsp,%rbx), %ymm7, %ymm7
	vpaddq	29408(%rsp,%rbx), %ymm4, %ymm4
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpaddq	29376(%rsp,%rbx), %ymm6, %ymm6
	vpaddq	%ymm9, %ymm6, %ymm6
	vpaddq	29312(%rsp,%rbx), %ymm5, %ymm5
	vpaddq	%ymm8, %ymm5, %ymm5
	vpblendd	$170, %ymm12, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm12[1],ymm7[2],ymm12[3],ymm7[4],ymm12[5],ymm7[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm4, %ymm9 # ymm9 = ymm4[0],ymm12[1],ymm4[2],ymm12[3],ymm4[4],ymm12[5],ymm4[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm12[1],ymm6[2],ymm12[3],ymm6[4],ymm12[5],ymm6[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm12[1],ymm5[2],ymm12[3],ymm5[4],ymm12[5],ymm5[6],ymm12[7]
	vmovdqa	%ymm11, 29312(%rsp,%rbx)
	vmovdqa	%ymm10, 29376(%rsp,%rbx)
	vmovdqa	%ymm9, 29408(%rsp,%rbx)
	vmovdqa	%ymm8, 29344(%rsp,%rbx)
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %r13d
	jne	.LBB3_30
# %bb.31:                               # %for_test68.for_exit71_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_27 Depth=3
	testb	$1, %r8b
	je	.LBB3_33
.LBB3_32:                               # %for_loop70.us.epil.preheader
                                        #   in Loop: Header=BB3_27 Depth=3
	movq	%rsi, %rdi
	shlq	$6, %rdi
	vpmovzxdq	8880(%rsp,%rdi), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8864(%rsp,%rdi), %ymm9 # ymm9 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8848(%rsp,%rdi), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8832(%rsp,%rdi), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	vpmuludq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm0, %ymm8, %ymm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29312(%rsp,%rsi), %ymm5, %ymm5
	vpaddq	29344(%rsp,%rsi), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm5, %ymm3
	vpaddq	%ymm2, %ymm7, %ymm2
	vpaddq	29376(%rsp,%rsi), %ymm6, %ymm5
	vpaddq	%ymm1, %ymm5, %ymm1
	vpaddq	29408(%rsp,%rsi), %ymm4, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm0
	vpblendd	$170, %ymm12, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm12[1],ymm3[2],ymm12[3],ymm3[4],ymm12[5],ymm3[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm2, %ymm5 # ymm5 = ymm2[0],ymm12[1],ymm2[2],ymm12[3],ymm2[4],ymm12[5],ymm2[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm1, %ymm6 # ymm6 = ymm1[0],ymm12[1],ymm1[2],ymm12[3],ymm1[4],ymm12[5],ymm1[6],ymm12[7]
	vpblendd	$170, %ymm12, %ymm0, %ymm7 # ymm7 = ymm0[0],ymm12[1],ymm0[2],ymm12[3],ymm0[4],ymm12[5],ymm0[6],ymm12[7]
	vmovdqa	%ymm7, 29408(%rsp,%rsi)
	vmovdqa	%ymm6, 29376(%rsp,%rsi)
	vmovdqa	%ymm5, 29344(%rsp,%rsi)
	vmovdqa	%ymm4, 29312(%rsp,%rsi)
	vpsrlq	$32, %ymm0, %ymm4
	vpsrlq	$32, %ymm1, %ymm6
	vpsrlq	$32, %ymm2, %ymm7
	vpsrlq	$32, %ymm3, %ymm5
.LBB3_33:                               # %for_exit71.us
                                        #   in Loop: Header=BB3_27 Depth=3
	vmovdqa	%ymm7, 672(%rsp,%rdx)
	vmovdqa	%ymm5, 640(%rsp,%rdx)
	vmovdqa	%ymm6, 704(%rsp,%rdx)
	vmovdqa	%ymm4, 736(%rsp,%rdx)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r9, %rcx
	jne	.LBB3_27
# %bb.34:                               # %for_test98.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	testl	%r8d, %r8d
	vmovdqa	288(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	256(%rsp), %ymm11       # 32-byte Reload
	je	.LBB3_35
# %bb.39:                               # %for_loop100.lr.ph
                                        #   in Loop: Header=BB3_12 Depth=2
	vmovd	%r10d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	416(%rsp), %ymm0, %ymm1 # 32-byte Folded Reload
	vpand	448(%rsp), %ymm0, %ymm0 # 32-byte Folded Reload
	vpxor	%xmm13, %xmm13, %xmm13
	vpcmpeqd	%ymm13, %ymm0, %ymm0
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%ymm13, %ymm1, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqa	.LCPI3_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm1, %ymm2, %ymm4
	vmovdqa	.LCPI3_4(%rip), %ymm3   # ymm3 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm1, %ymm3, %ymm5
	vpermd	%ymm0, %ymm2, %ymm6
	vpermd	%ymm0, %ymm3, %ymm7
	xorl	%eax, %eax
	leaq	640(%rsp), %rcx
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm9, %xmm9, %xmm9
	.p2align	4, 0x90
.LBB3_40:                               # %for_loop100
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	leal	(%r8,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa	29312(%rsp,%rsi), %ymm0
	vmovdqa	29344(%rsp,%rsi), %ymm1
	vmovdqa	29376(%rsp,%rsi), %ymm2
	vmovdqa	29408(%rsp,%rsi), %ymm3
	vpaddq	640(%rsp,%rdx), %ymm0, %ymm0
	vpaddq	672(%rsp,%rdx), %ymm1, %ymm1
	vpaddq	704(%rsp,%rdx), %ymm2, %ymm2
	vpaddq	736(%rsp,%rdx), %ymm3, %ymm3
	vpaddq	%ymm0, %ymm0, %ymm8
	vblendvpd	%ymm4, %ymm8, %ymm0, %ymm0
	vpaddq	%ymm1, %ymm1, %ymm8
	vblendvpd	%ymm5, %ymm8, %ymm1, %ymm1
	vpaddq	%ymm2, %ymm2, %ymm8
	vblendvpd	%ymm6, %ymm8, %ymm2, %ymm2
	vpaddq	%ymm3, %ymm3, %ymm8
	vblendvpd	%ymm7, %ymm8, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm9, %ymm3
	vpblendd	$170, %ymm12, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm12[1],ymm3[2],ymm12[3],ymm3[4],ymm12[5],ymm3[6],ymm12[7]
	vmovdqa	%ymm8, 96(%rcx)
	vpaddq	%ymm2, %ymm15, %ymm2
	vpblendd	$170, %ymm12, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm12[1],ymm2[2],ymm12[3],ymm2[4],ymm12[5],ymm2[6],ymm12[7]
	vmovdqa	%ymm8, 64(%rcx)
	vpaddq	%ymm1, %ymm14, %ymm1
	vpblendd	$170, %ymm12, %ymm1, %ymm8 # ymm8 = ymm1[0],ymm12[1],ymm1[2],ymm12[3],ymm1[4],ymm12[5],ymm1[6],ymm12[7]
	vmovdqa	%ymm8, 32(%rcx)
	vpaddq	%ymm0, %ymm13, %ymm0
	vpblendd	$170, %ymm12, %ymm0, %ymm8 # ymm8 = ymm0[0],ymm12[1],ymm0[2],ymm12[3],ymm0[4],ymm12[5],ymm0[6],ymm12[7]
	vmovdqa	%ymm8, (%rcx)
	vpsrlq	$32, %ymm3, %ymm9
	vpsrlq	$32, %ymm2, %ymm15
	vpsrlq	$32, %ymm1, %ymm14
	vpsrlq	$32, %ymm0, %ymm13
	addl	$1, %eax
	subq	$-128, %rcx
	cmpl	%eax, %r8d
	jne	.LBB3_40
	jmp	.LBB3_36
	.p2align	4, 0x90
.LBB3_13:                               #   in Loop: Header=BB3_12 Depth=2
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm9, %xmm9, %xmm9
	movl	%ebx, %r10d
	vmovdqa	288(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	256(%rsp), %ymm11       # 32-byte Reload
	vpxor	%xmm12, %xmm12, %xmm12
	jmp	.LBB3_36
	.p2align	4, 0x90
.LBB3_35:                               #   in Loop: Header=BB3_12 Depth=2
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm9, %xmm9, %xmm9
.LBB3_36:                               # %for_test134.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	vmovdqa	%ymm9, 384(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm12, %ymm9, %ymm0
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpxor	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm12, %ymm15, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm4
	vpcmpeqq	%ymm12, %ymm14, %ymm0
	vpxor	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm12, %ymm13, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_44
	.p2align	4, 0x90
.LBB3_37:                               # %for_test148.preheader
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_42 Depth 4
	vmovdqa	.LCPI3_3(%rip), %ymm0   # ymm0 = [0,0,1,1,2,2,3,3]
	vpermd	%ymm2, %ymm0, %ymm3
	vmovdqa	.LCPI3_4(%rip), %ymm1   # ymm1 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm2, %ymm1, %ymm5
	vpermd	%ymm4, %ymm0, %ymm0
	vpermd	%ymm4, %ymm1, %ymm1
	testl	%r8d, %r8d
	vmovdqa	%ymm13, 608(%rsp)       # 32-byte Spill
	vmovdqa	%ymm14, 576(%rsp)       # 32-byte Spill
	vmovdqa	%ymm15, 544(%rsp)       # 32-byte Spill
	vmovaps	%ymm4, 512(%rsp)        # 32-byte Spill
	vmovaps	%ymm2, 480(%rsp)        # 32-byte Spill
	vmovdqa	%ymm1, 160(%rsp)        # 32-byte Spill
	vmovdqa	%ymm0, 128(%rsp)        # 32-byte Spill
	vmovdqa	%ymm5, 224(%rsp)        # 32-byte Spill
	vmovdqa	%ymm3, 192(%rsp)        # 32-byte Spill
	vmovdqa	%ymm11, %ymm8
	vpxor	%xmm11, %xmm11, %xmm11
	je	.LBB3_38
# %bb.41:                               # %for_loop150.preheader
                                        #   in Loop: Header=BB3_37 Depth=3
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vmovdqa	%ymm10, %ymm7
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	.p2align	4, 0x90
.LBB3_42:                               # %for_loop150
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        #       Parent Loop BB3_37 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa	640(%rsp,%rax), %ymm2
	vmovdqa	672(%rsp,%rax), %ymm3
	movq	%rcx, %rdx
	sarq	$26, %rdx
	vmovdqa	8832(%rsp,%rdx), %ymm0
	vmovdqa	8864(%rsp,%rdx), %ymm1
	vpsllvd	%ymm7, %ymm0, %ymm4
	vpor	%ymm15, %ymm4, %ymm4
	vpsllvd	%ymm7, %ymm1, %ymm15
	vpor	%ymm14, %ymm15, %ymm14
	vextracti128	$1, %ymm4, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm3, %ymm5
	vpaddq	%ymm13, %ymm5, %ymm5
	vmovdqa	704(%rsp,%rax), %ymm13
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm11, %ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm11 # ymm11 = ymm4[0],ymm9[1],ymm4[2],ymm9[3],ymm4[4],ymm9[5],ymm4[6],ymm9[7]
	vmovapd	192(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm11, %ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm5, %ymm11 # ymm11 = ymm5[0],ymm9[1],ymm5[2],ymm9[3],ymm5[4],ymm9[5],ymm5[6],ymm9[7]
	vmovapd	224(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm11, %ymm3, %ymm3
	vpmovzxdq	%xmm14, %ymm11  # ymm11 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpsubq	%ymm11, %ymm13, %ymm11
	vpaddq	%ymm12, %ymm11, %ymm11
	vpblendd	$170, %ymm9, %ymm11, %ymm12 # ymm12 = ymm11[0],ymm9[1],ymm11[2],ymm9[3],ymm11[4],ymm9[5],ymm11[6],ymm9[7]
	vmovapd	128(%rsp), %ymm6        # 32-byte Reload
	vblendvpd	%ymm6, %ymm12, %ymm13, %ymm12
	vmovdqa	736(%rsp,%rax), %ymm13
	vextracti128	$1, %ymm14, %xmm6
	vpmovzxdq	%xmm6, %ymm6    # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
	vpsubq	%ymm6, %ymm13, %ymm6
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm9, %ymm6, %ymm10 # ymm10 = ymm6[0],ymm9[1],ymm6[2],ymm9[3],ymm6[4],ymm9[5],ymm6[6],ymm9[7]
	vmovapd	160(%rsp), %ymm14       # 32-byte Reload
	vblendvpd	%ymm14, %ymm10, %ymm13, %ymm10
	vmovapd	%ymm10, 736(%rsp,%rax)
	vmovapd	%ymm12, 704(%rsp,%rax)
	vpsrlvd	%ymm8, %ymm1, %ymm14
	vpsrlvd	%ymm8, %ymm0, %ymm15
	vmovapd	%ymm3, 672(%rsp,%rax)
	vmovapd	%ymm2, 640(%rsp,%rax)
	vpsrad	$31, %ymm6, %ymm0
	vpshufd	$245, %ymm6, %ymm1      # ymm1 = ymm6[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm10 # ymm10 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm11, %ymm0
	vpshufd	$245, %ymm11, %ymm1     # ymm1 = ymm11[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm12 # ymm12 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm5, %ymm0
	vpshufd	$245, %ymm5, %ymm1      # ymm1 = ymm5[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm13 # ymm13 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpsrad	$31, %ymm4, %ymm0
	vpshufd	$245, %ymm4, %ymm1      # ymm1 = ymm4[1,1,3,3,5,5,7,7]
	vpblendd	$170, %ymm0, %ymm1, %ymm11 # ymm11 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	addq	%r14, %rcx
	subq	$-128, %rax
	cmpq	%rax, %r12
	jne	.LBB3_42
	jmp	.LBB3_43
	.p2align	4, 0x90
.LBB3_38:                               #   in Loop: Header=BB3_37 Depth=3
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm12, %xmm12, %xmm12
	vmovdqa	%ymm10, %ymm7
	vpxor	%xmm10, %xmm10, %xmm10
.LBB3_43:                               # %for_exit151
                                        #   in Loop: Header=BB3_37 Depth=3
	vmovdqa	384(%rsp), %ymm4        # 32-byte Reload
	vpaddq	%ymm4, %ymm10, %ymm0
	vmovdqa	544(%rsp), %ymm15       # 32-byte Reload
	vpaddq	%ymm15, %ymm12, %ymm1
	vmovdqa	576(%rsp), %ymm14       # 32-byte Reload
	vpaddq	%ymm14, %ymm13, %ymm2
	vmovdqa	608(%rsp), %ymm13       # 32-byte Reload
	vpaddq	%ymm13, %ymm11, %ymm3
	vmovapd	192(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm3, %ymm13, %ymm13
	vmovapd	224(%rsp), %ymm3        # 32-byte Reload
	vblendvpd	%ymm3, %ymm2, %ymm14, %ymm14
	vmovapd	128(%rsp), %ymm2        # 32-byte Reload
	vblendvpd	%ymm2, %ymm1, %ymm15, %ymm15
	vmovapd	160(%rsp), %ymm1        # 32-byte Reload
	vblendvpd	%ymm1, %ymm0, %ymm4, %ymm4
	vpcmpeqq	%ymm9, %ymm14, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpcmpeqq	%ymm9, %ymm13, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vinserti128	$1, %xmm0, %ymm1, %ymm0
	vmovapd	%ymm4, 384(%rsp)        # 32-byte Spill
	vpcmpeqq	%ymm9, %ymm4, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpackssdw	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%ymm9, %ymm15, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpackssdw	%xmm3, %xmm2, %xmm2
	vinserti128	$1, %xmm1, %ymm2, %ymm1
	vmovdqa	512(%rsp), %ymm4        # 32-byte Reload
	vpandn	%ymm4, %ymm1, %ymm4
	vmovdqa	480(%rsp), %ymm2        # 32-byte Reload
	vpandn	%ymm2, %ymm0, %ymm2
	vmovmskps	%ymm2, %eax
	vmovmskps	%ymm4, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovdqa	%ymm7, %ymm10
	vmovdqa	%ymm8, %ymm11
	jne	.LBB3_37
.LBB3_44:                               # %for_exit137
                                        #   in Loop: Header=BB3_12 Depth=2
	shrl	%r10d
	jne	.LBB3_12
# %bb.14:                               # %for_test36.loopexit
                                        #   in Loop: Header=BB3_9 Depth=1
	movl	$-2147483648, %r10d     # imm = 0x80000000
	movq	112(%rsp), %rcx         # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB3_9
.LBB3_15:                               # %for_test196.preheader
	testl	%r8d, %r8d
	je	.LBB3_16
# %bb.17:                               # %for_loop198.lr.ph
	leal	-1(%r8), %ecx
	movl	%r8d, %eax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB3_53
# %bb.18:
	xorl	%ecx, %ecx
	testl	%eax, %eax
	jne	.LBB3_20
	jmp	.LBB3_22
.LBB3_53:                               # %for_loop198.lr.ph.new
	movl	%r8d, %edx
	subl	%eax, %edx
	movl	%r8d, %r9d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_54:                               # %for_loop198
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	288(%rsp,%rdi), %ymm1
	vmovaps	320(%rsp,%rdi), %ymm2
	vmovaps	352(%rsp,%rdi), %ymm3
	vmovaps	%ymm3, 12640(%rsp,%rdi)
	vmovaps	%ymm2, 12608(%rsp,%rdi)
	vmovaps	%ymm1, 12576(%rsp,%rdi)
	vmovaps	256(%rsp,%rdi), %ymm1
	vmovaps	%ymm1, 12544(%rsp,%rdi)
	leaq	(%r9,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 13024(%rsp,%rsi)
	vmovdqa	%ymm0, 12992(%rsp,%rsi)
	vmovdqa	%ymm0, 12960(%rsp,%rsi)
	vmovdqa	%ymm0, 12928(%rsp,%rsi)
	vmovaps	384(%rsp,%rdi), %ymm1
	vmovaps	416(%rsp,%rdi), %ymm2
	vmovaps	448(%rsp,%rdi), %ymm3
	vmovaps	480(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 12768(%rsp,%rdi)
	vmovaps	%ymm3, 12736(%rsp,%rdi)
	vmovaps	%ymm2, 12704(%rsp,%rdi)
	vmovaps	%ymm1, 12672(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 12992(%rsp,%rsi)
	vmovdqa	%ymm0, 12928(%rsp,%rsi)
	vmovdqa	%ymm0, 13024(%rsp,%rsi)
	vmovdqa	%ymm0, 12960(%rsp,%rsi)
	vmovaps	512(%rsp,%rdi), %ymm1
	vmovaps	544(%rsp,%rdi), %ymm2
	vmovaps	576(%rsp,%rdi), %ymm3
	vmovaps	608(%rsp,%rdi), %ymm4
	vmovaps	%ymm4, 12896(%rsp,%rdi)
	vmovaps	%ymm3, 12864(%rsp,%rdi)
	vmovaps	%ymm2, 12832(%rsp,%rdi)
	vmovaps	%ymm1, 12800(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 13024(%rsp,%rsi)
	vmovdqa	%ymm0, 12992(%rsp,%rsi)
	vmovdqa	%ymm0, 12960(%rsp,%rsi)
	vmovdqa	%ymm0, 12928(%rsp,%rsi)
	vmovdqa	640(%rsp,%rdi), %ymm1
	vmovdqa	672(%rsp,%rdi), %ymm2
	vmovdqa	704(%rsp,%rdi), %ymm3
	vmovdqa	736(%rsp,%rdi), %ymm4
	vmovdqa	%ymm4, 13024(%rsp,%rdi)
	vmovdqa	%ymm3, 12992(%rsp,%rdi)
	vmovdqa	%ymm2, 12960(%rsp,%rdi)
	vmovdqa	%ymm1, 12928(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovdqa	%ymm0, 13024(%rsp,%rbx)
	vmovdqa	%ymm0, 12992(%rsp,%rbx)
	vmovdqa	%ymm0, 12960(%rsp,%rbx)
	vmovdqa	%ymm0, 12928(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB3_54
# %bb.19:                               # %for_test196.for_test214.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	je	.LBB3_22
.LBB3_20:                               # %for_loop198.epil.preheader
	leal	(%r8,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_21:                               # %for_loop198.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rcx), %ymm1
	vmovdqa	672(%rsp,%rcx), %ymm2
	vmovdqa	704(%rsp,%rcx), %ymm3
	vmovdqa	736(%rsp,%rcx), %ymm4
	vmovdqa	%ymm4, 13024(%rsp,%rcx)
	vmovdqa	%ymm3, 12992(%rsp,%rcx)
	vmovdqa	%ymm2, 12960(%rsp,%rcx)
	vmovdqa	%ymm1, 12928(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa	%ymm0, 13024(%rsp,%rsi)
	vmovdqa	%ymm0, 12992(%rsp,%rsi)
	vmovdqa	%ymm0, 12960(%rsp,%rsi)
	vmovdqa	%ymm0, 12928(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB3_21
.LBB3_22:                               # %for_test214.preheader
	testl	%r8d, %r8d
	je	.LBB3_16
# %bb.23:                               # %for_loop232.lr.ph.us.preheader
	leaq	8896(%rsp), %r9
	movl	%r8d, %r15d
	andl	$1, %r15d
	movl	%r8d, %r11d
	subl	%r15d, %r11d
	movl	$1, %esi
	xorl	%edi, %edi
	vmovdqa	.LCPI3_2(%rip), %ymm0   # ymm0 = [0,2,4,6,4,6,6,7]
	vpxor	%xmm1, %xmm1, %xmm1
	movl	%r8d, %r10d
	.p2align	4, 0x90
.LBB3_24:                               # %for_loop232.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_46 Depth 2
	movq	%rdi, %rax
	shlq	$7, %rax
	vpermd	12992(%rsp,%rax), %ymm0, %ymm2
	vpermd	13024(%rsp,%rax), %ymm0, %ymm3
	vpermd	12928(%rsp,%rax), %ymm0, %ymm4
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vpermd	12960(%rsp,%rax), %ymm0, %ymm3
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpmulld	352(%rsp), %ymm3, %ymm5 # 32-byte Folded Reload
	vpmulld	320(%rsp), %ymm2, %ymm3 # 32-byte Folded Reload
	vextracti128	$1, %ymm3, %xmm2
	vpmovzxdq	%xmm2, %ymm2    # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vextracti128	$1, %ymm5, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpxor	%xmm8, %xmm8, %xmm8
	cmpl	$1, %r8d
	jne	.LBB3_45
# %bb.25:                               #   in Loop: Header=BB3_24 Depth=1
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	jmp	.LBB3_48
	.p2align	4, 0x90
.LBB3_45:                               # %for_loop232.lr.ph.us.new
                                        #   in Loop: Header=BB3_24 Depth=1
	movq	%r9, %rbx
	xorl	%edx, %edx
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB3_46:                               # %for_loop232.us
                                        #   Parent Loop BB3_24 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-16(%rbx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-32(%rbx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-48(%rbx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	-64(%rbx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm13
	vpmuludq	%ymm4, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm10, %ymm10
	leal	(%rdi,%rdx), %ecx
	shlq	$7, %rcx
	vpaddq	12928(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	%ymm13, %ymm8, %ymm8
	vpaddq	12960(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	%ymm12, %ymm9, %ymm9
	vpaddq	12992(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	13024(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	%ymm10, %ymm6, %ymm6
	vpblendd	$170, %ymm1, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm9, %ymm11 # ymm11 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm13 # ymm13 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vmovdqa	%ymm13, 13024(%rsp,%rcx)
	vmovdqa	%ymm12, 12992(%rsp,%rcx)
	vmovdqa	%ymm11, 12960(%rsp,%rcx)
	vmovdqa	%ymm10, 12928(%rsp,%rcx)
	vpsrlq	$32, %ymm8, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm9, %ymm9
	vpmovzxdq	(%rbx), %ymm10  # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	32(%rbx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	48(%rbx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	16(%rbx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm4, %ymm13, %ymm13
	vpmuludq	%ymm2, %ymm12, %ymm12
	vpmuludq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm5, %ymm10, %ymm10
	leal	(%rsi,%rdx), %ecx
	shlq	$7, %rcx
	vpaddq	12960(%rsp,%rcx), %ymm9, %ymm9
	vpaddq	13024(%rsp,%rcx), %ymm6, %ymm6
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm12, %ymm6, %ymm6
	vpaddq	12992(%rsp,%rcx), %ymm7, %ymm7
	vpaddq	%ymm11, %ymm7, %ymm7
	vpaddq	12928(%rsp,%rcx), %ymm8, %ymm8
	vpaddq	%ymm10, %ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm9, %ymm10 # ymm10 = ymm9[0],ymm1[1],ymm9[2],ymm1[3],ymm9[4],ymm1[5],ymm9[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm6, %ymm11 # ymm11 = ymm6[0],ymm1[1],ymm6[2],ymm1[3],ymm6[4],ymm1[5],ymm6[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm7, %ymm12 # ymm12 = ymm7[0],ymm1[1],ymm7[2],ymm1[3],ymm7[4],ymm1[5],ymm7[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm8, %ymm13 # ymm13 = ymm8[0],ymm1[1],ymm8[2],ymm1[3],ymm8[4],ymm1[5],ymm8[6],ymm1[7]
	vmovdqa	%ymm13, 12928(%rsp,%rcx)
	vmovdqa	%ymm12, 12992(%rsp,%rcx)
	vmovdqa	%ymm11, 13024(%rsp,%rcx)
	vmovdqa	%ymm10, 12960(%rsp,%rcx)
	vpsrlq	$32, %ymm6, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpsrlq	$32, %ymm9, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	addq	$2, %rdx
	subq	$-128, %rbx
	cmpl	%edx, %r11d
	jne	.LBB3_46
# %bb.47:                               # %for_test230.for_exit233_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_24 Depth=1
	testb	$1, %r8b
	je	.LBB3_49
.LBB3_48:                               # %for_loop232.us.epil.preheader
                                        #   in Loop: Header=BB3_24 Depth=1
	movq	%rdx, %rcx
	shlq	$6, %rcx
	vpmovzxdq	8880(%rsp,%rcx), %ymm10 # ymm10 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8864(%rsp,%rcx), %ymm11 # ymm11 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8848(%rsp,%rcx), %ymm12 # ymm12 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmovzxdq	8832(%rsp,%rcx), %ymm13 # ymm13 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero
	vpmuludq	%ymm5, %ymm13, %ymm5
	vpmuludq	%ymm4, %ymm12, %ymm4
	vpmuludq	%ymm3, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm10, %ymm2
	addl	%edi, %edx
	shlq	$7, %rdx
	vpaddq	12928(%rsp,%rdx), %ymm8, %ymm8
	vpaddq	12960(%rsp,%rdx), %ymm9, %ymm9
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm9, %ymm4
	vpaddq	12992(%rsp,%rdx), %ymm7, %ymm7
	vpaddq	%ymm3, %ymm7, %ymm3
	vpaddq	13024(%rsp,%rdx), %ymm6, %ymm6
	vpaddq	%ymm2, %ymm6, %ymm2
	vpblendd	$170, %ymm1, %ymm5, %ymm6 # ymm6 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm7 # ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm8 # ymm8 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm9 # ymm9 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm9, 13024(%rsp,%rdx)
	vmovdqa	%ymm8, 12992(%rsp,%rdx)
	vmovdqa	%ymm7, 12960(%rsp,%rdx)
	vmovdqa	%ymm6, 12928(%rsp,%rdx)
	vpsrlq	$32, %ymm2, %ymm6
	vpsrlq	$32, %ymm3, %ymm7
	vpsrlq	$32, %ymm4, %ymm9
	vpsrlq	$32, %ymm5, %ymm8
.LBB3_49:                               # %for_exit233.us
                                        #   in Loop: Header=BB3_24 Depth=1
	vmovdqa	%ymm9, 672(%rsp,%rax)
	vmovdqa	%ymm8, 640(%rsp,%rax)
	vmovdqa	%ymm7, 704(%rsp,%rax)
	vmovdqa	%ymm6, 736(%rsp,%rax)
	addq	$1, %rdi
	addq	$1, %rsi
	cmpq	%r10, %rdi
	jne	.LBB3_24
# %bb.50:                               # %for_test263.preheader
	testl	%r8d, %r8d
	je	.LBB3_16
# %bb.51:                               # %for_loop265.lr.ph
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	$1, %r8d
	jne	.LBB3_55
# %bb.52:
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB3_58
.LBB3_16:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB3_60
.LBB3_55:                               # %for_loop265.lr.ph.new
	leaq	768(%rsp), %rdx
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%esi, %esi
	movabsq	$8589934592, %rdi       # imm = 0x200000000
	movl	%r8d, %ebx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_56:                               # %for_loop265
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rcx
	sarq	$25, %rcx
	vpaddq	704(%rsp,%rcx), %ymm2, %ymm2
	vpaddq	672(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	640(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	736(%rsp,%rcx), %ymm3, %ymm3
	movl	%ebx, %ecx
	shlq	$7, %rcx
	vpaddq	13024(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	12928(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	12960(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	12992(%rsp,%rcx), %ymm2, %ymm2
	vpblendd	$170, %ymm1, %ymm2, %ymm6 # ymm6 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm4, %ymm8 # ymm8 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm9, -32(%rdx)
	vmovdqa	%ymm8, -128(%rdx)
	vmovdqa	%ymm7, -96(%rdx)
	vmovdqa	%ymm6, -64(%rdx)
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	leaq	(%rsi,%r14), %rcx
	sarq	$25, %rcx
	vpaddq	736(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	640(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	672(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	704(%rsp,%rcx), %ymm2, %ymm2
	leal	1(%rbx), %ecx
	shlq	$7, %rcx
	vpaddq	12992(%rsp,%rcx), %ymm2, %ymm2
	vpaddq	12960(%rsp,%rcx), %ymm5, %ymm5
	vpaddq	12928(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	13024(%rsp,%rcx), %ymm3, %ymm3
	vpblendd	$170, %ymm1, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm1[1],ymm4[2],ymm1[3],ymm4[4],ymm1[5],ymm4[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm1[1],ymm5[2],ymm1[3],ymm5[4],ymm1[5],ymm5[6],ymm1[7]
	vpblendd	$170, %ymm1, %ymm2, %ymm8 # ymm8 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
	vmovdqa	%ymm8, 64(%rdx)
	vmovdqa	%ymm7, 32(%rdx)
	vmovdqa	%ymm6, (%rdx)
	vpblendd	$170, %ymm1, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm1[1],ymm3[2],ymm1[3],ymm3[4],ymm1[5],ymm3[6],ymm1[7]
	vmovdqa	%ymm6, 96(%rdx)
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm5, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	addq	$2, %rax
	addl	$2, %ebx
	addq	$256, %rdx              # imm = 0x100
	addq	%rdi, %rsi
	cmpl	%eax, %r11d
	jne	.LBB3_56
# %bb.57:                               # %for_test263.for_exit266_crit_edge.unr-lcssa
	testl	%r15d, %r15d
	je	.LBB3_59
.LBB3_58:                               # %for_loop265.epil.preheader
	movslq	%eax, %rcx
	movq	%rcx, %rdx
	shlq	$7, %rdx
	vpaddq	640(%rsp,%rdx), %ymm4, %ymm1
	vpaddq	672(%rsp,%rdx), %ymm5, %ymm4
	vpaddq	704(%rsp,%rdx), %ymm2, %ymm2
	vpaddq	736(%rsp,%rdx), %ymm3, %ymm3
	addl	%r8d, %ecx
	shlq	$7, %rcx
	vpaddq	13024(%rsp,%rcx), %ymm3, %ymm3
	vpaddq	12992(%rsp,%rcx), %ymm2, %ymm2
	vpaddq	12960(%rsp,%rcx), %ymm4, %ymm4
	vpaddq	12928(%rsp,%rcx), %ymm1, %ymm1
	shlq	$7, %rax
	vpblendd	$170, %ymm0, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm0[1],ymm4[2],ymm0[3],ymm4[4],ymm0[5],ymm4[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm2, %ymm7 # ymm7 = ymm2[0],ymm0[1],ymm2[2],ymm0[3],ymm2[4],ymm0[5],ymm2[6],ymm0[7]
	vpblendd	$170, %ymm0, %ymm3, %ymm0 # ymm0 = ymm3[0],ymm0[1],ymm3[2],ymm0[3],ymm3[4],ymm0[5],ymm3[6],ymm0[7]
	vmovdqa	%ymm0, 736(%rsp,%rax)
	vmovdqa	%ymm7, 704(%rsp,%rax)
	vmovdqa	%ymm6, 672(%rsp,%rax)
	vmovdqa	%ymm5, 640(%rsp,%rax)
	vpsrlq	$32, %ymm3, %ymm3
	vpsrlq	$32, %ymm2, %ymm2
	vpsrlq	$32, %ymm4, %ymm5
	vpsrlq	$32, %ymm1, %ymm4
.LBB3_59:                               # %for_test263.for_exit266_crit_edge
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
.LBB3_60:                               # %for_exit266
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm5, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_64
# %bb.61:                               # %for_exit266
	testl	%r8d, %r8d
	je	.LBB3_64
# %bb.62:                               # %for_loop300.lr.ph
	movq	104(%rsp), %rcx         # 8-byte Reload
	vmovd	%ecx, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movl	$32, %eax
	subl	%ecx, %eax
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovaps	.LCPI3_3(%rip), %ymm2   # ymm2 = [0,0,1,1,2,2,3,3]
	vpermps	%ymm4, %ymm2, %ymm3
	vmovaps	%ymm3, 160(%rsp)        # 32-byte Spill
	vmovdqa	.LCPI3_4(%rip), %ymm6   # ymm6 = [4,4,5,5,6,6,7,7]
	vpermd	%ymm4, %ymm6, %ymm3
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vpermps	%ymm5, %ymm2, %ymm2
	vmovaps	%ymm2, 224(%rsp)        # 32-byte Spill
	vpermd	%ymm5, %ymm6, %ymm2
	vmovdqa	%ymm2, 192(%rsp)        # 32-byte Spill
	movl	%r8d, %eax
	shlq	$7, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB3_63:                               # %for_loop300
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa	640(%rsp,%rcx), %ymm15
	vmovdqa	672(%rsp,%rcx), %ymm2
	movq	%rdx, %rsi
	sarq	$26, %rsi
	vmovdqa	8832(%rsp,%rsi), %ymm13
	vmovdqa	8864(%rsp,%rsi), %ymm14
	vpsllvd	%ymm0, %ymm13, %ymm3
	vpor	%ymm12, %ymm3, %ymm3
	vpsllvd	%ymm0, %ymm14, %ymm12
	vpor	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm3, %xmm4
	vpmovzxdq	%xmm4, %ymm4    # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero
	vpsubq	%ymm4, %ymm2, %ymm4
	vpaddq	%ymm10, %ymm4, %ymm4
	vmovdqa	704(%rsp,%rcx), %ymm10
	vpmovzxdq	%xmm3, %ymm3    # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
	vpsubq	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm9, %ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm9 # ymm9 = ymm3[0],ymm6[1],ymm3[2],ymm6[3],ymm3[4],ymm6[5],ymm3[6],ymm6[7]
	vmovapd	160(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm9, %ymm15, %ymm9
	vpblendd	$170, %ymm6, %ymm4, %ymm12 # ymm12 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7]
	vmovapd	128(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm2, %ymm2
	vpmovzxdq	%xmm11, %ymm12  # ymm12 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero
	vpsubq	%ymm12, %ymm10, %ymm12
	vpaddq	%ymm8, %ymm12, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm12 # ymm12 = ymm8[0],ymm6[1],ymm8[2],ymm6[3],ymm8[4],ymm6[5],ymm8[6],ymm6[7]
	vmovapd	224(%rsp), %ymm5        # 32-byte Reload
	vblendvpd	%ymm5, %ymm12, %ymm10, %ymm10
	vmovdqa	736(%rsp,%rcx), %ymm12
	vextracti128	$1, %ymm11, %xmm5
	vpmovzxdq	%xmm5, %ymm5    # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
	vpsubq	%ymm5, %ymm12, %ymm5
	vpaddq	%ymm7, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm6[1],ymm5[2],ymm6[3],ymm5[4],ymm6[5],ymm5[6],ymm6[7]
	vmovapd	192(%rsp), %ymm11       # 32-byte Reload
	vblendvpd	%ymm11, %ymm7, %ymm12, %ymm7
	vmovapd	%ymm7, 736(%rsp,%rcx)
	vmovapd	%ymm10, 704(%rsp,%rcx)
	vpsrlvd	%ymm1, %ymm14, %ymm11
	vpsrlvd	%ymm1, %ymm13, %ymm12
	vmovapd	%ymm2, 672(%rsp,%rcx)
	vmovapd	%ymm9, 640(%rsp,%rcx)
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
	addq	%r14, %rdx
	subq	$-128, %rcx
	cmpq	%rcx, %rax
	jne	.LBB3_63
.LBB3_64:                               # %safe_if_after_true
	leal	-1(%r8), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqq	736(%rsp,%rax), %ymm0, %ymm1
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm3
	vpcmpeqq	704(%rsp,%rax), %ymm0, %ymm4
	vpackssdw	%xmm3, %xmm1, %xmm1
	vpxor	%ymm2, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vinserti128	$1, %xmm1, %ymm3, %ymm3
	vpcmpeqq	672(%rsp,%rax), %ymm0, %ymm1
	vpxor	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm4
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpcmpeqq	640(%rsp,%rax), %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm4
	vpackssdw	%xmm4, %xmm0, %xmm0
	vinserti128	$1, %xmm1, %ymm0, %ymm1
	vmovmskps	%ymm1, %eax
	vmovmskps	%ymm3, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	vmovaps	%ymm3, 160(%rsp)        # 32-byte Spill
	vmovaps	%ymm1, 128(%rsp)        # 32-byte Spill
	je	.LBB3_65
# %bb.68:                               # %for_test357.preheader
	movl	%r8d, %eax
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
	je	.LBB3_65
# %bb.69:                               # %for_loop359.preheader
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vbroadcastss	.LCPI3_5(%rip), %ymm11 # ymm11 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vpbroadcastd	.LCPI3_5(%rip), %ymm15 # ymm15 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	xorl	%eax, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	vmovdqa	%ymm15, %ymm9
	vmovdqa	%ymm15, %ymm10
	vmovaps	%ymm11, %ymm12
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	movq	96(%rsp), %rsi          # 8-byte Reload
	.p2align	4, 0x90
.LBB3_70:                               # %for_loop359
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	8832(%rsp,%rdx), %ymm9, %ymm13
	vpaddd	8864(%rsp,%rdx), %ymm10, %ymm14
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpmaxud	8864(%rsp,%rdx), %ymm14, %ymm9
	vpcmpeqd	%ymm9, %ymm14, %ymm9
	vpandn	%ymm15, %ymm9, %ymm10
	vpmaxud	8832(%rsp,%rdx), %ymm13, %ymm9
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
	vpcmpeqq	672(%rsp,%rcx), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	640(%rsp,%rcx), %ymm12, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm3, %ymm4, %ymm3
	vpcmpeqq	736(%rsp,%rcx), %ymm2, %ymm2
	vextracti128	$1, %ymm2, %xmm4
	vpackssdw	%xmm4, %xmm2, %xmm2
	vpcmpeqq	704(%rsp,%rcx), %ymm11, %ymm4
	vextracti128	$1, %ymm4, %xmm7
	vpackssdw	%xmm7, %xmm4, %xmm4
	vinserti128	$1, %xmm2, %ymm4, %ymm2
	vpandn	%ymm5, %ymm2, %ymm2
	vpandn	%ymm6, %ymm3, %ymm3
	vblendvps	%ymm3, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r8d, %eax
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
	jne	.LBB3_70
	jmp	.LBB3_66
.LBB3_65:
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	movq	96(%rsp), %rsi          # 8-byte Reload
.LBB3_66:                               # %safe_if_after_true349
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vpxor	128(%rsp), %ymm2, %ymm4 # 32-byte Folded Reload
	vpxor	160(%rsp), %ymm2, %ymm2 # 32-byte Folded Reload
	vmovmskps	%ymm4, %eax
	vmovmskps	%ymm2, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	je	.LBB3_67
# %bb.71:                               # %safe_if_run_false415
	vpbroadcastq	.LCPI3_6(%rip), %ymm3 # ymm3 = [1,1,1,1]
	vpcmpeqq	736(%rsp), %ymm3, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	704(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	672(%rsp), %ymm3, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	640(%rsp), %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm7
	vpackssdw	%xmm7, %xmm3, %xmm3
	vinserti128	$1, %xmm6, %ymm3, %ymm3
	vblendvps	%ymm4, %ymm3, %ymm0, %ymm0
	vblendvps	%ymm2, %ymm5, %ymm1, %ymm1
	xorl	%eax, %eax
	cmpl	$1, %r8d
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
	je	.LBB3_67
# %bb.72:                               # %for_loop427.preheader
	movl	$1, %eax
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB3_73:                               # %for_loop427
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	672(%rsp,%rcx), %ymm8, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm5
	vpcmpeqq	640(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpcmpeqq	736(%rsp,%rcx), %ymm8, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpackssdw	%xmm7, %xmm6, %xmm6
	vpcmpeqq	704(%rsp,%rcx), %ymm8, %ymm7
	vextracti128	$1, %ymm7, %xmm4
	vpackssdw	%xmm4, %xmm7, %xmm4
	vinserti128	$1, %xmm6, %ymm4, %ymm4
	vpandn	%ymm2, %ymm4, %ymm4
	vpandn	%ymm3, %ymm5, %ymm5
	vblendvps	%ymm5, %ymm8, %ymm0, %ymm0
	vblendvps	%ymm4, %ymm8, %ymm1, %ymm1
	addl	$1, %eax
	cmpl	%r8d, %eax
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
	jne	.LBB3_73
.LBB3_67:                               # %if_done348
	vbroadcastss	.LCPI3_5(%rip), %ymm2 # ymm2 = [1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45,1.40129846E-45]
	vandps	%ymm2, %ymm1, %ymm1
	vandps	%ymm2, %ymm0, %ymm0
	vmovups	%ymm0, (%rsi)
	vmovups	%ymm1, 32(%rsi)
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
