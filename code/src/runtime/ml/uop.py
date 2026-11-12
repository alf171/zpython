from ml.tensor import Tensor
from ml.ops import Ops
from ml.eval import evaluate

# FIXME: support tagged unions to remove args like axis
class Uop[T]():
    def __init__(self, src: list[Uop], op: Ops, shape: tuple[i32, i32], axis: i32) -> None:
        self.src: list[Uop] = src
        self.buffers: list[TensorData[T]] = []
        self.op: Ops = op
        self.shape: tuple[i32, i32] = shape
        self.axis: i32 = axis
        # FIXME: communicate this with `all_tensors` global
        self.owners: list[Tensor[T]] = []

    @staticmethod
    def from_data[U](data: TensorData[U]) -> Uop[U]:
        sources: list[Uop[U]] = []
        node: Uop[U] = Uop(sources, Ops.BUFFER, (data.rows, data.cols), 0)
        node.buffers.append(data)
        return node

    def toposort(self) -> list[Uop]:
        visited: dict[Uop, bool] = {}
        order: list[Uop] = []
        Uop._visit(self, visited, order)
        return order

    @staticmethod
    def _visit(self: Uop, visited: dict[Uop, bool], order: list[Uop]) -> None:
        if self in visited:
            return

        for source in self.src:
            Uop._visit(source, visited, order)

        visited[self] = True
        order.append(self)

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Uop[U]:
        data = TensorData.fill(shape, value)
        return Uop.from_data(data)

    def __print__(self, end:str="\n") -> None:
        print(evaluate(self), end=end)

    def __gt__(self, other: Uop[T]) -> Uop[bool]:
        return Uop([self, other], Ops.GT, self.shape, 0)

    def __ge__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) >= evaluate(other)
        return Uop.from_data(view)

    def __lt__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) < evaluate(other)
        return Uop.from_data(view)

    def __le__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) <= evaluate(other)
        return Uop.from_data(view)

    def eq(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) == evaluate(other)
        return Uop.from_data(view)

    def ne(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) != evaluate(other)
        return Uop.from_data(view)

    def transpose(self) -> Uop[T]:
        shape = (self.shape[1], self.shape[0])
        return Uop([self], Ops.TRANSPOSE, shape, 0)

    def broadcast_to(self, shape: tuple[i32, i32]) -> Uop[T]:
        return Uop([self], Ops.BROADCAST, shape, 0)

    @staticmethod
    def where[U](condition: Uop[bool], lhs: Uop[U], rhs: Uop[U]) -> Uop[U]:
        return Uop([condition, lhs, rhs], Ops.WHERE, lhs.shape, 0)

    def __mul__(self, other: Uop[T]) -> Uop[T]:
        return Uop([self, other], Ops.MUL, self.shape, 0)

    def __truediv__(self, other: Uop[T]) -> Uop[T]:
        return Uop([self, other], Ops.DIV, self.shape, 0)

    def __pow__(self, other: Uop[T]) -> Uop[T]:
        return Uop([self, other], Ops.POW, self.shape, 0)

    def __matmul__(self, other: Uop[T]) -> Uop[T]:
        shape = (self.shape[0], other.shape[1])
        return Uop([self, other], Ops.MATMUL, shape, 0)

    def __neg__(self) -> Tensor[T]:
        minus_one_t: T = -1
        minus_one = Uop.fill(self.shape, minus_one_t)
        return self * minus_one

    def sum(self, axis: i32) -> Uop[T]:
        shape = (self.shape[0], 1) if axis == 1 else (1, self.shape[1])
        return Uop([self], Ops.SUM, shape, axis)

    def max(self, axis: i32) -> Uop[T]:
        shape = (self.shape[0], 1) if axis == 1 else (1, self.shape[1])
        return Uop([self], Ops.MAX, shape, axis)

    def argmax(self, axis: i32) -> Uop[T]:
        shape = (self.shape[0], 1) if axis == 1 else (1, self.shape[1])
        return Uop([self], Ops.ARGMAX, shape, axis)
