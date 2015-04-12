module deimos.hyperdex.hyperspace_builder;

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

import deimos.hyperdex.core;

extern(C):
public:
nothrow:

struct hyperspace;

/* hyperspace_returncode occupies [8576, 8704) */
enum hyperspace_returncode
{
    HYPERSPACE_SUCCESS       = 8576,
    HYPERSPACE_INVALID_NAME  = 8577,
    HYPERSPACE_INVALID_TYPE  = 8578,
    HYPERSPACE_DUPLICATE     = 8579,
    HYPERSPACE_IS_KEY        = 8580,
    HYPERSPACE_UNKNOWN_ATTR  = 8581,
    HYPERSPACE_NO_SUBSPACE   = 8582,
    HYPERSPACE_OUT_OF_BOUNDS = 8583,
    HYPERSPACE_UNINDEXABLE   = 8584,

    HYPERSPACE_GARBAGE       = 8703
};

hyperspace* hyperspace_create();

hyperspace* hyperspace_parse(const char* desc);

void hyperspace_destroy(hyperspace* space);

const (char*) hyperspace_error(hyperspace* space);

hyperspace_returncode hyperspace_set_name(hyperspace* space, const char* name);

hyperspace_returncode hyperspace_set_key(hyperspace* space, const char* attr, hyperdatatype datatype);

hyperspace_returncode hyperspace_add_attribute(hyperspace* space, const char* attr, hyperdatatype datatype);

hyperspace_returncode hyperspace_add_subspace(hyperspace* space);

hyperspace_returncode hyperspace_add_subspace_attribute(hyperspace* space, const char* attr);

hyperspace_returncode hyperspace_add_index(hyperspace* space, const char* attr);

hyperspace_returncode hyperspace_set_fault_tolerance(hyperspace* space, ulong num);

hyperspace_returncode hyperspace_set_number_of_partitions(hyperspace* space, ulong num);

hyperspace_returncode hyperspace_use_authorization(hyperspace* space);
