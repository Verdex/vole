
#include "vec.h"
#include<stdbool.h>
#include<stdlib.h>
#include<string.h>

static void* local_item_alloc(size_t size) {
    return NULL;
}

static void local_item_free(void* p) {

}

static void* local_vec_alloc() {
    return NULL;
}

static void local_vec_free(void* p) {

}

static void* local_stable_alloc() {
    return NULL;
}

static void local_stable_free(void* p) {

}

vec_def(int)

vec_code(int)