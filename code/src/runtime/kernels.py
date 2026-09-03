from indexing import index_2d

@gpu
def add[U](out: list[U], a: list[U], b: list[U]) -> None:
    i = global_id(0)
    out[i] = a[i] + b[i]
    return

@gpu
def sub[U](out: list[U], a: list[U], b: list[U]) -> None:
    i = global_id(0)
    out[i] = a[i] - b[i]
    return

@gpu
def mul[U](out: list[U], a: list[U], b: list[U]) -> None:
    i = global_id(0)
    out[i] = a[i] * b[i]
    return

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
