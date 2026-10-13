
class str:
    def __init__(self, data: array[char]) -> None:
        self.data = data

    @inline
    def __getitem__(self, i: int) -> char:
        return self.data[i]

    @inline
    def __setitem__(self, i: int, c: char) -> None:
        self.data[i] = c

    def __len__(self) -> i32:
        # exclude trailing \0
        return len(self.data) - 1

    def __eq__(self, other: str) -> bool:
        if len(self.data) != len(other.data):
            return False

        for i in range(len(self.data)):
            if self.data[i] != other.data[i]:
                return False

        return True

    def __hash__(self) -> int:
        res: int = 0
        for i in range(len(self.data) - 1):
            # replace with 2**31 - 1
            res = (res * 31 + int(self.data[i])) % (2147483647)
        return res

    # NOTE: should establish a better way to do this
    def __write__(self, fd: int, count: int) -> None:
        write(fd, self.data, count)

    def __print__(self, end:str = "\n") -> None:
        write(1, self.data, len(self))
        write(1, end, len(end))

    def __add__(self, other: str) -> str:
        left = len(self)
        right = len(other)
        data: array[char] = array_empty(left + right + 1)

        for i in range(left):
            data[i] = self[i]
        for j in range(right):
            data[left + j] = other[j]

        # FIXME: this shouldve been inferred
        terminator: char = '\0'
        data[left + right] = terminator
        return str(data)
