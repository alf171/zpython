# NOTE: linear probing hashmap
# (keys, values) arent zipped to avoid pointers
# since we cant express union types, store occupied in their one field

# TODO: add asserts
class dict[K, V]:
    def __init__(self, keys: array[K], values: array[V]) -> None:
        capacity = len(keys) * 2 + 1
        self.keys: array[K] = array_empty(capacity)
        self.values: array[V] = array_empty(capacity)
        self.occupied: array[bool] = array_empty(capacity)
        self.size: i32 = 0
        for i in range(capacity):
            self.occupied[i] = False
        for i in range(len(keys)):
            self[keys[i]] = values[i]

    # @inline
    def __getitem__(self, key: K) -> V:
        index = self._get(key)
        return self.values[index]

    # @inline
    def __setitem__(self, key: K, value: V) -> None:
        # at 70% occupancy, expand our dictionary
        if (self.size + 1) * 10 >= len(self.values) * 7:
            self._grow()
        index = self._get(key)
        self.keys[index] = key
        self.values[index] = value
        self.occupied[index] = True
        self.size += 1

    def __contains__(self, key: K) -> bool:
        index = self._get(key)
        return self.occupied[index]

    # @inline
    def _get(self, key: K) -> int:
        lv = len(self.values)
        index = hash(key) % lv
        while self.occupied[index]:
            # early return
            if self.keys[index] == key:
                return index
            index = (index + 1) % lv
        # empty spot found
        return index

    def _grow(self) -> None:
        # save state
        old_keys = self.keys
        old_values = self.values
        old_occupied = self.occupied
        old_capacity = len(old_keys)
        # new state
        capacity = old_capacity * 2 + 1
        # FIXME: type shouldnt be required here
        self.keys: array[K] = array_empty(capacity)
        self.values: array[V] = array_empty(capacity)
        self.occupied: array[bool] = array_empty(capacity)
        self.size = 0
        for i in range(capacity):
            self.occupied[i] = False
        for i in range(old_capacity):
            if old_occupied[i]:
                self[old_keys[i]] = old_values[i]

    def __print__(self, end:str="\n") -> None:
        pass
