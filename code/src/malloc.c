#include <bits/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

typedef struct Allocation {
  void *ptr;
  uint64_t bytes;
  struct Allocation *next;
} Allocation;

static Allocation *allocations = NULL;
static uint64_t alloc_count = 0;
static uint64_t free_count = 0;
static uint64_t allocated_bytes = 0;
static uint64_t freed_bytes = 0;
static uint64_t cleanup_ns = 0;

static uint64_t now_ns(void) {
  struct timespec ts;
  if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) abort();
  return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}

void *arena_malloc(uint64_t bytes) {
  void* ptr = malloc(bytes);
  if (ptr == NULL) {
    abort();
  }

  Allocation *node = malloc(sizeof(Allocation));
  if (node == NULL) {
    abort();
  }
  node->ptr = ptr;
  node->next = allocations;
  node->bytes = bytes;

  allocations = node;
  alloc_count += 1;
  allocated_bytes += bytes;
  return ptr;
}

void arena_free(void) {
  uint64_t start = now_ns();
  Allocation *node = allocations;
  while (node != NULL) {
    Allocation *current = node;
    Allocation *next = current->next;
    freed_bytes += node->bytes;
    free(node->ptr);
    free(node);
    node = next;
    free_count += 1;
  }
  allocations = NULL;
  cleanup_ns += now_ns() - start;
  if (alloc_count > 0) {
    fprintf(stdout, "[!!memory report!!]: allocs=%llu frees=%llu allocated_bytes=%llu freed_bytes=%llu cleanup_ms=%.3f\n",
        (unsigned long long)alloc_count,
        (unsigned long long)free_count,
        (unsigned long long)allocated_bytes,
        (unsigned long long)freed_bytes,
        cleanup_ns / 1e6);
  }
}
