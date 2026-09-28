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
	leaq _basic__f(%rip), %rdi
	movq $0, %rsi
	callq _basic__g
	movq %rax, %rbx
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
	movslq 0(%r12), %rdi
	movq -8(%rbp), %rsi
	movslq 0(%rsi), %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %r15
	subq %rdi, %r15
	movslq 0(%rbx), %rdi
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
	movslq 0(%r12), %rsi
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
	movslq 0(%r9), %rbx
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
	movslq 0(%rdx), %rsi
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
	movslq 0(%rbx), %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L4
	jmp _print__print_int_L5
_print__print_int_L4:
	movslq 0(%rbx), %rdi
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
	movslq 0(%r13), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_bool_L1
	jmp _print__print_bool_L2
_print__print_bool_L1:
	movslq 0(%r13), %rdi
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
	movslq 0(%rdx), %rdi
	movq $1, %rsi
	movq %rdi, %rcx
	subq %rsi, %rcx
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rcx, %rdx
	callq write
	movslq 0(%rbx), %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_string_L1
	jmp _print__print_string_L2
_print__print_string_L1:
	movslq 0(%rbx), %rdi
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
	movslq 0(%r12), %rdi
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
	movslq 0(%r12), %rsi
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
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
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
	movq %r11, %xmm0
	mulsd %xmm1, %xmm0
	movq %xmm0, -8(%rbp)
	movq -8(%rbp), %xmm0
	cvttsd2siq %xmm0, %r14
	movq %r14, %rdi
	callq _print___print_int_helper
	cvtsi2sdq %r14, %xmm0
	movq -8(%rbp), %xmm1
	subsd %xmm0, %xmm1
	movq $1, %rdi
	addq %rdi, %r13
	jmp _print__print_float_L4
_print__print_float_L6:
	movslq 0(%rbx), %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L7
	jmp _print__print_float_L8
_print__print_float_L7:
	movslq 0(%rbx), %rdi
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
	movq %rdi, %r12
	movq %rsi, %rbx
	movq 8(%r12), %rsi
	movq 0(%rbx), %rdi
	movslq 8(%rdi), %rdx
	movq $1, %rdi
	cmpq %rdi, %rdx
	sete %r11b
	movzbq %r11b, %rdx
	movq 0(%r12), %rdi
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
	movq 8(%r12), %rdi
	movq $0, %rsi
	callq _data__TensorData__sum__f32
	movq %rax, %rsi
	jmp _backward__broadcast_to_L3
_backward__broadcast_to_L2:
	jmp _backward__broadcast_to_L3
_backward__broadcast_to_L3:
	movq 0(%rbx), %rdi
	movslq 12(%rdi), %rdx
	movq $1, %rdi
	cmpq %rdi, %rdx
	sete %r11b
	movzbq %r11b, %rdi
	movq 0(%r12), %rdx
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
	movq 8(%r12), %rdi
	movq $1, %rsi
	callq _data__TensorData__sum__f32
	movq %rax, %rsi
	jmp _backward__broadcast_to_L6
_backward__broadcast_to_L5:
	jmp _backward__broadcast_to_L6
_backward__broadcast_to_L6:
	movq 8(%rbx), %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, 8(%rbx)
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
_module__Module____init___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: user
_basic__f:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_basic__f_L0:
	cmpq $0, %rdi
	jne _basic__f_L1
	jmp _basic__f_L2
_basic__f_L1:
	movq $1, %rdi
	jmp _basic__f_L3
_basic__f_L2:
	movq $2, %rdi
	jmp _basic__f_L3
_basic__f_L3:
	movq %rdi, %rax
	jmp _basic__f_epilogue
_basic__f_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: user
_basic__g:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_basic__g_L0:
	movq %rsi, %rdi
	movq $2, %rbx
	callq _basic__f
	movq %rax, %rdi
	imulq %rbx, %rdi
	movq %rdi, %rax
	jmp _basic__g_epilogue
_basic__g_epilogue:
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
	movq 8(%rdi), %rdx
	movq 16(%rdi), %rsi
	movq %rdx, %rdi
	callq _backward__broadcast_to
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
	callq _backward__add
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
_tensor____lambda_87:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_87_L0:
	movq 8(%rdi), %rsi
	movq 16(%rdi), %rcx
	movq 24(%rdi), %rdx
	movq %rsi, %rdi
	movq %rcx, %rsi
	callq _backward__sub
	jmp _tensor____lambda_87_epilogue
_tensor____lambda_87_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor____lambda_88:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor____lambda_88_L0:
	movq 8(%rdi), %rdx
	movq 16(%rdi), %rsi
	movq 24(%rdi), %rcx
	movq %rdx, %rdi
	movq %rcx, %rdx
	callq _backward__mul
	jmp _tensor____lambda_88_epilogue
