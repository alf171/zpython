
class Box[T]:
    def __init__(self, value: T) -> None:
        # more complex if this were type T
        self.value: list[T] = [value]

a = Box(i32(1))
b = Box(f32(1))
c: list[Box] = [a, b]
print(type(c))
d = c[0]
# print(d)
print(type(d))
