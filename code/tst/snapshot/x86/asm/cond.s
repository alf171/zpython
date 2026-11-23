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
	movq $5, %r14
	movq $10, %r13
	cmpq %r13, %r14
	setl %r11b
	movzbq %r11b, %r12
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
	movq %rax, %r15
	movq %r15, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r15, %rsi
	callq _print__print_bool
	cmpq %r13, %r14
	sete %r11b
	movzbq %r11b, %r12
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
	movq %rax, %r15
	movq %r15, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r15, %rsi
	callq _print__print_bool
	cmpq %r13, %r14
	setne %r11b
	movzbq %r11b, %r12
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
	movq $0, %rax
	jmp main_epilogue
main_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_uop__Uop___visit:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_uop__Uop___visit_L0:
	movq %rdi, %r15
	movq %rsi, %r14
	movq %rdx, %r13
	movq %r14, %rdi
	movq %r15, %rsi
	callq _dict__dict____contains____class_1_bool
	movq %rax, %rdi
	cmpq $0, %rdi
	jne _uop__Uop___visit_L1
	jmp _uop__Uop___visit_L2
_uop__Uop___visit_L1:
	jmp _uop__Uop___visit_epilogue
_uop__Uop___visit_L2:
	jmp _uop__Uop___visit_L3
_uop__Uop___visit_L3:
	movq 0(%r15), %r12
	movslq 8(%r12), %rdi
	movq %rdi, -8(%rbp)
	movq $0, %rbx
	jmp _uop__Uop___visit_L4
_uop__Uop___visit_L4:
	movq -8(%rbp), %rdi
	cmpq %rdi, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _uop__Uop___visit_L5
	jmp _uop__Uop___visit_L6
_uop__Uop___visit_L5:
	movq 0(%r12), %rdx
	movq $8, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %r14, %rsi
	movq %r13, %rdx
	callq _uop__Uop___visit
	movq $1, %rdi
	addq %rdi, %rbx
	jmp _uop__Uop___visit_L4
_uop__Uop___visit_L6:
	movq %r14, %rdi
	movq %r15, %rsi
	movq $1, %rdx
	callq _dict__dict____setitem____class_1_bool
	movq %r13, %rdi
	movq %r15, %rsi
	callq _list__list__append__class_1
	jmp _uop__Uop___visit_epilogue
_uop__Uop___visit_epilogue:
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
_tensor__Tensor__randn:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor__randn_L0:
	callq _data__TensorData__randn
	movq %rax, %rdi
	callq _uop__Uop__from_data__f32
	movq %rax, %rdi
	callq _tensor__Tensor___init__f32
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _tensor__Tensor__randn_epilogue
_tensor__Tensor__randn_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_data__TensorData__randn:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_data__TensorData__randn_L0:
	movq %rdi, %rbx
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
	movq %r13, 0(%r12)
	movq $0, %rdi
	movq %rdi, -8(%rbp)
	movq $0, %r14
	jmp _data__TensorData__randn_L1
_data__TensorData__randn_L1:
	cmpq %r13, %r14
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _data__TensorData__randn_L2
	jmp _data__TensorData__randn_L3
_data__TensorData__randn_L2:
	movq -8(%rbp), %rdi
	movq %rdi, %r15
	addq %r14, %r15
	callq _random__randn
	movq $4, %rdi
	movq %r15, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movss %xmm0, (%r12,%rdi)
	movq $1, %rdi
	addq %rdi, %r14
	jmp _data__TensorData__randn_L1
_data__TensorData__randn_L3:
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %r12, %rsi
	movq %rbx, %rdx
	callq _data__TensorData____init____f32
	movq %r13, %rax
	jmp _data__TensorData__randn_epilogue
_data__TensorData__randn_epilogue:
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
_random__uniform:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_random__uniform_L0:
	callq rand
	movq %rax, %rdi
	cvtsi2sdl %edi, %xmm1
	movabsq $4607182418800017408, %r11
	movq %r11, %xmm0
	addsd %xmm0, %xmm1
	movabsq $4746794007248502784, %r11
	movq %r11, %xmm0
	subq $8, %rsp
	movsd %xmm0, (%rsp)
	movsd %xmm1, %xmm0
	divsd (%rsp), %xmm0
	addq $8, %rsp
	jmp _random__uniform_epilogue
_random__uniform_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_random__randn:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_random__randn_L0:
	callq _random__uniform
	movq %xmm0, -16(%rbp)
	callq _random__uniform
	movq %xmm0, -32(%rbp)
	movabsq $4611686018427387904, %r11
	movq %r11, %xmm0
	 movq %xmm0, %xmm0
	movabsq $0x8000000000000000, %r11
	movq %r11, %xmm15
	 xorpd %xmm15, %xmm0
	movq %xmm0, -8(%rbp)
	movq -16(%rbp), %xmm0
	callq log
	movsd %xmm0, %xmm1
	movq -8(%rbp), %xmm0
	mulsd %xmm1, %xmm0
	 movq %xmm0, %xmm0
	sqrtsd %xmm0, %xmm0
	movq %xmm0, -24(%rbp)
	movabsq $4618760256179416344, %r11
	movq %r11, %xmm1
	movq -32(%rbp), %xmm0
	mulsd %xmm1, %xmm0
	callq cos
	movsd %xmm0, %xmm1
	movq -24(%rbp), %xmm0
	mulsd %xmm1, %xmm0
	cvtsd2ss %xmm0, %xmm0
	jmp _random__randn_epilogue
_random__randn_epilogue:
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
_schedule__same_shape:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_schedule__same_shape_L0:
	movq %rdi, %r9
	movq %rsi, %r8
	movq 24(%r9), %rsi
	movq $0, %rdi
	movslq (%rdi,%rsi), %rdx
	movq 24(%r8), %rsi
	movq $0, %rdi
	movslq (%rdi,%rsi), %rdi
	cmpq %rdi, %rdx
	sete %r11b
	movzbq %r11b, %rcx
	movq 24(%r9), %rsi
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdx
	movq 24(%r8), %rsi
	movq $8, %rdi
	movslq (%rdi,%rsi), %rdi
	cmpq %rdi, %rdx
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rcx
	movq %rdi, %r11
