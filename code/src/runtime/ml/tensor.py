from ml.data import TensorData
from ml.ops import Ops
from ml.uop import Uop
from ml.eval import evaluate
from ml.backward import grad_rule

class Tensor[T]:
    def __init__(self, data: array[T], shape: tuple[i32, i32]) -> None:
        td: TensorData[T] = TensorData(data, shape)
        self.uop: Uop[T] = Uop.from_data(td)
        self.uop.owners.append(self)
        # optional gradient
        self.grad: Tensor[T] | None = None

    @staticmethod
    def _init[U](uop: Uop[U]) -> Tensor[U]:
        result: Tensor[U] = Tensor.__new__(Tensor)
        result.uop: Uop[U] = uop
        uop.owners.append(result)
        zero: U = 0
        result.grad: Tensor[U] | None = None
        return result

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Tensor[U]:
        return Tensor._init(Uop.fill(shape, value))

    @staticmethod
    def randn(shape: tuple[i32, i32]) -> Tensor[f32]:
        data = TensorData.randn(shape)
        uop: Uop[f32] = Uop.from_data(data)
        return Tensor._init(uop)

    def assign(self, value: Tensor[T]) -> Tensor[T]:
        data = evaluate(value.uop)
        uop = Uop.from_data(data)
        self.uop = uop
        uop.owners.append(self)
        return self

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
                    grads[source] = Uop([grads[source], incoming], Ops.ADD, source.shape, 0)
                else:
                    grads[source] = incoming

        targets: list[Tensor[T]] = []
        for node in uops:
            for owner in node.owners:
                targets.append(owner)

        for tensor in targets:
            if tensor.uop in grads:
                tensor.grad = Tensor._init(grads[tensor.uop])

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
        return Tensor._init(self.uop > other.uop)

    def __ge__(self, other: Tensor[T]) -> Tensor[bool]:
        return Tensor._init(self.uop >= other.uop)

    def __lt__(self, other: Tensor[T]) -> Tensor[bool]:
        return Tensor._init(self.uop < other.uop)

    def __le__(self, other: Tensor[T]) -> Tensor[bool]:
        return Tensor._init(self.uop <= other.uop)

    def __eq__(self, other: Tensor[T]) -> Tensor[bool]:
        return Tensor._init(self.uop.eq(other.uop))

    def __ne__(self, other: Tensor[T]) -> Tensor[bool]:
        return Tensor._init(self.uop.ne(other.uop))

    def __add__(self, other: Tensor[T]) -> Tensor[T]:
        uop = Uop([self.uop, other.uop], Ops.ADD, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def __sub__(self, other: Tensor[T]) -> Tensor[T]:
        uop = Uop([self.uop, other.uop], Ops.SUB, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def __mul__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.uop * other.uop)
        return res

    def __truediv__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.uop / other.uop)
        return res

    def __matmul__(self, other: Tensor[T]) -> Tensor[T]:
        return Tensor._init(self.uop @ other.uop)

    def __neg__(self) -> Tensor[T]:
        return Tensor._init(-self.uop)

    @staticmethod
    def where[U](condition: Tensor[bool], lhs: Tensor[U], rhs: Tensor[U]) -> Tensor[U]:
        return Tensor._init(Uop.where(condition.uop, lhs.uop, rhs.uop))

    def relu(self) -> Tensor[T]:
        zero: T = 0
        zeros = Tensor.fill(self.uop.shape, zero)
        return Tensor.where(self > zeros, self, zeros)

    def exp(self) -> Tensor[T]:
        uop = Uop([self.uop], Ops.EXP, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def sum(self, axis: i32) -> Tensor[T]:
        return Tensor._init(self.uop.sum(axis))

    def max(self, axis: i32) -> Tensor[T]:
        return Tensor._init(self.uop.max(axis))

    def argmax(self, axis: i32) -> Tensor[i32]:
        # HACK: eager
        values = evaluate(self.uop)
        indicies = values.argmax(axis)
        return Tensor._init(Uop.from_data(indicies))

    def __print__(self, end:str="\n") -> None:
        print(self.uop, end=end)

    def print_shape(self) -> None:
        print("(", end = "")
        realized = evaluate(self.uop)
        print(realized.rows, end=", ")
        print(realized.cols, end="")
        print(")", end="\n")

