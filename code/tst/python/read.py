
file = File("tst/python/if.py")
header: array[char] = array_empty(16)
count = file.readinto(header)
write(1, header, count)
print("\n", end="")
file.close()
