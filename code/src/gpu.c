#include <hsa/hsa.h>
#include <hsa/hsa_ext_amd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include "gpu_layout.h"

typedef struct {
  uint32_t x;
  uint32_t y;
  uint32_t z;
} LaunchDims;

typedef struct {
  hsa_agent_t agent;
  hsa_executable_t executable;
  hsa_queue_t *queue;
  hsa_region_t kernelarg_region;
} GpuRuntime;

static void check(hsa_status_t status, const char *operation) {
  if (status == HSA_STATUS_SUCCESS)
    return;

  const char *message = NULL;
  hsa_status_string(status, &message);

  fprintf(stderr, "%s failed: %s\n", operation, message != NULL ? message : "unknown hsa");
  abort();
}

static hsa_status_t find_gpu(hsa_agent_t agent, void *data) {
  hsa_device_type_t type;
  hsa_status_t status = hsa_agent_get_info(agent, HSA_AGENT_INFO_DEVICE, &type);

  if (status != HSA_STATUS_SUCCESS)
    return status;

  if (type == HSA_DEVICE_TYPE_GPU)
    *(hsa_agent_t *)data = agent;

  return HSA_STATUS_SUCCESS;
}

static hsa_status_t find_kernarg_region(hsa_region_t region, void *data) {
  hsa_region_segment_t segment;

  hsa_status_t status = hsa_region_get_info(region, HSA_REGION_INFO_SEGMENT, &segment);
  if (status != HSA_STATUS_SUCCESS)
    return status;

  if (segment != HSA_REGION_SEGMENT_GLOBAL)
    return HSA_STATUS_SUCCESS;

  uint32_t flags = 0;
  status = hsa_region_get_info(region, HSA_REGION_INFO_GLOBAL_FLAGS, &flags);

  if (status == HSA_STATUS_SUCCESS && (flags & HSA_REGION_GLOBAL_FLAG_KERNARG)) {
    *(hsa_region_t *)data = region;
  }

  return status;
}

static GpuRuntime runtime = {0};

static void shutdown_hsa() {
  if (runtime.queue != NULL) {
    check(hsa_queue_destroy(runtime.queue), "hsa_queue_destroy");
  }
  check(hsa_executable_destroy(runtime.executable), "hsa_executable_destroy");
  check(hsa_shut_down(), "hsa_shut_down");
}

static void ensure_hsa_initialized(void) {
  static int initialized = 0;
  if (initialized) return;

  check(hsa_init(), "hsa_init");
  if (atexit(shutdown_hsa) != 0) abort();

  // agent
  check(hsa_iterate_agents(find_gpu, &runtime.agent), "hsa_iterate_agents");
  if (runtime.agent.handle == 0) {
    fprintf(stderr, "no hsa gpu agent found\n");
    abort();
  }

  // executable
  hsa_profile_t profile;
  check(hsa_agent_get_info(runtime.agent, HSA_AGENT_INFO_PROFILE, &profile), "hsa_agent_get_info(PROFILE)");
  int code_object_fd = open("/tmp/device.co", O_RDONLY);
  if (code_object_fd < 0) {
    perror("open /tmp/device.co");
    abort();
  }
  hsa_code_object_reader_t reader;
  check(hsa_code_object_reader_create_from_file(code_object_fd, &reader), "hsa_code_object_reader_create_from_file");
  check(hsa_executable_create_alt(profile, HSA_DEFAULT_FLOAT_ROUNDING_MODE_DEFAULT, NULL, &runtime.executable), "hsa_executable_create_alt");
  hsa_loaded_code_object_t loaded_code_obj;
  check(hsa_executable_load_agent_code_object(runtime.executable, runtime.agent, reader, NULL, &loaded_code_obj), "hsa_executable_load_agent_code_object");
  check(hsa_executable_freeze(runtime.executable, NULL), "hsa_executable_freeze");
  // destroy
  check(hsa_code_object_reader_destroy(reader), "hsa_code_object_reader_destroy");
  close(code_object_fd);
  // queue
  uint32_t queue_max_size = 0;
  check(hsa_agent_get_info(runtime.agent, HSA_AGENT_INFO_QUEUE_MAX_SIZE, &queue_max_size), "hsa_agent_get_info");
  check(hsa_queue_create(runtime.agent, queue_max_size, HSA_QUEUE_TYPE_SINGLE, NULL, NULL, UINT32_MAX, UINT32_MAX, &runtime.queue), "hsa_queue_create");
  // get kernel arg region
  check(hsa_agent_iterate_regions(runtime.agent, find_kernarg_region, &runtime.kernelarg_region), "hsa_agent_iterate_regions");

  if (runtime.kernelarg_region.handle == 0) {
    fprintf(stderr, "No kernarg region found\n");
    abort();
  }

  initialized = 1;
}

