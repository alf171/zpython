import helper
from helper import two as helper_two

print(type(helper))
print(type(helper_two))

def two(x: i32, y: f32) -> int:
    return 3

print(type(two))
print(helper_two())
print(helper.two())
print(two(1, 2.0))
