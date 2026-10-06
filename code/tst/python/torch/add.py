two: f32 = 2.0
A = Tensor.fill((3,3), two)
three: f32 = 3.0
B = Tensor.fill((3,3), three)

C = A + B
print(C[0, 0])
order = C.uop.toposort(16)
print(len(order))
print(order[0] == A.uop)
print(order[1] == B.uop)
print(order[2] == C.uop)
