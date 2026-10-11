.text
.global main
# origin: user
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
main_L0:
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $4, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rdi
	movl $1084227584, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $12, %rdi
	movl $1092616192, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $16, %rdi
	movl $1101004800, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $20, %rdi
	movl $1109393408, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $2, %rsi
	movq $2, %rdi
	leaq -16(%rbp), %r12
	movl %esi, 0(%r12)
	movl %edi, 8(%r12)
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	movq %r12, %rdx
	callq _tensor__Tensor____init____f32
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $4, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rdi
	movl $1092616192, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $12, %rdi
	movl $1092616192, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $16, %rdi
	movl $1101004800, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $20, %rdi
	movl $1106247680, %r11d
	movd %r11d, %xmm0
	movss %xmm0, (%rbx,%rdi)
	movq $2, %rsi
	movq $2, %rdi
	leaq -32(%rbp), %r14
	movl %esi, 0(%r14)
	movl %edi, 8(%r14)
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	movq %r14, %rdx
	callq _tensor__Tensor____init____f32
	movq %r13, %rdi
	movq %r12, %rsi
	callq _tensor__Tensor____gt____f32
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
	callq _tensor__Tensor____print____bool
	movq %r13, %rdi
	movq %r12, %rsi
	callq _tensor__Tensor____lt____f32
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
	callq _tensor__Tensor____print____bool
	movq %r13, %rdi
	movq %r12, %rsi
	callq _tensor__Tensor____le____f32
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
	callq _tensor__Tensor____print____bool
	movq %r13, %rdi
	movq %r12, %rsi
	callq _tensor__Tensor____ge____f32
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
	callq _tensor__Tensor____print____bool
	movq %r13, %rdi
	movq %r12, %rsi
	callq _tensor__Tensor____eq____f32
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
	callq _tensor__Tensor____print____bool
	movq %r13, %rdi
	movq %r12, %rsi
	callq _tensor__Tensor____ne____f32
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
	callq _tensor__Tensor____print____bool
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
	addq $32, %rsp
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
	movq %xmm0, -16(%rbp)
	movq %rsi, %r12
	movabsq $0, %r11
	movq %r11, %xmm1
	movq -16(%rbp), %xmm0
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
	movq -16(%rbp), %xmm0
	 movq %xmm0, %xmm0
	movabsq $0x8000000000000000, %r11
	movq %r11, %xmm15
	 xorpd %xmm15, %xmm0
	movq %xmm0, -24(%rbp)
	jmp _print__print_float_L3
_print__print_float_L2:
	movq -16(%rbp), %xmm0
	movq %xmm0, -24(%rbp)
	jmp _print__print_float_L3
_print__print_float_L3:
	movq -24(%rbp), %xmm0
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
	movq -24(%rbp), %xmm0
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
_tensor__Tensor____init____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____init____f32_L0:
	movq %rdi, %r13
	movq %rsi, %rbx
	movq %rdx, %r12
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	movq %r12, %rdx
	callq _data__TensorData____init____f32
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rdi
	movq %r14, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_f32
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r15, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_f32
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r15, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r12, %r8
	movq $0, %r9
	callq _uop__Uop____init____f32
	movq %rbx, 0(%r13)
	movq %r12, %rdi
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rdi
	movq %rdi, 8(%r13)
	jmp _tensor__Tensor____init____f32_epilogue
_tensor__Tensor____init____f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor____gt____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____gt____f32_L0:
	movq %rsi, %r12
	callq _tensor__Tensor__realize__f32
	movq %rax, %rbx
	movq %r12, %rdi
	callq _tensor__Tensor__realize__f32
	movq %rax, %rsi
	movq %rbx, %rdi
	callq _data__TensorData____gt____f32
	movq %rax, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_bool
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq %r13, %rsi
	movq $8, %rdi
	movq %rsi, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_bool
	movslq 8(%r13), %rsi
	movslq 12(%r13), %rdi
	leaq -16(%rbp), %r13
	movl %esi, 0(%r13)
	movl %edi, 8(%r13)
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %r9
	callq _uop__Uop____init____bool
	movq %rbx, %rdi
	callq _tensor__Tensor___init__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____gt____f32_epilogue
_tensor__Tensor____gt____f32_epilogue:
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
_tensor__Tensor____print____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____print____bool_L0:
	movq %rsi, %rbx
	callq _tensor__Tensor__realize__bool
	movq %rax, %rdi
	movq %rbx, %rsi
	callq _data__TensorData____print____bool
	jmp _tensor__Tensor____print____bool_epilogue
_tensor__Tensor____print____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor____lt____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____lt____f32_L0:
	movq %rsi, %r12
	callq _tensor__Tensor__realize__f32
	movq %rax, %rbx
	movq %r12, %rdi
	callq _tensor__Tensor__realize__f32
	movq %rax, %rsi
	movq %rbx, %rdi
	callq _data__TensorData____lt____f32
	movq %rax, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_bool
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq %r13, %rsi
	movq $8, %rdi
	movq %rsi, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_bool
	movslq 8(%r13), %rsi
	movslq 12(%r13), %rdi
	leaq -16(%rbp), %r13
	movl %esi, 0(%r13)
	movl %edi, 8(%r13)
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %r9
	callq _uop__Uop____init____bool
	movq %rbx, %rdi
	callq _tensor__Tensor___init__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____lt____f32_epilogue
_tensor__Tensor____lt____f32_epilogue:
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
_tensor__Tensor____le____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____le____f32_L0:
	movq %rsi, %r12
	callq _tensor__Tensor__realize__f32
	movq %rax, %rbx
	movq %r12, %rdi
	callq _tensor__Tensor__realize__f32
	movq %rax, %rsi
	movq %rbx, %rdi
	callq _data__TensorData____le____f32
	movq %rax, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_bool
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq %r13, %rsi
	movq $8, %rdi
	movq %rsi, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_bool
	movslq 8(%r13), %rsi
	movslq 12(%r13), %rdi
	leaq -16(%rbp), %r13
	movl %esi, 0(%r13)
	movl %edi, 8(%r13)
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %r9
	callq _uop__Uop____init____bool
	movq %rbx, %rdi
	callq _tensor__Tensor___init__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____le____f32_epilogue
