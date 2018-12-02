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
	movq	%rdx, 104(%rsp)         # 8-byte Spill
	je	.LBB0_1
# %bb.3:                                # %for_loop.lr.ph
	vmovdqu64	(%rsi), %zmm1
	vmovdqu64	64(%rsi), %zmm0
	movw	$-21846, %r9w           # imm = 0xAAAA
	kmovw	%r9d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm0 {%k1}{z}
	vmovdqa32	%zmm1, %zmm1 {%k1}{z}
	leal	-2(%rdx), %r14d
	movl	%r11d, %ecx
	andl	$3, %ecx
	cmpl	$3, %r14d
	jae	.LBB0_5
# %bb.4:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vpxor	%xmm5, %xmm5, %xmm5
	testl	%ecx, %ecx
	jne	.LBB0_8
	jmp	.LBB0_10
.LBB0_1:                                # %for_loop75.lr.ph.thread
	movl	%r11d, %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa64	%zmm0, 192(%rsp,%rax)
	vmovdqa64	%zmm0, 128(%rsp,%rax)
	movl	%edx, %r8d
	andl	$1, %r8d
	xorl	%r15d, %r15d
	xorl	%eax, %eax
	jmp	.LBB0_2
.LBB0_5:                                # %for_loop.lr.ph.new
	movl	%r11d, %r10d
	subl	%ecx, %r10d
	vpxor	%xmm2, %xmm2, %xmm2
	movl	$384, %ebx              # imm = 0x180
	xorl	%eax, %eax
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm4
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB0_6:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-256(%rsi,%rbx), %zmm6
	vmovdqu64	-192(%rsi,%rbx), %zmm7
	kmovw	%r9d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm7, %zmm7 {%k1}{z}
	vpmuludq	%zmm7, %zmm0, %zmm8
	vpaddq	%zmm5, %zmm8, %zmm5
	vpmuludq	%zmm7, %zmm3, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vmovdqa32	%zmm6, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm1, %zmm7
	vpaddq	%zmm2, %zmm7, %zmm2
	vpmuludq	%zmm6, %zmm4, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqa64	%zmm7, -192(%rsp,%rbx)
	vpaddq	%zmm2, %zmm6, %zmm2
	vmovdqa32	%zmm2, %zmm6 {%k1}{z}
	vmovdqa64	%zmm6, -256(%rsp,%rbx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm2, %zmm2
	vmovdqu64	-128(%rsi,%rbx), %zmm6
	vmovdqu64	-64(%rsi,%rbx), %zmm7
	vmovdqa32	%zmm7, %zmm7 {%k1}{z}
	vpmuludq	%zmm7, %zmm0, %zmm8
	vpmuludq	%zmm7, %zmm3, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm8, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vmovdqa32	%zmm6, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm1, %zmm7
	vpmuludq	%zmm6, %zmm4, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm6, %zmm7, %zmm6
	vpaddq	%zmm2, %zmm6, %zmm2
	vmovdqa32	%zmm5, %zmm6 {%k1}{z}
	vmovdqa64	%zmm6, -64(%rsp,%rbx)
	vmovdqa32	%zmm2, %zmm6 {%k1}{z}
	vmovdqa64	%zmm6, -128(%rsp,%rbx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm2, %zmm2
	vmovdqu64	(%rsi,%rbx), %zmm6
	vmovdqu64	64(%rsi,%rbx), %zmm7
	vmovdqa32	%zmm7, %zmm7 {%k1}{z}
	vpmuludq	%zmm7, %zmm0, %zmm8
	vpmuludq	%zmm7, %zmm3, %zmm7
	vpsllq	$32, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm8, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vmovdqa32	%zmm6, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm1, %zmm7
	vpmuludq	%zmm6, %zmm4, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm6, %zmm7, %zmm6
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqa64	%zmm7, 64(%rsp,%rbx)
	vpaddq	%zmm2, %zmm6, %zmm2
	vmovdqa32	%zmm2, %zmm6 {%k1}{z}
	vmovdqa64	%zmm6, (%rsp,%rbx)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm5, %zmm5
	addq	$4, %rax
	vmovdqu64	128(%rsi,%rbx), %zmm6
	vmovdqu64	192(%rsi,%rbx), %zmm7
	vmovdqa32	%zmm6, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm1, %zmm8
	vpmuludq	%zmm6, %zmm4, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm6, %zmm8, %zmm6
	vpaddq	%zmm2, %zmm6, %zmm2
	vmovdqa32	%zmm7, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm0, %zmm7
	vpmuludq	%zmm6, %zmm3, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm6, %zmm7, %zmm6
	vpaddq	%zmm5, %zmm6, %zmm5
	vmovdqa32	%zmm2, %zmm6 {%k1}{z}
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqa64	%zmm7, 192(%rsp,%rbx)
	vmovdqa64	%zmm6, 128(%rsp,%rbx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm2, %zmm2
	addq	$512, %rbx              # imm = 0x200
	cmpl	%eax, %r10d
	jne	.LBB0_6
# %bb.7:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	je	.LBB0_10
.LBB0_8:                                # %for_loop.epil.preheader
	shlq	$7, %rax
	negl	%ecx
	movw	$-21846, %bx            # imm = 0xAAAA
	vpsrlq	$32, %zmm1, %zmm3
	vpsrlq	$32, %zmm0, %zmm4
	.p2align	4, 0x90
.LBB0_9:                                # %for_loop.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	128(%rsi,%rax), %zmm6
	vmovdqu64	192(%rsi,%rax), %zmm7
	kmovw	%ebx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm6, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm1, %zmm8
	vpaddq	%zmm2, %zmm8, %zmm2
	vpmuludq	%zmm6, %zmm3, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm2, %zmm6, %zmm2
	vmovdqa32	%zmm7, %zmm6 {%k1}{z}
	vpmuludq	%zmm6, %zmm0, %zmm7
	vpaddq	%zmm5, %zmm7, %zmm5
	vpmuludq	%zmm6, %zmm4, %zmm6
	vpsllq	$32, %zmm6, %zmm6
	vpaddq	%zmm5, %zmm6, %zmm5
	vmovdqa32	%zmm2, %zmm6 {%k1}{z}
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqa64	%zmm7, 192(%rsp,%rax)
	vmovdqa64	%zmm6, 128(%rsp,%rax)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm2, %zmm2
	subq	$-128, %rax
	addl	$1, %ecx
	jne	.LBB0_9
.LBB0_10:                               # %for_exit
	movl	%r11d, 100(%rsp)        # 4-byte Spill
	movl	%r11d, %r15d
	movq	%r15, %rax
	shlq	$7, %rax
	vmovdqa64	%zmm5, 192(%rsp,%rax)
	vmovdqa64	%zmm2, 128(%rsp,%rax)
	cmpl	$3, %edx
	jb	.LBB0_18
# %bb.11:                               # %for_test30.preheader.lr.ph
	leal	-3(%rdx), %r9d
	movl	%edx, %eax
	movq	%rax, 120(%rsp)         # 8-byte Spill
	movq	%rsi, %rax
	subq	$-128, %rax
	movq	%rax, 112(%rsp)         # 8-byte Spill
	movl	$2, %r11d
	xorl	%eax, %eax
	movw	$-21846, %r13w          # imm = 0xAAAA
	.p2align	4, 0x90
.LBB0_12:                               # %for_loop32.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_16 Depth 2
	movl	%r14d, %ebx
	subl	%eax, %ebx
	movq	%r11, %rcx
	shlq	$7, %rcx
	vmovdqu64	-128(%rsi,%rcx), %zmm1
	vmovdqu64	-64(%rsi,%rcx), %zmm0
	kmovw	%r13d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm0 {%k1}{z}
	vmovdqa32	%zmm1, %zmm1 {%k1}{z}
	vpxor	%xmm2, %xmm2, %xmm2
	leaq	-2(%r11), %r12
	testb	$1, %bl
	movq	%r11, %rbx
	vpxor	%xmm3, %xmm3, %xmm3
	je	.LBB0_14
# %bb.13:                               # %for_loop32.prol.preheader
                                        #   in Loop: Header=BB0_12 Depth=1
	vmovdqu64	(%rsi,%rcx), %zmm2
	vmovdqu64	64(%rsi,%rcx), %zmm3
	kmovw	%r13d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm2, %zmm2 {%k1}{z}
	vpmuludq	%zmm2, %zmm1, %zmm4
	vpsrlq	$32, %zmm1, %zmm5
	vpmuludq	%zmm2, %zmm5, %zmm2
	vpsllq	$32, %zmm2, %zmm2
	vpaddq	%zmm2, %zmm4, %zmm2
	vmovdqa32	%zmm3, %zmm3 {%k1}{z}
	vpmuludq	%zmm3, %zmm0, %zmm4
	vpsrlq	$32, %zmm0, %zmm5
	vpmuludq	%zmm3, %zmm5, %zmm3
	vpsllq	$32, %zmm3, %zmm3
	vpaddq	%zmm3, %zmm4, %zmm3
	leal	(%r12,%r11), %ecx
	shlq	$7, %rcx
	vpaddq	192(%rsp,%rcx), %zmm3, %zmm3
	vpaddq	128(%rsp,%rcx), %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqa64	%zmm5, 192(%rsp,%rcx)
	vmovdqa64	%zmm4, 128(%rsp,%rcx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	leaq	1(%r11), %rbx
.LBB0_14:                               # %for_loop32.prol.loopexit.unr-lcssa
                                        #   in Loop: Header=BB0_12 Depth=1
	cmpl	%eax, %r9d
	je	.LBB0_17
# %bb.15:                               # %for_loop32.preheader
                                        #   in Loop: Header=BB0_12 Depth=1
	movq	120(%rsp), %r10         # 8-byte Reload
	subq	%rbx, %r10
	leaq	(%rbx,%rax), %r8
	shlq	$7, %rbx
	addq	112(%rsp), %rbx         # 8-byte Folded Reload
	.p2align	4, 0x90
.LBB0_16:                               # %for_loop32
                                        #   Parent Loop BB0_12 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu64	-128(%rbx), %zmm4
	vmovdqu64	-64(%rbx), %zmm5
	kmovw	%r13d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm5, %zmm5 {%k1}{z}
	vpmuludq	%zmm5, %zmm0, %zmm6
	vpsrlq	$32, %zmm0, %zmm7
	vpmuludq	%zmm5, %zmm7, %zmm5
	vpsllq	$32, %zmm5, %zmm5
	vmovdqa32	%zmm4, %zmm4 {%k1}{z}
	vpmuludq	%zmm4, %zmm1, %zmm8
	vpsrlq	$32, %zmm1, %zmm9
	vpmuludq	%zmm4, %zmm9, %zmm4
	vpsllq	$32, %zmm4, %zmm4
	movl	%r8d, %ecx
	shlq	$7, %rcx
	vpaddq	192(%rsp,%rcx), %zmm3, %zmm3
	vpaddq	%zmm3, %zmm6, %zmm3
	vpaddq	%zmm3, %zmm5, %zmm3
	vpaddq	128(%rsp,%rcx), %zmm2, %zmm2
	vpaddq	%zmm2, %zmm8, %zmm2
	vpaddq	%zmm2, %zmm4, %zmm2
	vmovdqa32	%zmm3, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 192(%rsp,%rcx)
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 128(%rsp,%rcx)
	vpsrlq	$32, %zmm2, %zmm2
	vpsrlq	$32, %zmm3, %zmm3
	vmovdqu64	(%rbx), %zmm4
	vmovdqu64	64(%rbx), %zmm5
	vmovdqa32	%zmm5, %zmm5 {%k1}{z}
	vpmuludq	%zmm5, %zmm0, %zmm6
	vpmuludq	%zmm5, %zmm7, %zmm5
	vpsllq	$32, %zmm5, %zmm5
	vpaddq	%zmm5, %zmm6, %zmm5
	vmovdqa32	%zmm4, %zmm4 {%k1}{z}
	vpmuludq	%zmm4, %zmm1, %zmm6
	vpmuludq	%zmm4, %zmm9, %zmm4
	vpsllq	$32, %zmm4, %zmm4
	leal	1(%r8), %ecx
	shlq	$7, %rcx
	vpaddq	192(%rsp,%rcx), %zmm3, %zmm3
	vpaddq	%zmm4, %zmm6, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	128(%rsp,%rcx), %zmm2, %zmm2
	vpaddq	%zmm4, %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 128(%rsp,%rcx)
	vmovdqa32	%zmm3, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 192(%rsp,%rcx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %r8
	addq	$256, %rbx              # imm = 0x100
	addq	$-2, %r10
	jne	.LBB0_16
.LBB0_17:                               # %for_exit33
                                        #   in Loop: Header=BB0_12 Depth=1
	movq	104(%rsp), %rdx         # 8-byte Reload
	addl	%edx, %r12d
	shlq	$7, %r12
	vmovdqa64	%zmm3, 192(%rsp,%r12)
	vmovdqa64	%zmm2, 128(%rsp,%r12)
	addq	$1, %r11
	addq	$1, %rax
	cmpl	%r14d, %eax
	jne	.LBB0_12
.LBB0_18:                               # %for_test73.preheader
	testl	%edx, %edx
	je	.LBB0_19
# %bb.20:                               # %for_loop75.lr.ph
	movl	100(%rsp), %r11d        # 4-byte Reload
	testl	%r11d, %r11d
	je	.LBB0_21
# %bb.25:                               # %for_loop75.lr.ph.new
	movq	%rdx, %r10
	movl	%r10d, %r8d
	andl	$1, %r8d
                                        # kill: def $r10d killed $r10d killed $r10 def $r10
	subl	%r8d, %r10d
	movq	%rsi, %rbx
	subq	$-128, %rbx
	movl	$3, %ecx
	xorl	%eax, %eax
	movw	$-21846, %r9w           # imm = 0xAAAA
	.p2align	4, 0x90
.LBB0_26:                               # %for_loop75
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-128(%rbx), %zmm0
	vmovdqu64	-64(%rbx), %zmm1
	kmovw	%r9d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm0 {%k1}{z}
	vpmuludq	%zmm0, %zmm0, %zmm0
	vmovdqa32	%zmm1, %zmm1 {%k1}{z}
	vpmuludq	%zmm1, %zmm1, %zmm1
	leal	-3(%rcx), %edx
	shlq	$7, %rdx
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqu64	%zmm2, 64(%rdi,%rdx)
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqu64	%zmm2, (%rdi,%rdx)
	leal	-2(%rcx), %edx
	shlq	$7, %rdx
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	vmovdqu64	%zmm1, 64(%rdi,%rdx)
	vmovdqu64	%zmm0, (%rdi,%rdx)
	vmovdqu64	(%rbx), %zmm0
	vmovdqu64	64(%rbx), %zmm1
	vmovdqa32	%zmm1, %zmm1 {%k1}{z}
	vpmuludq	%zmm1, %zmm1, %zmm1
	vmovdqa32	%zmm0, %zmm0 {%k1}{z}
	vpmuludq	%zmm0, %zmm0, %zmm0
	leal	-1(%rcx), %edx
	shlq	$7, %rdx
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqu64	%zmm3, 64(%rdi,%rdx)
	vmovdqu64	%zmm2, (%rdi,%rdx)
	movl	%ecx, %edx
	shlq	$7, %rdx
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	vmovdqu64	%zmm1, 64(%rdi,%rdx)
	vmovdqu64	%zmm0, (%rdi,%rdx)
	addq	$2, %rax
	addq	$256, %rbx              # imm = 0x100
	addl	$4, %ecx
	cmpl	%eax, %r10d
	jne	.LBB0_26
.LBB0_2:                                # %for_test73.for_test107.preheader_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	movq	104(%rsp), %rdx         # 8-byte Reload
	jne	.LBB0_22
	jmp	.LBB0_23
.LBB0_19:
	movl	100(%rsp), %r11d        # 4-byte Reload
	jmp	.LBB0_23
.LBB0_21:
	xorl	%eax, %eax
.LBB0_22:                               # %for_loop75.epil.preheader
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqu64	(%rsi,%rcx), %zmm0
	vmovdqu64	64(%rsi,%rcx), %zmm1
	movw	$-21846, %cx            # imm = 0xAAAA
	kmovw	%ecx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm1 {%k1}{z}
	vpmuludq	%zmm1, %zmm1, %zmm1
	vmovdqa32	%zmm0, %zmm0 {%k1}{z}
	vpmuludq	%zmm0, %zmm0, %zmm0
	leal	(%rax,%rax), %ecx
	shlq	$7, %rcx
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqu64	%zmm3, 64(%rdi,%rcx)
	vmovdqu64	%zmm2, (%rdi,%rcx)
	leal	(%rax,%rax), %eax
	addl	$1, %eax
	shlq	$7, %rax
	vpsrlq	$32, %zmm0, %zmm0
	vpsrlq	$32, %zmm1, %zmm1
	vmovdqu64	%zmm1, 64(%rdi,%rax)
	vmovdqu64	%zmm0, (%rdi,%rax)
.LBB0_23:                               # %for_test107.preheader
	vpxor	%xmm2, %xmm2, %xmm2
	testl	%r11d, %r11d
	je	.LBB0_24
# %bb.27:                               # %for_loop109.preheader
	movl	$1, %eax
	vpbroadcastq	.LCPI0_0(%rip), %zmm0 # zmm0 = [1,1,1,1,1,1,1,1]
	vpbroadcastq	.LCPI0_1(%rip), %zmm1 # zmm1 = [4294967294,4294967294,4294967294,4294967294,4294967294,4294967294,4294967294,4294967294]
	movw	$-21846, %cx            # imm = 0xAAAA
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB0_28:                               # %for_loop109
                                        # =>This Inner Loop Header: Depth=1
	leal	-1(%rax), %esi
	shlq	$7, %rsi
	vmovdqa64	128(%rsp,%rsi), %zmm4
	vmovdqa64	192(%rsp,%rsi), %zmm5
	movl	%eax, %ebx
	cltq
	movq	%rax, %rsi
	shlq	$7, %rsi
	vpaddq	64(%rdi,%rsi), %zmm3, %zmm3
	vpaddq	(%rdi,%rsi), %zmm2, %zmm2
	vpaddq	%zmm4, %zmm4, %zmm6
	vpaddq	%zmm5, %zmm5, %zmm7
	vpandq	%zmm1, %zmm7, %zmm7
	vpaddq	%zmm7, %zmm3, %zmm3
	vpandq	%zmm1, %zmm6, %zmm6
	shlq	$7, %rbx
	kmovw	%ecx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm3, %zmm7 {%k1}{z}
	vmovdqu64	%zmm7, 64(%rdi,%rbx)
	vpaddq	%zmm6, %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, (%rdi,%rbx)
	vpsrlq	$31, %zmm5, %zmm5
	vpsrlq	$31, %zmm4, %zmm4
	vpandq	%zmm0, %zmm4, %zmm4
	vpandq	%zmm0, %zmm5, %zmm5
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	vmovdqa64	128(%rsp,%rbx), %zmm6
	vmovdqa64	192(%rsp,%rbx), %zmm7
	leal	1(%rax), %ebx
	movslq	%ebx, %rsi
	shlq	$7, %rsi
	vpaddq	%zmm7, %zmm7, %zmm8
	vpaddq	%zmm6, %zmm6, %zmm9
	vpandq	%zmm1, %zmm9, %zmm9
	vpaddq	%zmm9, %zmm2, %zmm2
	vpandq	%zmm1, %zmm8, %zmm8
	vpaddq	%zmm8, %zmm3, %zmm3
	vpaddq	64(%rdi,%rsi), %zmm5, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpaddq	(%rdi,%rsi), %zmm4, %zmm4
	vpaddq	%zmm2, %zmm4, %zmm2
	shlq	$7, %rbx
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqu64	%zmm5, 64(%rdi,%rbx)
	vmovdqu64	%zmm4, (%rdi,%rbx)
	vpsrlq	$31, %zmm7, %zmm4
	vpsrlq	$31, %zmm6, %zmm5
	vpandq	%zmm0, %zmm5, %zmm5
	vpandq	%zmm0, %zmm4, %zmm4
	vpsrlq	$32, %zmm2, %zmm2
	vpaddq	%zmm5, %zmm2, %zmm2
	vpsrlq	$32, %zmm3, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	addl	$2, %eax
	addq	$-1, %r15
	jne	.LBB0_28
	jmp	.LBB0_29
.LBB0_24:
	vpxor	%xmm3, %xmm3, %xmm3
.LBB0_29:                               # %for_exit110
	leal	(%rdx,%rdx), %eax
	addl	$-1, %eax
	shlq	$7, %rax
	vpaddq	(%rdi,%rax), %zmm2, %zmm0
	vpaddq	64(%rdi,%rax), %zmm3, %zmm1
	vmovdqu64	%zmm1, 64(%rdi,%rax)
	vmovdqu64	%zmm0, (%rdi,%rax)
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
	.p2align	4, 0x90         # -- Begin function toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
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
	subq	$8576, %rsp             # imm = 0x2180
                                        # kill: def $edx killed $edx def $rdx
	movq	%rsi, %r13
	movq	%rdi, %r12
	movl	%edx, %r11d
	shrl	%r11d
	movq	%rdx, %rax
	movq	%rdx, 104(%rsp)         # 8-byte Spill
	movl	%edx, %esi
	subl	%r11d, %esi
	movq	%rsi, %rax
	shlq	$7, %rax
	movq	%rax, 8(%rsp)           # 8-byte Spill
	leaq	(%rax,%r13), %rbx
	cmpl	%esi, %r11d
	movq	%rsi, (%rsp)            # 8-byte Spill
	jne	.LBB1_5
# %bb.1:                                # %for_test.i.preheader
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vmovdqu64	(%r13,%rax), %zmm3
	vmovdqu64	64(%r13,%rax), %zmm4
	vmovdqu64	(%rbx,%rax), %zmm5
	vmovdqu64	64(%rbx,%rax), %zmm6
	vpcmpltuq	%zmm5, %zmm3, %k0
	vpcmpltuq	%zmm6, %zmm4, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	jb	.LBB1_15
# %bb.2:                                # %no_return.i.lr.ph
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm7
	leal	-2(%r11), %eax
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpxor	%xmm8, %xmm8, %xmm8
	vpcmpeqd	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB1_3:                                # %no_return.i
                                        # =>This Inner Loop Header: Depth=1
	vpandn	%xmm2, %xmm7, %xmm1
	vpcmpnleuq	%zmm5, %zmm3, %k0
	vpcmpnleuq	%zmm6, %zmm4, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm3, %zmm3, %zmm3 {%k1}{z}
	vpmovdb	%zmm3, %xmm3
	vpand	%xmm1, %xmm3, %xmm1
	vpcmpeqb	%xmm8, %xmm1, %xmm3
	vpand	%xmm0, %xmm3, %xmm0
	vpor	%xmm7, %xmm1, %xmm7
	vpcmpeqb	%xmm8, %xmm7, %xmm1
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	kortestw	%k0, %k0
	jb	.LBB1_16
# %bb.4:                                # %no_return43.i
                                        #   in Loop: Header=BB1_3 Depth=1
	vpandn	%xmm2, %xmm7, %xmm2
	movl	%eax, %ecx
	shlq	$7, %rcx
	vmovdqu64	(%r13,%rcx), %zmm3
	vmovdqu64	64(%r13,%rcx), %zmm4
	vmovdqu64	(%rbx,%rcx), %zmm5
	vmovdqu64	64(%rbx,%rcx), %zmm6
	vpcmpltuq	%zmm5, %zmm3, %k0
	vpcmpltuq	%zmm6, %zmm4, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm1, %zmm1, %zmm1 {%k1}{z}
	vpmovdb	%zmm1, %xmm1
	vpand	%xmm2, %xmm1, %xmm1
	vpcmpeqb	%xmm8, %xmm1, %xmm9
	vpternlogq	$15, %zmm9, %zmm9, %zmm9
	vpor	%xmm0, %xmm9, %xmm0
	vpor	%xmm7, %xmm1, %xmm7
	vpcmpeqb	%xmm8, %xmm7, %xmm1
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	addl	$-1, %eax
	kortestw	%k0, %k0
	jae	.LBB1_3
	jmp	.LBB1_16
.LBB1_5:                                # %if_else
	movl	%r11d, %r10d
	shlq	$7, %r10
	vmovdqu64	(%r13,%r10), %zmm8
	vmovdqu64	64(%r13,%r10), %zmm10
	vptestnmq	%zmm8, %zmm8, %k0
	vptestnmq	%zmm10, %zmm10, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm11
	kortestw	%k1, %k1
	je	.LBB1_11
# %bb.6:                                # %for_test.i498.preheader
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vmovdqu64	(%r13,%rax), %zmm5
	vmovdqu64	64(%r13,%rax), %zmm6
	vmovdqu64	(%rbx,%rax), %zmm7
	vmovdqu64	64(%rbx,%rax), %zmm9
	vpcmpltuq	%zmm7, %zmm5, %k0
	vpcmpltuq	%zmm9, %zmm6, %k2
	kunpckbw	%k0, %k2, %k0
	kandw	%k1, %k0, %k2
	kmovw	%k1, %ecx
	kmovw	%k2, %eax
	vpcmpeqd	%xmm3, %xmm3, %xmm3
	cmpw	%ax, %cx
	je	.LBB1_10
# %bb.7:                                # %no_return.i512.lr.ph
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k2}{z}
	vpmovdb	%zmm0, %xmm1
	leal	-2(%r11), %edx
	vpcmpeqd	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB1_8:                                # %no_return.i512
                                        # =>This Inner Loop Header: Depth=1
	vpandn	%xmm0, %xmm1, %xmm2
	vpcmpnleuq	%zmm7, %zmm5, %k0
	vpcmpnleuq	%zmm9, %zmm6, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm5, %zmm5, %zmm5 {%k1}{z}
	vpmovdb	%zmm5, %xmm5
	vpand	%xmm2, %xmm5, %xmm2
	vpcmpeqb	%xmm4, %xmm2, %xmm5
	vpand	%xmm3, %xmm5, %xmm3
	vpand	%xmm11, %xmm2, %xmm2
	vpor	%xmm1, %xmm2, %xmm1
	vpcmpeqb	%xmm4, %xmm1, %xmm2
	vpternlogq	$15, %zmm2, %zmm2, %zmm2
	vpmovsxbd	%xmm2, %zmm2
	vptestmd	%zmm2, %zmm2, %k0
	kmovw	%k0, %eax
	cmpw	%ax, %cx
	je	.LBB1_10
# %bb.9:                                # %no_return43.i517
                                        #   in Loop: Header=BB1_8 Depth=1
	vpandn	%xmm0, %xmm1, %xmm0
	movl	%edx, %eax
	shlq	$7, %rax
	vmovdqu64	(%r13,%rax), %zmm5
	vmovdqu64	64(%r13,%rax), %zmm6
	vmovdqu64	(%rbx,%rax), %zmm7
	vmovdqu64	64(%rbx,%rax), %zmm9
	vpcmpltuq	%zmm7, %zmm5, %k0
	vpcmpltuq	%zmm9, %zmm6, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	vpand	%xmm0, %xmm2, %xmm2
	vpcmpeqb	%xmm4, %xmm2, %xmm12
	vpternlogq	$15, %zmm12, %zmm12, %zmm12
	vpor	%xmm3, %xmm12, %xmm3
	vpand	%xmm11, %xmm2, %xmm2
	vpor	%xmm1, %xmm2, %xmm1
	vpcmpeqb	%xmm4, %xmm1, %xmm2
	vpternlogq	$15, %zmm2, %zmm2, %zmm2
	vpmovsxbd	%xmm2, %zmm2
	vptestmd	%zmm2, %zmm2, %k0
	kmovw	%k0, %eax
	addl	$-1, %edx
	cmpw	%ax, %cx
	jne	.LBB1_8
.LBB1_10:                               # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit518
	vpand	%xmm11, %xmm3, %xmm11
.LBB1_11:                               # %logical_op_done
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqb	%xmm0, %xmm11, %xmm0
	vmovdqa64	%zmm0, %zmm1
	vpternlogq	$15, %zmm0, %zmm0, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	kortestw	%k0, %k0
	je	.LBB1_37
# %bb.12:                               # %for_test.i433.preheader
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k0
	kmovw	%k0, 96(%rsp)
	vmovd	96(%rsp), %xmm0         # xmm0 = mem[0],zero,zero,zero
	testl	%r11d, %r11d
	vpextrb	$0, %xmm0, %eax
	vpextrb	$1, %xmm0, %ecx
	kmovw	%eax, %k1
	kmovw	%ecx, %k2
	je	.LBB1_36
# %bb.13:                               # %for_loop.i445.lr.ph
	cmpl	$1, %r11d
	jne	.LBB1_32
# %bb.14:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB1_35
.LBB1_15:
	vpcmpeqd	%xmm0, %xmm0, %xmm0
.LBB1_16:                               # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vpxor	%xmm1, %xmm1, %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm1
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	kortestw	%k0, %k0
	je	.LBB1_24
# %bb.17:                               # %lessThan___un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	testl	%r11d, %r11d
	je	.LBB1_24
# %bb.18:                               # %for_loop.i462.lr.ph
	vpxor	%xmm1, %xmm1, %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm1
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	kmovw	%k0, 64(%rsp)
	vmovd	64(%rsp), %xmm1         # xmm1 = mem[0],zero,zero,zero
	vpextrb	$0, %xmm1, %eax
	vpextrb	$1, %xmm1, %ecx
	kmovw	%eax, %k1
	kmovw	%ecx, %k2
	movl	%r11d, %eax
	notl	%eax
	movl	%r11d, %r8d
	andl	$1, %r8d
	addl	104(%rsp), %eax         # 4-byte Folded Reload
	jne	.LBB1_20
# %bb.19:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB1_22
.LBB1_20:                               # %for_loop.i462.lr.ph.new
	movq	8(%rsp), %rax           # 8-byte Reload
	leaq	(%rax,%r13), %rdx
	addq	$128, %rdx
	movl	%r11d, %esi
	subl	%r8d, %esi
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%edi, %edi
	movw	$-21846, %ax            # imm = 0xAAAA
	xorl	%ecx, %ecx
	vpxor	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB1_21:                               # %for_loop.i462
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-128(%rdx,%rdi), %zmm3
	vmovdqu64	-64(%rdx,%rdi), %zmm4
	vpsubq	(%r13,%rdi), %zmm3, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	vpsubq	64(%r13,%rdi), %zmm4, %zmm3
	vpaddq	%zmm2, %zmm3, %zmm2
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm1, %zmm3 {%k3}{z}
	vmovdqu64	%zmm3, (%r12,%rdi) {%k1}
	vmovdqa32	%zmm2, %zmm3 {%k3}{z}
	vmovdqu64	%zmm3, 64(%r12,%rdi) {%k2}
	vpsraq	$32, %zmm2, %zmm2
	vpsraq	$32, %zmm1, %zmm1
	vmovdqu64	64(%rdx,%rdi), %zmm3
	vpsubq	192(%r13,%rdi), %zmm3, %zmm3
	vmovdqu64	(%rdx,%rdi), %zmm4
	vpaddq	%zmm2, %zmm3, %zmm2
	vpsubq	128(%r13,%rdi), %zmm4, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	vmovdqa32	%zmm1, %zmm3 {%k3}{z}
	vmovdqu64	%zmm3, 128(%r12,%rdi) {%k1}
	vmovdqa32	%zmm2, %zmm3 {%k3}{z}
	vmovdqu64	%zmm3, 192(%r12,%rdi) {%k2}
	vpsraq	$32, %zmm2, %zmm2
	vpsraq	$32, %zmm1, %zmm1
	addq	$2, %rcx
	addq	$256, %rdi              # imm = 0x100
	cmpl	%ecx, %esi
	jne	.LBB1_21
.LBB1_22:                               # %for_test.i450.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	movq	(%rsp), %rsi            # 8-byte Reload
	je	.LBB1_24
# %bb.23:                               # %for_loop.i462.epil.preheader
	shlq	$7, %rcx
	vmovdqu64	(%rbx,%rcx), %zmm3
	vmovdqu64	64(%rbx,%rcx), %zmm4
	vpsubq	64(%r13,%rcx), %zmm4, %zmm4
	vpaddq	%zmm2, %zmm4, %zmm2
	vpsubq	(%r13,%rcx), %zmm3, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm2, %zmm2 {%k3}{z}
	vmovdqa32	%zmm1, %zmm1 {%k3}{z}
	vmovdqu64	%zmm1, (%r12,%rcx) {%k1}
	vmovdqu64	%zmm2, 64(%r12,%rcx) {%k2}
.LBB1_24:                               # %safe_if_after_true
	vpcmpeqd	%xmm1, %xmm1, %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm1
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	kortestw	%k0, %k0
	je	.LBB1_48
# %bb.25:                               # %safe_if_after_true
	testl	%r11d, %r11d
	je	.LBB1_48
# %bb.26:                               # %for_loop.i479.lr.ph
	vpcmpeqd	%xmm1, %xmm1, %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm0
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k0
	kmovw	%k0, 48(%rsp)
	vmovd	48(%rsp), %xmm0         # xmm0 = mem[0],zero,zero,zero
	vpextrb	$0, %xmm0, %eax
	vpextrb	$1, %xmm0, %ecx
	kmovw	%eax, %k1
	kmovw	%ecx, %k2
	movl	%r11d, %eax
	notl	%eax
	movl	%r11d, %r8d
	andl	$1, %r8d
	addl	104(%rsp), %eax         # 4-byte Folded Reload
	jne	.LBB1_28
# %bb.27:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB1_30
.LBB1_28:                               # %for_loop.i479.lr.ph.new
	movq	8(%rsp), %rax           # 8-byte Reload
	leaq	(%rax,%r13), %rdx
	addq	$128, %rdx
	movl	%r11d, %esi
	subl	%r8d, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edi, %edi
	movw	$-21846, %ax            # imm = 0xAAAA
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB1_29:                               # %for_loop.i479
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	(%r13,%rdi), %zmm2
	vmovdqu64	64(%r13,%rdi), %zmm3
	vpsubq	-128(%rdx,%rdi), %zmm2, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vpsubq	-64(%rdx,%rdi), %zmm3, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm0, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, (%r12,%rdi) {%k1}
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 64(%r12,%rdi) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
	vmovdqu64	192(%r13,%rdi), %zmm2
	vpsubq	64(%rdx,%rdi), %zmm2, %zmm2
	vmovdqu64	128(%r13,%rdi), %zmm3
	vpaddq	%zmm1, %zmm2, %zmm1
	vpsubq	(%rdx,%rdi), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vmovdqa32	%zmm0, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 128(%r12,%rdi) {%k1}
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 192(%r12,%rdi) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
	addq	$2, %rcx
	addq	$256, %rdi              # imm = 0x100
	cmpl	%ecx, %esi
	jne	.LBB1_29
.LBB1_30:                               # %for_test.i467.if_exit.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	movq	(%rsp), %rsi            # 8-byte Reload
	je	.LBB1_48
# %bb.31:                               # %for_loop.i479.epil.preheader
	shlq	$7, %rcx
	vmovdqu64	(%r13,%rcx), %zmm2
	vmovdqu64	64(%r13,%rcx), %zmm3
	vpsubq	64(%rbx,%rcx), %zmm3, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	vpsubq	(%rbx,%rcx), %zmm2, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm1, %zmm1 {%k3}{z}
	vmovdqa32	%zmm0, %zmm0 {%k3}{z}
	vmovdqu64	%zmm0, (%r12,%rcx) {%k1}
	vmovdqu64	%zmm1, 64(%r12,%rcx) {%k2}
	jmp	.LBB1_48
.LBB1_32:                               # %for_loop.i445.lr.ph.new
	movl	%r11d, %r8d
	andl	$1, %r8d
	movq	8(%rsp), %rax           # 8-byte Reload
	leaq	(%rax,%r13), %rsi
	addq	$128, %rsi
	movl	%r11d, %edi
	subl	%r8d, %edi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	movw	$-21846, %ax            # imm = 0xAAAA
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB1_33:                               # %for_loop.i445
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-128(%rsi,%rdx), %zmm2
	vmovdqu64	-64(%rsi,%rdx), %zmm3
	vpsubq	(%r13,%rdx), %zmm2, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vpsubq	64(%r13,%rdx), %zmm3, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm0, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, (%r12,%rdx) {%k1}
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 64(%r12,%rdx) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
	vmovdqu64	64(%rsi,%rdx), %zmm2
	vpsubq	192(%r13,%rdx), %zmm2, %zmm2
	vmovdqu64	(%rsi,%rdx), %zmm3
	vpaddq	%zmm1, %zmm2, %zmm1
	vpsubq	128(%r13,%rdx), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vmovdqa32	%zmm0, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 128(%r12,%rdx) {%k1}
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 192(%r12,%rdx) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
	addq	$2, %rcx
	addq	$256, %rdx              # imm = 0x100
	cmpl	%ecx, %edi
	jne	.LBB1_33
# %bb.34:                               # %for_test.i433.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit446_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	movq	(%rsp), %rsi            # 8-byte Reload
	je	.LBB1_36
.LBB1_35:                               # %for_loop.i445.epil.preheader
	shlq	$7, %rcx
	vmovdqu64	(%rbx,%rcx), %zmm2
	vmovdqu64	64(%rbx,%rcx), %zmm3
	vpsubq	64(%r13,%rcx), %zmm3, %zmm3
	vpaddq	%zmm1, %zmm3, %zmm1
	vpsubq	(%r13,%rcx), %zmm2, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm1, %zmm1 {%k3}{z}
	vmovdqa32	%zmm0, %zmm0 {%k3}{z}
	vmovdqu64	%zmm0, (%r12,%rcx) {%k1}
	vmovdqu64	%zmm1, 64(%r12,%rcx) {%k2}
.LBB1_36:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit446
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu64	%zmm0, (%r12,%r10) {%k1}
	vmovdqu64	%zmm0, 64(%r12,%r10) {%k2}
.LBB1_37:                               # %safe_if_after_true57
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpcmpeqb	%xmm0, %xmm11, %xmm0
	vmovdqa64	%zmm0, %zmm1
	vpternlogq	$15, %zmm0, %zmm0, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k0
	kortestw	%k0, %k0
	je	.LBB1_47
# %bb.38:                               # %safe_if_run_false75
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k0
	kmovw	%k0, 80(%rsp)
	vmovd	80(%rsp), %xmm0         # xmm0 = mem[0],zero,zero,zero
	leaq	(%r12,%r10), %r8
	testl	%r11d, %r11d
	vpextrb	$0, %xmm0, %eax
	vpextrb	$1, %xmm0, %ecx
	kmovw	%eax, %k1
	kmovw	%ecx, %k2
	je	.LBB1_41
# %bb.39:                               # %for_loop.i.lr.ph
	cmpl	$1, %r11d
	jne	.LBB1_42
# %bb.40:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB1_45
.LBB1_41:
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB1_46
.LBB1_42:                               # %for_loop.i.lr.ph.new
	movl	%r11d, %r9d
	andl	$1, %r9d
	movq	8(%rsp), %rax           # 8-byte Reload
	leaq	(%rax,%r13), %rdi
	addq	$128, %rdi
	movl	%r11d, %ecx
	subl	%r9d, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%esi, %esi
	movw	$-21846, %ax            # imm = 0xAAAA
	xorl	%edx, %edx
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB1_43:                               # %for_loop.i
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	(%r13,%rsi), %zmm2
	vmovdqu64	64(%r13,%rsi), %zmm3
	vpsubq	-128(%rdi,%rsi), %zmm2, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vpsubq	-64(%rdi,%rsi), %zmm3, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm0, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, (%r12,%rsi) {%k1}
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 64(%r12,%rsi) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
	vmovdqu64	192(%r13,%rsi), %zmm2
	vpsubq	64(%rdi,%rsi), %zmm2, %zmm2
	vmovdqu64	128(%r13,%rsi), %zmm3
	vpaddq	%zmm1, %zmm2, %zmm1
	vpsubq	(%rdi,%rsi), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	vmovdqa32	%zmm0, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 128(%r12,%rsi) {%k1}
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqu64	%zmm2, 192(%r12,%rsi) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
	addq	$2, %rdx
	addq	$256, %rsi              # imm = 0x100
	cmpl	%edx, %ecx
	jne	.LBB1_43
# %bb.44:                               # %for_test.i356.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	movq	(%rsp), %rsi            # 8-byte Reload
	je	.LBB1_46
.LBB1_45:                               # %for_loop.i.epil.preheader
	shlq	$7, %rdx
	vmovdqu64	(%r13,%rdx), %zmm2
	vmovdqu64	64(%r13,%rdx), %zmm3
	vpsubq	64(%rbx,%rdx), %zmm3, %zmm3
	vpsubq	(%rbx,%rdx), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm3, %zmm1
	vpaddq	%zmm0, %zmm2, %zmm0
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm1, %zmm2 {%k3}{z}
	vmovdqa32	%zmm0, %zmm3 {%k3}{z}
	vmovdqu64	%zmm3, (%r12,%rdx) {%k1}
	vmovdqu64	%zmm2, 64(%r12,%rdx) {%k2}
	vpsraq	$32, %zmm1, %zmm1
	vpsraq	$32, %zmm0, %zmm0
.LBB1_46:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit
	vpaddq	%zmm10, %zmm1, %zmm1
	vpaddq	%zmm8, %zmm0, %zmm0
	vmovdqu64	%zmm0, (%r8) {%k1}
	vmovdqu64	%zmm1, 64(%r12,%r10) {%k2}
.LBB1_47:                               # %if_done56
	leal	-2(,%rsi,4), %eax
	shlq	$7, %rax
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu64	%zmm0, 64(%r12,%rax)
	vmovdqu64	%zmm0, (%r12,%rax)
	leal	-1(,%rsi,4), %eax
	shlq	$7, %rax
	vmovdqu64	%zmm0, 64(%r12,%rax)
	vmovdqu64	%zmm0, (%r12,%rax)
.LBB1_48:                               # %if_exit
	leal	(%rsi,%rsi), %r15d
	movq	%r15, %rax
	shlq	$7, %rax
	movq	%r11, 120(%rsp)         # 8-byte Spill
	movq	%rax, 112(%rsp)         # 8-byte Spill
	leaq	(%r12,%rax), %r14
	leaq	128(%rsp), %rdi
	movq	%r12, %rsi
	movq	(%rsp), %rdx            # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%r14, %rdi
	movq	%rbx, %rsi
	movq	120(%rsp), %rbx         # 8-byte Reload
	movl	%ebx, %edx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	(%rsp), %rdx            # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx
	callq	squareSimple___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	movq	(%rsp), %r13            # 8-byte Reload
	testl	%r13d, %r13d
	je	.LBB1_51
# %bb.49:                               # %for_loop.i375.lr.ph
	movq	8(%rsp), %rax           # 8-byte Reload
	leaq	(%r12,%rax), %rax
	movabsq	$8589934592, %r10       # imm = 0x200000000
	movabsq	$4294967296, %r11       # imm = 0x100000000
	movl	%ebx, %r8d
	notl	%r8d
	movl	%r13d, %r9d
	andl	$1, %r9d
	movl	%r8d, %ecx
	addl	104(%rsp), %ecx         # 4-byte Folded Reload
	jne	.LBB1_52
# %bb.50:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%esi, %esi
	vpxor	%xmm1, %xmm1, %xmm1
	testl	%r9d, %r9d
	jne	.LBB1_55
	jmp	.LBB1_56
.LBB1_51:
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.LBB1_67
.LBB1_52:                               # %for_loop.i375.lr.ph.new
                                        # kill: def $r13d killed $r13d killed $r13 def $r13
	subl	%r9d, %r13d
	movq	112(%rsp), %rcx         # 8-byte Reload
	addq	%r12, %rcx
	addq	$128, %rcx
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edi, %edi
	movw	$-21846, %bx            # imm = 0xAAAA
	xorl	%esi, %esi
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB1_53:                               # %for_loop.i375
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rdx
	sarq	$25, %rdx
	vpaddq	64(%rax,%rdx), %zmm1, %zmm1
	vpaddq	(%rax,%rdx), %zmm0, %zmm0
	vpaddq	(%r14,%rdx), %zmm0, %zmm0
	vpaddq	64(%r14,%rdx), %zmm1, %zmm1
	kmovw	%ebx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqu64	%zmm2, -64(%rcx)
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqu64	%zmm2, -128(%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	leaq	(%rdi,%r11), %rdx
	sarq	$25, %rdx
	vpaddq	(%rax,%rdx), %zmm0, %zmm0
	vpaddq	64(%rax,%rdx), %zmm1, %zmm1
	vpaddq	64(%r14,%rdx), %zmm1, %zmm1
	vpaddq	(%r14,%rdx), %zmm0, %zmm0
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqu64	%zmm3, 64(%rcx)
	vmovdqu64	%zmm2, (%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addq	$2, %rsi
	addq	$256, %rcx              # imm = 0x100
	addq	%r10, %rdi
	cmpl	%esi, %r13d
	jne	.LBB1_53
# %bb.54:                               # %for_test.i364.for_test.i379.preheader_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_56
.LBB1_55:                               # %for_loop.i375.epil.preheader
	movslq	%esi, %rcx
	shlq	$7, %rcx
	vpaddq	(%rax,%rcx), %zmm0, %zmm0
	vpaddq	64(%rax,%rcx), %zmm1, %zmm1
	vpaddq	64(%r14,%rcx), %zmm1, %zmm1
	vpaddq	(%r14,%rcx), %zmm0, %zmm0
	shlq	$7, %rsi
	movw	$-21846, %cx            # imm = 0xAAAA
	kmovw	%ecx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqu64	%zmm3, 64(%r14,%rsi)
	vmovdqu64	%zmm2, (%r14,%rsi)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB1_56:                               # %for_test.i379.preheader
	movq	(%rsp), %r13            # 8-byte Reload
	testl	%r13d, %r13d
	je	.LBB1_59
# %bb.57:                               # %for_loop.i391.lr.ph
	movl	%r13d, %r9d
	andl	$1, %r9d
	movl	%r8d, %ecx
	addl	104(%rsp), %ecx         # 4-byte Folded Reload
	jne	.LBB1_60
# %bb.58:
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%esi, %esi
	vpxor	%xmm3, %xmm3, %xmm3
	testl	%r9d, %r9d
	jne	.LBB1_63
	jmp	.LBB1_64
.LBB1_59:
	vpxor	%xmm4, %xmm4, %xmm4
	vmovdqa64	%zmm0, %zmm2
	vmovdqa64	%zmm1, %zmm3
	jmp	.LBB1_68
.LBB1_60:                               # %for_loop.i391.lr.ph.new
                                        # kill: def $r13d killed $r13d killed $r13 def $r13
	subl	%r9d, %r13d
	movq	8(%rsp), %rcx           # 8-byte Reload
	addq	%r12, %rcx
	addq	$128, %rcx
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%edi, %edi
	movw	$-21846, %bx            # imm = 0xAAAA
	xorl	%esi, %esi
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB1_61:                               # %for_loop.i391
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdi, %rdx
	sarq	$25, %rdx
	vpaddq	64(%r14,%rdx), %zmm3, %zmm3
	vpaddq	(%r14,%rdx), %zmm2, %zmm2
	vpaddq	(%r12,%rdx), %zmm2, %zmm2
	vpaddq	64(%r12,%rdx), %zmm3, %zmm3
	kmovw	%ebx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm3, %zmm4 {%k1}{z}
	vmovdqu64	%zmm4, -64(%rcx)
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqu64	%zmm4, -128(%rcx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	leaq	(%rdi,%r11), %rdx
	sarq	$25, %rdx
	vpaddq	(%r14,%rdx), %zmm2, %zmm2
	vpaddq	64(%r14,%rdx), %zmm3, %zmm3
	vpaddq	64(%r12,%rdx), %zmm3, %zmm3
	vpaddq	(%r12,%rdx), %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqu64	%zmm5, 64(%rcx)
	vmovdqu64	%zmm4, (%rcx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rsi
	addq	$256, %rcx              # imm = 0x100
	addq	%r10, %rdi
	cmpl	%esi, %r13d
	jne	.LBB1_61
# %bb.62:                               # %for_test.i379.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit392_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_64
.LBB1_63:                               # %for_loop.i391.epil.preheader
	movslq	%esi, %rcx
	shlq	$7, %rcx
	vpaddq	(%r14,%rcx), %zmm2, %zmm2
	vpaddq	64(%r14,%rcx), %zmm3, %zmm3
	vpaddq	64(%r12,%rcx), %zmm3, %zmm3
	vpaddq	(%r12,%rcx), %zmm2, %zmm2
	shlq	$7, %rsi
	movw	$-21846, %cx            # imm = 0xAAAA
	kmovw	%ecx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqu64	%zmm5, 64(%rax,%rsi)
	vmovdqu64	%zmm4, (%rax,%rsi)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
.LBB1_64:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit392
	movq	(%rsp), %r13            # 8-byte Reload
	testl	%r13d, %r13d
	vpaddq	%zmm0, %zmm2, %zmm2
	vpaddq	%zmm1, %zmm3, %zmm3
	je	.LBB1_67
# %bb.65:                               # %for_loop.i408.lr.ph
	addq	%r14, 8(%rsp)           # 8-byte Folded Spill
	movl	%r13d, %r9d
	andl	$1, %r9d
	addl	104(%rsp), %r8d         # 4-byte Folded Reload
	jne	.LBB1_76
# %bb.66:
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%edi, %edi
	vpxor	%xmm5, %xmm5, %xmm5
	movq	8(%rsp), %rbx           # 8-byte Reload
	testl	%r9d, %r9d
	jne	.LBB1_79
	jmp	.LBB1_80
.LBB1_67:
	vpxor	%xmm4, %xmm4, %xmm4
.LBB1_68:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit426
	vpxor	%xmm5, %xmm5, %xmm5
.LBB1_69:                               # %bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit426
	vpaddq	%zmm5, %zmm1, %zmm1
	vpaddq	%zmm4, %zmm0, %zmm0
	vptestmq	%zmm2, %zmm2, %k0
	vptestmq	%zmm3, %zmm3, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	je	.LBB1_72
# %bb.70:                               # %for_loop.lr.ph
	vpternlogd	$255, %zmm4, %zmm4, %zmm4 {%k1}{z}
	vpmovdb	%zmm4, %xmm4
	movw	$-21846, %ax            # imm = 0xAAAA
	vpxor	%xmm12, %xmm12, %xmm12
	.p2align	4, 0x90
.LBB1_71:                               # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	movl	%r15d, %ecx
	movslq	%r15d, %r15
	movq	%r15, %rdx
	shlq	$7, %rdx
	vpaddq	(%r12,%rdx), %zmm2, %zmm6
	vpaddq	64(%r12,%rdx), %zmm3, %zmm7
	shlq	$7, %rcx
	kmovw	%eax, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm7, %zmm8 {%k1}{z}
	vmovdqa32	%zmm6, %zmm9 {%k1}{z}
	vpcmpeqb	%xmm12, %xmm4, %xmm10
	vpmovsxbd	%xmm10, %zmm11
	vpternlogq	$15, %zmm10, %zmm10, %zmm10
	vpmovsxbd	%xmm10, %zmm10
	vptestmd	%zmm10, %zmm10, %k0
	kmovw	%k0, 32(%rsp)
	vmovd	32(%rsp), %xmm5         # xmm5 = mem[0],zero,zero,zero
	vpextrb	$0, %xmm5, %edx
	vpextrb	$1, %xmm5, %esi
	kmovw	%edx, %k1
	vmovdqu64	%zmm9, (%r12,%rcx) {%k1}
	kmovw	%esi, %k1
	vmovdqu64	%zmm8, 64(%r12,%rcx) {%k1}
	vpsrlq	$32, %zmm6, %zmm5
	vpsrlq	$32, %zmm7, %zmm6
	vptestmd	%zmm11, %zmm11, %k1
	kshiftrw	$8, %k1, %k2
	vmovdqa64	%zmm3, %zmm6 {%k2}
	vmovdqa64	%zmm2, %zmm5 {%k1}
	addl	$1, %r15d
	vptestnmq	%zmm5, %zmm5, %k0
	vptestnmq	%zmm6, %zmm6, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	vpandn	%xmm4, %xmm2, %xmm4
	vpcmpeqb	%xmm12, %xmm4, %xmm2
	vpternlogq	$15, %zmm2, %zmm2, %zmm2
	vpmovsxbd	%xmm2, %zmm2
	vptestmd	%zmm2, %zmm2, %k0
	kortestw	%k0, %k0
	vmovdqa64	%zmm5, %zmm2
	vmovdqa64	%zmm6, %zmm3
	jne	.LBB1_71
.LBB1_72:                               # %for_exit
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	je	.LBB1_75
# %bb.73:                               # %for_loop202.lr.ph
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	leal	(%r13,%r13,2), %eax
	movw	$-21846, %cx            # imm = 0xAAAA
	vpxor	%xmm10, %xmm10, %xmm10
	.p2align	4, 0x90
.LBB1_74:                               # %for_loop202
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %edx
	shlq	$7, %rdx
	vpaddq	(%r12,%rdx), %zmm0, %zmm4
	vpaddq	64(%r12,%rdx), %zmm1, %zmm5
	kmovw	%ecx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm5, %zmm6 {%k1}{z}
	vmovdqa32	%zmm4, %zmm7 {%k1}{z}
	vpcmpeqb	%xmm10, %xmm2, %xmm8
	vpmovsxbd	%xmm8, %zmm9
	vpternlogq	$15, %zmm8, %zmm8, %zmm8
	vpmovsxbd	%xmm8, %zmm8
	vptestmd	%zmm8, %zmm8, %k0
	kmovw	%k0, 16(%rsp)
	vmovd	16(%rsp), %xmm3         # xmm3 = mem[0],zero,zero,zero
	vpextrb	$0, %xmm3, %esi
	vpextrb	$1, %xmm3, %edi
	kmovw	%esi, %k1
	vmovdqu64	%zmm7, (%r12,%rdx) {%k1}
	kmovw	%edi, %k1
	vmovdqu64	%zmm6, 64(%r12,%rdx) {%k1}
	vpsraq	$32, %zmm4, %zmm3
	vpsraq	$32, %zmm5, %zmm4
	vptestmd	%zmm9, %zmm9, %k1
	kshiftrw	$8, %k1, %k2
	vmovdqa64	%zmm1, %zmm4 {%k2}
	vmovdqa64	%zmm0, %zmm3 {%k1}
	addl	$1, %eax
	vptestnmq	%zmm3, %zmm3, %k0
	vptestnmq	%zmm4, %zmm4, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm0
	vpandn	%xmm2, %xmm0, %xmm2
	vpcmpeqb	%xmm10, %xmm2, %xmm0
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k0
	kortestw	%k0, %k0
	vmovdqa64	%zmm3, %zmm0
	vmovdqa64	%zmm4, %zmm1
	jne	.LBB1_74
.LBB1_75:                               # %for_exit203
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB1_76:                               # %for_loop.i408.lr.ph.new
                                        # kill: def $r13d killed $r13d killed $r13 def $r13
	subl	%r9d, %r13d
	movq	112(%rsp), %rcx         # 8-byte Reload
	addq	%r12, %rcx
	addq	$128, %rcx
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%esi, %esi
	movw	$-21846, %r8w           # imm = 0xAAAA
	xorl	%edi, %edi
	vpxor	%xmm5, %xmm5, %xmm5
	movq	8(%rsp), %rbx           # 8-byte Reload
	.p2align	4, 0x90
.LBB1_77:                               # %for_loop.i408
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rdx
	sarq	$25, %rdx
	vpaddq	64(%r14,%rdx), %zmm5, %zmm5
	vpaddq	(%r14,%rdx), %zmm4, %zmm4
	vpaddq	(%rbx,%rdx), %zmm4, %zmm4
	vpaddq	64(%rbx,%rdx), %zmm5, %zmm5
	kmovw	%r8d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm5, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -64(%rcx)
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -128(%rcx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm4, %zmm4
	leaq	(%rsi,%r11), %rdx
	sarq	$25, %rdx
	vpaddq	(%r14,%rdx), %zmm4, %zmm4
	vpaddq	64(%r14,%rdx), %zmm5, %zmm5
	vpaddq	64(%rbx,%rdx), %zmm5, %zmm5
	vpaddq	(%rbx,%rdx), %zmm4, %zmm4
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqu64	%zmm7, 64(%rcx)
	vmovdqu64	%zmm6, (%rcx)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm4, %zmm4
	addq	$2, %rdi
	addq	$256, %rcx              # imm = 0x100
	addq	%r10, %rsi
	cmpl	%edi, %r13d
	jne	.LBB1_77
# %bb.78:                               # %for_test.i396.bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit409_crit_edge.unr-lcssa
	testl	%r9d, %r9d
	je	.LBB1_80
.LBB1_79:                               # %for_loop.i408.epil.preheader
	movslq	%edi, %rcx
	shlq	$7, %rcx
	vpaddq	(%r14,%rcx), %zmm4, %zmm4
	vpaddq	64(%r14,%rcx), %zmm5, %zmm5
	vpaddq	64(%rbx,%rcx), %zmm5, %zmm5
	vpaddq	(%rbx,%rcx), %zmm4, %zmm4
	shlq	$7, %rdi
	movw	$-21846, %cx            # imm = 0xAAAA
	kmovw	%ecx, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqu64	%zmm7, 64(%r14,%rdi)
	vmovdqu64	%zmm6, (%r14,%rdi)
	vpsrlq	$32, %zmm5, %zmm5
	vpsrlq	$32, %zmm4, %zmm4
.LBB1_80:                               # %bigAdd___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit409
	vpaddq	%zmm0, %zmm4, %zmm0
	vpaddq	%zmm1, %zmm5, %zmm1
	testl	%r15d, %r15d
	je	.LBB1_83
# %bb.81:                               # %for_loop.i425.lr.ph
	movq	104(%rsp), %rcx         # 8-byte Reload
	leal	(%rcx,%rcx), %esi
	orl	$1, %ecx
	movl	%esi, %edx
	subl	%ecx, %edx
	movl	%r15d, %ecx
	andl	$2, %ecx
	cmpl	$3, %edx
	jae	.LBB1_84
# %bb.82:
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%edx, %edx
	vpxor	%xmm5, %xmm5, %xmm5
	testl	%ecx, %ecx
	je	.LBB1_87
.LBB1_88:                               # %for_loop.i425.epil.preheader
	shlq	$7, %rdx
	negl	%ecx
	movw	$-21846, %si            # imm = 0xAAAA
	movq	(%rsp), %r13            # 8-byte Reload
	.p2align	4, 0x90
.LBB1_89:                               # %for_loop.i425.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	(%rax,%rdx), %zmm6
	vpsubq	128(%rsp,%rdx), %zmm6, %zmm6
	vmovdqu64	64(%rax,%rdx), %zmm7
	vpaddq	%zmm4, %zmm6, %zmm4
	vpsubq	192(%rsp,%rdx), %zmm7, %zmm6
	vpaddq	%zmm5, %zmm6, %zmm5
	kmovw	%esi, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqu64	%zmm7, 64(%rax,%rdx)
	vmovdqu64	%zmm6, (%rax,%rdx)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	subq	$-128, %rdx
	addl	$1, %ecx
	jne	.LBB1_89
	jmp	.LBB1_69
.LBB1_83:
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	(%rsp), %r13            # 8-byte Reload
	jmp	.LBB1_69
.LBB1_84:                               # %for_loop.i425.lr.ph.new
	movq	120(%rsp), %rdx         # 8-byte Reload
	leal	(%rcx,%rdx,2), %edx
	subl	%edx, %esi
	vpxor	%xmm4, %xmm4, %xmm4
	movl	$384, %edi              # imm = 0x180
	xorl	%edx, %edx
	movw	$-21846, %r8w           # imm = 0xAAAA
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB1_85:                               # %for_loop.i425
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu64	-384(%rax,%rdi), %zmm6
	vmovdqu64	-320(%rax,%rdi), %zmm7
	vmovdqu64	-256(%rax,%rdi), %zmm8
	vpsubq	-192(%rsp,%rdi), %zmm7, %zmm7
	vmovdqu64	-192(%rax,%rdi), %zmm9
	vpaddq	%zmm5, %zmm7, %zmm5
	vpsubq	-256(%rsp,%rdi), %zmm6, %zmm6
	kmovw	%r8d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm5, %zmm7 {%k1}{z}
	vmovdqu64	%zmm7, -320(%rax,%rdi)
	vpaddq	%zmm4, %zmm6, %zmm4
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -384(%rax,%rdi)
	vpsraq	$32, %zmm5, %zmm5
	vpsubq	-64(%rsp,%rdi), %zmm9, %zmm6
	vpsraq	$32, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm6, %zmm5
	vpsubq	-128(%rsp,%rdi), %zmm8, %zmm6
	vpaddq	%zmm4, %zmm6, %zmm4
	vmovdqa32	%zmm5, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -192(%rax,%rdi)
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -256(%rax,%rdi)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	vmovdqu64	-64(%rax,%rdi), %zmm6
	vpsubq	64(%rsp,%rdi), %zmm6, %zmm6
	vmovdqu64	-128(%rax,%rdi), %zmm7
	vpaddq	%zmm5, %zmm6, %zmm5
	vpsubq	(%rsp,%rdi), %zmm7, %zmm6
	vpaddq	%zmm4, %zmm6, %zmm4
	vmovdqa32	%zmm5, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -64(%rax,%rdi)
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, -128(%rax,%rdi)
	vpsraq	$32, %zmm4, %zmm4
	vpsraq	$32, %zmm5, %zmm5
	vmovdqu64	(%rax,%rdi), %zmm6
	vpsubq	128(%rsp,%rdi), %zmm6, %zmm6
	vmovdqu64	64(%rax,%rdi), %zmm7
	vpaddq	%zmm4, %zmm6, %zmm4
	vpsubq	192(%rsp,%rdi), %zmm7, %zmm6
	vpaddq	%zmm5, %zmm6, %zmm5
	vmovdqa32	%zmm5, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, 64(%rax,%rdi)
	vmovdqa32	%zmm4, %zmm6 {%k1}{z}
	vmovdqu64	%zmm6, (%rax,%rdi)
	vpsraq	$32, %zmm5, %zmm5
	vpsraq	$32, %zmm4, %zmm4
	addq	$4, %rdx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%edx, %esi
	jne	.LBB1_85
# %bb.86:                               # %for_test.i413.bigSub___un_3C_vyU_3E_un_3C_CvyU_3E_un_3C_CvyU_3E_unu.exit426_crit_edge.unr-lcssa
	testl	%ecx, %ecx
	jne	.LBB1_88
.LBB1_87:
	movq	(%rsp), %r13            # 8-byte Reload
	jmp	.LBB1_69
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
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2
.LCPI2_1:
	.long	1                       # 0x1
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI2_2:
	.quad	1                       # 0x1
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI2_3:
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
	vmovdqa	%xmm0, %xmm12
	movl	%r8d, %r11d
	movq	%rcx, %r14
	testl	%r8d, %r8d
	je	.LBB2_3
# %bb.1:                                # %for_loop.lr.ph
	vpbroadcastd	%r11d, %zmm0
	vpmulld	.LCPI2_0(%rip), %zmm0, %zmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpcmpeqb	%xmm1, %xmm12, %xmm1
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	vpmovsxbd	%xmm1, %zmm1
	vptestmd	%zmm1, %zmm1, %k1
	movl	%r11d, %r10d
	andl	$1, %r10d
	cmpl	$1, %r11d
	movq	%r14, 72(%rsp)          # 8-byte Spill
	movl	%r9d, 60(%rsp)          # 4-byte Spill
	movl	%r10d, 64(%rsp)         # 4-byte Spill
	jne	.LBB2_4
# %bb.2:
	xorl	%eax, %eax
	jmp	.LBB2_7
.LBB2_3:                                # %for_test186.preheader.thread
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqb	%xmm0, %xmm12, %xmm0
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k4
	kxorw	%k0, %k0, %k1
	jmp	.LBB2_66
.LBB2_4:                                # %for_loop.lr.ph.new
	movl	%r11d, %r8d
	subl	%r10d, %r8d
	movl	$64, %ebx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB2_5:                                # %for_loop
                                        # =>This Inner Loop Header: Depth=1
	vpbroadcastd	%eax, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k2}
	vmovdqa64	%zmm2, 8512(%rsp,%rbx)
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k2}
	vextracti64x4	$1, %zmm2, %ymm1
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vmovdqa64	%zmm1, 320(%rsp,%rbx,2)
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm1, 256(%rsp,%rbx,2)
	leal	1(%rax), %ecx
	vpbroadcastd	%ecx, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k2}
	vmovdqa64	%zmm2, 8576(%rsp,%rbx)
	kmovw	%k1, %k2
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k2}
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm2, 448(%rsp,%rbx,2)
	vmovdqa64	%zmm1, 384(%rsp,%rbx,2)
	addq	$2, %rax
	subq	$-128, %rbx
	cmpl	%eax, %r8d
	jne	.LBB2_5
# %bb.6:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r10d, %r10d
	je	.LBB2_8
.LBB2_7:                                # %for_loop.epil.preheader
	movq	%rax, %rcx
	shlq	$6, %rcx
	vpbroadcastd	%eax, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm0
	vpslld	$2, %zmm0, %zmm0
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
.LBB2_8:                                # %for_exit
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqb	%xmm0, %xmm12, %xmm0
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k4
	vmovdqu32	(%rsi), %zmm0 {%k4}{z}
	vmovdqa64	%zmm0, 128(%rsp) # 64-byte Spill
	testl	%r11d, %r11d
	jle	.LBB2_38
# %bb.9:                                # %for_loop32.lr.ph
	movabsq	$8589934592, %r15       # imm = 0x200000000
	movabsq	$4294967296, %r14       # imm = 0x100000000
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	60(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %r8d
	vpbroadcastd	%ecx, %zmm14
	movl	$32, %eax
	subl	%ecx, %eax
	vpbroadcastd	%eax, %zmm15
	leal	-1(%r11), %r13d
	movslq	%r11d, %rcx
	movl	%r11d, %ebx
	subl	64(%rsp), %ebx          # 4-byte Folded Reload
	leal	1(%r11), %edi
	movw	$-21846, %r12w          # imm = 0xAAAA
	vmovdqa	%xmm12, 112(%rsp)       # 16-byte Spill
	movq	%r11, 104(%rsp)         # 8-byte Spill
	kmovw	%k4, 70(%rsp)           # 2-byte Spill
	vmovdqa64	%zmm14, 256(%rsp) # 64-byte Spill
	vmovdqa64	%zmm15, 192(%rsp) # 64-byte Spill
	movq	%rdi, 96(%rsp)          # 8-byte Spill
	.p2align	4, 0x90
.LBB2_10:                               # %for_loop32
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_13 Depth 2
                                        #       Child Loop BB2_14 Depth 3
                                        #         Child Loop BB2_16 Depth 4
                                        #       Child Loop BB2_23 Depth 3
                                        #       Child Loop BB2_29 Depth 3
                                        #         Child Loop BB2_32 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	movq	%rcx, 88(%rsp)          # 8-byte Spill
	testq	%rcx, %rcx
	vpternlogd	$255, %zmm0, %zmm0, %zmm0
	je	.LBB2_12
# %bb.11:                               # %for_loop32
                                        #   in Loop: Header=BB2_10 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB2_12:                               # %for_loop32
                                        #   in Loop: Header=BB2_10 Depth=1
	vpaddd	8576(%rsp,%rax), %zmm0, %zmm0
	vmovdqa64	%zmm0, 320(%rsp) # 64-byte Spill
	.p2align	4, 0x90
.LBB2_13:                               # %for_loop49.lr.ph.split.us
                                        #   Parent Loop BB2_10 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_14 Depth 3
                                        #         Child Loop BB2_16 Depth 4
                                        #       Child Loop BB2_23 Depth 3
                                        #       Child Loop BB2_29 Depth 3
                                        #         Child Loop BB2_32 Depth 4
	movl	%r8d, 84(%rsp)          # 4-byte Spill
	leaq	29056(%rsp), %rdi
	leaq	384(%rsp), %rsi
	movl	%r11d, %edx
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	leaq	8640(%rsp), %r9
	movq	104(%rsp), %r11         # 8-byte Reload
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa64	128(%rsp), %zmm6 # 64-byte Reload
	.p2align	4, 0x90
.LBB2_14:                               # %for_loop60.lr.ph.us
                                        #   Parent Loop BB2_10 Depth=1
                                        #     Parent Loop BB2_13 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_16 Depth 4
	movq	%rcx, %r8
	shlq	$7, %r8
	vmovdqa64	29056(%rsp,%r8), %zmm0
	vmovdqa64	29120(%rsp,%r8), %zmm1
	vpmovqd	%zmm0, %ymm0
	vpmovqd	%zmm1, %ymm1
	vinserti64x4	$1, %ymm1, %zmm0, %zmm0
	vpmulld	%zmm0, %zmm6, %zmm1
	vextracti64x4	$1, %zmm1, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpxor	%xmm2, %xmm2, %xmm2
	testl	%r13d, %r13d
	je	.LBB2_18
# %bb.15:                               # %for_loop60.lr.ph.us.new
                                        #   in Loop: Header=BB2_14 Depth=3
	movq	%r9, %rdi
	xorl	%esi, %esi
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_16:                               # %for_loop60.us
                                        #   Parent Loop BB2_10 Depth=1
                                        #     Parent Loop BB2_13 Depth=2
                                        #       Parent Loop BB2_14 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-64(%rdi), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-32(%rdi), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm5
	leal	(%rcx,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpmuludq	%zmm1, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqa64	%zmm5, 29120(%rsp,%rdx)
	vpaddq	%zmm4, %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	32(%rdi), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm2, %zmm2
	vpmovzxdq	(%rdi), %zmm5   # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm5
	leal	(%rax,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	vpmuludq	%zmm0, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm2, %zmm2
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	vmovdqa32	%zmm3, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 29120(%rsp,%rdx)
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %ebx
	jne	.LBB2_16
# %bb.17:                               # %for_test58.for_exit61_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_14 Depth=3
	testb	$1, %r11b
	jne	.LBB2_19
	jmp	.LBB2_20
	.p2align	4, 0x90
.LBB2_18:                               #   in Loop: Header=BB2_14 Depth=3
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%esi, %esi
.LBB2_19:                               # %for_loop60.us.epil.preheader
                                        #   in Loop: Header=BB2_14 Depth=3
	movq	%rsi, %rdx
	shlq	$6, %rdx
	vpmovzxdq	8608(%rsp,%rdx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8576(%rsp,%rdx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm1
	vpmuludq	%zmm0, %zmm4, %zmm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29056(%rsp,%rsi), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	vpaddq	29120(%rsp,%rsi), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqa32	%zmm0, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 29120(%rsp,%rsi)
	vmovdqa64	%zmm2, 29056(%rsp,%rsi)
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm2
.LBB2_20:                               # %for_exit61.us
                                        #   in Loop: Header=BB2_14 Depth=3
	vmovdqa64	%zmm3, 448(%rsp,%r8)
	vmovdqa64	%zmm2, 384(%rsp,%r8)
	addq	$1, %rcx
	movl	%r11d, %edx
	addq	$1, %rax
	cmpq	%rdx, %rcx
	jne	.LBB2_14
# %bb.21:                               # %for_loop90.lr.ph
                                        #   in Loop: Header=BB2_13 Depth=2
	movl	84(%rsp), %r8d          # 4-byte Reload
	vpbroadcastd	%r8d, %zmm0
	vptestmd	320(%rsp), %zmm0, %k1 # 64-byte Folded Reload
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm2
	kshiftrw	$8, %k1, %k1
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm3
	testl	%r13d, %r13d
	vmovdqa	112(%rsp), %xmm12       # 16-byte Reload
	kmovw	70(%rsp), %k4           # 2-byte Reload
	vpxor	%xmm13, %xmm13, %xmm13
	vmovdqa64	256(%rsp), %zmm14 # 64-byte Reload
	vmovdqa64	192(%rsp), %zmm15 # 64-byte Reload
	movq	96(%rsp), %rdi          # 8-byte Reload
	vpxor	%xmm0, %xmm0, %xmm0
	je	.LBB2_25
# %bb.22:                               # %for_loop90.lr.ph.new
                                        #   in Loop: Header=BB2_13 Depth=2
	xorl	%eax, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB2_23:                               # %for_loop90
                                        #   Parent Loop BB2_10 Depth=1
                                        #     Parent Loop BB2_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	leal	(%r11,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa64	29056(%rsp,%rsi), %zmm4
	vmovdqa64	29120(%rsp,%rsi), %zmm5
	vpaddq	384(%rsp,%rdx), %zmm4, %zmm4
	vpaddq	448(%rsp,%rdx), %zmm5, %zmm5
	vpsllvq	%zmm3, %zmm5, %zmm5
	vpsllvq	%zmm2, %zmm4, %zmm4
	vpaddq	%zmm1, %zmm5, %zmm1
	vpaddq	%zmm0, %zmm4, %zmm0
	shlq	$7, %rcx
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 448(%rsp,%rcx)
	vmovdqa32	%zmm0, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 384(%rsp,%rcx)
	vpsrlq	$32, %zmm0, %zmm0
	leal	1(%rax), %ecx
	movslq	%ecx, %rdx
	shlq	$7, %rdx
	leal	(%rdi,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa64	29056(%rsp,%rsi), %zmm4
	vmovdqa64	29120(%rsp,%rsi), %zmm5
	vpaddq	448(%rsp,%rdx), %zmm5, %zmm5
	vpaddq	384(%rsp,%rdx), %zmm4, %zmm4
	vpsrlq	$32, %zmm1, %zmm1
	vpsllvq	%zmm2, %zmm4, %zmm4
	vpaddq	%zmm0, %zmm4, %zmm0
	vpsllvq	%zmm3, %zmm5, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	shlq	$7, %rcx
	vmovdqa32	%zmm0, %zmm4 {%k1}{z}
	vmovdqa32	%zmm1, %zmm5 {%k1}{z}
	vmovdqa64	%zmm5, 448(%rsp,%rcx)
	vmovdqa64	%zmm4, 384(%rsp,%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addl	$2, %eax
	cmpl	%eax, %ebx
	jne	.LBB2_23
# %bb.24:                               # %for_test88.for_test124.preheader_crit_edge.unr-lcssa
                                        #   in Loop: Header=BB2_13 Depth=2
	testb	$1, %r11b
	leaq	512(%rsp), %r9
	jne	.LBB2_26
	jmp	.LBB2_27
	.p2align	4, 0x90
.LBB2_25:                               #   in Loop: Header=BB2_13 Depth=2
	xorl	%eax, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	leaq	512(%rsp), %r9
.LBB2_26:                               # %for_loop90.epil.preheader
                                        #   in Loop: Header=BB2_13 Depth=2
	movslq	%eax, %rcx
	movq	%rcx, %rdx
	shlq	$7, %rdx
	addl	%r11d, %ecx
	movslq	%ecx, %rcx
	shlq	$7, %rcx
	vmovdqa64	29056(%rsp,%rcx), %zmm4
	vmovdqa64	29120(%rsp,%rcx), %zmm5
	vpaddq	448(%rsp,%rdx), %zmm5, %zmm5
	vpaddq	384(%rsp,%rdx), %zmm4, %zmm4
	vpsllvq	%zmm2, %zmm4, %zmm2
	movl	%eax, %eax
	vpsllvq	%zmm3, %zmm5, %zmm3
	vpaddq	%zmm0, %zmm2, %zmm0
	vpaddq	%zmm1, %zmm3, %zmm1
	shlq	$7, %rax
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 448(%rsp,%rax)
	vmovdqa64	%zmm2, 384(%rsp,%rax)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB2_27:                               # %for_test124.preheader
                                        #   in Loop: Header=BB2_13 Depth=2
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	jmp	.LBB2_29
	.p2align	4, 0x90
.LBB2_28:                               # %for_exit141.us
                                        #   in Loop: Header=BB2_29 Depth=3
	vpcmpeqb	%xmm13, %xmm2, %xmm5
	vpmovsxbd	%xmm5, %zmm5
	vptestmd	%zmm5, %zmm5, %k0
	knotw	%k0, %k1
	vmovdqa64	%zmm4, %zmm4 {%k1}{z}
	vpaddq	%zmm0, %zmm4, %zmm0
	kshiftrw	$8, %k0, %k0
	knotw	%k0, %k1
	vmovdqa64	%zmm3, %zmm3 {%k1}{z}
	vpaddq	%zmm1, %zmm3, %zmm1
	vptestnmq	%zmm0, %zmm0, %k0
	vptestnmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm3, %zmm3, %zmm3 {%k1}{z}
	vpmovdb	%zmm3, %xmm3
	vpandn	%xmm2, %xmm3, %xmm2
.LBB2_29:                               # %for_test124.preheader
                                        #   Parent Loop BB2_10 Depth=1
                                        #     Parent Loop BB2_13 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_32 Depth 4
	vpand	%xmm12, %xmm2, %xmm3
	vpcmpeqb	%xmm13, %xmm3, %xmm3
	vpternlogq	$15, %zmm3, %zmm3, %zmm3
	vpmovsxbd	%xmm3, %zmm3
	vptestmd	%zmm3, %zmm3, %k0
	kortestw	%k0, %k0
	je	.LBB2_36
# %bb.30:                               # %for_loop140.lr.ph.us
                                        #   in Loop: Header=BB2_29 Depth=3
	testl	%r13d, %r13d
	je	.LBB2_34
# %bb.31:                               # %for_loop140.lr.ph.us.new
                                        #   in Loop: Header=BB2_29 Depth=3
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%ecx, %ecx
	movq	%r9, %rdx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_32:                               # %for_loop140.us
                                        #   Parent Loop BB2_10 Depth=1
                                        #     Parent Loop BB2_13 Depth=2
                                        #       Parent Loop BB2_29 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpcmpeqb	%xmm13, %xmm2, %xmm6
	movq	%rcx, %rsi
	sarq	$26, %rsi
	vmovdqa64	8576(%rsp,%rsi), %zmm7
	vpsllvd	%zmm14, %zmm7, %zmm8
	vpmovsxbd	%xmm6, %zmm6
	vpsrlvd	%zmm15, %zmm7, %zmm7
	vptestmd	%zmm6, %zmm6, %k1
	vpord	%zmm5, %zmm8, %zmm5
	vextracti64x4	$1, %zmm5, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vmovdqa64	-128(%rdx), %zmm8
	vmovdqa64	-64(%rdx), %zmm9
	vmovdqa64	(%rdx), %zmm10
	vmovdqa64	64(%rdx), %zmm11
	vpsubq	%zmm5, %zmm8, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm4
	vpsubq	%zmm6, %zmm9, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	kmovw	%r12d, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm4, %zmm5 {%k2}{z}
	kshiftrw	$8, %k1, %k3
	vmovdqa32	%zmm3, %zmm6 {%k2}{z}
	vmovdqa64	%zmm9, %zmm6 {%k3}
	vmovdqa64	%zmm6, -64(%rdx)
	vmovdqa64	%zmm8, %zmm5 {%k1}
	vmovdqa64	%zmm5, -128(%rdx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm4, %zmm4
	leaq	(%rcx,%r14), %rsi
	sarq	$26, %rsi
	vmovdqa64	8576(%rsp,%rsi), %zmm5
	vpsllvd	%zmm14, %zmm5, %zmm6
	vpord	%zmm7, %zmm6, %zmm6
	vpsrlvd	%zmm15, %zmm5, %zmm5
	vpmovzxdq	%ymm6, %zmm7    # zmm7 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vextracti64x4	$1, %zmm6, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpsubq	%zmm6, %zmm11, %zmm6
	vpaddq	%zmm3, %zmm6, %zmm3
	vpsubq	%zmm7, %zmm10, %zmm6
	vpaddq	%zmm4, %zmm6, %zmm4
	vmovdqa32	%zmm3, %zmm6 {%k2}{z}
	vmovdqa32	%zmm4, %zmm7 {%k2}{z}
	vmovdqa64	%zmm10, %zmm7 {%k1}
	vmovdqa64	%zmm11, %zmm6 {%k3}
	vmovdqa64	%zmm6, 64(%rdx)
	vmovdqa64	%zmm7, (%rdx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm4, %zmm4
	addq	$2, %rax
	addq	$256, %rdx              # imm = 0x100
	addq	%r15, %rcx
	cmpl	%eax, %ebx
	jne	.LBB2_32
# %bb.33:                               # %for_test138.for_exit141_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_29 Depth=3
	testb	$1, %r11b
	je	.LBB2_28
	jmp	.LBB2_35
	.p2align	4, 0x90
.LBB2_34:                               #   in Loop: Header=BB2_29 Depth=3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%eax, %eax
.LBB2_35:                               # %for_loop140.us.epil.preheader
                                        #   in Loop: Header=BB2_29 Depth=3
	vpcmpeqb	%xmm13, %xmm2, %xmm6
	vpmovsxbd	%xmm6, %zmm6
	vptestmd	%zmm6, %zmm6, %k1
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm6
	vmovdqa64	448(%rsp,%rcx), %zmm7
	cltq
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm8
	vpsllvd	%zmm14, %zmm8, %zmm8
	vpord	%zmm5, %zmm8, %zmm5
	vpmovzxdq	%ymm5, %zmm8    # zmm8 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vextracti64x4	$1, %zmm5, %ymm5
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpsubq	%zmm5, %zmm7, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	%zmm8, %zmm6, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm4
	kmovw	%r12d, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm3, %zmm5 {%k2}{z}
	vmovdqa32	%zmm4, %zmm8 {%k2}{z}
	vmovdqa64	%zmm6, %zmm8 {%k1}
	kshiftrw	$8, %k1, %k1
	vmovdqa64	%zmm7, %zmm5 {%k1}
	vmovdqa64	%zmm5, 448(%rsp,%rcx)
	vmovdqa64	%zmm8, 384(%rsp,%rcx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm4, %zmm4
	jmp	.LBB2_28
	.p2align	4, 0x90
.LBB2_36:                               # %for_exit127
                                        #   in Loop: Header=BB2_13 Depth=2
	shrl	%r8d
	jne	.LBB2_13
# %bb.37:                               # %for_test30.loopexit
                                        #   in Loop: Header=BB2_10 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	88(%rsp), %rcx          # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB2_10
.LBB2_38:                               # %for_test186.preheader
	kxorw	%k0, %k0, %k1
	testl	%r11d, %r11d
	je	.LBB2_41
# %bb.39:                               # %for_loop188.lr.ph
	leal	-1(%r11), %ecx
	movl	%r11d, %eax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB2_42
# %bb.40:
	xorl	%ecx, %ecx
	movq	72(%rsp), %r14          # 8-byte Reload
	movl	64(%rsp), %r12d         # 4-byte Reload
	jmp	.LBB2_44
.LBB2_41:
	movq	72(%rsp), %r14          # 8-byte Reload
	movl	60(%rsp), %r9d          # 4-byte Reload
	jmp	.LBB2_66
.LBB2_42:                               # %for_loop188.lr.ph.new
	movl	%r11d, %edx
	subl	%eax, %edx
	movl	%r11d, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	movq	72(%rsp), %r14          # 8-byte Reload
	movl	64(%rsp), %r12d         # 4-byte Reload
	.p2align	4, 0x90
.LBB2_43:                               # %for_loop188
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	(%rsp,%rdi), %zmm1
	vmovaps	64(%rsp,%rdi), %zmm2
	vmovdqa64	128(%rsp,%rdi), %zmm3
	vmovaps	%zmm2, 12352(%rsp,%rdi)
	vmovaps	192(%rsp,%rdi), %zmm2
	vmovaps	%zmm1, 12288(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovaps	%zmm2, 12480(%rsp,%rdi)
	vmovdqa64	%zmm3, 12416(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovaps	256(%rsp,%rdi), %zmm1
	vmovaps	320(%rsp,%rdi), %zmm2
	vmovaps	%zmm2, 12608(%rsp,%rdi)
	vmovaps	%zmm1, 12544(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovdqa64	384(%rsp,%rdi), %zmm1
	vmovdqa64	448(%rsp,%rdi), %zmm2
	vmovdqa64	%zmm2, 12736(%rsp,%rdi)
	vmovdqa64	%zmm1, 12672(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB2_43
.LBB2_44:                               # %for_test186.for_test204.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	vmovdqa64	128(%rsp), %zmm6 # 64-byte Reload
	je	.LBB2_47
# %bb.45:                               # %for_loop188.epil.preheader
	leal	(%r11,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB2_46:                               # %for_loop188.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa64	384(%rsp,%rcx), %zmm1
	vmovdqa64	448(%rsp,%rcx), %zmm2
	vmovdqa64	%zmm2, 12736(%rsp,%rcx)
	vmovdqa64	%zmm1, 12672(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB2_46
.LBB2_47:                               # %for_test204.preheader
	testl	%r11d, %r11d
	je	.LBB2_60
# %bb.48:                               # %for_loop222.lr.ph.us.preheader
	leaq	8640(%rsp), %r8
	movl	%r11d, %eax
	subl	%r12d, %eax
	movl	$1, %edx
	xorl	%esi, %esi
	movq	%r11, %rcx
	movw	$-21846, %r11w          # imm = 0xAAAA
	movq	%rcx, %r15
	movl	%ecx, %r9d
	.p2align	4, 0x90
.LBB2_49:                               # %for_loop222.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_52 Depth 2
	movq	%rsi, %r10
	shlq	$7, %r10
	vmovdqa64	12672(%rsp,%r10), %zmm0
	vmovdqa64	12736(%rsp,%r10), %zmm1
	vpmovqd	%zmm0, %ymm0
	vpmovqd	%zmm1, %ymm1
	vinserti64x4	$1, %ymm1, %zmm0, %zmm0
	vpmulld	%zmm0, %zmm6, %zmm1
	vextracti64x4	$1, %zmm1, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpxor	%xmm2, %xmm2, %xmm2
	cmpl	$1, %r15d
	jne	.LBB2_51
# %bb.50:                               #   in Loop: Header=BB2_49 Depth=1
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%ebx, %ebx
	jmp	.LBB2_54
	.p2align	4, 0x90
.LBB2_51:                               # %for_loop222.lr.ph.us.new
                                        #   in Loop: Header=BB2_49 Depth=1
	movq	%r8, %rcx
	xorl	%ebx, %ebx
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_52:                               # %for_loop222.us
                                        #   Parent Loop BB2_49 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-64(%rcx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-32(%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm5
	leal	(%rsi,%rbx), %edi
	shlq	$7, %rdi
	vpaddq	12736(%rsp,%rdi), %zmm3, %zmm3
	vpmuludq	%zmm1, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	12672(%rsp,%rdi), %zmm2, %zmm2
	kmovw	%r11d, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm3, %zmm5 {%k2}{z}
	vmovdqa64	%zmm5, 12736(%rsp,%rdi)
	vpaddq	%zmm4, %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k2}{z}
	vmovdqa64	%zmm4, 12672(%rsp,%rdi)
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	32(%rcx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm2, %zmm2
	vpmovzxdq	(%rcx), %zmm5   # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm5
	leal	(%rdx,%rbx), %edi
	shlq	$7, %rdi
	vpaddq	12672(%rsp,%rdi), %zmm2, %zmm2
	vpmuludq	%zmm0, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm2, %zmm2
	vpaddq	12736(%rsp,%rdi), %zmm3, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	vmovdqa32	%zmm3, %zmm4 {%k2}{z}
	vmovdqa64	%zmm4, 12736(%rsp,%rdi)
	vmovdqa32	%zmm2, %zmm4 {%k2}{z}
	vmovdqa64	%zmm4, 12672(%rsp,%rdi)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rbx
	subq	$-128, %rcx
	cmpl	%ebx, %eax
	jne	.LBB2_52
# %bb.53:                               # %for_test220.for_exit223_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB2_49 Depth=1
	testb	$1, %r15b
	je	.LBB2_55
.LBB2_54:                               # %for_loop222.us.epil.preheader
                                        #   in Loop: Header=BB2_49 Depth=1
	movq	%rbx, %rcx
	shlq	$6, %rcx
	vpmovzxdq	8608(%rsp,%rcx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8576(%rsp,%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm1
	vpmuludq	%zmm0, %zmm4, %zmm0
	addl	%esi, %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	kmovw	%r11d, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm1, %zmm2 {%k2}{z}
	vmovdqa32	%zmm0, %zmm3 {%k2}{z}
	vmovdqa64	%zmm3, 12736(%rsp,%rbx)
	vmovdqa64	%zmm2, 12672(%rsp,%rbx)
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm2
.LBB2_55:                               # %for_exit223.us
                                        #   in Loop: Header=BB2_49 Depth=1
	vmovdqa64	%zmm3, 448(%rsp,%r10)
	vmovdqa64	%zmm2, 384(%rsp,%r10)
	addq	$1, %rsi
	addq	$1, %rdx
	cmpq	%r9, %rsi
	jne	.LBB2_49
# %bb.56:                               # %for_test253.preheader
	movq	%r15, %r11
	testl	%r11d, %r11d
	je	.LBB2_60
# %bb.57:                               # %for_loop255.lr.ph
	cmpl	$1, %r11d
	movl	60(%rsp), %r9d          # 4-byte Reload
	jne	.LBB2_61
# %bb.58:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB2_64
.LBB2_60:
	movl	60(%rsp), %r9d          # 4-byte Reload
	jmp	.LBB2_66
.LBB2_61:                               # %for_loop255.lr.ph.new
	movabsq	$8589934592, %r8        # imm = 0x200000000
	movabsq	$4294967296, %r15       # imm = 0x100000000
	leaq	512(%rsp), %rdi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	movw	$-21846, %r10w          # imm = 0xAAAA
	movl	%r11d, %esi
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB2_62:                               # %for_loop255
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdx, %rbx
	sarq	$25, %rbx
	vpaddq	384(%rsp,%rbx), %zmm0, %zmm0
	vpaddq	448(%rsp,%rbx), %zmm1, %zmm1
	movl	%esi, %ebx
	shlq	$7, %rbx
	vpaddq	12736(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12672(%rsp,%rbx), %zmm0, %zmm0
	kmovw	%r10d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa64	%zmm2, -128(%rdi)
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqa64	%zmm2, -64(%rdi)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	leaq	(%rdx,%r15), %rbx
	sarq	$25, %rbx
	vpaddq	384(%rsp,%rbx), %zmm0, %zmm0
	vpaddq	448(%rsp,%rbx), %zmm1, %zmm1
	leal	1(%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	12736(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12672(%rsp,%rbx), %zmm0, %zmm0
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 64(%rdi)
	vmovdqa64	%zmm2, (%rdi)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addq	$2, %rcx
	addl	$2, %esi
	addq	$256, %rdi              # imm = 0x100
	addq	%r8, %rdx
	cmpl	%ecx, %eax
	jne	.LBB2_62
# %bb.63:                               # %for_test253.for_exit256_crit_edge.unr-lcssa
	testl	%r12d, %r12d
	je	.LBB2_65
.LBB2_64:                               # %for_loop255.epil.preheader
	movslq	%ecx, %rax
	movq	%rax, %rdx
	shlq	$7, %rdx
	vpaddq	384(%rsp,%rdx), %zmm0, %zmm0
	vpaddq	448(%rsp,%rdx), %zmm1, %zmm1
	addl	%r11d, %eax
	shlq	$7, %rax
	vpaddq	12736(%rsp,%rax), %zmm1, %zmm1
	vpaddq	12672(%rsp,%rax), %zmm0, %zmm0
	shlq	$7, %rcx
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 448(%rsp,%rcx)
	vmovdqa64	%zmm2, 384(%rsp,%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB2_65:                               # %for_test253.for_exit256_crit_edge
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
.LBB2_66:                               # %for_exit256
	kandw	%k4, %k1, %k0
	kortestw	%k0, %k0
	je	.LBB2_74
# %bb.67:                               # %for_exit256
	testl	%r11d, %r11d
	je	.LBB2_74
# %bb.68:                               # %for_loop290.lr.ph
	vpbroadcastd	%r9d, %zmm0
	cmpl	$1, %r11d
	jne	.LBB2_70
# %bb.69:
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB2_73
.LBB2_70:                               # %for_loop290.lr.ph.new
	movl	$32, %eax
	subl	%r9d, %eax
	vpbroadcastd	%eax, %zmm1
	movl	%r11d, %r8d
	andl	$1, %r8d
	movabsq	$8589934592, %r9        # imm = 0x200000000
	movabsq	$4294967296, %r10       # imm = 0x100000000
	movl	%r11d, %edi
	subl	%r8d, %edi
	leaq	512(%rsp), %rbx
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%esi, %esi
	movw	$-21846, %dx            # imm = 0xAAAA
	kshiftrw	$8, %k1, %k2
	xorl	%eax, %eax
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_71:                               # %for_loop290
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rcx
	sarq	$26, %rcx
	vmovdqa64	8576(%rsp,%rcx), %zmm5
	vpsllvd	%zmm0, %zmm5, %zmm6
	vpord	%zmm2, %zmm6, %zmm2
	vpsrlvd	%zmm1, %zmm5, %zmm5
	vextracti64x4	$1, %zmm2, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	-128(%rbx), %zmm7
	vmovdqa64	-64(%rbx), %zmm8
	vmovdqa64	(%rbx), %zmm9
	vmovdqa64	64(%rbx), %zmm10
	vpsubq	%zmm2, %zmm7, %zmm2
	vpaddq	%zmm3, %zmm2, %zmm2
	vpsubq	%zmm6, %zmm8, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	kmovw	%edx, %k0
	knotw	%k0, %k3
	vmovdqa32	%zmm2, %zmm4 {%k3}{z}
	vmovdqa32	%zmm3, %zmm6 {%k3}{z}
	vmovdqa64	%zmm6, %zmm8 {%k2}
	vmovdqa64	%zmm8, -64(%rbx)
	vmovdqa64	%zmm4, %zmm7 {%k1}
	vmovdqa64	%zmm7, -128(%rbx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm4
	leaq	(%rsi,%r10), %rcx
	sarq	$26, %rcx
	vmovdqa64	8576(%rsp,%rcx), %zmm2
	vpsllvd	%zmm0, %zmm2, %zmm6
	vpord	%zmm5, %zmm6, %zmm5
	vpsrlvd	%zmm1, %zmm2, %zmm2
	vpmovzxdq	%ymm5, %zmm6    # zmm6 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vextracti64x4	$1, %zmm5, %ymm5
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpsubq	%zmm5, %zmm10, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	%zmm6, %zmm9, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm5
	vmovdqa32	%zmm3, %zmm4 {%k3}{z}
	vmovdqa32	%zmm5, %zmm6 {%k3}{z}
	vmovdqa64	%zmm6, %zmm9 {%k1}
	vmovdqa64	%zmm4, %zmm10 {%k2}
	vmovdqa64	%zmm10, 64(%rbx)
	vmovdqa64	%zmm9, (%rbx)
	vpsraq	$32, %zmm3, %zmm4
	vpsraq	$32, %zmm5, %zmm3
	addq	$2, %rax
	addq	$256, %rbx              # imm = 0x100
	addq	%r9, %rsi
	cmpl	%eax, %edi
	jne	.LBB2_71
# %bb.72:                               # %for_test288.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	je	.LBB2_74
.LBB2_73:                               # %for_loop290.epil.preheader
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm1
	cltq
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm5
	vpsllvd	%zmm0, %zmm5, %zmm0
	vmovdqa64	448(%rsp,%rcx), %zmm5
	vpord	%zmm2, %zmm0, %zmm0
	vpmovzxdq	%ymm0, %zmm2    # zmm2 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vextracti64x4	$1, %zmm0, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpsubq	%zmm0, %zmm5, %zmm0
	vpaddq	%zmm4, %zmm0, %zmm0
	vpsubq	%zmm2, %zmm1, %zmm2
	vpaddq	%zmm3, %zmm2, %zmm2
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm0, %zmm0 {%k2}{z}
	vmovdqa32	%zmm2, %zmm2 {%k2}{z}
	vmovdqa64	%zmm2, %zmm1 {%k1}
	kshiftrw	$8, %k1, %k1
	vmovdqa64	%zmm0, %zmm5 {%k1}
	vmovdqa64	%zmm5, 448(%rsp,%rcx)
	vmovdqa64	%zmm1, 384(%rsp,%rcx)
.LBB2_74:                               # %safe_if_after_true
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vmovdqa64	384(%rsp,%rax), %zmm0
	vmovdqa64	448(%rsp,%rax), %zmm1
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm1
	vpand	%xmm12, %xmm1, %xmm0
	vpxor	%xmm8, %xmm8, %xmm8
	vpcmpeqb	%xmm8, %xmm0, %xmm0
	vpternlogq	$15, %zmm0, %zmm0, %zmm0
	vpmovsxbd	%xmm0, %zmm0
	vptestmd	%zmm0, %zmm0, %k0
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	kortestw	%k0, %k0
	je	.LBB2_78
# %bb.75:                               # %for_test347.preheader
	movl	%r11d, %eax
	negl	%eax
	sbbb	%al, %al
	vmovd	%eax, %xmm3
	vpbroadcastb	%xmm3, %xmm3
	vpand	%xmm1, %xmm3, %xmm3
	vpand	%xmm12, %xmm3, %xmm4
	vpcmpeqb	%xmm8, %xmm4, %xmm4
	vpternlogq	$15, %zmm4, %zmm4, %zmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k0
	kortestw	%k0, %k0
	je	.LBB2_78
# %bb.76:                               # %for_loop349.preheader
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpbroadcastd	.LCPI2_1(%rip), %zmm5 # zmm5 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_77:                               # %for_loop349
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	8576(%rsp,%rdx), %zmm5, %zmm6
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpcmpltud	8576(%rsp,%rdx), %zmm6, %k1
	vpternlogd	$255, %zmm7, %zmm7, %zmm7 {%k1}{z}
	vpsrld	$31, %zmm7, %zmm7
	vpcmpeqb	%xmm4, %xmm3, %xmm2
	vpmovsxbd	%xmm2, %zmm2
	vptestmd	%zmm2, %zmm2, %k1
	vmovdqa32	%zmm5, %zmm7 {%k1}
	shlq	$7, %rcx
	vextracti64x4	$1, %zmm6, %ymm2
	vpmovzxdq	%ymm6, %zmm5    # zmm5 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpcmpeqq	384(%rsp,%rcx), %zmm5, %k0
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vpcmpeqq	448(%rsp,%rcx), %zmm2, %k2
	kunpckbw	%k0, %k2, %k0
	korw	%k1, %k0, %k1
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	vpand	%xmm0, %xmm2, %xmm0
	addl	$1, %eax
	cmpl	%r11d, %eax
	sbbb	%cl, %cl
	vmovd	%ecx, %xmm2
	vpbroadcastb	%xmm2, %xmm2
	vpand	%xmm2, %xmm3, %xmm2
	vpand	%xmm2, %xmm0, %xmm3
	vpand	%xmm12, %xmm3, %xmm2
	vpcmpeqb	%xmm4, %xmm2, %xmm2
	vpternlogq	$15, %zmm2, %zmm2, %zmm2
	vpmovsxbd	%xmm2, %zmm2
	vptestmd	%zmm2, %zmm2, %k0
	kortestw	%k0, %k0
	vmovdqa64	%zmm7, %zmm5
	jne	.LBB2_77
.LBB2_78:                               # %safe_if_after_true339
	vpandn	%xmm12, %xmm1, %xmm3
	vpcmpeqb	%xmm8, %xmm3, %xmm2
	vpternlogq	$15, %zmm2, %zmm2, %zmm2
	vpmovsxbd	%xmm2, %zmm2
	vptestmd	%zmm2, %zmm2, %k0
	kortestw	%k0, %k0
	je	.LBB2_82
# %bb.79:                               # %safe_if_run_false405
	vpbroadcastq	.LCPI2_2(%rip), %zmm2 # zmm2 = [1,1,1,1,1,1,1,1]
	vpcmpeqq	384(%rsp), %zmm2, %k0
	vpcmpeqq	448(%rsp), %zmm2, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	vpblendvb	%xmm1, %xmm0, %xmm2, %xmm0
	cmpl	$1, %r11d
	seta	%al
	vpternlogq	$15, %zmm1, %zmm1, %zmm1
	negb	%al
	vmovd	%eax, %xmm2
	vpbroadcastb	%xmm2, %xmm2
	vpand	%xmm1, %xmm0, %xmm1
	vpand	%xmm2, %xmm1, %xmm1
	vpand	%xmm12, %xmm1, %xmm3
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqb	%xmm2, %xmm3, %xmm3
	vpternlogq	$15, %zmm3, %zmm3, %zmm3
	vpmovsxbd	%xmm3, %zmm3
	vptestmd	%zmm3, %zmm3, %k0
	kortestw	%k0, %k0
	je	.LBB2_82
# %bb.80:                               # %for_loop417.preheader
	movl	$1, %eax
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB2_81:                               # %for_loop417
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	384(%rsp,%rcx), %zmm3, %k0
	vpcmpeqq	448(%rsp,%rcx), %zmm3, %k1
	kunpckbw	%k0, %k1, %k0
	vpcmpeqb	%xmm2, %xmm1, %xmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k1
	korw	%k1, %k0, %k1
	vpternlogd	$255, %zmm4, %zmm4, %zmm4 {%k1}{z}
	vpmovdb	%zmm4, %xmm4
	vpand	%xmm0, %xmm4, %xmm0
	addl	$1, %eax
	cmpl	%r11d, %eax
	sbbb	%cl, %cl
	vmovd	%ecx, %xmm4
	vpbroadcastb	%xmm4, %xmm4
	vpand	%xmm4, %xmm1, %xmm1
	vpand	%xmm1, %xmm0, %xmm1
	vpand	%xmm12, %xmm1, %xmm4
	vpcmpeqb	%xmm2, %xmm4, %xmm4
	vpternlogq	$15, %zmm4, %zmm4, %zmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k0
	kortestw	%k0, %k0
	jne	.LBB2_81
.LBB2_82:                               # %if_done338
	vpand	.LCPI2_3(%rip), %xmm0, %xmm0
	vpmovzxbd	%xmm0, %zmm0    # zmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[9],zero,zero,zero,xmm0[10],zero,zero,zero,xmm0[11],zero,zero,zero,xmm0[12],zero,zero,zero,xmm0[13],zero,zero,zero,xmm0[14],zero,zero,zero,xmm0[15],zero,zero,zero
	vmovdqu32	%zmm0, (%r14) {%k4}
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
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2
.LCPI3_1:
	.long	1                       # 0x1
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI3_2:
	.quad	1                       # 0x1
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI3_3:
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
	movl	%r8d, %r11d
	movq	%rcx, %r14
	kxorw	%k0, %k0, %k1
	testl	%r8d, %r8d
	je	.LBB3_64
# %bb.1:                                # %for_loop.lr.ph
	vpbroadcastd	%r11d, %zmm0
	vpmulld	.LCPI3_0(%rip), %zmm0, %zmm0
	movl	%r11d, %r10d
	andl	$1, %r10d
	cmpl	$1, %r11d
	movq	%r14, 88(%rsp)          # 8-byte Spill
	movl	%r9d, 80(%rsp)          # 4-byte Spill
	movl	%r10d, 84(%rsp)         # 4-byte Spill
	jne	.LBB3_3
# %bb.2:
	xorl	%eax, %eax
	jmp	.LBB3_6
.LBB3_3:                                # %for_loop.lr.ph.new
	movl	%r11d, %r8d
	subl	%r10d, %r8d
	movl	$64, %ebx
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
	vmovdqa64	%zmm2, 8512(%rsp,%rbx)
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k1}
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm2, 320(%rsp,%rbx,2)
	vmovdqa64	%zmm1, 256(%rsp,%rbx,2)
	leal	1(%rax), %ecx
	vpbroadcastd	%ecx, %zmm1
	vpaddd	%zmm0, %zmm1, %zmm1
	vpslld	$2, %zmm1, %zmm1
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdi,%zmm1), %zmm2 {%k1}
	vmovdqa64	%zmm2, 8576(%rsp,%rbx)
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm2, %xmm2, %xmm2
	vpgatherdd	(%rdx,%zmm1), %zmm2 {%k1}
	vpmovzxdq	%ymm2, %zmm1    # zmm1 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vextracti64x4	$1, %zmm2, %ymm2
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	%zmm2, 448(%rsp,%rbx,2)
	vmovdqa64	%zmm1, 384(%rsp,%rbx,2)
	addq	$2, %rax
	subq	$-128, %rbx
	cmpl	%eax, %r8d
	jne	.LBB3_4
# %bb.5:                                # %for_test.for_exit_crit_edge.unr-lcssa
	testl	%r10d, %r10d
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
	vmovdqu64	(%rsi), %zmm0
	vmovdqa64	%zmm0, 128(%rsp) # 64-byte Spill
	testl	%r11d, %r11d
	jle	.LBB3_16
# %bb.8:                                # %for_loop32.lr.ph
	movabsq	$8589934592, %r15       # imm = 0x200000000
	movabsq	$4294967296, %r14       # imm = 0x100000000
	movl	$-2147483648, %eax      # imm = 0x80000000
	movl	80(%rsp), %ecx          # 4-byte Reload
	shrxl	%ecx, %eax, %r8d
	vpbroadcastd	%ecx, %zmm12
	movl	$32, %eax
	subl	%ecx, %eax
	vpbroadcastd	%eax, %zmm13
	leal	-1(%r11), %r13d
	movslq	%r11d, %rcx
	movl	%r11d, %ebx
	subl	84(%rsp), %ebx          # 4-byte Folded Reload
	leal	1(%r11), %edi
	movw	$-21846, %r12w          # imm = 0xAAAA
	movq	%r11, 120(%rsp)         # 8-byte Spill
	vmovdqa64	%zmm12, 256(%rsp) # 64-byte Spill
	vmovdqa64	%zmm13, 192(%rsp) # 64-byte Spill
	movq	%rdi, 112(%rsp)         # 8-byte Spill
	.p2align	4, 0x90
.LBB3_9:                                # %for_loop32
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_12 Depth 2
                                        #       Child Loop BB3_13 Depth 3
                                        #         Child Loop BB3_26 Depth 4
                                        #       Child Loop BB3_45 Depth 3
                                        #       Child Loop BB3_36 Depth 3
                                        #         Child Loop BB3_39 Depth 4
	addq	$-1, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	movq	%rcx, 104(%rsp)         # 8-byte Spill
	testq	%rcx, %rcx
	vpternlogd	$255, %zmm0, %zmm0, %zmm0
	je	.LBB3_11
# %bb.10:                               # %for_loop32
                                        #   in Loop: Header=BB3_9 Depth=1
	vpxor	%xmm0, %xmm0, %xmm0
.LBB3_11:                               # %for_loop32
                                        #   in Loop: Header=BB3_9 Depth=1
	vpaddd	8576(%rsp,%rax), %zmm0, %zmm0
	vmovdqa64	%zmm0, 320(%rsp) # 64-byte Spill
	.p2align	4, 0x90
.LBB3_12:                               # %for_loop49.lr.ph.split.us
                                        #   Parent Loop BB3_9 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_13 Depth 3
                                        #         Child Loop BB3_26 Depth 4
                                        #       Child Loop BB3_45 Depth 3
                                        #       Child Loop BB3_36 Depth 3
                                        #         Child Loop BB3_39 Depth 4
	movl	%r8d, 100(%rsp)         # 4-byte Spill
	leaq	29056(%rsp), %rdi
	leaq	384(%rsp), %rsi
	movl	%r11d, %edx
	callq	toom2SquareFull___UM_un_3C_vyU_3E_un_3C_CvyU_3E_unu
	leaq	8640(%rsp), %r9
	movq	120(%rsp), %r11         # 8-byte Reload
	movl	$1, %eax
	xorl	%ecx, %ecx
	vmovdqa64	128(%rsp), %zmm6 # 64-byte Reload
	.p2align	4, 0x90
.LBB3_13:                               # %for_loop60.lr.ph.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_26 Depth 4
	movq	%rcx, %r8
	shlq	$7, %r8
	vmovdqa64	29056(%rsp,%r8), %zmm0
	vmovdqa64	29120(%rsp,%r8), %zmm1
	vpmovqd	%zmm0, %ymm0
	vpmovqd	%zmm1, %ymm1
	vinserti64x4	$1, %ymm1, %zmm0, %zmm0
	vpmulld	%zmm0, %zmm6, %zmm1
	vextracti64x4	$1, %zmm1, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpxor	%xmm2, %xmm2, %xmm2
	testl	%r13d, %r13d
	je	.LBB3_14
# %bb.25:                               # %for_loop60.lr.ph.us.new
                                        #   in Loop: Header=BB3_13 Depth=3
	movq	%r9, %rdi
	xorl	%esi, %esi
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_26:                               # %for_loop60.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        #       Parent Loop BB3_13 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpmovzxdq	-64(%rdi), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-32(%rdi), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm5
	leal	(%rcx,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpmuludq	%zmm1, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqa64	%zmm5, 29120(%rsp,%rdx)
	vpaddq	%zmm4, %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	32(%rdi), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm2, %zmm2
	vpmovzxdq	(%rdi), %zmm5   # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm5
	leal	(%rax,%rsi), %edx
	shlq	$7, %rdx
	vpaddq	29056(%rsp,%rdx), %zmm2, %zmm2
	vpmuludq	%zmm0, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm2, %zmm2
	vpaddq	29120(%rsp,%rdx), %zmm3, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	vmovdqa32	%zmm3, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 29120(%rsp,%rdx)
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 29056(%rsp,%rdx)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rsi
	subq	$-128, %rdi
	cmpl	%esi, %ebx
	jne	.LBB3_26
# %bb.27:                               # %for_test58.for_exit61_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_13 Depth=3
	testb	$1, %r11b
	jne	.LBB3_28
	jmp	.LBB3_29
	.p2align	4, 0x90
.LBB3_14:                               #   in Loop: Header=BB3_13 Depth=3
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%esi, %esi
.LBB3_28:                               # %for_loop60.us.epil.preheader
                                        #   in Loop: Header=BB3_13 Depth=3
	movq	%rsi, %rdx
	shlq	$6, %rdx
	vpmovzxdq	8608(%rsp,%rdx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8576(%rsp,%rdx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm1
	vpmuludq	%zmm0, %zmm4, %zmm0
	addl	%ecx, %esi
	shlq	$7, %rsi
	vpaddq	29056(%rsp,%rsi), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	vpaddq	29120(%rsp,%rsi), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqa32	%zmm0, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 29120(%rsp,%rsi)
	vmovdqa64	%zmm2, 29056(%rsp,%rsi)
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm2
.LBB3_29:                               # %for_exit61.us
                                        #   in Loop: Header=BB3_13 Depth=3
	vmovdqa64	%zmm3, 448(%rsp,%r8)
	vmovdqa64	%zmm2, 384(%rsp,%r8)
	addq	$1, %rcx
	movl	%r11d, %edx
	addq	$1, %rax
	cmpq	%rdx, %rcx
	jne	.LBB3_13
# %bb.30:                               # %for_loop90.lr.ph
                                        #   in Loop: Header=BB3_12 Depth=2
	movl	100(%rsp), %r8d         # 4-byte Reload
	vpbroadcastd	%r8d, %zmm0
	vptestmd	320(%rsp), %zmm0, %k1 # 64-byte Folded Reload
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm2
	kshiftrw	$8, %k1, %k1
	vpternlogq	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpsrlq	$63, %zmm0, %zmm3
	testl	%r13d, %r13d
	vmovdqa64	256(%rsp), %zmm12 # 64-byte Reload
	vmovdqa64	192(%rsp), %zmm13 # 64-byte Reload
	movq	112(%rsp), %rdi         # 8-byte Reload
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm0, %xmm0, %xmm0
	je	.LBB3_31
# %bb.44:                               # %for_loop90.lr.ph.new
                                        #   in Loop: Header=BB3_12 Depth=2
	xorl	%eax, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB3_45:                               # %for_loop90
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$7, %rdx
	leal	(%r11,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa64	29056(%rsp,%rsi), %zmm4
	vmovdqa64	29120(%rsp,%rsi), %zmm5
	vpaddq	384(%rsp,%rdx), %zmm4, %zmm4
	vpaddq	448(%rsp,%rdx), %zmm5, %zmm5
	vpsllvq	%zmm3, %zmm5, %zmm5
	vpsllvq	%zmm2, %zmm4, %zmm4
	vpaddq	%zmm1, %zmm5, %zmm1
	vpaddq	%zmm0, %zmm4, %zmm0
	shlq	$7, %rcx
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 448(%rsp,%rcx)
	vmovdqa32	%zmm0, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 384(%rsp,%rcx)
	vpsrlq	$32, %zmm0, %zmm0
	leal	1(%rax), %ecx
	movslq	%ecx, %rdx
	shlq	$7, %rdx
	leal	(%rdi,%rax), %esi
	movslq	%esi, %rsi
	shlq	$7, %rsi
	vmovdqa64	29056(%rsp,%rsi), %zmm4
	vmovdqa64	29120(%rsp,%rsi), %zmm5
	vpaddq	448(%rsp,%rdx), %zmm5, %zmm5
	vpaddq	384(%rsp,%rdx), %zmm4, %zmm4
	vpsrlq	$32, %zmm1, %zmm1
	vpsllvq	%zmm2, %zmm4, %zmm4
	vpaddq	%zmm0, %zmm4, %zmm0
	vpsllvq	%zmm3, %zmm5, %zmm4
	vpaddq	%zmm1, %zmm4, %zmm1
	shlq	$7, %rcx
	vmovdqa32	%zmm0, %zmm4 {%k1}{z}
	vmovdqa32	%zmm1, %zmm5 {%k1}{z}
	vmovdqa64	%zmm5, 448(%rsp,%rcx)
	vmovdqa64	%zmm4, 384(%rsp,%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addl	$2, %eax
	cmpl	%eax, %ebx
	jne	.LBB3_45
# %bb.32:                               # %for_test88.for_test124.preheader_crit_edge.unr-lcssa
                                        #   in Loop: Header=BB3_12 Depth=2
	testb	$1, %r11b
	leaq	512(%rsp), %r9
	jne	.LBB3_33
	jmp	.LBB3_34
	.p2align	4, 0x90
.LBB3_31:                               #   in Loop: Header=BB3_12 Depth=2
	xorl	%eax, %eax
	vpxor	%xmm1, %xmm1, %xmm1
	leaq	512(%rsp), %r9
.LBB3_33:                               # %for_loop90.epil.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	movslq	%eax, %rcx
	movq	%rcx, %rdx
	shlq	$7, %rdx
	addl	%r11d, %ecx
	movslq	%ecx, %rcx
	shlq	$7, %rcx
	vmovdqa64	29056(%rsp,%rcx), %zmm4
	vmovdqa64	29120(%rsp,%rcx), %zmm5
	vpaddq	448(%rsp,%rdx), %zmm5, %zmm5
	vpaddq	384(%rsp,%rdx), %zmm4, %zmm4
	vpsllvq	%zmm2, %zmm4, %zmm2
	movl	%eax, %eax
	vpsllvq	%zmm3, %zmm5, %zmm3
	vpaddq	%zmm0, %zmm2, %zmm0
	vpaddq	%zmm1, %zmm3, %zmm1
	shlq	$7, %rax
	kmovw	%r12d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 448(%rsp,%rax)
	vmovdqa64	%zmm2, 384(%rsp,%rax)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB3_34:                               # %for_test124.preheader
                                        #   in Loop: Header=BB3_12 Depth=2
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	je	.LBB3_43
# %bb.35:                               #   in Loop: Header=BB3_12 Depth=2
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	.p2align	4, 0x90
.LBB3_36:                               # %for_loop140.lr.ph.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_39 Depth 4
	testl	%r13d, %r13d
	je	.LBB3_37
# %bb.38:                               # %for_loop140.lr.ph.us.new
                                        #   in Loop: Header=BB3_36 Depth=3
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%ecx, %ecx
	movq	%r9, %rdx
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_39:                               # %for_loop140.us
                                        #   Parent Loop BB3_9 Depth=1
                                        #     Parent Loop BB3_12 Depth=2
                                        #       Parent Loop BB3_36 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vpcmpeqb	%xmm14, %xmm2, %xmm6
	movq	%rcx, %rsi
	sarq	$26, %rsi
	vmovdqa64	8576(%rsp,%rsi), %zmm7
	vpsllvd	%zmm12, %zmm7, %zmm8
	vpmovsxbd	%xmm6, %zmm6
	vpsrlvd	%zmm13, %zmm7, %zmm7
	vptestmd	%zmm6, %zmm6, %k1
	vpord	%zmm5, %zmm8, %zmm5
	vextracti64x4	$1, %zmm5, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vmovdqa64	-128(%rdx), %zmm8
	vmovdqa64	-64(%rdx), %zmm9
	vmovdqa64	(%rdx), %zmm10
	vmovdqa64	64(%rdx), %zmm11
	vpsubq	%zmm5, %zmm8, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm4
	vpsubq	%zmm6, %zmm9, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	kmovw	%r12d, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm4, %zmm5 {%k2}{z}
	kshiftrw	$8, %k1, %k3
	vmovdqa32	%zmm3, %zmm6 {%k2}{z}
	vmovdqa64	%zmm9, %zmm6 {%k3}
	vmovdqa64	%zmm6, -64(%rdx)
	vmovdqa64	%zmm8, %zmm5 {%k1}
	vmovdqa64	%zmm5, -128(%rdx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm4, %zmm4
	leaq	(%rcx,%r14), %rsi
	sarq	$26, %rsi
	vmovdqa64	8576(%rsp,%rsi), %zmm5
	vpsllvd	%zmm12, %zmm5, %zmm6
	vpord	%zmm7, %zmm6, %zmm6
	vpsrlvd	%zmm13, %zmm5, %zmm5
	vpmovzxdq	%ymm6, %zmm7    # zmm7 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vextracti64x4	$1, %zmm6, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpsubq	%zmm6, %zmm11, %zmm6
	vpaddq	%zmm3, %zmm6, %zmm3
	vpsubq	%zmm7, %zmm10, %zmm6
	vpaddq	%zmm4, %zmm6, %zmm4
	vmovdqa32	%zmm3, %zmm6 {%k2}{z}
	vmovdqa32	%zmm4, %zmm7 {%k2}{z}
	vmovdqa64	%zmm10, %zmm7 {%k1}
	vmovdqa64	%zmm11, %zmm6 {%k3}
	vmovdqa64	%zmm6, 64(%rdx)
	vmovdqa64	%zmm7, (%rdx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm4, %zmm4
	addq	$2, %rax
	addq	$256, %rdx              # imm = 0x100
	addq	%r15, %rcx
	cmpl	%eax, %ebx
	jne	.LBB3_39
# %bb.40:                               # %for_test138.for_exit141_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_36 Depth=3
	testb	$1, %r11b
	jne	.LBB3_41
	jmp	.LBB3_42
	.p2align	4, 0x90
.LBB3_37:                               #   in Loop: Header=BB3_36 Depth=3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm5, %xmm5, %xmm5
	xorl	%eax, %eax
.LBB3_41:                               # %for_loop140.us.epil.preheader
                                        #   in Loop: Header=BB3_36 Depth=3
	vpcmpeqb	%xmm14, %xmm2, %xmm6
	vpmovsxbd	%xmm6, %zmm6
	vptestmd	%zmm6, %zmm6, %k1
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm6
	vmovdqa64	448(%rsp,%rcx), %zmm7
	cltq
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm8
	vpsllvd	%zmm12, %zmm8, %zmm8
	vpord	%zmm5, %zmm8, %zmm5
	vpmovzxdq	%ymm5, %zmm8    # zmm8 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vextracti64x4	$1, %zmm5, %ymm5
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpsubq	%zmm5, %zmm7, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	%zmm8, %zmm6, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm4
	kmovw	%r12d, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm3, %zmm5 {%k2}{z}
	vmovdqa32	%zmm4, %zmm8 {%k2}{z}
	vmovdqa64	%zmm6, %zmm8 {%k1}
	kshiftrw	$8, %k1, %k1
	vmovdqa64	%zmm7, %zmm5 {%k1}
	vmovdqa64	%zmm5, 448(%rsp,%rcx)
	vmovdqa64	%zmm8, 384(%rsp,%rcx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm4, %zmm4
.LBB3_42:                               # %for_exit141.us
                                        #   in Loop: Header=BB3_36 Depth=3
	vpcmpeqb	%xmm14, %xmm2, %xmm5
	vpmovsxbd	%xmm5, %zmm5
	vptestmd	%zmm5, %zmm5, %k0
	knotw	%k0, %k1
	vmovdqa64	%zmm4, %zmm4 {%k1}{z}
	vpaddq	%zmm0, %zmm4, %zmm0
	kshiftrw	$8, %k0, %k0
	knotw	%k0, %k1
	vmovdqa64	%zmm3, %zmm3 {%k1}{z}
	vpaddq	%zmm1, %zmm3, %zmm1
	vptestnmq	%zmm0, %zmm0, %k0
	vptestnmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm3, %zmm3, %zmm3 {%k1}{z}
	vpmovdb	%zmm3, %xmm3
	vpandn	%xmm2, %xmm3, %xmm2
	vpcmpeqb	%xmm14, %xmm2, %xmm3
	vpternlogq	$15, %zmm3, %zmm3, %zmm3
	vpmovsxbd	%xmm3, %zmm3
	vptestmd	%zmm3, %zmm3, %k0
	kortestw	%k0, %k0
	jne	.LBB3_36
.LBB3_43:                               # %for_exit127
                                        #   in Loop: Header=BB3_12 Depth=2
	shrl	%r8d
	jne	.LBB3_12
# %bb.15:                               # %for_test30.loopexit
                                        #   in Loop: Header=BB3_9 Depth=1
	movl	$-2147483648, %r8d      # imm = 0x80000000
	movq	104(%rsp), %rcx         # 8-byte Reload
	testq	%rcx, %rcx
	jg	.LBB3_9
.LBB3_16:                               # %for_test186.preheader
	testl	%r11d, %r11d
	je	.LBB3_17
# %bb.18:                               # %for_loop188.lr.ph
	leal	-1(%r11), %ecx
	movl	%r11d, %eax
	andl	$3, %eax
	cmpl	$3, %ecx
	jae	.LBB3_57
# %bb.19:
	xorl	%ecx, %ecx
	movq	88(%rsp), %r14          # 8-byte Reload
	kxorw	%k0, %k0, %k1
	movl	84(%rsp), %r12d         # 4-byte Reload
	jmp	.LBB3_20
.LBB3_17:
	movq	88(%rsp), %r14          # 8-byte Reload
	kxorw	%k0, %k0, %k1
	movl	80(%rsp), %r9d          # 4-byte Reload
	kortestw	%k1, %k1
	jne	.LBB3_65
	jmp	.LBB3_70
.LBB3_57:                               # %for_loop188.lr.ph.new
	movl	%r11d, %edx
	subl	%eax, %edx
	movl	%r11d, %r8d
	movl	$384, %edi              # imm = 0x180
	xorl	%ecx, %ecx
	vpxor	%xmm0, %xmm0, %xmm0
	movq	88(%rsp), %r14          # 8-byte Reload
	kxorw	%k0, %k0, %k1
	movl	84(%rsp), %r12d         # 4-byte Reload
	.p2align	4, 0x90
.LBB3_58:                               # %for_loop188
                                        # =>This Inner Loop Header: Depth=1
	vmovaps	(%rsp,%rdi), %zmm1
	vmovaps	64(%rsp,%rdi), %zmm2
	vmovdqa64	128(%rsp,%rdi), %zmm3
	vmovaps	%zmm2, 12352(%rsp,%rdi)
	vmovaps	192(%rsp,%rdi), %zmm2
	vmovaps	%zmm1, 12288(%rsp,%rdi)
	leaq	(%r8,%rcx), %rbx
	movl	%ebx, %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovaps	%zmm2, 12480(%rsp,%rdi)
	vmovdqa64	%zmm3, 12416(%rsp,%rdi)
	leal	1(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovaps	256(%rsp,%rdi), %zmm1
	vmovaps	320(%rsp,%rdi), %zmm2
	vmovaps	%zmm2, 12608(%rsp,%rdi)
	vmovaps	%zmm1, 12544(%rsp,%rdi)
	leal	2(%rbx), %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	vmovdqa64	384(%rsp,%rdi), %zmm1
	vmovdqa64	448(%rsp,%rdi), %zmm2
	vmovdqa64	%zmm2, 12736(%rsp,%rdi)
	vmovdqa64	%zmm1, 12672(%rsp,%rdi)
	addl	$3, %ebx
	shlq	$7, %rbx
	vmovdqa64	%zmm0, 12736(%rsp,%rbx)
	vmovdqa64	%zmm0, 12672(%rsp,%rbx)
	addq	$4, %rcx
	addq	$512, %rdi              # imm = 0x200
	cmpl	%ecx, %edx
	jne	.LBB3_58
.LBB3_20:                               # %for_test186.for_test204.preheader_crit_edge.unr-lcssa
	testl	%eax, %eax
	vmovdqa64	128(%rsp), %zmm6 # 64-byte Reload
	je	.LBB3_23
# %bb.21:                               # %for_loop188.epil.preheader
	leal	(%r11,%rcx), %edx
	shlq	$7, %rcx
	negl	%eax
	vpxor	%xmm0, %xmm0, %xmm0
	.p2align	4, 0x90
.LBB3_22:                               # %for_loop188.epil
                                        # =>This Inner Loop Header: Depth=1
	vmovdqa64	384(%rsp,%rcx), %zmm1
	vmovdqa64	448(%rsp,%rcx), %zmm2
	vmovdqa64	%zmm2, 12736(%rsp,%rcx)
	vmovdqa64	%zmm1, 12672(%rsp,%rcx)
	movl	%edx, %esi
	shlq	$7, %rsi
	vmovdqa64	%zmm0, 12736(%rsp,%rsi)
	vmovdqa64	%zmm0, 12672(%rsp,%rsi)
	addl	$1, %edx
	subq	$-128, %rcx
	addl	$1, %eax
	jne	.LBB3_22
.LBB3_23:                               # %for_test204.preheader
	testl	%r11d, %r11d
	je	.LBB3_24
# %bb.46:                               # %for_loop222.lr.ph.us.preheader
	leaq	8640(%rsp), %r8
	movl	%r11d, %eax
	subl	%r12d, %eax
	movl	$1, %edx
	xorl	%esi, %esi
	movq	%r11, %rcx
	movw	$-21846, %r11w          # imm = 0xAAAA
	movq	%rcx, %r15
	movl	%ecx, %r9d
	.p2align	4, 0x90
.LBB3_47:                               # %for_loop222.lr.ph.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_50 Depth 2
	movq	%rsi, %r10
	shlq	$7, %r10
	vmovdqa64	12672(%rsp,%r10), %zmm0
	vmovdqa64	12736(%rsp,%r10), %zmm1
	vpmovqd	%zmm0, %ymm0
	vpmovqd	%zmm1, %ymm1
	vinserti64x4	$1, %ymm1, %zmm0, %zmm0
	vpmulld	%zmm0, %zmm6, %zmm1
	vextracti64x4	$1, %zmm1, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpmovzxdq	%ymm1, %zmm1    # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero
	vpxor	%xmm2, %xmm2, %xmm2
	cmpl	$1, %r15d
	jne	.LBB3_49
# %bb.48:                               #   in Loop: Header=BB3_47 Depth=1
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%ebx, %ebx
	jmp	.LBB3_52
	.p2align	4, 0x90
.LBB3_49:                               # %for_loop222.lr.ph.us.new
                                        #   in Loop: Header=BB3_47 Depth=1
	movq	%r8, %rcx
	xorl	%ebx, %ebx
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_50:                               # %for_loop222.us
                                        #   Parent Loop BB3_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovzxdq	-64(%rcx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	-32(%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm0, %zmm5, %zmm5
	leal	(%rsi,%rbx), %edi
	shlq	$7, %rdi
	vpaddq	12736(%rsp,%rdi), %zmm3, %zmm3
	vpmuludq	%zmm1, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm3, %zmm3
	vpaddq	12672(%rsp,%rdi), %zmm2, %zmm2
	kmovw	%r11d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm3, %zmm5 {%k1}{z}
	vmovdqa64	%zmm5, 12736(%rsp,%rdi)
	vpaddq	%zmm4, %zmm2, %zmm2
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 12672(%rsp,%rdi)
	vpsrlq	$32, %zmm3, %zmm3
	vpmovzxdq	32(%rcx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpsrlq	$32, %zmm2, %zmm2
	vpmovzxdq	(%rcx), %zmm5   # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm5
	leal	(%rdx,%rbx), %edi
	shlq	$7, %rdi
	vpaddq	12672(%rsp,%rdi), %zmm2, %zmm2
	vpmuludq	%zmm0, %zmm4, %zmm4
	vpaddq	%zmm5, %zmm2, %zmm2
	vpaddq	12736(%rsp,%rdi), %zmm3, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	vmovdqa32	%zmm3, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 12736(%rsp,%rdi)
	vmovdqa32	%zmm2, %zmm4 {%k1}{z}
	vmovdqa64	%zmm4, 12672(%rsp,%rdi)
	vpsrlq	$32, %zmm3, %zmm3
	vpsrlq	$32, %zmm2, %zmm2
	addq	$2, %rbx
	subq	$-128, %rcx
	cmpl	%ebx, %eax
	jne	.LBB3_50
# %bb.51:                               # %for_test220.for_exit223_crit_edge.us.unr-lcssa
                                        #   in Loop: Header=BB3_47 Depth=1
	testb	$1, %r15b
	je	.LBB3_53
.LBB3_52:                               # %for_loop222.us.epil.preheader
                                        #   in Loop: Header=BB3_47 Depth=1
	movq	%rbx, %rcx
	shlq	$6, %rcx
	vpmovzxdq	8608(%rsp,%rcx), %zmm4 # zmm4 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmovzxdq	8576(%rsp,%rcx), %zmm5 # zmm5 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpmuludq	%zmm1, %zmm5, %zmm1
	vpmuludq	%zmm0, %zmm4, %zmm0
	addl	%esi, %ebx
	shlq	$7, %rbx
	vpaddq	12672(%rsp,%rbx), %zmm2, %zmm2
	vpaddq	%zmm1, %zmm2, %zmm1
	vpaddq	12736(%rsp,%rbx), %zmm3, %zmm2
	vpaddq	%zmm0, %zmm2, %zmm0
	kmovw	%r11d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqa32	%zmm0, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 12736(%rsp,%rbx)
	vmovdqa64	%zmm2, 12672(%rsp,%rbx)
	vpsrlq	$32, %zmm0, %zmm3
	vpsrlq	$32, %zmm1, %zmm2
.LBB3_53:                               # %for_exit223.us
                                        #   in Loop: Header=BB3_47 Depth=1
	vmovdqa64	%zmm3, 448(%rsp,%r10)
	vmovdqa64	%zmm2, 384(%rsp,%r10)
	addq	$1, %rsi
	addq	$1, %rdx
	cmpq	%r9, %rsi
	kxorw	%k0, %k0, %k1
	jne	.LBB3_47
# %bb.54:                               # %for_test253.preheader
	movq	%r15, %r11
	testl	%r11d, %r11d
	movl	80(%rsp), %r9d          # 4-byte Reload
	je	.LBB3_64
# %bb.55:                               # %for_loop255.lr.ph
	cmpl	$1, %r11d
	jne	.LBB3_59
# %bb.56:
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	jmp	.LBB3_62
.LBB3_24:
	movl	80(%rsp), %r9d          # 4-byte Reload
.LBB3_64:                               # %for_exit256
	kortestw	%k1, %k1
	je	.LBB3_70
.LBB3_65:                               # %for_exit256
	testl	%r11d, %r11d
	je	.LBB3_70
# %bb.66:                               # %for_loop290.lr.ph
	vpbroadcastd	%r9d, %zmm0
	cmpl	$1, %r11d
	jne	.LBB3_79
# %bb.67:
	vpxor	%xmm3, %xmm3, %xmm3
	xorl	%eax, %eax
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm2, %xmm2, %xmm2
	jmp	.LBB3_69
.LBB3_79:                               # %for_loop290.lr.ph.new
	movl	$32, %eax
	subl	%r9d, %eax
	vpbroadcastd	%eax, %zmm1
	movl	%r11d, %r8d
	andl	$1, %r8d
	movabsq	$8589934592, %r9        # imm = 0x200000000
	movabsq	$4294967296, %r10       # imm = 0x100000000
	movl	%r11d, %edi
	subl	%r8d, %edi
	leaq	512(%rsp), %rbx
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%esi, %esi
	movw	$-21846, %dx            # imm = 0xAAAA
	kmovw	%k1, %k3
	kshiftrw	$8, %k1, %k1
	xorl	%eax, %eax
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB3_80:                               # %for_loop290
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsi, %rcx
	sarq	$26, %rcx
	vmovdqa64	8576(%rsp,%rcx), %zmm5
	vpsllvd	%zmm0, %zmm5, %zmm6
	vpord	%zmm2, %zmm6, %zmm2
	vpsrlvd	%zmm1, %zmm5, %zmm5
	vextracti64x4	$1, %zmm2, %ymm6
	vpmovzxdq	%ymm6, %zmm6    # zmm6 = ymm6[0],zero,ymm6[1],zero,ymm6[2],zero,ymm6[3],zero,ymm6[4],zero,ymm6[5],zero,ymm6[6],zero,ymm6[7],zero
	vpmovzxdq	%ymm2, %zmm2    # zmm2 = ymm2[0],zero,ymm2[1],zero,ymm2[2],zero,ymm2[3],zero,ymm2[4],zero,ymm2[5],zero,ymm2[6],zero,ymm2[7],zero
	vmovdqa64	-128(%rbx), %zmm7
	vmovdqa64	-64(%rbx), %zmm8
	vmovdqa64	(%rbx), %zmm9
	vmovdqa64	64(%rbx), %zmm10
	vpsubq	%zmm2, %zmm7, %zmm2
	vpaddq	%zmm3, %zmm2, %zmm2
	vpsubq	%zmm6, %zmm8, %zmm3
	vpaddq	%zmm4, %zmm3, %zmm3
	kmovw	%edx, %k0
	knotw	%k0, %k2
	vmovdqa32	%zmm2, %zmm4 {%k2}{z}
	vmovdqa32	%zmm3, %zmm6 {%k2}{z}
	vmovdqa64	%zmm6, %zmm8 {%k1}
	vmovdqa64	%zmm8, -64(%rbx)
	vmovdqa64	%zmm4, %zmm7 {%k3}
	vmovdqa64	%zmm7, -128(%rbx)
	vpsraq	$32, %zmm3, %zmm3
	vpsraq	$32, %zmm2, %zmm4
	leaq	(%rsi,%r10), %rcx
	sarq	$26, %rcx
	vmovdqa64	8576(%rsp,%rcx), %zmm2
	vpsllvd	%zmm0, %zmm2, %zmm6
	vpord	%zmm5, %zmm6, %zmm5
	vpsrlvd	%zmm1, %zmm2, %zmm2
	vpmovzxdq	%ymm5, %zmm6    # zmm6 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vextracti64x4	$1, %zmm5, %ymm5
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpsubq	%zmm5, %zmm10, %zmm5
	vpaddq	%zmm3, %zmm5, %zmm3
	vpsubq	%zmm6, %zmm9, %zmm5
	vpaddq	%zmm4, %zmm5, %zmm5
	vmovdqa32	%zmm3, %zmm4 {%k2}{z}
	vmovdqa32	%zmm5, %zmm6 {%k2}{z}
	vmovdqa64	%zmm6, %zmm9 {%k3}
	vmovdqa64	%zmm4, %zmm10 {%k1}
	vmovdqa64	%zmm10, 64(%rbx)
	vmovdqa64	%zmm9, (%rbx)
	vpsraq	$32, %zmm3, %zmm4
	vpsraq	$32, %zmm5, %zmm3
	addq	$2, %rax
	addq	$256, %rbx              # imm = 0x100
	addq	%r9, %rsi
	cmpl	%eax, %edi
	jne	.LBB3_80
# %bb.68:                               # %for_test288.safe_if_after_true.loopexit_crit_edge.unr-lcssa
	testl	%r8d, %r8d
	kmovw	%k3, %k1
	je	.LBB3_70
.LBB3_69:                               # %for_loop290.epil.preheader
	movq	%rax, %rcx
	shlq	$7, %rcx
	vmovdqa64	384(%rsp,%rcx), %zmm1
	cltq
	shlq	$6, %rax
	vmovdqa64	8576(%rsp,%rax), %zmm5
	vpsllvd	%zmm0, %zmm5, %zmm0
	vmovdqa64	448(%rsp,%rcx), %zmm5
	vpord	%zmm2, %zmm0, %zmm0
	vpmovzxdq	%ymm0, %zmm2    # zmm2 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vextracti64x4	$1, %zmm0, %ymm0
	vpmovzxdq	%ymm0, %zmm0    # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
	vpsubq	%zmm0, %zmm5, %zmm0
	vpaddq	%zmm4, %zmm0, %zmm0
	vpsubq	%zmm2, %zmm1, %zmm2
	vpaddq	%zmm3, %zmm2, %zmm2
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	kmovw	%k1, %k2
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm0 {%k1}{z}
	vmovdqa32	%zmm2, %zmm2 {%k1}{z}
	vmovdqa64	%zmm2, %zmm1 {%k2}
	kshiftrw	$8, %k2, %k1
	vmovdqa64	%zmm0, %zmm5 {%k1}
	vmovdqa64	%zmm5, 448(%rsp,%rcx)
	vmovdqa64	%zmm1, 384(%rsp,%rcx)
.LBB3_70:                               # %safe_if_after_true
	leal	-1(%r11), %eax
	shlq	$7, %rax
	vmovdqa64	384(%rsp,%rax), %zmm0
	vmovdqa64	448(%rsp,%rax), %zmm1
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm0, %zmm0, %zmm0 {%k1}{z}
	vpmovdb	%zmm0, %xmm1
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	kortestw	%k1, %k1
	je	.LBB3_74
# %bb.71:                               # %for_test347.preheader
	movl	%r11d, %eax
	negl	%eax
	sbbb	%al, %al
	vmovd	%eax, %xmm2
	vpbroadcastb	%xmm2, %xmm2
	vpand	%xmm1, %xmm2, %xmm3
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqb	%xmm2, %xmm3, %xmm4
	vpternlogq	$15, %zmm4, %zmm4, %zmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k0
	kortestw	%k0, %k0
	je	.LBB3_74
# %bb.72:                               # %for_loop349.preheader
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpbroadcastd	.LCPI3_1(%rip), %zmm4 # zmm4 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB3_73:                               # %for_loop349
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	cltq
	movq	%rax, %rdx
	shlq	$6, %rdx
	vpaddd	8576(%rsp,%rdx), %zmm4, %zmm5
	movq	%rcx, %rdx
	shlq	$6, %rdx
	vpcmpltud	8576(%rsp,%rdx), %zmm5, %k2
	vpternlogd	$255, %zmm6, %zmm6, %zmm6 {%k2}{z}
	vpsrld	$31, %zmm6, %zmm6
	vpcmpeqb	%xmm2, %xmm3, %xmm7
	vpmovsxbd	%xmm7, %zmm7
	vptestmd	%zmm7, %zmm7, %k2
	vmovdqa32	%zmm4, %zmm6 {%k2}
	shlq	$7, %rcx
	vextracti64x4	$1, %zmm5, %ymm4
	vpmovzxdq	%ymm4, %zmm4    # zmm4 = ymm4[0],zero,ymm4[1],zero,ymm4[2],zero,ymm4[3],zero,ymm4[4],zero,ymm4[5],zero,ymm4[6],zero,ymm4[7],zero
	vpmovzxdq	%ymm5, %zmm5    # zmm5 = ymm5[0],zero,ymm5[1],zero,ymm5[2],zero,ymm5[3],zero,ymm5[4],zero,ymm5[5],zero,ymm5[6],zero,ymm5[7],zero
	vpcmpeqq	384(%rsp,%rcx), %zmm5, %k0
	vpcmpeqq	448(%rsp,%rcx), %zmm4, %k3
	kunpckbw	%k0, %k3, %k0
	korw	%k2, %k0, %k2
	vpternlogd	$255, %zmm4, %zmm4, %zmm4 {%k2}{z}
	vpmovdb	%zmm4, %xmm4
	vpand	%xmm0, %xmm4, %xmm0
	addl	$1, %eax
	cmpl	%r11d, %eax
	sbbb	%cl, %cl
	vmovd	%ecx, %xmm4
	vpbroadcastb	%xmm4, %xmm4
	vpand	%xmm4, %xmm3, %xmm3
	vpand	%xmm3, %xmm0, %xmm3
	vpcmpeqb	%xmm2, %xmm3, %xmm4
	vpternlogq	$15, %zmm4, %zmm4, %zmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k0
	kortestw	%k0, %k0
	vmovdqa64	%zmm6, %zmm4
	jne	.LBB3_73
.LBB3_74:                               # %safe_if_after_true339
	kortestw	%k1, %k1
	jb	.LBB3_78
# %bb.75:                               # %safe_if_run_false405
	vpbroadcastq	.LCPI3_2(%rip), %zmm2 # zmm2 = [1,1,1,1,1,1,1,1]
	vpcmpeqq	384(%rsp), %zmm2, %k0
	vpcmpeqq	448(%rsp), %zmm2, %k1
	kunpckbw	%k0, %k1, %k1
	vpternlogd	$255, %zmm2, %zmm2, %zmm2 {%k1}{z}
	vpmovdb	%zmm2, %xmm2
	vpblendvb	%xmm1, %xmm0, %xmm2, %xmm0
	cmpl	$1, %r11d
	seta	%al
	negb	%al
	vmovd	%eax, %xmm2
	vpbroadcastb	%xmm2, %xmm2
	vpandn	%xmm0, %xmm1, %xmm1
	vpand	%xmm2, %xmm1, %xmm2
	vpxor	%xmm1, %xmm1, %xmm1
	vpcmpeqb	%xmm1, %xmm2, %xmm3
	vpternlogq	$15, %zmm3, %zmm3, %zmm3
	vpmovsxbd	%xmm3, %zmm3
	vptestmd	%zmm3, %zmm3, %k0
	kortestw	%k0, %k0
	je	.LBB3_78
# %bb.76:                               # %for_loop417.preheader
	movl	$1, %eax
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB3_77:                               # %for_loop417
                                        # =>This Inner Loop Header: Depth=1
	movl	%eax, %ecx
	shlq	$7, %rcx
	vpcmpeqq	384(%rsp,%rcx), %zmm3, %k0
	vpcmpeqq	448(%rsp,%rcx), %zmm3, %k1
	kunpckbw	%k0, %k1, %k0
	vpcmpeqb	%xmm1, %xmm2, %xmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k1
	korw	%k1, %k0, %k1
	vpternlogd	$255, %zmm4, %zmm4, %zmm4 {%k1}{z}
	vpmovdb	%zmm4, %xmm4
	vpand	%xmm0, %xmm4, %xmm0
	addl	$1, %eax
	cmpl	%r11d, %eax
	sbbb	%cl, %cl
	vmovd	%ecx, %xmm4
	vpbroadcastb	%xmm4, %xmm4
	vpand	%xmm4, %xmm2, %xmm2
	vpand	%xmm2, %xmm0, %xmm2
	vpcmpeqb	%xmm1, %xmm2, %xmm4
	vpternlogq	$15, %zmm4, %zmm4, %zmm4
	vpmovsxbd	%xmm4, %zmm4
	vptestmd	%zmm4, %zmm4, %k0
	kortestw	%k0, %k0
	jne	.LBB3_77
.LBB3_78:                               # %if_done338
	vpand	.LCPI3_3(%rip), %xmm0, %xmm0
	vpmovzxbd	%xmm0, %zmm0    # zmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero,xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[9],zero,zero,zero,xmm0[10],zero,zero,zero,xmm0[11],zero,zero,zero,xmm0[12],zero,zero,zero,xmm0[13],zero,zero,zero,xmm0[14],zero,zero,zero,xmm0[15],zero,zero,zero
	vmovdqu64	%zmm0, (%r14)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB3_59:                               # %for_loop255.lr.ph.new
	movabsq	$8589934592, %r8        # imm = 0x200000000
	movabsq	$4294967296, %r15       # imm = 0x100000000
	leaq	512(%rsp), %rdi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%edx, %edx
	movw	$-21846, %r10w          # imm = 0xAAAA
	movl	%r11d, %esi
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB3_60:                               # %for_loop255
                                        # =>This Inner Loop Header: Depth=1
	movq	%rdx, %rbx
	sarq	$25, %rbx
	vpaddq	384(%rsp,%rbx), %zmm0, %zmm0
	vpaddq	448(%rsp,%rbx), %zmm1, %zmm1
	movl	%esi, %ebx
	shlq	$7, %rbx
	vpaddq	12736(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12672(%rsp,%rbx), %zmm0, %zmm0
	kmovw	%r10d, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa64	%zmm2, -128(%rdi)
	vmovdqa32	%zmm1, %zmm2 {%k1}{z}
	vmovdqa64	%zmm2, -64(%rdi)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	leaq	(%rdx,%r15), %rbx
	sarq	$25, %rbx
	vpaddq	384(%rsp,%rbx), %zmm0, %zmm0
	vpaddq	448(%rsp,%rbx), %zmm1, %zmm1
	leal	1(%rsi), %ebx
	shlq	$7, %rbx
	vpaddq	12736(%rsp,%rbx), %zmm1, %zmm1
	vpaddq	12672(%rsp,%rbx), %zmm0, %zmm0
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 64(%rdi)
	vmovdqa64	%zmm2, (%rdi)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
	addq	$2, %rcx
	addl	$2, %esi
	addq	$256, %rdi              # imm = 0x100
	addq	%r8, %rdx
	cmpl	%ecx, %eax
	jne	.LBB3_60
# %bb.61:                               # %for_test253.for_exit256_crit_edge.unr-lcssa
	testl	%r12d, %r12d
	je	.LBB3_63
.LBB3_62:                               # %for_loop255.epil.preheader
	movslq	%ecx, %rax
	movq	%rax, %rdx
	shlq	$7, %rdx
	vpaddq	384(%rsp,%rdx), %zmm0, %zmm0
	vpaddq	448(%rsp,%rdx), %zmm1, %zmm1
	addl	%r11d, %eax
	shlq	$7, %rax
	vpaddq	12736(%rsp,%rax), %zmm1, %zmm1
	vpaddq	12672(%rsp,%rax), %zmm0, %zmm0
	shlq	$7, %rcx
	movw	$-21846, %ax            # imm = 0xAAAA
	kmovw	%eax, %k0
	knotw	%k0, %k1
	vmovdqa32	%zmm0, %zmm2 {%k1}{z}
	vmovdqa32	%zmm1, %zmm3 {%k1}{z}
	vmovdqa64	%zmm3, 448(%rsp,%rcx)
	vmovdqa64	%zmm2, 384(%rsp,%rcx)
	vpsrlq	$32, %zmm1, %zmm1
	vpsrlq	$32, %zmm0, %zmm0
.LBB3_63:                               # %for_test253.for_exit256_crit_edge
	vptestmq	%zmm0, %zmm0, %k0
	vptestmq	%zmm1, %zmm1, %k1
	kunpckbw	%k0, %k1, %k1
	kortestw	%k1, %k1
	jne	.LBB3_65
	jmp	.LBB3_70
.Lfunc_end3:
	.size	fermat_test512, .Lfunc_end3-fermat_test512
                                        # -- End function

	.ident	"clang version 8.0.0 (http://llvm.org/git/clang.git 2d5099826365b50ff253e48c0832255600e68202) (http://llvm.org/git/llvm.git 498b7f9b57123ce661e075ae584876be72852506)"
	.section	".note.GNU-stack","",@progbits
