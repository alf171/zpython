
def string_concat(a: str, b: str) -> str:
    out: str = ['\0'] * (len(a) + len(b) - 1)
    # dont include \0
    for i in range(len(a) - 1):
        out[i] = a[i]
    # include \0
    for i in range(len(b)):
        out[i + len(a) - 1] = b[i]

    return out
