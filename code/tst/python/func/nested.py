
def a(x: int) -> None:
    def b(x: float) -> None:
        print(b)

    b(float(x + 2))

a(1)
