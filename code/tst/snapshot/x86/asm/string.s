.text
.global main
# origin: user
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
main_L0:
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $4, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $102, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $111, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $111, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $4, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rsi
	movq $98, %rdi
	movb %dil, (%r12,%rsi)
	movq $9, %rsi
	movq $97, %rdi
	movb %dil, (%r12,%rsi)
	movq $10, %rsi
	movq $114, %rdi
	movb %dil, (%r12,%rsi)
	movq $11, %rsi
	movq $0, %rdi
	movb %dil, (%r12,%rsi)
	movq %rbx, %rdi
	movq %r12, %rsi
	callq _concat__string_concat
	movq %rax, %r13
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %r13, %rdi
	movq %rdx, %rsi
	callq _print__print_string
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $16, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $102, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $115, %rdi
	movb %dil, (%rdx,%rsi)
	movq $10, %rsi
	movq $116, %rdi
	movb %dil, (%rdx,%rsi)
	movq $11, %rsi
	movq $114, %rdi
	movb %dil, (%rdx,%rsi)
	movq $12, %rsi
	movq $105, %rdi
	movb %dil, (%rdx,%rsi)
	movq $13, %rsi
	movq $110, %rdi
	movb %dil, (%rdx,%rsi)
	movq $14, %rsi
	movq $103, %rdi
	movb %dil, (%rdx,%rsi)
	movq $15, %rsi
	movq $32, %rdi
	movb %dil, (%rdx,%rsi)
	movq $16, %rsi
	movq $112, %rdi
	movb %dil, (%rdx,%rsi)
	movq $17, %rsi
	movq $114, %rdi
	movb %dil, (%rdx,%rsi)
	movq $18, %rsi
	movq $105, %rdi
	movb %dil, (%rdx,%rsi)
	movq $19, %rsi
	movq $110, %rdi
	movb %dil, (%rdx,%rsi)
	movq $20, %rsi
	movq $116, %rdi
	movb %dil, (%rdx,%rsi)
	movq $21, %rsi
	movq $58, %rdi
	movb %dil, (%rdx,%rsi)
	movq $22, %rsi
	movq $32, %rdi
	movb %dil, (%rdx,%rsi)
	movq $23, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %rdx, %rdi
	movq %rbx, %rsi
	callq _concat__string_concat
	movq %rax, %rbx
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $32, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %rbx, %rdi
	movq %rdx, %rsi
	callq _concat__string_concat
	movq %rax, %rdi
	movq %r12, %rsi
	callq _concat__string_concat
	movq %rax, %rbx
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %rbx, %rdi
	movq %rdx, %rsi
	callq _print__print_string
	callq arena_free
	jmp main_epilogue
main_epilogue:
	movq $0, %rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_concat__string_concat:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_concat__string_concat_L0:
	movq %rdi, %rbx
	movq %rsi, %rdi
	movq %rdi, -8(%rbp)
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $1, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%r12,%rsi)
	movslq 0(%rbx), %rsi
	movq -8(%rbp), %rdi
	movslq 0(%rdi), %rdi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %r14
	subq %rdi, %r14
	movslq 0(%r12), %rdi
	movq %rdi, %r13
	imulq %r14, %r13
	movq $8, %rdi
	addq %r13, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r13, 0(%r15)
	movq %r15, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	callq _repeat__array_repeat__char
	movslq 0(%rbx), %rsi
	movq $1, %rdi
	movq %rsi, %rax
	subq %rdi, %rax
	movq $0, %r9
	movq -8(%rbp), %rdx
	movq %rbx, %rcx
	movq %r15, %r8
	movq $0, %rbx
	jmp _concat__string_concat_L1
_concat__string_concat_L1:
	cmpq %rax, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L2
	jmp _concat__string_concat_L3
_concat__string_concat_L2:
	movq %r9, %r10
	addq %rbx, %r10
	movq $8, %rdi
	addq %r10, %rdi
	movzbq (%rdi,%rcx), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movb %sil, (%r8,%rdi)
	movq $1, %rdi
	addq %rdi, %rbx
	jmp _concat__string_concat_L1
_concat__string_concat_L3:
	movslq 0(%rdx), %r10
	movq $0, %rax
	movq $0, %r9
	jmp _concat__string_concat_L4
_concat__string_concat_L4:
	cmpq %r10, %r9
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L5
	jmp _concat__string_concat_L6
_concat__string_concat_L5:
	movq %rax, %rsi
	addq %r9, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movzbq (%rdi,%rdx), %rbx
	movslq 0(%rcx), %rdi
	addq %rdi, %rsi
	movq $1, %rdi
	subq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movb %bl, (%r8,%rdi)
	movq $1, %rdi
	addq %rdi, %r9
	jmp _concat__string_concat_L4
_concat__string_concat_L6:
	movq %r8, %rax
	jmp _concat__string_concat_epilogue
_concat__string_concat_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $16, %rsp
	popq %rbp
	retq
