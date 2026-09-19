# Overview

Goal of this project is to create a python like language which can write gpu/ai accelerator kernels without the hassle of things like cuda.

This is a project to learn more about the implementations of a compilers, linkers, hardware, and more!

## Design Choices
- leverage python
  - subset of its syntax
  - using annotation to invoke new functionality (@gpu, @inline, ...)
- modular
- compiled not interpreted
- function types are enforced
- deterministic

## Language Specs
- circular imports are allowed!
- additional types like `i32`, `f32`
- [WIP] type inference and compiler errors

## Example from `src/runtime/{tensor,kernels,indexing}.py`
```python
class Tensor[T]:
    def __init__(self, data: list[T], shape: tuple[i32, i32]) -> None:
        self.data: list[T] = data
        self.rows: i32 = shape[0]
        self.cols: i32 = shape[1]
        self.row_stride: i32 = shape[1]
        self.col_stride: i32 = 1
        ...

# GPUs don't have ABI semantics so we use inlining to allow for function calls on the GPU
@inline
def index_2d(row: i32, col: i32, row_stride: i32, col_stride: i32) -> i32:
    return row * row_stride + col * col_stride;

@gpu
# (i, j) @ (j,k) = (i, k)
def matmul[U](out: Tensor[U], a: Tensor[U], b: Tensor[U]) -> None:
    i = global_id(0)
    k = global_id(1)

    acc: U = 0
    for j in range(a.cols):
        a_i = index_2d(i, j, a.row_stride, a.col_stride)
        b_i = index_2d(j, k, b.row_stride, b.col_stride) 
        acc += a.data[a_i] * b.data[b_i]

    # (i, k)
    out_i = index_2d(i, k, out.row_stride, out.col_stride)
    out.data[out_i] = acc
```

## Reading Materials
- user scheduling lanuage
  - [exo1](https://dl.acm.org/doi/epdf/10.1145/3519939.3523446)
  - [exo2](https://arxiv.org/pdf/2411.07211)
- hardware
  - [gemmini](https://arxiv.org/pdf/1911.09925)
- compilers
  - [phi function vs block args](https://mlir.llvm.org/docs/Rationale/Rationale/#block-arguments-vs-phi-nodes)
  - [phi vs select](https://stackoverflow.com/questions/63048341/what-is-the-difference-between-select-and-phi-in-llvm-ir)
  - [garbage collection](https://www.microsoft.com/en-us/research/wp-content/uploads/2020/11/perceus-tr-v1.pdf)
- GPU
  - [rdna3](https://rocm.blogs.amd.com/software-tools-optimization/amdgcn-isa/README.html)
  - [cuda memory swizzling](https://leimao.github.io/blog/CUDA-Shared-Memory-Swizzling/)
  - [more swizzling](https://mlc.ai/modern-gpu-programming-for-mlsys/chapter_data_layout/index.html#swizzle-layout)
- LLMs
  - [inference paper](https://arxiv.org/pdf/2607.02521)
