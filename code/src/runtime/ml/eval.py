from ml.uop import Uop
from ml.data import TensorData
from ml.ops import Ops
from ml.schedule import schedule
from ml.schedule import KernelPlan

def evaluate[T](node: Uop[T]) -> TensorData[T]:
    if len(node.buffers) > 0:
        return node.buffers[0]

    plan = schedule(node)
    res = execute(plan)
    # execute plan here for now
    node.buffers.append(res)
    return res

def execute[T](plan: KernelPlan[T]) -> TensorData[T]:
    node = plan.root
    if node.op == Ops.SUB and len(plan.inputs) == 3:
        rhs = node.src[1]
        if rhs.op == Ops.MUL:
            a = evaluate(cast(Uop[T], plan.inputs[0]))
            b = evaluate(cast(Uop[T], plan.inputs[1]))
            c = evaluate(cast(Uop[T], plan.inputs[2]))
            return a.sub_mul(b, c)
    if node.op == Ops.WHERE and len(plan.inputs) == 4:
        condition = node.src[0]
        if condition.op == Ops.GT:
            a = evaluate(cast(Uop[f32], plan.inputs[0]))
            b = evaluate(cast(Uop[f32], plan.inputs[1]))
            x = evaluate(cast(Uop[T], plan.inputs[2]))
            y = evaluate(cast(Uop[T], plan.inputs[3]))
            return TensorData.where_gt(a, b, x, y)
    return evaluate_uncached(node)

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
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs > rhs
    elif node.op == Ops.GE:
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs >= rhs
    elif node.op == Ops.LT:
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs < rhs
    elif node.op == Ops.LE:
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs <= rhs
    elif node.op == Ops.EQ:
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs == rhs
    elif node.op == Ops.NE:
        lhs = evaluate(cast(Uop[f32], node.src[0]))
        rhs = evaluate(cast(Uop[f32], node.src[1]))
        return lhs != rhs
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
