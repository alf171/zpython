class Box[T]:
    def __init__(self, value: T) -> None:
        self.value = value

def consume[T](box: Box[T]) -> T:
    return box.value

box = Box([1, 2, 3])
print(consume(box))
