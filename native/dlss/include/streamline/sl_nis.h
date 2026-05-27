/*
* Copyright (c) 2022-2023 NVIDIA CORPORATION. All rights reserved
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/ 

#pragma once

namespace sl
{

enum class NISMode : uint32_t
{
    eOff,
    eScaler,
    eSharpen,
    eCount
};

enum class NISHDR : uint32_t
{
    eNone,
    eLinear,
    ePQ,
    eCount
};

// {676610E5-9674-4D3A-9C8A-F495D01B36F3}
SL_STRUCT_BEGIN(NISOptions, StructType({ 0x676610e5, 0x9674, 0x4d3a, { 0x9c, 0x8a, 0xf4, 0x95, 0xd0, 0x1b, 0x36, 0xf3 } }), kStructVersion1)
    //! Specifies which mode should be used
    NISMode mode = NISMode::eScaler;
    //! Specifies which hdr mode should be used
    NISHDR hdrMode = NISHDR::eNone;
    //! Specifies sharpening level in range [0,1]
    float sharpness = 0.0f;

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

//! Returned by the NIS plugin
//! 
// {71AB4FD0-D959-4C2A-AF69-ED4850BD4E3D}
SL_STRUCT_BEGIN(NISState, StructType({ 0x71ab4fd0, 0xd959, 0x4c2a, { 0xaf, 0x69, 0xed, 0x48, 0x50, 0xbd, 0x4e, 0x3d } }), kStructVersion1)
    //! Specified the amount of memory expected to be used
    uint64_t estimatedVRAMUsageInBytes {};

//! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

}

//! Sets NIS options
//!
//! Call this method to turn DLSS on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies NIS options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
using PFun_slNISSetOptions = sl::Result(const sl::ViewportHandle& viewport, const sl::NISOptions& options);

//! Provides NIS state for the given viewport
//!
//! Call this method to obtain VRAM usage and other information.
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is to be returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
using PFun_slNISGetState = sl::Result(const sl::ViewportHandle& viewport, sl::NISState& state);

//! HELPERS
//! 
inline sl::Result slNISSetOptions(const sl::ViewportHandle& viewport, const sl::NISOptions& options)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureNIS, slNISSetOptions);
    return s_slNISSetOptions(viewport, options);
}

inline sl::Result slNISGetState(const sl::ViewportHandle& viewport, sl::NISState& state)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureNIS, slNISGetState);
    return s_slNISGetState(viewport, state);
}
