from backward import add as backwards_add
from backward import sub as backwards_sub
from backward import mul as backwards_mul
from data import TensorData

class Tensor[T]:
    def __init__(self, data: list[T], shape: tuple[i32, i32]) -> None:
        self.view: TensorData[T] = TensorData(data, shape)
        # info for backwards pass
        zero: f32 = 0
        self.grad: TensorData[f32] = TensorData([zero] * (shape[0] * shape[1]), shape)
        self.backward: Callable[[], None] = lambda: None

    @staticmethod
    def _init[U](view: TensorData[U]) -> Tensor[U]:
        result = Tensor(view.data, (view.rows, view.cols))
        # HACK: need to preserve stride
        result.view = view
        return result

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Tensor[U]:
        return Tensor._init(TensorData.fill(shape, value))

    def broadcast_to(self, shape: tuple[i32, i32]) -> Tensor[T]:
        return Tensor._init(self.view.broadcast_to(shape))

    def transpose(self) -> Tensor[T]:
        return Tensor._init(self.view.transpose())

    def __getitem__(self, idxs: tuple[i32, i32]) -> T:
        return self.view[idxs]

    def __setitem__(self, idxs: tuple[i32, i32], value: T) -> None:
        self.view[idxs] = value

    def __add__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.view + other.view)
        res.backward: Callable[[], None] = lambda: backwards_add(res, self, other)
        return res

    def __sub__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.view - other.view)
        res.backward: Callable[[], None] = lambda: backwards_sub(res, self, other)
        return res

    def __mul__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.view * other.view)
        res.backward: Callable[[], None] = lambda: backwards_mul(res, self, other)
        return res

    def __truediv__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.view / other.view)
        return res

    def __matmul__(self, other: Tensor[T]) -> Tensor[T]:
        res = Tensor._init(self.view @ other.view)
        return res

    def relu(self) -> Tensor[T]:
        res = Tensor._init(self.view.relu())
        return res

    def exp(self) -> Tensor[T]:
        res = Tensor._init(self.view.exp())
        return res

    def sum(self, axis: i32) -> Tensor[T]:
        res = Tensor._init(self.view.sum(axis))
        return res

    def max(self, axis: i32) -> Tensor[T]:
        res = Tensor._init(self.view.max(axis))
        return res

    def print(self) -> None:
        self.view.print()

    def print_shape(self) -> None:
        print("(", end = "")
        print(self.view.rows, end=", ")
        print(self.view.cols, end="")
        print(")", end="\n")

