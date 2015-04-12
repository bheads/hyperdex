module deimos.hyperdex.datastructures;

/* Copyright (c) 2013, Cornell University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of HyperDex nor the names of its contributors may be
 *       used to endorse or promote products derived from this software without
 *       specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


/* HyperDex */
import deimos.hyperdex.client;

extern(C):
public:
nothrow:

/* types */
struct hyperdex_ds_arena;

struct hyperdex_ds_list;
struct hyperdex_ds_set;
struct hyperdex_ds_map;

struct hyperdex_ds_iterator
{
    hyperdatatype datatype;
    const char* value;
    const char* value_end;
    const char* progress;
};

/* errors */
enum hyperdex_ds_returncode
{
    HYPERDEX_DS_SUCCESS,
    HYPERDEX_DS_NOMEM,
    HYPERDEX_DS_MIXED_TYPES,
    HYPERDEX_DS_WRONG_STATE,
    HYPERDEX_DS_STRING_TOO_LONG
};

/* arena manipulation */
hyperdex_ds_arena* hyperdex_ds_arena_create();

void hyperdex_ds_arena_destroy(hyperdex_ds_arena* arena);

void* hyperdex_ds_malloc(hyperdex_ds_arena* arena, size_t sz);

/* client parameters */
hyperdex_client_attribute* hyperdex_ds_allocate_attribute(hyperdex_ds_arena* arena, size_t sz);

hyperdex_client_attribute_check* hyperdex_ds_allocate_attribute_check(hyperdex_ds_arena* arena, size_t sz);

hyperdex_client_map_attribute* hyperdex_ds_allocate_map_attribute(hyperdex_ds_arena* arena, size_t sz);

/* pack/unpack ints/floats */
void hyperdex_ds_pack_int(long num, char* buf);
int hyperdex_ds_unpack_int(const char* buf, size_t buf_sz, long* num);

void hyperdex_ds_pack_float(double num, char* buf);
int hyperdex_ds_unpack_float(const char* buf, size_t buf_sz, double* num);

/* copy strings/ints/floats */
int hyperdex_ds_copy_string(hyperdex_ds_arena* arena, const char* str, size_t str_sz,  hyperdex_ds_returncode* status, const char** value, size_t* value_sz);
int hyperdex_ds_copy_int(hyperdex_ds_arena* arena, long num, hyperdex_ds_returncode* status, const char** value, size_t* value_sz);
int hyperdex_ds_copy_float(hyperdex_ds_arena* arena, double num, hyperdex_ds_returncode* status, const char** value, size_t* value_sz);

/* pack lists */
hyperdex_ds_list* hyperdex_ds_allocate_list(hyperdex_ds_arena* arena);
int hyperdex_ds_list_append_string(hyperdex_ds_list* list, const char* str, size_t str_sz, hyperdex_ds_returncode* status);
int hyperdex_ds_list_append_int(hyperdex_ds_list* list, long num, hyperdex_ds_returncode* status);
int hyperdex_ds_list_append_float(hyperdex_ds_list* list, double num, hyperdex_ds_returncode* status);
int hyperdex_ds_list_finalize(hyperdex_ds_list* list, hyperdex_ds_returncode* status, const char** value, size_t* value_sz, hyperdatatype* datatype);

/* pack sets */
hyperdex_ds_set* hyperdex_ds_allocate_set(hyperdex_ds_arena* arena);
int hyperdex_ds_set_insert_string(hyperdex_ds_set* set, const char* str, size_t str_sz, hyperdex_ds_returncode* status);
int hyperdex_ds_set_insert_int(hyperdex_ds_set* set, long num, hyperdex_ds_returncode* status);
int hyperdex_ds_set_insert_float(hyperdex_ds_set* set, double num, hyperdex_ds_returncode* status);
int hyperdex_ds_set_finalize(hyperdex_ds_set*, hyperdex_ds_returncode* status, const char** value, size_t* value_sz, hyperdatatype* datatype);

/* pack maps */
hyperdex_ds_map* hyperdex_ds_allocate_map(hyperdex_ds_arena* arena);
int hyperdex_ds_map_insert_key_string(hyperdex_ds_map* map, const char* str, size_t str_sz, hyperdex_ds_returncode* status);
int hyperdex_ds_map_insert_val_string(hyperdex_ds_map* map, const char* str, size_t str_sz, hyperdex_ds_returncode* status);
int hyperdex_ds_map_insert_key_int(hyperdex_ds_map* map, long num, hyperdex_ds_returncode* status);
int hyperdex_ds_map_insert_val_int(hyperdex_ds_map* map, long num, hyperdex_ds_returncode* status);
int hyperdex_ds_map_insert_key_float(hyperdex_ds_map* map, double num, hyperdex_ds_returncode* status);
int hyperdex_ds_map_insert_val_float(hyperdex_ds_map* map, double num, hyperdex_ds_returncode* status);
int hyperdex_ds_map_finalize(hyperdex_ds_map*, hyperdex_ds_returncode* status, const char** value, size_t* value_sz, hyperdatatype* datatype);

/* iterate datatypes */
void hyperdex_ds_iterator_init(hyperdex_ds_iterator* iter, hyperdatatype datatype, const char* value, size_t value_sz);
/* list */
int hyperdex_ds_iterate_list_string_next(hyperdex_ds_iterator* iter, const char** str, size_t* str_sz);
int hyperdex_ds_iterate_list_int_next(hyperdex_ds_iterator* iter, long* num); 
int hyperdex_ds_iterate_list_float_next(hyperdex_ds_iterator* iter, double* num);
/* set */
int hyperdex_ds_iterate_set_string_next(hyperdex_ds_iterator* iter, const char** str, size_t* str_sz);
int hyperdex_ds_iterate_set_int_next(hyperdex_ds_iterator* iter, long* num);
int hyperdex_ds_iterate_set_float_next(hyperdex_ds_iterator* iter, double* num);
/* map(string, *) */
int hyperdex_ds_iterate_map_string_string_next(hyperdex_ds_iterator* iter, const char** key, size_t* key_sz, const char** val, size_t* val_sz);
int hyperdex_ds_iterate_map_string_int_next(hyperdex_ds_iterator* iter, const char** key, size_t* key_sz, long* val);
int hyperdex_ds_iterate_map_string_float_next(hyperdex_ds_iterator* iter, const char** key, size_t* key_sz, double* val);
/* map(int, *) */
int hyperdex_ds_iterate_map_int_string_next(hyperdex_ds_iterator* iter, long* key, const char** val, size_t* val_sz);
int hyperdex_ds_iterate_map_int_int_next(hyperdex_ds_iterator* iter, long* key, long* val);
int hyperdex_ds_iterate_map_int_float_next(hyperdex_ds_iterator* iter, long* key, double* val);
/* map(float, *) */
int hyperdex_ds_iterate_map_float_string_next(hyperdex_ds_iterator* iter, double* key, const char** val, size_t* val_sz);
int hyperdex_ds_iterate_map_float_int_next(hyperdex_ds_iterator* iter, double* key, long* val);
int hyperdex_ds_iterate_map_float_float_next(hyperdex_ds_iterator* iter, double* key, double* val);
