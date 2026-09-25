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
    # left.grad += right.view * out.grad
    # right.grad += left.view * out.grad
    pass
