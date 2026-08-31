import helper

print(type(helper))
print(helper.two())

def two() -> int:
    return 3

print(two())
print(helper.two())
