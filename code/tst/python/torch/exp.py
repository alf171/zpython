A_data: list[f32] = [0.0, 1.0, -1.0, 5.0] 
A = Tensor(A_data, (2, 2))
B = A.exp()

print(B[0, 0])
print(B[0, 1])
print(B[1, 0])
print(B[1, 1])
