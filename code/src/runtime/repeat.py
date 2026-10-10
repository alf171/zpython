
def array_repeat[T](dst: array[T], src: array[T], repeat_count: int) -> None:
    src_len = len(src)
    for i in range(src_len * repeat_count):
        dst[i] = src[i % src_len]