movq $0, %rdi
	cmovne %r11, %rdi
	movq %rdi, %rax
	jmp _schedule__same_shape_epilogue
_schedule__same_shape_epilogue:
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
_mnist__be32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_mnist__be32_L0:
	movq %rdi, %rax
	movq %rsi, %r10
	movq $0, %r9
	movq $4, %r8
	movq $0, %rdx
	movq $0, %rcx
	jmp _mnist__be32_L1
_mnist__be32_L1:
	cmpq %r8, %rcx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _mnist__be32_L2
	jmp _mnist__be32_L3
_mnist__be32_L2:
	movq %r9, %rsi
	addq %rcx, %rsi
	movq $256, %rdi
	imulq %rdi, %rdx
	addq %r10, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movzbq (%rdi,%rax), %rdi
	movzbq %dil, %rdi
	addq %rdi, %rdx
	movq $1, %rdi
	addq %rdi, %rcx
	jmp _mnist__be32_L1
_mnist__be32_L3:
	movq %rdx, %rax
	jmp _mnist__be32_epilogue
_mnist__be32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_mnist__MNIST____init__:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_mnist__MNIST____init___L0:
	movq %rdi, %rbx
	movq %rsi, %r14
	movq %rdx, %r13
	movq %rcx, %rdi
	movq %rdi, -16(%rbp)
	movq $4, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r14, %rsi
	callq _file__File____init__
	movq %r12, 24(%rbx)
	movq $4, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r13, %rsi
	callq _file__File____init__
	movq %r12, 32(%rbx)
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %rdi, -8(%rbp)
	movq $16, %rsi
	movq -8(%rbp), %rdi
	movq %rsi, 0(%rdi)
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $8, %rdi
	movq %rdi, 0(%r12)
	movq 24(%rbx), %rdi
	movq -8(%rbp), %rsi
	callq _file__File__readinto
	movq 32(%rbx), %rdi
	movq %r12, %rsi
	callq _file__File__readinto
	movq -8(%rbp), %rdi
	movq $0, %rsi
	callq _mnist__be32
	movq %rax, %rsi
	movq $2051, %rdi
	cmpq %rdi, %rsi
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _mnist__MNIST____init___L1
	jmp _mnist__MNIST____init___L2
_mnist__MNIST____init___L1:
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $6, %rdi
	movq %rdi, 0(%r13)
	movq $8, %rsi
	movq $69, %rdi
	movb %dil, (%r13,%rsi)
	movq $9, %rsi
	movq $82, %rdi
	movb %dil, (%r13,%rsi)
	movq $10, %rsi
	movq $82, %rdi
	movb %dil, (%r13,%rsi)
	movq $11, %rsi
	movq $79, %rdi
	movb %dil, (%r13,%rsi)
	movq $12, %rsi
	movq $82, %rdi
	movb %dil, (%r13,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%r13,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %r13, %rsi
	callq _str__str____init__
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $2, %rdi
	movq %rdi, 0(%r13)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%r13,%rsi)
	movq $9, %rsi
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
	callq _str__str____print__
	jmp _mnist__MNIST____init___L3
_mnist__MNIST____init___L2:
	jmp _mnist__MNIST____init___L3
_mnist__MNIST____init___L3:
	movq %r12, %rdi
	movq $0, %rsi
	callq _mnist__be32
	movq %rax, %rsi
	movq $2049, %rdi
	cmpq %rdi, %rsi
	setne %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _mnist__MNIST____init___L4
	jmp _mnist__MNIST____init___L5
_mnist__MNIST____init___L4:
	movq $14, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $6, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rsi
	movq $69, %rdi
	movb %dil, (%r12,%rsi)
	movq $9, %rsi
	movq $82, %rdi
	movb %dil, (%r12,%rsi)
	movq $10, %rsi
	movq $82, %rdi
	movb %dil, (%r12,%rsi)
	movq $11, %rsi
	movq $79, %rdi
	movb %dil, (%r12,%rsi)
	movq $12, %rsi
	movq $82, %rdi
	movb %dil, (%r12,%rsi)
	movq $13, %rsi
	movq $0, %rdi
	movb %dil, (%r12,%rsi)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq %r12, %rsi
	callq _str__str____init__
	movq $10, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq $2, %rdi
	movq %rdi, 0(%r12)
	movq $8, %rsi
	movq $10, %rdi
	movb %dil, (%r12,%rsi)
	movq $9, %rsi
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
	callq _str__str____print__
	jmp _mnist__MNIST____init___L6
_mnist__MNIST____init___L5:
	jmp _mnist__MNIST____init___L6
_mnist__MNIST____init___L6:
	movq -8(%rbp), %rdi
	movq $4, %rsi
	callq _mnist__be32
	movq %rax, %rdi
	movq %rdi, 40(%rbx)
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq -16(%rbp), %rdi
	movl %edi, 48(%rbx)
	movq $784, %rsi
	movq -16(%rbp), %rdi
	movq %rsi, %r12
	imulq %rdi, %r12
	movq $8, %rdi
	addq %r12, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %r12, 0(%rdi)
	movq %rdi, 8(%rbx)
	movq $8, %rsi
	movq -16(%rbp), %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq -16(%rbp), %rdi
	movq %rdi, 0(%rsi)
	movq %rsi, 16(%rbx)
	jmp _mnist__MNIST____init___epilogue
