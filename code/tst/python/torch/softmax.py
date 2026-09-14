
x_data: list[f32] = [1000.0, 999.9, -1000.0, -1001.0]

x = Tensor(x_data, (2,2))
softmax = Softmax[f32]()
y = softmax.forward(x)
y.print()
y.sum(1).print()
