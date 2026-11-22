def f() -> None:
    x = 1
    y = 2
    i = 0

    while i < 1:
      t = x # t = 1
      x = y # x = 2
      y = t # y = 1
      i = i + 1 # i = 2

    print(x)
    print(y)

f()

def g() -> bool:
    print("should not run")
    return True

if False and g():
    print("also should not run")
