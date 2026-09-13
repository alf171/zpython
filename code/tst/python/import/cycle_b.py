from cycle_a import a

a(5)

def b(x: int) -> None:
    # FIXME: fstrings dont support ints right now since they hardcode concat!
    print(f"b got ", end="")
    print(x)
