
items: list[int] = [1, 2, 3]
print(items)
items[2] = 0
print(items)
print(len(items.data))
items.append(4)
print(items)
print(len(items.data), end = " ")
for i in range(5, 10):
    items.append(i)
    print(len(items.data), end=" ")
print("\n", end="")
print(items)
