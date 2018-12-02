#!/usr/bin/sed -f
/^PROLOGUE(rie_mod_1s_2p_4times)/s/.*/\
	.globl rie_mod_1s_2p_4times\
rie_mod_1s_2p_4times:\
	push	%rdi\
	push	%rsi\
	mov	%rcx, %rdi\
	mov	%rdx, %rsi\
	mov	%r8, %rdx\
	mov	%r9, %rcx\
	mov	56\(%rsp\), %r8\
	mov	64\(%rsp\), %r9/
/^\tret/s/.*/\
	pop	%rsi\
	pop	%rdi\
	ret/
