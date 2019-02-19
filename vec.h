
#define vec_def(type) \
struct vec_##type { \
    size_t capacity; \
    size_t count; \
    type * items; \
}; \
   \
void vec_##type##_push( vec_##type * v, type i ); \
void vec_##type##_init( vec_##type * v ); \
void vec_##type##_delete( vec_##type * v ); \

