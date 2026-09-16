x = "foo"
y = "bar"
# FIXME: should become x + y?
z = _concat__string_concat(x, y)
print(z)
print(f"fstring print: {x} {y}")
