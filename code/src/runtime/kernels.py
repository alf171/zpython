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
def matmul[U](out: Tensor[U], a: Tensor[U], b: Tensor[U]) -> None:
    i = global_id(0)
    k = global_id(1)

    acc: U = 0
    for j in range(a.cols):
        a_i = index_2d(i, j, a.row_stride, a.col_stride)
        b_i = index_2d(j, k, b.row_stride, b.col_stride) 
        acc += a.data[a_i] * b.data[b_i]

    # (i, k)
    out_i = index_2d(i, k, out.row_stride, out.col_stride)
    out.data[out_i] = acc

@gpu
def relu[U](out: Tensor[U], a: Tensor[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    zero: U = 0
    out_i = index_2d(row, col, out.row_stride, out.col_stride)
    a_i = index_2d(row, col, a.row_stride, a.col_stride)
    out.data[out_i] = max(a.data[a_i], zero)

@gpu
# a bit hacky for rdna3 :)
def exp[U](out: list[U], a: list[U]) -> None:
    i = global_id(0)
    log2_e: f32 = 1.4426950408889634
    out[i] = exp2(a[i] * log2_e)

@gpu
def sum_cols[U](out: list[U], a: Tensor[U]) -> None:
    col = global_id(0)
    total: U = 0

    for row in range(a.rows):
        total += a.data[index_2d(row, col, a.row_stride, a.col_stride)]

    out[col] = total

@gpu
def sum_rows[U](out: list[U], a: Tensor[U]) -> None:
    row = global_id(0)
    total: U = 0

    for col in range(a.cols):
        total += a.data[index_2d(row, col, a.row_stride, a.col_stride)]

    out[row] = total

@gpu
def max_cols[U](out: list[U], a: Tensor[U]) -> None:
    col = global_id(0)
    best: U = a.data[index_2d(0, col, a.row_stride, a.col_stride)]

    for row in range(1, a.rows):
        best = max(best, a.data[index_2d(row, col, a.row_stride, a.col_stride)])

    out[col] = best

@gpu
def max_rows[U](out: list[U], a: Tensor[U]) -> None:
    row = global_id(0)
    best: U = a.data[index_2d(row, 0, a.row_stride, a.col_stride)]

    for col in range(1, a.cols):
        best = max(best, a.data[index_2d(row, col, a.row_stride, a.col_stride)])

    out[row] = best
