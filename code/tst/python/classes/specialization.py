
class Box[T]:
    def __init__(self, values: list[T]) -> None:
        self.values = values

def make_box[T](value: T) -> Box[T]:
    return Box([value])

def consume_box[T](box: Box[T]) -> T:
    return box.values[0]

# FIXME: name main is not allowed actually!
def run() -> None:
    ints = make_box(1)
    print(type(ints))
    more_ints = make_box(2)
    print(type(more_ints))
    floats = make_box(3.0)
    print(type(floats))
    direct = Box([i32(4)])
    print(type(direct))
    print(ints.values[0])
    print(more_ints.values[0])
    print(floats.values[0])
    print(direct.values[0])

    print(consume_box(ints))

run()
