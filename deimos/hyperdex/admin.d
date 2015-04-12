module deimos.hyperdex.admin;

/* Copyright (c) 2013-2014, Cornell University
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

extern(C):
public:
nothrow:

public import deimos.hyperdex.core;

struct hyperdex_admin;

struct hyperdex_admin_perf_counter
{
    ulong id;
    ulong time;
    const char* property;
    ulong measurement;
}

/* hyperdex_admin_returncode occupies [8704, 8832) */
enum hyperdex_admin_returncode
{
    HYPERDEX_ADMIN_SUCCESS     = 8704,

    /* Error conditions */
    HYPERDEX_ADMIN_NOMEM       = 8768,
    HYPERDEX_ADMIN_NONEPENDING = 8769,
    HYPERDEX_ADMIN_POLLFAILED  = 8770,
    HYPERDEX_ADMIN_TIMEOUT     = 8771,
    HYPERDEX_ADMIN_INTERRUPTED = 8772,
    HYPERDEX_ADMIN_SERVERERROR = 8773,
    HYPERDEX_ADMIN_COORDFAIL   = 8774,
    HYPERDEX_ADMIN_BADSPACE    = 8775,
    HYPERDEX_ADMIN_DUPLICATE   = 8776,
    HYPERDEX_ADMIN_NOTFOUND    = 8777,
    HYPERDEX_ADMIN_LOCALERROR  = 8778,

    /* This should never happen.  It indicates a bug */
    HYPERDEX_ADMIN_INTERNAL    = 8829,
    HYPERDEX_ADMIN_EXCEPTION   = 8830,
    HYPERDEX_ADMIN_GARBAGE     = 8831
}

hyperdex_admin* hyperdex_admin_create(const char* coordinator, ushort port);

void hyperdex_admin_destroy(hyperdex_admin* admin);

long hyperdex_admin_dump_config(hyperdex_admin* admin, hyperdex_admin_returncode* status, const char** config);

long hyperdex_admin_read_only(hyperdex_admin* admin, int ro, hyperdex_admin_returncode* status);

long hyperdex_admin_wait_until_stable(hyperdex_admin* admin, hyperdex_admin_returncode* status);

long hyperdex_admin_fault_tolerance(hyperdex_admin* admin, const char* space, ulong ft, hyperdex_admin_returncode* status);

int hyperdex_admin_validate_space(hyperdex_admin* admin, const char* description, hyperdex_admin_returncode* status);

long hyperdex_admin_add_space(hyperdex_admin* admin, const char* description, hyperdex_admin_returncode* status);

long hyperdex_admin_rm_space(hyperdex_admin* admin, const char* space, hyperdex_admin_returncode* status);

long hyperdex_admin_mv_space(hyperdex_admin* admin, const char* source, const char* target, hyperdex_admin_returncode* status);

long hyperdex_admin_list_spaces(hyperdex_admin* admin, hyperdex_admin_returncode* status, const char** spaces);

long hyperdex_admin_list_indices(hyperdex_admin* admin, const char* space, hyperdex_admin_returncode* status, const char** indexes);

long hyperdex_admin_list_subspaces(hyperdex_admin* admin, const char* space, hyperdex_admin_returncode* status, const char** subspaces);

long hyperdex_admin_add_index(hyperdex_admin* admin, const char* space, const char* attribute, hyperdex_admin_returncode* status);

long hyperdex_admin_rm_index(hyperdex_admin* admin, ulong idxid, hyperdex_admin_returncode* status);

long hyperdex_admin_server_register(hyperdex_admin* admin, ulong token, const char* address, hyperdex_admin_returncode* status);

long hyperdex_admin_server_online(hyperdex_admin* admin, ulong token, hyperdex_admin_returncode* status);

long hyperdex_admin_server_offline(hyperdex_admin* admin, ulong token, hyperdex_admin_returncode* status);

long hyperdex_admin_server_forget(hyperdex_admin* admin, ulong token, hyperdex_admin_returncode* status);

long hyperdex_admin_server_kill(hyperdex_admin* admin, ulong token, hyperdex_admin_returncode* status);

long hyperdex_admin_backup(hyperdex_admin* admin, const char* backup, hyperdex_admin_returncode* status, const char** backups);

long hyperdex_admin_enable_perf_counters(hyperdex_admin* admin, hyperdex_admin_returncode* status, hyperdex_admin_perf_counter* pc);

void hyperdex_admin_disable_perf_counters(hyperdex_admin* admin);

long hyperdex_admin_loop(hyperdex_admin* admin, int timeout, hyperdex_admin_returncode* status);

int hyperdex_admin_raw_backup(const char* host, ushort port, const char* name, hyperdex_admin_returncode* status);

const (char*) hyperdex_admin_error_message(hyperdex_admin* admin);

const (char*) hyperdex_admin_error_location(hyperdex_admin* admin);

const (char*) hyperdex_admin_returncode_to_string(hyperdex_admin_returncode);
