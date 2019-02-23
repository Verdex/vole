
#include "vec.h"
#include<stdbool.h>
#include<stdint.h>
#include<stdlib.h>
#include<string.h>
#include<assert.h>

static void** item_alloc_ptr;
static size_t* item_alloc_size;
static int item_alloc_call_count;
static void* local_item_alloc(size_t size) {
    void* ret = item_alloc_ptr[item_alloc_call_count];
    item_alloc_size[item_alloc_call_count] = size;
    item_alloc_call_count++;
    return ret;
}

static void** item_free_ptr;
static int item_free_call_count;
static void local_item_free(void* p) {
    item_free_ptr[item_free_call_count] = p;
    item_free_call_count++;
}

static void** vec_alloc_ptr;
static int vec_alloc_call_count;
static void* local_vec_alloc() {
    void* ret = vec_alloc_ptr[vec_alloc_call_count];
    vec_alloc_call_count++;
    return ret;
}

static void** vec_free_ptr;
static int vec_free_call_count;
static void local_vec_free(void* p) {
    vec_free_ptr[vec_free_call_count] = p;
    vec_free_call_count++;
}

static void** stable_alloc_ptr;
static int stable_alloc_call_count;
static void* local_stable_alloc() {
    void* ret = stable_alloc_ptr[stable_alloc_call_count];
    stable_alloc_call_count++;
    return ret;
}

static void** stable_free_ptr;
static int stable_free_call_count;
static void local_stable_free(void* p) {
    stable_free_ptr[stable_free_call_count] = p;
    stable_free_call_count++;
}

vec_def(int)

vec_code(int)

void should_handle_with_capacity() {

    vec_alloc_call_count = 0;

    vec_int* vec = vec_int_with_capacity(10);
}

int main() {


    return 0;
}