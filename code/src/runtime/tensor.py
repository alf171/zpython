from backward import add as backwards_add
from backward import sub as backwards_sub
from backward import mul as backwards_mul
from backward import sum as backwards_sum
from backward import broadcast_to as backwards_broadcast_to
from data import TensorData
from ops import Ops
from uop import Uop
from eval import evaluate

class Tensor[T]:
    def __init__(self, data: array[T], shape: tuple[i32, i32]) -> None:
        td: TensorData[T] = TensorData(data, shape)
        buffers: list[TensorData[T]] = [td]
        # sources: array[]
        self.uop: Uop[T] = Uop([], buffers, Ops.BUFFER, shape, 0)
        # info for backwards pass
        zero: T = 0
        self.grad: TensorData[T] = TensorData.fill(shape, zero)

    @staticmethod
    def _init[U](uop: Uop[U]) -> Tensor[U]:
        result: Tensor[U] = Tensor.__new__(Tensor)
        result.uop: Uop[U] = uop
        zero: U = 0
        result.grad: TensorData[U] = TensorData.fill(uop.shape, zero)
        return result

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Tensor[U]:
        data = TensorData.fill(shape, value)
        uop: Uop[U] = Uop([], [data], Ops.BUFFER, shape, 0)
        return Tensor._init(uop)

    def realize(self) -> TensorData[T]:
        return evaluate(self.uop)

    def broadcast_to(self, shape: tuple[i32, i32]) -> Tensor[T]:
        uop = Uop([self.uop], [], Ops.BROADCAST, shape, 0)
        res = Tensor._init(uop)
        return res

    def transpose(self) -> Tensor[T]:
        uop = Uop([self.uop], [], Ops.TRANSPOSE, self.uop.shape, 0)
        return Tensor._init(uop)

    def __getitem__(self, idxs: tuple[i32, i32]) -> T:
        return self.realize()[idxs]

    # yeah this wont work...
    def __setitem__(self, idxs: tuple[i32, i32], value: T) -> None:
        self.realize()[idxs] = value

    def __gt__(self, other: Tensor[T]) -> Tensor[bool]:
        view = self.realize() > other.realize()
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __ge__(self, other: Tensor[T]) -> Tensor[bool]:
        view = self.realize() >= other.realize()
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __lt__(self, other: Tensor[T]) -> Tensor[bool]:
        view = self.realize() < other.realize()
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __le__(self, other: Tensor[T]) -> Tensor[bool]:
        view = self.realize() <= other.realize()
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __eq__(self, other: Tensor[T]) -> Tensor[bool]:
        view = self.realize() == other.realize()
        sources: list[Uop[bool]] = []
        uop = Uop(sources, [view], Ops.BUFFER, (view.rows, view.cols), 0)
        return Tensor._init(uop)

    def __ne__(self, other: Tensor[T]) -> Tensor[bool]:
        view = self.realize() != other.realize()
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
        uop = Uop([self.uop, other.uop], [], Ops.MUL, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def __truediv__(self, other: Tensor[T]) -> Tensor[T]:
        uop = Uop([self.uop, other.uop], [], Ops.DIV, self.uop.shape, 0)
        res = Tensor._init(uop)
        return res

    def __matmul__(self, other: Tensor[T]) -> Tensor[T]:
        uop = Uop([self.uop, other.uop], [], Ops.MATMUL, self.uop.shape, 0)
        res = Tensor._init(uop)
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
        uop = Uop([self.uop], [], Ops.SUM, self.uop.shape, axis)
        res = Tensor._init(uop)
        return res

    def max(self, axis: i32) -> Tensor[T]:
        uop = Uop([self.uop], [], Ops.MAX, self.uop.shape, axis)
        res = Tensor._init(uop)
        return res

    def __print__(self, end:str="\n") -> None:
        print(self.realize(), end=end)

    def print_shape(self) -> None:
        print("(", end = "")
        print(self.realize().rows, end=", ")
        print(self.realize().cols, end="")
        print(")", end="\n")

