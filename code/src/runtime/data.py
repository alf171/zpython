from indexing import index_2d
from kernels import add as _add_gpu
from kernels import sub as _sub_gpu
from kernels import mul as _mul_gpu
from kernels import div as _div_gpu
from kernels import matmul as _matmul_gpu
from kernels import relu as _relu_gpu
from kernels import exp as _exp_gpu
from kernels import sum_rows as _sum_rows_gpu
from kernels import sum_cols as _sum_cols_gpu
from kernels import max_rows as _max_rows_gpu
from kernels import max_cols as _max_cols_gpu

class TensorData[T]:
    def __init__(self, data: list[T], shape: tuple[i32, i32]) -> None:
        self.data: list[T] = data
        self.rows: i32 = shape[0]
        self.cols: i32 = shape[1]
        self.row_stride: i32 = shape[1]
        self.col_stride: i32 = 1

    @staticmethod
    def _view[U](data: list[U], rows: i32, cols: i32, row_stride: i32, col_stride: i32) -> TensorData[U]:
        res = TensorData(data, (rows, cols))
        res.row_stride = row_stride
        res.col_stride = col_stride
        return res

    def broadcast_to(self, shape: tuple[i32, i32]) -> TensorData[T]:
        rows, cols = shape
        row_stride = 0 if self.rows == 1 and rows != 1 else self.row_stride
        col_stride = 0 if self.cols == 1 and cols != 1 else self.col_stride
        return TensorData._view(self.data, rows, cols, row_stride, col_stride)

    def transpose(self) -> TensorData[T]:
        return TensorData._view(self.data, self.cols, self.rows, self.col_stride, self.row_stride)

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
    def fill[U](shape: tuple[i32, i32], value: U) -> TensorData[U]:
        count: int =  shape[0] * shape[1]
        return TensorData([value] * count, shape)

    def __add__(self, other: TensorData[T]) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _add_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __sub__(self, other: TensorData[T]) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _sub_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __mul__(self, other: TensorData[T]) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _mul_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __truediv__(self, other: TensorData[T]) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _div_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __matmul__(self, other: TensorData[T]) -> TensorData[T]:
        zero: T = 0
        # (i, k)
        res = TensorData.fill((self.rows, other.cols), zero)
        _matmul_gpu(res, self, other, (self.rows, other.cols, 1))
        return res

    def relu(self) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _relu_gpu(res, self, (self.rows, self.cols, 1)
        )
        return res

    def exp(self) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _exp_gpu(res.data, self.data, (self.rows * self.cols, 1, 1))
        return res

    # NOTE: consider support axes: list[i32]
    # keep_dims could also be supported once shape is more generic than just 2d always
    def sum(self, axis: i32) -> TensorData[T]:
        zero: T = 0
        if axis == 0:
            out = TensorData.fill((1, self.cols), zero)
            _sum_cols_gpu(out.data, self, (self.cols, 1, 1))
        else:
            out = TensorData.fill((self.rows, 1), zero)
            _sum_rows_gpu(out.data, self, (self.rows, 1, 1))
        return out

    def max(self, axis: i32) -> TensorData[T]:
        zero: T = 0
        if axis == 0:
            out = TensorData.fill((1, self.cols), zero)
            _max_cols_gpu(out.data, self, (self.cols, 1, 1))
        else:
            out = TensorData.fill((self.rows, 1), zero)
            _max_rows_gpu(out.data, self, (self.rows, 1, 1))
        return out

    def print(self) -> None:
        for i in range(self.rows):
            for j in range(self.cols):
                print(self[i, j], end=" ")
        print("\n", end="")

