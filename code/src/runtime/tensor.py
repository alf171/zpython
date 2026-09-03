from indexing import index_2d
from kernels import add as _add_gpu
from kernels import sub as _sub_gpu
from kernels import mul as _mul_gpu
from kernels import matmul as _matmul_gpu
from kernels import relu as _relu_gpu
from kernels import exp as _exp_gpu

class Tensor[T]:
    def __init__(self, data: list[T], shape: tuple[i32, i32]) -> None:
        self.data = data
        self.rows = shape[0]
        self.cols = shape[1]
        self.row_stride = shape[1]
        self.col_stride: i32 = 1

    @staticmethod
    def _view[U](data: list[U], rows: i32, cols: i32, row_stride: i32, col_stride: i32) -> Tensor[U]:
        res = Tensor(data, (rows, cols))
        res.row_stride = row_stride
        res.col_stride = col_stride
        return res

    def transpose(self) -> Tensor[T]:
        return Tensor._view(self.data, self.cols, self.rows, self.col_stride, self.row_stride)

    def __getitem__(self, idxs: tuple[i32, i32]) -> T:
        row = idxs[0]
        col = idxs[1]
        index = index_2d(row, col, self.row_stride, self.col_stride)
        return self.data[index]

    def __setitem__(self, idxs: tuple[i32, i32], value: T) -> None:
        row = idxs[0]
        col = idxs[1]
        index = index_2d(row, col, self.row_stride, self.col_stride)
        self.data[index] = value

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> Tensor[U]:
        count: int =  shape[0] * shape[1]
        return Tensor([value] * count, shape)

    def __add__(self, other: Tensor[T]) -> Tensor[T]:
        zero: T = 0
        res = Tensor.fill((self.rows, self.cols), zero)
        _add_gpu(res.data, self.data, other.data, (self.rows * self.cols, 1, 1))
        return res

    def __sub__(self, other: Tensor[T]) -> Tensor[T]:
        zero: T = 0
        res = Tensor.fill((self.rows, self.cols), zero)
        _sub_gpu(res.data, self.data, other.data, (self.rows * self.cols, 1, 1))
        return res

    def __mul__(self, other: Tensor[T]) -> Tensor[T]:
        zero: T = 0
        res = Tensor.fill((self.rows, self.cols), zero)
        _mul_gpu(res.data, self.data, other.data, (self.rows * self.cols, 1, 1))
        return res

    def __matmul__(self, other: Tensor[T]) -> Tensor[T]:
        zero: T = 0
        # (i, k)
        res = Tensor.fill((self.rows, other.cols), zero)
        _matmul_gpu(
            res.data,
            self.data,
            other.data,
            self.cols,
            other.cols,
           (self.rows, other.cols, 1)
        )
        return res

    def relu(self) -> Tensor[T]:
        zero: T = 0
        res = Tensor.fill((self.rows, self.cols), zero)
        _relu_gpu(
            res.data,
            self.data,
            (self.rows * self.cols, 1, 1)
        )
        return res

    def exp(self) -> Tensor[T]:
        zero: T = 0
        res = Tensor.fill((self.rows, self.cols), zero)
        _exp_gpu(res.data, self.data, (self.rows * self.cols, 1, 1))
        return res
