/*
 * Copyright 2014-2023 NVIDIA Corporation.  All rights reserved.
 *
 * NOTICE TO USER:
 *
 * This source code is subject to NVIDIA ownership rights under U.S. and
 * international Copyright laws.
 *
 * This software and the information contained herein is PROPRIETARY and
 * CONFIDENTIAL to NVIDIA and is being provided under the terms and conditions
 * of a form of NVIDIA software license agreement.
 *
 * NVIDIA MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE
 * CODE FOR ANY PURPOSE.  IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR
 * IMPLIED WARRANTY OF ANY KIND.  NVIDIA DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOURCE CODE, INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.
 * IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL,
 * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
 * OF USE, DATA OR PROFITS,  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION,  ARISING OUT OF OR IN CONNECTION WITH THE USE
 * OR PERFORMANCE OF THIS SOURCE CODE.
 *
 * U.S. Government End Users.   This source code is a "commercial item" as
 * that term is defined at  48 C.F.R. 2.101 (OCT 1995), consisting  of
 * "commercial computer  software"  and "commercial computer software
 * documentation" as such terms are  used in 48 C.F.R. 12.212 (SEPT 1995)
 * and is provided to the U.S. Government only as a commercial end item.
 * Consistent with 48 C.F.R.12.212 and 48 C.F.R. 227.7202-1 through
 * 227.7202-4 (JUNE 1995), all U.S. Government End Users acquire the
 * source code with only those rights set forth herein.
 *
 * Any use of this source code in individual and commercial software must
 * include, in the user documentation and internal comments to the code,
 * the above Disclaimer and U.S. Government End Users Notice.
 */

#pragma once

namespace sl
{

//! If your plugin does not have any constants then the code below can be removed
//! 
enum class NvPerfMode : uint32_t
{
    eOff,
    eOn,

    eCount
};

//! IMPORTANT: Each structure must have a unique GUID assigned, change this as needed
//!
// {29DF7FE0-273A-4D72-B481-2DC823D5B1AD}
SL_STRUCT_BEGIN(NvPerfConstants, StructType({ 0x29df7fe0, 0x273a, 0x4d72, { 0xb4, 0x81, 0x2d, 0xc8, 0x23, 0xd5, 0xb1, 0xad } }), kStructVersion1)
NvPerfMode mode = NvPerfMode::eOff;

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

//! IMPORTANT: Each structure must have a unique GUID assigned, change this as needed
//!
// {39DF7FE0-283A-4D72-B481-2DC823D5B1AD}
SL_STRUCT_BEGIN(NvPerfSettings, StructType({ 0x39df7fe0, 0x283a, 0x4d72, { 0xb4, 0x81, 0x2d, 0xc8, 0x23, 0xd5, 0xb1, 0xad } }), kStructVersion1)
    
    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

}
