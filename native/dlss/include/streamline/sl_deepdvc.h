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

#include "sl.h"
#include "sl_helpers.h"

namespace sl
{

enum class DeepDVCMode : uint32_t
{
    eOff,
    eOn,    
    eCount
};

// {23288AAD-7E7E-BE2A-916F-27DA30A3046B}
SL_STRUCT_BEGIN(DeepDVCOptions, StructType({ 0x23288aad, 0x7e7e, 0xbe2a, { 0x91, 0x67, 0x27, 0xda, 0x30, 0xa3, 0x04, 0x6b } }), kStructVersion1)
    //! Specifies which mode should be used
    DeepDVCMode mode = DeepDVCMode::eOff;
    //! Specifies intensity level in range [0,1]. Default 0.5
    float intensity = 0.5f;
    //! Specifies saturation boost in range [0,1]. Default 0.25
    float saturationBoost = 0.25f;
SL_STRUCT_END()

//! Returned by the DeepDVC plugin
//!
// {934FD3D3-B34C-70A7-A139-F19FE04D91D3}
SL_STRUCT_BEGIN(DeepDVCState, StructType({ 0x934fd3d3, 0xb34c, 0x70a7, { 0xa1, 0x39, 0xf1, 0x9f, 0xe0, 0x4d, 0x91, 0xd3 } }), kStructVersion1)
    //! Specified the amount of memory expected to be used
    uint64_t estimatedVRAMUsageInBytes {};
SL_STRUCT_END()

}

//! Sets DeepDVC options
//!
//! Call this method to turn DeepDVC on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DeepDVC options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
using PFun_slDeepDVCSetOptions = sl::Result(const sl::ViewportHandle& viewport, const sl::DeepDVCOptions& options);

//! Provides DeepDVC state for the given viewport
//!
//! Call this method to obtain VRAM usage and other information.
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is to be returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
using PFun_slDeepDVCGetState = sl::Result(const sl::ViewportHandle& viewport, sl::DeepDVCState& state);

//! HELPERS
//! 
inline sl::Result slDeepDVCSetOptions(const sl::ViewportHandle& viewport, const sl::DeepDVCOptions& options)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureDeepDVC, slDeepDVCSetOptions);
    return s_slDeepDVCSetOptions(viewport, options);
}

inline sl::Result slDeepDVCGetState(const sl::ViewportHandle& viewport, sl::DeepDVCState& state)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureDeepDVC, slDeepDVCGetState);
    return s_slDeepDVCGetState(viewport, state);
}
//#define SL_CASE_STR(a) case a : return #a;

inline const char* getDeepDVCModeAsStr(sl::DeepDVCMode v)
{
    switch (v)
    {
        SL_CASE_STR(sl::DeepDVCMode::eOff);
        SL_CASE_STR(sl::DeepDVCMode::eOn);
    };
    return "Unknown";
}
