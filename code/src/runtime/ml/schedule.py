from ml.uop import Uop
from ml.ops import Ops

class KernelPlan[T]:
    def __init__(self, root: Uop[T], inputs: list[Uop]) -> None:
        self.root: Uop[T] = root
        self.inputs: list[Uop] = inputs

# FIXME: tuple __equal__ should own this logic
def same_shape(a: Uop, b: Uop) -> bool:
    return a.shape[0] == b.shape[0] and a.shape[1] == b.shape[1]

def schedule[T](root: Uop[T]) -> KernelPlan[T]:
    if root.op == Ops.SUB:
        a = root.src[0]
        bc = cast(Uop[T], root.src[1])
        if bc.op == Ops.MUL and len(bc.buffers) == 0:
            b = bc.src[0]
            c = bc.src[1]
            if same_shape(root, a) and same_shape(root, bc) and same_shape(root, b) and same_shape(root, c):
                return KernelPlan(root, [a, b, c])
    if root.op == Ops.WHERE:
        bc = cast(Uop[bool], root.src[0])
        if bc.op == Ops.GT and len(bc.buffers) == 0:
            a = bc.src[0]
            b = bc.src[1]
            x = root.src[1]
            y = root.src[2]
            return KernelPlan(root, [a, b, x, y])

    return KernelPlan(root, root.src)
