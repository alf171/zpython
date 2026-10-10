x1_data: array[f32] = [5.00,10.0,20.0,40.0]
x1 = Tensor(x1_data, (2,2))
x2_data: array[f32] = [10.0,10.0,20.0,30.0]
x2 = Tensor(x2_data, (2,2))

y1 = x1 > x2
print(y1)
y2 = x1 < x2
print(y2)
y3 = x1 <= x2
print(y3)
y4 = x1 >= x2
print(y4)
y5 = x1 == x2
print(y5)
y6 = x1 != x2
print(y6)
