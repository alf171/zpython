A_data: list[f32] = [1,2,3,4]
A = Tensor(A_data, (2,2))
B = A.transpose()
print(B[1,0])
print(B[0,1])

A[0, 1] = f32(99.0)
print(B[1,0])
