from nn.module import Module
from tensor import Tensor

class Linear[T](Module):
    def __init__(self, weights: Tensor[T], bias: Tensor[T]) -> None:
        self.weights: Tensor[T] = weights
        self.bias: Tensor[T] = bias
        # super().__init__()
    """
    y = x*W^T + b
    where x: [batch_size, in_features]
    W: [out_features, in_features]
    b: [out_features]
    """
    def forward(self, x: Tensor[T]) -> Tensor[T]:
        projected = x @ self.weights.transpose()
        bias = self.bias.broadcast_to((x.view.rows, self.bias.view.cols))
        return projected + bias
