
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
    const size_t count; \
    const type * const items; \
} \
 \
struct slice_##type { \
    const size_t count; \
    const type * const items; \
} \
 \
struct vec_##type * vec_##type##_with_capacity( size_t capacity ); \
struct vec_##type * vec_##type##_with_array( type * array ); \
struct stable_##type * stable_##type##_with_array( type * array ); \
void vec_##type##_push( struct vec_##type * vec, type item ); \
bool vec_##type##_pop( struct vec_##type * vec, type * item ); \
void vec_##type##_delete( vec_##type ** vec ); \
void stable_##type##_delete( stable_##type ** stable ); \
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
struct stable_##type * stable_##type##_with_array( type * array ) { \
    struct stable_##type * ret = local_stable_alloc(); \
    type * items = local_item_alloc( count ); \
    memcpy( items, array, count ); \
    struct stable_##type temp = { count, items }; \
    memcpy( ret, &temp, sizeof( struct stable_##type ) ); \
    return ret; \
} \
 \
void vec_##type##_push( struct vec_##type * vec, type item ); \
bool vec_##type##_pop( struct vec_##type * vec, type * item ); \
 \
void vec_##type##_delete( vec_##type ** vec ) { \
    local_item_free( (*vec)->items );
    local_vec_free( *vec );
    *vec = NULL;
} \ 
void stable_##type##_delete( stable_##type ** stable ); \
struct stable_##type * vec_##type##_move_stable( struct vec_##type ** vec ); \
struct slice_##type stable_##type##_slice( struct stable_##type * stable, int start, int end ); \
struct slice_##type slice_##type##_slice( struct slice_##type slice, int start, int end );


// foreach, vec, slice, array, stable

#endif