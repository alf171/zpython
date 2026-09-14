#ifndef ZPYTHON_GPU_LAYOUT_H
#define ZPYTHON_GPU_LAYOUT_H

#include <stdint.h>

typedef struct {
    uint64_t offset;
    uint64_t element_size;
} GpuListField;

typedef struct {
  uint64_t byte_size;
  uint64_t list_field_count;
  const GpuListField *list_fields;
} GpuInstanceLayout;

#endif