_tensor__Tensor____le____f32_epilogue:
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
_tensor__Tensor____ge____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____ge____f32_L0:
	movq %rsi, %r12
	callq _tensor__Tensor__realize__f32
	movq %rax, %rbx
	movq %r12, %rdi
	callq _tensor__Tensor__realize__f32
	movq %rax, %rsi
	movq %rbx, %rdi
	callq _data__TensorData____ge____f32
	movq %rax, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_bool
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq %r13, %rsi
	movq $8, %rdi
	movq %rsi, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_bool
	movslq 8(%r13), %rsi
	movslq 12(%r13), %rdi
	leaq -16(%rbp), %r13
	movl %esi, 0(%r13)
	movl %edi, 8(%r13)
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %r9
	callq _uop__Uop____init____bool
	movq %rbx, %rdi
	callq _tensor__Tensor___init__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____ge____f32_epilogue
_tensor__Tensor____ge____f32_epilogue:
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
_tensor__Tensor____eq____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____eq____f32_L0:
	movq %rsi, %r12
	callq _tensor__Tensor__realize__f32
	movq %rax, %rbx
	movq %r12, %rdi
	callq _tensor__Tensor__realize__f32
	movq %rax, %rsi
	movq %rbx, %rdi
	callq _data__TensorData____eq____f32
	movq %rax, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_bool
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq %r13, %rsi
	movq $8, %rdi
	movq %rsi, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_bool
	movslq 8(%r13), %rsi
	movslq 12(%r13), %rdi
	leaq -16(%rbp), %r13
	movl %esi, 0(%r13)
	movl %edi, 8(%r13)
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %r9
	callq _uop__Uop____init____bool
	movq %rbx, %rdi
	callq _tensor__Tensor___init__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____eq____f32_epilogue
