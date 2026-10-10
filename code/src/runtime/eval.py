from uop import Uop
from data import TensorData
from ops import Ops

def evaluate[T](node: Uop[T]) -> TensorData[T]:
    if node.op == Ops.BUFFER:
        return node.buffers[0]
    elif node.op == Ops.ADD:
        lhs = evaluate(node.src[0])
        rhs = evaluate(node.src[1])
        return lhs + rhs
    elif node.op == Ops.SUB:
        lhs = evaluate(node.src[0])
        rhs = evaluate(node.src[1])
        return lhs - rhs
    elif node.op == Ops.MUL:
        lhs = evaluate(node.src[0])
        rhs = evaluate(node.src[1])
        return lhs * rhs
    elif node.op == Ops.DIV:
        lhs = evaluate(node.src[0])
        rhs = evaluate(node.src[1])
        return lhs / rhs
    elif node.op == Ops.MATMUL:
        lhs = evaluate(node.src[0])
        rhs = evaluate(node.src[1])
        return lhs @ rhs
    elif node.op == Ops.RELU:
        lhs = evaluate(node.src[0])
        return lhs.relu()
    elif node.op == Ops.EXP:
        lhs = evaluate(node.src[0])
        return lhs.exp()
    elif node.op == Ops.SUM:
        lhs = evaluate(node.src[0])
        return lhs.sum(node.axis)
    elif node.op == Ops.MAX:
        lhs = evaluate(node.src[0])
        return lhs.max(node.axis)
    elif node.op == Ops.BROADCAST:
        lhs = evaluate(node.src[0])
        return lhs.broadcast_to(node.shape)
    elif node.op == Ops.TRANSPOSE:
        lhs = evaluate(node.src[0])
        return lhs.transpose()
