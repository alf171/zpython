from tensor import Tensor
from ops import Ops
from eval import evaluate

# FIXME: support tagged unions to remove args like axis
class Uop[T]():
    def __init__(
            self,
            src: list[Uop[T]],
            buffers: list[TensorData[T]],
            op: Ops,
            shape: tuple[i32, i32],
            axis: i32,
    ) -> None:
        self.src: list[Uop[T]] = src
        self.buffers: list[TensorData[T]] = buffers
        self.op: Ops = op
        self.shape: tuple[i32, i32] = shape
        self.axis: i32 = axis

    def toposort(self) -> list[Uop[T]]:
        visited: dict[Uop[T], bool] = {}
        order: list[Uop[T]] = []
        Uop._visit(self, visited, order)
        return order

    @staticmethod
    def _visit[U](self: Uop[U], visited: dict[Uop[U], bool], order: list[Uop[U]]) -> None:
        if self in visited:
            return

        for source in self.src:
            Uop._visit(source, visited, order)

        visited[self] = True
        order.append(self)

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Uop[U]:
        data = TensorData.fill(shape, value)
        sources: list[Uop[U]] = []
        return Uop(sources, [data], Ops.BUFFER, shape, 0)

    def __print__(self, end:str="\n") -> None:
        print(evaluate(self), end=end)

    def __gt__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) > evaluate(other)
        sources: list[Uop[bool]] = []
        return Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)

    def __ge__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) >= evaluate(other)
        sources: list[Uop[bool]] = []
        return Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)

    def __lt__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) < evaluate(other)
        sources: list[Uop[bool]] = []
        return Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)

    def __le__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) <= evaluate(other)
        sources: list[Uop[bool]] = []
        return Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)

    def __eq__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) == evaluate(other)
        sources: list[Uop[bool]] = []
        return Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)

    def __ne__(self, other: Uop[T]) -> Uop[bool]:
        view = evaluate(self) != evaluate(other)
        sources: list[Uop[bool]] = []
        return Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)

    def transpose(self) -> Uop[T]:
        shape = (self.shape[1], self.shape[0])
        return Uop([self], [], Ops.TRANSPOSE, shape, 0)

    def broadcast_to(self, shape: tuple[i32, i32]) -> Uop[T]:
        return Uop([self], [], Ops.BROADCAST, shape, 0)

    def where[U](self, if_true: Uop[U], if_false: Uop[U]) -> Uop[U]:
        return Uop([self, if_true, if_false], [], Ops.WHERE, self.shape, 0)

    def __mul__(self, other: Uop[T]) -> Uop[T]:
        return Uop([self, other], [], Ops.MUL, self.shape, 0)

    def __truediv__(self, other: Uop[T]) -> Uop[T]:
        return Uop([self, other], [], Ops.DIV, self.shape, 0)

    def __pow__(self, other: Uop[T]) -> Uop[T]:
        return Uop([self, other], [], Ops.POW, self.shape, 0)

    def __matmul__(self, other: Uop[T]) -> Uop[T]:
        shape = (self.shape[0], other.shape[1])
        return Uop([self, other], [], Ops.MATMUL, shape, 0)

    def sum(self, axis: i32) -> Uop[T]:
        shape = (self.shape[0], 1) if axis == 1 else (1, self.shape[1])
        return Uop([self], [], Ops.SUM, shape, axis)