_mnist__MNIST____init___epilogue:
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
_mnist__MNIST__next:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_mnist__MNIST__next_L0:
	movq %rdi, %rbx
	movq 24(%rbx), %rdi
	movq 8(%rbx), %rsi
	callq _file__File__readinto
	movq 32(%rbx), %rdi
	movq 16(%rbx), %rsi
	callq _file__File__readinto
	movq $784, %rsi
	movslq 48(%rbx), %rdi
	movq %rsi, %r12
	imulq %rdi, %r12
	movq $4, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %rdi, -8(%rbp)
	movq -8(%rbp), %rdi
	movq %r12, 0(%rdi)
	movq $784, %rsi
	movslq 48(%rbx), %rdi
	movq %rsi, %r8
	imulq %rdi, %r8
	movq $0, %rcx
	movq $0, %rdx
	jmp _mnist__MNIST__next_L1
_mnist__MNIST__next_L1:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _mnist__MNIST__next_L2
	jmp _mnist__MNIST__next_L3
_mnist__MNIST__next_L2:
	movq %rcx, %r9
	addq %rdx, %r9
	movq 8(%rbx), %rsi
	movq $8, %rdi
	addq %r9, %rdi
	movzbq (%rdi,%rsi), %rdi
	movzbq %dil, %r11
	cvtsi2ssq %r11, %xmm1
	movq $255, %rdi
	cvtsi2ssq %rdi, %xmm0
	subq $4, %rsp
	movss %xmm0, (%rsp)
	movss %xmm1, %xmm0
	divss (%rsp), %xmm0
	addq $4, %rsp
	movq $4, %rdi
	movq %r9, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rdi, %rsi
	movq -8(%rbp), %rdi
	movss %xmm0, (%rdi,%rsi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _mnist__MNIST__next_L1
_mnist__MNIST__next_L3:
	movq $10, %rsi
	movslq 48(%rbx), %rdi
	movq %rsi, %r13
	imulq %rdi, %r13
	movq $4, %rdi
	movq %r13, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r13, 0(%r12)
	movq $10, %rsi
	movslq 48(%rbx), %rdi
	movq %rsi, %r8
	imulq %rdi, %r8
	movq $0, %rcx
	movq $0, %rdx
	jmp _mnist__MNIST__next_L4
_mnist__MNIST__next_L4:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _mnist__MNIST__next_L5
	jmp _mnist__MNIST__next_L6
_mnist__MNIST__next_L5:
	movq %rcx, %rsi
	addq %rdx, %rsi
	movq $0, %rdi
	cvtsi2ssq %rdi, %xmm0
	movq $4, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movss %xmm0, (%r12,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _mnist__MNIST__next_L4
_mnist__MNIST__next_L6:
	movslq 48(%rbx), %r8
	movq $0, %rcx
	movq $0, %rdx
	jmp _mnist__MNIST__next_L7
_mnist__MNIST__next_L7:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _mnist__MNIST__next_L8
	jmp _mnist__MNIST__next_L9
_mnist__MNIST__next_L8:
	movq %rcx, %rax
	addq %rdx, %rax
	movq $1, %rdi
	cvtsi2ssq %rdi, %xmm0
	movq $10, %rdi
	movq %rax, %r9
	imulq %rdi, %r9
	movq 16(%rbx), %rsi
	movq $8, %rdi
	addq %rax, %rdi
	movzbq (%rdi,%rsi), %rdi
	movzbl %dil, %edi
	movq %r9, %rsi
	addq %rdi, %rsi
	movq $4, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movss %xmm0, (%r12,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _mnist__MNIST__next_L7
_mnist__MNIST__next_L9:
	movq 0(%rbx), %rsi
	movslq 48(%rbx), %rdi
	addq %rsi, %rdi
	movq %rdi, 0(%rbx)
	movslq 48(%rbx), %r15
	movq $784, %r13
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r14
	movl %r15d, 0(%r14)
	movl %r13d, 8(%r14)
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq %r13, %rdi
	movq -8(%rbp), %rsi
	movq %r14, %rdx
	callq _tensor__Tensor____init____f32
	movslq 48(%rbx), %r15
	movq $10, %rbx
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r14
	movl %r15d, 0(%r14)
	movl %ebx, 8(%r14)
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	callq _tensor__Tensor____init____f32
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %r13, 0(%rdi)
	movq %rbx, 8(%rdi)
	movq %rdi, %rax
	jmp _mnist__MNIST__next_epilogue
_mnist__MNIST__next_epilogue:
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
_mnist__MNIST__close:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_mnist__MNIST__close_L0:
	movq %rdi, %rbx
	movq 24(%rbx), %rdi
	callq _file__File__close
	movq 32(%rbx), %rdi
	callq _file__File__close
	jmp _mnist__MNIST__close_epilogue
_mnist__MNIST__close_epilogue:
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
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_concat__string_concat_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $1, %rdi
	movq %rdi, 0(%r13)
	movq $8, %rsi
	movq $0, %rdi
	movb %dil, (%r13,%rsi)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %r13, %rsi
	callq _list__list____init____char
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	subq %rdi, %rsi
	movq %r14, %rdi
	callq _list__list____mul____char
	movq %rax, %rdx
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq $1, %rsi
	movq %rdi, %r9
	subq %rsi, %r9
	movq $0, %r8
	movq $0, %rcx
	jmp _concat__string_concat_L1
_concat__string_concat_L1:
	cmpq %r9, %rcx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L2
	jmp _concat__string_concat_L3
_concat__string_concat_L2:
	movq %r8, %r10
	addq %rcx, %r10
	movq 0(%r12), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movzbq (%rdi,%rsi), %rax
	movq 0(%rdx), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movb %al, (%rsi,%rdi)
	movq $1, %rdi
	addq %rdi, %rcx
	jmp _concat__string_concat_L1
_concat__string_concat_L3:
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %r8
	subq %rdi, %r8
	movq $0, %r9
	movq $0, %rcx
	jmp _concat__string_concat_L4
_concat__string_concat_L4:
	cmpq %r8, %rcx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _concat__string_concat_L5
	jmp _concat__string_concat_L6
_concat__string_concat_L5:
	movq %r9, %r10
	addq %rcx, %r10
	movq 0(%rbx), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movzbq (%rdi,%rsi), %rax
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq %r10, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %r10
	subq %rdi, %r10
	movq 0(%rdx), %rsi
	movq $8, %rdi
	addq %r10, %rdi
	movb %al, (%rsi,%rdi)
	movq $1, %rdi
	addq %rdi, %rcx
	jmp _concat__string_concat_L4
_concat__string_concat_L6:
	movq %rdx, %rax
	jmp _concat__string_concat_epilogue
_concat__string_concat_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
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
	addq %rbx, %rdi
	movzbq %dil, %rbx
	movq $9, %rdi
	callq arena_malloc
	movq %rax, %rsi
	movq $1, %rdi
	movq %rdi, 0(%rsi)
	movq $8, %rdi
	movb %bl, (%rsi,%rdi)
	movq $8, %rdi
	addq %rdi, %rsi
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
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq $0, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_L4
	jmp _print__print_int_L5
_print__print_int_L4:
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
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
	movq 0(%r13), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq $0, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_bool_L1
	jmp _print__print_bool_L2
_print__print_bool_L1:
	movq 0(%r13), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
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
	movq %rdi, %rcx
	movq %rsi, %rbx
	movq 0(%rcx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq %rcx, %rdi
	movq $1, %rsi
	callq _str__str____write__
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq $0, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_string_L1
	jmp _print__print_string_L2
_print__print_string_L1:
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
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
	movq %rdi, -8(%rbp)
	movq %rsi, %rdi
	movq %rdi, -32(%rbp)
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
	movq %rax, %r12
	movq %r12, %rdi
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
	movq %rax, %r13
	movq %r13, %rdi
	movq %rbx, %rsi
	callq _str__str____init__
	movq %r12, %rdi
	movq %r13, %rsi
	callq _print__print_string
	movq -8(%rbp), %rdi
	movslq 0(%rdi), %rsi
	movq $0, %rdi
	movq %rdi, -24(%rbp)
	movq %rsi, -16(%rbp)
	movq $0, %rbx
	jmp _print__print_int_array_L1
_print__print_int_array_L1:
	movq -16(%rbp), %rdi
	cmpq %rdi, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_int_array_L2
	jmp _print__print_int_array_L3
_print__print_int_array_L2:
	movq -24(%rbp), %rdi
	movq %rdi, %r12
	addq %rbx, %r12
	movq $8, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rdi, %rsi
	movq -8(%rbp), %rdi
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
	movq -8(%rbp), %rdi
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
	movq -32(%rbp), %rsi
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
	movq %xmm0, -8(%rbp)
	movq %rsi, %r13
	movabsq $0, %r11
	movq %r11, %xmm1
	movq -8(%rbp), %xmm0
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
	movq -8(%rbp), %xmm0
	 movq %xmm0, %xmm0
	movabsq $0x8000000000000000, %r11
	movq %r11, %xmm15
	 xorpd %xmm15, %xmm0
	movq %xmm0, -16(%rbp)
	jmp _print__print_float_L3
_print__print_float_L2:
	movq -8(%rbp), %xmm0
	movq %xmm0, -16(%rbp)
	jmp _print__print_float_L3
_print__print_float_L3:
	movq -16(%rbp), %xmm0
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
	movq -16(%rbp), %xmm0
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
	movq $0, %rdi
	movq $5, %r14
	movq $0, %r12
	jmp _print__print_float_L4
_print__print_float_L4:
	cmpq %r14, %r12
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L5
	jmp _print__print_float_L6
_print__print_float_L5:
	movabsq $4621819117588971520, %r11
	movq %r11, %xmm0
	mulsd %xmm1, %xmm0
	movq %xmm0, -24(%rbp)
	movq -24(%rbp), %xmm0
	cvttsd2siq %xmm0, %rbx
	movq %rbx, %rdi
	callq _print___print_int_helper
	cvtsi2sdq %rbx, %xmm1
	movq -24(%rbp), %xmm0
	movsd %xmm1, %xmm15
	movsd %xmm0, %xmm1
	subsd %xmm15, %xmm1
	movq $1, %rdi
	addq %rdi, %r12
	jmp _print__print_float_L4
_print__print_float_L6:
	movq 0(%r13), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq $0, %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _print__print_float_L7
	jmp _print__print_float_L8
_print__print_float_L7:
	movq 0(%r13), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq %r13, %rdi
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
_print__print_none:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_print__print_none_L0:
	movq %rsi, %r12
	movq $13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $5, %rdi
	movq %rdi, 0(%rbx)
	movq $8, %rsi
	movq $78, %rdi
	movb %dil, (%rbx,%rsi)
	movq $9, %rsi
	movq $111, %rdi
	movb %dil, (%rbx,%rsi)
	movq $10, %rsi
	movq $110, %rdi
	movb %dil, (%rbx,%rsi)
	movq $11, %rsi
	movq $101, %rdi
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
	movq %r13, %rdi
	movq %r12, %rsi
	callq _print__print_string
	jmp _print__print_none_epilogue
_print__print_none_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_file__File____init__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_file__File____init___L0:
	movq %rdi, %rbx
	movq %rsi, %r8
	movq $100, %rdi
	 movq %rdi, %rdi
	negq %rdi
	movl %edi, %esi
	movq $0, %rdi
	movl %edi, %edx
	movq $0, %rdi
	movl %edi, %ecx
	movq %r8, %rdi
	callq _str__str____openat__
	movq %rax, %rdi
	movl %edi, 0(%rbx)
	jmp _file__File____init___epilogue
_file__File____init___epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_file__File__readinto:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_file__File__readinto_L0:
	movslq 0(%rdi), %rcx
	movslq 0(%rsi), %rdi
	movslq %edi, %rdx
	movq $8, %rdi
	addq %rdi, %rsi
	movq %rcx, %rdi
	callq read
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _file__File__readinto_epilogue
_file__File__readinto_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_file__File__close:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_file__File__close_L0:
	movq %rdi, %rbx
	movslq 0(%rbx), %rsi
	movq $0, %rdi
	cmpq %rdi, %rsi
	setge %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _file__File__close_L1
	jmp _file__File__close_L2
_file__File__close_L1:
	movslq 0(%rbx), %rdi
	callq close
	movq $1, %rdi
	 movq %rdi, %rdi
	negq %rdi
	movq %rdi, 0(%rbx)
	jmp _file__File__close_L3
_file__File__close_L2:
	jmp _file__File__close_L3
_file__File__close_L3:
	jmp _file__File__close_epilogue
_file__File__close_epilogue:
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
	movq %rdi, %r9
	movq %rsi, %rax
	movq 0(%r9), %rdi
	movslq 0(%rdi), %rsi
	movq 0(%rax), %rdi
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
_str__str____eq___L2:
	jmp _str__str____eq___L3
_str__str____eq___L3:
	movq 0(%r9), %rdi
	movslq 0(%rdi), %r8
	movq $0, %rcx
	movq $0, %rdx
	jmp _str__str____eq___L4
_str__str____eq___L4:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____eq___L5
	jmp _str__str____eq___L6
_str__str____eq___L5:
	movq %rcx, %rbx
	addq %rdx, %rbx
	movq 0(%r9), %rsi
	movq $8, %rdi
	addq %rbx, %rdi
	movzbq (%rdi,%rsi), %r10
	movq 0(%rax), %rsi
	movq $8, %rdi
	addq %rbx, %rdi
	movzbq (%rdi,%rsi), %rdi
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
_str__str____eq___L8:
	jmp _str__str____eq___L9
_str__str____eq___L9:
	movq $1, %rdi
	addq %rdi, %rdx
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
_str__str____openat__:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____openat___L0:
	movq %rsi, %r8
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %rdi, %rsi
	movq %r8, %rdi
	callq openat
	movq %rax, %rdi
	movq %rdi, %rax
	jmp _str__str____openat___epilogue
_str__str____openat___epilogue:
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
	movq %rdi, %rcx
	movq %rsi, %rbx
	movq 0(%rcx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
	movq %rcx, %rdi
	movq $1, %rsi
	callq _str__str____write__
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %rdx
	subq %rdi, %rdx
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
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_str__str____add___L0:
	movq %rdi, %r15
	movq %rsi, %rdi
	movq %rdi, -8(%rbp)
	movq 0(%r15), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rsi, %r14
	subq %rdi, %r14
	movq -8(%rbp), %rdi
	movq 0(%rdi), %rdi
	movslq 0(%rdi), %rsi
	movq $1, %rdi
	movq %rdi, %r11
	movq %rsi, %rdi
	subq %r11, %rdi
	movq %rdi, %r13
	movq %r14, %rsi
	addq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %r12
	addq %rdi, %r12
	movq $8, %rdi
	addq %r12, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %r12, %rdi
	movq %rdi, 0(%rbx)
	movq $0, %rcx
	movq %r14, %r8
	movq $0, %rdx
	jmp _str__str____add___L1
_str__str____add___L1:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____add___L2
	jmp _str__str____add___L3
_str__str____add___L2:
	movq %rcx, %r9
	addq %rdx, %r9
	movq 0(%r15), %rsi
	movq $8, %rdi
	addq %r9, %rdi
	movzbq (%rdi,%rsi), %rsi
	movq $8, %rdi
	addq %r9, %rdi
	movb %sil, (%rbx,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _str__str____add___L1
_str__str____add___L3:
	movq $0, %rcx
	movq %r13, %r8
	movq $0, %rdx
	jmp _str__str____add___L4
_str__str____add___L4:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _str__str____add___L5
	jmp _str__str____add___L6
_str__str____add___L5:
	movq %rcx, %rax
	addq %rdx, %rax
	movq -8(%rbp), %rdi
	movq 0(%rdi), %rsi
	movq $8, %rdi
	addq %rax, %rdi
	movzbq (%rdi,%rsi), %r9
	movq %r14, %rsi
	addq %rax, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movb %r9b, (%rbx,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _str__str____add___L4
_str__str____add___L6:
	movq $0, %rdx
	movq %r14, %rsi
	addq %r13, %rsi
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
	addq $16, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____len____class_1:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____len____class_1_L0:
	movslq 8(%rdi), %rdi
	movq %rdi, %rax
	jmp _list__list____len____class_1_epilogue
_list__list____len____class_1_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list____getitem____class_1:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____getitem____class_1_L0:
	movq 0(%rdi), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rdx), %rdi
	movq %rdi, %rax
	jmp _list__list____getitem____class_1_epilogue
_list__list____getitem____class_1_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_dict__dict____setitem____class_1_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict____setitem____class_1_bool_L0:
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
	jne _dict__dict____setitem____class_1_bool_L1
	jmp _dict__dict____setitem____class_1_bool_L2
_dict__dict____setitem____class_1_bool_L1:
	movq %rbx, %rdi
	callq _dict__dict___grow__class_1_bool
	jmp _dict__dict____setitem____class_1_bool_L3
_dict__dict____setitem____class_1_bool_L2:
	jmp _dict__dict____setitem____class_1_bool_L3
_dict__dict____setitem____class_1_bool_L3:
	movq %rbx, %rdi
	movq %r13, %rsi
	callq _dict__dict___get__class_1_bool
	movq %rax, %rcx
	movq 0(%rbx), %rdx
	movq $8, %rdi
	movq %rcx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %r13, (%rdx,%rdi)
	movq 8(%rbx), %rsi
	movq $8, %rdi
	addq %rcx, %rdi
	movb %r12b, (%rsi,%rdi)
	movq $1, %rdx
	movq 16(%rbx), %rsi
	movq $8, %rdi
	addq %rcx, %rdi
	movb %dl, (%rsi,%rdi)
	movslq 24(%rbx), %rsi
	movq $1, %rdi
	addq %rsi, %rdi
	movl %edi, 24(%rbx)
	jmp _dict__dict____setitem____class_1_bool_epilogue
_dict__dict____setitem____class_1_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list__append__class_1:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list__append__class_1_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movslq 8(%r12), %rsi
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list__append__class_1_L1
	jmp _list__list__append__class_1_L2
_list__list__append__class_1_L1:
	movq %r12, %rdi
	callq _list__list___grow__class_1
	jmp _list__list__append__class_1_L3
_list__list__append__class_1_L2:
	jmp _list__list__append__class_1_L3
_list__list__append__class_1_L3:
	movslq 8(%r12), %rsi
	movq 0(%r12), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %rbx, (%rdx,%rdi)
	movslq 8(%r12), %rsi
	movq $1, %rdi
	addq %rsi, %rdi
	movl %edi, 8(%r12)
	jmp _list__list__append__class_1_epilogue
_list__list__append__class_1_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_uop__Uop__from_data__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_uop__Uop__from_data__f32_L0:
	movq %rdi, %r13
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq $0, %rdi
	movq %rdi, 0(%rbx)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq %r14, %rdi
	movq %rbx, %rsi
	callq _list__list____init____class_1_f32
	movslq 8(%r13), %r15
	movslq 12(%r13), %rbx
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %r12
	movl %r15d, 0(%r12)
	movl %ebx, 8(%r12)
	movq $44, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %rbx, %rdi
	movq %r14, %rsi
	movq $0, %rdx
	movq %r12, %rcx
	movq $0, %r8
	callq _uop__Uop____init____f32
	movq 8(%rbx), %rdi
	movq %r13, %rsi
	callq _list__list__append__class_3_f32
	movq %rbx, %rax
	jmp _uop__Uop__from_data__f32_epilogue
_uop__Uop__from_data__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_tensor__Tensor___init__f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_tensor__Tensor___init__f32_L0:
	movq %rdi, %r12
	movq $16, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %r12, 0(%rbx)
	movq 36(%r12), %rdi
	movq %rbx, %rsi
	callq _list__list__append__class_2_f32
	movq $0, %rdi
	movq %rdi, 8(%rbx)
	movq %rbx, %rax
	jmp _tensor__Tensor___init__f32_epilogue
_tensor__Tensor___init__f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
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
	movq %rdi, %rbx
	movq %rsi, %r14
	movq %rdx, %r13
	movq $24, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r14, %rsi
	movq %r13, %rdx
	callq _data__TensorData____init____f32
	movq %r12, %rdi
	callq _uop__Uop__from_data__f32
	movq %rax, %rdi
	movq %rdi, 0(%rbx)
	movq 0(%rbx), %rdi
	movq 36(%rdi), %rdi
	movq %rbx, %rsi
	callq _list__list__append__class_2_f32
	movq $0, %rdi
	movq %rdi, 8(%rbx)
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
_dict__dict___grow__class_1_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict___grow__class_1_bool_L0:
	movq %rdi, %r15
	movq 0(%r15), %r14
	movq 8(%r15), %rdi
	movq %rdi, -8(%rbp)
	movq 16(%r15), %rdi
	movq %rdi, -16(%rbp)
	movslq 0(%r14), %rbx
	movq $2, %rdi
	movq %rbx, %rsi
	imulq %rdi, %rsi
	movq $1, %rdi
	movq %rsi, %r12
	addq %rdi, %r12
	movq $8, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %r12, 0(%rdi)
	movq %rdi, 0(%r15)
	movq $8, %rdi
	addq %r12, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %r12, 0(%rdi)
	movq %rdi, 8(%r15)
	movq $8, %rdi
	addq %r12, %rdi
	callq arena_malloc
	movq %rax, %rdi
	movq %r12, 0(%rdi)
	movq %rdi, 16(%r15)
	movq $0, %rdi
	movq %rdi, 24(%r15)
	movq $0, %r9
	movq $0, %r8
	jmp _dict__dict___grow__class_1_bool_L1
_dict__dict___grow__class_1_bool_L1:
	cmpq %r12, %r8
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict___grow__class_1_bool_L2
	jmp _dict__dict___grow__class_1_bool_L3
_dict__dict___grow__class_1_bool_L2:
	movq %r9, %rcx
	addq %r8, %rcx
	movq $0, %rdx
	movq 16(%r15), %rsi
	movq $8, %rdi
	addq %rcx, %rdi
	movb %dl, (%rsi,%rdi)
	movq $1, %rdi
	addq %rdi, %r8
	jmp _dict__dict___grow__class_1_bool_L1
_dict__dict___grow__class_1_bool_L3:
	movq $0, %r13
	movq %rbx, %r12
	movq $0, %rbx
	jmp _dict__dict___grow__class_1_bool_L4
_dict__dict___grow__class_1_bool_L4:
	cmpq %r12, %rbx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict___grow__class_1_bool_L5
	jmp _dict__dict___grow__class_1_bool_L6
_dict__dict___grow__class_1_bool_L5:
	movq %r13, %rdx
	addq %rbx, %rdx
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq -16(%rbp), %rdi
	movzbq (%rsi,%rdi), %rdi
	cmpq $0, %rdi
	jne _dict__dict___grow__class_1_bool_L7
	jmp _dict__dict___grow__class_1_bool_L8
_dict__dict___grow__class_1_bool_L6:
	jmp _dict__dict___grow__class_1_bool_epilogue
_dict__dict___grow__class_1_bool_L7:
	movq $8, %rdi
	movq %rdx, %rsi
	addq %rdi, %rsi
	movq -8(%rbp), %rdi
	movzbq (%rsi,%rdi), %rcx
	movq $8, %rdi
	movq %rdx, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%r14), %rsi
	movq %r15, %rdi
	movq %rcx, %rdx
	callq _dict__dict____setitem____class_1_bool
	jmp _dict__dict___grow__class_1_bool_L9
_dict__dict___grow__class_1_bool_L8:
	jmp _dict__dict___grow__class_1_bool_L9
_dict__dict___grow__class_1_bool_L9:
	movq $1, %rdi
	addq %rbx, %rdi
	movq %rdi, %rbx
	jmp _dict__dict___grow__class_1_bool_L4
_dict__dict___grow__class_1_bool_epilogue:
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
_dict__dict___get__class_1_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict___get__class_1_bool_L0:
	movq %rdi, %rcx
	movq %rsi, %r8
	movq 8(%rcx), %rdi
	movslq 0(%rdi), %rdx
	pushq %rax
	pushq %rdx
	movq %rdx, %r11
	movq %r8, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %r9
	jmp _dict__dict___get__class_1_bool_L1
_dict__dict___get__class_1_bool_L1:
	movq 16(%rcx), %rsi
	movq $8, %rdi
	addq %r9, %rdi
	movzbq (%rdi,%rsi), %rdi
	cmpq $0, %rdi
	jne _dict__dict___get__class_1_bool_L2
	jmp _dict__dict___get__class_1_bool_L3
_dict__dict___get__class_1_bool_L2:
	movq 0(%rcx), %rax
	movq $8, %rdi
	movq %r9, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rax), %rdi
	cmpq %r8, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _dict__dict___get__class_1_bool_L4
	jmp _dict__dict___get__class_1_bool_L5
_dict__dict___get__class_1_bool_L3:
	movq %r9, %rax
	jmp _dict__dict___get__class_1_bool_epilogue
_dict__dict___get__class_1_bool_L4:
	movq %r9, %rax
	jmp _dict__dict___get__class_1_bool_epilogue
_dict__dict___get__class_1_bool_L5:
	jmp _dict__dict___get__class_1_bool_L6
_dict__dict___get__class_1_bool_L6:
	movq $1, %rdi
	addq %r9, %rdi
	pushq %rax
	pushq %rdx
	movq %rdx, %r11
	movq %rdi, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %r9
	jmp _dict__dict___get__class_1_bool_L1
_dict__dict___get__class_1_bool_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list___grow__class_1:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list___grow__class_1_L0:
	movq %rdi, %rbx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $8, %rdi
	cmpq %rdi, %rsi
	setl %r11b
	movzbq %r11b, %rdx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $2, %rdi
	imulq %rsi, %rdi
	cmpq $0, %rdx
movq $8, %r11
	movq %rdi, %r12
	cmovne %r11, %r12
	movq $8, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r8
	movq %r12, 0(%r8)
	movslq 8(%rbx), %r9
	movq $0, %rcx
	movq $0, %rdx
	jmp _list__list___grow__class_1_L1
_list__list___grow__class_1_L1:
	cmpq %r9, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list___grow__class_1_L2
	jmp _list__list___grow__class_1_L3
_list__list___grow__class_1_L2:
	movq %rcx, %r10
	addq %rdx, %r10
	movq 0(%rbx), %rax
	movq $8, %rdi
	movq %r10, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rax), %rax
	movq $8, %rdi
	movq %r10, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %rax, (%r8,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _list__list___grow__class_1_L1
_list__list___grow__class_1_L3:
	movq %r8, 0(%rbx)
	jmp _list__list___grow__class_1_epilogue
_list__list___grow__class_1_epilogue:
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
	subq $16, %rsp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_uop__Uop____init____f32_L0:
	movq %rdi, %rbx
	movq %rdx, %rdi
	movq %rdi, -8(%rbp)
	movq %rcx, %r13
	movq %r8, %r12
	movq %rsi, 0(%rbx)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r14
	movq $0, %rdi
	movq %rdi, 0(%r14)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r15
	movq %r15, %rdi
	movq %r14, %rsi
	callq _list__list____init____class_3_f32
	movq %r15, 8(%rbx)
	movq -8(%rbp), %rdi
	movq %rdi, 16(%rbx)
	movq %r13, 24(%rbx)
	movl %r12d, 32(%rbx)
	movq $8, %rdi
	callq arena_malloc
	movq %rax, %r13
	movq $0, %rdi
	movq %rdi, 0(%r13)
	movq $12, %rdi
	callq arena_malloc
	movq %rax, %r12
	movq %r12, %rdi
	movq %r13, %rsi
	callq _list__list____init____class_2_f32
	movq %r12, 36(%rbx)
	jmp _uop__Uop____init____f32_epilogue
_uop__Uop____init____f32_epilogue:
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
_list__list__append__class_3_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list__append__class_3_f32_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movslq 8(%r12), %rsi
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list__append__class_3_f32_L1
	jmp _list__list__append__class_3_f32_L2
_list__list__append__class_3_f32_L1:
	movq %r12, %rdi
	callq _list__list___grow__class_3_f32
	jmp _list__list__append__class_3_f32_L3
_list__list__append__class_3_f32_L2:
	jmp _list__list__append__class_3_f32_L3
_list__list__append__class_3_f32_L3:
	movslq 8(%r12), %rsi
	movq 0(%r12), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %rbx, (%rdx,%rdi)
	movslq 8(%r12), %rsi
	movq $1, %rdi
	addq %rsi, %rdi
	movl %edi, 8(%r12)
	jmp _list__list__append__class_3_f32_epilogue
_list__list__append__class_3_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list__append__class_2_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list__append__class_2_f32_L0:
	movq %rdi, %r12
	movq %rsi, %rbx
	movslq 8(%r12), %rsi
	movq 0(%r12), %rdi
	movslq 0(%rdi), %rdi
	cmpq %rdi, %rsi
	sete %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list__append__class_2_f32_L1
	jmp _list__list__append__class_2_f32_L2
_list__list__append__class_2_f32_L1:
	movq %r12, %rdi
	callq _list__list___grow__class_2_f32
	jmp _list__list__append__class_2_f32_L3
_list__list__append__class_2_f32_L2:
	jmp _list__list__append__class_2_f32_L3
_list__list__append__class_2_f32_L3:
	movslq 8(%r12), %rsi
	movq 0(%r12), %rdx
	movq $8, %rdi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %rbx, (%rdx,%rdi)
	movslq 8(%r12), %rsi
	movq $1, %rdi
	addq %rsi, %rdi
	movl %edi, 8(%r12)
	jmp _list__list__append__class_2_f32_epilogue
_list__list__append__class_2_f32_epilogue:
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
_list__list____init____class_2_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list____init____class_2_f32_L0:
	movq %rdi, %rdx
	movq %rsi, %rdi
	movq %rdi, 0(%rdx)
	movslq 0(%rdi), %rdi
	movl %edi, 8(%rdx)
	jmp _list__list____init____class_2_f32_epilogue
_list__list____init____class_2_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list___grow__class_3_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list___grow__class_3_f32_L0:
	movq %rdi, %rbx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $8, %rdi
	cmpq %rdi, %rsi
	setl %r11b
	movzbq %r11b, %rdx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $2, %rdi
	imulq %rsi, %rdi
	cmpq $0, %rdx
movq $8, %r11
	movq %rdi, %r12
	cmovne %r11, %r12
	movq $8, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r8
	movq %r12, 0(%r8)
	movslq 8(%rbx), %r9
	movq $0, %rcx
	movq $0, %rdx
	jmp _list__list___grow__class_3_f32_L1
_list__list___grow__class_3_f32_L1:
	cmpq %r9, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list___grow__class_3_f32_L2
	jmp _list__list___grow__class_3_f32_L3
_list__list___grow__class_3_f32_L2:
	movq %rcx, %r10
	addq %rdx, %r10
	movq 0(%rbx), %rax
	movq $8, %rdi
	movq %r10, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rax), %rax
	movq $8, %rdi
	movq %r10, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %rax, (%r8,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _list__list___grow__class_3_f32_L1
_list__list___grow__class_3_f32_L3:
	movq %r8, 0(%rbx)
	jmp _list__list___grow__class_3_f32_epilogue
_list__list___grow__class_3_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_list__list___grow__class_2_f32:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_list__list___grow__class_2_f32_L0:
	movq %rdi, %rbx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $8, %rdi
	cmpq %rdi, %rsi
	setl %r11b
	movzbq %r11b, %rdx
	movq 0(%rbx), %rdi
	movslq 0(%rdi), %rsi
	movq $2, %rdi
	imulq %rsi, %rdi
	cmpq $0, %rdx
movq $8, %r11
	movq %rdi, %r12
	cmovne %r11, %r12
	movq $8, %rdi
	movq %r12, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	callq arena_malloc
	movq %rax, %r8
	movq %r12, 0(%r8)
	movslq 8(%rbx), %r9
	movq $0, %rcx
	movq $0, %rdx
	jmp _list__list___grow__class_2_f32_L1
_list__list___grow__class_2_f32_L1:
	cmpq %r9, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list___grow__class_2_f32_L2
	jmp _list__list___grow__class_2_f32_L3
_list__list___grow__class_2_f32_L2:
	movq %rcx, %r10
	addq %rdx, %r10
	movq 0(%rbx), %rax
	movq $8, %rdi
	movq %r10, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq (%rdi,%rax), %rax
	movq $8, %rdi
	movq %r10, %rsi
	imulq %rdi, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movq %rax, (%r8,%rdi)
	movq $1, %rdi
	addq %rdi, %rdx
	jmp _list__list___grow__class_2_f32_L1
_list__list___grow__class_2_f32_L3:
	movq %r8, 0(%rbx)
	jmp _list__list___grow__class_2_f32_epilogue
_list__list___grow__class_2_f32_epilogue:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	addq $8, %rsp
	popq %rbp
	retq
# origin: runtime
_dict__dict____contains____class_1_bool:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
_dict__dict____contains____class_1_bool_L0:
	movq %rdi, %rbx
	movq %rbx, %rdi
	callq _dict__dict___get__class_1_bool
	movq %rax, %rdx
	movq 16(%rbx), %rsi
	movq $8, %rdi
	addq %rdx, %rdi
	movzbq (%rdi,%rsi), %rdi
	movq %rdi, %rax
	jmp _dict__dict____contains____class_1_bool_epilogue
_dict__dict____contains____class_1_bool_epilogue:
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
	movq %rdi, %r12
	movq %rsi, %r14
	movslq 8(%r12), %rdi
	movq %rdi, %r13
	imulq %r14, %r13
	movq $8, %rdi
	addq %r13, %rdi
	callq arena_malloc
	movq %rax, %rbx
	movq %r13, 0(%rbx)
	movslq 8(%r12), %rdi
	movq %rdi, %r8
	imulq %r14, %r8
	movq $0, %rcx
	movq $0, %rdx
	jmp _list__list____mul____char_L1
_list__list____mul____char_L1:
	cmpq %r8, %rdx
	setl %r11b
	movzbq %r11b, %rdi
	cmpq $0, %rdi
	jne _list__list____mul____char_L2
	jmp _list__list____mul____char_L3
_list__list____mul____char_L2:
	movq %rcx, %rax
	addq %rdx, %rax
	movq 0(%r12), %r9
	movslq 8(%r12), %rdi
	pushq %rax
	pushq %rdx
	movq %rdi, %r11
	movq %rax, %rax
	cqto
	idivq %r11
	movq %rdx, %r11
	popq %rdx
	popq %rax
	movq %r11, %rsi
	movq $8, %rdi
	addq %rsi, %rdi
	movzbq (%rdi,%r9), %rsi
	movq $8, %rdi
	addq %rax, %rdi
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
