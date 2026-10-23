srand(42)

def xavier_normal(f_in: i32, f_out: i32) -> Tensor[f32]:
    shape = (f_out, f_in)
    std: f32 = f32(sqrt(2.0 / float(f_in + f_out)))
    sample = Tensor.randn(shape)
    scale = Tensor.fill(shape, std)
    return sample * scale

# batch size 1
data = xavier_normal(784, 1)
weight1 = Tensor.randn((64,784))
bias1 = Tensor.fill((1,64), f32(0))
layer1 = Linear(weight1, bias1)
# 784 -> 128
y1 = layer1.forward(data)
# relu
y2 = y1.relu()
weight2 = xavier_normal(64,10)
bias2 = Tensor.fill((1,10), f32(0))
layer2 = Linear(weight2, bias2)
# 128 -> 10
y3 = layer2.forward(y2)
# softmax
softmax = Softmax[f32]()
probs = softmax.forward(y3)
print(probs)
