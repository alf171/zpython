
def grad_rule[T](node: Uop[T], incoming: Uop[T]) -> list[Uop[T]|None]:
    if node.op == Ops.BUFFER:
        return []
    elif node.op == Ops.ADD:
        return [incoming, incoming]
    elif node.op == Ops.SUB:
        return [incoming, -incoming]
    elif node.op == Ops.MUL:
        lhs = cast(Uop[T], node.src[0])
        rhs = cast(Uop[T], node.src[1])
        return [incoming * rhs, incoming * lhs]
    # lhs/rhs
    elif node.op == Ops.DIV:
        lhs = cast(Uop[T], node.src[0])
        rhs = cast(Uop[T], node.src[1])
        two_t: T = 2
        two = Uop.fill(rhs.shape, two_t)
        return [incoming/rhs, -(incoming * lhs)/(rhs**two)]
    elif node.op == Ops.MATMUL:
        lhs = cast(Uop[T], node.src[0])
        rhs = cast(Uop[T], node.src[1])
        return [incoming @ rhs.transpose(), lhs.transpose() @ incoming]
    elif node.op == Ops.WHERE:
        mask = cast(Uop[bool], node.src[0])
        zero_t: T = 0
        zero = Uop.fill(node.shape, zero_t)
        return [
            None,
            Uop.where(mask, incoming, zero),
            Uop.where(mask, zero, incoming)
        ]
    elif node.op == Ops.GT:
        pass
    elif node.op == Ops.EXP:
        # identity
        return [incoming * node]
    elif node.op == Ops.SUM:
        return [incoming.broadcast_to(node.src[0].shape)]
    # input: [4, 5, 5]
    # incoming: 6
    # grad: [0, 3, 3] >> split is kinda tricky here
    elif node.op == Ops.MAX:
        # source = node.src[0]
        # max = node.broadcast_to(source.shape)
        pass
    elif node.op == Ops.BROADCAST:
        # assume 2d
        source = node.src[0]
        grad = incoming
        if (source.shape[0] == 1 and node.shape[0] != 1):
            grad = grad.sum(0)
        if (source.shape[1] == 1 and node.shape[1] != 1):
            grad = grad.sum(1)
        return [grad]
    elif node.op == Ops.TRANSPOSE:
        return [incoming.transpose()]
