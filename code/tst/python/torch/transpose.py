A = Tensor([1,2,3,4], (2,2))
B = A.transpose()
print(B[1,0])
print(B[0,1])

A[0, 1] = 99
print(B[1,0])
