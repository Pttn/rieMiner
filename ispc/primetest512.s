	.text
	.file	"primetest.ispc"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
.LCPI0_0:
	.quad	4294967295              # 0xffffffff
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
	je	.LBB0_3
# %bb.1:                                # %for_loop.lr.ph
	vpbroadcastq	.LCPI0_0(%rip), %zmm0 # zmm0 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandd	64(%rsi), %zmm0, %zmm1
	vpandd	(%rsi), %zmm0, %zmm2
	leal	-2(%rdx), %r15d
	movl	%r8d, %eax
	andl	$3, %eax
	cmpl	$3, %r15d
	vpsrlq	$32, %zmm1, %zmm3
	vpsrlq	$32, %zmm2, %zmm4
	jae	.LBB0_4
# %bb.2:
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%ebx, %ebx
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.LBB0_6
.LBB0_3:                                # %for_exit24.thread
	movl	%r8d, %eax
	shlq	$7, %rax
	vpxor	%xmm3, %xmm3, %xmm3
	vmovdqa64	%zmm3, 192(%rsp,%rax)
	vmovdqa64	%zmm3, 128(%rsp,%rax)
	vmovdqu64	(%rsi), %zmm0
	vmovdqu64	64(%rsi), %zmm1
	vpmuludq	%zmm1, %zmm1, %zmm1
	vpbroadcastq	.LCPI0_0(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpmuludq	%zmm0, %zmm0, %zmm2
	vpandd	%zmm4, %zmm1, %zmm0
	vmovdqu64	%zmm0, 64(%rdi)
	vpandd	%zmm4, %zmm2, %zmm0
	vmovdqu64	%zmm0, (%rdi)
	jmp	.LBB0_21
.LBB0_4:                                # %for_loop.lr.ph.new
	movl	%r8d, %r9d
	subl	%eax, %r9d
	vpxor	%xmm5, %xmm5, %xmm5
	movl	$384, %ecx              # imm = 0x180
	xorl	%ebx, %ebx
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB0_5:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-256(%rsi,%rcx), %zmm7
	vmovdqu64	-192(%rsi,%rcx), %zmm8
	vpmuludq	%zmm8, %zmm1, %zmm9
	vpaddq	%zmm6, %zmm9, %zmm6
	vpmuludq	%zmm8, %zmm3, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	vpaddq	%zmm6, %zmm8, %zmm6
	vpmuludq	%zmm7, %zmm2, %zmm8
	vpaddq	%zmm5, %zmm8, %zmm5
	vpmuludq	%zmm7, %zmm4, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vpandd	%zmm0, %zmm5, %zmm7
	vmovdqa64	%zmm7, -256(%rsp,%rcx)
	vpandd	%zmm0, %zmm6, %zmm7
	vmovdqa64	%zmm7, -192(%rsp,%rcx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm6, %zmm6
	vmovdqu64	-128(%rsi,%rcx), %zmm7
	vmovdqu64	-64(%rsi,%rcx), %zmm8
	vpmuludq	%zmm7, %zmm2, %zmm9
	vpmuludq	%zmm7, %zmm4, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm9, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vpmuludq	%zmm8, %zmm1, %zmm7
	vpmuludq	%zmm8, %zmm3, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	vpaddq	%zmm8, %zmm7, %zmm7
	vpaddq	%zmm6, %zmm7, %zmm6
	vpandd	%zmm0, %zmm6, %zmm7
	vmovdqa64	%zmm7, -64(%rsp,%rcx)
	vpandd	%zmm0, %zmm5, %zmm7
	vmovdqa64	%zmm7, -128(%rsp,%rcx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm6, %zmm6
	vmovdqu64	(%rsi,%rcx), %zmm7
	vmovdqu64	64(%rsi,%rcx), %zmm8
	vpmuludq	%zmm7, %zmm2, %zmm9
	vpmuludq	%zmm7, %zmm4, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm9, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vpmuludq	%zmm8, %zmm1, %zmm7
	vpmuludq	%zmm8, %zmm3, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	vpaddq	%zmm8, %zmm7, %zmm7
	vpaddq	%zmm6, %zmm7, %zmm6
	vpandd	%zmm0, %zmm6, %zmm7
	vmovdqa64	%zmm7, 64(%rsp,%rcx)
	vpandd	%zmm0, %zmm5, %zmm7
	vmovdqa64	%zmm7, (%rsp,%rcx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm6, %zmm6
	addq	$4, %rbx
	vmovdqu64	128(%rsi,%rcx), %zmm7
	vmovdqu64	192(%rsi,%rcx), %zmm8
	vpmuludq	%zmm7, %zmm2, %zmm9
	vpmuludq	%zmm7, %zmm4, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm9, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vpmuludq	%zmm8, %zmm1, %zmm7
	vpmuludq	%zmm8, %zmm3, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	vpaddq	%zmm8, %zmm7, %zmm7
	vpaddq	%zmm6, %zmm7, %zmm6
	vpandd	%zmm0, %zmm5, %zmm7
	vpandd	%zmm0, %zmm6, %zmm8
	vmovdqa64	%zmm8, 192(%rsp,%rcx)
	vmovdqa64	%zmm7, 128(%rsp,%rcx)
	vpsrlq	$32, %zmm6, %zmm6
	vpsrlq	$32, %zmm5, %zmm5
	addq	$512, %rcx              # imm = 0x200
	cmpl	%ebx, %r9d
	jne	.LBB0_5
.LBB0_6:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%eax, %eax
	je	.LBB0_9
# %bb.7:                                # %for_loop.epil.preheader
	shlq	$7, %rbx
	.p2align	4, 0x90
.LBB0_8:                                # %for_loop.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	128(%rsi,%rbx), %zmm7
	vmovdqu64	192(%rsi,%rbx), %zmm8
	vpmuludq	%zmm8, %zmm1, %zmm9
	vpaddq	%zmm6, %zmm9, %zmm6
	vpmuludq	%zmm8, %zmm3, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	vpaddq	%zmm6, %zmm8, %zmm6
	vpmuludq	%zmm7, %zmm2, %zmm8
	vpaddq	%zmm5, %zmm8, %zmm5
	vpmuludq	%zmm7, %zmm4, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vpandd	%zmm0, %zmm6, %zmm7
	vpandd	%zmm0, %zmm5, %zmm8
	vmovdqa64	%zmm8, 128(%rsp,%rbx)
	vmovdqa64	%zmm7, 192(%rsp,%rbx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm6, %zmm6
	subq	$-128, %rbx
	addl	$-1, %eax
	jne	.LBB0_8
.LBB0_9:                                # %for_exit
	movl	%r8d, 108(%rsp)         # 4-byte Spill
	movl	%r8d, %r9d
	movq	%r9, %rax
	shlq	$7, %rax
	vmovdqa64	%zmm6, 192(%rsp,%rax)
	vmovdqa64	%zmm5, 128(%rsp,%rax)
	cmpl	$3, %edx
	jb	.LBB0_17
# %bb.10:                               # %for_test30.preheader.lr.ph
	leal	-3(%rdx), %r14d
	movl	%edx, %eax
	movq	%rax, 120(%rsp)         # 8-byte Spill
	leaq	128(%rsi), %rax
	movq	%rax, 112(%rsp)         # 8-byte Spill
	movl	$2, %r10d
	xorl	%r13d, %r13d
	jmp	.LBB0_12
	.p2align	4, 0x90
.LBB0_11:                               # %for_exit33
                                        #   in Loop: Header=BB0_12 Depth=1
	addl	%edx, %r12d
	shlq	$7, %r12
	vmovdqa64	%zmm6, 192(%rsp,%r12)
	vmovdqa64	%zmm5, 128(%rsp,%r12)
	addq	$1, %r10
	addq	$1, %r13
	cmpl	%r15d, %r13d
	je	.LBB0_17
.LBB0_12:                               # %for_loop31.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_16 Depth 2
	movl	%r15d, %ebx
	subl	%r13d, %ebx
	movq	%r10, %rax
	shlq	$7, %rax
	vpandd	-64(%rax,%rsi), %zmm0, %zmm1
	vpandd	-128(%rax,%rsi), %zmm0, %zmm2
	leaq	-2(%r10), %r12
	vpxor	%xmm5, %xmm5, %xmm5
	testb	$1, %bl
	vpsrlq	$32, %zmm2, %zmm3
	vpsrlq	$32, %zmm1, %zmm4
	movq	%r10, %rbx
	vpxor	%xmm6, %xmm6, %xmm6
	je	.LBB0_14
# %bb.13:                               # %for_loop31.prol.preheader
                                        #   in Loop: Header=BB0_12 Depth=1
	vmovdqu64	(%rsi,%rax), %zmm5
	vmovdqu64	64(%rsi,%rax), %zmm6
	vpmuludq	%zmm6, %zmm1, %zmm7
	vpmuludq	%zmm6, %zmm4, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm6, %zmm7, %zmm6
	vpmuludq	%zmm5, %zmm2, %zmm7
	vpmuludq	%zmm5, %zmm3, %zmm5
	vpsllq	$32, %zmm5, %zmm5
	vpaddq	%zmm5, %zmm7, %zmm5
	leal	(%r12,%r10), %eax
	shlq	$7, %rax
	vpaddq	128(%rsp,%rax), %zmm5, %zmm5
	vpaddq	192(%rsp,%rax), %zmm6, %zmm6
	vpandd	%zmm0, %zmm6, %zmm7
	vpandd	%zmm0, %zmm5, %zmm8
	vmovdqa64	%zmm8, 128(%rsp,%rax)
	vmovdqa64	%zmm7, 192(%rsp,%rax)
	vpsrlq	$32, %zmm6, %zmm6
	vpsrlq	$32, %zmm5, %zmm5
	leaq	1(%r10), %rbx
.LBB0_14:                               # %for_loop31.prol.loopexit.unr-lcssa
                                        #   in Loop: Header=BB0_12 Depth=1
	cmpl	%r13d, %r14d
	je	.LBB0_11
# %bb.15:                               # %for_loop31.preheader
                                        #   in Loop: Header=BB0_12 Depth=1
	movq	120(%rsp), %rax         # 8-byte Reload
	subq	%rbx, %rax
	leaq	(%rbx,%r13), %r8
	shlq	$7, %rbx
	addq	112(%rsp), %rbx         # 8-byte Folded Reload
	.p2align	4, 0x90
.LBB0_16:                               # %for_loop31
                                        #   Parent Loop BB0_12 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu64	-128(%rbx), %zmm7
	vmovdqu64	-64(%rbx), %zmm8
	vpmuludq	%zmm7, %zmm2, %zmm9
	vpmuludq	%zmm7, %zmm3, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpmuludq	%zmm8, %zmm1, %zmm10
	vpmuludq	%zmm8, %zmm4, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	movl	%r8d, %r11d
	shlq	$7, %r11
	vpaddq	128(%rsp,%r11), %zmm5, %zmm5
	vpaddq	%zmm5, %zmm9, %zmm5
	vpaddq	%zmm5, %zmm7, %zmm5
	vpaddq	192(%rsp,%r11), %zmm6, %zmm6
	vpaddq	%zmm6, %zmm10, %zmm6
	vpaddq	%zmm6, %zmm8, %zmm6
	vpandd	%zmm0, %zmm5, %zmm7
	vpandd	%zmm0, %zmm6, %zmm8
	vmovdqa64	%zmm8, 192(%rsp,%r11)
	vmovdqa64	%zmm7, 128(%rsp,%r11)
	vpsrlq	$32, %zmm6, %zmm6
	vpsrlq	$32, %zmm5, %zmm5
	vmovdqu64	(%rbx), %zmm7
	vmovdqu64	64(%rbx), %zmm8
	vpmuludq	%zmm7, %zmm2, %zmm9
	vpmuludq	%zmm7, %zmm3, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm9, %zmm7
	vpmuludq	%zmm8, %zmm1, %zmm9
	vpmuludq	%zmm8, %zmm4, %zmm8
	vpsllq	$32, %zmm8, %zmm8
	leal	1(%r8), %ecx
	shlq	$7, %rcx
	vpaddq	128(%rsp,%rcx), %zmm5, %zmm5
	vpaddq	%zmm8, %zmm9, %zmm8
	vpaddq	%zmm7, %zmm5, %zmm5
	vpaddq	192(%rsp,%rcx), %zmm6, %zmm6
	vpaddq	%zmm8, %zmm6, %zmm6
	vpandd	%zmm0, %zmm6, %zmm7
	vmovdqa64	%zmm7, 192(%rsp,%rcx)
	vpandd	%zmm0, %zmm5, %zmm7
	vmovdqa64	%zmm7, 128(%rsp,%rcx)
	vpsrlq	$32, %zmm6, %zmm6
	vpsrlq	$32, %zmm5, %zmm5
	addq	$2, %r8
	addq	$256, %rbx              # imm = 0x100
	addq	$-2, %rax
	jne	.LBB0_16
	jmp	.LBB0_11
.LBB0_17:                               # %for_exit24
	cmpl	$0, 108(%rsp)           # 4-byte Folded Reload
	vmovdqu64	(%rsi), %zmm2
	vmovdqu64	64(%rsi), %zmm1
	vpmuludq	%zmm1, %zmm1, %zmm1
	vpmuludq	%zmm2, %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqu64	%zmm4, 64(%rdi)
	vmovdqu64	%zmm3, (%rdi)
	je	.LBB0_20
# %bb.18:                               # %for_loop88.preheader
	addq	%r9, %r9
	subq	$-128, %rsi
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB0_19:                               # %for_loop88
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa64	128(%rsp,%rcx), %zmm5
	vmovdqa64	192(%rsp,%rcx), %zmm6
	vpsrlq	$32, %zmm1, %zmm1
	vpaddq	%zmm4, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	%zmm3, %zmm2, %zmm2
	vpmovqd	%zmm6, %ymm3
	vpmovqd	%zmm5, %ymm4
	vpaddd	%ymm4, %ymm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpaddq	%zmm4, %zmm2, %zmm2
	vpaddd	%ymm3, %ymm3, %ymm3
	vpmovzxdq	%ymm3, %zmm3    # zmm3 = ymm3[0],zero,ymm3[1],zero,ymm3[2],zero,ymm3[3],zero,ymm3[4],zero,ymm3[5],zero,ymm3[6],zero,ymm3[7],zero
	vpaddq	%zmm3, %zmm1, %zmm1
	leal	1(%rax), %ecx
	shlq	$7, %rcx
	vpandd	%zmm0, %zmm1, %zmm3
	vmovdqu64	%zmm3, 64(%rdi,%rcx)
	vpandd	%zmm0, %zmm2, %zmm3
	vmovdqu64	%zmm3, (%rdi,%rcx)
	vpsrlq	$31, %zmm5, %zmm3
	vpsrlq	$31, %zmm6, %zmm4
	vpsrlq	$32, %zmm1, %zmm5
	vpsrlq	$32, %zmm2, %zmm6
	vmovdqu64	(%rsi), %zmm2
	vmovdqu64	64(%rsi), %zmm1
	vpmuludq	%zmm1, %zmm1, %zmm1
	vpmuludq	%zmm2, %zmm2, %zmm2
	vmovdqa64	128(%rsp,%rcx), %zmm7
	vmovdqa64	192(%rsp,%rcx), %zmm8
	vpandd	%zmm0, %zmm2, %zmm9
	vpaddq	%zmm3, %zmm9, %zmm3
	vpandd	%zmm0, %zmm1, %zmm9
	vpaddq	%zmm4, %zmm9, %zmm4
	vpmovqd	%zmm8, %ymm9
	vpmovqd	%zmm7, %ymm10
	vpaddd	%ymm10, %ymm10, %ymm10
	vpmovzxdq	%ymm10, %zmm10  # zmm10 = ymm10[0],zero,ymm10[1],zero,ymm10[2],zero,ymm10[3],zero,ymm10[4],zero,ymm10[5],zero,ymm10[6],zero,ymm10[7],zero
	vpaddq	%zmm10, %zmm3, %zmm3
	vpaddq	%zmm3, %zmm6, %zmm3
	vpaddd	%ymm9, %ymm9, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpaddq	%zmm6, %zmm4, %zmm4
	vpaddq	%zmm4, %zmm5, %zmm4
	addq	$2, %rax
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpandd	%zmm0, %zmm3, %zmm5
	vpandd	%zmm0, %zmm4, %zmm6
	vmovdqu64	%zmm6, 64(%rdi,%rcx)
	vmovdqu64	%zmm5, (%rdi,%rcx)
	vpsrlq	$31, %zmm7, %zmm5
	vpsrlq	$31, %zmm8, %zmm6
	vpsrlq	$32, %zmm3, %zmm3
	vpaddq	%zmm5, %zmm3, %zmm3
	vpsrlq	$32, %zmm4, %zmm4
	vpaddq	%zmm6, %zmm4, %zmm4
	subq	$-128, %rsi
	cmpq	%rax, %r9
	jne	.LBB0_19
	jmp	.LBB0_22
.LBB0_20:
	vpxor	%xmm3, %xmm3, %xmm3
.LBB0_21:                               # %for_exit90
	vpxor	%xmm4, %xmm4, %xmm4
.LBB0_22:                               # %for_exit90
	leal	(%rdx,%rdx), %eax
	addl	$-1, %eax
	shlq	$7, %rax
	vpsrlq	$32, %zmm1, %zmm0
	vpaddq	%zmm4, %zmm0, %zmm0
	vpsrlq	$32, %zmm2, %zmm1
	vpaddq	%zmm3, %zmm1, %zmm1
	vmovdqu64	%zmm0, 64(%rdi,%rax)
	vmovdqu64	%zmm1, (%rdi,%rax)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end0:
	.size	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu, .Lfunc_end0-squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
.LCPI1_0:
	.quad	4294967295              # 0xffffffff
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
	subq	$8704, %rsp             # imm = 0x2200
	movl	%edx, %r9d
	movq	%rsi, %r13
	movq	%rdi, %rbx
	movl	%edx, %r11d
	shrl	%r11d
	subl	%r11d, %edx
	movq	%rdx, %r15
	shlq	$7, %r15
	leaq	(%rsi,%r15), %r14
	cmpl	%edx, %r11d
	movq	%r9, 120(%rsp)          # 8-byte Spill
	jne	.LBB1_5
# %bb.1:                                # %for_test.i.preheader
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vmovdqu64	(%r13,%rax), %zmm0
	vmovdqu64	64(%r13,%rax), %zmm1
	vmovdqu64	(%r14,%rax), %zmm2
	vmovdqu64	64(%r14,%rax), %zmm3
	vpcmpltuq	%zmm2, %zmm0, %k0
	vpcmpltuq	%zmm3, %zmm1, %k1
	kunpckbw	%k0, %k1, %k2
	kortestw	%k2, %k2
	jb	.LBB1_15
# %bb.2:                                # %no_return.i.preheader
	leal	-2(%r11), %eax
	kxnorw	%k0, %k0, %k0
	kxnorw	%k0, %k0, %k1
	.p2align	4, 0x90
.LBB1_3:                                # %no_return.i
                                        # =>This Inner Loop Header: Depth=1
	vpcmpnleuq	%zmm2, %zmm0, %k3
	vpcmpnleuq	%zmm3, %zmm1, %k4
	kunpckbw	%k3, %k4, %k3
	kandw	%k1, %k3, %k3
	knotw	%k3, %k4
	korw	%k4, %k2, %k4
	kandw	%k0, %k4, %k0
	korw	%k3, %k2, %k2
	kortestw	%k2, %k2
	jb	.LBB1_16
# %bb.4:                                # %no_return47.i
                                        #   in Loop: Header=BB1_3 Depth=1
	kandnw	%k1, %k2, %k1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqu64	(%r13,%rcx), %zmm0
	vmovdqu64	64(%r13,%rcx), %zmm1
	vmovdqu64	(%r14,%rcx), %zmm2
	vmovdqu64	64(%r14,%rcx), %zmm3
	vpcmpltuq	%zmm2, %zmm0, %k3
	vpcmpltuq	%zmm3, %zmm1, %k4
	kunpckbw	%k3, %k4, %k3
	kandw	%k1, %k3, %k3
	korw	%k0, %k3, %k0
	korw	%k2, %k3, %k2
	addl	$-1, %eax
	kortestw	%k2, %k2
	jae	.LBB1_3
	jmp	.LBB1_16
.LBB1_5:                                # %if_else
	movl	%r11d, %r10d
	shlq	$7, %r10
	vmovdqu64	(%r13,%r10), %zmm0
	vmovdqu64	64(%r13,%r10), %zmm1
	vptestnmq	%zmm0, %zmm0, %k1
	vptestnmq	%zmm1, %zmm1, %k2
	kunpckbw	%k1, %k2, %k0
	kortestw	%k0, %k0
	je	.LBB1_11
# %bb.6:                                # %for_test.i345.preheader
	kunpckbw	%k1, %k2, %k0
	leal	-1(%r11), %ecx
	shlq	$7, %rcx
	vmovdqu64	(%r13,%rcx), %zmm2
	vmovdqu64	64(%r13,%rcx), %zmm3
	vmovdqu64	(%r14,%rcx), %zmm4
	vmovdqu64	64(%r14,%rcx), %zmm5
	vpcmpltuq	%zmm4, %zmm2, %k1
	vpcmpltuq	%zmm5, %zmm3, %k2
	kunpckbw	%k1, %k2, %k1
	kandw	%k0, %k1, %k2
	kmovw	%k0, %ecx
	kmovw	%k2, %esi
	kxnorw	%k0, %k0, %k1
	cmpw	%si, %cx
	je	.LBB1_10
# %bb.7:                                # %no_return.i357.preheader
	leal	-2(%r11), %eax
	kxnorw	%k0, %k0, %k1
	kxnorw	%k0, %k0, %k3
	.p2align	4, 0x90
.LBB1_8:                                # %no_return.i357
                                        # =>This Inner Loop Header: Depth=1
	vpcmpnleuq	%zmm4, %zmm2, %k4
	vpcmpnleuq	%zmm5, %zmm3, %k5
	kunpckbw	%k4, %k5, %k4
	kandw	%k3, %k4, %k4
	kandnw	%k4, %k2, %k4
	kandnw	%k1, %k4, %k1
	kandw	%k0, %k4, %k4
	korw	%k2, %k4, %k2
	kmovw	%k2, %esi
	cmpw	%si, %cx
	je	.LBB1_10
# %bb.9:                                # %no_return47.i360
                                        #   in Loop: Header=BB1_8 Depth=1
	kandnw	%k3, %k2, %k3
	movl	%eax, %esi
	shlq	$7, %rsi
	vmovdqu64	(%r13,%rsi), %zmm2
	vmovdqu64	64(%r13,%rsi), %zmm3
	vmovdqu64	(%r14,%rsi), %zmm4
	vmovdqu64	64(%r14,%rsi), %zmm5
	vpcmpltuq	%zmm4, %zmm2, %k4
	vpcmpltuq	%zmm5, %zmm3, %k5
	kunpckbw	%k4, %k5, %k4
	kandw	%k3, %k4, %k4
	korw	%k1, %k4, %k1
	kandw	%k0, %k4, %k4
	korw	%k2, %k4, %k2
	kmovw	%k2, %esi
	addl	$-1, %eax
	cmpw	%si, %cx
	jne	.LBB1_8
.LBB1_10:                               # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit361
	kandw	%k0, %k1, %k0
.LBB1_11:                               # %logical_op_done
	kortestw	%k0, %k0
	je	.LBB1_37
# %bb.12:                               # %for_test.i293.preheader
	testl	%r11d, %r11d
	kmovw	%k0, 240(%rsp)
	vmovdqa	240(%rsp), %xmm2
	vpextrb	$0, %xmm2, %ecx
	vpextrb	$1, %xmm2, %esi
	kmovw	%ecx, %k1
	kmovw	%esi, %k2
	je	.LBB1_36
# %bb.13:                               # %for_loop.i305.lr.ph
	cmpl	$1, %r11d
	jne	.LBB1_32
# %bb.14:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	jmp	.LBB1_35
.LBB1_15:
	kxnorw	%k0, %k0, %k0
.LBB1_16:                               # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	kortestw	%k0, %k0
	je	.LBB1_24
# %bb.17:                               # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	testl	%r11d, %r11d
	je	.LBB1_24
# %bb.18:                               # %for_loop.i377.lr.ph
	kmovw	%k0, 208(%rsp)
	vmovdqa	208(%rsp), %xmm0
	vpextrb	$0, %xmm0, %eax
	vpextrb	$1, %xmm0, %ecx
	kmovw	%eax, %k1
	kmovw	%ecx, %k2
	movl	%r11d, %ecx
	notl	%ecx
	movl	%r11d, %r8d
	andl	$1, %r8d
	addl	%r9d, %ecx
	jne	.LBB1_20
# %bb.19:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB1_22
.LBB1_20:                               # %for_loop.i377.lr.ph.new
	leaq	(%r15,%r13), %rax
	addq	$128, %rax
	movl	%r11d, %esi
	subl	%r8d, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edi, %edi
	vpbroadcastq	.LCPI1_0(%rip), %zmm1 # zmm1 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB1_21:                               # %for_loop.i377
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-64(%rax,%rdi), %zmm3
	vpsubq	64(%r13,%rdi), %zmm3, %zmm3
	vmovdqu64	-128(%rax,%rdi), %zmm4
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	(%r13,%rdi), %zmm4, %zmm3
	vpaddq	%zmm0, %zmm3, %zmm0
	vpandd	%zmm1, %zmm0, %zmm3
	vmovdqu64	%zmm3, (%rbx,%rdi) {%k1}
	vpandd	%zmm1, %zmm2, %zmm3
	vmovdqu64	%zmm3, 64(%rbx,%rdi) {%k2}
	vpsraq	$32, %zmm2, %zmm2
	vpsraq	$32, %zmm0, %zmm0
	vmovdqu64	64(%rax,%rdi), %zmm3
	vpsubq	192(%r13,%rdi), %zmm3, %zmm3
	vmovdqu64	(%rax,%rdi), %zmm4
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	128(%r13,%rdi), %zmm4, %zmm3
	vpaddq	%zmm0, %zmm3, %zmm0
	vpandd	%zmm1, %zmm0, %zmm3
	vmovdqu64	%zmm3, 128(%rbx,%rdi) {%k1}
	vpandd	%zmm1, %zmm2, %zmm3
	vmovdqu64	%zmm3, 192(%rbx,%rdi) {%k2}
	vpsraq	$32, %zmm2, %zmm2
	vpsraq	$32, %zmm0, %zmm0
	addq	$2, %rcx
	addq	$256, %rdi              # imm = 0x100
	cmpl	%ecx, %esi
	jne	.LBB1_21
.LBB1_22:                               # %for_test.i365.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_24
# %bb.23:                               # %for_loop.i377.epil.preheader
	shlq	$7, %rcx
	vmovdqu64	(%r14,%rcx), %zmm1
	vmovdqu64	64(%r14,%rcx), %zmm3
	vpsubq	64(%r13,%rcx), %zmm3, %zmm3
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	(%r13,%rcx), %zmm1, %zmm1
	vpaddq	%zmm0, %zmm1, %zmm0
	vpbroadcastq	.LCPI1_0(%rip), %zmm1 # zmm1 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandd	%zmm1, %zmm2, %zmm2
	vpandd	%zmm1, %zmm0, %zmm0
	vmovdqu64	%zmm0, (%rbx,%rcx) {%k1}
	vmovdqu64	%zmm2, 64(%rbx,%rcx) {%k2}
.LBB1_24:                               # %safe_if_after_true
	knotw	%k0, %k0
	kortestw	%k0, %k0
	je	.LBB1_48
# %bb.25:                               # %safe_if_after_true
	testl	%r11d, %r11d
	je	.LBB1_48
# %bb.26:                               # %for_loop.i326.lr.ph
	kmovw	%k0, 192(%rsp)
	vmovdqa	192(%rsp), %xmm0
	vpextrb	$0, %xmm0, %eax
	vpextrb	$1, %xmm0, %ecx
	kmovw	%eax, %k1
	kmovw	%ecx, %k2
	movl	%r11d, %ecx
	notl	%ecx
	movl	%r11d, %r8d
	andl	$1, %r8d
	addl	120(%rsp), %ecx         # 4-byte Folded Reload
	jne	.LBB1_28
# %bb.27:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB1_30
.LBB1_28:                               # %for_loop.i326.lr.ph.new
	leaq	(%r15,%r13), %rax
	addq	$128, %rax
	movl	%r11d, %esi
	subl	%r8d, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edi, %edi
	vpbroadcastq	.LCPI1_0(%rip), %zmm1 # zmm1 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB1_29:                               # %for_loop.i326
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	64(%r13,%rdi), %zmm3
	vpsubq	-64(%rax,%rdi), %zmm3, %zmm3
	vmovdqu64	(%r13,%rdi), %zmm4
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	-128(%rax,%rdi), %zmm4, %zmm3
	vpaddq	%zmm0, %zmm3, %zmm0
	vpandd	%zmm1, %zmm0, %zmm3
	vmovdqu64	%zmm3, (%rbx,%rdi) {%k1}
	vpandd	%zmm1, %zmm2, %zmm3
	vmovdqu64	%zmm3, 64(%rbx,%rdi) {%k2}
	vpsraq	$32, %zmm2, %zmm2
	vpsraq	$32, %zmm0, %zmm0
	vmovdqu64	192(%r13,%rdi), %zmm3
	vpsubq	64(%rax,%rdi), %zmm3, %zmm3
	vmovdqu64	128(%r13,%rdi), %zmm4
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	(%rax,%rdi), %zmm4, %zmm3
	vpaddq	%zmm0, %zmm3, %zmm0
	vpandd	%zmm1, %zmm0, %zmm3
	vmovdqu64	%zmm3, 128(%rbx,%rdi) {%k1}
	vpandd	%zmm1, %zmm2, %zmm3
	vmovdqu64	%zmm3, 192(%rbx,%rdi) {%k2}
	vpsraq	$32, %zmm2, %zmm2
	vpsraq	$32, %zmm0, %zmm0
	addq	$2, %rcx
	addq	$256, %rdi              # imm = 0x100
	cmpl	%ecx, %esi
	jne	.LBB1_29
.LBB1_30:                               # %for_test.i314.if_exit.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_48
# %bb.31:                               # %for_loop.i326.epil.preheader
	shlq	$7, %rcx
	vmovdqu64	(%r13,%rcx), %zmm1
	vmovdqu64	64(%r13,%rcx), %zmm3
	vpsubq	64(%r14,%rcx), %zmm3, %zmm3
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	(%r14,%rcx), %zmm1, %zmm1
	vpaddq	%zmm0, %zmm1, %zmm0
	vpbroadcastq	.LCPI1_0(%rip), %zmm1 # zmm1 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandd	%zmm1, %zmm2, %zmm2
	vpandd	%zmm1, %zmm0, %zmm0
	vmovdqu64	%zmm0, (%rbx,%rcx) {%k1}
	vmovdqu64	%zmm2, 64(%rbx,%rcx) {%k2}
	jmp	.LBB1_48
.LBB1_32:                               # %for_loop.i305.lr.ph.new
	movl	%r11d, %r8d
	andl	$1, %r8d
	leaq	(%r15,%r13), %rsi
	addq	$128, %rsi
	movl	%r11d, %edi
	subl	%r8d, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vpbroadcastq	.LCPI1_0(%rip), %zmm3 # zmm3 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	xorl	%ecx, %ecx
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB1_33:                               # %for_loop.i305
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-64(%rsi,%rax), %zmm5
	vpsubq	64(%r13,%rax), %zmm5, %zmm5
	vmovdqu64	-128(%rsi,%rax), %zmm6
	vpaddq	%zmm4, %zmm5, %zmm4
	vpsubq	(%r13,%rax), %zmm6, %zmm5
	vpaddq	%zmm2, %zmm5, %zmm2
	vpandd	%zmm3, %zmm2, %zmm5
	vmovdqu64	%zmm5, (%rbx,%rax) {%k1}
	vpandd	%zmm3, %zmm4, %zmm5
	vmovdqu64	%zmm5, 64(%rbx,%rax) {%k2}
	vpsraq	$32, %zmm4, %zmm4
	vpsraq	$32, %zmm2, %zmm2
	vmovdqu64	64(%rsi,%rax), %zmm5
	vpsubq	192(%r13,%rax), %zmm5, %zmm5
	vmovdqu64	(%rsi,%rax), %zmm6
	vpaddq	%zmm4, %zmm5, %zmm4
	vpsubq	128(%r13,%rax), %zmm6, %zmm5
	vpaddq	%zmm2, %zmm5, %zmm2
	vpandd	%zmm3, %zmm2, %zmm5
	vmovdqu64	%zmm5, 128(%rbx,%rax) {%k1}
	vpandd	%zmm3, %zmm4, %zmm5
	vmovdqu64	%zmm5, 192(%rbx,%rax) {%k2}
	vpsraq	$32, %zmm4, %zmm4
	vpsraq	$32, %zmm2, %zmm2
	addq	$2, %rcx
	addq	$256, %rax              # imm = 0x100
	cmpl	%ecx, %edi
	jne	.LBB1_33
# %bb.34:                               # %for_test.i293.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit306_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB1_36
.LBB1_35:                               # %for_loop.i305.epil.preheader
	shlq	$7, %rcx
	vmovdqu64	(%r14,%rcx), %zmm3
	vmovdqu64	64(%r14,%rcx), %zmm5
	vpsubq	64(%r13,%rcx), %zmm5, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm4
	vpsubq	(%r13,%rcx), %zmm3, %zmm3
	vpaddq	%zmm2, %zmm3, %zmm2
	vpbroadcastq	.LCPI1_0(%rip), %zmm3 # zmm3 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandd	%zmm3, %zmm4, %zmm4
	vpandd	%zmm3, %zmm2, %zmm2
	vmovdqu64	%zmm2, (%rbx,%rcx) {%k1}
	vmovdqu64	%zmm4, 64(%rbx,%rcx) {%k2}
.LBB1_36:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit306
	vpxor	%xmm2, %xmm2, %xmm2
	vmovdqu64	%zmm2, (%rbx,%r10) {%k1}
	vmovdqu64	%zmm2, 64(%rbx,%r10) {%k2}
.LBB1_37:                               # %safe_if_after_true57
	knotw	%k0, %k0
	kortestw	%k0, %k0
	je	.LBB1_47
# %bb.38:                               # %safe_if_run_false75
	leaq	(%rbx,%r10), %r8
	testl	%r11d, %r11d
	kmovw	%k0, 224(%rsp)
	vmovdqa	224(%rsp), %xmm2
	vpextrb	$0, %xmm2, %ecx
	vpextrb	$1, %xmm2, %esi
	kmovw	%ecx, %k1
	kmovw	%esi, %k2
	je	.LBB1_41
# %bb.39:                               # %for_loop.i.lr.ph
	cmpl	$1, %r11d
	jne	.LBB1_42
# %bb.40:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB1_45
.LBB1_41:
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB1_46
.LBB1_42:                               # %for_loop.i.lr.ph.new
	movl	%r11d, %r9d
	andl	$1, %r9d
	leaq	(%r15,%r13), %rdi
	addq	$128, %rdi
	movl	%r11d, %ecx
	subl	%r9d, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%esi, %esi
	vpbroadcastq	.LCPI1_0(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	xorl	%eax, %eax
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB1_43:                               # %for_loop.i
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	64(%r13,%rsi), %zmm5
	vpsubq	-64(%rdi,%rsi), %zmm5, %zmm5
	vmovdqu64	(%r13,%rsi), %zmm6
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	-128(%rdi,%rsi), %zmm6, %zmm5
	vpaddq	%zmm2, %zmm5, %zmm2
	vpandd	%zmm4, %zmm2, %zmm5
	vmovdqu64	%zmm5, (%rbx,%rsi) {%k1}
	vpandd	%zmm4, %zmm3, %zmm5
	vmovdqu64	%zmm5, 64(%rbx,%rsi) {%k2}
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
	vmovdqu64	192(%r13,%rsi), %zmm5
	vpsubq	64(%rdi,%rsi), %zmm5, %zmm5
	vmovdqu64	128(%r13,%rsi), %zmm6
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	(%rdi,%rsi), %zmm6, %zmm5
	vpaddq	%zmm2, %zmm5, %zmm2
	vpandd	%zmm4, %zmm2, %zmm5
	vmovdqu64	%zmm5, 128(%rbx,%rsi) {%k1}
	vpandd	%zmm4, %zmm3, %zmm5
	vmovdqu64	%zmm5, 192(%rbx,%rsi) {%k2}
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
	addq	$2, %rax
	addq	$256, %rsi              # imm = 0x100
	cmpl	%eax, %ecx
	jne	.LBB1_43
# %bb.44:                               # %for_test.i285.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_46
.LBB1_45:                               # %for_loop.i.epil.preheader
	shlq	$7, %rax
	vmovdqu64	(%r13,%rax), %zmm4
	vmovdqu64	64(%r13,%rax), %zmm5
	vpsubq	64(%r14,%rax), %zmm5, %zmm5
	vpsubq	(%r14,%rax), %zmm4, %zmm4
	vpaddq	%zmm3, %zmm5, %zmm3
	vpaddq	%zmm2, %zmm4, %zmm2
	vpbroadcastq	.LCPI1_0(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandd	%zmm4, %zmm3, %zmm5
	vpandd	%zmm4, %zmm2, %zmm4
	vmovdqu64	%zmm4, (%rbx,%rax) {%k1}
	vmovdqu64	%zmm5, 64(%rbx,%rax) {%k2}
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
.LBB1_46:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vpaddq	%zmm0, %zmm2, %zmm0
	vpaddq	%zmm1, %zmm3, %zmm1
	vmovdqu64	%zmm0, (%r8) {%k1}
	vmovdqu64	%zmm1, 64(%rbx,%r10) {%k2}
.LBB1_47:                               # %if_done56
	leal	-2(,%rdx,4), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu64	%zmm0, 64(%rbx,%rax)
	vmovdqu64	%zmm0, (%rbx,%rax)
	leal	-1(,%rdx,4), %eax
	shlq	$7, %rax
	vmovdqu64	%zmm0, 64(%rbx,%rax)
	vmovdqu64	%zmm0, (%rbx,%rax)
.LBB1_48:                               # %if_exit
	movq	%r14, 152(%rsp)         # 8-byte Spill
	leal	(%rdx,%rdx), %r14d
	movq	%r14, %r12
	shlq	$7, %r12
	leaq	(%rbx,%r12), %rax
	movq	%rax, 144(%rsp)         # 8-byte Spill
	leaq	256(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rdx, 136(%rsp)         # 8-byte Spill
	movq	%r11, 128(%rsp)         # 8-byte Spill
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	144(%rsp), %rdi         # 8-byte Reload
	movq	152(%rsp), %rsi         # 8-byte Reload
	movq	128(%rsp), %rdx         # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%rbx, %rdi
	movq	%r13, %rsi
	movq	136(%rsp), %rdx         # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	136(%rsp), %r8          # 8-byte Reload
	testl	%r8d, %r8d
	je	.LBB1_51
# %bb.49:                               # %for_loop.i418.lr.ph
	movq	128(%rsp), %r9          # 8-byte Reload
	movl	%r9d, %eax
	notl	%eax
	movq	120(%rsp), %r10         # 8-byte Reload
	addl	%r10d, %eax
	movl	%r8d, %ecx
	andl	$3, %ecx
	cmpl	$3, %eax
	jae	.LBB1_52
# %bb.50:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB1_54
.LBB1_51:
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB1_77
.LBB1_52:                               # %for_loop.i418.lr.ph.new
	movl	%r8d, %esi
	subl	%ecx, %esi
	leaq	384(%rbx), %rdi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	vpbroadcastq	.LCPI1_0(%rip), %zmm2 # zmm2 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB1_53:                               # %for_loop.i418
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-320(%rdi,%r15), %zmm1, %zmm1
	vpaddq	-384(%rdi,%r15), %zmm0, %zmm0
	vpaddq	-384(%rdi,%r12), %zmm0, %zmm0
	vpaddq	-320(%rdi,%r12), %zmm1, %zmm1
	vpandd	%zmm2, %zmm1, %zmm3
	vpandd	%zmm2, %zmm0, %zmm4
	vmovdqu64	%zmm4, -384(%rdi,%r12)
	vmovdqu64	%zmm3, -320(%rdi,%r12)
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	vpaddq	-192(%rdi,%r15), %zmm1, %zmm1
	vpaddq	-256(%rdi,%r15), %zmm0, %zmm0
	vpaddq	-256(%rdi,%r12), %zmm0, %zmm0
	vpaddq	-192(%rdi,%r12), %zmm1, %zmm1
	vpandd	%zmm2, %zmm1, %zmm3
	vpandd	%zmm2, %zmm0, %zmm4
	vmovdqu64	%zmm4, -256(%rdi,%r12)
	vmovdqu64	%zmm3, -192(%rdi,%r12)
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	vpaddq	-64(%rdi,%r15), %zmm1, %zmm1
	vpaddq	-128(%rdi,%r15), %zmm0, %zmm0
	vpaddq	-128(%rdi,%r12), %zmm0, %zmm0
	vpaddq	-64(%rdi,%r12), %zmm1, %zmm1
	vpandd	%zmm2, %zmm1, %zmm3
	vpandd	%zmm2, %zmm0, %zmm4
	vmovdqu64	%zmm4, -128(%rdi,%r12)
	vmovdqu64	%zmm3, -64(%rdi,%r12)
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	vpaddq	64(%rdi,%r15), %zmm1, %zmm1
	vpaddq	(%rdi,%r15), %zmm0, %zmm0
	vpaddq	(%rdi,%r12), %zmm0, %zmm0
	vpaddq	64(%rdi,%r12), %zmm1, %zmm1
	vpandd	%zmm2, %zmm0, %zmm3
	vmovdqu64	%zmm3, (%rdi,%r12)
	vpandd	%zmm2, %zmm1, %zmm3
	vmovdqu64	%zmm3, 64(%rdi,%r12)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addq	$4, %rdx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%edx, %esi
	jne	.LBB1_53
.LBB1_54:                               # %for_test.i407.for_test.i422.preheader_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_57
# %bb.55:                               # %for_loop.i418.epil.preheader
	shlq	$7, %rdx
	addq	%rbx, %rdx
	vpbroadcastq	.LCPI1_0(%rip), %zmm2 # zmm2 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	.p2align	4, 0x90
.LBB1_56:                               # %for_loop.i418.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	64(%rdx,%r15), %zmm1, %zmm1
	vpaddq	(%rdx,%r15), %zmm0, %zmm0
	vpaddq	(%rdx,%r12), %zmm0, %zmm0
	vpaddq	64(%rdx,%r12), %zmm1, %zmm1
	vpandd	%zmm2, %zmm1, %zmm3
	vpandd	%zmm2, %zmm0, %zmm4
	vmovdqu64	%zmm4, (%rdx,%r12)
	vmovdqu64	%zmm3, 64(%rdx,%r12)
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	subq	$-128, %rdx
	addl	$-1, %ecx
	jne	.LBB1_56
.LBB1_57:                               # %for_test.i422.preheader
	testl	%r8d, %r8d
	je	.LBB1_60
# %bb.58:                               # %for_loop.i434.lr.ph
	movl	%r8d, %ecx
	andl	$3, %ecx
	cmpl	$3, %eax
	jae	.LBB1_61
# %bb.59:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%edx, %edx
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB1_63
.LBB1_60:
	vpxor	%xmm4, %xmm4, %xmm4
	vmovdqa64	%zmm0, %zmm11
	vmovdqa64	%zmm1, %zmm3
	jmp	.LBB1_78
.LBB1_61:                               # %for_loop.i434.lr.ph.new
	movl	%r8d, %esi
	subl	%ecx, %esi
	leaq	384(%rbx), %rdi
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%edx, %edx
	vpbroadcastq	.LCPI1_0(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB1_62:                               # %for_loop.i434
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-320(%rdi,%r12), %zmm3, %zmm3
	vpaddq	-384(%rdi,%r12), %zmm2, %zmm2
	vpaddq	-384(%rdi), %zmm2, %zmm2
	vpaddq	-320(%rdi), %zmm3, %zmm3
	vpandd	%zmm4, %zmm3, %zmm5
	vpandd	%zmm4, %zmm2, %zmm6
	vmovdqu64	%zmm6, -384(%rdi,%r15)
	vmovdqu64	%zmm5, -320(%rdi,%r15)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	-256(%rdi,%r12), %zmm2, %zmm2
	vpaddq	-192(%rdi,%r12), %zmm3, %zmm3
	vpaddq	-192(%rdi), %zmm3, %zmm3
	vpaddq	-256(%rdi), %zmm2, %zmm2
	vpandd	%zmm4, %zmm2, %zmm5
	vpandd	%zmm4, %zmm3, %zmm6
	vmovdqu64	%zmm6, -192(%rdi,%r15)
	vmovdqu64	%zmm5, -256(%rdi,%r15)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	-128(%rdi,%r12), %zmm2, %zmm2
	vpaddq	-64(%rdi,%r12), %zmm3, %zmm3
	vpaddq	-64(%rdi), %zmm3, %zmm3
	vpaddq	-128(%rdi), %zmm2, %zmm2
	vpandd	%zmm4, %zmm2, %zmm5
	vpandd	%zmm4, %zmm3, %zmm6
	vmovdqu64	%zmm6, -64(%rdi,%r15)
	vmovdqu64	%zmm5, -128(%rdi,%r15)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	(%rdi,%r12), %zmm2, %zmm2
	vpaddq	64(%rdi,%r12), %zmm3, %zmm3
	vpaddq	64(%rdi), %zmm3, %zmm3
	vpaddq	(%rdi), %zmm2, %zmm2
	vpandd	%zmm4, %zmm3, %zmm5
	vmovdqu64	%zmm5, 64(%rdi,%r15)
	vpandd	%zmm4, %zmm2, %zmm5
	vmovdqu64	%zmm5, (%rdi,%r15)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$4, %rdx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%edx, %esi
	jne	.LBB1_62
.LBB1_63:                               # %for_test.i422.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit435_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_66
# %bb.64:                               # %for_loop.i434.epil.preheader
	shlq	$7, %rdx
	addq	%rbx, %rdx
	vpbroadcastq	.LCPI1_0(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	.p2align	4, 0x90
.LBB1_65:                               # %for_loop.i434.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	64(%rdx,%r12), %zmm3, %zmm3
	vpaddq	(%rdx,%r12), %zmm2, %zmm2
	vpaddq	(%rdx), %zmm2, %zmm2
	vpaddq	64(%rdx), %zmm3, %zmm3
	vpandd	%zmm4, %zmm3, %zmm5
	vpandd	%zmm4, %zmm2, %zmm6
	vmovdqu64	%zmm6, (%rdx,%r15)
	vmovdqu64	%zmm5, 64(%rdx,%r15)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm3, %zmm3
	subq	$-128, %rdx
	addl	$-1, %ecx
	jne	.LBB1_65
.LBB1_66:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit435
	testl	%r8d, %r8d
	vpaddq	%zmm0, %zmm2, %zmm11
	vpaddq	%zmm1, %zmm3, %zmm3
	je	.LBB1_77
# %bb.67:                               # %for_loop.i451.lr.ph
	movl	%r8d, %ecx
	andl	$3, %ecx
	cmpl	$3, %eax
	jae	.LBB1_69
# %bb.68:
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
	vpxor	%xmm5, %xmm5, %xmm5
	jmp	.LBB1_71
.LBB1_69:                               # %for_loop.i451.lr.ph.new
	movl	%r8d, %edx
	subl	%ecx, %edx
	leaq	(%r12,%rbx), %rsi
	addq	$384, %rsi              # imm = 0x180
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
	vpbroadcastq	.LCPI1_0(%rip), %zmm6 # zmm6 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB1_70:                               # %for_loop.i451
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-320(%rsi), %zmm5, %zmm5
	vpaddq	-384(%rsi), %zmm4, %zmm4
	vpaddq	-384(%rsi,%r15), %zmm4, %zmm4
	vpaddq	-320(%rsi,%r15), %zmm5, %zmm5
	vpandd	%zmm6, %zmm5, %zmm7
	vpandd	%zmm6, %zmm4, %zmm8
	vmovdqu64	%zmm8, -384(%rsi)
	vmovdqu64	%zmm7, -320(%rsi)
	vpsrlq	$32, %zmm4, %zmm4
	vpsrlq	$32, %zmm5, %zmm5
	vpaddq	-192(%rsi), %zmm5, %zmm5
	vpaddq	-256(%rsi), %zmm4, %zmm4
	vpaddq	-256(%rsi,%r15), %zmm4, %zmm4
	vpaddq	-192(%rsi,%r15), %zmm5, %zmm5
	vpandd	%zmm6, %zmm5, %zmm7
	vpandd	%zmm6, %zmm4, %zmm8
	vmovdqu64	%zmm8, -256(%rsi)
	vmovdqu64	%zmm7, -192(%rsi)
	vpsrlq	$32, %zmm4, %zmm4
	vpsrlq	$32, %zmm5, %zmm5
	vpaddq	-64(%rsi), %zmm5, %zmm5
	vpaddq	-128(%rsi), %zmm4, %zmm4
	vpaddq	-128(%rsi,%r15), %zmm4, %zmm4
	vpaddq	-64(%rsi,%r15), %zmm5, %zmm5
	vpandd	%zmm6, %zmm5, %zmm7
	vpandd	%zmm6, %zmm4, %zmm8
	vmovdqu64	%zmm8, -128(%rsi)
	vmovdqu64	%zmm7, -64(%rsi)
	vpsrlq	$32, %zmm4, %zmm4
	vpsrlq	$32, %zmm5, %zmm5
	vpaddq	64(%rsi), %zmm5, %zmm5
	vpaddq	(%rsi), %zmm4, %zmm4
	vpaddq	(%rsi,%r15), %zmm4, %zmm4
	vpaddq	64(%rsi,%r15), %zmm5, %zmm5
	vpandd	%zmm6, %zmm4, %zmm7
	vmovdqu64	%zmm7, (%rsi)
	vpandd	%zmm6, %zmm5, %zmm7
	vmovdqu64	%zmm7, 64(%rsi)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm4, %zmm4
	addq	$4, %rax
	addq	$512, %rsi              # imm = 0x200
	cmpl	%eax, %edx
	jne	.LBB1_70
.LBB1_71:                               # %for_test.i439.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit452_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB1_74
# %bb.72:                               # %for_loop.i451.epil.preheader
	addq	%r14, %rax
	shlq	$7, %rax
	addq	%rbx, %rax
	vpbroadcastq	.LCPI1_0(%rip), %zmm6 # zmm6 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	.p2align	4, 0x90
.LBB1_73:                               # %for_loop.i451.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	64(%rax), %zmm5, %zmm5
	vpaddq	(%rax), %zmm4, %zmm4
	vpaddq	(%rax,%r15), %zmm4, %zmm4
	vpaddq	64(%rax,%r15), %zmm5, %zmm5
	vpandd	%zmm6, %zmm5, %zmm7
	vpandd	%zmm6, %zmm4, %zmm8
	vmovdqu64	%zmm8, (%rax)
	vmovdqu64	%zmm7, 64(%rax)
	vpsrlq	$32, %zmm4, %zmm4
	vpsrlq	$32, %zmm5, %zmm5
	subq	$-128, %rax
	addl	$-1, %ecx
	jne	.LBB1_73
.LBB1_74:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit452
	vpaddq	%zmm0, %zmm4, %zmm0
	vpaddq	%zmm1, %zmm5, %zmm1
	testl	%r14d, %r14d
	je	.LBB1_77
# %bb.75:                               # %for_loop.i402.lr.ph
	addq	%rbx, %r15
	leal	(%r10,%r10), %ecx
	orl	$1, %r10d
	movl	%ecx, %edx
	subl	%r10d, %edx
	movl	%r14d, %eax
	andl	$2, %eax
	cmpl	$3, %edx
	jae	.LBB1_86
# %bb.76:
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%ecx, %ecx
	vpxor	%xmm5, %xmm5, %xmm5
	testl	%eax, %eax
	je	.LBB1_79
	jmp	.LBB1_89
.LBB1_77:
	vpxor	%xmm4, %xmm4, %xmm4
.LBB1_78:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit403
	vpxor	%xmm5, %xmm5, %xmm5
.LBB1_79:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit403
	vpaddq	%zmm5, %zmm1, %zmm1
	vpaddq	%zmm4, %zmm0, %zmm0
	vptestmq	%zmm11, %zmm11, %k0
	vptestmq	%zmm3, %zmm3, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	je	.LBB1_82
# %bb.80:                               # %for_loop.preheader
	vpbroadcastq	.LCPI1_0(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	.p2align	4, 0x90
.LBB1_81:                               # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	movl	%r14d, %eax
	shlq	$7, %rax
	vpaddq	(%rbx,%rax), %zmm11, %zmm5
	vpaddq	64(%rbx,%rax), %zmm3, %zmm6
	vpandd	%zmm4, %zmm5, %zmm7
	kmovw	%k1, 176(%rsp)
	vmovdqa	176(%rsp), %xmm2
	vpextrb	$0, %xmm2, %ecx
	vpextrb	$1, %xmm2, %edx
	kmovw	%ecx, %k2
	vmovdqu64	%zmm7, (%rbx,%rax) {%k2}
	vpandd	%zmm4, %zmm6, %zmm2
	kmovw	%edx, %k2
	vmovdqu64	%zmm2, 64(%rbx,%rax) {%k2}
	kshiftrw	$8, %k1, %k2
	vpsrlq	$32, %zmm6, %zmm3 {%k2}
	vpsrlq	$32, %zmm5, %zmm11 {%k1}
	addl	$1, %r14d
	vptestmq	%zmm11, %zmm11, %k0
	vptestmq	%zmm3, %zmm3, %k2
	kunpckbw	%k0, %k2, %k0
	kandw	%k0, %k1, %k1
	kortestw	%k1, %k1
	jne	.LBB1_81
.LBB1_82:                               # %for_exit
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	je	.LBB1_85
# %bb.83:                               # %for_loop201.lr.ph
	leal	(%r8,%r8,2), %eax
	vpbroadcastq	.LCPI1_0(%rip), %zmm2 # zmm2 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	.p2align	4, 0x90
.LBB1_84:                               # %for_loop201
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpaddq	(%rbx,%rcx), %zmm0, %zmm3
	vpaddq	64(%rbx,%rcx), %zmm1, %zmm4
	vpandd	%zmm2, %zmm3, %zmm5
	kmovw	%k1, 160(%rsp)
	vmovdqa	160(%rsp), %xmm6
	vpextrb	$0, %xmm6, %edx
	vpextrb	$1, %xmm6, %esi
	kmovw	%edx, %k2
	vmovdqu64	%zmm5, (%rbx,%rcx) {%k2}
	vpandd	%zmm2, %zmm4, %zmm5
	kmovw	%esi, %k2
	vmovdqu64	%zmm5, 64(%rbx,%rcx) {%k2}
	kshiftrw	$8, %k1, %k2
	vpsraq	$32, %zmm4, %zmm1 {%k2}
	vpsraq	$32, %zmm3, %zmm0 {%k1}
	addl	$1, %eax
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k2
	kunpckbw	%k0, %k2, %k0
	kandw	%k0, %k1, %k1
	kortestw	%k1, %k1
	jne	.LBB1_84
.LBB1_85:                               # %for_exit203
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB1_86:                               # %for_loop.i402.lr.ph.new
	leal	(%rax,%r9,2), %edx
	subl	%ecx, %edx
	vpxor	%xmm4, %xmm4, %xmm4
	movl	$384, %esi              # imm = 0x180
	xorl	%ecx, %ecx
	vpbroadcastq	.LCPI1_0(%rip), %zmm6 # zmm6 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB1_87:                               # %for_loop.i402
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-384(%r15,%rsi), %zmm7
	vmovdqu64	-320(%r15,%rsi), %zmm8
	vmovdqu64	-256(%r15,%rsi), %zmm9
	vmovdqu64	-192(%r15,%rsi), %zmm10
	vpsubq	-64(%rsp,%rsi), %zmm8, %zmm8
	vpsubq	-128(%rsp,%rsi), %zmm7, %zmm7
	vpaddq	%zmm5, %zmm8, %zmm5
	vpaddq	%zmm4, %zmm7, %zmm4
	vpandd	%zmm6, %zmm5, %zmm7
	vpandd	%zmm6, %zmm4, %zmm8
	vmovdqu64	%zmm8, -384(%r15,%rsi)
	vmovdqu64	%zmm7, -320(%r15,%rsi)
	vpsraq	$32, %zmm5, %zmm5
	vpsubq	64(%rsp,%rsi), %zmm10, %zmm7
	vpsraq	$32, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm7, %zmm5
	vpsubq	(%rsp,%rsi), %zmm9, %zmm7
	vpaddq	%zmm4, %zmm7, %zmm4
	vpandd	%zmm6, %zmm4, %zmm7
	vmovdqu64	%zmm7, -256(%r15,%rsi)
	vpandd	%zmm6, %zmm5, %zmm7
	vmovdqu64	%zmm7, -192(%r15,%rsi)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	vmovdqu64	-64(%r15,%rsi), %zmm7
	vpsubq	192(%rsp,%rsi), %zmm7, %zmm7
	vmovdqu64	-128(%r15,%rsi), %zmm8
	vpaddq	%zmm5, %zmm7, %zmm5
	vpsubq	128(%rsp,%rsi), %zmm8, %zmm7
	vpaddq	%zmm4, %zmm7, %zmm4
	vpandd	%zmm6, %zmm4, %zmm7
	vmovdqu64	%zmm7, -128(%r15,%rsi)
	vpandd	%zmm6, %zmm5, %zmm7
	vmovdqu64	%zmm7, -64(%r15,%rsi)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	vmovdqu64	64(%r15,%rsi), %zmm7
	vpsubq	320(%rsp,%rsi), %zmm7, %zmm7
	vmovdqu64	(%r15,%rsi), %zmm8
	vpaddq	%zmm5, %zmm7, %zmm5
	vpsubq	256(%rsp,%rsi), %zmm8, %zmm7
	vpaddq	%zmm4, %zmm7, %zmm4
	vpandd	%zmm6, %zmm4, %zmm7
	vmovdqu64	%zmm7, (%r15,%rsi)
	vpandd	%zmm6, %zmm5, %zmm7
	vmovdqu64	%zmm7, 64(%r15,%rsi)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	addq	$512, %rsi              # imm = 0x200
	addq	$-4, %rcx
	cmpl	%ecx, %edx
	jne	.LBB1_87
# %bb.88:                               # %for_test.i390.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit403_crit_edge.unr-lcssa.loopexit
	negq	%rcx
	testl	%eax, %eax
	je	.LBB1_79
.LBB1_89:                               # %for_loop.i402.epil.preheader
	shlq	$7, %rcx
	negl	%eax
	vpbroadcastq	.LCPI1_0(%rip), %zmm6 # zmm6 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	.p2align	4, 0x90
.LBB1_90:                               # %for_loop.i402.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	(%r15,%rcx), %zmm7
	vmovdqu64	64(%r15,%rcx), %zmm8
	vpsubq	320(%rsp,%rcx), %zmm8, %zmm8
	vpsubq	256(%rsp,%rcx), %zmm7, %zmm7
	vpaddq	%zmm5, %zmm8, %zmm5
	vpaddq	%zmm4, %zmm7, %zmm4
	vpandd	%zmm6, %zmm5, %zmm7
	vpandd	%zmm6, %zmm4, %zmm8
	vmovdqu64	%zmm8, (%r15,%rcx)
	vmovdqu64	%zmm7, 64(%r15,%rcx)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	subq	$-128, %rcx
	incl	%eax
	jne	.LBB1_90
	jmp	.LBB1_79
.Lfunc_end1:
	.size	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu, .Lfunc_end1-toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
                                        # -- End function
	.section	.rodata,"a",@progbits
	.p2align	6               # -- Begin function fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
.LCPI2_0:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
	.long	8                       # 0x8
	.long	9                       # 0x9
	.long	10                      # 0xa
	.long	11                      # 0xb
	.long	12                      # 0xc
	.long	13                      # 0xd
	.long	14                      # 0xe
	.long	15                      # 0xf
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI2_1:
	.quad	4294967295              # 0xffffffff
.LCPI2_3:
	.quad	1                       # 0x1
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2
.LCPI2_2:
	.long	1                       # 0x1
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI2_4:
	.zero	16,1
	.text
	.globl	fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
	.p2align	4, 0x90
	.type	fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu,@function
fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu: # @fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
# %bb.0:                                # %allocas
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-128, %rsp
	subq	$45568, %rsp            # imm = 0xB200
	movl	%r9d, 32(%rsp)          # 4-byte Spill
	movl	%r8d, %r13d
	movq	%rcx, 40(%rsp)          # 8-byte Spill
	vpmovsxbd	%xmm0, %zmm0
	vpslld	$31, %zmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k5
	testl	%r8d, %r8d
	je	.LBB2_7
# %bb.1:                                # %for_loop.lr.ph
	vpbroadcastd	%r13d, %zmm0
	vpmulld	.LCPI2_0(%rip), %zmm0, %zmm0
	kmovw	%k5, %r9d
	cmpl	$1, %r13d
	jne	.LBB2_3
# %bb.2:
	xorl	%eax, %eax
	jmp	.LBB2_6
.LBB2_3:                                # %for_loop.lr.ph.new
	movl	%r13d, %r8d
	andl	$1, %r8d
	movl	%r13d, %r10d
	subl	%r8d, %r10d
	movl	$64, %ecx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB2_4:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vpbroadcastd	%eax, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kmovw	%r9d, %k1
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k2}
	vmovdqa64	%zmm2, 8512(%rsp,%rcx)
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k2}
	vextracti64x4	$1, %zmm2, %ymm1
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vmovdqa64	%zmm1, 320(%rsp,%rcx,2)
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm1, 256(%rsp,%rcx,2)
	leal	1(%rax), %ebx
	vpbroadcastd	%ebx, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k2}
	vmovdqa64	%zmm2, 8576(%rsp,%rcx)
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k1}
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm2, 448(%rsp,%rcx,2)
	vmovdqa64	%zmm1, 384(%rsp,%rcx,2)
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %r10d
	jne	.LBB2_4
# %bb.5:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_7
.LBB2_6:                                # %for_loop.epil.preheader
	movq	%rax, %rcx
	shlq	$6, %rcx
	vpbroadcastd	%eax, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm0
	vpslld	$2, %zmm0, %zmm0
	kmovw	%r9d, %k1
	vpxor	%xmm1, %xmm1, %xmm1
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm0), %zmm2 {%k2}
	vmovdqa64	%zmm2, 8576(%rsp,%rcx)
	shlq	$7, %rax
	vpgatherdd	(%rdx,%zmm0), %zmm1 {%k1}
	vpmovzxdq	%ymm1, %zmm0    # zmm0 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vextracti64x4	$1, %zmm1, %ymm1
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vmovdqa64	%zmm1, 448(%rsp,%rax)
	vmovdqa64	%zmm0, 384(%rsp,%rax)
.LBB2_7:                                # %for_exit
	xorl	%ecx, %ecx
	movl	32(%rsp), %edx          # 4-byte Reload
	cmpl	$23, %edx
	seta	%cl
	movl	%r13d, %eax
	subl	%ecx, %eax
	vmovdqu32	(%rsi), %zmm12 {%k5}{z}
	testl	%eax, %eax
	vpbroadcastd	%edx, %zmm11
	movl	%r13d, %r14d
	jle	.LBB2_15
# %bb.8:                                # %for_loop35.lr.ph
	xorl	%ecx, %ecx
	movl	32(%rsp), %esi          # 4-byte Reload
	cmpl	$24, %esi
	setb	%cl
	shll	$5, %ecx
	addl	%esi, %ecx
	addb	$-24, %cl
	movl	$-2147483648, %edx      # imm = 0x80000000
	shrxl	%ecx, %edx, %edi
	movl	$32, %ecx
	subl	%esi, %ecx
	vpbroadcastd	%ecx, %zmm13
	leal	-1(%r13), %r12d
	movl	%eax, %eax
	leaq	8640(%rsp), %r15
	movl	%r13d, %ebx
	andl	$-2, %ebx
	vpbroadcastq	.LCPI2_1(%rip), %zmm14 # zmm14 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	kmovw	%k5, 30(%rsp)           # 2-byte Spill
	vmovdqa64	%zmm11, 256(%rsp) # 64-byte Spill
	vmovdqa64	%zmm12, 192(%rsp) # 64-byte Spill
	vmovdqa64	%zmm13, 128(%rsp) # 64-byte Spill
	vmovdqa64	%zmm14, 64(%rsp) # 64-byte Spill
	jmp	.LBB2_9
	.p2align	4, 0x90
.LBB2_14:                               # %for_test34.loopexit
                                        #   in Loop: Header=BB2_9 Depth=1
	movl	$-2147483648, %edi      # imm = 0x80000000
	cmpq	$1, 56(%rsp)            # 8-byte Folded Reload
	movq	48(%rsp), %rax          # 8-byte Reload
	jle	.LBB2_15
.LBB2_9:                                # %for_loop35
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_12 Depth 2
                                        #       Child Loop BB2_26 Depth 3
                                        #         Child Loop BB2_29 Depth 4
                                        #       Child Loop BB2_49 Depth 3
                                        #       Child Loop BB2_41 Depth 3
                                        #         Child Loop BB2_44 Depth 4
                                        #       Child Loop BB2_50 Depth 3
	movq	%rax, 56(%rsp)          # 8-byte Spill
	leaq	-1(%rax), %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	movq	%rcx, 48(%rsp)          # 8-byte Spill
	testq	%rcx, %rcx
	vpternlogd	$255, %zmm0, %zmm0, %zmm0
	je	.LBB2_11
# %bb.10:                               # %for_loop35
                                        #   in Loop: Header=BB2_9 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_11:                               # %for_loop35
                                        #   in Loop: Header=BB2_9 Depth=1
	vpaddd	8576(%rsp,%rax), %zmm0, %zmm0
	vmovdqa64	%zmm0, 320(%rsp) # 64-byte Spill
	jmp	.LBB2_12
	.p2align	4, 0x90
.LBB2_51:                               # %for_exit135
                                        #   in Loop: Header=BB2_12 Depth=2
	shrl	%edi
	je	.LBB2_14
.LBB2_12:                               # %do_loop
                                        #   Parent Loop BB2_9 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_26 Depth 3
                                        #         Child Loop BB2_29 Depth 4
                                        #       Child Loop BB2_49 Depth 3
                                        #       Child Loop BB2_41 Depth 3
                                        #         Child Loop BB2_44 Depth 4
                                        #       Child Loop BB2_50 Depth 3
	movl	%edi, 36(%rsp)          # 4-byte Spill
	leaq	29056(%rsp), %rdi
	leaq	384(%rsp), %rsi
	movl	%r13d, %edx
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	testl	%r13d, %r13d
	je	.LBB2_13
# %bb.25:                               # %for_loop67.lr.ph.us.preheader
                                        #   in Loop: Header=BB2_12 Depth=2
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa64	256(%rsp), %zmm11 # 64-byte Reload
	vmovdqa64	192(%rsp), %zmm12 # 64-byte Reload
	vmovdqa64	128(%rsp), %zmm13 # 64-byte Reload
	vmovdqa64	64(%rsp), %zmm14 # 64-byte Reload
	jmp	.LBB2_26
	.p2align	4, 0x90
.LBB2_27:                               #   in Loop: Header=BB2_26 Depth=3
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%esi, %esi
.LBB2_31:                               # %for_loop67.us.epil.preheader
                                        #   in Loop: Header=BB2_26 Depth=3
	movq	%rsi, %rdx
	shlq	$6, %rdx
	vpmovzxdq	8576(%rsp,%rdx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8608(%rsp,%rdx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm0
	vpmuludq	%zmm1, %zmm4, %zmm1
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29120(%rsp,%rsi), %zmm3, %zmm3
	vpaddq	%zmm0, %zmm3, %zmm0
	vpaddq	29056(%rsp,%rsi), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	vpandd	%zmm14, %zmm0, %zmm2
	vpandd	%zmm14, %zmm1, %zmm3
	vmovdqa64	%zmm3, 29056(%rsp,%rsi)
	vmovdqa64	%zmm2, 29120(%rsp,%rsi)
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm2
.LBB2_32:                               # %for_exit69.us
                                        #   in Loop: Header=BB2_26 Depth=3
	vmovdqa64	%zmm3, 448(%rsp,%r8)
	vmovdqa64	%zmm2, 384(%rsp,%r8)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r14, %rcx
	je	.LBB2_33
.LBB2_26:                               # %for_loop67.lr.ph.us
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_29 Depth 4
	movq	%rcx, %r8
	shlq	$7, %r8
	vmovdqa64	29056(%rsp,%r8), %zmm0
	vmovdqa64	29120(%rsp,%r8), %zmm1
	vpmovqd	%zmm0, %ymm0
	vpmovqd	%zmm1, %ymm1
	vinserti64x4	$1, %ymm1, %zmm0, %zmm0
	vpmulld	%zmm0, %zmm12, %zmm1
	vextracti64x4	$1, %zmm1, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpxor	%xmm2, %xmm2, %xmm2
	testl	%r12d, %r12d
	je	.LBB2_27
# %bb.28:                               # %for_loop67.lr.ph.us.new
                                        #   in Loop: Header=BB2_26 Depth=3
	movq	%r15, %rdi
	xorl	%esi, %esi
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_29:                               # %for_loop67.us
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_12 Depth=2
                                        #       Parent Loop BB2_26 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-32(%rdi), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-64(%rdi), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm5
	vpmuludq	%zmm0, %zmm4, %zmm4
	leal	(%rcx,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpaddq	%zmm5, %zmm2, %zmm2
	vpaddq	%zmm4, %zmm3, %zmm3
	vpandd	%zmm14, %zmm2, %zmm4
	vpandd	%zmm14, %zmm3, %zmm5
	vmovdqa64	%zmm5, 29120(%rsp,%rdx)
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpsrlq	$32, %zmm2, %zmm2
	vpmovzxdq	(%rdi), %zmm4   # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	32(%rdi), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm5
	leal	(%rax,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpmuludq	%zmm1, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vpandd	%zmm14, %zmm2, %zmm4
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpandd	%zmm14, %zmm3, %zmm4
	vmovdqa64	%zmm4, 29120(%rsp,%rdx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %ebx
	jne	.LBB2_29
# %bb.30:                               # %for_test66.for_exit69_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_26 Depth=3
	testb	$1, %r13b
	jne	.LBB2_31
	jmp	.LBB2_32
	.p2align	4, 0x90
.LBB2_33:                               # %for_test96.preheader
                                        #   in Loop: Header=BB2_12 Depth=2
	testl	%r13d, %r13d
	kmovw	30(%rsp), %k5           # 2-byte Reload
	je	.LBB2_34
# %bb.35:                               # %for_loop97.lr.ph
                                        #   in Loop: Header=BB2_12 Depth=2
	movl	36(%rsp), %edi          # 4-byte Reload
	vpbroadcastd	%edi, %zmm0
	vptestmd	320(%rsp), %zmm0, %k1 # 64-byte Folded Reload
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm2
	kshiftrw	$8, %k1, %k1
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm3
	vpxor	%xmm0, %xmm0, %xmm0
	testl	%r12d, %r12d
	je	.LBB2_36
# %bb.48:                               # %for_loop97.lr.ph.new
                                        #   in Loop: Header=BB2_12 Depth=2
	movl	%r13d, %ecx
	leaq	512(%rsp), %rdx
	xorl	%eax, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB2_49:                               # %for_loop97
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%ecx, %esi
	shlq	$7, %rsi
	vmovdqa64	29056(%rsp,%rsi), %zmm4
	vmovdqa64	29120(%rsp,%rsi), %zmm5
	vpaddq	-64(%rdx), %zmm5, %zmm5
	vpaddq	-128(%rdx), %zmm4, %zmm4
	vpsllvq	%zmm2, %zmm4, %zmm4
	vpaddq	%zmm0, %zmm4, %zmm0
	vpsllvq	%zmm3, %zmm5, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpandd	%zmm14, %zmm0, %zmm4
	vpandd	%zmm14, %zmm1, %zmm5
	vmovdqa64	%zmm5, -64(%rdx)
	vmovdqa64	%zmm4, -128(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	leal	1(%rcx), %esi
	shlq	$7, %rsi
	vmovdqa64	29120(%rsp,%rsi), %zmm4
	vmovdqa64	29056(%rsp,%rsi), %zmm5
	vpaddq	(%rdx), %zmm5, %zmm5
	vpaddq	64(%rdx), %zmm4, %zmm4
	vpsllvq	%zmm3, %zmm4, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpsllvq	%zmm2, %zmm5, %zmm4
	vpaddq	%zmm0, %zmm4, %zmm0
	vpandd	%zmm14, %zmm1, %zmm4
	vpandd	%zmm14, %zmm0, %zmm5
	vmovdqa64	%zmm5, (%rdx)
	vmovdqa64	%zmm4, 64(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addq	$2, %rax
	addq	$256, %rdx              # imm = 0x100
	addl	$2, %ecx
	cmpl	%eax, %ebx
	jne	.LBB2_49
# %bb.37:                               # %for_test96.for_test132.preheader_crit_edge.unr-lcssa
                                        #   in Loop: Header=BB2_12 Depth=2
	testb	$1, %r13b
	jne	.LBB2_38
	jmp	.LBB2_39
	.p2align	4, 0x90
.LBB2_13:                               #   in Loop: Header=BB2_12 Depth=2
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	kmovw	30(%rsp), %k5           # 2-byte Reload
	vmovdqa64	256(%rsp), %zmm11 # 64-byte Reload
	vmovdqa64	192(%rsp), %zmm12 # 64-byte Reload
	vmovdqa64	128(%rsp), %zmm13 # 64-byte Reload
	movl	36(%rsp), %edi          # 4-byte Reload
	vmovdqa64	64(%rsp), %zmm14 # 64-byte Reload
	jmp	.LBB2_39
	.p2align	4, 0x90
.LBB2_34:                               #   in Loop: Header=BB2_12 Depth=2
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	movl	36(%rsp), %edi          # 4-byte Reload
	jmp	.LBB2_39
.LBB2_36:                               #   in Loop: Header=BB2_12 Depth=2
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
.LBB2_38:                               # %for_loop97.epil.preheader
                                        #   in Loop: Header=BB2_12 Depth=2
	movq	%rax, %rcx
	shlq	$7, %rcx
	addl	%r13d, %eax
	shlq	$7, %rax
	vmovdqa64	29056(%rsp,%rax), %zmm4
	vmovdqa64	29120(%rsp,%rax), %zmm5
	vpaddq	384(%rsp,%rcx), %zmm4, %zmm4
	vpaddq	448(%rsp,%rcx), %zmm5, %zmm5
	vpsllvq	%zmm3, %zmm5, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	vpsllvq	%zmm2, %zmm4, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vpandd	%zmm14, %zmm1, %zmm2
	vpandd	%zmm14, %zmm0, %zmm3
	vmovdqa64	%zmm3, 384(%rsp,%rcx)
	vmovdqa64	%zmm2, 448(%rsp,%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB2_39:                               # %for_test132.preheader
                                        #   in Loop: Header=BB2_12 Depth=2
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kandw	%k5, %k1, %k0
	kortestw	%k0, %k0
	je	.LBB2_51
# %bb.40:                               # %for_test146.preheader.lr.ph
                                        #   in Loop: Header=BB2_12 Depth=2
	testl	%r13d, %r13d
	kmovw	%k1, %k0
	jne	.LBB2_41
	.p2align	4, 0x90
.LBB2_50:                               # %for_exit149
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	kandw	%k0, %k1, %k0
	kandw	%k5, %k0, %k2
	kortestw	%k2, %k2
	jne	.LBB2_50
	jmp	.LBB2_51
	.p2align	4, 0x90
.LBB2_42:                               #   in Loop: Header=BB2_41 Depth=3
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
.LBB2_46:                               # %for_loop147.us.epil.preheader
                                        #   in Loop: Header=BB2_41 Depth=3
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm5
	vmovdqa64	448(%rsp,%rcx), %zmm6
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm7
	vpsllvd	%zmm11, %zmm7, %zmm7
	vpord	%zmm4, %zmm7, %zmm4
	vpmovzxdq	%ymm4, %zmm7    # zmm7 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vextracti64x4	$1, %zmm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpsubq	%zmm4, %zmm6, %zmm4
	vpaddq	%zmm3, %zmm4, %zmm3
	vpsubq	%zmm7, %zmm5, %zmm4
	vpaddq	%zmm2, %zmm4, %zmm2
	vpandq	%zmm14, %zmm3, %zmm6 {%k2}
	vpandq	%zmm14, %zmm2, %zmm5 {%k1}
	vmovdqa64	%zmm5, 384(%rsp,%rcx)
	vmovdqa64	%zmm6, 448(%rsp,%rcx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
.LBB2_47:                               # %for_exit149.us
                                        #   in Loop: Header=BB2_41 Depth=3
	vmovdqa64	%zmm2, %zmm2 {%k1}{z}
	vpaddq	%zmm0, %zmm2, %zmm0
	vmovdqa64	%zmm3, %zmm2 {%k2}{z}
	vpaddq	%zmm1, %zmm2, %zmm1
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k2
	kunpckbw	%k0, %k2, %k0
	kandw	%k1, %k0, %k1
	kandw	%k5, %k1, %k0
	kortestw	%k0, %k0
	je	.LBB2_51
.LBB2_41:                               # %for_loop147.lr.ph.us
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_44 Depth 4
	testl	%r12d, %r12d
	kshiftrw	$8, %k1, %k2
	je	.LBB2_42
# %bb.43:                               # %for_loop147.lr.ph.us.new
                                        #   in Loop: Header=BB2_41 Depth=3
	vpxor	%xmm4, %xmm4, %xmm4
	movl	$64, %ecx
	xorl	%eax, %eax
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_44:                               # %for_loop147.us
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_12 Depth=2
                                        #       Parent Loop BB2_41 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa64	8512(%rsp,%rcx), %zmm5
	vpsllvd	%zmm11, %zmm5, %zmm6
	vpord	%zmm4, %zmm6, %zmm4
	vpsrlvd	%zmm13, %zmm5, %zmm5
	vpmovzxdq	%ymm4, %zmm6    # zmm6 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vextracti64x4	$1, %zmm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vmovdqa64	256(%rsp,%rcx,2), %zmm7
	vmovdqa64	320(%rsp,%rcx,2), %zmm8
	vmovdqa64	384(%rsp,%rcx,2), %zmm9
	vmovdqa64	448(%rsp,%rcx,2), %zmm10
	vpsubq	%zmm4, %zmm8, %zmm4
	vpaddq	%zmm3, %zmm4, %zmm3
	vpsubq	%zmm6, %zmm7, %zmm4
	vpaddq	%zmm2, %zmm4, %zmm2
	vpandq	%zmm14, %zmm3, %zmm8 {%k2}
	vpandq	%zmm14, %zmm2, %zmm7 {%k1}
	vmovdqa64	%zmm7, 256(%rsp,%rcx,2)
	vmovdqa64	%zmm8, 320(%rsp,%rcx,2)
	vmovdqa64	8576(%rsp,%rcx), %zmm4
	vpsllvd	%zmm11, %zmm4, %zmm6
	vpsraq	$32, %zmm3, %zmm3
	vpsrlvd	%zmm13, %zmm4, %zmm4
	vpsraq	$32, %zmm2, %zmm2
	vpord	%zmm5, %zmm6, %zmm5
	vpmovzxdq	%ymm5, %zmm6    # zmm6 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vextracti64x4	$1, %zmm5, %ymm5
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpsubq	%zmm5, %zmm10, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	%zmm6, %zmm9, %zmm5
	vpaddq	%zmm2, %zmm5, %zmm2
	vpandq	%zmm14, %zmm2, %zmm9 {%k1}
	vmovdqa64	%zmm9, 384(%rsp,%rcx,2)
	vpandq	%zmm14, %zmm3, %zmm10 {%k2}
	vmovdqa64	%zmm10, 448(%rsp,%rcx,2)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %ebx
	jne	.LBB2_44
# %bb.45:                               # %for_test146.for_exit149_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_41 Depth=3
	testb	$1, %r13b
	jne	.LBB2_46
	jmp	.LBB2_47
.LBB2_15:                               # %for_test194.preheader
	kxorw	%k0, %k0, %k1
	testl	%r13d, %r13d
	je	.LBB2_68
# %bb.16:                               # %for_loop195.lr.ph
	leal	-1(%r13), %r8d
	movl	%r13d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB2_60
# %bb.17:
	xorl	%edx, %edx
	jmp	.LBB2_18
.LBB2_60:                               # %for_loop195.lr.ph.new
	movl	%r13d, %eax
	subl	%ecx, %eax
	movl	$384, %esi              # imm = 0x180
	xorl	%edx, %edx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_61:                               # %for_loop195
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	(%rsp,%rsi), %zmm1
	vmovaps	64(%rsp,%rsi), %zmm2
	vmovdqa64	128(%rsp,%rsi), %zmm3
	vmovaps	%zmm1, 12288(%rsp,%rsi)
	vmovaps	192(%rsp,%rsi), %zmm1
	vmovaps	%zmm2, 12352(%rsp,%rsi)
	leaq	(%r14,%rdx), %rdi
	movl	%edi, %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovdqa64	%zmm3, 12416(%rsp,%rsi)
	vmovaps	%zmm1, 12480(%rsp,%rsi)
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovaps	320(%rsp,%rsi), %zmm1
	vmovaps	256(%rsp,%rsi), %zmm2
	vmovaps	%zmm2, 12544(%rsp,%rsi)
	vmovaps	%zmm1, 12608(%rsp,%rsi)
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovdqa64	448(%rsp,%rsi), %zmm1
	vmovdqa64	384(%rsp,%rsi), %zmm2
	vmovdqa64	%zmm2, 12672(%rsp,%rsi)
	vmovdqa64	%zmm1, 12736(%rsp,%rsi)
	addl	$3, %edi
	shlq	$7, %rdi
	vmovdqa64	%zmm0, 12672(%rsp,%rdi)
	vmovdqa64	%zmm0, 12736(%rsp,%rdi)
	addq	$4, %rdx
	addq	$512, %rsi              # imm = 0x200
	cmpl	%edx, %eax
	jne	.LBB2_61
.LBB2_18:                               # %for_test194.for_test212.preheader_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB2_21
# %bb.19:                               # %for_loop195.epil.preheader
	leal	(%rdx,%r13), %eax
	shlq	$7, %rdx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_20:                               # %for_loop195.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa64	384(%rsp,%rdx), %zmm1
	vmovdqa64	448(%rsp,%rdx), %zmm2
	vmovdqa64	%zmm1, 12672(%rsp,%rdx)
	vmovdqa64	%zmm2, 12736(%rsp,%rdx)
	movl	%eax, %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	addl	$1, %eax
	subq	$-128, %rdx
	addl	$-1, %ecx
	jne	.LBB2_20
.LBB2_21:                               # %for_test212.preheader
	testl	%r13d, %r13d
	je	.LBB2_68
# %bb.22:                               # %for_loop213.lr.ph.split.us
	leaq	8640(%rsp), %r9
	movl	%r13d, %edx
	andl	$-2, %edx
	movl	$1, %esi
	xorl	%edi, %edi
	vpbroadcastq	.LCPI2_1(%rip), %zmm0 # zmm0 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	jmp	.LBB2_23
	.p2align	4, 0x90
.LBB2_24:                               #   in Loop: Header=BB2_23 Depth=1
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
.LBB2_55:                               # %for_loop229.us.epil.preheader
                                        #   in Loop: Header=BB2_23 Depth=1
	movq	%rax, %rcx
	shlq	$6, %rcx
	vpmovzxdq	8576(%rsp,%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8608(%rsp,%rcx), %zmm6 # zmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm6, %zmm1
	vpmuludq	%zmm2, %zmm5, %zmm2
	addl	%edi, %eax
	shlq	$7, %rax
	vpaddq	12736(%rsp,%rax), %zmm4, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpaddq	12672(%rsp,%rax), %zmm3, %zmm3
	vpaddq	%zmm2, %zmm3, %zmm2
	vpandd	%zmm0, %zmm1, %zmm3
	vpandd	%zmm0, %zmm2, %zmm4
	vmovdqa64	%zmm4, 12672(%rsp,%rax)
	vmovdqa64	%zmm3, 12736(%rsp,%rax)
	vpsrlq	$32, %zmm1, %zmm4
	vpsrlq	$32, %zmm2, %zmm3
.LBB2_56:                               # %for_exit231.us
                                        #   in Loop: Header=BB2_23 Depth=1
	vmovdqa64	%zmm4, 448(%rsp,%r10)
	vmovdqa64	%zmm3, 384(%rsp,%r10)
	addq	$1, %rdi
	addq	$1, %rsi
	cmpq	%r14, %rdi
	je	.LBB2_57
.LBB2_23:                               # %for_loop229.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_53 Depth 2
	movq	%rdi, %r10
	shlq	$7, %r10
	vmovdqa64	12672(%rsp,%r10), %zmm1
	vmovdqa64	12736(%rsp,%r10), %zmm2
	vpmovqd	%zmm1, %ymm1
	vpmovqd	%zmm2, %ymm2
	vinserti64x4	$1, %ymm2, %zmm1, %zmm1
	vpmulld	%zmm1, %zmm12, %zmm2
	vextracti64x4	$1, %zmm2, %ymm1
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vpxor	%xmm3, %xmm3, %xmm3
	cmpl	$1, %r13d
	je	.LBB2_24
# %bb.52:                               # %for_loop229.lr.ph.us.new
                                        #   in Loop: Header=BB2_23 Depth=1
	movq	%r9, %rcx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_53:                               # %for_loop229.us
                                        #   Parent Loop BB2_23 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-32(%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-64(%rcx), %zmm6 # zmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm2, %zmm6, %zmm6
	vpmuludq	%zmm1, %zmm5, %zmm5
	leal	(%rdi,%rax), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm3, %zmm3
	vpaddq	12736(%rsp,%rbx), %zmm4, %zmm4
	vpaddq	%zmm6, %zmm3, %zmm3
	vpaddq	%zmm5, %zmm4, %zmm4
	vpandd	%zmm0, %zmm3, %zmm5
	vpandd	%zmm0, %zmm4, %zmm6
	vmovdqa64	%zmm6, 12736(%rsp,%rbx)
	vmovdqa64	%zmm5, 12672(%rsp,%rbx)
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	(%rcx), %zmm5   # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm4, %zmm4
	vpmovzxdq	32(%rcx), %zmm6 # zmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm6, %zmm6
	leal	(%rsi,%rax), %ebx
	shlq	$7, %rbx
	vpaddq	12736(%rsp,%rbx), %zmm4, %zmm4
	vpmuludq	%zmm2, %zmm5, %zmm5
	vpaddq	%zmm6, %zmm4, %zmm4
	vpaddq	12672(%rsp,%rbx), %zmm3, %zmm3
	vpaddq	%zmm5, %zmm3, %zmm3
	vpandd	%zmm0, %zmm3, %zmm5
	vmovdqa64	%zmm5, 12672(%rsp,%rbx)
	vpandd	%zmm0, %zmm4, %zmm5
	vmovdqa64	%zmm5, 12736(%rsp,%rbx)
	vpsrlq	$32, %zmm4, %zmm4
	vpsrlq	$32, %zmm3, %zmm3
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %edx
	jne	.LBB2_53
# %bb.54:                               # %for_test228.for_exit231_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_23 Depth=1
	testb	$1, %r13b
	jne	.LBB2_55
	jmp	.LBB2_56
.LBB2_57:                               # %for_test261.preheader
	testl	%r13d, %r13d
	je	.LBB2_68
# %bb.58:                               # %for_loop262.lr.ph
	movl	%r13d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB2_62
# %bb.59:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB2_64
.LBB2_62:                               # %for_loop262.lr.ph.new
	leaq	768(%rsp), %rdx
	movl	%r13d, %esi
	subl	%ecx, %esi
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	movl	%r13d, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB2_63:                               # %for_loop262
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-320(%rdx), %zmm2, %zmm2
	vpaddq	-384(%rdx), %zmm1, %zmm1
	movl	%edi, %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, -384(%rdx)
	vmovdqa64	%zmm3, -320(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	-192(%rdx), %zmm2, %zmm2
	vpaddq	-256(%rdx), %zmm1, %zmm1
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, -256(%rdx)
	vmovdqa64	%zmm3, -192(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	-64(%rdx), %zmm2, %zmm2
	vpaddq	-128(%rdx), %zmm1, %zmm1
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, -128(%rdx)
	vmovdqa64	%zmm3, -64(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	64(%rdx), %zmm2, %zmm2
	vpaddq	(%rdx), %zmm1, %zmm1
	leal	3(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, (%rdx)
	vmovdqa64	%zmm3, 64(%rdx)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm1, %zmm1
	addq	$4, %rax
	addq	$512, %rdx              # imm = 0x200
	addl	$4, %edi
	cmpl	%eax, %esi
	jne	.LBB2_63
.LBB2_64:                               # %for_test261.for_exit264_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB2_67
# %bb.65:                               # %for_loop262.epil.preheader
	leal	(%rax,%r13), %edx
	shlq	$7, %rax
	addq	%rsp, %rax
	addq	$384, %rax              # imm = 0x180
	.p2align	4, 0x90
.LBB2_66:                               # %for_loop262.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	64(%rax), %zmm2, %zmm2
	vpaddq	(%rax), %zmm1, %zmm1
	movl	%edx, %esi
	shlq	$7, %rsi
	vpaddq	12672(%rsp,%rsi), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rsi), %zmm2, %zmm2
	vpandd	%zmm0, %zmm1, %zmm3
	vmovdqa64	%zmm3, (%rax)
	vpandd	%zmm0, %zmm2, %zmm3
	vmovdqa64	%zmm3, 64(%rax)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm1, %zmm1
	addl	$1, %edx
	subq	$-128, %rax
	addl	$-1, %ecx
	jne	.LBB2_66
.LBB2_67:                               # %for_test261.for_exit264_crit_edge
	vptestmq	%zmm1, %zmm1, %k0
	vptestmq	%zmm2, %zmm2, %k1
	kunpckbw	%k0, %k1, %k1
.LBB2_68:                               # %for_exit264
	kandw	%k5, %k1, %k0
	kortestw	%k0, %k0
	je	.LBB2_74
# %bb.69:                               # %for_exit264
	testl	%r13d, %r13d
	je	.LBB2_74
# %bb.70:                               # %for_loop297.lr.ph
	cmpl	$1, %r13d
	kshiftrw	$8, %k1, %k2
	jne	.LBB2_85
# %bb.71:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB2_73
.LBB2_85:                               # %for_loop297.lr.ph.new
	movl	$32, %eax
	subl	32(%rsp), %eax          # 4-byte Folded Reload
	vpbroadcastd	%eax, %zmm0
	movl	%r13d, %ecx
	andl	$1, %ecx
	movl	%r13d, %edx
	subl	%ecx, %edx
	vpxor	%xmm2, %xmm2, %xmm2
	movl	$64, %esi
	xorl	%eax, %eax
	vpbroadcastq	.LCPI2_1(%rip), %zmm3 # zmm3 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_86:                               # %for_loop297
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa64	8512(%rsp,%rsi), %zmm5
	vpsllvd	%zmm11, %zmm5, %zmm6
	vpord	%zmm2, %zmm6, %zmm2
	vpsrlvd	%zmm0, %zmm5, %zmm5
	vpmovzxdq	%ymm2, %zmm6    # zmm6 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	256(%rsp,%rsi,2), %zmm7
	vmovdqa64	320(%rsp,%rsi,2), %zmm8
	vmovdqa64	384(%rsp,%rsi,2), %zmm9
	vmovdqa64	448(%rsp,%rsi,2), %zmm10
	vpsubq	%zmm2, %zmm8, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vpsubq	%zmm6, %zmm7, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpandq	%zmm3, %zmm2, %zmm8 {%k2}
	vpandq	%zmm3, %zmm1, %zmm7 {%k1}
	vmovdqa64	%zmm7, 256(%rsp,%rsi,2)
	vmovdqa64	%zmm8, 320(%rsp,%rsi,2)
	vmovdqa64	8576(%rsp,%rsi), %zmm4
	vpsllvd	%zmm11, %zmm4, %zmm6
	vpsraq	$32, %zmm2, %zmm7
	vpsrlvd	%zmm0, %zmm4, %zmm2
	vpsraq	$32, %zmm1, %zmm1
	vpord	%zmm5, %zmm6, %zmm4
	vpmovzxdq	%ymm4, %zmm5    # zmm5 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vextracti64x4	$1, %zmm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpsubq	%zmm4, %zmm10, %zmm4
	vpaddq	%zmm7, %zmm4, %zmm4
	vpsubq	%zmm5, %zmm9, %zmm5
	vpaddq	%zmm1, %zmm5, %zmm1
	vpandq	%zmm3, %zmm1, %zmm9 {%k1}
	vmovdqa64	%zmm9, 384(%rsp,%rsi,2)
	vpandq	%zmm3, %zmm4, %zmm10 {%k2}
	vmovdqa64	%zmm10, 448(%rsp,%rsi,2)
	vpsraq	$32, %zmm4, %zmm4
	vpsraq	$32, %zmm1, %zmm1
	addq	$2, %rax
	subq	$-128, %rsi
	cmpl	%eax, %edx
	jne	.LBB2_86
# %bb.72:                               # %for_test296.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB2_74
.LBB2_73:                               # %for_loop297.epil.preheader
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm0
	vmovdqa64	448(%rsp,%rcx), %zmm3
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm5
	vpsllvd	%zmm11, %zmm5, %zmm5
	vpord	%zmm2, %zmm5, %zmm2
	vpmovzxdq	%ymm2, %zmm5    # zmm5 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vpsubq	%zmm2, %zmm3, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vpsubq	%zmm5, %zmm0, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpbroadcastq	.LCPI2_1(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandq	%zmm4, %zmm2, %zmm3 {%k2}
	vpandq	%zmm4, %zmm1, %zmm0 {%k1}
	vmovdqa64	%zmm0, 384(%rsp,%rcx)
	vmovdqa64	%zmm3, 448(%rsp,%rcx)
.LBB2_74:                               # %safe_if_after_true
	leal	-1(%r13), %eax
	shlq	$7, %rax
	vmovdqa64	384(%rsp,%rax), %zmm0
	vmovdqa64	448(%rsp,%rax), %zmm1
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kandw	%k5, %k1, %k0
	vpcmpeqd	%xmm2, %xmm2, %xmm2
	kortestw	%k0, %k0
	je	.LBB2_79
# %bb.75:                               # %for_test355.preheader
	xorl	%eax, %eax
	cmpl	%r13d, %eax
	movl	$0, %ecx
	sbbw	%cx, %cx
	kmovw	%ecx, %k0
	kandw	%k0, %k1, %k2
	kandw	%k5, %k2, %k0
	kortestw	%k0, %k0
	je	.LBB2_79
# %bb.76:                               # %for_loop356.preheader
	vpbroadcastd	.LCPI2_2(%rip), %zmm2 # zmm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	kxnorw	%k0, %k0, %k3
	.p2align	4, 0x90
.LBB2_77:                               # %for_loop356
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vmovdqa64	8576(%rsp,%rdx), %zmm3
	vpaddd	%zmm2, %zmm3, %zmm4
	vpcmpltud	%zmm3, %zmm4, %k4
	vpternlogd	$255, %zmm3, %zmm3, %zmm3 {%k4}{z}
	vpsrld	$31, %zmm3, %zmm2 {%k2}
	shlq	$7, %rcx
	vextracti64x4	$1, %zmm4, %ymm3
	vpmovzxdq	%ymm3, %zmm3    # zmm3 = ymm3[0],zero,ymm3[1],zero,ymm3[2],zero,ymm3[3],zero,ymm3[4],zero,ymm3[5],zero,ymm3[6],zero,ymm3[7],zero
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpcmpneqq	384(%rsp,%rcx), %zmm4, %k0
	vpcmpneqq	448(%rsp,%rcx), %zmm3, %k4
	kunpckbw	%k0, %k4, %k0
	kandw	%k2, %k0, %k0
	kxorw	%k3, %k0, %k3
	addl	$1, %eax
	cmpl	%r13d, %eax
	sbbw	%cx, %cx
	kmovw	%ecx, %k0
	kandw	%k0, %k2, %k0
	kandw	%k0, %k3, %k2
	kandw	%k5, %k2, %k0
	kortestw	%k0, %k0
	jne	.LBB2_77
# %bb.78:                               # %for_test355.safe_if_after_true347.loopexit_crit_edge
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k3}{z}
	vpmovdb	%zmm2, %xmm2
.LBB2_79:                               # %safe_if_after_true347
	vptestnmq	%zmm0, %zmm0, %k0
	vptestnmq	%zmm1, %zmm1, %k2
	kunpckbw	%k0, %k2, %k0
	kandw	%k5, %k0, %k2
	kortestw	%k2, %k2
	je	.LBB2_84
# %bb.80:                               # %safe_if_run_false413
	vpbroadcastq	.LCPI2_3(%rip), %zmm0 # zmm0 = [1,1,1,1,1,1,1,1]
	vpcmpeqq	384(%rsp), %zmm0, %k2
	vpcmpeqq	448(%rsp), %zmm0, %k3
	kunpckbw	%k2, %k3, %k2
	vpmovsxbd	%xmm2, %zmm0
	vpslld	$31, %zmm0, %zmm0
	kandnw	%k2, %k1, %k2
	vptestmd	%zmm0, %zmm0, %k1 {%k1}
	korw	%k2, %k1, %k1
	xorl	%eax, %eax
	cmpl	$1, %r13d
	movl	$65535, %ecx            # imm = 0xFFFF
	cmovbel	%eax, %ecx
	kmovw	%ecx, %k2
	kandw	%k0, %k1, %k0
	kandw	%k2, %k0, %k0
	kandw	%k5, %k0, %k2
	kortestw	%k2, %k2
	je	.LBB2_83
# %bb.81:                               # %for_loop429.preheader
	movl	$1, %eax
	.p2align	4, 0x90
.LBB2_82:                               # %for_loop429
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm0
	vmovdqa64	448(%rsp,%rcx), %zmm1
	vptestmq	%zmm0, %zmm0, %k2
	vptestmq	%zmm1, %zmm1, %k3
	kunpckbw	%k2, %k3, %k2
	kandw	%k0, %k2, %k2
	kxorw	%k1, %k2, %k1
	addl	$1, %eax
	cmpl	%r13d, %eax
	sbbw	%cx, %cx
	kmovw	%ecx, %k2
	kandw	%k2, %k0, %k0
	kandw	%k0, %k1, %k0
	kandw	%k5, %k0, %k2
	kortestw	%k2, %k2
	jne	.LBB2_82
.LBB2_83:                               # %if_done346.loopexit
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm2
.LBB2_84:                               # %if_done346
	movq	40(%rsp), %rax          # 8-byte Reload
	vpand	.LCPI2_4(%rip), %xmm2, %xmm0
	vpmovzxbd	%xmm0, %zmm0    # zmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[9],zero,zero,zero,xmm0[10],zero,zero,zero,xmm0[11],zero,zero,zero,xmm0[12],zero,zero,zero,xmm0[13],zero,zero,zero,xmm0[14],zero,zero,zero,xmm0[15],zero,zero,zero
	vmovdqu32	%zmm0, (%rax) {%k5}
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end2:
	.size	fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu, .Lfunc_end2-fermat_test512___un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_un_3C_unu_3E_unuunu
                                        # -- End function
	.section	.rodata,"a",@progbits
	.p2align	6               # -- Begin function fermat_test512
.LCPI3_0:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
	.long	8                       # 0x8
	.long	9                       # 0x9
	.long	10                      # 0xa
	.long	11                      # 0xb
	.long	12                      # 0xc
	.long	13                      # 0xd
	.long	14                      # 0xe
	.long	15                      # 0xf
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI3_1:
	.quad	4294967295              # 0xffffffff
.LCPI3_3:
	.quad	1                       # 0x1
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2
.LCPI3_2:
	.long	1                       # 0x1
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI3_4:
	.zero	16,1
	.text
	.globl	fermat_test512
	.p2align	4, 0x90
	.type	fermat_test512,@function
fermat_test512:                            # @fermat_test512
# %bb.0:                                # %allocas
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-128, %rsp
	subq	$45568, %rsp            # imm = 0xB200
	movl	%r9d, 32(%rsp)          # 4-byte Spill
	movl	%r8d, %r13d
	movq	%rcx, 40(%rsp)          # 8-byte Spill
	testl	%r8d, %r8d
	je	.LBB3_7
# %bb.1:                                # %for_loop.lr.ph
	vpbroadcastd	%r13d, %zmm0
	vpmulld	.LCPI3_0(%rip), %zmm0, %zmm0
	cmpl	$1, %r13d
	jne	.LBB3_3
# %bb.2:
	xorl	%eax, %eax
	jmp	.LBB3_6
.LBB3_3:                                # %for_loop.lr.ph.new
	movl	%r13d, %r8d
	andl	$1, %r8d
	movl	%r13d, %r9d
	subl	%r8d, %r9d
	movl	$64, %ecx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB3_4:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vpbroadcastd	%eax, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k1}
	vmovdqa64	%zmm2, 8512(%rsp,%rcx)
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k1}
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm2, 320(%rsp,%rcx,2)
	vmovdqa64	%zmm1, 256(%rsp,%rcx,2)
	leal	1(%rax), %ebx
	vpbroadcastd	%ebx, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k1}
	vmovdqa64	%zmm2, 8576(%rsp,%rcx)
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k1}
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm2, 448(%rsp,%rcx,2)
	vmovdqa64	%zmm1, 384(%rsp,%rcx,2)
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %r9d
	jne	.LBB3_4
# %bb.5:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB3_7
.LBB3_6:                                # %for_loop.epil.preheader
	movq	%rax, %rcx
	shlq	$6, %rcx
	vpbroadcastd	%eax, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm0
	vpslld	$2, %zmm0, %zmm0
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	kxnorw	%k0, %k0, %k2
	vpgatherdd	(%rdi,%zmm0), %zmm2 {%k2}
	vmovdqa64	%zmm2, 8576(%rsp,%rcx)
	shlq	$7, %rax
	vpgatherdd	(%rdx,%zmm0), %zmm1 {%k1}
	vpmovzxdq	%ymm1, %zmm0    # zmm0 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vextracti64x4	$1, %zmm1, %ymm1
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vmovdqa64	%zmm1, 448(%rsp,%rax)
	vmovdqa64	%zmm0, 384(%rsp,%rax)
.LBB3_7:                                # %for_exit
	xorl	%ecx, %ecx
	movl	32(%rsp), %edx          # 4-byte Reload
	cmpl	$23, %edx
	seta	%cl
	movl	%r13d, %eax
	subl	%ecx, %eax
	vmovdqu64	(%rsi), %zmm12
	testl	%eax, %eax
	vpbroadcastd	%edx, %zmm11
	movl	%r13d, %r14d
	jle	.LBB3_15
# %bb.8:                                # %for_loop35.lr.ph
	xorl	%ecx, %ecx
	movl	32(%rsp), %esi          # 4-byte Reload
	cmpl	$24, %esi
	setb	%cl
	shll	$5, %ecx
	addl	%esi, %ecx
	addb	$-24, %cl
	movl	$-2147483648, %edx      # imm = 0x80000000
	shrxl	%ecx, %edx, %edi
	movl	$32, %ecx
	subl	%esi, %ecx
	vpbroadcastd	%ecx, %zmm13
	leal	-1(%r13), %r12d
	movl	%eax, %eax
	leaq	8640(%rsp), %r15
	movl	%r13d, %ebx
	andl	$-2, %ebx
	vpbroadcastq	.LCPI3_1(%rip), %zmm14 # zmm14 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vmovdqa64	%zmm11, 256(%rsp) # 64-byte Spill
	vmovdqa64	%zmm12, 192(%rsp) # 64-byte Spill
	vmovdqa64	%zmm13, 128(%rsp) # 64-byte Spill
	vmovdqa64	%zmm14, 64(%rsp) # 64-byte Spill
	jmp	.LBB3_9
	.p2align	4, 0x90
.LBB3_14:                               # %for_test34.loopexit
                                        #   in Loop: Header=BB3_9 Depth=1
	movl	$-2147483648, %edi      # imm = 0x80000000
	cmpq	$1, 56(%rsp)            # 8-byte Folded Reload
	movq	48(%rsp), %rax          # 8-byte Reload
	jle	.LBB3_15
.LBB3_9:                                # %for_loop35
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_12 Depth 2
                                        #       Child Loop BB3_26 Depth 3
                                        #         Child Loop BB3_29 Depth 4
                                        #       Child Loop BB3_49 Depth 3
                                        #       Child Loop BB3_41 Depth 3
                                        #         Child Loop BB3_44 Depth 4
                                        #       Child Loop BB3_50 Depth 3
	movq	%rax, 56(%rsp)          # 8-byte Spill
	leaq	-1(%rax), %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	movq	%rcx, 48(%rsp)          # 8-byte Spill
	testq	%rcx, %rcx
	vpternlogd	$255, %zmm0, %zmm0, %zmm0
	je	.LBB3_11
# %bb.10:                               # %for_loop35
                                        #   in Loop: Header=BB3_9 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB3_11:                               # %for_loop35
                                        #   in Loop: Header=BB3_9 Depth=1
	vpaddd	8576(%rsp,%rax), %zmm0, %zmm0
	vmovdqa64	%zmm0, 320(%rsp) # 64-byte Spill
	jmp	.LBB3_12
	.p2align	4, 0x90
.LBB3_51:                               # %for_exit135
                                        #   in Loop: Header=BB3_12 Depth=2
	shrl	%edi
	je	.LBB3_14
.LBB3_12:                               # %do_loop
                                        #   Parent Loop BB3_9 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_26 Depth 3
                                        #         Child Loop BB3_29 Depth 4
                                        #       Child Loop BB3_49 Depth 3
                                        #       Child Loop BB3_41 Depth 3
                                        #         Child Loop BB3_44 Depth 4
                                        #       Child Loop BB3_50 Depth 3
	movl	%edi, 36(%rsp)          # 4-byte Spill
	leaq	29056(%rsp), %rdi
	leaq	384(%rsp), %rsi
	movl	%r13d, %edx
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	testl	%r13d, %r13d
	je	.LBB3_13
# %bb.25:                               # %for_loop67.lr.ph.us.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa64	256(%rsp), %zmm11 # 64-byte Reload
	vmovdqa64	192(%rsp), %zmm12 # 64-byte Reload
	vmovdqa64	128(%rsp), %zmm13 # 64-byte Reload
	vmovdqa64	64(%rsp), %zmm14 # 64-byte Reload
	jmp	.LBB3_26
	.p2align	4, 0x90
.LBB3_27:                               #   in Loop: Header=BB3_26 Depth=3
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%esi, %esi
.LBB3_31:                               # %for_loop67.us.epil.preheader
                                        #   in Loop: Header=BB3_26 Depth=3
	movq	%rsi, %rdx
	shlq	$6, %rdx
	vpmovzxdq	8576(%rsp,%rdx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8608(%rsp,%rdx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm0
	vpmuludq	%zmm1, %zmm4, %zmm1
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29120(%rsp,%rsi), %zmm3, %zmm3
	vpaddq	%zmm0, %zmm3, %zmm0
	vpaddq	29056(%rsp,%rsi), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	vpandd	%zmm14, %zmm0, %zmm2
	vpandd	%zmm14, %zmm1, %zmm3
	vmovdqa64	%zmm3, 29056(%rsp,%rsi)
	vmovdqa64	%zmm2, 29120(%rsp,%rsi)
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm2
.LBB3_32:                               # %for_exit69.us
                                        #   in Loop: Header=BB3_26 Depth=3
	vmovdqa64	%zmm3, 448(%rsp,%r8)
	vmovdqa64	%zmm2, 384(%rsp,%r8)
	addq	$1, %rcx
	addq	$1, %rax
	cmpq	%r14, %rcx
	je	.LBB3_33
.LBB3_26:                               # %for_loop67.lr.ph.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_29 Depth 4
	movq	%rcx, %r8
	shlq	$7, %r8
	vmovdqa64	29056(%rsp,%r8), %zmm0
	vmovdqa64	29120(%rsp,%r8), %zmm1
	vpmovqd	%zmm0, %ymm0
	vpmovqd	%zmm1, %ymm1
	vinserti64x4	$1, %ymm1, %zmm0, %zmm0
	vpmulld	%zmm0, %zmm12, %zmm1
	vextracti64x4	$1, %zmm1, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpxor	%xmm2, %xmm2, %xmm2
	testl	%r12d, %r12d
	je	.LBB3_27
# %bb.28:                               # %for_loop67.lr.ph.us.new
                                        #   in Loop: Header=BB3_26 Depth=3
	movq	%r15, %rdi
	xorl	%esi, %esi
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_29:                               # %for_loop67.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        #       Parent Loop BB3_26 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-32(%rdi), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-64(%rdi), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm5
	vpmuludq	%zmm0, %zmm4, %zmm4
	leal	(%rcx,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpaddq	%zmm5, %zmm2, %zmm2
	vpaddq	%zmm4, %zmm3, %zmm3
	vpandd	%zmm14, %zmm2, %zmm4
	vpandd	%zmm14, %zmm3, %zmm5
	vmovdqa64	%zmm5, 29120(%rsp,%rdx)
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpsrlq	$32, %zmm2, %zmm2
	vpmovzxdq	(%rdi), %zmm4   # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	32(%rdi), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm5
	leal	(%rax,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpmuludq	%zmm1, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vpandd	%zmm14, %zmm2, %zmm4
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpandd	%zmm14, %zmm3, %zmm4
	vmovdqa64	%zmm4, 29120(%rsp,%rdx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %ebx
	jne	.LBB3_29
# %bb.30:                               # %for_test66.for_exit69_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_26 Depth=3
	testb	$1, %r13b
	jne	.LBB3_31
	jmp	.LBB3_32
	.p2align	4, 0x90
.LBB3_33:                               # %for_test96.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	testl	%r13d, %r13d
	je	.LBB3_34
# %bb.35:                               # %for_loop97.lr.ph
                                        #   in Loop: Header=BB3_12 Depth=2
	movl	36(%rsp), %edi          # 4-byte Reload
	vpbroadcastd	%edi, %zmm0
	vptestmd	320(%rsp), %zmm0, %k1 # 64-byte Folded Reload
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm2
	kshiftrw	$8, %k1, %k1
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm3
	vpxor	%xmm0, %xmm0, %xmm0
	testl	%r12d, %r12d
	je	.LBB3_36
# %bb.48:                               # %for_loop97.lr.ph.new
                                        #   in Loop: Header=BB3_12 Depth=2
	movl	%r13d, %ecx
	leaq	512(%rsp), %rdx
	xorl	%eax, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB3_49:                               # %for_loop97
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%ecx, %esi
	shlq	$7, %rsi
	vmovdqa64	29056(%rsp,%rsi), %zmm4
	vmovdqa64	29120(%rsp,%rsi), %zmm5
	vpaddq	-64(%rdx), %zmm5, %zmm5
	vpaddq	-128(%rdx), %zmm4, %zmm4
	vpsllvq	%zmm2, %zmm4, %zmm4
	vpaddq	%zmm0, %zmm4, %zmm0
	vpsllvq	%zmm3, %zmm5, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpandd	%zmm14, %zmm0, %zmm4
	vpandd	%zmm14, %zmm1, %zmm5
	vmovdqa64	%zmm5, -64(%rdx)
	vmovdqa64	%zmm4, -128(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	leal	1(%rcx), %esi
	shlq	$7, %rsi
	vmovdqa64	29120(%rsp,%rsi), %zmm4
	vmovdqa64	29056(%rsp,%rsi), %zmm5
	vpaddq	(%rdx), %zmm5, %zmm5
	vpaddq	64(%rdx), %zmm4, %zmm4
	vpsllvq	%zmm3, %zmm4, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpsllvq	%zmm2, %zmm5, %zmm4
	vpaddq	%zmm0, %zmm4, %zmm0
	vpandd	%zmm14, %zmm1, %zmm4
	vpandd	%zmm14, %zmm0, %zmm5
	vmovdqa64	%zmm5, (%rdx)
	vmovdqa64	%zmm4, 64(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addq	$2, %rax
	addq	$256, %rdx              # imm = 0x100
	addl	$2, %ecx
	cmpl	%eax, %ebx
	jne	.LBB3_49
# %bb.37:                               # %for_test96.for_test132.preheader_crit_edge.unr-lcssa
                                        #   in Loop: Header=BB3_12 Depth=2
	testb	$1, %r13b
	jne	.LBB3_38
	jmp	.LBB3_39
	.p2align	4, 0x90
.LBB3_13:                               #   in Loop: Header=BB3_12 Depth=2
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa64	256(%rsp), %zmm11 # 64-byte Reload
	vmovdqa64	192(%rsp), %zmm12 # 64-byte Reload
	vmovdqa64	128(%rsp), %zmm13 # 64-byte Reload
	movl	36(%rsp), %edi          # 4-byte Reload
	vmovdqa64	64(%rsp), %zmm14 # 64-byte Reload
	jmp	.LBB3_39
	.p2align	4, 0x90
.LBB3_34:                               #   in Loop: Header=BB3_12 Depth=2
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	movl	36(%rsp), %edi          # 4-byte Reload
	jmp	.LBB3_39
.LBB3_36:                               #   in Loop: Header=BB3_12 Depth=2
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
.LBB3_38:                               # %for_loop97.epil.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	movq	%rax, %rcx
	shlq	$7, %rcx
	addl	%r13d, %eax
	shlq	$7, %rax
	vmovdqa64	29056(%rsp,%rax), %zmm4
	vmovdqa64	29120(%rsp,%rax), %zmm5
	vpaddq	384(%rsp,%rcx), %zmm4, %zmm4
	vpaddq	448(%rsp,%rcx), %zmm5, %zmm5
	vpsllvq	%zmm3, %zmm5, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	vpsllvq	%zmm2, %zmm4, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vpandd	%zmm14, %zmm1, %zmm2
	vpandd	%zmm14, %zmm0, %zmm3
	vmovdqa64	%zmm3, 384(%rsp,%rcx)
	vmovdqa64	%zmm2, 448(%rsp,%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB3_39:                               # %for_test132.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	je	.LBB3_51
# %bb.40:                               # %for_test146.preheader.lr.ph
                                        #   in Loop: Header=BB3_12 Depth=2
	testl	%r13d, %r13d
	kmovw	%k1, %k0
	jne	.LBB3_41
	.p2align	4, 0x90
.LBB3_50:                               # %for_exit149
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	kandw	%k0, %k1, %k0
	kortestw	%k0, %k0
	jne	.LBB3_50
	jmp	.LBB3_51
	.p2align	4, 0x90
.LBB3_42:                               #   in Loop: Header=BB3_41 Depth=3
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
.LBB3_46:                               # %for_loop147.us.epil.preheader
                                        #   in Loop: Header=BB3_41 Depth=3
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm5
	vmovdqa64	448(%rsp,%rcx), %zmm6
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm7
	vpsllvd	%zmm11, %zmm7, %zmm7
	vpord	%zmm4, %zmm7, %zmm4
	vpmovzxdq	%ymm4, %zmm7    # zmm7 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vextracti64x4	$1, %zmm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpsubq	%zmm4, %zmm6, %zmm4
	vpaddq	%zmm3, %zmm4, %zmm3
	vpsubq	%zmm7, %zmm5, %zmm4
	vpaddq	%zmm2, %zmm4, %zmm2
	vpandq	%zmm14, %zmm3, %zmm6 {%k2}
	vpandq	%zmm14, %zmm2, %zmm5 {%k1}
	vmovdqa64	%zmm5, 384(%rsp,%rcx)
	vmovdqa64	%zmm6, 448(%rsp,%rcx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
.LBB3_47:                               # %for_exit149.us
                                        #   in Loop: Header=BB3_41 Depth=3
	vmovdqa64	%zmm2, %zmm2 {%k1}{z}
	vpaddq	%zmm0, %zmm2, %zmm0
	vmovdqa64	%zmm3, %zmm2 {%k2}{z}
	vpaddq	%zmm1, %zmm2, %zmm1
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k2
	kunpckbw	%k0, %k2, %k0
	kandw	%k1, %k0, %k1
	kortestw	%k1, %k1
	je	.LBB3_51
.LBB3_41:                               # %for_loop147.lr.ph.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_44 Depth 4
	testl	%r12d, %r12d
	kshiftrw	$8, %k1, %k2
	je	.LBB3_42
# %bb.43:                               # %for_loop147.lr.ph.us.new
                                        #   in Loop: Header=BB3_41 Depth=3
	vpxor	%xmm4, %xmm4, %xmm4
	movl	$64, %ecx
	xorl	%eax, %eax
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_44:                               # %for_loop147.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        #       Parent Loop BB3_41 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovdqa64	8512(%rsp,%rcx), %zmm5
	vpsllvd	%zmm11, %zmm5, %zmm6
	vpord	%zmm4, %zmm6, %zmm4
	vpsrlvd	%zmm13, %zmm5, %zmm5
	vpmovzxdq	%ymm4, %zmm6    # zmm6 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vextracti64x4	$1, %zmm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vmovdqa64	256(%rsp,%rcx,2), %zmm7
	vmovdqa64	320(%rsp,%rcx,2), %zmm8
	vmovdqa64	384(%rsp,%rcx,2), %zmm9
	vmovdqa64	448(%rsp,%rcx,2), %zmm10
	vpsubq	%zmm4, %zmm8, %zmm4
	vpaddq	%zmm3, %zmm4, %zmm3
	vpsubq	%zmm6, %zmm7, %zmm4
	vpaddq	%zmm2, %zmm4, %zmm2
	vpandq	%zmm14, %zmm3, %zmm8 {%k2}
	vpandq	%zmm14, %zmm2, %zmm7 {%k1}
	vmovdqa64	%zmm7, 256(%rsp,%rcx,2)
	vmovdqa64	%zmm8, 320(%rsp,%rcx,2)
	vmovdqa64	8576(%rsp,%rcx), %zmm4
	vpsllvd	%zmm11, %zmm4, %zmm6
	vpsraq	$32, %zmm3, %zmm3
	vpsrlvd	%zmm13, %zmm4, %zmm4
	vpsraq	$32, %zmm2, %zmm2
	vpord	%zmm5, %zmm6, %zmm5
	vpmovzxdq	%ymm5, %zmm6    # zmm6 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vextracti64x4	$1, %zmm5, %ymm5
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpsubq	%zmm5, %zmm10, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	%zmm6, %zmm9, %zmm5
	vpaddq	%zmm2, %zmm5, %zmm2
	vpandq	%zmm14, %zmm2, %zmm9 {%k1}
	vmovdqa64	%zmm9, 384(%rsp,%rcx,2)
	vpandq	%zmm14, %zmm3, %zmm10 {%k2}
	vmovdqa64	%zmm10, 448(%rsp,%rcx,2)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm2
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %ebx
	jne	.LBB3_44
# %bb.45:                               # %for_test146.for_exit149_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_41 Depth=3
	testb	$1, %r13b
	jne	.LBB3_46
	jmp	.LBB3_47
.LBB3_15:                               # %for_test194.preheader
	kxorw	%k0, %k0, %k1
	testl	%r13d, %r13d
	je	.LBB3_68
# %bb.16:                               # %for_loop195.lr.ph
	leal	-1(%r13), %r8d
	movl	%r13d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB3_60
# %bb.17:
	xorl	%edx, %edx
	jmp	.LBB3_18
.LBB3_60:                               # %for_loop195.lr.ph.new
	movl	%r13d, %eax
	subl	%ecx, %eax
	movl	$384, %esi              # imm = 0x180
	xorl	%edx, %edx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_61:                               # %for_loop195
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	(%rsp,%rsi), %zmm1
	vmovaps	64(%rsp,%rsi), %zmm2
	vmovdqa64	128(%rsp,%rsi), %zmm3
	vmovaps	%zmm1, 12288(%rsp,%rsi)
	vmovaps	192(%rsp,%rsi), %zmm1
	vmovaps	%zmm2, 12352(%rsp,%rsi)
	leaq	(%r14,%rdx), %rdi
	movl	%edi, %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovdqa64	%zmm3, 12416(%rsp,%rsi)
	vmovaps	%zmm1, 12480(%rsp,%rsi)
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovaps	320(%rsp,%rsi), %zmm1
	vmovaps	256(%rsp,%rsi), %zmm2
	vmovaps	%zmm2, 12544(%rsp,%rsi)
	vmovaps	%zmm1, 12608(%rsp,%rsi)
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovdqa64	448(%rsp,%rsi), %zmm1
	vmovdqa64	384(%rsp,%rsi), %zmm2
	vmovdqa64	%zmm2, 12672(%rsp,%rsi)
	vmovdqa64	%zmm1, 12736(%rsp,%rsi)
	addl	$3, %edi
	shlq	$7, %rdi
	vmovdqa64	%zmm0, 12672(%rsp,%rdi)
	vmovdqa64	%zmm0, 12736(%rsp,%rdi)
	addq	$4, %rdx
	addq	$512, %rsi              # imm = 0x200
	cmpl	%edx, %eax
	jne	.LBB3_61
.LBB3_18:                               # %for_test194.for_test212.preheader_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB3_21
# %bb.19:                               # %for_loop195.epil.preheader
	leal	(%rdx,%r13), %eax
	shlq	$7, %rdx
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_20:                               # %for_loop195.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa64	384(%rsp,%rdx), %zmm1
	vmovdqa64	448(%rsp,%rdx), %zmm2
	vmovdqa64	%zmm1, 12672(%rsp,%rdx)
	vmovdqa64	%zmm2, 12736(%rsp,%rdx)
	movl	%eax, %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	addl	$1, %eax
	subq	$-128, %rdx
	addl	$-1, %ecx
	jne	.LBB3_20
.LBB3_21:                               # %for_test212.preheader
	testl	%r13d, %r13d
	je	.LBB3_68
# %bb.22:                               # %for_loop213.lr.ph.split.us
	leaq	8640(%rsp), %r9
	movl	%r13d, %edx
	andl	$-2, %edx
	movl	$1, %esi
	xorl	%edi, %edi
	vpbroadcastq	.LCPI3_1(%rip), %zmm0 # zmm0 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	jmp	.LBB3_23
	.p2align	4, 0x90
.LBB3_24:                               #   in Loop: Header=BB3_23 Depth=1
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
.LBB3_55:                               # %for_loop229.us.epil.preheader
                                        #   in Loop: Header=BB3_23 Depth=1
	movq	%rax, %rcx
	shlq	$6, %rcx
	vpmovzxdq	8576(%rsp,%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8608(%rsp,%rcx), %zmm6 # zmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm6, %zmm1
	vpmuludq	%zmm2, %zmm5, %zmm2
	addl	%edi, %eax
	shlq	$7, %rax
	vpaddq	12736(%rsp,%rax), %zmm4, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpaddq	12672(%rsp,%rax), %zmm3, %zmm3
	vpaddq	%zmm2, %zmm3, %zmm2
	vpandd	%zmm0, %zmm1, %zmm3
	vpandd	%zmm0, %zmm2, %zmm4
	vmovdqa64	%zmm4, 12672(%rsp,%rax)
	vmovdqa64	%zmm3, 12736(%rsp,%rax)
	vpsrlq	$32, %zmm1, %zmm4
	vpsrlq	$32, %zmm2, %zmm3
.LBB3_56:                               # %for_exit231.us
                                        #   in Loop: Header=BB3_23 Depth=1
	vmovdqa64	%zmm4, 448(%rsp,%r10)
	vmovdqa64	%zmm3, 384(%rsp,%r10)
	addq	$1, %rdi
	addq	$1, %rsi
	cmpq	%r14, %rdi
	je	.LBB3_57
.LBB3_23:                               # %for_loop229.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_53 Depth 2
	movq	%rdi, %r10
	shlq	$7, %r10
	vmovdqa64	12672(%rsp,%r10), %zmm1
	vmovdqa64	12736(%rsp,%r10), %zmm2
	vpmovqd	%zmm1, %ymm1
	vpmovqd	%zmm2, %ymm2
	vinserti64x4	$1, %ymm2, %zmm1, %zmm1
	vpmulld	%zmm1, %zmm12, %zmm2
	vextracti64x4	$1, %zmm2, %ymm1
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vpxor	%xmm3, %xmm3, %xmm3
	cmpl	$1, %r13d
	je	.LBB3_24
# %bb.52:                               # %for_loop229.lr.ph.us.new
                                        #   in Loop: Header=BB3_23 Depth=1
	movq	%r9, %rcx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB3_53:                               # %for_loop229.us
                                        #   Parent Loop BB3_23 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-32(%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-64(%rcx), %zmm6 # zmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm2, %zmm6, %zmm6
	vpmuludq	%zmm1, %zmm5, %zmm5
	leal	(%rdi,%rax), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm3, %zmm3
	vpaddq	12736(%rsp,%rbx), %zmm4, %zmm4
	vpaddq	%zmm6, %zmm3, %zmm3
	vpaddq	%zmm5, %zmm4, %zmm4
	vpandd	%zmm0, %zmm3, %zmm5
	vpandd	%zmm0, %zmm4, %zmm6
	vmovdqa64	%zmm6, 12736(%rsp,%rbx)
	vmovdqa64	%zmm5, 12672(%rsp,%rbx)
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	(%rcx), %zmm5   # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm4, %zmm4
	vpmovzxdq	32(%rcx), %zmm6 # zmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm6, %zmm6
	leal	(%rsi,%rax), %ebx
	shlq	$7, %rbx
	vpaddq	12736(%rsp,%rbx), %zmm4, %zmm4
	vpmuludq	%zmm2, %zmm5, %zmm5
	vpaddq	%zmm6, %zmm4, %zmm4
	vpaddq	12672(%rsp,%rbx), %zmm3, %zmm3
	vpaddq	%zmm5, %zmm3, %zmm3
	vpandd	%zmm0, %zmm3, %zmm5
	vmovdqa64	%zmm5, 12672(%rsp,%rbx)
	vpandd	%zmm0, %zmm4, %zmm5
	vmovdqa64	%zmm5, 12736(%rsp,%rbx)
	vpsrlq	$32, %zmm4, %zmm4
	vpsrlq	$32, %zmm3, %zmm3
	addq	$2, %rax
	subq	$-128, %rcx
	cmpl	%eax, %edx
	jne	.LBB3_53
# %bb.54:                               # %for_test228.for_exit231_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_23 Depth=1
	testb	$1, %r13b
	jne	.LBB3_55
	jmp	.LBB3_56
.LBB3_57:                               # %for_test261.preheader
	testl	%r13d, %r13d
	je	.LBB3_68
# %bb.58:                               # %for_loop262.lr.ph
	movl	%r13d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r8d
	jae	.LBB3_62
# %bb.59:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB3_64
.LBB3_62:                               # %for_loop262.lr.ph.new
	leaq	768(%rsp), %rdx
	movl	%r13d, %esi
	subl	%ecx, %esi
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	movl	%r13d, %edi
	vpxor	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB3_63:                               # %for_loop262
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	-320(%rdx), %zmm2, %zmm2
	vpaddq	-384(%rdx), %zmm1, %zmm1
	movl	%edi, %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, -384(%rdx)
	vmovdqa64	%zmm3, -320(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	-192(%rdx), %zmm2, %zmm2
	vpaddq	-256(%rdx), %zmm1, %zmm1
	leal	1(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, -256(%rdx)
	vmovdqa64	%zmm3, -192(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	-64(%rdx), %zmm2, %zmm2
	vpaddq	-128(%rdx), %zmm1, %zmm1
	leal	2(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, -128(%rdx)
	vmovdqa64	%zmm3, -64(%rdx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	64(%rdx), %zmm2, %zmm2
	vpaddq	(%rdx), %zmm1, %zmm1
	leal	3(%rdi), %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm2, %zmm2
	vpandd	%zmm0, %zmm2, %zmm3
	vpandd	%zmm0, %zmm1, %zmm4
	vmovdqa64	%zmm4, (%rdx)
	vmovdqa64	%zmm3, 64(%rdx)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm1, %zmm1
	addq	$4, %rax
	addq	$512, %rdx              # imm = 0x200
	addl	$4, %edi
	cmpl	%eax, %esi
	jne	.LBB3_63
.LBB3_64:                               # %for_test261.for_exit264_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB3_67
# %bb.65:                               # %for_loop262.epil.preheader
	leal	(%rax,%r13), %edx
	shlq	$7, %rax
	addq	%rsp, %rax
	addq	$384, %rax              # imm = 0x180
	.p2align	4, 0x90
.LBB3_66:                               # %for_loop262.epil
                                        # =>This Inner Loop Header: Depth=1
	vpaddq	64(%rax), %zmm2, %zmm2
	vpaddq	(%rax), %zmm1, %zmm1
	movl	%edx, %esi
	shlq	$7, %rsi
	vpaddq	12672(%rsp,%rsi), %zmm1, %zmm1
	vpaddq	12736(%rsp,%rsi), %zmm2, %zmm2
	vpandd	%zmm0, %zmm1, %zmm3
	vmovdqa64	%zmm3, (%rax)
	vpandd	%zmm0, %zmm2, %zmm3
	vmovdqa64	%zmm3, 64(%rax)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm1, %zmm1
	addl	$1, %edx
	subq	$-128, %rax
	addl	$-1, %ecx
	jne	.LBB3_66
.LBB3_67:                               # %for_test261.for_exit264_crit_edge
	vptestmq	%zmm1, %zmm1, %k0
	vptestmq	%zmm2, %zmm2, %k1
	kunpckbw	%k0, %k1, %k1
.LBB3_68:                               # %for_exit264
	kortestw	%k1, %k1
	je	.LBB3_74
# %bb.69:                               # %for_exit264
	testl	%r13d, %r13d
	je	.LBB3_74
# %bb.70:                               # %for_loop297.lr.ph
	cmpl	$1, %r13d
	kshiftrw	$8, %k1, %k2
	jne	.LBB3_85
# %bb.71:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB3_73
.LBB3_85:                               # %for_loop297.lr.ph.new
	movl	$32, %eax
	subl	32(%rsp), %eax          # 4-byte Folded Reload
	vpbroadcastd	%eax, %zmm0
	movl	%r13d, %ecx
	andl	$1, %ecx
	movl	%r13d, %edx
	subl	%ecx, %edx
	vpxor	%xmm2, %xmm2, %xmm2
	movl	$64, %esi
	xorl	%eax, %eax
	vpbroadcastq	.LCPI3_1(%rip), %zmm3 # zmm3 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB3_86:                               # %for_loop297
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa64	8512(%rsp,%rsi), %zmm5
	vpsllvd	%zmm11, %zmm5, %zmm6
	vpord	%zmm2, %zmm6, %zmm2
	vpsrlvd	%zmm0, %zmm5, %zmm5
	vpmovzxdq	%ymm2, %zmm6    # zmm6 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	256(%rsp,%rsi,2), %zmm7
	vmovdqa64	320(%rsp,%rsi,2), %zmm8
	vmovdqa64	384(%rsp,%rsi,2), %zmm9
	vmovdqa64	448(%rsp,%rsi,2), %zmm10
	vpsubq	%zmm2, %zmm8, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vpsubq	%zmm6, %zmm7, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpandq	%zmm3, %zmm2, %zmm8 {%k2}
	vpandq	%zmm3, %zmm1, %zmm7 {%k1}
	vmovdqa64	%zmm7, 256(%rsp,%rsi,2)
	vmovdqa64	%zmm8, 320(%rsp,%rsi,2)
	vmovdqa64	8576(%rsp,%rsi), %zmm4
	vpsllvd	%zmm11, %zmm4, %zmm6
	vpsraq	$32, %zmm2, %zmm7
	vpsrlvd	%zmm0, %zmm4, %zmm2
	vpsraq	$32, %zmm1, %zmm1
	vpord	%zmm5, %zmm6, %zmm4
	vpmovzxdq	%ymm4, %zmm5    # zmm5 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vextracti64x4	$1, %zmm4, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpsubq	%zmm4, %zmm10, %zmm4
	vpaddq	%zmm7, %zmm4, %zmm4
	vpsubq	%zmm5, %zmm9, %zmm5
	vpaddq	%zmm1, %zmm5, %zmm1
	vpandq	%zmm3, %zmm1, %zmm9 {%k1}
	vmovdqa64	%zmm9, 384(%rsp,%rsi,2)
	vpandq	%zmm3, %zmm4, %zmm10 {%k2}
	vmovdqa64	%zmm10, 448(%rsp,%rsi,2)
	vpsraq	$32, %zmm4, %zmm4
	vpsraq	$32, %zmm1, %zmm1
	addq	$2, %rax
	subq	$-128, %rsi
	cmpl	%eax, %edx
	jne	.LBB3_86
# %bb.72:                               # %for_test296.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB3_74
.LBB3_73:                               # %for_loop297.epil.preheader
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm0
	vmovdqa64	448(%rsp,%rcx), %zmm3
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm5
	vpsllvd	%zmm11, %zmm5, %zmm5
	vpord	%zmm2, %zmm5, %zmm2
	vpmovzxdq	%ymm2, %zmm5    # zmm5 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vpsubq	%zmm2, %zmm3, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vpsubq	%zmm5, %zmm0, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	vpbroadcastq	.LCPI3_1(%rip), %zmm4 # zmm4 = [4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295]
	vpandq	%zmm4, %zmm2, %zmm3 {%k2}
	vpandq	%zmm4, %zmm1, %zmm0 {%k1}
	vmovdqa64	%zmm0, 384(%rsp,%rcx)
	vmovdqa64	%zmm3, 448(%rsp,%rcx)
.LBB3_74:                               # %safe_if_after_true
	leal	-1(%r13), %eax
	shlq	$7, %rax
	vmovdqa64	384(%rsp,%rax), %zmm0
	vmovdqa64	448(%rsp,%rax), %zmm1
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	vpcmpeqd	%xmm2, %xmm2, %xmm2
	kortestw	%k1, %k1
	je	.LBB3_79
# %bb.75:                               # %for_test355.preheader
	xorl	%eax, %eax
	cmpl	%r13d, %eax
	movl	$0, %ecx
	sbbw	%cx, %cx
	kmovw	%ecx, %k0
	kandw	%k0, %k1, %k2
	kortestw	%k2, %k2
	je	.LBB3_79
# %bb.76:                               # %for_loop356.preheader
	vpbroadcastd	.LCPI3_2(%rip), %zmm2 # zmm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	kxnorw	%k0, %k0, %k3
	.p2align	4, 0x90
.LBB3_77:                               # %for_loop356
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vmovdqa64	8576(%rsp,%rdx), %zmm3
	vpaddd	%zmm2, %zmm3, %zmm4
	vpcmpltud	%zmm3, %zmm4, %k4
	vpternlogd	$255, %zmm3, %zmm3, %zmm3 {%k4}{z}
	vpsrld	$31, %zmm3, %zmm2 {%k2}
	shlq	$7, %rcx
	vextracti64x4	$1, %zmm4, %ymm3
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpcmpneqq	384(%rsp,%rcx), %zmm4, %k0
	vpmovzxdq	%ymm3, %zmm3    # zmm3 = ymm3[0],zero,ymm3[1],zero,ymm3[2],zero,ymm3[3],zero,ymm3[4],zero,ymm3[5],zero,ymm3[6],zero,ymm3[7],zero
	vpcmpneqq	448(%rsp,%rcx), %zmm3, %k4
	kunpckbw	%k0, %k4, %k0
	kandw	%k2, %k0, %k0
	kxorw	%k3, %k0, %k3
	addl	$1, %eax
	cmpl	%r13d, %eax
	sbbw	%cx, %cx
	kmovw	%ecx, %k0
	kandw	%k0, %k2, %k0
	kandw	%k0, %k3, %k2
	kortestw	%k2, %k2
	jne	.LBB3_77
# %bb.78:                               # %for_test355.safe_if_after_true347.loopexit_crit_edge
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k3}{z}
	vpmovdb	%zmm2, %xmm2
.LBB3_79:                               # %safe_if_after_true347
	vptestnmq	%zmm0, %zmm0, %k0
	vptestnmq	%zmm1, %zmm1, %k2
	kunpckbw	%k0, %k2, %k0
	kortestw	%k0, %k0
	je	.LBB3_84
# %bb.80:                               # %safe_if_run_false413
	vpbroadcastq	.LCPI3_3(%rip), %zmm0 # zmm0 = [1,1,1,1,1,1,1,1]
	vpcmpeqq	384(%rsp), %zmm0, %k2
	vpcmpeqq	448(%rsp), %zmm0, %k3
	kunpckbw	%k2, %k3, %k2
	vpmovsxbd	%xmm2, %zmm0
	vpslld	$31, %zmm0, %zmm0
	kandnw	%k2, %k1, %k2
	vptestmd	%zmm0, %zmm0, %k1 {%k1}
	xorl	%eax, %eax
	cmpl	$1, %r13d
	movl	$65535, %ecx            # imm = 0xFFFF
	cmovbel	%eax, %ecx
	korw	%k2, %k1, %k1
	kmovw	%ecx, %k2
	kandw	%k0, %k1, %k0
	kandw	%k2, %k0, %k0
	kortestw	%k0, %k0
	je	.LBB3_83
# %bb.81:                               # %for_loop429.preheader
	movl	$1, %eax
	.p2align	4, 0x90
.LBB3_82:                               # %for_loop429
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm0
	vmovdqa64	448(%rsp,%rcx), %zmm1
	vptestmq	%zmm0, %zmm0, %k2
	vptestmq	%zmm1, %zmm1, %k3
	kunpckbw	%k2, %k3, %k2
	kandw	%k0, %k2, %k2
	kxorw	%k1, %k2, %k1
	addl	$1, %eax
	cmpl	%r13d, %eax
	sbbw	%cx, %cx
	kmovw	%ecx, %k2
	kandw	%k2, %k0, %k0
	kandw	%k0, %k1, %k0
	kortestw	%k0, %k0
	jne	.LBB3_82
.LBB3_83:                               # %if_done346.loopexit
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm2
.LBB3_84:                               # %if_done346
	movq	40(%rsp), %rax          # 8-byte Reload
	vpand	.LCPI3_4(%rip), %xmm2, %xmm0
	vpmovzxbd	%xmm0, %zmm0    # zmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[9],zero,zero,zero,xmm0[10],zero,zero,zero,xmm0[11],zero,zero,zero,xmm0[12],zero,zero,zero,xmm0[13],zero,zero,zero,xmm0[14],zero,zero,zero,xmm0[15],zero,zero,zero
	vmovdqu64	%zmm0, (%rax)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end3:
	.size	fermat_test512, .Lfunc_end3-fermat_test512
                                        # -- End function
	.ident	"clang version 10.0.1 (/usr/local/src/llvm/llvm-10.0/clang ef32c611aa214dea855364efd7ba451ec5ec3f74)"
	.section	".note.GNU-stack","",@progbits
