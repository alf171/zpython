
# TODO: add asserts
class list[T]:
    # used by compiler!
    def __init__(self, data: array[T]) -> None:
        self.data: array[T] = data
        # 4.2 billion is max size here
        self.size: i32 = len(data)

    @inline
    def __getitem__(self, i: int) -> T:
        return self.data[i]

    @inline
    def __setitem__(self, i: int, value: T) -> None:
        self.data[i] = value

    @inline
    def __len__(self) -> int:
        return self.size

    def __mul__(self, count: int) -> list[T]:
        data: array[T] = array_empty(self.size * count)
        for i in range(self.size * count):
            data[i] = self.data[i % self.size]
        return list(data)

    # FIXME: should override __str__
    # would require a rework of the print pass
    def __print__(self, end:str="\n") -> None:
      print("[", end="")
      for i in range(self.size):
          if i != 0:
              print(", ", end="")
          print(self.data[i], end="")
      print("]", end=end)

    def append(self, value: T) -> None:
        if self.size == len(self.data):
            self._grow()
        self.data[self.size] = value
        self.size += 1

    def _grow(self) -> None:
        capacity = 8 if len(self.data) < 8 else len(self.data) * 2
        new_data: array[T] = array_empty(capacity)
        for i in range(self.size):
            new_data[i] = self.data[i]
        self.data = new_data