void gpu_launch(const uint64_t *arg_slots, uint64_t arg_count, const uint64_t *workitems, const uint64_t *kernel_name_slots) {
  // TEMP: hack since tuples dont map 1 to 1 with strings (namely always 8 bytes)
  char symbol_name[256] = {0};
  size_t i = 0;

  for (; i < sizeof(symbol_name) - 1; ++i) {
    const uint8_t ch = ((const uint8_t *)kernel_name_slots)[i * sizeof(uint64_t)];

    symbol_name[i] = (char)ch;

    if (ch == '\0')
      break;
  }
  static const char suffix[] = ".kd";
  memcpy(symbol_name + i, suffix, sizeof(suffix));
  // fprintf(stderr, "Looking up kernel symbol: '%s'\n", symbol_name);
  const LaunchDims dims = {
    .x = (uint32_t)workitems[0],
    .y = (uint32_t)workitems[1],
    .z = (uint32_t)workitems[2],
  };

  // fprintf(stderr, "grid: %u x %u x %u\n", dims.x, dims.y, dims.z);

  uint16_t rank;
  if (dims.z != 1) {
    rank = 3;
  } else if (dims.y != 1) {
    rank = 2;
  } else {
    rank = 1;
  }

  const uint64_t n = (uint64_t)dims.x * dims.y * dims.z;
  ensure_hsa_initialized();

  uint32_t max_workgroup_size;
  uint16_t max_workgroup_dims[3];
  check(hsa_agent_get_info(runtime.agent, HSA_AGENT_INFO_WORKGROUP_MAX_SIZE, &max_workgroup_size), "hsa_agent_get_info(WORKGROUP_MAX_SIZE)");
  check(hsa_agent_get_info(runtime.agent, HSA_AGENT_INFO_WORKGROUP_MAX_DIM, &max_workgroup_dims), "hsa_agent_get_info(WORKGROUP_MAX_DIM)");
  const uint32_t grid[3] = {dims.x, dims.y, dims.z};
  uint16_t group[3];
  uint32_t budget = 256;
  for (unsigned axis = 0; axis < 3; axis++) {
    uint32_t size = grid[axis] < budget ? grid[axis] : budget;
    while (grid[axis] % size != 0) size--;
    group[axis] = (uint16_t)size;
    budget /= size;
  }

  char name[64] = {0};
  check(hsa_agent_get_info(runtime.agent, HSA_AGENT_INFO_NAME, name), "hsa_agent_info(name)");

  hsa_executable_symbol_t kernel_symbol;
  check(hsa_executable_get_symbol_by_name(runtime.executable, symbol_name, &runtime.agent, &kernel_symbol), "hsa_executable_get_symbol_by_name");

  uint64_t kernel_object = 0;
  check(hsa_executable_symbol_get_info(kernel_symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_OBJECT, &kernel_object), "hsa_executable_symbol_get_info");

  // fprintf(stderr, "Loaded kernel.kd: kernel object=0x%lx\n", kernel_object);

  hsa_signal_t completion_signal;
  check(hsa_signal_create(1, 0, NULL, &completion_signal), "hsa_signal_create");
  // fprintf(stderr, "Created queue: id=%ld size=%u signal=%lu\n", shared_queue->id, shared_queue->size, completion_signal.handle);

  uint64_t *kernel_args = NULL;
  check(hsa_memory_allocate(runtime.kernelarg_region, arg_count * sizeof(*kernel_args), (void **)&kernel_args), "hsa_memory_allocate");
  void **argument_device_ptrs = calloc(arg_count, sizeof(*argument_device_ptrs));
  for (uint64_t i = 0; i < arg_count; i++) {
    // fprintf(
    //   stderr,
    //   "arg[%lu] value=%#lx bytes=%lu layout=%#lx\n",
    //   i,
    //   arg_slots[3 * i],
    //   arg_slots[3 * i + 1],
    //   arg_slots[3 * i + 2]
    // );
    uint64_t byte_count = arg_slots[3 * i + 1];
    const GpuInstanceLayout *layout = (const GpuInstanceLayout *)(uintptr_t)arg_slots[3 * i + 2];
    if (byte_count != 0) {
      void *instance_host_ptr = (void *)arg_slots[3 * i];
      if (layout != NULL) {
        for (uint64_t j = 0; j < layout->list_field_count; j++) {
          const GpuListField *field = &layout->list_fields[j];
          void *array_host_ptr;
          memcpy(
            &array_host_ptr,
            (const unsigned char *)instance_host_ptr + field->offset,
            sizeof(array_host_ptr)
          );
          uint64_t count;
          memcpy(&count, array_host_ptr, sizeof(count));

          size_t bytes = sizeof(count) + count * field->element_size;
          void *array_device_ptr;
          check(hsa_amd_memory_lock(array_host_ptr, bytes, &runtime.agent, 1, &array_device_ptr), "hsa_amd_memory_lock");
          // fprintf(stderr, "list host=%p device=%p\n", array_host_ptr, array_device_ptr);
        }
      }
      check(hsa_amd_memory_lock(instance_host_ptr, byte_count, &runtime.agent, 1, &argument_device_ptrs[i]), "hsa_amd_memory_lock");
      kernel_args[i] = (uint64_t)argument_device_ptrs[i];
    } else {
      kernel_args[i] = arg_slots[3*i];
    }
  }

  uint64_t packet_id = hsa_queue_add_write_index_relaxed(runtime.queue, 1);
  uint32_t packet_index = packet_id & (runtime.queue->size - 1);
  hsa_kernel_dispatch_packet_t *packet = &((hsa_kernel_dispatch_packet_t*)runtime.queue->base_address)[packet_index];
  memset(packet, 0, sizeof(*packet));
  packet->setup = rank << HSA_KERNEL_DISPATCH_PACKET_SETUP_DIMENSIONS;

  packet->workgroup_size_x = group[0];
  packet->workgroup_size_y = group[1];
  packet->workgroup_size_z = group[2];
  packet->grid_size_x = dims.x;
  packet->grid_size_y = dims.y;
  packet->grid_size_z = dims.z;

  packet->private_segment_size = 0;
  packet->group_segment_size = 0;

  packet->kernel_object = kernel_object;
  packet->kernarg_address = kernel_args;
  packet->completion_signal = completion_signal;

  uint16_t header =
      (HSA_PACKET_TYPE_KERNEL_DISPATCH
          << HSA_PACKET_HEADER_TYPE) |
      (HSA_FENCE_SCOPE_SYSTEM
          << HSA_PACKET_HEADER_ACQUIRE_FENCE_SCOPE) |
      (HSA_FENCE_SCOPE_SYSTEM
          << HSA_PACKET_HEADER_RELEASE_FENCE_SCOPE);

  __atomic_store_n(
      &packet->header,
      header,
      __ATOMIC_RELEASE);

  hsa_signal_store_screlease(
      runtime.queue->doorbell_signal,
      packet_id);
   hsa_signal_value_t completion =
       hsa_signal_wait_scacquire(
           completion_signal,
           HSA_SIGNAL_CONDITION_LT,
           1,
           UINT64_MAX,
           HSA_WAIT_STATE_BLOCKED);
  
  for (uint64_t i = 0; i < arg_count; i++) {
    uint64_t byte_count = arg_slots[3 * i + 1];
    if (byte_count != 0) {
      void *instance_host_ptr = (void *)arg_slots[3 * i];
      check(hsa_amd_memory_unlock(instance_host_ptr), "hsa_amd_memory_unlock");
      const GpuInstanceLayout *layout = (const GpuInstanceLayout *)(uintptr_t)arg_slots[3 * i + 2];
      if (layout != NULL) {
        for (uint64_t j = 0; j < layout->list_field_count; j++) {
          void *array_host_ptr;
          memcpy(&array_host_ptr, (const unsigned char *)instance_host_ptr + layout->list_fields[j].offset, sizeof(array_host_ptr));
          check(hsa_amd_memory_unlock(array_host_ptr), "hsa_amd_memory_unlock(array)");
        }
      }
    }
  }
  free(argument_device_ptrs);

   // fprintf(
   //     stderr,
   //     "Kernel completed: signal=%ld\n",
   //     completion);

  check(hsa_memory_free(kernel_args), "hsa_memory_free(kernel_args)");

  check(hsa_signal_destroy(completion_signal), "hsa_signal_destroy");
}
