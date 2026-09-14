from nn.module import Module
from tensor import Tensor

class Softmax[T](Module):
    def __init__(self) -> None:
        pass
        # super().__init__()
    """
    softmax(x_i) = e^(x_i) / sum_{j}(e^x_j)
    """
    def forward(self, x: Tensor[T]) -> Tensor[T]:
        x_shifted = x - x.max(1).broadcast_to((x.rows, x.cols))
        x_exp = x_shifted.exp()
        x_sum = x_exp.sum(1).broadcast_to((x.rows, x.cols))
        return x_exp / x_sum
