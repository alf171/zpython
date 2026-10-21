from random import randn

x = 11
y = 5
# add
print(x + y)
# sub
print(x - y)
# mul
print(x * y)
# FIXME: cast shouldnt required
# a rewrite layer should handle pythonic scenarios here
print(f32(x) / f32(y))
# floor div
print(x // y)
# mod
print(x % y)
# exp
print(exp(float(x)))
# exp2
print(exp2(f32(x)))
# left shift
print(x << 3)
# right shift
print(x >> 2)
# log_e
print(log(f32(x)))
# cos
print(cos(f32(x)))
# sqrt
print(sqrt(float(x)))
# seed randomness
srand(42)
# rand i32
print(rand())
# rand f32
print(randn())
