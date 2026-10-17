from tensor import Tensor
from ops import Ops

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
