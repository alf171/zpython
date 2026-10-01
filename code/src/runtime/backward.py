from tensor import Tensor

# should be same type as `Tensor.grad`
def add[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += out.grad
    right.grad += out.grad

def sub[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += out.grad
    right.grad -= out.grad

def mul[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += right.view * out.grad
    right.grad += left.view * out.grad

def matmul[U](out: Tensor[U], left: Tensor[U], right: Tensor[U]) -> None:
    left.grad += out.grad @ right.view.transpose()
    right.grad += left.view.transpose() @ out.grad

def broadcast_to[U](out: Tensor[U], left: Tensor[U]) -> None:
    grad = out.grad
    if (left.view.rows == 1 and out.view.rows != 1):
        grad = out.grad.sum(0)

    if (left.view.cols == 1 and out.view.cols != 1):
        grad = out.grad.sum(1)

    left.grad += grad

def sum[U](out: Tensor[U], left: Tensor[U]) -> None:
    left.grad = out.grad.broadcast_to((left.view.rows, left.view.cols))
