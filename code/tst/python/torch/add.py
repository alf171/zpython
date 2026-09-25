two: i32 = 2
A = Tensor.fill((3,3), two)
three: i32 = 3
B = Tensor.fill((3,3), three)

C = A + B
print(C[0, 0])
# FIXME: subscriptions dont coherse
one: f32 = 1.0
C.grad[0, 0] = one
print(A.grad[0, 0])
print(B.grad[0, 0])
C.backward()
print(A.grad[0, 0])
print(B.grad[0, 0])
