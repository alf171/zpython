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

    # FIXME: clearer with dicts
    def toposort(self, capacity: i32) -> array[Uop[T]]:
        order: array[Uop[T]] = [self] * capacity
        count = Uop._visit(self, order, 0)
        # copy to a result
        result: array[Uop[T]] = [self] * count
        for i in range(count):
            result[i] = order[i]
        return result

    @staticmethod
    def _visit[U](self: Uop[U], order: array[Uop[U]], count: i32) -> i32:
        for i in range(count):
            if order[i] == self:
                return count

        for source in self.src:
            count = Uop._visit(source, order, count)

        order[count] = self
        return count + 1
