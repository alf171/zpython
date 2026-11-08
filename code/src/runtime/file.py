
class File:
    def __init__(self, path: str) -> None:
        self.fd: i32 = openat(i32(-100), path, i32(0), i32(0))
        # assert self.fd >= 0

    def readinto(self, buffer: array[char]) -> int:
        # assert self.fd >= 0
        count = read(self.fd, buffer, int(len(buffer)))
        # assert count >= 0
        return count

    def close(self) -> None:
        if self.fd >= 0:
            result = close(self.fd)
            self.fd = -1
            # assert result == 0
