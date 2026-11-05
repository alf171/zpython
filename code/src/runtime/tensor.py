from data import TensorData
from ops import Ops
from uop import Uop
from eval import evaluate
from backward import grad_rule

class Tensor[T]:
    def __init__(self, data: array[T], shape: tuple[i32, i32]) -> None:
        td: TensorData[T] = TensorData(data, shape)
        buffers: list[TensorData[T]] = [td]
        # sources: array[]
        self.uop: Uop[T] = Uop([], buffers, Ops.BUFFER, shape, 0)
        # optional gradient
        self.grad: Tensor[T] | None = None

    @staticmethod
    def _init[U](uop: Uop[U]) -> Tensor[U]:
        result: Tensor[U] = Tensor.__new__(Tensor)
        result.uop: Uop[U] = uop
        zero: U = 0
        result.grad: Tensor[U] | None = None
        return result

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Tensor[U]:
        return Tensor._init(Uop.fill(shape, value))

    @staticmethod
    def randn(shape: tuple[i32, i32]) -> Tensor[f32]:
        data = TensorData.randn(shape)
        uop: Uop[f32] = Uop([], [data], Ops.BUFFER, shape, 0)
        return Tensor._init(uop)

    def backward(self, incoming_grad: Tensor[T]) -> None:
        uops = self.uop.toposort()
        grads: dict[Uop[T], Uop[T]] = {self.uop: incoming_grad.uop}
        i = len(uops)
        while i > 0:
            i -= 1
            node = uops[i]
            # skip non differentiable stuff
            if node not in grads:
                continue
            
            contributions = grad_rule(node, grads[node])
            for j in range(len(contributions)):
                source = node.src[j]
                incoming = contributions[j]

                if source in grads:
                    grads[source] = Uop([grads[source], incoming], [], Ops.ADD, source.shape, 0)
                else:
                    grads[source] = incoming

    def broadcast_to(self, shape: tuple[i32, i32]) -> Tensor[T]:
        return Tensor._init(self.uop.broadcast_to(shape))

    def transpose(self) -> Tensor[T]:
        return Tensor._init(self.uop.transpose())

    def __getitem__(self, idxs: tuple[i32, i32]) -> T:
        return evaluate(self.uop)[idxs]

    # yeah this wont work...
    def __setitem__(self, idxs: tuple[i32, i32], value: T) -> None:
        evaluate(self.uop)[idxs] = value

    def __gt__(self, other: Tensor[T]) -> Tensor[bool]:
        view = evaluate(self.uop) > evaluate(other.uop)
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __ge__(self, other: Tensor[T]) -> Tensor[bool]:
        view = evaluate(self.uop) >= evaluate(other.uop)
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __lt__(self, other: Tensor[T]) -> Tensor[bool]:
        view = evaluate(self.uop) < evaluate(other.uop)
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __le__(self, other: Tensor[T]) -> Tensor[bool]:
        view = evaluate(self.uop) <= evaluate(other.uop)
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __eq__(self, other: Tensor[T]) -> Tensor[bool]:
        view = evaluate(self.uop) == evaluate(other.uop)
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __ne__(self, other: Tensor[T]) -> Tensor[bool]:
        view = evaluate(self.uop) != evaluate(other.uop)
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __add__(self, other: Tensor[T]) -> Tensor[T]:
        uop = Uop([self.uop, other.uop], [], Ops.ADD, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def __sub__(self, other: Tensor[T]) -> Tensor[T]:
        uop = Uop([self.uop, other.uop], [], Ops.SUB, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def __mul__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.uop * other.uop)
        return res

    def __truediv__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.uop / other.uop)
        return res

    def __matmul__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.uop @ other.uop)
        return res

    def relu(self) -> Tensor[T]:
        uop = Uop([self.uop], [], Ops.RELU, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def exp(self) -> Tensor[T]:
        uop = Uop([self.uop], [], Ops.EXP, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def sum(self, axis: i32) -> Tensor[T]:
        return Tensor._init(self.uop.sum(axis))

    def max(self, axis: i32) -> Tensor[T]:
        shape = (self.uop.shape[0], 1) if axis == 1 else (1, self.uop.shape[1])
        uop = Uop([self.uop], [], Ops.MAX, shape, axis)
        res = Tensor._init(uop)
        return res

    def __print__(self, end:str="\n") -> None:
        print(self.uop, end=end)

    def print_shape(self) -> None:
        print("(", end = "")
        realized = evaluate(self.uop)
        print(realized.rows, end=", ")
        print(realized.cols, end="")
        print(")", end="\n")

