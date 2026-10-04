
class Box():
    def __init__(self, x: int) -> None:
        self.x = x

a = Box(1)
b = a
c = Box(1)

print(a == b)
print(a == c)
