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
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $6, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $108, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $5, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $114, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq $18, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $10, %rdi
	movq %rdi, 0(%r13)
	movq $8, %rsi
	movq $112, %rdi
	movb %dil, (%r13,%rsi)
	movq $9, %rsi
	movq $105, %rdi
	movb %dil, (%r13,%rsi)
	movq $10, %rsi
	movq $110, %rdi
	movb %dil, (%r13,%rsi)
	movq $11, %rsi
	movq $101, %rdi
	movb %dil, (%r13,%rsi)
	movq $12, %rsi
	movq $97, %rdi
	movb %dil, (%r13,%rsi)
	movq $13, %rsi
	movq $112, %rdi
	movb %dil, (%r13,%rsi)
	movq $14, %rsi
	movq $112, %rdi
	movb %dil, (%r13,%rsi)
	movq $15, %rsi
	movq $108, %rdi
	movb %dil, (%r13,%rsi)
	movq $16, %rsi
	movq $101, %rdi
	movb %dil, (%r13,%rsi)
	movq $17, %rsi
	movq $0, %rdi
	movb %dil, (%r13,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r13, %rsi
	callq _str__str____init__
	movq $32, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $3, %rdi
	movq %rdi, 0(%r13)
	movq %r14, %rsi
	movq $8, %rdi
	movq %rsi, (%r13,%rdi)
	movq %r12, %rsi
	movq $16, %rdi
	movq %rsi, (%r13,%rdi)
	movq $24, %rdi
	movq %rbx, (%r13,%rdi)
	movq $32, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $3, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $3, %rdi
	movq %rdi, (%rbx,%rsi)
	movq $16, %rsi
	movq $4, %rdi
	movq %rdi, (%rbx,%rsi)
	movq $24, %rsi
	movq $1, %rdi
	movq %rdi, (%rbx,%rsi)
	movq $28, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r13, %rsi
	movq %rbx, %rdx
	callq _dict__dict____init____class_9_i64
	movq $18, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $10, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $105, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $110, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $13, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $14, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $15, %rsi
	movq $108, %rdi
	movb %dil, (%rbx,%rsi)
	movq $16, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $17, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _dict__dict____getitem____class_9_i64
	movq %rax, %r13
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r13, %rdi
	movq %r14, %rsi
	callq _print__print_int
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $5, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $114, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _dict__dict____getitem____class_9_i64
	movq %rax, %r13
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r13, %rdi
	movq %r14, %rsi
	callq _print__print_int
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $6, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $108, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _dict__dict____getitem____class_9_i64
	movq %rax, %r13
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r13, %rdi
	movq %r14, %rsi
	callq _print__print_int
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $5, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $107, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $105, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $119, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $105, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _dict__dict____contains____class_9_i64
	movq %rax, %r13
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r13, %rdi
	movq %r14, %rsi
	callq _print__print_bool
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $6, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $112, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $108, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _dict__dict____contains____class_9_i64
	movq %rax, %r12
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _print__print_bool
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
	subq $32, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_concat__string_concat_L0:
	movq %rdi, %r12
	movq %rsi, %r13
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____char
	movq %r12, %rdi
	callq _str__str____len__
	movq %rax, %rbx
	movq %r13, %rdi
	callq _str__str____len__
	movq %rax, %rdi
	movq %rbx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	subq %rdi, %rsi
	movq %r14, %rdi
	callq _list__list____mul____char
	movq %rax, %rbx
	movq %r12, %rdi
	callq _str__str____len__
	movq %rax, %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq $0, %rsi
	movq $0, %r8
	jmp _concat__string_concat_L1
_concat__string_concat_L1:
	cmpq %rdx, %r8
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L2
	jmp _concat__string_concat_L3
_concat__string_concat_L2:
	movq %rsi, %r9
	addq %r8, %r9
	movq 0(%r12), %rcx
	movq $8, %rdi
	addq %r9, %rdi
	movzbq (%rdi,%rcx), %r10
	movq 0(%rbx), %rcx
	movq $8, %rdi
	addq %r9, %rdi
	movb %r10b, (%rcx,%rdi)
	movq $1, %rdi
	addq %rdi, %r8
	jmp _concat__string_concat_L1
_concat__string_concat_L3:
	movq %r13, %rdi
	callq _str__str____len__
	movq %rax, %rsi
	movq $0, %rdi
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	movq %r13, %rdi
	movq %rdi, -24(%rbp)
	movq %r12, %r13
	movq %rbx, %r12
	movq $0, %rbx
	jmp _concat__string_concat_L4
_concat__string_concat_L4:
	movq -16(%rbp), %rdi
	cmpq %rdi, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L5
	jmp _concat__string_concat_L6
_concat__string_concat_L5:
	movq -8(%rbp), %rdi
	movq %rdi, %r14
	addq %rbx, %r14
	movq -24(%rbp), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %r14, %rdi
	movzbq (%rdi,%rsi), %r15
	movq %r13, %rdi
	callq _str__str____len__
	movq %rax, %rdi
	movq %r14, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq 0(%r12), %rsi
	movq $8, %rdi
	addq %rdx, %rdi
	movb %r15b, (%rsi,%rdi)
	movq $1, %rdi
	addq %rdi, %rbx
	jmp _concat__string_concat_L4
_concat__string_concat_L6:
	movq %r12, %rax
	jmp _concat__string_concat_epilogue
_concat__string_concat_epilogue:
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
_print___print_int_helper:
	pushq %rbp
	movq %rsp, %rbp
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
	addq %rdi, %rbx
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, 0(%rsi)
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
	movq %rdi, %r13
	movq %rsi, %r12
	movq $0, %rdi
	cmpq %rdi, %r13
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L1
	jmp _print__print_int_L2
_print__print_int_L1:
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $45, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r14, %rdi
	movq $1, %rsi
	movq $1, %rdx
	callq _str__str____write__
	 movq %r13, %r13
	negq %r13
	jmp _print__print_int_L3
_print__print_int_L2:
	jmp _print__print_int_L3
_print__print_int_L3:
	movq %r13, %rdi
	callq _print___print_int_helper
	movq %r12, %rdi
	callq _str__str____len__
	movq %rax, %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L4
	jmp _print__print_int_L5
_print__print_int_L4:
	movq %r12, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %r12, %rdi
	movq $1, %rsi
	callq _str__str____write__
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
	movq %rdi, %r14
	movq %rsi, %r13
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
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $6, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $70, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $97, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $108, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $115, %rdi
	movb %dil, (%rbx,%rsi)
	movq $12, %rsi
	movq $101, %rdi
	movb %dil, (%rbx,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r15, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	cmpq $0, %r14
	movq %r12, %r11
	movq %r15, %rdi
	cmovne %r11, %rdi
	cmpq $0, %r14
movq $4, %r11
movq $5, %rdx
	cmovne %r11, %rdx
	movq $1, %rsi
	callq _str__str____write__
	movq %r13, %rdi
	callq _str__str____len__
	movq %rax, %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_bool_L1
	jmp _print__print_bool_L2
_print__print_bool_L1:
	movq %r13, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %r13, %rdi
	movq $1, %rsi
	callq _str__str____write__
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
	movq %rdi, %r12
	movq %rsi, %rbx
	movq %r12, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %r12, %rdi
	movq $1, %rsi
	callq _str__str____write__
	movq %rbx, %rdi
	callq _str__str____len__
	movq %rax, %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_string_L1
	jmp _print__print_string_L2
_print__print_string_L1:
	movq %rbx, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %rbx, %rdi
	movq $1, %rsi
	callq _str__str____write__
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
	subq $32, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_int_array_L0:
	movq %rdi, %r13
	movq %rsi, %r12
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $91, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $1, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r15, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r14, %rdi
	movq %r15, %rsi
	callq _print__print_string
	movslq 0(%r13), %rsi
	movq $0, %rdi
	movq %rdi, -16(%rbp)
	movq %rsi, -24(%rbp)
	movq %r12, -8(%rbp)
	movq %r13, -32(%rbp)
	movq $0, %rbx
	jmp _print__print_int_array_L1
_print__print_int_array_L1:
	movq -24(%rbp), %rdi
	cmpq %rdi, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_array_L2
	jmp _print__print_int_array_L3
_print__print_int_array_L2:
	movq -16(%rbp), %rdi
	movq %rdi, %r12
	addq %rbx, %r12
	movq $8, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rdi, %rsi
	movq -32(%rbp), %rdi
	movq (%rsi,%rdi), %r14
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $1, %rdi
	movq %rdi, 0(%r13)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%r13,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r15, %rdi
	movq %r13, %rsi
	callq _str__str____init__
	movq %r14, %rdi
	movq %r15, %rsi
	callq _print__print_int
	movq -32(%rbp), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	cmpq %rdi, %r12
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_array_L4
	jmp _print__print_int_array_L5
_print__print_int_array_L3:
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $93, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq -8(%rbp), %rsi
	callq _print__print_string
	jmp _print__print_int_array_epilogue
_print__print_int_array_L4:
	movq $11, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $3, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rsi
	movq $44, %rdi
	movb %dil, (%r12,%rsi)
	movq $9, %rsi
	movq $32, %rdi
	movb %dil, (%r12,%rsi)
	movq $10, %rsi
	movq $0, %rdi
	movb %dil, (%r12,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %r12, %rsi
	callq _str__str____init__
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $1, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%r12,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %r12, %rsi
	callq _str__str____init__
	movq %r13, %rdi
	movq %r14, %rsi
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
	addq $32, %rsp
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
	movq %rsi, %r13
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
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $45, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq $1, %rsi
	movq $1, %rdx
	callq _str__str____write__
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
	cvttsd2siq %xmm0, %r12
	movq %r12, %rdi
	callq _print___print_int_helper
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $2, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $46, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $0, %rdi
	movb %dil, (%rbx,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r14, %rdi
	movq $1, %rsi
	movq $1, %rdx
	callq _str__str____write__
	cvtsi2sdq %r12, %xmm1
	movq -24(%rbp), %xmm0
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
	movq $0, %rdi
	movq $5, %r14
	movq %r13, %rbx
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
	cvttsd2siq %xmm0, %r12
	movq %r12, %rdi
	callq _print___print_int_helper
	cvtsi2sdq %r12, %xmm1
	movq -8(%rbp), %xmm0
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
	movq $1, %rdi
	addq %rdi, %r13
	jmp _print__print_float_L4
_print__print_float_L6:
	movq %rbx, %rdi
	callq _str__str____len__
	movq %rax, %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L7
	jmp _print__print_float_L8
_print__print_float_L7:
	movq %rbx, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %rbx, %rdi
	movq $1, %rsi
	callq _str__str____write__
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
_str__str____init__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____init___L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	jmp _str__str____init___epilogue
_str__str____init___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____getitem__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____getitem___L0:
	movq %rsi, %rdx
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %rdx, %rdi
	movzbq (%rdi,%rsi), %rdi
	movq %rdi, %rax
	jmp _str__str____getitem___epilogue
_str__str____getitem___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____setitem__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____setitem___L0:
	movq %rsi, %rcx
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %rcx, %rdi
	movb %dl, (%rsi,%rdi)
	jmp _str__str____setitem___epilogue
_str__str____setitem___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____len__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____len___L0:
	movq 0(%rdi), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq %rdi, %rax
	jmp _str__str____len___epilogue
_str__str____len___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____eq__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____eq___L0:
	movq %rdi, %r8
	movq %rsi, %r9
	movq 0(%r8), %rdi
	movslq 0(%rdi), %rsi
	movq 0(%r9), %rdi
	movslq 0(%rdi), %rdi
	cmpq %rdi, %rsi
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____eq___L1
	jmp _str__str____eq___L2
_str__str____eq___L1:
	movq $0, %rax
	jmp _str__str____eq___epilogue
	jmp _str__str____eq___L3
_str__str____eq___L2:
	jmp _str__str____eq___L3
_str__str____eq___L3:
	movq 0(%r8), %rdi
	movslq 0(%rdi), %rcx
	movq $0, %rdx
	movq $0, %rsi
	jmp _str__str____eq___L4
_str__str____eq___L4:
	cmpq %rcx, %rsi
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____eq___L5
	jmp _str__str____eq___L6
_str__str____eq___L5:
	movq %rdx, %rbx
	addq %rsi, %rbx
	movq 0(%r8), %rax
	movq $8, %rdi
	addq %rbx, %rdi
	movzbq (%rdi,%rax), %r10
	movq 0(%r9), %rax
	movq $8, %rdi
	addq %rbx, %rdi
	movzbq (%rdi,%rax), %rdi
	cmpq %rdi, %r10
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____eq___L7
	jmp _str__str____eq___L8
_str__str____eq___L6:
	movq $1, %rax
	jmp _str__str____eq___epilogue
_str__str____eq___L7:
	movq $0, %rax
	jmp _str__str____eq___epilogue
	jmp _str__str____eq___L9
_str__str____eq___L8:
	jmp _str__str____eq___L9
_str__str____eq___L9:
	movq $1, %rdi
	addq %rdi, %rsi
	jmp _str__str____eq___L4
_str__str____eq___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____hash__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____hash___L0:
	movq %rdi, %rax
	movq 0(%rax), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %r9
	subq %rdi, %r9
	movq $0, %r8
	movq $0, %rsi
	movq $0, %rcx
	jmp _str__str____hash___L1
_str__str____hash___L1:
	cmpq %r9, %rcx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____hash___L2
	jmp _str__str____hash___L3
_str__str____hash___L2:
	movq %r8, %r10
	addq %rcx, %r10
	movq $31, %rdi
	movq %rsi, %rdx
	imulq %rdi, %rdx
	movq 0(%rax), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movzbq (%rdi,%rsi), %rdi
	movzbq %dil, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $2147483647, %rdi
	pushq %rax
	pushq %rdx
	movq %rdi, %r11
	movq %rsi, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rsi
	movq $1, %rdi
	addq %rdi, %rcx
	jmp _str__str____hash___L1
_str__str____hash___L3:
	movq %rsi, %rax
	jmp _str__str____hash___epilogue
_str__str____hash___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____write__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____write___L0:
	movq %rsi, %rcx
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %rdi, %rsi
	movq %rcx, %rdi
	callq write
	jmp _str__str____write___epilogue
_str__str____write___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____print__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____print___L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movq %r12, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %r12, %rdi
	movq $1, %rsi
	callq _str__str____write__
	movq %rbx, %rdi
	callq _str__str____len__
	movq %rax, %rdx
	movq %rbx, %rdi
	movq $1, %rsi
	callq _str__str____write__
	jmp _str__str____print___epilogue
_str__str____print___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_str__str____add__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____add___L0:
	movq %rdi, %r15
	movq %rsi, %r14
	movq %r15, %rdi
	callq _str__str____len__
	movq %rax, %r13
	movq %r14, %rdi
	callq _str__str____len__
	movq %rax, %r12
	movq %r13, %rsi
	addq %r12, %rsi
	movq $1, %rdi
	movq %rsi, %rbx
	addq %rdi, %rbx
	movq $8, %rdi
	addq %rbx, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %rbx, 0(%rdi)
	movq $0, %r8
	movq %r13, %rcx
	movq %rdi, %rdx
	movq %r14, %rsi
	movq %r15, %r10
	movq %r13, %r9
	movq $0, %rbx
	jmp _str__str____add___L1
_str__str____add___L1:
	cmpq %rcx, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____add___L2
	jmp _str__str____add___L3
_str__str____add___L2:
	movq %r8, %r13
	addq %rbx, %r13
	movq 0(%r10), %r14
	movq $8, %rdi
	addq %r13, %rdi
	movzbq (%rdi,%r14), %r14
	movq $8, %rdi
	addq %r13, %rdi
	movb %r14b, (%rdx,%rdi)
	movq $1, %rdi
	addq %rdi, %rbx
	jmp _str__str____add___L1
_str__str____add___L3:
	movq $0, %r8
	movq %r12, %rcx
	movq %rdx, %rbx
	movq %rsi, %rdx
	movq %r12, %r10
	movq $0, %r12
	jmp _str__str____add___L4
_str__str____add___L4:
	cmpq %rcx, %r12
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____add___L5
	jmp _str__str____add___L6
_str__str____add___L5:
	movq %r8, %r14
	addq %r12, %r14
	movq 0(%rdx), %rsi
	movq $8, %rdi
	addq %r14, %rdi
	movzbq (%rdi,%rsi), %r13
	movq %r9, %rsi
	addq %r14, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movb %r13b, (%rbx,%rdi)
	movq $1, %rdi
	addq %rdi, %r12
	jmp _str__str____add___L4
_str__str____add___L6:
	movq $0, %rdx
	movq %r9, %rsi
	addq %r10, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movb %dl, (%rbx,%rdi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rax
	jmp _str__str____add___epilogue
_str__str____add___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_dict__dict____init____class_9_i64:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict____init____class_9_i64_L0:
	movq %rdi, %r14
	movq %rsi, %r13
	movq %rdx, %r12
	movslq 0(%r13), %rsi
	movq $2, %rdi
	imulq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %rbx
	addq %rdi, %rbx
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 0(%r14)
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 8(%r14)
	movq $8, %rdi
	addq %rbx, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 16(%r14)
	movq $0, %rdi
	movl %edi, 24(%r14)
	movq $0, %rax
	movq %rbx, %r9
	movq %r13, %r8
	movq %r14, %rcx
	movq %r12, %rdx
	movq %rbx, %rdi
	movq $0, %r12
	jmp _dict__dict____init____class_9_i64_L1
_dict__dict____init____class_9_i64_L1:
	cmpq %r9, %r12
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict____init____class_9_i64_L2
	jmp _dict__dict____init____class_9_i64_L3
_dict__dict____init____class_9_i64_L2:
	movq %rax, %rbx
	addq %r12, %rbx
	movq $0, %r10
	movq 16(%rcx), %rsi
	movq $8, %rdi
	addq %rbx, %rdi
	movb %r10b, (%rsi,%rdi)
	movq $1, %rdi
	addq %rdi, %r12
	jmp _dict__dict____init____class_9_i64_L1
_dict__dict____init____class_9_i64_L3:
	movslq 0(%r8), %rsi
	movq $0, %rdi
	movq %rdi, -8(%rbp)
	movq %rsi, %r15
	movq %r8, %r14
	movq %rcx, %r13
	movq %rdx, %r12
	movq $0, %rbx
	jmp _dict__dict____init____class_9_i64_L4
_dict__dict____init____class_9_i64_L4:
	cmpq %r15, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict____init____class_9_i64_L5
	jmp _dict__dict____init____class_9_i64_L6
_dict__dict____init____class_9_i64_L5:
	movq -8(%rbp), %rdi
	movq %rdi, %rcx
	addq %rbx, %rcx
	movq $8, %rdi
	movq %rcx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r12), %rdx
	movq $8, %rdi
	movq %rcx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r14), %rsi
	movq %r13, %rdi
	callq _dict__dict____setitem____class_9_i64
	movq $1, %rdi
	addq %rbx, %rdi
	movq %rdi, %rbx
	jmp _dict__dict____init____class_9_i64_L4
_dict__dict____init____class_9_i64_L6:
	jmp _dict__dict____init____class_9_i64_epilogue
_dict__dict____init____class_9_i64_epilogue:
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
_dict__dict____getitem____class_9_i64:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict____getitem____class_9_i64_L0:
	movq %rdi, %rbx
	movq %rbx, %rdi
	callq _dict__dict___get__class_9_i64
	movq %rax, %rsi
	movq 8(%rbx), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _dict__dict____getitem____class_9_i64_epilogue
_dict__dict____getitem____class_9_i64_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____init____char:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____init____char_L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	movslq 0(%rdi), %rdi
	movl %edi, 8(%rdx)
	jmp _list__list____init____char_epilogue
_list__list____init____char_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____setitem____char:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____setitem____char_L0:
	movq %rsi, %rcx
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %rcx, %rdi
	movb %dl, (%rsi,%rdi)
	jmp _list__list____setitem____char_epilogue
_list__list____setitem____char_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_dict__dict____setitem____class_9_i64:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict____setitem____class_9_i64_L0:
	movq %rdi, %rbx
	movq %rsi, %r13
	movq %rdx, %r12
	movslq 24(%rbx), %rsi
	movq $1, %rdi
	addq %rdi, %rsi
	movq $10, %rdi
	movq %rsi, %rdx
	imulq %rdi, %rdx
	movq 8(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $7, %rdi
	imulq %rsi, %rdi
	cmpq %rdi, %rdx
	setge %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict____setitem____class_9_i64_L1
	jmp _dict__dict____setitem____class_9_i64_L2
_dict__dict____setitem____class_9_i64_L1:
	movq %rbx, %rdi
	callq _dict__dict___grow__class_9_i64
	jmp _dict__dict____setitem____class_9_i64_L3
_dict__dict____setitem____class_9_i64_L2:
	jmp _dict__dict____setitem____class_9_i64_L3
_dict__dict____setitem____class_9_i64_L3:
	movq %rbx, %rdi
	movq %r13, %rsi
	callq _dict__dict___get__class_9_i64
	movq %rax, %rdx
	movq 0(%rbx), %rcx
	movq $8, %rdi
	movq %rdx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %r13, (%rcx,%rdi)
	movq 8(%rbx), %rcx
	movq $8, %rdi
	movq %rdx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %r12, (%rcx,%rdi)
	movq $1, %rcx
	movq 16(%rbx), %rsi
	movq $8, %rdi
	addq %rdx, %rdi
	movb %cl, (%rsi,%rdi)
	movslq 24(%rbx), %rsi
	movq $1, %rdi
	addq %rsi, %rdi
	movl %edi, 24(%rbx)
	jmp _dict__dict____setitem____class_9_i64_epilogue
_dict__dict____setitem____class_9_i64_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_dict__dict___get__class_9_i64:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict___get__class_9_i64_L0:
	movq %rdi, %r12
	movq %rsi, %r13
	movq 8(%r12), %rdi
	movslq 0(%rdi), %rbx
	movq %r13, %rdi
	callq _str__str____hash__
	movq %rax, %rdi
	pushq %rax
	pushq %rdx
	movq %rbx, %r11
	movq %rdi, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rdi
	movq %r13, %r14
	movq %r12, %r13
	movq %rbx, %r12
	movq %rdi, %rbx
	jmp _dict__dict___get__class_9_i64_L1
_dict__dict___get__class_9_i64_L1:
	movq 16(%r13), %rsi
	movq $8, %rdi
	addq %rbx, %rdi
	movzbq (%rdi,%rsi), %rdi
	cmpq $0, %rdi
	jne _dict__dict___get__class_9_i64_L2
	jmp _dict__dict___get__class_9_i64_L3
_dict__dict___get__class_9_i64_L2:
	movq 0(%r13), %rdx
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %r14, %rsi
	callq _str__str____eq__
	movq %rax, %rdi
	cmpq $0, %rdi
	jne _dict__dict___get__class_9_i64_L4
	jmp _dict__dict___get__class_9_i64_L5
_dict__dict___get__class_9_i64_L3:
	movq %rbx, %rax
	jmp _dict__dict___get__class_9_i64_epilogue
_dict__dict___get__class_9_i64_L4:
	movq %rbx, %rax
	jmp _dict__dict___get__class_9_i64_epilogue
	jmp _dict__dict___get__class_9_i64_L6
_dict__dict___get__class_9_i64_L5:
	jmp _dict__dict___get__class_9_i64_L6
_dict__dict___get__class_9_i64_L6:
	movq $1, %rdi
	addq %rbx, %rdi
	pushq %rax
	pushq %rdx
	movq %r12, %r11
	movq %rdi, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rbx
	jmp _dict__dict___get__class_9_i64_L1
_dict__dict___get__class_9_i64_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_dict__dict___grow__class_9_i64:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict___grow__class_9_i64_L0:
	movq %rdi, %r14
	movq 0(%r14), %r13
	movq 8(%r14), %r12
	movq 16(%r14), %rdi
	movq %rdi, -8(%rbp)
	movslq 0(%r13), %r15
	movq $2, %rdi
	movq %r15, %rsi
	imulq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %rbx
	addq %rdi, %rbx
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 0(%r14)
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 8(%r14)
	movq $8, %rdi
	addq %rbx, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %rbx, %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 16(%r14)
	movq $0, %rdi
	movq %rdi, 24(%r14)
	movq $0, %r9
	movq %rbx, %r8
	movq %rbx, %rdi
	movq %r15, %rax
	movq %r13, %r10
	movq %r14, %rcx
	movq %r12, %rdx
	movq -8(%rbp), %rsi
	movq $0, %r13
	jmp _dict__dict___grow__class_9_i64_L1
_dict__dict___grow__class_9_i64_L1:
	cmpq %r8, %r13
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict___grow__class_9_i64_L2
	jmp _dict__dict___grow__class_9_i64_L3
_dict__dict___grow__class_9_i64_L2:
	movq %r9, %r14
	addq %r13, %r14
	movq $0, %r12
	movq 16(%rcx), %rbx
	movq $8, %rdi
	addq %r14, %rdi
	movb %r12b, (%rbx,%rdi)
	movq $1, %rdi
	addq %rdi, %r13
	jmp _dict__dict___grow__class_9_i64_L1
_dict__dict___grow__class_9_i64_L3:
	movq $0, %rdi
	movq %rdi, -16(%rbp)
	movq %rax, -24(%rbp)
	movq %r10, %r15
	movq %rcx, %r14
	movq %rdx, %r13
	movq %rsi, %r12
	movq $0, %rbx
	jmp _dict__dict___grow__class_9_i64_L4
_dict__dict___grow__class_9_i64_L4:
	movq -24(%rbp), %rdi
	cmpq %rdi, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict___grow__class_9_i64_L5
	jmp _dict__dict___grow__class_9_i64_L6
_dict__dict___grow__class_9_i64_L5:
	movq -16(%rbp), %rdi
	movq %rdi, %rdx
	addq %rbx, %rdx
	movq $8, %rdi
	addq %rdx, %rdi
	movzbq (%rdi,%r12), %rdi
	cmpq $0, %rdi
	jne _dict__dict___grow__class_9_i64_L7
	jmp _dict__dict___grow__class_9_i64_L8
_dict__dict___grow__class_9_i64_L6:
	jmp _dict__dict___grow__class_9_i64_epilogue
_dict__dict___grow__class_9_i64_L7:
	movq $8, %rdi
	movq %rdx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r13), %rcx
	movq $8, %rdi
	movq %rdx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r15), %rsi
	movq %r14, %rdi
	movq %rcx, %rdx
	callq _dict__dict____setitem____class_9_i64
	jmp _dict__dict___grow__class_9_i64_L9
_dict__dict___grow__class_9_i64_L8:
	jmp _dict__dict___grow__class_9_i64_L9
_dict__dict___grow__class_9_i64_L9:
	movq $1, %rdi
	addq %rbx, %rdi
	movq %rdi, %rbx
	jmp _dict__dict___grow__class_9_i64_L4
_dict__dict___grow__class_9_i64_epilogue:
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
_dict__dict____contains____class_9_i64:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict____contains____class_9_i64_L0:
	movq %rdi, %rbx
	movq %rbx, %rdi
	callq _dict__dict___get__class_9_i64
	movq %rax, %rdx
	movq 16(%rbx), %rsi
	movq $8, %rdi
	addq %rdx, %rdi
	movzbq (%rdi,%rsi), %rdi
	movq %rdi, %rax
	jmp _dict__dict____contains____class_9_i64_epilogue
_dict__dict____contains____class_9_i64_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____mul____char:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____mul____char_L0:
	movq %rdi, %rbx
	movq %rsi, %r12
	movslq 8(%rbx), %rdi
	movq %rdi, %r13
	imulq %r12, %r13
	movq $8, %rdi
	addq %r13, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq %r13, 0(%rsi)
	movslq 8(%rbx), %rdi
	movq %rdi, %r9
	imulq %r12, %r9
	movq $0, %r8
	movq %rbx, %rcx
	movq %rsi, %rbx
	movq $0, %rdx
	jmp _list__list____mul____char_L1
_list__list____mul____char_L1:
	cmpq %r9, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list____mul____char_L2
	jmp _list__list____mul____char_L3
_list__list____mul____char_L2:
	movq %r8, %r10
	addq %rdx, %r10
	movq 0(%rcx), %r12
	movslq 8(%rcx), %rdi
	pushq %rax
	pushq %rdx
	movq %rdi, %r11
	movq %r10, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movzbq (%rdi,%r12), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movb %sil, (%rbx,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _list__list____mul____char_L1
_list__list____mul____char_L3:
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %rbx, %rsi
	callq _list__list____init____char
	movq %r12, %rax
	jmp _list__list____mul____char_epilogue
_list__list____mul____char_epilogue:
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
