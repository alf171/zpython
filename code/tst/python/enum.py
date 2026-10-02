

class Color(Enum):
    RED = 0
    GREEN = 1
    BLUE = 2

red = Color.RED
green = Color.GREEN
blue = Color.BLUE

def identity(color: Color) -> Color:
    return color

print(red == Color.RED)
print(identity(green) == Color.GREEN)
print(Color.GREEN == Color.BLUE)
print(blue)
