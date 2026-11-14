from ml.indexing import index_2d
from ml.kernels import gt as _gt_gpu
from ml.kernels import ge as _ge_gpu
from ml.kernels import lt as _lt_gpu
from ml.kernels import le as _le_gpu
from ml.kernels import eq as _eq_gpu
from ml.kernels import ne as _ne_gpu
from ml.kernels import add as _add_gpu
from ml.kernels import sub as _sub_gpu
from ml.kernels import mul as _mul_gpu
from ml.kernels import div as _div_gpu
from ml.kernels import matmul as _matmul_gpu
from ml.kernels import where as _where_gpu
from ml.kernels import exp as _exp_gpu
from ml.kernels import sum_rows as _sum_rows_gpu
from ml.kernels import sum_cols as _sum_cols_gpu
from ml.kernels import max_rows as _max_rows_gpu
from ml.kernels import max_cols as _max_cols_gpu
from ml.kernels import argmax_rows as _argmax_rows_gpu
from ml.kernels import argmax_cols as _argmax_cols_gpu
from random import randn

class TensorData[T]:
    def __init__(self, data: array[T], shape: tuple[i32, i32]) -> None:
        self.data: array[T] = data
        self.rows: i32 = shape[0]
        self.cols: i32 = shape[1]
        self.row_stride: i32 = shape[1]
        self.col_stride: i32 = 1

    @staticmethod
    def _view[U](data: array[U], rows: i32, cols: i32, row_stride: i32, col_stride: i32) -> TensorData[U]:
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

    @inline
    def __getitem__(self, idxs: tuple[i32, i32]) -> T:
        return self.load(idxs[0], idxs[1])

    # HACK: tuple on gpu doesn't work b/c it requires a function call to malloc
    @inline
    def load(self, row: i32, col: i32) -> T:
        index = index_2d(row, col, self.row_stride, self.col_stride)
        return self.data[index]

    @inline
    def __setitem__(self, idxs: tuple[i32, i32], value: T) -> None:
        self.store(idxs[0], idxs[1], value)

    # HACK: tuple on gpu doesn't work b/c it requires a function call to malloc
    @inline
    def store(self, row: i32, col: i32, value: T) -> None:
        index = index_2d(row, col, self.row_stride, self.col_stride)
        self.data[index] = value

    def __gt__(self, other: TensorData[T]) -> TensorData[bool]:
        res = TensorData.fill((self.rows, self.cols), False)
        _gt_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __ge__(self, other: TensorData[T]) -> TensorData[bool]:
        res = TensorData.fill((self.rows, self.cols), False)
        _ge_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __lt__(self, other: TensorData[T]) -> TensorData[bool]:
        res = TensorData.fill((self.rows, self.cols), False)
        _lt_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __le__(self, other: TensorData[T]) -> TensorData[bool]:
        res = TensorData.fill((self.rows, self.cols), False)
        _le_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __eq__(self, other: TensorData[T]) -> TensorData[bool]:
        res = TensorData.fill((self.rows, self.cols), False)
        _eq_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    def __ne__(self, other: TensorData[T]) -> TensorData[bool]:
        res = TensorData.fill((self.rows, self.cols), False)
        _ne_gpu(res, self, other, (self.rows, self.cols, 1))
        return res

    @staticmethod
    def fill[U](shape: tuple[i32, i32], value: U) -> TensorData[U]:
        count: int = shape[0] * shape[1]
        data: array[U] = array_empty(count)
        for i in range(count):
            data[i] = value
        return TensorData(data, shape)

    @staticmethod
    def randn(shape: tuple[i32, i32]) -> TensorData[f32]:
        count: int = shape[0] * shape[1]
        data: array[f32] = array_empty(count)
        for i in range(count):
            data[i] = randn()
        return TensorData(data, shape)

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

    @staticmethod
    def where[U](condition: TensorData[bool], lhs: TensorData[U], rhs: TensorData[U]) -> TensorData[U]:
        zero: U = 0
        res = TensorData.fill((lhs.rows, lhs.cols), zero)
        _where_gpu(res, condition, lhs, rhs, (lhs.rows, lhs.cols, 1))
        return res

    def exp(self) -> TensorData[T]:
        zero: T = 0
        res = TensorData.fill((self.rows, self.cols), zero)
        _exp_gpu(res.data, self.data, (self.rows * self.cols, 1, 1))
        return res

    # NOTE: consider support axes: array[i32]
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

    def argmax(self, axis: i32) -> TensorData[i32]:
        zero: i32 = 0
        if axis == 0:
            out = TensorData.fill((1, self.cols), zero)
            _argmax_cols_gpu(out.data, self, (self.cols, 1, 1))
        else:
            out = TensorData.fill((self.rows, 1), zero)
            _argmax_rows_gpu(out.data, self, (self.rows, 1, 1))
        return out

    def __print__(self, end:str="\n") -> None:
        for i in range(self.rows):
            for j in range(self.cols):
                print(self[i, j], end=" ")
        print(end, end="")

