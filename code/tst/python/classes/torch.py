
x_data: array[f32] = [1, 2, 3, 4]
x = Tensor(x_data, (2, 2))
print(x[0, 1])
print(x[1, 0])
x[1, 0] = f32(99.0)
print(x[1, 0])

y = Tensor.fill((16, 16), f32(42));
print(y[0,0])
print(y[5,5])

z = Tensor.fill((16, 16), f32(42));
# this will get run on the gpu
a = y + z
a.print()
