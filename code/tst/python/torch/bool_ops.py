x1_data: list[f32] = [5.00,10.0,20.0,40.0]
x1 = Tensor(x1_data, (2,2))
x2_data: list[f32] = [10.0,10.0,20.0,30.0]
x2 = Tensor(x2_data, (2,2))

y1 = x1 > x2
# TODO: support overriding `print`
y1.print()
y2 = x1 < x2
y2.print()
y3 = x1 <= x2
y3.print()
y4 = x1 >= x2
y4.print()
y5 = x1 == x2
y5.print()
y6 = x1 != x2
y6.print()
