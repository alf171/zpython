two: i32 = 2
A = Tensor.fill((3,3), two)
three: i32 = 3
B = Tensor.fill((3,3), three)

C = A + B
print(C[0, 0])
# initialized as 0
print(A.grad[0])
C.grad[0] = 1.0
print(A.grad[0])
print(B.grad[0])
