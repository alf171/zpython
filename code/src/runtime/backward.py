from tensor import Tensor

# should be same time as `Tensor.grad`
def add(out: Tensor[f32], left: Tensor[f32], right: Tensor[f32]) -> None:
    for i in range(len(out.grad)):
        left.grad[i] += out.grad[i]
        right.grad[i] += out.grad[i]
