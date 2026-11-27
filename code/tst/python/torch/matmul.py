srand(42)

# f32 matmul
A = Tensor.randn((1024, 1024))
B = Tensor.randn((1024, 1024))
C = A @ B

print(C[0, 0])
print(C[10, 10])
print(C[100, 100])
print(C[1000, 1000])
