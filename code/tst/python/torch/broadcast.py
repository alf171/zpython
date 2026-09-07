x_data: list[f32] = [10.0,20.0]
x1 = Tensor(x_data, (1,2))

y = x1.broadcast_to((3,2))
y.print()

x2 = Tensor(x_data, (2,1))

y = x2.broadcast_to((2,3))
y.print()
