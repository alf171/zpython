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
# column major
def sub_mul[U](out: TensorData[U], a: TensorData[U], b: TensorData[U], c: TensorData[U]) -> None:
    col = global_id(0)
    row = global_id(1)
    out.store(row, col, a.load(row, col) - (b.load(row, col) * c.load(row, col)))

@gpu
def div[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    out.store(row, col, a.load(row, col) / b.load(row, col))

@gpu
# (i, j) @ (j,k) = (i,k)
# column major
def matmul[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    k = global_id(0)
    i = global_id(1)

    acc: U = 0
    for j in range(a.cols):
        acc += a.load(i, j) * b.load(j, k)

    # (i, k)
    out.store(i, k, acc)

@gpu
# (i, j) @ (j,k) = (i,k)
def matmul_tile[U](out: TensorData[U], a: TensorData[U], b: TensorData[U]) -> None:
    col = global_id(0)
    row = global_id(1)
    lr = local_id(0)
    lc = local_id(1)

    acc: U = 0
    for j in range(a.cols):
        av = a.load(col, j)
        acc += av * b.load(j, row)

    # (i, k)
    out.store(row, col, acc)

@gpu
def where[U](out: TensorData[U], mask: TensorData[bool], a: TensorData[U], b: TensorData[U]) -> None:
    row = global_id(0)
    col = global_id(1)
    value = a.load(row, col) if mask.load(row, col) else b.load(row, col)
    out.store(row, col, value)

@gpu
def where_gt[T, U](out: TensorData[T], a: TensorData[U], b: TensorData[U], x: TensorData[T], y: TensorData[T]) -> None:
    row = global_id(0)
    col = global_id(1)
    condition = a.load(row, col) > b.load(row, col)
    value = x.load(row, col) if condition else y.load(row, col)
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
        # FIXME: or we could use if statement?
        better = value > best
        best = value if better else best
        best_index = row if better else best_index

    out[col] = best_index

@gpu
def argmax_rows[U](out: array[i32], a: TensorData[U]) -> None:
    row = global_id(0)
    best: U = a.load(row, 0)
    best_index: i32 = 0

    for col in range(1, a.cols):
        value = a.load(row, col)
        # FIXME: or we could use if statement?
        better = value > best
        best = value if better else best
        best_index = col if better else best_index

    out[row] = best_index
