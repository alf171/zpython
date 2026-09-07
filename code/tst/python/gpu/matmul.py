# i32 matmul
A_data: list[i32] = [1,2,3,4,5,6] 
A = Tensor(A_data, (2,3))
B_data: list[i32] = [7,8,9,10,11,12,13,14,15,16,17,18]
B = Tensor(B_data, (3,4))
C = A @ B
print(C.rows, end = ", ")
print(C.cols)
C.print()

# f32 matmul
A_data: list[f32] = [1.5, -2.0, 0.0,  3.25, -1.0,  0.5]
A = Tensor(A_data, (3, 2))

B_data: list[f32] = [2.0, -1.0,  0.5, 4.0, 1.5,  2.0, -2.0, 0.0]
B = Tensor(B_data, (2, 4))
C = A @ B
C.print()
