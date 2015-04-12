module deimos.hyperdex.client;

/* Copyright (c) 2011-2014, Cornell University
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
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


/* HyperDex */
public import deimos.hyperdex.core;

extern(C):
public:
nothrow:

struct hyperdex_client;

struct hyperdex_client_attribute
{
    const char* attr; /* NULL-terminated */
    const char* value;
    size_t value_sz;
    hyperdatatype datatype;
};

struct hyperdex_client_map_attribute
{
    const char* attr; /* NULL-terminated */
    const char* map_key;
    size_t map_key_sz;
    hyperdatatype map_key_datatype;
    const char* value;
    size_t value_sz;
    hyperdatatype value_datatype;
};

struct hyperdex_client_attribute_check
{
    const char* attr; /* NULL-terminated */
    const char* value;
    size_t value_sz;
    hyperdatatype datatype;
    hyperpredicate predicate;
};

/* hyperdex_client_returncode occupies [8448, 8576) */
enum hyperdex_client_returncode
{
    HYPERDEX_CLIENT_SUCCESS      = 8448,
    HYPERDEX_CLIENT_NOTFOUND     = 8449,
    HYPERDEX_CLIENT_SEARCHDONE   = 8450,
    HYPERDEX_CLIENT_CMPFAIL      = 8451,
    HYPERDEX_CLIENT_READONLY     = 8452,

    /* Error conditions */
    HYPERDEX_CLIENT_UNKNOWNSPACE = 8512,
    HYPERDEX_CLIENT_COORDFAIL    = 8513,
    HYPERDEX_CLIENT_SERVERERROR  = 8514,
    HYPERDEX_CLIENT_POLLFAILED   = 8515,
    HYPERDEX_CLIENT_OVERFLOW     = 8516,
    HYPERDEX_CLIENT_RECONFIGURE  = 8517,
    HYPERDEX_CLIENT_TIMEOUT      = 8519,
    HYPERDEX_CLIENT_UNKNOWNATTR  = 8520,
    HYPERDEX_CLIENT_DUPEATTR     = 8521,
    HYPERDEX_CLIENT_NONEPENDING  = 8523,
    HYPERDEX_CLIENT_DONTUSEKEY   = 8524,
    HYPERDEX_CLIENT_WRONGTYPE    = 8525,
    HYPERDEX_CLIENT_NOMEM        = 8526,
    HYPERDEX_CLIENT_INTERRUPTED  = 8530,
    HYPERDEX_CLIENT_CLUSTER_JUMP = 8531,
    HYPERDEX_CLIENT_OFFLINE      = 8533,
    HYPERDEX_CLIENT_UNAUTHORIZED = 8534,

    /* This should never happen.  It indicates a bug */
    HYPERDEX_CLIENT_INTERNAL     = 8573,
    HYPERDEX_CLIENT_EXCEPTION    = 8574,
    HYPERDEX_CLIENT_GARBAGE      = 8575
};

const HYPERDEX_ATTRIBUTE_SECRET  = "__secret";

hyperdex_client* hyperdex_client_create(const char* coordinator, ushort port);
hyperdex_client* hyperdex_client_create_conn_str(const char* conn_str);
void hyperdex_client_destroy(hyperdex_client* client);

struct macaroon;

void hyperdex_client_clear_auth_context(hyperdex_client* client);
void hyperdex_client_set_auth_context(hyperdex_client* client, const char** macaroons, size_t macaroons_sz);

long
hyperdex_client_get(hyperdex_client* client,
                    const char* space,
                    const char* key, size_t key_sz,
                    hyperdex_client_returncode* status,
                    const hyperdex_client_attribute** attrs, size_t* attrs_sz);

long
hyperdex_client_get_partial(hyperdex_client* client,
                            const char* space,
                            const char* key, size_t key_sz,
                            const char** attrnames, size_t attrnames_sz,
                            hyperdex_client_returncode* status,
                            const hyperdex_client_attribute** attrs, size_t* attrs_sz);

long
hyperdex_client_put(hyperdex_client* client,
                    const char* space,
                    const char* key, size_t key_sz,
                    const hyperdex_client_attribute* attrs, size_t attrs_sz,
                    hyperdex_client_returncode* status);

long
hyperdex_client_cond_put(hyperdex_client* client,
                         const char* space,
                         const char* key, size_t key_sz,
                         const hyperdex_client_attribute_check* checks, size_t checks_sz,
                         const hyperdex_client_attribute* attrs, size_t attrs_sz,
                         hyperdex_client_returncode* status);

long
hyperdex_client_group_put(hyperdex_client* client,
                          const char* space,
                          const hyperdex_client_attribute_check* checks, size_t checks_sz,
                          const hyperdex_client_attribute* attrs, size_t attrs_sz,
                          hyperdex_client_returncode* status,
                          ulong* count);

long
hyperdex_client_put_if_not_exist(hyperdex_client* client,
                                 const char* space,
                                 const char* key, size_t key_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status);

