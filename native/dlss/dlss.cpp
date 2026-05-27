#define HL_NAME(n)  dlss_##n
#include <hl.h>
#undef _GUID

#include <vector>

#include <sl.h>
#include <sl_consts.h>
#include <sl_dlss.h>

#ifdef HL_WIN_DESKTOP
#include <dxgi.h>
#include <dxgi1_5.h>
#include <d3d12.h>
#include <dxcapi.h>
#endif

#define _DEVICE _ABSTRACT(dx_device)
#define _ADAPTER _ABSTRACT(dx_adapter)
#define _RES _ABSTRACT(dx_resource)

enum DLSSFeature {
    DLSS,
    FrameGen
};

sl::Feature toSlFeature(DLSSFeature feature) {
    sl::Feature featureId = 0;
    switch (feature) {
    case DLSSFeature::DLSS: {
        featureId = sl::kFeatureDLSS;
        break;
    }
    case DLSSFeature::FrameGen: {
        featureId = sl::kFeatureDLSS_G;
        break;
    }
    }
    return featureId;
}

HL_PRIM int HL_NAME(init)(bool showConsole) {
    sl::Preferences pref{};
    pref.showConsole = showConsole;
    pref.logLevel = sl::LogLevel::eDefault;
    pref.engine = sl::EngineType::eCustom;
    pref.applicationId = 231313132;
    pref.engineVersion = "2.1.1";
    sl::Feature featureList[] = { sl::kFeatureDLSS /*, sl::kFeatureDLSS_G*/ };
    pref.featuresToLoad = featureList;
    pref.numFeaturesToLoad = _countof(featureList);
    pref.flags = sl::PreferenceFlags::eUseFrameBasedResourceTagging;

    sl::Result res = slInit(pref);
    return static_cast<int>(res);
}

HL_PRIM int HL_NAME(shutdown)() {
    sl::Result res = slShutdown();
    return static_cast<int>(res);
}

HL_PRIM int HL_NAME(set_device)(void* nativeDevice) {
    sl::Result res = slSetD3DDevice(nativeDevice);
    return static_cast<int>(res);
}

HL_PRIM int HL_NAME(is_feature_supported)(IDXGIAdapter* adapter, DLSSFeature feature) {
    DXGI_ADAPTER_DESC desc;
    adapter->GetDesc(&desc);
    sl::AdapterInfo adapterInfo;
    adapterInfo.deviceLUID = (uint8_t*)&desc.AdapterLuid;
    adapterInfo.deviceLUIDSizeInBytes = sizeof(LUID);

    sl::Result res = slIsFeatureSupported(toSlFeature(feature), adapterInfo);
    return static_cast<int>(res);
}

struct DLSSOptions {
    sl::DLSSMode mode;
    uint32_t outputWidth;
    uint32_t outputHeight;
    sl::DLSSPreset preset;
    int colorBufferHDR;
};

struct DLSSOptimalSettings {
    uint32_t optimalRenderWidth;
    uint32_t optimalRenderHeight;
    double optimalSharpness;
};

HL_PRIM DLSSOptimalSettings* HL_NAME(get_optimal_settings)(DLSSOptions* options) {
    sl::DLSSOptions dlssOptions;
    dlssOptions.mode = options->mode;
    dlssOptions.outputWidth = options->outputWidth;
    dlssOptions.outputHeight = options->outputHeight;

    sl::DLSSOptimalSettings optimalSettings;
    slDLSSGetOptimalSettings(dlssOptions, optimalSettings);

    DLSSOptimalSettings* outOptimalSettings = new DLSSOptimalSettings();
    outOptimalSettings->optimalRenderWidth = optimalSettings.optimalRenderWidth;
    outOptimalSettings->optimalRenderHeight = optimalSettings.optimalRenderHeight;
    outOptimalSettings->optimalSharpness = (double)optimalSettings.optimalSharpness;

    return outOptimalSettings;
}

typedef sl::FrameToken dlss_frametoken;

#define _FRAMETOKEN _ABSTRACT(dlss_frametoken)

HL_PRIM sl::FrameToken* HL_NAME(get_new_frame_token)(int frameIndex) {
    sl::FrameToken* frameToken = nullptr;
    uint32_t frameId = (uint32_t)frameIndex;
    slGetNewFrameToken(frameToken, &frameId);
    return frameToken;
}

enum DLSSBufferType {
    Depth,
    MotionVectors,
    ColorIn,
    ColorOut
};

struct DLSSResource {
    ID3D12Resource* res;
    int width;
    int height;
    DLSSBufferType type;
    D3D12_RESOURCE_STATES state;
};

HL_PRIM int HL_NAME(set_tag_for_frame)(sl::FrameToken* frameToken, DLSSResource* res, int count, ID3D12GraphicsCommandList* cmdList) {
    std::vector<sl::Resource> slResources(count);
    std::vector<sl::Extent> slExtents(count);
    std::vector<sl::ResourceTag> slTags(count);

    for (int i = 0; i < count; i++) {
        DLSSResource& r = res[i];

        slResources[i] = { sl::ResourceType::eTex2d, r.res, (uint32_t)r.state };
        slExtents[i] = { 0, 0, (uint32_t)r.width, (uint32_t)r.height };

        sl::BufferType type = {};
        switch (r.type) {
        case DLSSBufferType::Depth: type = sl::kBufferTypeDepth; break;
        case DLSSBufferType::MotionVectors: type = sl::kBufferTypeMotionVectors; break;
        case DLSSBufferType::ColorIn: type = sl::kBufferTypeScalingInputColor; break;
        case DLSSBufferType::ColorOut: type = sl::kBufferTypeScalingOutputColor; break;
        }

        slTags[i] = { &slResources[i], type, sl::ResourceLifecycle::eValidUntilEvaluate, &slExtents[i] };
    }

    sl::Result result = slSetTagForFrame(*frameToken, sl::ViewportHandle(0), slTags.data(), (uint32_t)count, cmdList);

    return static_cast<int>(result);
}

