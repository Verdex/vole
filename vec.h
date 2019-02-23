
#ifndef _vec_h_
#define _vec_h_

#define vec_def(type) \
struct vec_##type { \
    size_t capacity; \
    size_t count; \
    type * items; \
}; \
 \
struct stable_##type { \
    size_t count; \
    type * items; \
}; \
 \
struct slice_##type { \
    size_t count; \
    type * items; \
}; \
 \
struct vec_##type * vec_##type##_with_capacity( size_t capacity ); \
struct vec_##type * vec_##type##_with_array( type * array, size_t count ); \
struct stable_##type * stable_##type##_with_array( type * array, size_t count ); \
void vec_##type##_push( struct vec_##type * vec, type item ); \
bool vec_##type##_pop( struct vec_##type * vec, type * item ); \
void vec_##type##_delete( struct vec_##type * vec ); \
void stable_##type##_delete( struct stable_##type * stable ); \
struct stable_##type * vec_##type##_move_stable( struct vec_##type * vec ); \
struct slice_##type stable_##type##_slice( struct stable_##type * stable, int start, int end ); \
struct slice_##type slice_##type##_slice( struct slice_##type slice, int start, int end );

//needs local_vec_alloc, local_stable_alloc, local_item_alloc
// local_vec_free, local_stable_free, local_item_free
// stdbool
// NULL
// memcpy
// size_t
#define vec_code(type) \
struct vec_##type * vec_##type##_with_capacity( size_t capacity ) { \
    if ( capacity == 0 ) { \
        return NULL; \
    } \
    struct vec_##type * ret = local_vec_alloc(); \
    type * items = local_item_alloc( capacity ); \
    ret->capacity = capacity; \
    ret->count = 0; \
    ret->items = items; \
    return ret; \
} \
 \
struct vec_##type * vec_##type##_with_array( type * array, size_t count ) { \
    if ( count == 0 ) {  \
        return NULL; \
    } \
    struct vec_##type * ret = local_vec_alloc(); \
    type * items = local_item_alloc( count ); \
    memcpy( items, array, count ); \
    ret->capacity = count; \
    ret->count = count; \
    ret->items = items; \
    return ret; \
} \
 \
struct stable_##type * stable_##type##_with_array( type * array, size_t count ) { \
    struct stable_##type * ret = local_stable_alloc(); \
    type * items = local_item_alloc( count ); \
    memcpy( items, array, count ); \
    ret->count = count; \
    ret->items = items;\
    return ret; \
} \
 \
void vec_##type##_push( struct vec_##type * vec, type item ) { \
    if ( vec->capacity == vec->count ) { \
        vec->capacity *= 2; \
        type * n = local_item_alloc( vec->capacity ); \
        memcpy(n, vec->items, sizeof( type ) * vec->count); \
        local_item_free(vec->items); \
        vec->items = n; \
    } \
    vec->items[vec->count] = item; \
    vec->count++; \
} \
 \
bool vec_##type##_pop( struct vec_##type * vec, type * item ) { \
    if ( vec->count == 0 ) { \
        return false; \
    } \
    vec->count--; \
    *item = vec->items[vec->count]; \
    return true; \
 } \
 \
void vec_##type##_delete( struct vec_##type * vec ) { \
    local_item_free( vec->items ); \
    local_vec_free( vec ); \
} \
 \
void stable_##type##_delete( struct stable_##type * stable ) { \
    local_item_free( stable->items ); \
    local_stable_free( stable ); \
}\
 \
struct stable_##type * vec_##type##_move_stable( struct vec_##type * vec ) { \
    struct stable_##type * ret = local_stable_alloc(); \
    ret->count = vec->count; \
    ret->items = vec->items; \
    local_vec_free( vec ); \
    return ret; \
} \
 \
struct slice_##type stable_##type##_slice( struct stable_##type * stable, int start, int end ) { \
    struct slice_##type ret = { end - start, stable->items + start }; \
    return ret; \
} \
 \
struct slice_##type slice_##type##_slice( struct slice_##type slice, int start, int end ) { \
    struct slice_##type ret = { end - start, slice.items + start }; \
    return ret; \
}


// foreach, vec, slice, array, stable

#endif