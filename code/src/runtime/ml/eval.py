from ml.uop import Uop
from ml.data import TensorData
from ml.ops import Ops

def evaluate[T](node: Uop[T]) -> TensorData[T]:
    if len(node.buffers) > 0:
        return node.buffers[0]

    res = evaluate_uncached(node)
    node.buffers.append(res)
    return res

def evaluate_uncached[T](node: Uop[T]) -> TensorData[T]:
    if node.op == Ops.BUFFER:
        return node.buffers[0]
    elif node.op == Ops.ADD:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        rhs = evaluate(cast(Uop[T], node.src[1]))
        return lhs + rhs
    elif node.op == Ops.SUB:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        rhs = evaluate(cast(Uop[T], node.src[1]))
        return lhs - rhs
    elif node.op == Ops.MUL:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        rhs = evaluate(cast(Uop[T], node.src[1]))
        return lhs * rhs
    elif node.op == Ops.DIV:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        rhs = evaluate(cast(Uop[T], node.src[1]))
        return lhs / rhs
    elif node.op == Ops.MATMUL:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        rhs = evaluate(cast(Uop[T], node.src[1]))
        return lhs @ rhs
    elif node.op == Ops.WHERE:
        condition = evaluate(cast(Uop[bool], node.src[0]))
        lhs = evaluate(cast(Uop[T], node.src[1]))
        rhs = evaluate(cast(Uop[T], node.src[2]))
        return TensorData.where(condition, lhs, rhs)
    elif node.op == Ops.GT:
        # ughhh why do we need f32...
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs > rhs
    elif node.op == Ops.EXP:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        return lhs.exp()
    elif node.op == Ops.SUM:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        return lhs.sum(node.axis)
    elif node.op == Ops.MAX:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        return lhs.max(node.axis)
    elif node.op == Ops.ARGMAX:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        return lhs.argmax(node.axis)
    elif node.op == Ops.BROADCAST:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        return lhs.broadcast_to(node.shape)
    elif node.op == Ops.TRANSPOSE:
        lhs = evaluate(cast(Uop[T], node.src[0]))
        return lhs.transpose()
