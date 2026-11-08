srand(42)


def xavier_normal(f_in: i32, f_out: i32) -> Tensor[f32]:
    shape = (f_out, f_in)
    std: f32 = f32(sqrt(2.0 / float(f_in + f_out)))
    sample = Tensor.randn(shape)
    scale = Tensor.fill(shape, std)
    return sample * scale


# batch size 1
data = xavier_normal(16, 1)
weight1 = xavier_normal(16, 64)
bias1 = Tensor.fill((1, 64), f32(0))
# 16 -> 64
layer1 = Linear(weight1, bias1)
weight2 = xavier_normal(64, 10)
bias2 = Tensor.fill((1,10), f32(0))
# 64 -> 10
layer2 = Linear(weight2, bias2)
# softmax
softmax = Softmax[f32]()
# optim step
optimizer = SGD([weight1, bias1, weight2, bias2], 0.001)

target_data: array[f32] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
target = Tensor(target_data, (1,10))
seed = Tensor.fill((1,1), f32(1))

for step in range(25):
    optimizer.zero_grad()
    y1 = layer1.forward(data)
    y2 = y1.relu()
    y3 = layer2.forward(y2)
    diff = y3 - target
    loss = (diff*diff).sum(1).sum(0)
    print(loss)
    loss.backward(seed)
    optimizer.step()
