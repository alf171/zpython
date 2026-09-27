.text
.global main
# origin: user
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $64, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
main_L0:
	movq $1, %rdi
	 movq %rdi, %rcx
	negq %rcx
	movq $3, %rdi
	movq $3, %rdx
	leaq -16(%rbp), %rsi
	movq %rdi, 0(%rsi)
	movq %rdx, 8(%rsi)
	movq %rsi, %rdi
	movq %rcx, %rsi
	callq _tensor__Tensor__fill__i32
	movq %rax, %rdi
	callq _tensor__Tensor__relu__i32
	movq %rax, %rdi
	movq $0, %rsi
	movq $0, %rdx
	leaq -32(%rbp), %rcx
	movq %rsi, 0(%rcx)
	movq %rdx, 8(%rcx)
	movq %rcx, %rsi
	callq _tensor__Tensor____getitem____i32
	movq %rax, %rdi
	movslq %edi, %rbx
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq $2, %rdi
	movq %rdi, 0(%rsi)
	movq $8, %rdi
	movq $10, %rdx
	movb %dl, (%rsi,%rdi)
	movq $9, %rdi
	movq $0, %rdx
	movb %dl, (%rsi,%rdi)
	movq %rbx, %rdi
	callq _print__print_int
	movq $3, %rdx
	movq $3, %rdi
	leaq -48(%rbp), %rsi
	movq %rdx, 0(%rsi)
	movq %rdi, 8(%rsi)
	movq %rsi, %rdi
	movq $1, %rsi
	callq _tensor__Tensor__fill__i32
	movq %rax, %rdi
	callq _tensor__Tensor__relu__i32
	movq %rax, %rcx
	movq $0, %rdi
	movq $0, %rdx
	leaq -64(%rbp), %rsi
	movq %rdi, 0(%rsi)
	movq %rdx, 8(%rsi)
	movq %rcx, %rdi
	callq _tensor__Tensor____getitem____i32
	movq %rax, %rdi
	movslq %edi, %rbx
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rdi
	movq $0, %rsi
	movb %sil, (%rdx,%rdi)
	movq %rbx, %rdi
	movq %rdx, %rsi
	callq _print__print_int
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
	addq $64, %rsp
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
	movq %rdi, %r12
	movq %rsi, %rdi
	movq %rdi, -8(%rbp)
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rdi
	movq $0, %rsi
	movb %sil, (%rbx,%rdi)
	movq (%r12), %rdi
	movq -8(%rbp), %rsi
	movq (%rsi), %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %r15
	subq %rdi, %r15
	movq (%rbx), %rdi
	movq %rdi, %r14
	imulq %r15, %r14
	movq $8, %rdi
	addq %r14, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r14, 0(%r13)
	movq %r13, %rdi
	movq %rbx, %rsi
	movq %r15, %rdx
	callq _repeat__list_repeat__char
	movq (%r12), %rsi
	movq $1, %rdi
	movq %rsi, %r10
	subq %rdi, %r10
	movq $0, %rax
	movq -8(%rbp), %r9
	movq %r12, %rdx
	movq %r13, %rcx
	movq $0, %rsi
	jmp _concat__string_concat_L1
_concat__string_concat_L1:
	cmpq %r10, %rsi
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L2
	jmp _concat__string_concat_L3
_concat__string_concat_L2:
	movq %rax, %rbx
	addq %rsi, %rbx
	movq $8, %rdi
	addq %rbx, %rdi
	movzbq (%rdi,%rdx), %r8
	movq $8, %rdi
	addq %rbx, %rdi
	movb %r8b, (%rcx,%rdi)
	movq $1, %rdi
	addq %rdi, %rsi
	jmp _concat__string_concat_L1
_concat__string_concat_L3:
	movq (%r9), %rbx
	movq $0, %rdi
	movq $0, %r10
	jmp _concat__string_concat_L4
_concat__string_concat_L4:
	cmpq %rbx, %r10
	setl %r11b
	movzbq %r11b, %rsi
	cmpq $0, %rsi
	jne _concat__string_concat_L5
	jmp _concat__string_concat_L6
_concat__string_concat_L5:
	movq %rdi, %r8
	addq %r10, %r8
	movq $8, %rsi
	addq %r8, %rsi
	movzbq (%rsi,%r9), %rax
	movq (%rdx), %rsi
	addq %r8, %rsi
	movq $1, %r8
	subq %r8, %rsi
	movq $8, %r8
	addq %r8, %rsi
	movb %al, (%rcx,%rsi)
	movq $1, %rsi
	addq %rsi, %r10
	jmp _concat__string_concat_L4
_concat__string_concat_L6:
	movq %rcx, %rax
	jmp _concat__string_concat_epilogue
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
	movq $8, %rdi
	movq $45, %rsi
	movb %sil, (%rdx,%rdi)
	movq $9, %rdi
	movq $0, %rsi
	movb %sil, (%rdx,%rdi)
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
	movq (%rbx), %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L4
	jmp _print__print_int_L5
_print__print_int_L4:
	movq (%rbx), %rdi
	movq $1, %rsi
	movq %rdi, %rdx
	subq %rsi, %rdx
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
	movq %rdi, %rbx
	movq %rsi, %r13
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $5, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rdi
	movq $84, %rsi
	movb %sil, (%r12,%rdi)
	movq $9, %rdi
	movq $114, %rsi
	movb %sil, (%r12,%rdi)
	movq $10, %rdi
	movq $117, %rsi
	movb %sil, (%r12,%rdi)
	movq $11, %rsi
	movq $101, %rdi
	movb %dil, (%r12,%rsi)
	movq $12, %rdi
	movq $0, %rsi
	movb %sil, (%r12,%rdi)
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
	movq $10, %rdi
	movq $108, %rsi
	movb %sil, (%rdx,%rdi)
	movq $11, %rsi
	movq $115, %rdi
	movb %dil, (%rdx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rdx,%rsi)
	movq $13, %rdi
	movq $0, %rsi
	movb %sil, (%rdx,%rdi)
	cmpq $0, %rbx
	movq %r12, %r11
	movq %rdx, %rdi
	cmovne %r11, %rdi
	cmpq $0, %rbx
