

class Key:
    def __init__(self, val: int) -> None:
        self.val = val


    def __hash__(self) -> int:
        return self.val

    def __eq__(self, other: Key) -> bool:
        return self.val == other.val

a = Key(5)
b = Key(5)
c = Key(6)

print(hash(a))
print(hash(a) == hash(b))
print(hash(a) == hash(c))
print(a == b)
print(a == c)
