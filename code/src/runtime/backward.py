# from tensor import Tensor
#
# def broadcast_to[U](out: Tensor[U], left: Tensor[U]) -> None:
#     grad = out.grad
#     if (left.uop.shape[0] == 1 and out.uop.shape[1] != 1):
#         grad = out.grad.sum(0)
#
#     if (left.uop.shape[0] == 1 and out.uop.shape[1] != 1):
#         grad = out.grad.sum(1)
#
#     left.grad += grad
#
# def sum[U](out: Tensor[U], left: Tensor[U]) -> None:
#     rows = left.uop.shape[0]
#     cols = left.uop.shape[1]
#     left.grad = out.grad.broadcast_to((rows, cols))

def grad_rule[T](node: Uop[T], incoming: Uop[T]) -> list[Uop[T]]:
    if node.op == Ops.BUFFER:
        return []
    elif node.op == Ops.ADD:
        return [incoming, incoming]
    elif node.op == Ops.SUB:
        return [incoming, -incoming]
    elif node.op == Ops.MUL:
        return [incoming * node.src[1], incoming * node.src[0]]
    # lhs/rhs
    elif node.op == Ops.DIV:
        lhs = node.src[0]
        rhs = node.src[1]
        two_t: T = 2
        two = Uop.fill(rhs.shape, two_t)
        return [incoming/rhs, -(incoming * lhs)/(rhs**two)]
    elif node.op == Ops.MATMUL:
        return [incoming @ node.src[1].transpose(), node.src[0].transpose() @ node.src[0]]
    elif node.op == Ops.RELU:
        zero_t: T = 0
        zero = Uop.fill(node.shape, zero_t)
        return [(node.src[0] > zero).where(incoming, zero)]
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
        if (source.shape[0] != 1 and node.shape[0] != 1):
            grad = grad.sum(0)
        if (source.shape[1] != 1 and node.shape[1] != 1):
            grad = grad.sum(1)
        return grad
    elif node.op == Ops.TRANSPOSE:
        return [incoming.transpose()]
