from tensor import Tensor
from indexing import index_2d

@gpu
def add[U](out: Tensor[U], a: Tensor[U], b: Tensor[U]) -> None:
    row = global_id(0)
    col = global_id(1)

    out_i = index_2d(row, col, out.row_stride, out.col_stride)
    a_i = index_2d(row, col, a.row_stride, a.col_stride)
    b_i = index_2d(row, col, b.row_stride, b.col_stride)
    out.data[out_i] = a.data[a_i] + b.data[b_i]

@gpu
def sub[U](out: Tensor[U], a: Tensor[U], b: Tensor[U]) -> None:
    row = global_id(0)
    col = global_id(1)

    out_i = index_2d(row, col, out.row_stride, out.col_stride)
    a_i = index_2d(row, col, a.row_stride, a.col_stride)
    b_i = index_2d(row, col, b.row_stride, b.col_stride)
    out.data[out_i] = a.data[a_i] - b.data[b_i]

@gpu
def mul[U](out: Tensor[U], a: Tensor[U], b: Tensor[U]) -> None:
    row = global_id(0)
    col = global_id(1)

    out_i = index_2d(row, col, out.row_stride, out.col_stride)
    a_i = index_2d(row, col, a.row_stride, a.col_stride)
    b_i = index_2d(row, col, b.row_stride, b.col_stride)
    out.data[out_i] = a.data[a_i] * b.data[b_i]

@gpu
def div[U](out: Tensor[U], a: Tensor[U], b: Tensor[U]) -> None:
    row = global_id(0)
    col = global_id(1)

    out_i = index_2d(row, col, out.row_stride, out.col_stride)
    a_i = index_2d(row, col, a.row_stride, a.col_stride)
    b_i = index_2d(row, col, b.row_stride, b.col_stride)
    out.data[out_i] = a.data[a_i] / b.data[b_i]

@gpu
# (i, j) @ (j,k) = (i,k)
def matmul[U](out: list[U], a: list[U], b: list[U], J: i32, K: i32) -> None:
    i = global_id(0)
    k = global_id(1)
    acc: U = 0
    for j in range(J):
        a_i = index_2d(i, j, J, 1)
        b_i = index_2d(j, k, K, 1) 
        acc += a[a_i] * b[b_i]

    # (i, k)
    out[i * K + k] = acc

@gpu
def relu[U](out: list[U], a: list[U]) -> None:
    i = global_id(0)
    zero: U = 0
    out[i] = max(a[i], zero)

@gpu
# a bit hacky for rdna3 :)
def exp[U](out: list[U], a: list[U]) -> None:
    i = global_id(0)
    log2_e: f32 = 1.4426950408889634
    out[i] = exp2(a[i] * log2_e)

@gpu
def sum_cols[U](out: list[U], a: list[U], rows: i32, row_stride: i32, col_stride: i32) -> None:
    col = global_id(0)
    total: U = 0

    for row in range(rows):
        total += a[index_2d(row, col, row_stride, col_stride)]

    out[col] = total

@gpu
def sum_rows[U](out: list[U], a: list[U], cols: i32, row_stride: i32, col_stride: i32) -> None:
    row = global_id(0)
    total: U = 0

    for col in range(cols):
        total += a[index_2d(row, col, row_stride, col_stride)]

    out[row] = total

@gpu
def max_cols[U](out: list[U], a: list[U], rows: i32, row_stride: i32, col_stride: i32) -> None:
    col = global_id(0)
    best: U = a[index_2d(0, col, row_stride, col_stride)]

    for row in range(1, rows):
        best = max(best, a[index_2d(row, col, row_stride, col_stride)])

    out[col] = best

@gpu
def max_rows[U](out: list[U], a: list[U], cols: i32, row_stride: i32, col_stride: i32) -> None:
    row = global_id(0)
    best: U = a[index_2d(row, 0, row_stride, col_stride)]

    for col in range(1, cols):
        best = max(best, a[index_2d(row, col, row_stride, col_stride)])

    out[row] = best