movq $4, %r11
movq $5, %rdx
	cmovne %r11, %rdx
	movq $8, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	movq (%r13), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_bool_L1
	jmp _print__print_bool_L2
_print__print_bool_L1:
	movq (%r13), %rdi
	movq $1, %rsi
	movq %rdi, %rdx
	subq %rsi, %rdx
	movq $8, %rdi
	movq %r13, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	jmp _print__print_bool_L3
_print__print_bool_L2:
	jmp _print__print_bool_L3
_print__print_bool_L3:
	jmp _print__print_bool_epilogue
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
	movq %rdi, %rdx
	movq %rsi, %rbx
	movq (%rdx), %rdi
	movq $1, %rsi
	movq %rdi, %rcx
	subq %rsi, %rcx
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rcx, %rdx
	callq write
	movq (%rbx), %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_string_L1
	jmp _print__print_string_L2
_print__print_string_L1:
	movq (%rbx), %rdi
	movq $1, %rsi
	movq %rdi, %rdx
	subq %rsi, %rdx
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
_print__print_int_list:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_int_list_L0:
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
	movq $8, %rdi
	movq $0, %rsi
	movb %sil, (%rdx,%rdi)
	movq %r13, %rdi
	movq %rdx, %rsi
	callq _print__print_string
	movq (%r12), %rdi
	movq $0, %rsi
	movq %rsi, -16(%rbp)
	movq %rdi, %r13
	movq %rbx, -8(%rbp)
	movq $0, %r14
	jmp _print__print_int_list_L1
_print__print_int_list_L1:
	cmpq %r13, %r14
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_list_L2
	jmp _print__print_int_list_L3
_print__print_int_list_L2:
	movq -16(%rbp), %rdi
	movq %rdi, %rbx
	addq %r14, %rbx
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r12), %r15
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq $1, %rdi
	movq %rdi, 0(%rsi)
	movq $8, %rdi
	movq $0, %rdx
	movb %dl, (%rsi,%rdi)
	movq %r15, %rdi
	callq _print__print_int
	movq (%r12), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	cmpq %rdi, %rbx
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_list_L4
	jmp _print__print_int_list_L5
_print__print_int_list_L3:
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq $2, %rsi
	movq %rsi, 0(%rdi)
	movq $8, %rsi
	movq $93, %rdx
	movb %dl, (%rdi,%rsi)
	movq $9, %rsi
	movq $0, %rdx
	movb %dl, (%rdi,%rsi)
	movq -8(%rbp), %rsi
	callq _print__print_string
	jmp _print__print_int_list_epilogue
	jmp _print__print_int_list_epilogue
_print__print_int_list_L4:
	movq $11, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $3, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rdi
	movq $44, %rsi
	movb %sil, (%rbx,%rdi)
	movq $9, %rdi
	movq $32, %rsi
	movb %sil, (%rbx,%rdi)
	movq $10, %rdi
	movq $0, %rsi
	movb %sil, (%rbx,%rdi)
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $1, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%rdx,%rsi)
	movq %rbx, %rdi
	movq %rdx, %rsi
	callq _print__print_string
	jmp _print__print_int_list_L6
_print__print_int_list_L5:
	jmp _print__print_int_list_L6
_print__print_int_list_L6:
	movq $1, %rdi
	addq %r14, %rdi
	movq %rdi, %r14
	jmp _print__print_int_list_L1
_print__print_int_list_epilogue:
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
	movq %rsi, %rbx
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
	movq $8, %rdi
	movq $45, %rsi
	movb %sil, (%rdx,%rdi)
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
	cvttsd2siq %xmm0, %r12
	movq %r12, %rdi
	callq _print___print_int_helper
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rdx
	movq $2, %rdi
	movq %rdi, 0(%rdx)
	movq $8, %rsi
	movq $46, %rdi
	movb %dil, (%rdx,%rsi)
	movq $9, %rdi
	movq $0, %rsi
	movb %sil, (%rdx,%rdi)
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq $1, %rdx
	callq write
	cvtsi2sdq %r12, %xmm1
	movq -16(%rbp), %xmm0
	subsd %xmm1, %xmm0
	movq $0, %rdi
	movq $5, %r12
	movq $0, %r13
	jmp _print__print_float_L4
_print__print_float_L4:
	cmpq %r12, %r13
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L5
	jmp _print__print_float_L6
_print__print_float_L5:
	movabsq $4621819117588971520, %r11
	movq %r11, %xmm1
	mulsd %xmm1, %xmm0
	movq %xmm0, -8(%rbp)
	movq -8(%rbp), %xmm0
	cvttsd2siq %xmm0, %r14
	movq %r14, %rdi
	callq _print___print_int_helper
	cvtsi2sdq %r14, %xmm0
	movq -8(%rbp), %xmm1
	movsd %xmm0, %xmm15
	movsd %xmm1, %xmm0
	subsd %xmm15, %xmm0
	movq $1, %rdi
	addq %rdi, %r13
	jmp _print__print_float_L4
_print__print_float_L6:
	movq (%rbx), %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L7
	jmp _print__print_float_L8
_print__print_float_L7:
	movq (%rbx), %rdi
	movq $1, %rsi
	movq %rdi, %rdx
	subq %rsi, %rdx
	movq $8, %rdi
	movq %rbx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	callq write
	jmp _print__print_float_L9
_print__print_float_L8:
	jmp _print__print_float_L9
