
def uniform() -> float:
    # FIXME: replace with 2**31 - 1
    return (float(rand()) + 1.0) / 2147483648.0

# https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
def randn() -> f32:
    u1 = uniform()
    u2 = uniform()

    radius = sqrt(-2.0 * log(u1))
    two_pi = 6.283185307179586
    angle = two_pi * u2
    return f32(radius * cos(angle))
