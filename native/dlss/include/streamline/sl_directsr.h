/*
* Copyright (c) 2024 NVIDIA CORPORATION. All rights reserved
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

#include "sl_struct.h"
#include <dxgi.h>

struct ID3D12CommandQueue;
namespace sl
{

enum class DirectSROptimizationType : uint32_t
{
    eBalanced,
    eHighQuality,
    eMaxQuality,
    eHighPerformance,
    eMaxPerformance,
    ePowerSaving,
    eMaxPowerSaving,

    eCount
};

enum class DirectSRVariantFlags : uint32_t
{
    eNone = 0x0,
    eSupportsExposureScaleTexture = 0x1,
    eSupportsIgnoreHistoryMask = 0x2,
    eNative = 0x4,
    eSupportsReactiveMask = 0x8,
    eSupportsSharpness = 0x10,
    eDisallowsRegionOffsets = 0x20,

    eAll = eSupportsExposureScaleTexture | eSupportsIgnoreHistoryMask | eNative | eSupportsReactiveMask | eSupportsSharpness | eDisallowsRegionOffsets
};

// {1AD87504-774E-4BF3-9633-A44D1F7F9CB8}
SL_STRUCT_BEGIN(DirectSROptions, StructType({ 0x1ad87504, 0x774e, 0x4bf3, { 0x96, 0x33, 0xa4, 0x4d, 0x1f, 0x7f, 0x9c, 0xb8 } }), kStructVersion1)
    // DirectSR variant index as enumerated
    uint32_t variantIndex;

    // D3D12 command queue to execute work on
    ID3D12CommandQueue *pCommandQueue;

    //! Specifies which mode should be used
    DirectSROptimizationType optType;

    //! Specifies output (final) target width
    uint32_t outputWidth = INVALID_UINT;

    //! Specifies output (final) target height
    uint32_t outputHeight = INVALID_UINT;

    //! Specifies sharpening level in range [0,1]
    float sharpness = 0.0f;

    //! Specifies pre-exposure value
    float preExposure = 1.0f;

    //! Specifies exposure scale value
    float exposureScale = 1.0f;

    //! Specifies if tagged color buffers are full HDR or not (DLSS in HDR pipeline or not)
    Boolean colorBuffersHDR = Boolean::eTrue;

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

//! Returned by DirectSR plugin
//! 
//! {1BD0C637-A28F-41F2-BC91-B421FAEE8E1E}
SL_STRUCT_BEGIN(DirectSROptimalSettings, StructType({ 0x1bd0c637, 0xa28f, 0x41f2, { 0xbc, 0x91, 0xb4, 0x21, 0xfa, 0xee, 0x8e, 0x1e } }), kStructVersion1)
//! Specifies render area width
    uint32_t optimalRenderWidth{};
    //! Specifies render area height
    uint32_t optimalRenderHeight{};
    //! Specifies minimal render area width
    uint32_t renderWidthMin{};
    //! Specifies minimal render area height
    uint32_t renderHeightMin{};
    //! Specifies maximal render area width
    uint32_t renderWidthMax{};
    //! Specifies maximal render area height
    uint32_t renderHeightMax{};

    // optimal color format
    DXGI_FORMAT optimalColorFormat;

    // optimal depth format
    DXGI_FORMAT optimalDepthFormat;

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

//! Returned by DirectSR plugin
//! 
//! {38216184-79ba-48cb-93f5-7a8a59382fdf}
SL_STRUCT_BEGIN(DirectSRVariantInfo, StructType({ 0x38216184, 0x79ba, 0x48cb, { 0x93, 0xf5, 0x7a, 0x8a, 0x59, 0x38, 0x2f, 0xdf } }), kStructVersion1)
    char name[128];
    sl::DirectSRVariantFlags flags;
    sl::DirectSROptimizationType optimizationRankings[7];
    DXGI_FORMAT optimalTargetFormat;
    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
SL_STRUCT_END()

}

//! Provides optimal DirectSR settings
//!
//! Call this method to obtain optimal render target size and other DirectSR related settings.
//!
//! @param options Specifies DirectSR options to use
//! @param settings Reference to a structure where settings are returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
using PFun_slDirectSRGetOptimalSettings = sl::Result(const sl::DirectSROptions & options, sl::DirectSROptimalSettings & settings);

//! Retrive information about the available DirectSR variants.
using PFun_slDirectSRGetVariantInfo = sl::Result(uint32_t *numVariants, sl::DirectSRVariantInfo *variantInfo);

//! Sets DirectSR options
//!
//! Call this method to turn DirectSR on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DirectSR options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
using PFun_slDirectSRSetOptions = sl::Result(const sl::ViewportHandle& viewport, const sl::DirectSROptions& options);

//! HELPERS
//! 
inline sl::Result slDirectSRGetOptimalSettings(const sl::DirectSROptions& options, sl::DirectSROptimalSettings& settings)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureDirectSR, slDirectSRGetOptimalSettings);
    return s_slDirectSRGetOptimalSettings(options, settings);
}

inline sl::Result slDirectSRGetVariantInfo(uint32_t *numVariants, sl::DirectSRVariantInfo *variantInfo)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureDirectSR, slDirectSRGetVariantInfo);
    return s_slDirectSRGetVariantInfo(numVariants, variantInfo);
}

inline sl::Result slDirectSRSetOptions(const sl::ViewportHandle& viewport, const sl::DirectSROptions& options)
{
    SL_FEATURE_FUN_IMPORT_STATIC(sl::kFeatureDirectSR, slDirectSRSetOptions);
    return s_slDirectSRSetOptions(viewport, options);
}