_print__print_float_L9:
	jmp _print__print_float_epilogue
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
	movq %rsi, %r8
	movq %rdx, %rsi
	movq %rcx, %rdx
	imulq %rsi, %rdi
	movq %r8, %rsi
	imulq %rdx, %rsi
	addq %rsi, %rdi
	movq %rdi, %rax
	jmp _indexing__index_2d_epilogue
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
_backward__add:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_backward__add_L0:
	movq %rdi, %r13
	movq %rsi, %rbx
	movq %rdx, %r12
	movq 8(%rbx), %rdi
	movq 8(%r13), %rsi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%rbx)
	movq 8(%r12), %rdi
	movq 8(%r13), %rsi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%r12)
	jmp _backward__add_epilogue
	jmp _backward__add_epilogue
_backward__add_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_backward__sub:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_backward__sub_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movq %rdx, %rbx
	movq 8(%r12), %rdi
	movq 8(%r13), %rsi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%r12)
	movq 8(%rbx), %rdi
	movq 8(%r13), %rsi
	callq _data__TensorData____sub____f32
	movq %rax, %rdi
	movq %rdi, 8(%rbx)
	jmp _backward__sub_epilogue
	jmp _backward__sub_epilogue
_backward__sub_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_backward__mul:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_backward__mul_L0:
	movq %rdi, %rbx
	movq %rsi, %r14
	movq %rdx, %r12
	movq 8(%r14), %r13
	movq 0(%r12), %rdi
	movq 8(%rbx), %rsi
	callq _data__TensorData____mul____f32
	movq %rax, %rsi
	movq %r13, %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%r14)
	movq 8(%r12), %r13
	movq 0(%r14), %rdi
	movq 8(%rbx), %rsi
	callq _data__TensorData____mul____f32
	movq %rax, %rsi
	movq %r13, %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%r12)
	jmp _backward__mul_epilogue
	jmp _backward__mul_epilogue
_backward__mul_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_backward__matmul:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_backward__matmul_L0:
	movq %rdi, %r14
	movq %rsi, %rbx
	movq %rdx, %r12
	movq 8(%rbx), %r13
	movq 0(%r12), %rdi
	movq 8(%r14), %rsi
	callq _data__TensorData____mul____f32
	movq %rax, %rsi
	movq %r13, %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%rbx)
	movq 8(%r12), %r13
	movq 0(%rbx), %rdi
	movq 8(%r14), %rsi
	callq _data__TensorData____mul____f32
	movq %rax, %rsi
	movq %r13, %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%r12)
	jmp _backward__matmul_epilogue
	jmp _backward__matmul_epilogue
_backward__matmul_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_backward__broadcast_to:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_backward__broadcast_to_L0:
	movq %rdi, %rbx
	movq %rsi, %r12
	movq 8(%rbx), %rsi
	movq 0(%r12), %rdi
	movslq 8(%rdi), %rdx
	movq $1, %rdi
	cmpq %rdi, %rdx
	sete %r11b
	movzbq %r11b, %rdx
	movq 0(%rbx), %rdi
	movslq 8(%rdi), %rcx
	movq $1, %rdi
	cmpq %rdi, %rcx
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdx
	movq %rdi, %r11
movq $0, %rdi
	cmovne %r11, %rdi
	cmpq $0, %rdi
	jne _backward__broadcast_to_L1
	jmp _backward__broadcast_to_L2
_backward__broadcast_to_L1:
	movq 8(%rbx), %rdi
	movq $0, %rsi
	callq _data__TensorData__sum__f32
	movq %rax, %rsi
	jmp _backward__broadcast_to_L3
_backward__broadcast_to_L2:
	jmp _backward__broadcast_to_L3
_backward__broadcast_to_L3:
	movq 0(%r12), %rdi
	movslq 12(%rdi), %rdx
	movq $1, %rdi
	cmpq %rdi, %rdx
	sete %r11b
	movzbq %r11b, %rdi
	movq 0(%rbx), %rdx
	movslq 12(%rdx), %rcx
	movq $1, %rdx
	cmpq %rdx, %rcx
	setne %r11b
	movzbq %r11b, %rdx
	cmpq $0, %rdi
	movq %rdx, %r11
movq $0, %rdi
	cmovne %r11, %rdi
	cmpq $0, %rdi
	jne _backward__broadcast_to_L4
	jmp _backward__broadcast_to_L5
_backward__broadcast_to_L4:
	movq 8(%rbx), %rdi
	movq $1, %rsi
	callq _data__TensorData__sum__f32
	movq %rax, %rsi
	jmp _backward__broadcast_to_L6
_backward__broadcast_to_L5:
	jmp _backward__broadcast_to_L6
_backward__broadcast_to_L6:
	movq 8(%r12), %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%r12)
	jmp _backward__broadcast_to_epilogue
	jmp _backward__broadcast_to_epilogue
_backward__broadcast_to_epilogue:
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
_tensor____lambda_82:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_82_L0:
	jmp _tensor____lambda_82_epilogue
	jmp _tensor____lambda_82_epilogue
_tensor____lambda_82_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor____lambda_83:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_83_L0:
	movq %rdi, %rsi
	movq 8(%rsi), %rdi
	movq 16(%rsi), %rsi
	callq _backward__broadcast_to
	jmp _tensor____lambda_83_epilogue
	jmp _tensor____lambda_83_epilogue
_tensor____lambda_83_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor____lambda_84:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_84_L0:
	movq %rdi, %rdx
	movq 8(%rdx), %rdi
	movq 16(%rdx), %rsi
	movq 24(%rdx), %rdx
	callq _backward__add
	jmp _tensor____lambda_84_epilogue
	jmp _tensor____lambda_84_epilogue
_tensor____lambda_84_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor____lambda_85:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_85_L0:
	movq 8(%rdi), %rcx
	movq 16(%rdi), %rsi
	movq 24(%rdi), %rdx
	movq %rcx, %rdi
	callq _backward__sub
	jmp _tensor____lambda_85_epilogue
	jmp _tensor____lambda_85_epilogue
