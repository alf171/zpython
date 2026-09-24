def make() -> Callable[[], i32]:
    x: i32 = 1
    f: Callable[[], i32] = lambda: x
    # different from python semantics (this is a no op)
    x += 1
    return f

f = make()
print(f())
