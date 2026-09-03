# hack b/c circular imports arent allowed
@inline
def index_2d(row: i32, col: i32, row_stride: i32, col_stride: i32) -> i32:
    return row * row_stride + col * col_stride;