_tensor____lambda_85_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor____lambda_86:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_86_L0:
	movq %rdi, %rdx
	movq 8(%rdx), %rdi
	movq 16(%rdx), %rsi
	movq 24(%rdx), %rdx
	callq _backward__mul
	jmp _tensor____lambda_86_epilogue
	jmp _tensor____lambda_86_epilogue
_tensor____lambda_86_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor__fill__i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor__fill__i32_L0:
	callq _data__TensorData__fill__i32
	movq %rax, %rdi
	callq _tensor__Tensor___init__i32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor__fill__i32_epilogue
	jmp _tensor__Tensor__fill__i32_epilogue
_tensor__Tensor__fill__i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor__relu__i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor__relu__i32_L0:
	movq 0(%rdi), %rdi
	callq _data__TensorData__relu__i32
	movq %rax, %rdi
	callq _tensor__Tensor___init__i32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor__relu__i32_epilogue
	jmp _tensor__Tensor__relu__i32_epilogue
_tensor__Tensor__relu__i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor____getitem____i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____getitem____i32_L0:
	movq 0(%rdi), %rdi
	callq _data__TensorData____getitem____i32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____getitem____i32_epilogue
	jmp _tensor__Tensor____getitem____i32_epilogue
_tensor__Tensor____getitem____i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____add____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____add____f32_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rdi
	leaq -16(%rbp), %rsi
	movl %edx, 0(%rsi)
	movl %edi, 8(%rsi)
	movq %rsi, %rdi
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %r13
	movslq 8(%r12), %rsi
	movslq 12(%r12), %rcx
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %esi, 0(%rdx)
	movl %ecx, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rdi
	movq $0, %rsi
	movq %rsi, 0(%rdi)
	movq $4, %rsi
	movq %rsi, 8(%rdi)
	leaq -80(%rbp), %rcx
	movq $24, %rsi
	movq %rsi, 0(%rcx)
	movq $1, %rsi
	movq %rsi, 8(%rcx)
	movq %rdi, 16(%rcx)
	leaq -96(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -120(%rbp), %r8
	movq $24, %rdi
	movq %rdi, 0(%r8)
	movq $1, %rdi
	movq %rdi, 8(%r8)
	movq %rsi, 16(%r8)
	leaq -136(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -160(%rbp), %r9
	movq $24, %rdi
	movq %rdi, 0(%r9)
	movq $1, %rdi
	movq %rdi, 8(%r9)
	movq %rsi, 16(%r9)
	leaq -232(%rbp), %rsi
	movq %r13, 0(%rsi)
	movq $24, %rdi
	movq %rdi, 8(%rsi)
	movq %rcx, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %r8, 40(%rsi)
	movq %rbx, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -384(%rbp), %rcx
	movq $95, %rdi
	movb %dil, 0(%rcx)
	movq $107, %rdi
	movb %dil, 8(%rcx)
	movq $101, %rdi
	movb %dil, 16(%rcx)
	movq $114, %rdi
	movb %dil, 24(%rcx)
	movq $110, %rdi
	movb %dil, 32(%rcx)
	movq $101, %rdi
	movb %dil, 40(%rcx)
	movq $108, %rdi
	movb %dil, 48(%rcx)
	movq $115, %rdi
	movb %dil, 56(%rcx)
	movq $95, %rdi
	movb %dil, 64(%rcx)
	movq $95, %rdi
	movb %dil, 72(%rcx)
	movq $97, %rdi
	movb %dil, 80(%rcx)
	movq $100, %rdi
	movb %dil, 88(%rcx)
	movq $100, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $95, %rdi
	movb %dil, 112(%rcx)
	movq $102, %rdi
	movb %dil, 120(%rcx)
	movq $51, %rdi
	movb %dil, 128(%rcx)
	movq $50, %rdi
	movb %dil, 136(%rcx)
	movq $0, %rdi
	movb %dil, 144(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %r13, %rax
	jmp _data__TensorData____add____f32_epilogue
	jmp _data__TensorData____add____f32_epilogue
_data__TensorData____add____f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $384, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____sub____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____sub____f32_L0:
	movq %rdi, %r12
	movq %rsi, %r13
	movslq 8(%r12), %rsi
	movslq 12(%r12), %rdi
	leaq -16(%rbp), %rdx
	movl %esi, 0(%rdx)
	movl %edi, 8(%rdx)
	movq %rdx, %rdi
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r12), %rdi
	movslq 12(%r12), %rsi
	movq $1, %rcx
	leaq -40(%rbp), %rdx
	movl %edi, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rcx, 16(%rdx)
	leaq -56(%rbp), %rdi
	movq $0, %rsi
	movq %rsi, 0(%rdi)
	movq $4, %rsi
	movq %rsi, 8(%rdi)
	leaq -80(%rbp), %rcx
	movq $24, %rsi
	movq %rsi, 0(%rcx)
	movq $1, %rsi
	movq %rsi, 8(%rcx)
	movq %rdi, 16(%rcx)
	leaq -96(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -120(%rbp), %r9
	movq $24, %rdi
	movq %rdi, 0(%r9)
	movq $1, %rdi
	movq %rdi, 8(%r9)
	movq %rsi, 16(%r9)
	leaq -136(%rbp), %rdi
	movq $0, %rsi
	movq %rsi, 0(%rdi)
	movq $4, %rsi
	movq %rsi, 8(%rdi)
	leaq -160(%rbp), %rsi
	movq $24, %r8
	movq %r8, 0(%rsi)
	movq $1, %r8
	movq %r8, 8(%rsi)
	movq %rdi, 16(%rsi)
	leaq -232(%rbp), %r8
	movq %rbx, 0(%r8)
	movq $24, %rdi
	movq %rdi, 8(%r8)
	movq %rcx, 16(%r8)
	movq %r12, 24(%r8)
	movq $24, %rdi
	movq %rdi, 32(%r8)
	movq %r9, 40(%r8)
	movq %r13, 48(%r8)
	movq $24, %rdi
	movq %rdi, 56(%r8)
	movq %rsi, 64(%r8)
	leaq -384(%rbp), %rcx
	movq $95, %rdi
	movb %dil, 0(%rcx)
	movq $107, %rdi
	movb %dil, 8(%rcx)
	movq $101, %rdi
	movb %dil, 16(%rcx)
	movq $114, %rdi
	movb %dil, 24(%rcx)
	movq $110, %rdi
	movb %dil, 32(%rcx)
	movq $101, %rdi
	movb %dil, 40(%rcx)
	movq $108, %rdi
	movb %dil, 48(%rcx)
	movq $115, %rdi
	movb %dil, 56(%rcx)
	movq $95, %rdi
	movb %dil, 64(%rcx)
	movq $95, %rdi
	movb %dil, 72(%rcx)
	movq $115, %rdi
	movb %dil, 80(%rcx)
	movq $117, %rdi
	movb %dil, 88(%rcx)
	movq $98, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $95, %rdi
	movb %dil, 112(%rcx)
	movq $102, %rdi
	movb %dil, 120(%rcx)
	movq $51, %rdi
	movb %dil, 128(%rcx)
	movq $50, %rdi
	movb %dil, 136(%rcx)
	movq $0, %rdi
	movb %dil, 144(%rcx)
	movq %r8, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____sub____f32_epilogue
	jmp _data__TensorData____sub____f32_epilogue
_data__TensorData____sub____f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $384, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____mul____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____mul____f32_L0:
	movq %rdi, %r12
	movq %rsi, %r13
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r12), %rdi
	movslq 12(%r12), %rcx
	movq $1, %rsi
	leaq -40(%rbp), %rdx
	movl %edi, 0(%rdx)
	movl %ecx, 8(%rdx)
	movq %rsi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %r9
	movq $24, %rdi
	movq %rdi, 0(%r9)
	movq $1, %rdi
	movq %rdi, 8(%r9)
	movq %rsi, 16(%r9)
	leaq -96(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -120(%rbp), %rdi
	movq $24, %rcx
	movq %rcx, 0(%rdi)
	movq $1, %rcx
	movq %rcx, 8(%rdi)
	movq %rsi, 16(%rdi)
	leaq -136(%rbp), %rcx
	movq $0, %rsi
	movq %rsi, 0(%rcx)
	movq $4, %rsi
	movq %rsi, 8(%rcx)
	leaq -160(%rbp), %r8
	movq $24, %rsi
	movq %rsi, 0(%r8)
	movq $1, %rsi
	movq %rsi, 8(%r8)
	movq %rcx, 16(%r8)
	leaq -232(%rbp), %rcx
	movq %rbx, 0(%rcx)
	movq $24, %rsi
	movq %rsi, 8(%rcx)
	movq %r9, 16(%rcx)
	movq %r12, 24(%rcx)
	movq $24, %rsi
	movq %rsi, 32(%rcx)
	movq %rdi, 40(%rcx)
	movq %r13, 48(%rcx)
	movq $24, %rdi
	movq %rdi, 56(%rcx)
	movq %r8, 64(%rcx)
	leaq -384(%rbp), %r8
	movq $95, %rdi
	movb %dil, 0(%r8)
	movq $107, %rdi
	movb %dil, 8(%r8)
	movq $101, %rdi
	movb %dil, 16(%r8)
	movq $114, %rdi
	movb %dil, 24(%r8)
	movq $110, %rdi
	movb %dil, 32(%r8)
	movq $101, %rdi
	movb %dil, 40(%r8)
	movq $108, %rdi
	movb %dil, 48(%r8)
	movq $115, %rdi
	movb %dil, 56(%r8)
	movq $95, %rdi
	movb %dil, 64(%r8)
	movq $95, %rdi
	movb %dil, 72(%r8)
	movq $109, %rdi
	movb %dil, 80(%r8)
	movq $117, %rdi
	movb %dil, 88(%r8)
	movq $108, %rdi
	movb %dil, 96(%r8)
	movq $95, %rdi
	movb %dil, 104(%r8)
	movq $95, %rdi
	movb %dil, 112(%r8)
	movq $102, %rdi
	movb %dil, 120(%r8)
	movq $51, %rdi
	movb %dil, 128(%r8)
	movq $50, %rdi
	movb %dil, 136(%r8)
	movq $0, %rdi
	movb %dil, 144(%r8)
	movq %rcx, %rdi
	movq $3, %rsi
	movq %r8, %rcx
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____mul____f32_epilogue
	jmp _data__TensorData____mul____f32_epilogue
_data__TensorData____mul____f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $384, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__sum__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $640, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__sum__f32_L0:
	movq %rdi, %r12
	movl $0, %r11d
	movd %r11d, %xmm0
	movq $0, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__sum__f32_L1
	jmp _data__TensorData__sum__f32_L2
_data__TensorData__sum__f32_L1:
	movq $1, %rdi
	movslq 12(%r12), %rdx
	leaq -16(%rbp), %rsi
	movq %rdi, 0(%rsi)
	movl %edx, 8(%rsi)
	movq %rsi, %rdi
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 12(%r12), %rcx
	movq $1, %rdi
	movq $1, %rsi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rdi, 8(%rdx)
	movq %rsi, 16(%rdx)
	movq $4, %rsi
	movq (%r9), %rdi
	imulq %rsi, %rdi
	movq $8, %rsi
	movq %rdi, %rcx
	addq %rsi, %rcx
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %r8
	movq $24, %rdi
	movq %rdi, 0(%r8)
	movq $1, %rdi
	movq %rdi, 8(%r8)
	movq %rsi, 16(%r8)
	leaq -128(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %rcx, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %r8, 40(%rsi)
	leaq -320(%rbp), %rcx
	movq $95, %rdi
	movb %dil, 0(%rcx)
	movq $107, %rdi
	movb %dil, 8(%rcx)
	movq $101, %rdi
	movb %dil, 16(%rcx)
	movq $114, %rdi
	movb %dil, 24(%rcx)
	movq $110, %rdi
	movb %dil, 32(%rcx)
	movq $101, %rdi
	movb %dil, 40(%rcx)
	movq $108, %rdi
	movb %dil, 48(%rcx)
	movq $115, %rdi
	movb %dil, 56(%rcx)
	movq $95, %rdi
	movb %dil, 64(%rcx)
	movq $95, %rdi
	movb %dil, 72(%rcx)
	movq $115, %rdi
	movb %dil, 80(%rcx)
	movq $117, %rdi
	movb %dil, 88(%rcx)
	movq $109, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $99, %rdi
	movb %dil, 112(%rcx)
	movq $111, %rdi
	movb %dil, 120(%rcx)
	movq $108, %rdi
	movb %dil, 128(%rcx)
	movq $115, %rdi
	movb %dil, 136(%rcx)
	movq $95, %rdi
	movb %dil, 144(%rcx)
	movq $95, %rdi
	movb %dil, 152(%rcx)
	movq $102, %rdi
	movb %dil, 160(%rcx)
	movq $51, %rdi
	movb %dil, 168(%rcx)
	movq $50, %rdi
	movb %dil, 176(%rcx)
	movq $0, %rdi
	movb %dil, 184(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rdi
	jmp _data__TensorData__sum__f32_L3
_data__TensorData__sum__f32_L2:
	movslq 8(%r12), %rdx
	movq $1, %rdi
	leaq -336(%rbp), %rsi
	movl %edx, 0(%rsi)
	movq %rdi, 8(%rsi)
	movq %rsi, %rdi
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %rcx
	movslq 8(%r12), %r8
	movq $1, %rdi
	movq $1, %rsi
	leaq -360(%rbp), %rdx
	movl %r8d, 0(%rdx)
	movq %rdi, 8(%rdx)
	movq %rsi, 16(%rdx)
	movq $4, %rdi
	movq (%rcx), %rsi
	imulq %rsi, %rdi
	movq $8, %rsi
	movq %rdi, %r8
	addq %rsi, %r8
	leaq -376(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -400(%rbp), %r9
	movq $24, %rdi
	movq %rdi, 0(%r9)
	movq $1, %rdi
	movq %rdi, 8(%r9)
	movq %rsi, 16(%r9)
	leaq -448(%rbp), %rsi
	movq %rcx, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %r9, 40(%rsi)
	leaq -640(%rbp), %rcx
	movq $95, %rdi
	movb %dil, 0(%rcx)
	movq $107, %rdi
	movb %dil, 8(%rcx)
	movq $101, %rdi
	movb %dil, 16(%rcx)
	movq $114, %rdi
	movb %dil, 24(%rcx)
	movq $110, %rdi
	movb %dil, 32(%rcx)
	movq $101, %rdi
	movb %dil, 40(%rcx)
	movq $108, %rdi
	movb %dil, 48(%rcx)
	movq $115, %rdi
	movb %dil, 56(%rcx)
	movq $95, %rdi
	movb %dil, 64(%rcx)
	movq $95, %rdi
	movb %dil, 72(%rcx)
	movq $115, %rdi
	movb %dil, 80(%rcx)
	movq $117, %rdi
	movb %dil, 88(%rcx)
	movq $109, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $114, %rdi
	movb %dil, 112(%rcx)
	movq $111, %rdi
	movb %dil, 120(%rcx)
	movq $119, %rdi
	movb %dil, 128(%rcx)
	movq $115, %rdi
	movb %dil, 136(%rcx)
	movq $95, %rdi
	movb %dil, 144(%rcx)
	movq $95, %rdi
	movb %dil, 152(%rcx)
	movq $102, %rdi
	movb %dil, 160(%rcx)
	movq $51, %rdi
	movb %dil, 168(%rcx)
	movq $50, %rdi
	movb %dil, 176(%rcx)
	movq $0, %rdi
	movb %dil, 184(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rdi
	jmp _data__TensorData__sum__f32_L3
_data__TensorData__sum__f32_L3:
	movq %rdi, %rax
	jmp _data__TensorData__sum__f32_epilogue
	jmp _data__TensorData__sum__f32_epilogue
_data__TensorData__sum__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $640, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__fill__i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__fill__i32_L0:
	movq %rdi, %rbx
	movq %rsi, %r13
	movq $0, %rdi
	movslq (%rdi,%rbx), %rsi
	movq $8, %rdi
	movslq (%rdi,%rbx), %rdi
	movq %rsi, %r14
	imulq %rdi, %r14
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $1, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rdi
	movl %r13d, (%r12,%rdi)
	movq (%r12), %rdi
	movq %rdi, %r13
	imulq %r14, %r13
	movq $4, %rdi
	movq %r13, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r13, 0(%r15)
	movq %r15, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	callq _repeat__list_repeat__i32
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r15, %rsi
	movq %rbx, %rdx
	callq _data__TensorData____init____i32
	movq %r12, %rax
	jmp _data__TensorData__fill__i32_epilogue
	jmp _data__TensorData__fill__i32_epilogue
_data__TensorData__fill__i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor___init__i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor___init__i32_L0:
	movq %rdi, %rbx
	movq 0(%rbx), %r12
	movslq 8(%rbx), %rdi
	movslq 12(%rbx), %rsi
	leaq -16(%rbp), %r14
	movl %edi, 0(%r14)
	movl %esi, 8(%r14)
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	callq _tensor__Tensor____init____i32
	movq %rbx, 0(%r13)
	movq %r13, %rax
	jmp _tensor__Tensor___init__i32_epilogue
	jmp _tensor__Tensor___init__i32_epilogue
_tensor__Tensor___init__i32_epilogue:
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
_data__TensorData__relu__i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $336, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__relu__i32_L0:
	movq %rdi, %r12
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__i32
	movq %rax, %rbx
	movslq 8(%r12), %rsi
	movslq 12(%r12), %rcx
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %esi, 0(%rdx)
	movl %ecx, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %r8
	movq $24, %rdi
	movq %rdi, 0(%r8)
	movq $1, %rdi
	movq %rdi, 8(%r8)
	movq %rsi, 16(%r8)
	leaq -96(%rbp), %rcx
	movq $0, %rdi
	movq %rdi, 0(%rcx)
	movq $4, %rdi
	movq %rdi, 8(%rcx)
	leaq -120(%rbp), %rsi
	movq $24, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	movq %rcx, 16(%rsi)
	leaq -168(%rbp), %rcx
	movq %rbx, 0(%rcx)
	movq $24, %rdi
	movq %rdi, 8(%rcx)
	movq %r8, 16(%rcx)
	movq %r12, 24(%rcx)
	movq $24, %rdi
	movq %rdi, 32(%rcx)
	movq %rsi, 40(%rcx)
	leaq -328(%rbp), %r8
	movq $95, %rdi
	movb %dil, 0(%r8)
	movq $107, %rdi
	movb %dil, 8(%r8)
	movq $101, %rdi
	movb %dil, 16(%r8)
	movq $114, %rdi
	movb %dil, 24(%r8)
	movq $110, %rdi
	movb %dil, 32(%r8)
	movq $101, %rdi
	movb %dil, 40(%r8)
	movq $108, %rdi
	movb %dil, 48(%r8)
	movq $115, %rdi
	movb %dil, 56(%r8)
	movq $95, %rdi
	movb %dil, 64(%r8)
	movq $95, %rdi
	movb %dil, 72(%r8)
	movq $114, %rdi
	movb %dil, 80(%r8)
	movq $101, %rdi
	movb %dil, 88(%r8)
	movq $108, %rdi
	movb %dil, 96(%r8)
	movq $117, %rdi
	movb %dil, 104(%r8)
	movq $95, %rdi
	movb %dil, 112(%r8)
	movq $95, %rdi
	movb %dil, 120(%r8)
	movq $105, %rdi
	movb %dil, 128(%r8)
	movq $51, %rdi
	movb %dil, 136(%r8)
	movq $50, %rdi
	movb %dil, 144(%r8)
	movq $0, %rdi
	movb %dil, 152(%r8)
	movq %rcx, %rdi
	movq $2, %rsi
	movq %r8, %rcx
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData__relu__i32_epilogue
	jmp _data__TensorData__relu__i32_epilogue
_data__TensorData__relu__i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $336, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____getitem____i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____getitem____i32_L0:
	movq %rdi, %rdx
	movq $0, %rdi
	movslq (%rdi,%rsi), %rdi
	movq $8, %rcx
	movslq (%rcx,%rsi), %r8
	movslq 16(%rdx), %rsi
	movslq 20(%rdx), %rcx
	imulq %rdi, %rsi
	movq %r8, %rdi
	imulq %rcx, %rdi
	movq %rsi, %rcx
	addq %rdi, %rcx
	movq 0(%rdx), %rdi
	movq $4, %rsi
	imulq %rcx, %rsi
	movq $8, %rdx
	addq %rdx, %rsi
	movslq (%rsi,%rdi), %rdi
	movq %rdi, %rax
	jmp _data__TensorData____getitem____i32_epilogue
	jmp _data__TensorData____getitem____i32_epilogue
_data__TensorData____getitem____i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__fill__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__fill__f32_L0:
	movq %rdi, %rbx
	movq %xmm1, %xmm0
	movq %xmm0, -8(%rbp)
	movq $0, %rdi
	movslq (%rdi,%rbx), %rsi
	movq $8, %rdi
	movslq (%rdi,%rbx), %rdi
	movq %rsi, %r12
	imulq %rdi, %r12
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $1, %rdi
	movq %rdi, 0(%r13)
	movq -8(%rbp), %xmm0
	movq $8, %rdi
	movss %xmm0, (%r13,%rdi)
	movq (%r13), %rdi
	movq %rdi, %r14
	imulq %r12, %r14
	movq $4, %rdi
	imulq %r14, %rdi
	movq $8, %rsi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r14, 0(%r15)
	movq %r15, %rdi
	movq %r13, %rsi
	movq %r12, %rdx
	callq _repeat__list_repeat__f32
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r15, %rsi
	movq %rbx, %rdx
	callq _data__TensorData____init____f32
	movq %r12, %rax
	jmp _data__TensorData__fill__f32_epilogue
	jmp _data__TensorData__fill__f32_epilogue
_data__TensorData__fill__f32_epilogue:
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
_data__TensorData____init____i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____init____i32_L0:
	movq %rdi, %rcx
	movq %rsi, %rdi
	movq %rdx, %rsi
	movq %rdi, 0(%rcx)
	movq $0, %rdi
	movslq (%rdi,%rsi), %rdi
	movl %edi, 8(%rcx)
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdi
	movl %edi, 12(%rcx)
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdi
	movl %edi, 16(%rcx)
	movq $1, %rdi
	movl %edi, 20(%rcx)
	jmp _data__TensorData____init____i32_epilogue
	jmp _data__TensorData____init____i32_epilogue
_data__TensorData____init____i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor____init____i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____init____i32_L0:
	movq %rdi, -8(%rbp)
	movq %rsi, %rbx
	movq %rdx, %r12
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	movq %r12, %rdx
	callq _data__TensorData____init____i32
	movq -8(%rbp), %rdi
	movq %r13, 0(%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $1, %rdi
	movq %rdi, 0(%r13)
	movl $0, %r11d
	movd %r11d, %xmm0
	movq $8, %rdi
	movss %xmm0, (%r13,%rdi)
	movq $0, %rdi
	movslq (%rdi,%r12), %rsi
	movq $8, %rdi
	movslq (%rdi,%r12), %rdi
	movq %rsi, %rbx
	imulq %rdi, %rbx
	movq (%r13), %rdi
	movq %rdi, %r14
	imulq %rbx, %r14
	movq $4, %rdi
	imulq %r14, %rdi
	movq $8, %rsi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r14, 0(%r15)
	movq %r15, %rdi
	movq %r13, %rsi
	movq %rbx, %rdx
	callq _repeat__list_repeat__f32
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r15, %rsi
	movq %r12, %rdx
	callq _data__TensorData____init____f32
	movq -8(%rbp), %rdi
	movq %rbx, 8(%rdi)
	leaq _tensor____lambda_82(%rip), %rsi
	movq -8(%rbp), %rdi
	movq %rsi, 16(%rdi)
	jmp _tensor__Tensor____init____i32_epilogue
	jmp _tensor__Tensor____init____i32_epilogue
_tensor__Tensor____init____i32_epilogue:
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
_data__TensorData____init____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____init____f32_L0:
	movq %rdi, %rcx
	movq %rdx, %rdi
	movq %rsi, 0(%rcx)
	movq $0, %rsi
	movslq (%rsi,%rdi), %rsi
	movl %esi, 8(%rcx)
	movq $8, %rsi
	movslq (%rsi,%rdi), %rsi
	movl %esi, 12(%rcx)
	movq $8, %rsi
	movslq (%rsi,%rdi), %rdi
	movl %edi, 16(%rcx)
	movq $1, %rdi
	movl %edi, 20(%rcx)
	jmp _data__TensorData____init____f32_epilogue
	jmp _data__TensorData____init____f32_epilogue
_data__TensorData____init____f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_repeat__list_repeat__char:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_repeat__list_repeat__char_L0:
	movq %rdi, %r10
	movq %rdx, %rdi
	movq (%rsi), %rax
	movq %rax, %r9
	imulq %rdi, %r9
	movq $0, %rdi
	movq $0, %r8
	jmp _repeat__list_repeat__char_L1
_repeat__list_repeat__char_L1:
	cmpq %r9, %r8
	setl %r11b
	movzbq %r11b, %rdx
	cmpq $0, %rdx
	jne _repeat__list_repeat__char_L2
	jmp _repeat__list_repeat__char_L3
_repeat__list_repeat__char_L2:
	movq %rdi, %rbx
	addq %r8, %rbx
	pushq %rax
	pushq %rdx
	movq %rax, %r11
	movq %rbx, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rcx
	movq $8, %rdx
	addq %rcx, %rdx
	movzbq (%rdx,%rsi), %rdx
	movq $8, %rcx
	addq %rbx, %rcx
	movb %dl, (%r10,%rcx)
	movq $1, %rdx
	addq %rdx, %r8
	jmp _repeat__list_repeat__char_L1
_repeat__list_repeat__char_L3:
	jmp _repeat__list_repeat__char_epilogue
	jmp _repeat__list_repeat__char_epilogue
_repeat__list_repeat__char_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_repeat__list_repeat__i32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_repeat__list_repeat__i32_L0:
	movq %rdi, %rax
	movq %rsi, %r8
	movq %rdx, %rdi
	movq (%r8), %rsi
	movq %rsi, %rcx
	imulq %rdi, %rcx
	movq $0, %rdx
	movq $0, %r9
	jmp _repeat__list_repeat__i32_L1
_repeat__list_repeat__i32_L1:
	cmpq %rcx, %r9
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _repeat__list_repeat__i32_L2
	jmp _repeat__list_repeat__i32_L3
_repeat__list_repeat__i32_L2:
	movq %rdx, %rbx
	addq %r9, %rbx
	pushq %rax
	pushq %rdx
	movq %rsi, %r11
	movq %rbx, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %r10
	movq $4, %rdi
	imulq %rdi, %r10
	movq $8, %rdi
	addq %r10, %rdi
	movslq (%rdi,%r8), %r12
	movq $4, %rdi
	imulq %rbx, %rdi
	movq $8, %r10
	addq %r10, %rdi
	movl %r12d, (%rax,%rdi)
	movq $1, %rdi
	addq %rdi, %r9
	jmp _repeat__list_repeat__i32_L1
_repeat__list_repeat__i32_L3:
	jmp _repeat__list_repeat__i32_epilogue
	jmp _repeat__list_repeat__i32_epilogue
_repeat__list_repeat__i32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_repeat__list_repeat__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_repeat__list_repeat__f32_L0:
	movq %rdi, %rcx
	movq %rsi, %r9
	movq %rdx, %rdi
	movq (%r9), %rax
	movq %rax, %r8
	imulq %rdi, %r8
	movq $0, %r10
	movq $0, %rdx
	jmp _repeat__list_repeat__f32_L1
_repeat__list_repeat__f32_L1:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _repeat__list_repeat__f32_L2
	jmp _repeat__list_repeat__f32_L3
_repeat__list_repeat__f32_L2:
	movq %r10, %rsi
	addq %rdx, %rsi
	pushq %rax
	pushq %rdx
	movq %rax, %r11
	movq %rsi, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rdi
	movq $4, %rbx
	imulq %rbx, %rdi
	movq $8, %rbx
	addq %rbx, %rdi
	movss (%rdi,%r9), %xmm0
	movq $4, %rdi
	imulq %rsi, %rdi
	movq $8, %rsi
	addq %rsi, %rdi
	movss %xmm0, (%rcx,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _repeat__list_repeat__f32_L1
_repeat__list_repeat__f32_L3:
	jmp _repeat__list_repeat__f32_epilogue
	jmp _repeat__list_repeat__f32_epilogue
_repeat__list_repeat__f32_epilogue:
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
