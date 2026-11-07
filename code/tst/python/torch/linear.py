x_data: array[f32] = [1.0, 2.0, 3.0]
w_data: array[f32] = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0]
b_data: array[f32] = [0.5, 1.0]

x = Tensor(x_data, (1,3))
w = Tensor(w_data, (2,3))
b = Tensor(b_data, (1,2))

layer = Linear(w, b)
y = layer.forward(x)
print(y)
one: f32 = 1.0
y.backward(Tensor.fill((1, 2), one))

# weirdly enough accepts a nullable Tensor
def print_union(grad: Tensor[f32]) -> None:
    if grad is None:
        print(None)
    else:
        print(grad)

print_union(x.grad)
print_union(w.grad)
print_union(b.grad)
