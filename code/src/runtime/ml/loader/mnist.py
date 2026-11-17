def be32(data: array[char], offset: i32) -> int:
    value: int = 0
    for i in range(4):
        value = value * 256 + int(data[offset + i])
    return value

class MNIST:
    def __init__(self, image_path: str, label_path: str, batch_size: i32) -> None:
        self.images = File(image_path)
        self.labels = File(label_path)
        image_header: array[char] = array_empty(16)
        label_header: array[char] = array_empty(8)
        # fill headers
        self.images.readinto(image_header)
        self.labels.readinto(label_header)
        # read magic numbers
        if be32(image_header, 0) != 2051:
            print("ERROR")
        if be32(label_header, 0) != 2049:
            print("ERROR")
        # read image count
        self.count = be32(image_header, 4)
        # validation?
        self.position: int = 0
        self.batch_size = batch_size
        self.pixels: array[char] = array_empty(784 * batch_size)
        self.label: array[char] = array_empty(1 * batch_size)

    # missing `cast` and `onehot` primatives
    def next(self) -> tuple[Tensor[f32], Tensor[f32]]:
        self.images.readinto(self.pixels)
        self.labels.readinto(self.label)

        values: array[f32] = array_empty(784 * self.batch_size)
        for i in range(784 * self.batch_size):
            # should this div be on the gpu
            values[i] = f32(self.pixels[i]) / f32(255)

        targets: array[f32] = array_empty(10 * self.batch_size)
        for i in range(10 * self.batch_size):
            targets[i] = f32(0)
        for row in range(self.batch_size):
            targets[row * 10 + i32(self.label[row])] = f32(1)

        self.position += self.batch_size
        return Tensor(values, (self.batch_size,784)),Tensor(targets, (self.batch_size, 10))

    def close(self) -> None:
        self.images.close()
        self.labels.close()
