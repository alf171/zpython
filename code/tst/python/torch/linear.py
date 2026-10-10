x_data: array[f32] = [1.0, 2.0, 3.0]
w_data: array[f32] = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0]
b_data: array[f32] = [0.5, 1.0]

x = Tensor(x_data, (1,3))
w = Tensor(w_data, (2,3))
b = Tensor(b_data, (1,2))

layer = Linear(w, b)
y = layer.forward(x)
y.print()

one: f32 = 1.0
seed = Tensor.fill((1,2), one)
y.backward(seed.view)
x.grad.print()
w.grad.print()
b.grad.print()