HL_PRIM int HL_NAME(set_options)(DLSSOptions* options) {
    sl::DLSSOptions dlssOptions;
    dlssOptions.mode = options->mode;
    dlssOptions.outputWidth = options->outputWidth;
    dlssOptions.outputHeight = options->outputHeight;
    dlssOptions.dlaaPreset = options->preset;
    dlssOptions.colorBuffersHDR = options->colorBufferHDR ? sl::Boolean::eTrue : sl::Boolean::eFalse;

    sl::Result result = slDLSSSetOptions(sl::ViewportHandle(0), dlssOptions);

    return static_cast<int>(result);
}

struct DLSSConstants {
    float* cameraViewToClip;
    float* clipToCameraView;
    float* clipToLensClip;
    float* clipToPrevClip;
    float* prevClipToClip;
    float jitterOffsetX;
    float jitterOffsetY;
    float mvecScaleX;
    float mvecScaleY;
    float cameraPinholeOffsetX;
    float cameraPinholeOffsetY;
    float* cameraPos;
    float* cameraUp;
    float* cameraRight;
    float* cameraFwd;
    float cameraNear;
    float cameraFar;
    float cameraFOV;
    float cameraAspectRatio;
    float motionVectorsInvalidValue;
    int depthInverted;
    int cameraMotionIncluded;
    int motionVectors3D;
    int reset;
    int orthographicProjection;
    int motionVectorsDilated;
    int motionVectorsJittered;
    float minRelativeLinearDepthObjectSeparation;
};

HL_PRIM int HL_NAME(set_constants)(sl::FrameToken* frameToken, DLSSConstants* constants) {
    sl::Constants slConstants{};
    memcpy(&slConstants.cameraViewToClip, constants->cameraViewToClip, sizeof(float) * 16);
    memcpy(&slConstants.clipToCameraView, constants->clipToCameraView, sizeof(float) * 16);
    memcpy(&slConstants.clipToLensClip, constants->clipToLensClip, sizeof(float) * 16);
    memcpy(&slConstants.clipToPrevClip, constants->clipToPrevClip, sizeof(float) * 16);
    memcpy(&slConstants.prevClipToClip, constants->prevClipToClip, sizeof(float) * 16);
    slConstants.jitterOffset = { constants->jitterOffsetX, constants->jitterOffsetY };
    slConstants.mvecScale = { constants->mvecScaleX,    constants->mvecScaleY };
    slConstants.cameraPinholeOffset = { constants->cameraPinholeOffsetX, constants->cameraPinholeOffsetY };
    memcpy(&slConstants.cameraPos, constants->cameraPos, sizeof(float) * 3);
    memcpy(&slConstants.cameraUp, constants->cameraUp, sizeof(float) * 3);
    memcpy(&slConstants.cameraRight, constants->cameraRight, sizeof(float) * 3);
    memcpy(&slConstants.cameraFwd, constants->cameraFwd, sizeof(float) * 3);
    slConstants.cameraNear = constants->cameraNear;
    slConstants.cameraFar = constants->cameraFar;
    slConstants.cameraFOV = constants->cameraFOV;
    slConstants.cameraAspectRatio = constants->cameraAspectRatio;
    slConstants.motionVectorsInvalidValue = constants->motionVectorsInvalidValue;
    slConstants.depthInverted = constants->depthInverted ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.cameraMotionIncluded = constants->cameraMotionIncluded ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.motionVectors3D = constants->motionVectors3D ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.reset = constants->reset ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.orthographicProjection = constants->orthographicProjection ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.motionVectorsDilated = constants->motionVectorsDilated ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.motionVectorsJittered = constants->motionVectorsJittered ? sl::Boolean::eTrue : sl::Boolean::eFalse;
    slConstants.minRelativeLinearDepthObjectSeparation = constants->minRelativeLinearDepthObjectSeparation;

    sl::Result result = slSetConstants(slConstants, *frameToken, sl::ViewportHandle(0));
    return static_cast<int>(result);
}

HL_PRIM int HL_NAME(evaluate_feature)(sl::FrameToken* frameToken, ID3D12GraphicsCommandList* cmdList, DLSSFeature feature) {
    sl::ViewportHandle vp = { sl::ViewportHandle(0) };
    const sl::BaseStructure* inputs[] = { &vp };

    sl::Result result = slEvaluateFeature(toSlFeature(feature), *frameToken, inputs, _countof(inputs), cmdList);
    return static_cast<int>(result);
}

DEFINE_PRIM(_I32, init, _BOOL);
DEFINE_PRIM(_I32, shutdown, _NO_ARG);
DEFINE_PRIM(_I32, set_device, _DEVICE);
DEFINE_PRIM(_I32, is_feature_supported, _ADAPTER _I32);
DEFINE_PRIM(_STRUCT, get_optimal_settings, _STRUCT);
DEFINE_PRIM(_FRAMETOKEN, get_new_frame_token, _I32);
DEFINE_PRIM(_I32, set_tag_for_frame, _FRAMETOKEN _ABSTRACT(hl_carray) _I32 _RES);
DEFINE_PRIM(_I32, set_options, _STRUCT);
DEFINE_PRIM(_I32, set_constants, _FRAMETOKEN _STRUCT);
DEFINE_PRIM(_I32, evaluate_feature, _FRAMETOKEN _RES _I32);