
# HACK: a: <type> = <coercable type> doesn't work today
@inline
def coerce[U](t:Tensor[U]|None) -> Tensor[U]:
    return t

class SGD[T]:
    def __init__(self, params: list[Tensor[T]], lr: T) -> None:
        self.params: list[Tensor[T]] = params
        self.lr: T = lr

    def zero_grad(self) -> None:
        for param in self.params:
            param.grad = None

    def step(self) -> None:
        for param in self.params:
            grad = param.grad
            if grad is not None:
                rate = Tensor.fill(param.uop.shape, self.lr)
                # param -= lr * grad
                param.assign(param - rate * coerce(grad))
