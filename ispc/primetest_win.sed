#!/usr/bin/sed -f
/^\t\.type/s/.*//
/^\t\.size/s/.*//
/^\t\.section\t\"/s/.*//
/^\t\.section\t.rodata/s/.*/\t\.section\t\.rodata/
/^fermat_test\(512\)\?:/s/\(.*\)/\1\
	push	%rdi\
	push	%rsi\
	mov	%rcx, %rdi\
	mov	%rdx, %rsi\
	mov	%r8, %rdx\
	mov	%r9, %rcx\
        mov     56\(%rsp\), %r8\
        mov     64\(%rsp\), %r9/
/^[a-zA-Z_0-9]*: # @/s/\(.*\)/\1\
	push	%rdi\
	push	%rsi/
/^\tretq/s/.*/\
	pop	%rsi\
	pop	%rdi\
	retq/