long
hyperdex_client_del(hyperdex_client* client,
                    const char* space,
                    const char* key, size_t key_sz,
                    hyperdex_client_returncode* status);

long
hyperdex_client_cond_del(hyperdex_client* client,
                         const char* space,
                         const char* key, size_t key_sz,
                         const hyperdex_client_attribute_check* checks, size_t checks_sz,
                         hyperdex_client_returncode* status);

long
hyperdex_client_group_del(hyperdex_client* client,
                          const char* space,
                          const hyperdex_client_attribute_check* checks, size_t checks_sz,
                          hyperdex_client_returncode* status,
                          ulong* count);

long
hyperdex_client_atomic_add(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_add(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_add(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_sub(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_sub(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_sub(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_mul(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_mul(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_mul(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_div(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_div(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_div(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_mod(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_mod(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_mod(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_and(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_and(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_and(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_or(hyperdex_client* client,
                          const char* space,
                          const char* key, size_t key_sz,
                          const hyperdex_client_attribute* attrs, size_t attrs_sz,
                          hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_or(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_attribute_check* checks, size_t checks_sz,
                               const hyperdex_client_attribute* attrs, size_t attrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_or(hyperdex_client* client,
                                const char* space,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status,
                                ulong* count);

long
hyperdex_client_atomic_xor(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_xor(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_xor(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_min(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_min(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_min(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_atomic_max(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_atomic_max(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_atomic_max(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_string_prepend(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_attribute* attrs, size_t attrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_string_prepend(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_string_prepend(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_string_append(hyperdex_client* client,
                              const char* space,
                              const char* key, size_t key_sz,
                              const hyperdex_client_attribute* attrs, size_t attrs_sz,
                              hyperdex_client_returncode* status);

long
hyperdex_client_cond_string_append(hyperdex_client* client,
                                   const char* space,
                                   const char* key, size_t key_sz,
                                   const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                   const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                   hyperdex_client_returncode* status);

long
hyperdex_client_group_string_append(hyperdex_client* client,
                                    const char* space,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                    hyperdex_client_returncode* status,
                                    ulong* count);

long
hyperdex_client_list_lpush(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_list_lpush(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_list_lpush(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_list_rpush(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_list_rpush(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_list_rpush(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_set_add(hyperdex_client* client,
                        const char* space,
                        const char* key, size_t key_sz,
                        const hyperdex_client_attribute* attrs, size_t attrs_sz,
                        hyperdex_client_returncode* status);

long
hyperdex_client_cond_set_add(hyperdex_client* client,
                             const char* space,
                             const char* key, size_t key_sz,
                             const hyperdex_client_attribute_check* checks, size_t checks_sz,
                             const hyperdex_client_attribute* attrs, size_t attrs_sz,
                             hyperdex_client_returncode* status);

long
hyperdex_client_group_set_add(hyperdex_client* client,
                              const char* space,
                              const hyperdex_client_attribute_check* checks, size_t checks_sz,
                              const hyperdex_client_attribute* attrs, size_t attrs_sz,
                              hyperdex_client_returncode* status,
                              ulong* count);

long
hyperdex_client_set_remove(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_set_remove(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_set_remove(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_set_intersect(hyperdex_client* client,
                              const char* space,
                              const char* key, size_t key_sz,
                              const hyperdex_client_attribute* attrs, size_t attrs_sz,
                              hyperdex_client_returncode* status);

long
hyperdex_client_cond_set_intersect(hyperdex_client* client,
                                   const char* space,
                                   const char* key, size_t key_sz,
                                   const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                   const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                   hyperdex_client_returncode* status);

long
hyperdex_client_group_set_intersect(hyperdex_client* client,
                                    const char* space,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                    hyperdex_client_returncode* status,
                                    ulong* count);

long
hyperdex_client_set_union(hyperdex_client* client,
                          const char* space,
                          const char* key, size_t key_sz,
                          const hyperdex_client_attribute* attrs, size_t attrs_sz,
                          hyperdex_client_returncode* status);

long
hyperdex_client_cond_set_union(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_attribute_check* checks, size_t checks_sz,
                               const hyperdex_client_attribute* attrs, size_t attrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_group_set_union(hyperdex_client* client,
                                const char* space,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status,
                                ulong* count);

long
hyperdex_client_document_rename(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_cond_document_rename(hyperdex_client* client,
                                     const char* space,
                                     const char* key, size_t key_sz,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                     hyperdex_client_returncode* status);

long
hyperdex_client_group_document_rename(hyperdex_client* client,
                                      const char* space,
                                      const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                      const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                      hyperdex_client_returncode* status,
                                      ulong* count);

long
hyperdex_client_document_unset(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_attribute* attrs, size_t attrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_document_unset(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_document_unset(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_add(hyperdex_client* client,
                        const char* space,
                        const char* key, size_t key_sz,
                        const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                        hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_add(hyperdex_client* client,
                             const char* space,
                             const char* key, size_t key_sz,
                             const hyperdex_client_attribute_check* checks, size_t checks_sz,
                             const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                             hyperdex_client_returncode* status);

long
hyperdex_client_group_map_add(hyperdex_client* client,
                              const char* space,
                              const hyperdex_client_attribute_check* checks, size_t checks_sz,
                              const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                              hyperdex_client_returncode* status,
                              ulong* count);

long
hyperdex_client_map_remove(hyperdex_client* client,
                           const char* space,
                           const char* key, size_t key_sz,
                           const hyperdex_client_attribute* attrs, size_t attrs_sz,
                           hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_remove(hyperdex_client* client,
                                const char* space,
                                const char* key, size_t key_sz,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                hyperdex_client_returncode* status);

long
hyperdex_client_group_map_remove(hyperdex_client* client,
                                 const char* space,
                                 const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                 const hyperdex_client_attribute* attrs, size_t attrs_sz,
                                 hyperdex_client_returncode* status,
                                 ulong* count);

long
hyperdex_client_map_atomic_add(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_add(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_add(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_sub(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_sub(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_sub(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_mul(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_mul(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_mul(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_div(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_div(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_div(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_mod(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_mod(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_mod(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_and(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_and(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_and(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_or(hyperdex_client* client,
                              const char* space,
                              const char* key, size_t key_sz,
                              const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                              hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_or(hyperdex_client* client,
                                   const char* space,
                                   const char* key, size_t key_sz,
                                   const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                   const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                   hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_or(hyperdex_client* client,
                                    const char* space,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status,
                                    ulong* count);

long
hyperdex_client_map_atomic_xor(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_xor(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_xor(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_string_prepend(hyperdex_client* client,
                                   const char* space,
                                   const char* key, size_t key_sz,
                                   const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                   hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_string_prepend(hyperdex_client* client,
                                        const char* space,
                                        const char* key, size_t key_sz,
                                        const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                        const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                        hyperdex_client_returncode* status);

long
hyperdex_client_group_map_string_prepend(hyperdex_client* client,
                                         const char* space,
                                         const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                         const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                         hyperdex_client_returncode* status,
                                         ulong* count);

long
hyperdex_client_map_string_append(hyperdex_client* client,
                                  const char* space,
                                  const char* key, size_t key_sz,
                                  const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                  hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_string_append(hyperdex_client* client,
                                       const char* space,
                                       const char* key, size_t key_sz,
                                       const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                       const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                       hyperdex_client_returncode* status);

long
hyperdex_client_group_map_string_append(hyperdex_client* client,
                                        const char* space,
                                        const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                        const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                        hyperdex_client_returncode* status,
                                        ulong* count);

long
hyperdex_client_map_atomic_min(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_min(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_min(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_map_atomic_max(hyperdex_client* client,
                               const char* space,
                               const char* key, size_t key_sz,
                               const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                               hyperdex_client_returncode* status);

long
hyperdex_client_cond_map_atomic_max(hyperdex_client* client,
                                    const char* space,
                                    const char* key, size_t key_sz,
                                    const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                    const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                    hyperdex_client_returncode* status);

long
hyperdex_client_group_map_atomic_max(hyperdex_client* client,
                                     const char* space,
                                     const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                     const hyperdex_client_map_attribute* mapattrs, size_t mapattrs_sz,
                                     hyperdex_client_returncode* status,
                                     ulong* count);

long
hyperdex_client_search(hyperdex_client* client,
                       const char* space,
                       const hyperdex_client_attribute_check* checks, size_t checks_sz,
                       hyperdex_client_returncode* status,
                       const hyperdex_client_attribute** attrs, size_t* attrs_sz);

long
hyperdex_client_search_describe(hyperdex_client* client,
                                const char* space,
                                const hyperdex_client_attribute_check* checks, size_t checks_sz,
                                hyperdex_client_returncode* status,
                                const char** description);

long
hyperdex_client_sorted_search(hyperdex_client* client,
                              const char* space,
                              const hyperdex_client_attribute_check* checks, size_t checks_sz,
                              const char* sort_by,
                              ulong limit,
                              int maxmin,
                              hyperdex_client_returncode* status,
                              const hyperdex_client_attribute** attrs, size_t* attrs_sz);

long
hyperdex_client_count(hyperdex_client* client,
                      const char* space,
                      const hyperdex_client_attribute_check* checks, size_t checks_sz,
                      hyperdex_client_returncode* status,
                      ulong* count);

long
hyperdex_client_loop(hyperdex_client* client, int timeout,
                     hyperdex_client_returncode* status);

int
hyperdex_client_poll(hyperdex_client* client);

int
hyperdex_client_block(hyperdex_client* client, int timeout);

hyperdatatype
hyperdex_client_attribute_type(hyperdex_client* client,
                               const char* space, const char* name,
                               hyperdex_client_returncode* status);

const (char*) hyperdex_client_error_message(hyperdex_client* client);

const (char*) hyperdex_client_error_location(hyperdex_client* client);

const (char*) hyperdex_client_returncode_to_string(hyperdex_client_returncode);

void hyperdex_client_destroy_attrs(const hyperdex_client_attribute* attrs, size_t attrs_sz);