# origin: runtime
_print___print_int_helper:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print___print_int_helper_L0:
	movq %rdi, %r12
	movq $10, %rdi
	movq $48, %rbx
	pushq %rax
	movq %r12, %rax
	cqto
	idivq %rdi
	movq %rax, %rsi
	popq %rax
	movq $0, %rdi
	cmpq %rdi, %rsi
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print___print_int_helper_L1
	jmp _print___print_int_helper_L2
_print___print_int_helper_L1:
	movq %rsi, %rdi
	callq _print___print_int_helper
	jmp _print___print_int_helper_L3
_print___print_int_helper_L2:
	jmp _print___print_int_helper_L3
_print___print_int_helper_L3:
	movq $10, %rdi
	pushq %rax
	pushq %rdx
	movq %rdi, %r11
	movq %r12, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rdi
	addq %rbx, %rdi
	leaq -8(%rbp), %rsi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq $1, %rdx
	callq write
	jmp _print___print_int_helper_epilogue
_print___print_int_helper_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $16, %rsp
	popq %rbp
	retq
# origin: runtime
_print__print_int:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_int_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movq $0, %rdi
	cmpq %rdi, %r12
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L1
	jmp _print__print_int_L2
_print__print_int_L1:
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $45, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq $1, %rdx
	callq write
	 movq %r12, %r12
	negq %r12
	jmp _print__print_int_L3
_print__print_int_L2:
	jmp _print__print_int_L3
_print__print_int_L3:
	movq %r12, %rdi
	callq _print___print_int_helper
	movslq 0(%rbx), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L4
	jmp _print__print_int_L5
_print__print_int_L4:
	movslq 0(%rbx), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq $8, %rdi
	movq %rbx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	jmp _print__print_int_L6
_print__print_int_L5:
	jmp _print__print_int_L6
_print__print_int_L6:
	jmp _print__print_int_epilogue
_print__print_int_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_print__print_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_bool_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $5, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $84, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $114, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $117, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $6, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $70, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $97, %rdi
	movb %dil, (%rdx,%rsi)
	movq $10, %rsi
	movq $108, %rdi
	movb %dil, (%rdx,%rsi)
	movq $11, %rsi
	movq $115, %rdi
	movb %dil, (%rdx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rdx,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	cmpq $0, %r13
	movq %rbx, %r11
	movq %rdx, %rsi
	cmovne %r11, %rsi
	cmpq $0, %r13
movq $4, %r11
movq $5, %rdx
	cmovne %r11, %rdx
	movq $8, %rdi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	movslq 0(%r12), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_bool_L1
	jmp _print__print_bool_L2
_print__print_bool_L1:
	movslq 0(%r12), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq $8, %rdi
	movq %r12, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	jmp _print__print_bool_L3
_print__print_bool_L2:
	jmp _print__print_bool_L3
_print__print_bool_L3:
	jmp _print__print_bool_epilogue
_print__print_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_print__print_string:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_string_L0:
	movq %rdi, %rcx
	movq %rsi, %rbx
	movslq 0(%rcx), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq $8, %rdi
	movq %rcx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	movslq 0(%rbx), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_string_L1
	jmp _print__print_string_L2
_print__print_string_L1:
	movslq 0(%rbx), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq $8, %rdi
	movq %rbx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	jmp _print__print_string_L3
_print__print_string_L2:
	jmp _print__print_string_L3
_print__print_string_L3:
	jmp _print__print_string_epilogue
_print__print_string_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_print__print_int_array:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_int_array_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $2, %rdi
	movq %rdi, 0(%r13)
	movq $8, %rsi
	movq $91, %rdi
	movb %dil, (%r13,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%r13,%rsi)
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $1, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %r13, %rdi
	movq %rdx, %rsi
	callq _print__print_string
	movslq 0(%r12), %rsi
	movq $0, %rdi
	movq %rdi, -16(%rbp)
	movq %rsi, %r13
	movq %rbx, -8(%rbp)
	movq $0, %rbx
	jmp _print__print_int_array_L1
_print__print_int_array_L1:
	cmpq %r13, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_array_L2
	jmp _print__print_int_array_L3
_print__print_int_array_L2:
	movq -16(%rbp), %rdi
	movq %rdi, %r15
	addq %rbx, %r15
	movq $8, %rdi
	movq %r15, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r12), %r14
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $1, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %r14, %rdi
	movq %rdx, %rsi
	callq _print__print_int
	movslq 0(%r12), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	cmpq %rdi, %r15
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_array_L4
	jmp _print__print_int_array_L5
_print__print_int_array_L3:
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $93, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %rdx, %rdi
	movq -8(%rbp), %rsi
	callq _print__print_string
	jmp _print__print_int_array_epilogue
_print__print_int_array_L4:
	movq $11, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq $3, %rdi
	movq %rdi, 0(%r14)
	movq $8, %rsi
	movq $44, %rdi
	movb %dil, (%r14,%rsi)
	movq $9, %rsi
	movq $32, %rdi
	movb %dil, (%r14,%rsi)
	movq $10, %rsi
	movq $0, %rdi
	movb %dil, (%r14,%rsi)
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $1, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %r14, %rdi
	movq %rdx, %rsi
	callq _print__print_string
	jmp _print__print_int_array_L6
_print__print_int_array_L5:
	jmp _print__print_int_array_L6
