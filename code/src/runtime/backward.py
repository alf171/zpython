from tensor import Tensor

# should be same type as `Tensor.grad`
def add[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += out.grad
    right.grad += out.grad

def sub[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += out.grad
    right.grad -= out.grad

def mul[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += right.realize() * out.grad
    right.grad += left.realize() * out.grad

def matmul[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += out.grad @ right.realize().transpose()
    right.grad += left.realize().transpose() @ out.grad

def broadcast_to[U](out: Tensor[U], left: Tensor[U]) -> None:
    grad = out.grad
    if (left.uop.shape[0] == 1 and out.uop.shape[1] != 1):
        grad = out.grad.sum(0)

    if (left.uop.shape[0] == 1 and out.uop.shape[1] != 1):
        grad = out.grad.sum(1)

    left.grad += grad

def sum[U](out: Tensor[U], left: Tensor[U]) -> None:
    rows = left.uop.shape[0]
    cols = left.uop.shape[1]
    left.grad = out.grad.broadcast_to((rows, cols))
