x_data: list[f32] = [40.0,20.0,50.0,30.0]
x1 = Tensor(x_data, (2,2))
y = x1.max(0)
y.print_shape()
y.print()
z = x1.max(1)
z.print_shape()
z.print()