_tensor____lambda_88_epilogue:
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
	movq %rsi, %r13
	movslq 8(%r12), %rdi
	movslq 12(%r12), %rdx
	leaq -16(%rbp), %rsi
	movl %edi, 0(%rsi)
	movl %edx, 8(%rsi)
	movq %rsi, %rdi
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r12), %rcx
	movslq 12(%r12), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
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
	leaq -96(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -120(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
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
	movq %rbx, 0(%rsi)
	movq $24, %rdi
	movq %rdi, 8(%rsi)
	movq %r8, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r13, 48(%rsi)
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
	movq %rbx, %rax
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
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %r13, %rax
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
	movq $109, %rdi
	movb %dil, 80(%rcx)
	movq $117, %rdi
	movb %dil, 88(%rcx)
	movq $108, %rdi
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
	movq %rdi, %rbx
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
	movq $1, %rsi
	movslq 12(%rbx), %rdx
	leaq -16(%rbp), %rdi
	movq %rsi, 0(%rdi)
	movl %edx, 8(%rdi)
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %r12
	movq 0(%r12), %rsi
	movslq 12(%rbx), %r8
	movq $1, %rdi
	movq $1, %rcx
	leaq -40(%rbp), %rdx
	movl %r8d, 0(%rdx)
	movq %rdi, 8(%rdx)
	movq %rcx, 16(%rdx)
	movq $4, %rdi
	movq 0(%rsi), %rcx
	imulq %rcx, %rdi
	movq $8, %rcx
	movq %rdi, %r9
	addq %rcx, %r9
	leaq -56(%rbp), %r8
	movq $0, %rdi
	movq %rdi, 0(%r8)
	movq $4, %rdi
	movq %rdi, 8(%r8)
	leaq -80(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %r8, 16(%rcx)
	leaq -128(%rbp), %r8
	movq %rsi, 0(%r8)
	movq %r9, 8(%r8)
	movq $0, %rdi
	movq %rdi, 16(%r8)
	movq %rbx, 24(%r8)
	movq $24, %rdi
	movq %rdi, 32(%r8)
	movq %rcx, 40(%r8)
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
	movq %r8, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %r12, %rdi
	jmp _data__TensorData__sum__f32_L3
_data__TensorData__sum__f32_L2:
	movslq 8(%rbx), %rdi
	movq $1, %rdx
	leaq -336(%rbp), %rsi
	movl %edi, 0(%rsi)
	movq %rdx, 8(%rsi)
	movq %rsi, %rdi
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %r12
	movq 0(%r12), %r9
	movslq 8(%rbx), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -360(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq $4, %rdi
	movq 0(%r9), %rsi
	imulq %rsi, %rdi
	movq $8, %rsi
	movq %rdi, %rcx
	addq %rsi, %rcx
	leaq -376(%rbp), %r8
	movq $0, %rdi
	movq %rdi, 0(%r8)
	movq $4, %rdi
	movq %rdi, 8(%r8)
	leaq -400(%rbp), %rsi
	movq $24, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	movq %r8, 16(%rsi)
	leaq -448(%rbp), %r8
	movq %r9, 0(%r8)
	movq %rcx, 8(%r8)
	movq $0, %rdi
	movq %rdi, 16(%r8)
	movq %rbx, 24(%r8)
	movq $24, %rdi
	movq %rdi, 32(%r8)
	movq %rsi, 40(%r8)
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
	movq %r8, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %r12, %rdi
	jmp _data__TensorData__sum__f32_L3
_data__TensorData__sum__f32_L3:
	movq %rdi, %rax
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
	movslq (%rdi,%rbx), %rdi
	movq $8, %rsi
	movslq (%rsi,%rbx), %rsi
	movq %rdi, %r13
	imulq %rsi, %r13
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $1, %rdi
	movq %rdi, 0(%r12)
	movq -8(%rbp), %xmm0
	movq $8, %rdi
	movss %xmm0, (%r12,%rdi)
	movq 0(%r12), %rdi
	movq %rdi, %r14
	imulq %r13, %r14
	movq $4, %rdi
	movq %r14, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r14, 0(%r15)
	movq %r15, %rdi
	movq %r12, %rsi
	movq %r13, %rdx
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
	movq %rdi, %r8
	movq %rsi, %rbx
	movq %rdx, %rdi
	movslq 0(%rbx), %rdx
	movq %rdx, %rcx
	imulq %rdi, %rcx
	movq $0, %r10
	movq $0, %rax
	jmp _repeat__list_repeat__char_L1
_repeat__list_repeat__char_L1:
	cmpq %rcx, %rax
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _repeat__list_repeat__char_L2
	jmp _repeat__list_repeat__char_L3
_repeat__list_repeat__char_L2:
	movq %r10, %rdi
	addq %rax, %rdi
	pushq %rax
	pushq %rdx
	movq %rdx, %r11
	movq %rdi, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rsi
	movq $8, %r9
	addq %r9, %rsi
	movzbq (%rsi,%rbx), %rsi
	movq $8, %r9
	addq %r9, %rdi
	movb %sil, (%r8,%rdi)
	movq $1, %rdi
	addq %rdi, %rax
	jmp _repeat__list_repeat__char_L1
_repeat__list_repeat__char_L3:
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
	movq %rsi, %r8
	movq %rdx, %rdi
	movslq 0(%r8), %r10
	movq %r10, %rdx
	imulq %rdi, %rdx
	movq $0, %rax
	movq $0, %r9
	jmp _repeat__list_repeat__f32_L1
_repeat__list_repeat__f32_L1:
	cmpq %rdx, %r9
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _repeat__list_repeat__f32_L2
	jmp _repeat__list_repeat__f32_L3
_repeat__list_repeat__f32_L2:
	movq %rax, %rbx
	addq %r9, %rbx
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
	movq $4, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movss (%rdi,%r8), %xmm0
	movq $4, %rdi
	imulq %rbx, %rdi
	movq $8, %rsi
	addq %rsi, %rdi
	movss %xmm0, (%rcx,%rdi)
	movq $1, %rdi
	addq %rdi, %r9
	jmp _repeat__list_repeat__f32_L1
_repeat__list_repeat__f32_L3:
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