_tensor__Tensor____eq____f32_epilogue:
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
_tensor__Tensor____ne____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor____ne____f32_L0:
	movq %rsi, %r12
	callq _tensor__Tensor__realize__f32
	movq %rax, %rbx
	movq %r12, %rdi
	callq _tensor__Tensor__realize__f32
	movq %rax, %rsi
	movq %rbx, %rdi
	callq _data__TensorData____ne____f32
	movq %rax, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_bool
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq %r13, %rsi
	movq $8, %rdi
	movq %rsi, (%rbx,%rdi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_3_bool
	movslq 8(%r13), %rsi
	movslq 12(%r13), %rdi
	leaq -16(%rbp), %r13
	movl %esi, 0(%r13)
	movl %edi, 8(%r13)
	movq $36, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %r9
	callq _uop__Uop____init____bool
	movq %rbx, %rdi
	callq _tensor__Tensor___init__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor____ne____f32_epilogue
_tensor__Tensor____ne____f32_epilogue:
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
_list__list____init____class_3_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____init____class_3_f32_L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	movslq 0(%rdi), %rdi
	movl %edi, 8(%rdx)
	jmp _list__list____init____class_3_f32_epilogue
_list__list____init____class_3_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____init____class_1_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____init____class_1_f32_L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	movslq 0(%rdi), %rdi
	movl %edi, 8(%rdx)
	jmp _list__list____init____class_1_f32_epilogue
_list__list____init____class_1_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_uop__Uop____init____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_uop__Uop____init____f32_L0:
	movq %rdi, %rbx
	movq %rsi, %r10
	movq %rdx, %rax
	movq %rcx, %rdx
	movq %r8, %rsi
	movq %r9, %rdi
	movq %r10, 0(%rbx)
	movq %rax, 8(%rbx)
	movq %rdx, 16(%rbx)
	movq %rsi, 24(%rbx)
	movl %edi, 32(%rbx)
	jmp _uop__Uop____init____f32_epilogue
_uop__Uop____init____f32_epilogue:
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
	movq %rsi, %r13
	imulq %rdi, %r13
	movq $4, %rdi
	movq %r13, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r13, %rdi
	movq %rdi, 0(%r12)
	movq $0, %rcx
	movq -8(%rbp), %xmm0
	movq $0, %rdx
	jmp _data__TensorData__fill__f32_L1
_data__TensorData__fill__f32_L1:
	cmpq %r13, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__fill__f32_L2
	jmp _data__TensorData__fill__f32_L3
_data__TensorData__fill__f32_L2:
	movq %rcx, %rsi
	addq %rdx, %rsi
	movq $4, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movss %xmm0, (%r12,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _data__TensorData__fill__f32_L1
_data__TensorData__fill__f32_L3:
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %r12, %rsi
	movq %rbx, %rdx
	callq _data__TensorData____init____f32
	movq %r13, %rax
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
_tensor__Tensor__realize__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor__realize__f32_L0:
	movq 0(%rdi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor__realize__f32_epilogue
_tensor__Tensor__realize__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____gt____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____gt____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -376(%rbp), %rcx
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
	movq $103, %rdi
	movb %dil, 80(%rcx)
	movq $116, %rdi
	movb %dil, 88(%rcx)
	movq $95, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $102, %rdi
	movb %dil, 112(%rcx)
	movq $51, %rdi
	movb %dil, 120(%rcx)
	movq $50, %rdi
	movb %dil, 128(%rcx)
	movq $0, %rdi
	movb %dil, 136(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____gt____f32_epilogue
_data__TensorData____gt____f32_epilogue:
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
_list__list____init____class_1_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____init____class_1_bool_L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	movslq 0(%rdi), %rdi
	movl %edi, 8(%rdx)
	jmp _list__list____init____class_1_bool_epilogue
_list__list____init____class_1_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____init____class_3_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____init____class_3_bool_L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	movslq 0(%rdi), %rdi
	movl %edi, 8(%rdx)
	jmp _list__list____init____class_3_bool_epilogue
_list__list____init____class_3_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_uop__Uop____init____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_uop__Uop____init____bool_L0:
	movq %rdi, %rbx
	movq %rsi, %r10
	movq %rdx, %rax
	movq %rcx, %rdx
	movq %r8, %rsi
	movq %r9, %rdi
	movq %r10, 0(%rbx)
	movq %rax, 8(%rbx)
	movq %rdx, 16(%rbx)
	movq %rsi, 24(%rbx)
	movl %edi, 32(%rbx)
	jmp _uop__Uop____init____bool_epilogue
_uop__Uop____init____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor___init__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor___init__bool_L0:
	movq %rdi, %r12
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %r12, 0(%rbx)
	movq 24(%r12), %rdi
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rdi
	movq %rdi, 8(%rbx)
	movq %rbx, %rax
	jmp _tensor__Tensor___init__bool_epilogue
_tensor__Tensor___init__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor__realize__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor__realize__bool_L0:
	movq 0(%rdi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor__realize__bool_epilogue
_tensor__Tensor__realize__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____print____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $64, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____print____bool_L0:
	movq %rdi, %rcx
	movq %rsi, %rbx
	movslq 8(%rcx), %rsi
	movq $0, %rdi
	movq %rdi, -24(%rbp)
	movq %rsi, -32(%rbp)
	movq $0, %r14
	jmp _data__TensorData____print____bool_L1
_data__TensorData____print____bool_L1:
	movq -32(%rbp), %rdi
	cmpq %rdi, %r14
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData____print____bool_L2
	jmp _data__TensorData____print____bool_L3
_data__TensorData____print____bool_L2:
	movq -24(%rbp), %rdi
	movq %rdi, %rdx
	addq %r14, %rdx
	movslq 12(%rcx), %rsi
	movq $0, %rdi
	movq %rdi, -48(%rbp)
	movq %rsi, -56(%rbp)
	movq %rbx, -40(%rbp)
	movq %rcx, %r13
	movq %rdx, %r12
	movq $0, %rbx
	jmp _data__TensorData____print____bool_L4
_data__TensorData____print____bool_L3:
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
	jmp _data__TensorData____print____bool_epilogue
_data__TensorData____print____bool_L4:
	movq -56(%rbp), %rdi
	cmpq %rdi, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData____print____bool_L5
	jmp _data__TensorData____print____bool_L6
_data__TensorData____print____bool_L5:
	movq -48(%rbp), %rdi
	addq %rbx, %rdi
	leaq -16(%rbp), %rsi
	movl %r12d, 0(%rsi)
	movl %edi, 8(%rsi)
	movq %r13, %rdi
	callq _data__TensorData____getitem____bool
	movq %rax, %r15
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
	movq %r15, %rdi
	movq %rdx, %rsi
	callq _print__print_bool
	movq $1, %rdi
	addq %rdi, %rbx
	jmp _data__TensorData____print____bool_L4
_data__TensorData____print____bool_L6:
	movq $1, %rdi
	addq %r14, %rdi
	movq -40(%rbp), %rbx
	movq %r13, %rcx
	movq %rdi, %r14
	jmp _data__TensorData____print____bool_L1
_data__TensorData____print____bool_epilogue:
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
_data__TensorData____lt____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____lt____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -376(%rbp), %rcx
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
	movq $108, %rdi
	movb %dil, 80(%rcx)
	movq $116, %rdi
	movb %dil, 88(%rcx)
	movq $95, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $102, %rdi
	movb %dil, 112(%rcx)
	movq $51, %rdi
	movb %dil, 120(%rcx)
	movq $50, %rdi
	movb %dil, 128(%rcx)
	movq $0, %rdi
	movb %dil, 136(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____lt____f32_epilogue
_data__TensorData____lt____f32_epilogue:
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
_data__TensorData____le____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____le____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -376(%rbp), %rcx
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
	movq $108, %rdi
	movb %dil, 80(%rcx)
	movq $101, %rdi
	movb %dil, 88(%rcx)
	movq $95, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $102, %rdi
	movb %dil, 112(%rcx)
	movq $51, %rdi
	movb %dil, 120(%rcx)
	movq $50, %rdi
	movb %dil, 128(%rcx)
	movq $0, %rdi
	movb %dil, 136(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____le____f32_epilogue
_data__TensorData____le____f32_epilogue:
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
_data__TensorData____ge____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____ge____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -376(%rbp), %rcx
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
	movq $103, %rdi
	movb %dil, 80(%rcx)
	movq $101, %rdi
	movb %dil, 88(%rcx)
	movq $95, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $102, %rdi
	movb %dil, 112(%rcx)
	movq $51, %rdi
	movb %dil, 120(%rcx)
	movq $50, %rdi
	movb %dil, 128(%rcx)
	movq $0, %rdi
	movb %dil, 136(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____ge____f32_epilogue
_data__TensorData____ge____f32_epilogue:
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
_data__TensorData____eq____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____eq____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -376(%rbp), %rcx
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
	movq $101, %rdi
	movb %dil, 80(%rcx)
	movq $113, %rdi
	movb %dil, 88(%rcx)
	movq $95, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $102, %rdi
	movb %dil, 112(%rcx)
	movq $51, %rdi
	movb %dil, 120(%rcx)
	movq $50, %rdi
	movb %dil, 128(%rcx)
	movq $0, %rdi
	movb %dil, 136(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____eq____f32_epilogue
_data__TensorData____eq____f32_epilogue:
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
_data__TensorData____ne____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____ne____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -376(%rbp), %rcx
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
	movq $110, %rdi
	movb %dil, 80(%rcx)
	movq $101, %rdi
	movb %dil, 88(%rcx)
	movq $95, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $102, %rdi
	movb %dil, 112(%rcx)
	movq $51, %rdi
	movb %dil, 120(%rcx)
	movq $50, %rdi
	movb %dil, 128(%rcx)
	movq $0, %rdi
	movb %dil, 136(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____ne____f32_epilogue
_data__TensorData____ne____f32_epilogue:
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
_eval__evaluate__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_eval__evaluate__f32_L0:
	movq %rdi, %rbx
	movq 16(%rbx), %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L1
	jmp _eval__evaluate__f32_L2
_eval__evaluate__f32_L1:
	movq 8(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L3
_eval__evaluate__f32_L2:
	movq 16(%rbx), %rsi
	movq $2, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L4
	jmp _eval__evaluate__f32_L5
_eval__evaluate__f32_L3:
_eval__evaluate__f32_L4:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____add____f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L6
_eval__evaluate__f32_L5:
	movq 16(%rbx), %rsi
	movq $3, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L7
	jmp _eval__evaluate__f32_L8
_eval__evaluate__f32_L6:
	jmp _eval__evaluate__f32_L3
_eval__evaluate__f32_L7:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____sub____f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L9
_eval__evaluate__f32_L8:
	movq 16(%rbx), %rsi
	movq $4, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L10
	jmp _eval__evaluate__f32_L11
_eval__evaluate__f32_L9:
	jmp _eval__evaluate__f32_L6
_eval__evaluate__f32_L10:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____mul____f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L12
_eval__evaluate__f32_L11:
	movq 16(%rbx), %rsi
	movq $5, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L13
	jmp _eval__evaluate__f32_L14
_eval__evaluate__f32_L12:
	jmp _eval__evaluate__f32_L9
_eval__evaluate__f32_L13:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____truediv____f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L15
_eval__evaluate__f32_L14:
	movq 16(%rbx), %rsi
	movq $6, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L16
	jmp _eval__evaluate__f32_L17
_eval__evaluate__f32_L15:
	jmp _eval__evaluate__f32_L12
_eval__evaluate__f32_L16:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____matmul____f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L18
_eval__evaluate__f32_L17:
	movq 16(%rbx), %rsi
	movq $7, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L19
	jmp _eval__evaluate__f32_L20
_eval__evaluate__f32_L18:
	jmp _eval__evaluate__f32_L15
_eval__evaluate__f32_L19:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	callq _data__TensorData__relu__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L21
_eval__evaluate__f32_L20:
	movq 16(%rbx), %rsi
	movq $8, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L22
	jmp _eval__evaluate__f32_L23
_eval__evaluate__f32_L21:
	jmp _eval__evaluate__f32_L18
_eval__evaluate__f32_L22:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	callq _data__TensorData__exp__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L24
_eval__evaluate__f32_L23:
	movq 16(%rbx), %rsi
	movq $9, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L25
	jmp _eval__evaluate__f32_L26
_eval__evaluate__f32_L24:
	jmp _eval__evaluate__f32_L21
_eval__evaluate__f32_L25:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	movslq 32(%rbx), %rsi
	callq _data__TensorData__sum__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L27
_eval__evaluate__f32_L26:
	movq 16(%rbx), %rsi
	movq $10, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L28
	jmp _eval__evaluate__f32_L29
_eval__evaluate__f32_L27:
	jmp _eval__evaluate__f32_L24
_eval__evaluate__f32_L28:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	movslq 32(%rbx), %rsi
	callq _data__TensorData__max__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L30
_eval__evaluate__f32_L29:
	movq 16(%rbx), %rsi
	movq $11, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L31
	jmp _eval__evaluate__f32_L32
_eval__evaluate__f32_L30:
	jmp _eval__evaluate__f32_L27
_eval__evaluate__f32_L31:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	movq 24(%rbx), %rsi
	callq _data__TensorData__broadcast_to__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L33
_eval__evaluate__f32_L32:
	movq 16(%rbx), %rsi
	movq $12, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__f32_L34
	jmp _eval__evaluate__f32_L35
_eval__evaluate__f32_L33:
	jmp _eval__evaluate__f32_L30
_eval__evaluate__f32_L34:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__f32
	movq %rax, %rdi
	callq _data__TensorData__transpose__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__f32_epilogue
	jmp _eval__evaluate__f32_L36
_eval__evaluate__f32_L35:
	jmp _eval__evaluate__f32_L36
_eval__evaluate__f32_L36:
	jmp _eval__evaluate__f32_L33
_eval__evaluate__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__fill__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__fill__bool_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movq $0, %rdi
	movslq (%rdi,%r12), %rsi
	movq $8, %rdi
	movslq (%rdi,%r12), %rdi
	movq %rsi, %r13
	imulq %rdi, %r13
	movq $8, %rdi
	addq %r13, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %r13, %rdi
	movq %rdi, 0(%rsi)
	movq $0, %rcx
	movq %r13, %r8
	movq %rbx, %r9
	movq %r12, %r13
	movq %rsi, %r12
	movq $0, %rdx
	jmp _data__TensorData__fill__bool_L1
_data__TensorData__fill__bool_L1:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__fill__bool_L2
	jmp _data__TensorData__fill__bool_L3
_data__TensorData__fill__bool_L2:
	movq %rcx, %rsi
	addq %rdx, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movb %r9b, (%r12,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _data__TensorData__fill__bool_L1
_data__TensorData__fill__bool_L3:
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r13, %rdx
	callq _data__TensorData____init____bool
	movq %rbx, %rax
	jmp _data__TensorData__fill__bool_epilogue
_data__TensorData__fill__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_eval__evaluate__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_eval__evaluate__bool_L0:
	movq %rdi, %rbx
	movq 16(%rbx), %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L1
	jmp _eval__evaluate__bool_L2
_eval__evaluate__bool_L1:
	movq 8(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L3
_eval__evaluate__bool_L2:
	movq 16(%rbx), %rsi
	movq $2, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L4
	jmp _eval__evaluate__bool_L5
_eval__evaluate__bool_L3:
_eval__evaluate__bool_L4:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____add____bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L6
_eval__evaluate__bool_L5:
	movq 16(%rbx), %rsi
	movq $3, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L7
	jmp _eval__evaluate__bool_L8
_eval__evaluate__bool_L6:
	jmp _eval__evaluate__bool_L3
_eval__evaluate__bool_L7:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____sub____bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L9
_eval__evaluate__bool_L8:
	movq 16(%rbx), %rsi
	movq $4, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L10
	jmp _eval__evaluate__bool_L11
_eval__evaluate__bool_L9:
	jmp _eval__evaluate__bool_L6
_eval__evaluate__bool_L10:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____mul____bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L12
_eval__evaluate__bool_L11:
	movq 16(%rbx), %rsi
	movq $5, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L13
	jmp _eval__evaluate__bool_L14
_eval__evaluate__bool_L12:
	jmp _eval__evaluate__bool_L9
_eval__evaluate__bool_L13:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____truediv____bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L15
_eval__evaluate__bool_L14:
	movq 16(%rbx), %rsi
	movq $6, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L16
	jmp _eval__evaluate__bool_L17
_eval__evaluate__bool_L15:
	jmp _eval__evaluate__bool_L12
_eval__evaluate__bool_L16:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %r12
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $16, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rsi
	movq %r12, %rdi
	callq _data__TensorData____matmul____bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L18
_eval__evaluate__bool_L17:
	movq 16(%rbx), %rsi
	movq $7, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L19
	jmp _eval__evaluate__bool_L20
_eval__evaluate__bool_L18:
	jmp _eval__evaluate__bool_L15
_eval__evaluate__bool_L19:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	callq _data__TensorData__relu__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L21
_eval__evaluate__bool_L20:
	movq 16(%rbx), %rsi
	movq $8, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L22
	jmp _eval__evaluate__bool_L23
_eval__evaluate__bool_L21:
	jmp _eval__evaluate__bool_L18
_eval__evaluate__bool_L22:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	callq _data__TensorData__exp__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L24
_eval__evaluate__bool_L23:
	movq 16(%rbx), %rsi
	movq $9, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L25
	jmp _eval__evaluate__bool_L26
_eval__evaluate__bool_L24:
	jmp _eval__evaluate__bool_L21
_eval__evaluate__bool_L25:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	movslq 32(%rbx), %rsi
	callq _data__TensorData__sum__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L27
_eval__evaluate__bool_L26:
	movq 16(%rbx), %rsi
	movq $10, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L28
	jmp _eval__evaluate__bool_L29
_eval__evaluate__bool_L27:
	jmp _eval__evaluate__bool_L24
_eval__evaluate__bool_L28:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	movslq 32(%rbx), %rsi
	callq _data__TensorData__max__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L30
_eval__evaluate__bool_L29:
	movq 16(%rbx), %rsi
	movq $11, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L31
	jmp _eval__evaluate__bool_L32
_eval__evaluate__bool_L30:
	jmp _eval__evaluate__bool_L27
_eval__evaluate__bool_L31:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	movq 24(%rbx), %rsi
	callq _data__TensorData__broadcast_to__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L33
_eval__evaluate__bool_L32:
	movq 16(%rbx), %rsi
	movq $12, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _eval__evaluate__bool_L34
	jmp _eval__evaluate__bool_L35
_eval__evaluate__bool_L33:
	jmp _eval__evaluate__bool_L30
_eval__evaluate__bool_L34:
	movq 0(%rbx), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	movq (%rdi,%rsi), %rdi
	callq _eval__evaluate__bool
	movq %rax, %rdi
	callq _data__TensorData__transpose__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _eval__evaluate__bool_epilogue
	jmp _eval__evaluate__bool_L36
_eval__evaluate__bool_L35:
	jmp _eval__evaluate__bool_L36
_eval__evaluate__bool_L36:
	jmp _eval__evaluate__bool_L33
_eval__evaluate__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____getitem____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____getitem____bool_L0:
	movq %rdi, %r8
	movq $0, %rdi
	movslq (%rdi,%rsi), %rcx
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdx
	movslq 16(%r8), %rsi
	movslq 20(%r8), %rdi
	imulq %rcx, %rsi
	imulq %rdx, %rdi
	addq %rdi, %rsi
	movq 0(%r8), %rdx
	movq $8, %rdi
	addq %rsi, %rdi
	movzbq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _data__TensorData____getitem____bool_epilogue
_data__TensorData____getitem____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____getitem____class_3_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____getitem____class_3_f32_L0:
	movq 0(%rdi), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _list__list____getitem____class_3_f32_epilogue
_list__list____getitem____class_3_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____getitem____class_1_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____getitem____class_1_f32_L0:
	movq 0(%rdi), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _list__list____getitem____class_1_f32_epilogue
_list__list____getitem____class_1_f32_epilogue:
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
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
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
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
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
	movq %rbx, %rax
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
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
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
	movq %rsi, %rdi
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
_data__TensorData____truediv____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $384, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____truediv____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
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
	movq $100, %rdi
	movb %dil, 80(%rcx)
	movq $105, %rdi
	movb %dil, 88(%rcx)
	movq $118, %rdi
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
	jmp _data__TensorData____truediv____f32_epilogue
_data__TensorData____truediv____f32_epilogue:
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
_data__TensorData____matmul____f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $416, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____matmul____f32_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movslq 8(%r13), %rcx
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -408(%rbp), %rcx
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
	movq $97, %rdi
	movb %dil, 88(%rcx)
	movq $116, %rdi
	movb %dil, 96(%rcx)
	movq $109, %rdi
	movb %dil, 104(%rcx)
	movq $117, %rdi
	movb %dil, 112(%rcx)
	movq $108, %rdi
	movb %dil, 120(%rcx)
	movq $95, %rdi
	movb %dil, 128(%rcx)
	movq $95, %rdi
	movb %dil, 136(%rcx)
	movq $102, %rdi
	movb %dil, 144(%rcx)
	movq $51, %rdi
	movb %dil, 152(%rcx)
	movq $50, %rdi
	movb %dil, 160(%rcx)
	movq $0, %rdi
	movb %dil, 168(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____matmul____f32_epilogue
_data__TensorData____matmul____f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $416, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__relu__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $336, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__relu__f32_L0:
	movq %rdi, %r12
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
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
	leaq -168(%rbp), %rsi
	movq %rbx, 0(%rsi)
	movq $24, %rdi
	movq %rdi, 8(%rsi)
	movq %r8, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	leaq -328(%rbp), %rcx
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
	movq $114, %rdi
	movb %dil, 80(%rcx)
	movq $101, %rdi
	movb %dil, 88(%rcx)
	movq $108, %rdi
	movb %dil, 96(%rcx)
	movq $117, %rdi
	movb %dil, 104(%rcx)
	movq $95, %rdi
	movb %dil, 112(%rcx)
	movq $95, %rdi
	movb %dil, 120(%rcx)
	movq $102, %rdi
	movb %dil, 128(%rcx)
	movq $51, %rdi
	movb %dil, 136(%rcx)
	movq $50, %rdi
	movb %dil, 144(%rcx)
	movq $0, %rdi
	movb %dil, 152(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData__relu__f32_epilogue
_data__TensorData__relu__f32_epilogue:
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
_data__TensorData__exp__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $240, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__exp__f32_L0:
	movq %rdi, %r12
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movl $0, %r11d
	movd %r11d, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %rax
	movq 0(%r12), %r9
	movslq 8(%r12), %rsi
	movslq 12(%r12), %rdi
	movq %rsi, %rcx
	imulq %rdi, %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq $4, %rsi
	movq 0(%rax), %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	movq $4, %rsi
	movq 0(%r9), %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	movq %rsi, %rcx
	addq %rdi, %rcx
	leaq -88(%rbp), %rsi
	movq %rax, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r9, 24(%rsi)
	movq %rcx, 32(%rsi)
	movq $0, %rdi
	movq %rdi, 40(%rsi)
	leaq -240(%rbp), %rcx
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
	movq $101, %rdi
	movb %dil, 80(%rcx)
	movq $120, %rdi
	movb %dil, 88(%rcx)
	movq $112, %rdi
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
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData__exp__f32_epilogue
_data__TensorData__exp__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $240, %rsp
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
	movq $1, %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movq %rdx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 12(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq $4, %rsi
	movq 0(%r9), %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -128(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
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
	movq $1, %rsi
	leaq -336(%rbp), %rdi
	movl %edx, 0(%rdi)
	movq %rsi, 8(%rdi)
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 8(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -360(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq $4, %rsi
	movq 0(%r9), %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -376(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -400(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -448(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
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
_data__TensorData__max__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $640, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__max__f32_L0:
	movq %rdi, %r12
	movl $0, %r11d
	movd %r11d, %xmm0
	movq $0, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__max__f32_L1
	jmp _data__TensorData__max__f32_L2
_data__TensorData__max__f32_L1:
	movq $1, %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movq %rdx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 12(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq $4, %rsi
	movq 0(%r9), %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -128(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
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
	movq $109, %rdi
	movb %dil, 80(%rcx)
	movq $97, %rdi
	movb %dil, 88(%rcx)
	movq $120, %rdi
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
	jmp _data__TensorData__max__f32_L3
_data__TensorData__max__f32_L2:
	movslq 8(%r12), %rdx
	movq $1, %rsi
	leaq -336(%rbp), %rdi
	movl %edx, 0(%rdi)
	movq %rsi, 8(%rdi)
	movq %xmm0, %xmm1
	callq _data__TensorData__fill__f32
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 8(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -360(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq $4, %rsi
	movq 0(%r9), %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -376(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $4, %rdi
	movq %rdi, 8(%rsi)
	leaq -400(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -448(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
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
	movq $109, %rdi
	movb %dil, 80(%rcx)
	movq $97, %rdi
	movb %dil, 88(%rcx)
	movq $120, %rdi
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
	jmp _data__TensorData__max__f32_L3
_data__TensorData__max__f32_L3:
	movq %rdi, %rax
	jmp _data__TensorData__max__f32_epilogue
_data__TensorData__max__f32_epilogue:
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
_data__TensorData__broadcast_to__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__broadcast_to__f32_L0:
	movq %rdi, %r10
	movq $0, %rdi
	movslq (%rdi,%rsi), %r9
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdx
	movslq 8(%r10), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rsi
	movq $1, %rdi
	cmpq %rdi, %r9
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rsi
	movq %rdi, %r11
movq $0, %rsi
	cmovne %r11, %rsi
	movslq 16(%r10), %rdi
	cmpq $0, %rsi
movq $0, %r11
	movq %rdi, %rcx
	cmovne %r11, %rcx
	movslq 12(%r10), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rsi
	movq $1, %rdi
	cmpq %rdi, %rdx
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rsi
	movq %rdi, %r11
movq $0, %rsi
	cmovne %r11, %rsi
	movslq 20(%r10), %rdi
	cmpq $0, %rsi
movq $0, %r11
	movq %rdi, %r8
	cmovne %r11, %r8
	movq 0(%r10), %rdi
	movq %r9, %rsi
	callq _data__TensorData___view__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _data__TensorData__broadcast_to__f32_epilogue
_data__TensorData__broadcast_to__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__transpose__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__transpose__f32_L0:
	movq %rdi, %r8
	movq 0(%r8), %rdi
	movslq 12(%r8), %rsi
	movslq 8(%r8), %rdx
	movslq 20(%r8), %rcx
	movslq 16(%r8), %r8
	callq _data__TensorData___view__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _data__TensorData__transpose__f32_epilogue
_data__TensorData__transpose__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____init____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____init____bool_L0:
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
	jmp _data__TensorData____init____bool_epilogue
_data__TensorData____init____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____getitem____class_3_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____getitem____class_3_bool_L0:
	movq 0(%rdi), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _list__list____getitem____class_3_bool_epilogue
_list__list____getitem____class_3_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____getitem____class_1_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____getitem____class_1_bool_L0:
	movq 0(%rdi), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _list__list____getitem____class_1_bool_epilogue
_list__list____getitem____class_1_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____add____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $400, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____add____bool_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -392(%rbp), %rcx
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
	movq $98, %rdi
	movb %dil, 120(%rcx)
	movq $111, %rdi
	movb %dil, 128(%rcx)
	movq $111, %rdi
	movb %dil, 136(%rcx)
	movq $108, %rdi
	movb %dil, 144(%rcx)
	movq $0, %rdi
	movb %dil, 152(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____add____bool_epilogue
_data__TensorData____add____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $400, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____sub____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $400, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____sub____bool_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -392(%rbp), %rcx
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
	movq $98, %rdi
	movb %dil, 120(%rcx)
	movq $111, %rdi
	movb %dil, 128(%rcx)
	movq $111, %rdi
	movb %dil, 136(%rcx)
	movq $108, %rdi
	movb %dil, 144(%rcx)
	movq $0, %rdi
	movb %dil, 152(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____sub____bool_epilogue
_data__TensorData____sub____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $400, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____mul____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $400, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____mul____bool_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -392(%rbp), %rcx
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
	movq $98, %rdi
	movb %dil, 120(%rcx)
	movq $111, %rdi
	movb %dil, 128(%rcx)
	movq $111, %rdi
	movb %dil, 136(%rcx)
	movq $108, %rdi
	movb %dil, 144(%rcx)
	movq $0, %rdi
	movb %dil, 152(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____mul____bool_epilogue
_data__TensorData____mul____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $400, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____truediv____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $400, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____truediv____bool_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r13), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r13), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -392(%rbp), %rcx
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
	movq $100, %rdi
	movb %dil, 80(%rcx)
	movq $105, %rdi
	movb %dil, 88(%rcx)
	movq $118, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $95, %rdi
	movb %dil, 112(%rcx)
	movq $98, %rdi
	movb %dil, 120(%rcx)
	movq $111, %rdi
	movb %dil, 128(%rcx)
	movq $111, %rdi
	movb %dil, 136(%rcx)
	movq $108, %rdi
	movb %dil, 144(%rcx)
	movq $0, %rdi
	movb %dil, 152(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____truediv____bool_epilogue
_data__TensorData____truediv____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $400, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData____matmul____bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $416, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData____matmul____bool_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movslq 8(%r13), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movslq 8(%r13), %rcx
	movslq 12(%r12), %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movl %esi, 8(%rdx)
	movq %rdi, 16(%rdx)
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq $1, %rdi
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
	movq %r13, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	movq %r12, 48(%rsi)
	movq $24, %rdi
	movq %rdi, 56(%rsi)
	movq %r9, 64(%rsi)
	leaq -416(%rbp), %rcx
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
	movq $97, %rdi
	movb %dil, 88(%rcx)
	movq $116, %rdi
	movb %dil, 96(%rcx)
	movq $109, %rdi
	movb %dil, 104(%rcx)
	movq $117, %rdi
	movb %dil, 112(%rcx)
	movq $108, %rdi
	movb %dil, 120(%rcx)
	movq $95, %rdi
	movb %dil, 128(%rcx)
	movq $95, %rdi
	movb %dil, 136(%rcx)
	movq $98, %rdi
	movb %dil, 144(%rcx)
	movq $111, %rdi
	movb %dil, 152(%rcx)
	movq $111, %rdi
	movb %dil, 160(%rcx)
	movq $108, %rdi
	movb %dil, 168(%rcx)
	movq $0, %rdi
	movb %dil, 176(%rcx)
	movq %rsi, %rdi
	movq $3, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData____matmul____bool_epilogue
_data__TensorData____matmul____bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $416, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__relu__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $336, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__relu__bool_L0:
	movq %rdi, %r12
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
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
	movq $1, %rdi
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
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	leaq -120(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -168(%rbp), %rsi
	movq %rbx, 0(%rsi)
	movq $24, %rdi
	movq %rdi, 8(%rsi)
	movq %r8, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	leaq -336(%rbp), %rcx
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
	movq $114, %rdi
	movb %dil, 80(%rcx)
	movq $101, %rdi
	movb %dil, 88(%rcx)
	movq $108, %rdi
	movb %dil, 96(%rcx)
	movq $117, %rdi
	movb %dil, 104(%rcx)
	movq $95, %rdi
	movb %dil, 112(%rcx)
	movq $95, %rdi
	movb %dil, 120(%rcx)
	movq $98, %rdi
	movb %dil, 128(%rcx)
	movq $111, %rdi
	movb %dil, 136(%rcx)
	movq $111, %rdi
	movb %dil, 144(%rcx)
	movq $108, %rdi
	movb %dil, 152(%rcx)
	movq $0, %rdi
	movb %dil, 160(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData__relu__bool_epilogue
_data__TensorData__relu__bool_epilogue:
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
_data__TensorData__exp__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $256, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__exp__bool_L0:
	movq %rdi, %r12
	movslq 8(%r12), %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movl %edx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq $0, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movq 0(%rbx), %rax
	movq 0(%r12), %r9
	movslq 8(%r12), %rsi
	movslq 12(%r12), %rdi
	movq %rsi, %rcx
	imulq %rdi, %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq 0(%rax), %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	movq 0(%r9), %rsi
	movq $8, %rdi
	movq %rsi, %rcx
	addq %rdi, %rcx
	leaq -88(%rbp), %rsi
	movq %rax, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r9, 24(%rsi)
	movq %rcx, 32(%rsi)
	movq $0, %rdi
	movq %rdi, 40(%rsi)
	leaq -248(%rbp), %rcx
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
	movq $101, %rdi
	movb %dil, 80(%rcx)
	movq $120, %rdi
	movb %dil, 88(%rcx)
	movq $112, %rdi
	movb %dil, 96(%rcx)
	movq $95, %rdi
	movb %dil, 104(%rcx)
	movq $95, %rdi
	movb %dil, 112(%rcx)
	movq $98, %rdi
	movb %dil, 120(%rcx)
	movq $111, %rdi
	movb %dil, 128(%rcx)
	movq $111, %rdi
	movb %dil, 136(%rcx)
	movq $108, %rdi
	movb %dil, 144(%rcx)
	movq $0, %rdi
	movb %dil, 152(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rax
	jmp _data__TensorData__exp__bool_epilogue
_data__TensorData__exp__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $256, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__sum__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $656, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__sum__bool_L0:
	movq %rdi, %r12
	movq $0, %rcx
	movq $0, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__sum__bool_L1
	jmp _data__TensorData__sum__bool_L2
_data__TensorData__sum__bool_L1:
	movq $1, %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movq %rdx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq %rcx, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 12(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq 0(%r9), %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -128(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	leaq -328(%rbp), %rcx
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
	movq $98, %rdi
	movb %dil, 160(%rcx)
	movq $111, %rdi
	movb %dil, 168(%rcx)
	movq $111, %rdi
	movb %dil, 176(%rcx)
	movq $108, %rdi
	movb %dil, 184(%rcx)
	movq $0, %rdi
	movb %dil, 192(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rdi
	jmp _data__TensorData__sum__bool_L3
_data__TensorData__sum__bool_L2:
	movslq 8(%r12), %rdx
	movq $1, %rsi
	leaq -344(%rbp), %rdi
	movl %edx, 0(%rdi)
	movq %rsi, 8(%rdi)
	movq %rcx, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 8(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -368(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq 0(%r9), %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -384(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	leaq -408(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -456(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	leaq -656(%rbp), %rcx
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
	movq $98, %rdi
	movb %dil, 160(%rcx)
	movq $111, %rdi
	movb %dil, 168(%rcx)
	movq $111, %rdi
	movb %dil, 176(%rcx)
	movq $108, %rdi
	movb %dil, 184(%rcx)
	movq $0, %rdi
	movb %dil, 192(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rdi
	jmp _data__TensorData__sum__bool_L3
_data__TensorData__sum__bool_L3:
	movq %rdi, %rax
	jmp _data__TensorData__sum__bool_epilogue
_data__TensorData__sum__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $656, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__max__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $656, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__max__bool_L0:
	movq %rdi, %r12
	movq $0, %rcx
	movq $0, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__max__bool_L1
	jmp _data__TensorData__max__bool_L2
_data__TensorData__max__bool_L1:
	movq $1, %rdx
	movslq 12(%r12), %rsi
	leaq -16(%rbp), %rdi
	movq %rdx, 0(%rdi)
	movl %esi, 8(%rdi)
	movq %rcx, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 12(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -40(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq 0(%r9), %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -56(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	leaq -80(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -128(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	leaq -328(%rbp), %rcx
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
	movq $97, %rdi
	movb %dil, 88(%rcx)
	movq $120, %rdi
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
	movq $98, %rdi
	movb %dil, 160(%rcx)
	movq $111, %rdi
	movb %dil, 168(%rcx)
	movq $111, %rdi
	movb %dil, 176(%rcx)
	movq $108, %rdi
	movb %dil, 184(%rcx)
	movq $0, %rdi
	movb %dil, 192(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rdi
	jmp _data__TensorData__max__bool_L3
_data__TensorData__max__bool_L2:
	movslq 8(%r12), %rdx
	movq $1, %rsi
	leaq -344(%rbp), %rdi
	movl %edx, 0(%rdi)
	movq %rsi, 8(%rdi)
	movq %rcx, %rsi
	callq _data__TensorData__fill__bool
	movq %rax, %rbx
	movq 0(%rbx), %r9
	movslq 8(%r12), %rcx
	movq $1, %rsi
	movq $1, %rdi
	leaq -368(%rbp), %rdx
	movl %ecx, 0(%rdx)
	movq %rsi, 8(%rdx)
	movq %rdi, 16(%rdx)
	movq 0(%r9), %rsi
	movq $8, %rdi
	movq %rsi, %r8
	addq %rdi, %r8
	leaq -384(%rbp), %rsi
	movq $0, %rdi
	movq %rdi, 0(%rsi)
	movq $1, %rdi
	movq %rdi, 8(%rsi)
	leaq -408(%rbp), %rcx
	movq $24, %rdi
	movq %rdi, 0(%rcx)
	movq $1, %rdi
	movq %rdi, 8(%rcx)
	movq %rsi, 16(%rcx)
	leaq -456(%rbp), %rsi
	movq %r9, 0(%rsi)
	movq %r8, 8(%rsi)
	movq $0, %rdi
	movq %rdi, 16(%rsi)
	movq %r12, 24(%rsi)
	movq $24, %rdi
	movq %rdi, 32(%rsi)
	movq %rcx, 40(%rsi)
	leaq -656(%rbp), %rcx
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
	movq $97, %rdi
	movb %dil, 88(%rcx)
	movq $120, %rdi
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
	movq $98, %rdi
	movb %dil, 160(%rcx)
	movq $111, %rdi
	movb %dil, 168(%rcx)
	movq $111, %rdi
	movb %dil, 176(%rcx)
	movq $108, %rdi
	movb %dil, 184(%rcx)
	movq $0, %rdi
	movb %dil, 192(%rcx)
	movq %rsi, %rdi
	movq $2, %rsi
	callq gpu_launch
	movq %rbx, %rdi
	jmp _data__TensorData__max__bool_L3
_data__TensorData__max__bool_L3:
	movq %rdi, %rax
	jmp _data__TensorData__max__bool_epilogue
_data__TensorData__max__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	addq $656, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__broadcast_to__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__broadcast_to__bool_L0:
	movq %rdi, %r10
	movq $0, %rdi
	movslq (%rdi,%rsi), %r9
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdx
	movslq 8(%r10), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rsi
	movq $1, %rdi
	cmpq %rdi, %r9
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rsi
	movq %rdi, %r11
movq $0, %rsi
	cmovne %r11, %rsi
	movslq 16(%r10), %rdi
	cmpq $0, %rsi
movq $0, %r11
	movq %rdi, %rcx
	cmovne %r11, %rcx
	movslq 12(%r10), %rsi
	movq $1, %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rsi
	movq $1, %rdi
	cmpq %rdi, %rdx
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rsi
	movq %rdi, %r11
movq $0, %rsi
	cmovne %r11, %rsi
	movslq 20(%r10), %rdi
	cmpq $0, %rsi
movq $0, %r11
	movq %rdi, %r8
	cmovne %r11, %r8
	movq 0(%r10), %rdi
	movq %r9, %rsi
	callq _data__TensorData___view__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _data__TensorData__broadcast_to__bool_epilogue
_data__TensorData__broadcast_to__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__transpose__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__transpose__bool_L0:
	movq %rdi, %r8
	movq 0(%r8), %rdi
	movslq 12(%r8), %rsi
	movslq 8(%r8), %rdx
	movslq 20(%r8), %rcx
	movslq 16(%r8), %r8
	callq _data__TensorData___view__bool
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _data__TensorData__transpose__bool_epilogue
_data__TensorData__transpose__bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData___view__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData___view__f32_L0:
	movq %rdi, %r15
	movq %rdx, %rdi
	movq %rcx, %r14
	movq %r8, %r13
	leaq -16(%rbp), %r12
	movl %esi, 0(%r12)
	movl %edi, 8(%r12)
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r15, %rsi
	movq %r12, %rdx
	callq _data__TensorData____init____f32
	movl %r14d, 16(%rbx)
	movl %r13d, 20(%rbx)
	movq %rbx, %rax
	jmp _data__TensorData___view__f32_epilogue
_data__TensorData___view__f32_epilogue:
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
_data__TensorData___view__bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData___view__bool_L0:
	movq %rdi, %r15
	movq %rdx, %rdi
	movq %rcx, %r14
	movq %r8, %r13
	leaq -16(%rbp), %r12
	movl %esi, 0(%r12)
	movl %edi, 8(%r12)
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r15, %rsi
	movq %r12, %rdx
	callq _data__TensorData____init____bool
	movl %r14d, 16(%rbx)
	movl %r13d, 20(%rbx)
	movq %rbx, %rax
	jmp _data__TensorData___view__bool_epilogue
_data__TensorData___view__bool_epilogue:
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
