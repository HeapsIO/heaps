package h3d.impl;

#if (hldx && dx12 && dlss)

typedef DX12Device = dx.Dx12.Device;
typedef DX12Adapter = dx.Dx12.Adapter;
typedef DLSSRes = dx.Dx12.Resource;
typedef DLSSResourceState = dx.Dx12.ResourceState;
typedef DLSSCommandList = dx.Dx12.CommandList;

typedef DLSSFrameToken = hl.Abstract<"dlss_frametoken">;

enum abstract SlResult(Int) {
	var Ok = 0;
	var ErrorIO = 1;
	var ErrorDriverOutOfDate = 2;
	var ErrorOSOutOfDate = 3;
	var ErrorOSDisabledHWS = 4;
	var ErrorDeviceNotCreated = 5;
	var ErrorNoSupportedAdapterFound = 6;
	var ErrorAdapterNotSupported = 7;
	var ErrorNoPlugins = 8;
	var ErrorVulkanAPI = 9;
	var ErrorDXGIAPI = 10;
	var ErrorD3DAPI = 11;
	var ErrorNRDAPI = 12;
	var ErrorNVAPI = 13;
	var ErrorReflexAPI = 14;
	var ErrorNGXFailed = 15;
	var ErrorJSONParsing = 16;
	var ErrorMissingProxy = 17;
	var ErrorMissingResourceState = 18;
	var ErrorInvalidIntegration = 19;
	var ErrorMissingInputParameter = 20;
	var ErrorNotInitialized = 21;
	var ErrorComputeFailed = 22;
	var ErrorInitNotCalled = 23;
	var ErrorExceptionHandler = 24;
	var ErrorInvalidParameter = 25;
	var ErrorMissingConstants = 26;
	var ErrorDuplicatedConstants = 27;
	var ErrorMissingOrInvalidAPI = 28;
	var ErrorCommonConstantsMissing = 29;
	var ErrorUnsupportedInterface = 30;
	var ErrorFeatureMissing = 31;
	var ErrorFeatureNotSupported = 32;
	var ErrorFeatureMissingHooks = 33;
	var ErrorFeatureFailedToLoad = 34;
	var ErrorFeatureWrongPriority = 35;
	var ErrorFeatureMissingDependency = 36;
	var ErrorFeatureManagerInvalidState = 37;
	var ErrorInvalidState = 38;
	var WarnOutOfVRAM = 39;
}

enum abstract DLSSFeature(Int) {
	public var DLSS = 0;
	public var FRAMEGEN = 1;
}

enum abstract DLSSPreset(Int) {
	public var PRESET_DEFAULT = 0;
	public var PRESET_A = 1;
	public var PRESET_B = 2;
	public var PRESET_C = 3;
	public var PRESET_D = 4;
	public var PRESET_E = 5;
	public var PRESET_F = 6;
	public var PRESET_G = 7;
	public var PRESET_H = 8;
	public var PRESET_I = 9;
	public var PRESET_J = 10;
	public var PRESET_K = 11; // Default
	public var PRESET_L = 12; // UltraPerformance
	public var PRESET_M = 13; // Performance
}

enum abstract DLSSMode(Int) {
	public var OFF = 0;
	public var MAXPERFORMANCE = 1;
	public var BALANCED = 2;
	public var MAXQUALITY = 3;
	public var ULTRAPERFORMANCE = 4;
	public var ULTRAQUALITY = 5;
	public var DLAA = 6;
}

@:struct class DLSSOptions {
	public var mode : DLSSMode;
	public var outputWidth : Int;
	public var outputHeight : Int;
	public var preset : DLSSPreset;
	public var colorBufferHDR : Bool;
	public function new() {
	}
}

@:struct class DLSSOptimalSettings {
	public var optimalRenderWidth : Int;
	public var optimalRenderHeight : Int;
	public var optimalSharpness : Float;
	public function new() {
	}
}

enum abstract DLSSBufferType(Int) {
	public var DEPTH = 0;
	public var MOTIONVECTORS = 1;
	public var COLORIN = 2;
	public var COLOROUT = 3;
}

@:struct class DLSSResource {
	public var res : DLSSRes;
	public var width : Int;
	public var height : Int;
	public var type : DLSSBufferType;
	public var state : DLSSResourceState;
	public function new() {
	}
}

@:struct class DLSSVector {
	public var x : Single;
	public var y : Single;
	public var z : Single;
	public function new() {
	}
}

@:struct class DLSSMatrix {
	public var _11 : Single;
	public var _12 : Single;
	public var _13 : Single;
	public var _14 : Single;
	public var _21 : Single;
	public var _22 : Single;
	public var _23 : Single;
	public var _24 : Single;
	public var _31 : Single;
	public var _32 : Single;
	public var _33 : Single;
	public var _34 : Single;
	public var _41 : Single;
	public var _42 : Single;
	public var _43 : Single;
	public var _44 : Single;
	public function new() {
	}
}

@:struct class DLSSConstants {
	public var cameraViewToClip : DLSSMatrix;
	public var clipToCameraView : DLSSMatrix;
	public var clipToLensClip : DLSSMatrix;
	public var clipToPrevClip : DLSSMatrix;
	public var prevClipToClip : DLSSMatrix;
	public var jitterOffsetX : Single;
	public var jitterOffsetY : Single;
	public var mvecScaleX : Single;
	public var mvecScaleY : Single;
	public var cameraPinholeOffsetX : Single;
	public var cameraPinholeOffsetY : Single;
	public var cameraPos : DLSSVector;
	public var cameraUp : DLSSVector;
	public var cameraRight : DLSSVector;
	public var cameraFwd : DLSSVector;
	public var cameraNear : Single;
	public var cameraFar : Single;
	public var cameraFOV : Single;
	public var cameraAspectRatio : Single;
	public var motionVectorsInvalidValue : Single;
	public var depthInverted : Bool;
	public var cameraMotionIncluded : Bool;
	public var motionVectors3D : Bool;
	public var reset : Bool;
	public var orthographicProjection : Bool;
	public var motionVectorsDilated : Bool;
	public var motionVectorsJittered : Bool;
	public var minRelativeLinearDepthObjectSeparation : Single;
	public function new() {
	}
}

@:hlNative("dlss")
class Dlss {
	public static function init(showConsole : Bool) : Int {
		return 0;
	}

	public static function shutdown() : Int {
		return 0;
	}

	public static function setDevice(device : DX12Device) : Int {
		return 0;
	}

	public static function isFeatureSupported(adapter : DX12Adapter, feature : DLSSFeature) : Int {
		return 0;
	}

	public static function getOptimalSettings(options : DLSSOptions) : DLSSOptimalSettings {
		return null;
	}

	public static function getNewFrameToken(frameIndex : Int) : DLSSFrameToken {
		return null;
	}

	public static function setTagForFrame(frameToken : DLSSFrameToken, resources : hl.CArray<DLSSResource>, count : Int, commandList : DLSSCommandList) : Int {
		return 0;
	}

	public static function setOptions(options : DLSSOptions) : Int {
		return 0;
	}

	public static function setConstants(frameToken : DLSSFrameToken, constants : DLSSConstants) : Int {
		return 0;
	}

	public static function evaluateFeature(frameToken : DLSSFrameToken, commandList : DLSSCommandList, feature : DLSSFeature ) : Int {
		return 0;
	}
}

#end
