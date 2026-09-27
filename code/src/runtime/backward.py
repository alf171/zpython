from tensor import Tensor

# should be same type as `Tensor.grad`
def add(out: Tensor[f32], left: Tensor[f32], right: Tensor[f32]) -> None:
    left.grad += out.grad
    right.grad += out.grad

def sub(out: Tensor[f32], left: Tensor[f32], right: Tensor[f32]) -> None:
    left.grad += out.grad
    right.grad -= out.grad

def mul(out: Tensor[f32], left: Tensor[f32], right: Tensor[f32]) -> None:
    left.grad += right.view * out.grad
    right.grad += left.view * out.grad

def matmul(out: Tensor[f32], left: Tensor[f32], right: Tensor[f32]) -> None:
    left.grad += right.view * out.grad
    right.grad += left.view * out.grad
    pass

def broadcast_to(out: Tensor[f32], left: Tensor[f32]) -> None:
    grad = out.grad
    if (left.view.rows == 1 and out.view.rows != 1):
        grad = out.grad.sum(0)

    if (left.view.cols == 1 and out.view.cols != 1):
        grad = out.grad.sum(1)

    left.grad += grad
