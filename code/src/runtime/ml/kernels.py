from ml.data import TensorData
from ml.indexing import index_2d

@gpu
def gt[U](out: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) > b.load(row, col))

@gpu
def ge[U](out: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) >= b.load(row, col))

@gpu
def lt[U](out: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) < b.load(row, col))

@gpu
def le[U](out: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) <= b.load(row, col))

@gpu
def eq[U](out: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) == b.load(row, col))

@gpu
def ne[U](out: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) != b.load(row, col))

@gpu
def add[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) + b.load(row, col))

@gpu
def sub[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) - b.load(row, col))

@gpu
def mul[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) * b.load(row, col))

@gpu
def div[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) / b.load(row, col))

@gpu
# (i, j) @ (j,k) = (i,k)
def matmul[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    i = global_id(0)
    k = global_id(1)

    acc: U = 0
    for j in range(a.cols):
        acc += a.load(i, j) * b.load(j, k)

    # (i, k)
    out.store(i, k, acc)

@gpu
def where[U](out: TensorData[U], mask: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    value = a.load(row, col) if mask.load(row, col) else b.load(row, col)
    out.store(row, col, value)

@gpu
# a bit hacky for rdna3 :)
def exp[U](out: array[U], a: array[U]) -> None:
    i = global_id(0)
    log2_e: f32 = 1.4426950408889634
    out[i] = exp2(a[i] * log2_e)

@gpu
def sum_cols[U](out: array[U], a: TensorData[U]) -> None:
    col = global_id(0)
    total: U = 0

    for row in range(a.rows):
        total += a.load(row, col)

    out[col] = total

@gpu
def sum_rows[U](out: array[U], a: TensorData[U]) -> None:
    row = global_id(0)
    total: U = 0

    for col in range(a.cols):
        total += a.load(row, col)

    out[row] = total

@gpu
def max_cols[U](out: array[U], a: TensorData[U]) -> None:
    col = global_id(0)
    best: U = a.load(0, col)

    for row in range(1, a.rows):
        best = max(best, a.load(row, col))

    out[col] = best

@gpu
def max_rows[U](out: array[U], a: TensorData[U]) -> None:
    row = global_id(0)
    best: U = a.load(row, 0)

    for col in range(1, a.cols):
        best = max(best, a.load(row, col))

    out[row] = best

@gpu
def argmax_cols[U](out: array[i32], a: TensorData[U]) -> None:
    col = global_id(0)
    best: U = a.load(0, col)
    best_index: i32 = 0

    for row in range(1, a.rows):
        value = a.load(row, col)
        if value > best:
            best = value
            best_index = row

    out[col] = best_index

@gpu
def argmax_rows[U](out: array[i32], a: TensorData[U]) -> None:
    row = global_id(0)
    best: U = a.load(row, 0)
    best_index: i32 = 0

    for col in range(1, a.cols):
        value = a.load(row, col)
        if value > best:
            best = value
            best_index = col

    out[row] = best_index