_print__print_int_array_L6:
	movq $1, %rdi
	addq %rbx, %rdi
	movq %rdi, %rbx
	jmp _print__print_int_array_L1
_print__print_int_array_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $16, %rsp
	popq %rbp
	retq
# origin: runtime
_print__print_float:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_float_L0:
	movq %xmm0, -24(%rbp)
	movq %rsi, %r12
	movabsq $0, %r11
	movq %r11, %xmm1
	movq -24(%rbp), %xmm0
	ucomisd %xmm1, %xmm0
	setb %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L1
	jmp _print__print_float_L2
_print__print_float_L1:
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $45, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq $1, %rdx
	callq write
	movq -24(%rbp), %xmm0
	 movq %xmm0, %xmm0
	movabsq $0x8000000000000000, %r11
	movq %r11, %xmm15
	 xorpd %xmm15, %xmm0
	movq %xmm0, -16(%rbp)
	jmp _print__print_float_L3
_print__print_float_L2:
	movq -24(%rbp), %xmm0
	movq %xmm0, -16(%rbp)
	jmp _print__print_float_L3
_print__print_float_L3:
	movq -16(%rbp), %xmm0
	cvttsd2siq %xmm0, %rbx
	movq %rbx, %rdi
	callq _print___print_int_helper
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $46, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq $1, %rdx
	callq write
	cvtsi2sdq %rbx, %xmm1
	movq -16(%rbp), %xmm0
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
	movq $0, %rdi
	movq $5, %r14
	movq $0, %r13
	jmp _print__print_float_L4
_print__print_float_L4:
	cmpq %r14, %r13
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L5
	jmp _print__print_float_L6
_print__print_float_L5:
	movabsq $4621819117588971520, %r11
	movq %r11, %xmm0
	mulsd %xmm1, %xmm0
	movq %xmm0, -8(%rbp)
	movq -8(%rbp), %xmm0
	cvttsd2siq %xmm0, %rbx
	movq %rbx, %rdi
	callq _print___print_int_helper
	cvtsi2sdq %rbx, %xmm1
	movq -8(%rbp), %xmm0
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
	movq $1, %rdi
	addq %rdi, %r13
	jmp _print__print_float_L4
_print__print_float_L6:
	movslq 0(%r12), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L7
	jmp _print__print_float_L8
_print__print_float_L7:
	movslq 0(%r12), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq $8, %rdi
	movq %r12, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	jmp _print__print_float_L9
_print__print_float_L8:
	jmp _print__print_float_L9
_print__print_float_L9:
	jmp _print__print_float_epilogue
_print__print_float_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $32, %rsp
	popq %rbp
	retq
# origin: runtime
_indexing__index_2d:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_indexing__index_2d_L0:
	movq %rdi, %r9
	movq %rsi, %r8
	movq %rdx, %rsi
	movq %rcx, %rdi
	imulq %r9, %rsi
	imulq %r8, %rdi
	addq %rsi, %rdi
	movq %rdi, %rax
	jmp _indexing__index_2d_epilogue
_indexing__index_2d_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_module__Module____init__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_module__Module____init___L0:
	jmp _module__Module____init___epilogue
_module__Module____init___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__int_:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__int__L0:
	movq $11, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $3, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $52, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $50, %rdi
	movb %dil, (%rdx,%rsi)
	movq $10, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %rdx, %rax
	jmp _str__int__epilogue
_str__int__epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__bool_:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__bool__L0:
	movq %rdi, %r12
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $5, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $84, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $114, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $117, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $6, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $70, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rsi
	movq $97, %rdi
	movb %dil, (%rdx,%rsi)
	movq $10, %rsi
	movq $108, %rdi
	movb %dil, (%rdx,%rsi)
	movq $11, %rsi
	movq $115, %rdi
	movb %dil, (%rdx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rdx,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	cmpq $0, %r12
	movq %rbx, %r11
	movq %rdx, %rdi
	cmovne %r11, %rdi
	movq %rdi, %rax
	jmp _str__bool__epilogue
_str__bool__epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_repeat__array_repeat__char:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_repeat__array_repeat__char_L0:
	movq %rdi, %r9
	movq %rsi, %rax
	movq %rdx, %rdi
	movslq 0(%rax), %r10
	movq %r10, %r8
	imulq %rdi, %r8
	movq $0, %rcx
	movq $0, %rdx
	jmp _repeat__array_repeat__char_L1
_repeat__array_repeat__char_L1:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _repeat__array_repeat__char_L2
	jmp _repeat__array_repeat__char_L3
_repeat__array_repeat__char_L2:
	movq %rcx, %rbx
	addq %rdx, %rbx
	pushq %rax
	pushq %rdx
	movq %r10, %r11
	movq %rbx, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movzbq (%rdi,%rax), %rsi
	movq $8, %rdi
	addq %rbx, %rdi
	movb %sil, (%r9,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _repeat__array_repeat__char_L1
_repeat__array_repeat__char_L3:
	jmp _repeat__array_repeat__char_epilogue
_repeat__array_repeat__char_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq

.text
fmt:
	.asciz "%ld\n"
