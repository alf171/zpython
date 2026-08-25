class Counter:
    def __init__(self) -> None:
        self.value: i32 = 0

    def inc(self) -> None:
        self.value = self.value + 1

counter = Counter()
counter.inc()
counter.inc()
print(counter.value)
