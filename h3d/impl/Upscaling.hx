package h3d.impl;

#if (hldx && dx12)

import h3d.impl.Driver;
import h3d.impl.DX12Driver;
import dx.Dx12;

#if dlss
import heaps.dlss.Dlss;
#end
#if fsr
import heaps.fsr.Fsr;
#end

private typedef Driver = Dx12;

enum abstract UpscalingProvider(Int) {
	var NONE = 0;
	var DLSS = 1;
	var FSR = 2;

	public function toString() {
		return switch( abstract ) {
			case DLSS: "DLSS";
			case FSR: "FSR";
			default: "none";
		}
	}
}

@:access(h3d.impl.DX12Driver)
class DX12Upscaling {

	var driver : DX12Driver;

	#if dlss
	var slReady : Bool;
	var dlssReady : Bool;
	var framegenReady : Bool;
	var pclReady : Bool;
	var reflexReady : Bool;
	var reflexState : ReflexStateInfo;
	var pclFlashRequested : Bool;
	var dlssgMode : h3d.impl.Driver.FrameGenMode = Off;
	var dlssgFrames : Int = 1;
	var dlssgLastStatus : Int = 0;
	var reflexMode : LowLatencyMode = Off;
	var dlssConstantsFrame : Int = -1;
	var slInitResult : Int = -1;
	var dlssSupportResult : Int = -1;
	var dlssLastResult : Int = 0;
	#end

	#if fsr
	var fsrLoaded : Bool;
	var fsrInitResult : Int = -1;
	var fsrContext : FsrContext;
	var fsrContextWidth : Int = -1;
	var fsrContextHeight : Int = -1;
	var fsrContextFlags : Int = -1;
	var fsrLastResult : Int = 0;
	var fsrSwapChain : FsrSwapChain;
	var fsrProxy : FsrSwapChain;
	var fsrSwapChainResult : Int = FsrResult.NotCreated;
	var fsrFgContext : FsrContext;
	var fsrFgContextWidth : Int = -1;
	var fsrFgContextHeight : Int = -1;
	var fsrFgContextFlags : Int = -1;
	var fsrFgContextResult : Int = 0;
	var fsrFgMode : h3d.impl.Driver.FrameGenMode = Off;
	var fsrFgPendingRelease : Bool;
	var fsrFgFrameId : Int = 0;
	var fsrFgConfiguredFrame : Int = -1;
	var fsrFgPreparedFrame : Int = -1;
	var fsrFgConfigureResult : Int = 0;
	var fsrFgPrepareResult : Int = 0;
	var fsrFgDepth : h3d.mat.Texture;
	var fsrFgMotionVectors : h3d.mat.Texture;
	var fsrFgName : String;
	var fsrUiRegistered : Bool;
	var antiLag2Ready : Bool;
	var antiLag2Result : Int = 0;
	var antiLag2Mode : LowLatencyMode = Off;
	var antiLag2MaxFps : Int = 0;
	#end

	var upscalerProvider : UpscalingProvider = NONE;
	var frameGenProvider : UpscalingProvider = NONE;
	var nativeDevice : Device;
	var nativeQueue : CommandQueue;
	var presentCount : Int = 0;
	var frameGenUIMode : h3d.impl.Driver.FrameGenUIMode = h3d.impl.Driver.FrameGenUIMode.BackBuffer;
	var hudlessTextures : Array<h3d.mat.Texture> = [];
	var hudlessCaptured : Int = -1;
	var frameGenUITarget : h3d.mat.Texture;
	var frameGenUIDrawn : Int = -1;

	var upscalingFrame : Int = -1;
	var upscalingMode : UpscalingMode = Off;
	var upscalingColorIn : h3d.mat.Texture;
	var upscalingColorOut : h3d.mat.Texture;
	var upscalingDepth : h3d.mat.Texture;
	var upscalingMotionVectors : h3d.mat.Texture;

	var dlssUpCandidate : Bool;
	var dlssFgCandidate : Bool;
	var fsrUpCandidate : Bool;
	var fsrFgCandidate : Bool;
	var nativeFactory : Factory;
	#if dlss
	var resizeDlssgMode : h3d.impl.Driver.FrameGenMode = Off;
	#end

	public function new( driver : DX12Driver ) {
		this.driver = driver;
	}

	public function beforeCreateDevice() {
		upscalerProvider = UpscalingProvider.NONE;
		frameGenProvider = UpscalingProvider.NONE;
		dlssUpCandidate = DX12Driver.ENABLE_UPSCALING && (DX12Driver.UPSCALER == UpscalerSelection.AUTO || DX12Driver.UPSCALER == UpscalerSelection.DLSS);
		dlssFgCandidate = DX12Driver.ENABLE_UPSCALING && DX12Driver.FRAME_GEN && (DX12Driver.FRAME_GEN_PROVIDER == UpscalerSelection.AUTO || DX12Driver.FRAME_GEN_PROVIDER == UpscalerSelection.DLSS);
		fsrUpCandidate = DX12Driver.ENABLE_UPSCALING && (DX12Driver.UPSCALER == UpscalerSelection.AUTO || DX12Driver.UPSCALER == UpscalerSelection.FSR);
		fsrFgCandidate = DX12Driver.ENABLE_UPSCALING && DX12Driver.FRAME_GEN && (DX12Driver.FRAME_GEN_PROVIDER == UpscalerSelection.AUTO || DX12Driver.FRAME_GEN_PROVIDER == UpscalerSelection.FSR);

		#if dlss
		if ( dlssUpCandidate || dlssFgCandidate || (DX12Driver.ENABLE_UPSCALING && DX12Driver.LOW_LATENCY) ) {
			var features = [];
			if ( dlssUpCandidate ) features.push(DLSSFeature.DLSS);
			if ( dlssFgCandidate ) features.push(DLSSFeature.FRAMEGEN);
			if ( DX12Driver.LOW_LATENCY || dlssFgCandidate ) features.push(DLSSFeature.REFLEX);
			var nativeFeatures = new hl.NativeArray<Int>(features.length);
			for ( i => f in features )
				nativeFeatures[i] = f;
			slInitResult = Dlss.init(DX12Driver.UPSCALER_DEBUG, nativeFeatures, DX12Driver.CHECK_SL_DLL_SIGNATURE);
			slReady = slInitResult == 0;
		}
		#end
	}

	public function afterCreateDevice() {
		nativeDevice = Driver.getDevice();
		nativeFactory = Driver.getFactory();

		var fsrUpOk = false;
		var fsrFgOk = false;
		#if fsr
		if ( fsrUpCandidate || fsrFgCandidate ) {
			fsrInitResult = Fsr.init(nativeDevice, DX12Driver.UPSCALER_DEBUG ? FsrDebugLevel.WARNINGS : FsrDebugLevel.ERRORS);
			fsrLoaded = fsrInitResult == FsrResult.Ok;
			if ( fsrLoaded ) {
				fsrUpOk = fsrUpCandidate && Fsr.isEffectAvailable(nativeDevice, FsrEffect.UPSCALE);
				fsrFgOk = fsrFgCandidate && Fsr.isEffectAvailable(nativeDevice, FsrEffect.FRAME_GENERATION);
			} else
				trace('FSR unavailable ($fsrInitResult)');
		}
		#end

		var dlssOk = false;
		var dlssgOk = false;
		#if dlss
		var reflexOk = false;
		if ( slReady ) {
			var adapter = Driver.getAdapter();
			if ( dlssUpCandidate ) {
				dlssSupportResult = Dlss.isFeatureSupported(adapter, DLSSFeature.DLSS);
				dlssOk = dlssSupportResult == 0;
			}
			dlssgOk = dlssFgCandidate && Dlss.isFeatureSupported(adapter, DLSSFeature.FRAMEGEN) == 0;
			reflexOk = (DX12Driver.LOW_LATENCY || dlssgOk) && Dlss.isFeatureSupported(adapter, DLSSFeature.REFLEX) == 0;
		}
		#end

		upscalerProvider = dlssOk ? UpscalingProvider.DLSS : (fsrUpOk ? UpscalingProvider.FSR : UpscalingProvider.NONE);
		frameGenProvider = dlssgOk ? UpscalingProvider.DLSS : (fsrFgOk ? UpscalingProvider.FSR : UpscalingProvider.NONE);

		#if dlss
		if ( slReady && upscalerProvider != UpscalingProvider.DLSS && frameGenProvider != UpscalingProvider.DLSS && !reflexOk ) {
			Dlss.shutdown();
			slReady = false;
		}
		if ( slReady ) {
			var proxyDevice = Dlss.upgradeDevice(nativeDevice);
			Driver.setDevice(proxyDevice);
			slReady = Dlss.setDevice(Driver.getDevice()) == 0;
			if ( slReady ) {
				if ( dlssFgCandidate && frameGenProvider != UpscalingProvider.DLSS )
					Dlss.setFeatureLoaded(DLSSFeature.FRAMEGEN, false);
				var adapter = Driver.getAdapter();
				dlssReady = upscalerProvider == UpscalingProvider.DLSS;
				framegenReady = frameGenProvider == UpscalingProvider.DLSS;
				if ( reflexOk ) {
					pclReady = Dlss.isFeatureSupported(adapter, DLSSFeature.PCL) == 0 && Dlss.pclInitStats() == 0;
					reflexReady = true;
					if ( reflexState == null ) reflexState = new ReflexStateInfo();
					reflexReady = setLowLatencyOptions(Off, 0);
				}
			}
		}
		if ( !slReady ) {
			dlssReady = false;
			framegenReady = false;
			pclReady = false;
			reflexReady = false;
			if ( upscalerProvider == UpscalingProvider.DLSS ) upscalerProvider = fsrUpOk ? UpscalingProvider.FSR : UpscalingProvider.NONE;
			if ( frameGenProvider == UpscalingProvider.DLSS ) frameGenProvider = fsrFgOk ? UpscalingProvider.FSR : UpscalingProvider.NONE;
		}
		#end

		#if fsr
		antiLag2Ready = false;
		var reflexActive = #if dlss slReady && reflexReady #else false #end;
		if ( DX12Driver.ENABLE_UPSCALING && DX12Driver.LOW_LATENCY && !reflexActive ) {
			antiLag2Result = Fsr.antiLag2Init(nativeDevice);
			antiLag2Ready = antiLag2Result == 0;
		}
		#end
	}

	public function afterCreateQueue() {
		#if (hldx > version("1.16.0"))
		nativeQueue = driver.directQueue;
		#if dlss
		if ( slReady ) nativeQueue = Dlss.getNativeQueue(driver.directQueue);
		#end
		#end

		#if dlss
		if ( slReady )
			Driver.setFactory(Dlss.upgradeFactory(nativeFactory));
		#end

		#if fsr
		fsrSwapChain = null;
		fsrProxy = null;
		fsrSwapChainResult = FsrResult.NotCreated;
		fsrFgName = null;
		if ( frameGenProvider == UpscalingProvider.FSR ) {
			var res = 0;
			fsrProxy = Fsr.createSwapChain(@:privateAccess driver.window.win, nativeFactory, nativeQueue, driver.window.width, driver.window.height, DX12Driver.BUFFER_COUNT, R8G8B8A8_UNORM, res);
			fsrSwapChainResult = res;
			if ( fsrProxy == null ) {
				trace('FSR frame generation swapchain unavailable ($res)');
				frameGenProvider = UpscalingProvider.NONE;
			} else {
				fsrSwapChain = fsrProxy;
				#if dlss
				if ( slReady )
					fsrSwapChain = Dlss.upgradeSwapChain(fsrProxy);
				#end
				Driver.setSwapChain(fsrSwapChain);
				var version = Fsr.getEffectVersion(nativeDevice, FsrEffect.FRAME_GENERATION);
				fsrFgName = version == null ? "FSR FG" : "FSR FG " + version;
			}
		}
		#end
	}

	public function beginFrame() {
		#if dlss
		if ( slReady ) {
			driver.frame.dlssFrameToken = Dlss.getNewFrameToken(driver.frameCount);
			if ( reflexReady ) Dlss.reflexGetState(reflexState);
		}
		#end
	}

	public function begin() {
		#if dlss
		pclMarker(PCLMarker.RENDER_SUBMIT_START);
		#end
	}

	public function beforeResize() {
		#if dlss
		resizeDlssgMode = dlssgMode;
		if ( frameGenProvider == UpscalingProvider.DLSS && dlssgMode != Off ) setFrameGenMode(Off);
		#end
	}

	public function releaseResizeResources() {
		#if fsr
		destroyFsrContext();
		destroyFsrFgContext();
		#end
		disposeFrameGenTextures();
	}

	public function afterResize() {
		#if dlss
		if ( frameGenProvider == UpscalingProvider.DLSS && resizeDlssgMode != Off ) setFrameGenMode(resizeDlssgMode, dlssgFrames);
		#end
	}

	public function beforePresent() {
		#if fsr
		if ( frameGenProvider == UpscalingProvider.FSR )
			finishFsrFrameGen();
		#end
		prepareFrameGenInputs();
	}

	public function beforeQueuePresent() {
		#if fsr
		if ( antiLag2Ready && fsrProxy != null )
			antiLag2Result = Fsr.antiLag2Present(fsrProxy, antiLag2Mode != Off);
		#end
		#if dlss
		pclMarker(PCLMarker.RENDER_SUBMIT_END);
		pclMarker(PCLMarker.PRESENT_START);
		#end
	}

	public function afterQueuePresent() {
		presentCount++;
		#if fsr
		if ( fsrProxy != null ) {
			fsrFgFrameId++;
			if ( fsrFgPendingRelease ) {
				fsrFgPendingRelease = false;
				destroyFsrFgContext();
			}
		}
		#end
		#if dlss
		pclMarker(PCLMarker.PRESENT_END);
		if ( dlssgMode == Off )
			dlssgSettings.framesPresented = 1;
		else if ( refreshDLSSGState() && dlssgSettings.status != 0 )
			setFrameGenMode(Off);
		#end
	}

	public function shutdownUpscaling() {
		disposeFrameGenTextures();
		#if fsr
		if ( fsrProxy != null ) {
			destroyFsrFgContext();
			Fsr.destroySwapChainContext();
			Driver.setSwapChain(null);
			var refsLeft = Fsr.releaseSwapChain(fsrSwapChain);
			if ( DX12Driver.UPSCALER_DEBUG || refsLeft != 0 )
				trace('FSR frame generation swapchain released ($refsLeft refs left)');
			fsrSwapChain = null;
			fsrProxy = null;
		}
		destroyFsrContext();
		#end
		#if dlss
		if ( slReady ) {
			if ( dlssgMode != Off ) {
				setFrameGenMode(Off, 1, true);
				Dlss.setFeatureLoaded(DLSSFeature.FRAMEGEN, false);
			}
			driver.waitGpu();
			Dlss.shutdown();
			slReady = false;
			dlssReady = false;
			framegenReady = false;
			pclReady = false;
			reflexReady = false;
		}
		#end
		#if fsr
		if ( antiLag2Ready ) {
			Fsr.antiLag2DeInit();
			antiLag2Ready = false;
		}
		if ( fsrLoaded ) {
			Fsr.shutdown();
			fsrLoaded = false;
		}
		#end
		upscalerProvider = UpscalingProvider.NONE;
		frameGenProvider = UpscalingProvider.NONE;
	}

	#if dlss
	inline static function loadDlssVec( vec : DLSSVector, v : h3d.Vector ) {
		vec.x = cast(v.x, Single);
		vec.y = cast(v.y, Single);
		vec.z = cast(v.z, Single);
	}

	inline static function loadDlssMat( mat : DLSSMatrix, m : h3d.Matrix ) {
		mat._11 = cast(m._11, Single); mat._12 = cast(m._12, Single); mat._13 = cast(m._13, Single); mat._14 = cast(m._14, Single);
		mat._21 = cast(m._21, Single); mat._22 = cast(m._22, Single); mat._23 = cast(m._23, Single); mat._24 = cast(m._24, Single);
		mat._31 = cast(m._31, Single); mat._32 = cast(m._32, Single); mat._33 = cast(m._33, Single); mat._34 = cast(m._34, Single);
		mat._41 = cast(m._41, Single); mat._42 = cast(m._42, Single); mat._43 = cast(m._43, Single); mat._44 = cast(m._44, Single);
	}

	static var dlssOptimalSettings = new DLSSOptimalSettings();
	static var dlssSettings = new UpscalingSettings();
	static var dlssOptions = new DLSSOptions();
	static var dlssConstants = new DLSSConstants();
	static var dlssgOptions = new DLSSGOptions();
	static var dlssgStateInfo = new DLSSGStateInfo();
	static var dlssgSettings = new h3d.impl.Driver.FrameGenSettings();
	static var matCameraViewToClip = new DLSSMatrix();
	static var matClipToCameraView = new DLSSMatrix();
	static var matClipToLensClip = new DLSSMatrix();
	static var matClipToPrevClip = new DLSSMatrix();
	static var matPrevClipToClip = new DLSSMatrix();
	static var vecCameraPos = new DLSSVector();
	static var vecCameraUp = new DLSSVector();
	static var vecCameraRight = new DLSSVector();
	static var vecCameraFwd = new DLSSVector();
	#end

	#if fsr
	static var fsrParams = new FsrDispatchParams();
	static var fsrSettings = new UpscalingSettings();
	static var fsrSettingsMode : UpscalingMode = null;
	static var fsrSettingsWidth = -1;
	static var fsrSettingsHeight = -1;

	function destroyFsrContext() {
		if ( fsrContext != null ) {
			driver.waitGpu();
			Fsr.destroyContext(fsrContext);
			fsrContext = null;
		}
		fsrContextWidth = -1;
		fsrContextHeight = -1;
		fsrContextFlags = -1;
	}

	function getFsrQuality( mode : UpscalingMode ) : FsrQuality {
		return switch (mode) {
			case Off, NativeAA: FsrQuality.NATIVE_AA;
			case Quality: FsrQuality.QUALITY;
			case Balanced: FsrQuality.BALANCED;
			case Performance: FsrQuality.PERFORMANCE;
			case UltraPerformance: FsrQuality.ULTRA_PERFORMANCE;
		}
	}

	function getFsrSettings( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		if ( mode == fsrSettingsMode && targetWidth == fsrSettingsWidth && targetHeight == fsrSettingsHeight )
			return fsrSettings;
		var renderWidth = targetWidth;
		var renderHeight = targetHeight;
		var res = Fsr.getRenderResolution(nativeDevice, getFsrQuality(mode), targetWidth, targetHeight, renderWidth, renderHeight);
		if ( res != FsrResult.Ok ) {
			trace('FSR render resolution query failed ($res)');
			renderWidth = targetWidth;
			renderHeight = targetHeight;
		}
		fsrSettings.renderWidth = renderWidth;
		fsrSettings.renderHeight = renderHeight;
		fsrSettingsMode = mode;
		fsrSettingsWidth = targetWidth;
		fsrSettingsHeight = targetHeight;
		return fsrSettings;
	}

	function applyFsr( resources : Map<h3d.impl.Driver.UpscalingTag, h3d.mat.Texture>, params : UpscalingParams ) {
		var color = resources[ColorIn];
		var depth = resources[Depth];
		var motionVectors = resources[MotionVectors];
		var output = resources[ColorOut];
		if ( color?.t == null || depth?.t == null || motionVectors?.t == null || output?.t == null )
			return;

		var flags = 0;
		if ( params.autoExposure )
			flags |= FsrCreateFlag.AUTO_EXPOSURE;
		if ( params.colorBufferHDR )
			flags |= FsrCreateFlag.HIGH_DYNAMIC_RANGE;
		else
			flags |= FsrCreateFlag.NON_LINEAR_COLORSPACE;
		if ( params.depthInverted )
			flags |= FsrCreateFlag.DEPTH_INVERTED;
		if ( params.motionVectorsJittered )
			flags |= FsrCreateFlag.MOTION_VECTORS_JITTER_CANCELLATION;
		if ( DX12Driver.UPSCALER_DEBUG ) {
			flags |= FsrCreateFlag.DEBUG_CHECKING;
			flags |= FsrCreateFlag.DEBUG_VISUALIZATION;
		}

		if ( output.width != fsrContextWidth || output.height != fsrContextHeight || flags != fsrContextFlags ) {
			destroyFsrContext();
			var res = 0;
			fsrContext = Fsr.createContext(nativeDevice, flags, output.width, output.height, output.width, output.height, res);
			fsrContextWidth = output.width;
			fsrContextHeight = output.height;
			fsrContextFlags = flags;
			if ( fsrContext == null )
				trace('FSR context creation failed ($res)');
			else
				trace('FSR ${Fsr.getVersion(fsrContext)} context ${output.width}x${output.height}');
		}
		if ( fsrContext == null )
			return;

		driver.flushTransitions();

		var p = fsrParams;
		p.color = color.t.res;
		p.colorState = color.t.state;
		p.depth = depth.t.res;
		p.depthState = depth.t.state;
		p.motionVectors = motionVectors.t.res;
		p.motionVectorsState = motionVectors.t.state;
		p.output = output.t.res;
		p.outputState = output.t.state;
		p.jitterOffsetX = params.jitterOffsetX;
		p.jitterOffsetY = params.jitterOffsetY;
		p.motionVectorScaleX = params.mvecScaleX * color.width;
		p.motionVectorScaleY = params.mvecScaleY * color.height;
		p.renderWidth = color.width;
		p.renderHeight = color.height;
		p.upscaleWidth = output.width;
		p.upscaleHeight = output.height;
		p.enableSharpening = false;
		p.sharpness = 0.;
		p.frameTimeDelta = hxd.Timer.elapsedTime * 1000.;
		p.preExposure = 1.;
		p.reset = params.reset;
		p.cameraNear = params.cameraNear;
		p.cameraFar = params.cameraFar;
		p.cameraFovAngleVertical = hxd.Math.degToRad(params.cameraFOV);
		p.viewSpaceToMetersFactor = 1.;
		var dispatchFlags = 0;
		if ( !params.colorBufferHDR )
			dispatchFlags |= FsrDispatchFlag.NON_LINEAR_COLOR_SRGB;
		if ( DX12Driver.UPSCALER_DEBUG && DX12Driver.UPSCALER_DEBUG_VIEW )
			dispatchFlags |= FsrDispatchFlag.DRAW_DEBUG_VIEW;
		p.flags = dispatchFlags;

		driver.beginEvent("FSR");
		var res = Fsr.dispatch(fsrContext, driver.frame.commandList, p);
		driver.endEvent();
		if ( res != fsrLastResult ) {
			if ( res != FsrResult.Ok )
				trace('FSR dispatch failed ($res)');
			fsrLastResult = res;
		}

		var arr = driver.tmp.descriptors2;
		arr[0] = @:privateAccess driver.frame.srvHeap.heap;
		arr[1] = @:privateAccess driver.frame.samplerHeap.heap;
		driver.frame.commandList.setDescriptorHeaps(arr);
		driver.heapCount++;
		driver.currentShader = null;
		driver.currentPipelineState = null;

		color.lastFrame = driver.frameCount;
		depth.lastFrame = driver.frameCount;
		motionVectors.lastFrame = driver.frameCount;
		output.lastFrame = driver.frameCount;
	}

	static var fsrFgConfig = new FsrFrameGenConfig();
	static var fsrFgPrepare = new FsrFrameGenPrepareParams();
	static var fsrFgSettings = new h3d.impl.Driver.FrameGenSettings();

	static inline var FSR_FG_STATUS_CONTEXT_FAILED = 1;
	static inline var FSR_FG_STATUS_CONFIGURE_FAILED = 2;
	static inline var FSR_FG_STATUS_PREPARE_FAILED = 4;
	static inline var FSR_FG_STATUS_NOT_PREPARED = 8;

	function configureFsrFrameGen( enabled : Bool ) : Int {
		var cfg = fsrFgConfig;
		var hudless = enabled ? getHudlessTexture() : null;
		cfg.swapChain = fsrProxy;
		cfg.hudless = hudless == null ? null : hudless.t.res;
		cfg.hudlessState = hudless == null ? COMMON : NON_PIXEL_SHADER_RESOURCE;
		cfg.flags = DX12Driver.FRAME_GEN_DEBUG_FLAGS;
		cfg.rectX = 0;
		cfg.rectY = 0;
		cfg.rectWidth = driver.currentWidth;
		cfg.rectHeight = driver.currentHeight;
		cfg.frameID = fsrFgFrameId;
		cfg.enabled = enabled;
		cfg.allowAsyncWorkloads = DX12Driver.FRAME_GEN_ASYNC;
		cfg.onlyPresentGenerated = false;
		return Fsr.configureFrameGen(fsrFgContext, cfg);
	}

	function destroyFsrFgContext() {
		if ( fsrFgContext != null ) {
			driver.waitGpu();
			configureFsrFrameGen(false);
			Fsr.waitForPresents();
			Fsr.destroyContext(fsrFgContext);
			fsrFgContext = null;
		}
		fsrFgContextWidth = -1;
		fsrFgContextHeight = -1;
		fsrFgContextFlags = -1;
		fsrFgContextResult = 0;
	}

	function setFsrFrameGenMode( mode : h3d.impl.Driver.FrameGenMode, releaseResources : Bool ) : Bool {
		if ( fsrProxy == null )
			return false;
		if ( mode == Off ) {
			fsrFgMode = Off;
			if ( releaseResources && fsrFgContext != null )
				fsrFgPendingRelease = true;
		} else {
			fsrFgMode = On;
			fsrFgPendingRelease = false;
			if ( antiLag2Ready && antiLag2Mode == Off )
				antiLag2Mode = LowLatencyMode.On;
		}
		return true;
	}

	function applyFsrFrameGen( params : UpscalingParams ) {
		var depth = fsrFgDepth;
		var motionVectors = fsrFgMotionVectors;
		fsrFgDepth = null;
		fsrFgMotionVectors = null;
		if ( fsrProxy == null || fsrFgConfiguredFrame == fsrFgFrameId )
			return;

		var enabled = fsrFgMode != Off && depth?.t != null && motionVectors?.t != null;
		if ( enabled ) {
			var flags = 0;
			if ( params.depthInverted )
				flags |= FsrFrameGenCreateFlag.DEPTH_INVERTED;
			if ( params.motionVectorsJittered )
				flags |= FsrFrameGenCreateFlag.MOTION_VECTORS_JITTER_CANCELLATION;
			if ( DX12Driver.UPSCALER_DEBUG )
				flags |= FsrFrameGenCreateFlag.DEBUG_CHECKING;
			if ( DX12Driver.FRAME_GEN_ASYNC )
				flags |= FsrFrameGenCreateFlag.ASYNC_WORKLOAD_SUPPORT;
			if ( driver.currentWidth != fsrFgContextWidth || driver.currentHeight != fsrFgContextHeight || flags != fsrFgContextFlags ) {
				destroyFsrFgContext();
				var res = 0;
				fsrFgContext = Fsr.createFrameGenContext(nativeDevice, flags, driver.currentWidth, driver.currentHeight, driver.currentWidth, driver.currentHeight, DxgiFormat.R8G8B8A8_UNORM, DxgiFormat.UNKNOWN, res);
				fsrFgContextResult = res;
				fsrFgContextWidth = driver.currentWidth;
				fsrFgContextHeight = driver.currentHeight;
				fsrFgContextFlags = flags;
				if ( fsrFgContext == null )
					trace('FSR frame generation context creation failed ($res)');
				else if ( DX12Driver.UPSCALER_DEBUG )
					trace('$fsrFgName context ${driver.currentWidth}x${driver.currentHeight}');
			}
		}
		if ( fsrFgContext == null )
			return;

		fsrFgConfigureResult = configureFsrFrameGen(enabled);
		fsrFgConfiguredFrame = fsrFgFrameId;
		if ( !enabled || fsrFgConfigureResult != FsrResult.Ok )
			return;

		driver.flushTransitions();

		var p = fsrFgPrepare;
		p.depth = depth.t.res;
		p.depthState = depth.t.state;
		p.motionVectors = motionVectors.t.res;
		p.motionVectorsState = motionVectors.t.state;
		p.renderWidth = motionVectors.width;
		p.renderHeight = motionVectors.height;
		p.jitterOffsetX = params.jitterOffsetX;
		p.jitterOffsetY = params.jitterOffsetY;
		p.motionVectorScaleX = params.mvecScaleX * motionVectors.width;
		p.motionVectorScaleY = params.mvecScaleY * motionVectors.height;
		p.frameTimeDelta = hxd.Timer.elapsedTime * 1000.;
		p.reset = params.reset;
		p.cameraNear = params.cameraNear;
		p.cameraFar = params.cameraFar;
		p.cameraFovAngleVertical = hxd.Math.degToRad(params.cameraFOV);
		p.viewSpaceToMetersFactor = 1.;
		p.cameraPositionX = params.cameraPos.x;
		p.cameraPositionY = params.cameraPos.y;
		p.cameraPositionZ = params.cameraPos.z;
		p.cameraUpX = params.cameraUp.x;
		p.cameraUpY = params.cameraUp.y;
		p.cameraUpZ = params.cameraUp.z;
		p.cameraRightX = params.cameraRight.x;
		p.cameraRightY = params.cameraRight.y;
		p.cameraRightZ = params.cameraRight.z;
		p.cameraForwardX = params.cameraFwd.x;
		p.cameraForwardY = params.cameraFwd.y;
		p.cameraForwardZ = params.cameraFwd.z;
		p.frameID = fsrFgFrameId;
		p.flags = DX12Driver.FRAME_GEN_DEBUG_FLAGS;

		driver.beginEvent("FSR FG Prepare");
		fsrFgPrepareResult = Fsr.dispatchFrameGenPrepare(fsrFgContext, driver.frame.commandList, p);
		driver.endEvent();
		fsrFgPreparedFrame = fsrFgFrameId;

		var arr = driver.tmp.descriptors2;
		arr[0] = @:privateAccess driver.frame.srvHeap.heap;
		arr[1] = @:privateAccess driver.frame.samplerHeap.heap;
		driver.frame.commandList.setDescriptorHeaps(arr);
		driver.heapCount++;
		driver.currentShader = null;
		driver.currentPipelineState = null;

		depth.lastFrame = driver.frameCount;
		motionVectors.lastFrame = driver.frameCount;
	}

	function finishFsrFrameGen() {
		if ( fsrFgContext != null && fsrFgConfiguredFrame != fsrFgFrameId ) {
			fsrFgConfigureResult = configureFsrFrameGen(false);
			fsrFgConfiguredFrame = fsrFgFrameId;
		}
		var prepared = fsrFgPreparedFrame == fsrFgFrameId;
		var status = 0;
		if ( fsrFgMode != Off ) {
			if ( fsrFgContext == null && fsrFgContextFlags != -1 )
				status |= FSR_FG_STATUS_CONTEXT_FAILED;
			if ( fsrFgConfigureResult != FsrResult.Ok )
				status |= FSR_FG_STATUS_CONFIGURE_FAILED;
			if ( prepared && fsrFgPrepareResult != FsrResult.Ok )
				status |= FSR_FG_STATUS_PREPARE_FAILED;
			if ( !prepared )
				status |= FSR_FG_STATUS_NOT_PREPARED;
		}
		var s = fsrFgSettings;
		s.status = status;
		s.framesPresented = fsrFgMode != Off && prepared && fsrFgPrepareResult == FsrResult.Ok && fsrFgConfigureResult == FsrResult.Ok ? 2 : 1;
		s.maxFramesToGenerate = 1;
		s.minWidthOrHeight = 0;
		s.dynamicSupported = false;
		s.vsyncSupported = true;
	}
	#end

	public function isUpscalingSupported() : Bool {
		return upscalerProvider != UpscalingProvider.NONE;
	}

	public function isFrameGenSupported() : Bool {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: framegenReady;
			#end
			#if fsr
			case UpscalingProvider.FSR: fsrProxy != null;
			#end
			default: false;
		}
	}

	public function getUpscalerName() : String {
		return switch ( upscalerProvider ) {
			#if fsr
			case UpscalingProvider.FSR: fsrContext != null ? "FSR " + Fsr.getVersion(fsrContext) : "FSR";
			#end
			#if dlss
			case UpscalingProvider.DLSS: "DLSS";
			#end
			default: null;
		}
	}

	public function getFrameGenName() : String {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: "DLSS-G";
			#end
			#if fsr
			case UpscalingProvider.FSR: fsrFgName;
			#end
			default: null;
		}
	}

	#if dlss
	function getDlssMode( mode : UpscalingMode ) : DLSSModeNative {
		return switch (mode) {
			case Off: DLSSModeNative.OFF;
			case NativeAA: DLSSModeNative.DLAA;
			case Quality: DLSSModeNative.MAXQUALITY;
			case Balanced: DLSSModeNative.BALANCED;
			case Performance: DLSSModeNative.MAXPERFORMANCE;
			case UltraPerformance: DLSSModeNative.ULTRAPERFORMANCE;
		}
	}

	function getDlssSettings( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		dlssOptions.mode = getDlssMode(mode);
		dlssOptions.outputWidth = targetWidth;
		dlssOptions.outputHeight = targetHeight;
		Dlss.getOptimalSettings(dlssOptions, dlssOptimalSettings);
		dlssSettings.renderWidth = dlssOptimalSettings.optimalRenderWidth;
		dlssSettings.renderHeight = dlssOptimalSettings.optimalRenderHeight;
		return dlssSettings;
	}

	function applyDlss( resources : Map<h3d.impl.Driver.UpscalingTag, h3d.mat.Texture>, params : UpscalingParams, mode : UpscalingMode ) {
		dlssOptions.mode = getDlssMode(mode);

		var output = resources[ColorOut];
		dlssOptions.outputWidth = output.width;
		dlssOptions.outputHeight = output.height;
		dlssOptions.colorBufferHDR = params.colorBufferHDR;
		dlssOptions.preset = mode == NativeAA ? DLSSPreset.PRESET_L : DLSSPreset.PRESET_K;

		Dlss.setOptions(dlssOptions);

		tagDlssResources(resources);

		setDlssConstants(params);

		dlssLastResult = Dlss.evaluateFeature(driver.frame.dlssFrameToken, driver.frame.commandList, DLSSFeature.DLSS);

		var arr = driver.tmp.descriptors2;
		arr[0] = @:privateAccess driver.frame.srvHeap.heap;
		arr[1] = @:privateAccess driver.frame.samplerHeap.heap;
		driver.frame.commandList.setDescriptorHeaps(arr);
	}
	#end

	public function getUpscalingSettings( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		return switch ( upscalerProvider ) {
			#if fsr
			case UpscalingProvider.FSR: getFsrSettings(mode, targetWidth, targetHeight);
			#end
			#if dlss
			case UpscalingProvider.DLSS: getDlssSettings(mode, targetWidth, targetHeight);
			#end
			default: null;
		}
	}

	public function applyUpscaling( resources : Map<h3d.impl.Driver.UpscalingTag, h3d.mat.Texture>, params : UpscalingParams, mode : UpscalingMode ) {
		upscalingFrame = driver.frameCount;
		upscalingMode = mode;
		upscalingColorIn = resources[ColorIn];
		upscalingColorOut = resources[ColorOut];
		upscalingDepth = resources[Depth];
		upscalingMotionVectors = resources[MotionVectors];
		switch ( upscalerProvider ) {
			#if fsr
			case UpscalingProvider.FSR: applyFsr(resources, params);
			#end
			#if dlss
			case UpscalingProvider.DLSS: applyDlss(resources, params, mode);
			#end
			default:
		}
	}

	public function setFrameGenResources( resources : Map<h3d.impl.Driver.UpscalingTag, h3d.mat.Texture> ) {
		switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: tagDlssResources(resources);
			#end
			#if fsr
			case UpscalingProvider.FSR:
				fsrFgDepth = resources[Depth];
				fsrFgMotionVectors = resources[MotionVectors];
			#end
			default:
		}
	}

	public function setFrameGenParams( params : UpscalingParams ) {
		switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: setDlssConstants(params);
			#end
			#if fsr
			case UpscalingProvider.FSR: applyFsrFrameGen(params);
			#end
			default:
		}
	}

	function tagDlssResources( resources : Map<h3d.impl.Driver.UpscalingTag, h3d.mat.Texture> ) {
		#if dlss
		if ( !slReady || driver.frame.dlssFrameToken == null ) return;

		var resCount = 0;
		for ( t in resources.keys() )
			resCount++;
		if ( resCount == 0 ) return;

		var dlssResources = hl.CArray.alloc(DLSSResource, resCount);
		var idx = 0;
		for ( type in resources.keys() ) {
			var t = resources.get(type);
			var res = dlssResources[idx];
			res.res = t.t.res;
			res.width = t.width;
			res.height = t.height;
			switch ( type ) {
				case Depth: res.type = DLSSBufferType.DEPTH;
				case MotionVectors: res.type = DLSSBufferType.MOTIONVECTORS;
				case ColorIn: res.type = DLSSBufferType.COLORIN;
				case ColorOut: res.type = DLSSBufferType.COLOROUT;
				case HUDLess: res.type = DLSSBufferType.HUDLESSCOLOR;
				case UIColorAndAlpha: res.type = DLSSBufferType.UICOLORANDALPHA;
				case UIAlpha: res.type = DLSSBufferType.UIALPHA;
			}
			res.state = t.t.state;
			res.lifecycle = DLSSResourceLifecycle.VALID_UNTIL_PRESENT;
			t.lastFrame = driver.frameCount;
			idx++;
		}

		Dlss.setTagForFrame(driver.frame.dlssFrameToken, dlssResources, resCount, driver.frame.commandList);
		#end
	}

	public function clearFrameGenResources() {
		#if fsr
		fsrFgDepth = null;
		fsrFgMotionVectors = null;
		#end
		#if dlss
		if ( !slReady || driver.frame.dlssFrameToken == null )
			return;
		var types = [DLSSBufferType.DEPTH, DLSSBufferType.MOTIONVECTORS, DLSSBufferType.COLORIN, DLSSBufferType.COLOROUT, DLSSBufferType.HUDLESSCOLOR, DLSSBufferType.UICOLORANDALPHA, DLSSBufferType.UIALPHA];
		var dlssResources = hl.CArray.alloc(DLSSResource, types.length);
		for ( i => type in types ) {
			var res = dlssResources[i];
			res.res = null;
			res.type = type;
			res.lifecycle = DLSSResourceLifecycle.VALID_UNTIL_PRESENT;
		}
		Dlss.setTagForFrame(driver.frame.dlssFrameToken, dlssResources, types.length, driver.frame.commandList);
		#end
	}

	function setDlssConstants( params : UpscalingParams ) {
		#if dlss
		if ( !slReady || driver.frame.dlssFrameToken == null || dlssConstantsFrame == driver.frameCount )
			return;
		dlssConstantsFrame = driver.frameCount;

		loadDlssMat(matCameraViewToClip, params.cameraViewToClip);
		loadDlssMat(matClipToCameraView, params.clipToCameraView);
		loadDlssMat(matClipToPrevClip, params.clipToPrevClip);
		loadDlssMat(matPrevClipToClip, params.prevClipToClip);

		loadDlssVec(vecCameraPos, params.cameraPos);
		loadDlssVec(vecCameraUp, params.cameraUp);
		loadDlssVec(vecCameraRight, params.cameraRight);
		loadDlssVec(vecCameraFwd, params.cameraFwd);

		dlssConstants.cameraViewToClip = matCameraViewToClip;
		dlssConstants.clipToCameraView = matClipToCameraView;
		dlssConstants.clipToLensClip = matClipToLensClip;
		dlssConstants.clipToPrevClip = matClipToPrevClip;
		dlssConstants.prevClipToClip = matPrevClipToClip;
		dlssConstants.jitterOffsetX = params.jitterOffsetX;
		dlssConstants.jitterOffsetY = params.jitterOffsetY;
		dlssConstants.mvecScaleX = params.mvecScaleX;
		dlssConstants.mvecScaleY = params.mvecScaleY;
		dlssConstants.cameraPinholeOffsetX = 0.0;
		dlssConstants.cameraPinholeOffsetY = 0.0;
		dlssConstants.cameraPos = vecCameraPos;
		dlssConstants.cameraUp = vecCameraUp;
		dlssConstants.cameraRight = vecCameraRight;
		dlssConstants.cameraFwd = vecCameraFwd;
		dlssConstants.cameraNear = params.cameraNear;
		dlssConstants.cameraFar = params.cameraFar;
		dlssConstants.cameraFOV = params.cameraFOV;
		dlssConstants.cameraAspectRatio = params.cameraAspectRatio;
		dlssConstants.motionVectorsInvalidValue = params.motionVectorsInvalidValue;
		dlssConstants.depthInverted = params.depthInverted;
		dlssConstants.cameraMotionIncluded = params.cameraMotionIncluded;
		dlssConstants.motionVectors3D = false;
		dlssConstants.reset = params.reset;
		dlssConstants.orthographicProjection = params.orthographicProjection;
		dlssConstants.motionVectorsDilated = params.motionVectorsDilated;
		dlssConstants.motionVectorsJittered = params.motionVectorsJittered;
		dlssConstants.minRelativeLinearDepthObjectSeparation = 40.0;

		Dlss.setConstants(driver.frame.dlssFrameToken, dlssConstants);
		#end
	}

	#if dlss
	inline function pclMarker( marker : PCLMarker ) {
		if ( slReady && pclReady && driver.frame.dlssFrameToken != null )
			Dlss.pclSetMarker(driver.frame.dlssFrameToken, marker);
	}
	#end

	public function latencyMarkerSimulationStart() {
		#if dlss
		if ( slReady && pclReady && driver.frame.dlssFrameToken != null ) {
			pclMarker(PCLMarker.SIMULATION_START);
			Dlss.pclPollPing(driver.frame.dlssFrameToken);
		}
		#end
	}

	public function latencyMarkerSimulationEnd() {
		#if dlss
		pclMarker(PCLMarker.SIMULATION_END);
		if ( pclFlashRequested ) {
			pclMarker(PCLMarker.TRIGGER_FLASH);
			pclFlashRequested = false;
		}
		#end
	}

	public function latencyMarkerTriggerFlash() {
		#if dlss
		pclFlashRequested = true;
		#end
	}

	public function lowLatencySleep() {
		#if dlss
		if ( slReady && reflexReady ) {
			if ( driver.frame.dlssFrameToken != null )
				Dlss.reflexSleep(driver.frame.dlssFrameToken);
			return;
		}
		#end
		#if fsr
		if ( antiLag2Ready )
			antiLag2Result = Fsr.antiLag2Update(antiLag2Mode != Off, antiLag2MaxFps);
		#end
	}

	public function setLowLatencyOptions( mode : LowLatencyMode, frameLimitUs : Int = 0 ) {
		#if fsr
		if ( antiLag2Ready ) {
			if ( mode == Off && frameGenProvider == UpscalingProvider.FSR && fsrFgMode != Off )
				mode = LowLatencyMode.On;
			antiLag2Mode = mode;
			antiLag2MaxFps = frameLimitUs > 0 ? Math.round(1000000 / frameLimitUs) : 0;
			return true;
		}
		#end
		#if dlss
		if ( !slReady || !reflexReady )
			return false;

		if ( mode == Off && frameGenProvider == UpscalingProvider.DLSS && dlssgMode != Off )
			mode = LowLatencyMode.On;

		var native = switch ( mode ) {
			case Off: ReflexModeNative.OFF;
			case On: ReflexModeNative.LOW_LATENCY;
			case OnWithBoost: ReflexModeNative.LOW_LATENCY_WITH_BOOST;
		}

		if ( Dlss.reflexSetOptions(native, frameLimitUs, false, PCLHotKey.USE_PING_MESSAGE, 0) != 0 )
			return false;

		reflexMode = mode;
		return true;
		#else
		return false;
		#end
	}

	public function setFrameGenMode( mode : h3d.impl.Driver.FrameGenMode, numFramesToGenerate : Int = 1, releaseResources = false ) : Bool {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: setDlssgMode(mode, numFramesToGenerate, releaseResources);
			#end
			#if fsr
			case UpscalingProvider.FSR: setFsrFrameGenMode(mode, releaseResources);
			#end
			default: false;
		}
	}

	#if dlss
	function setDlssgMode( mode : h3d.impl.Driver.FrameGenMode, numFramesToGenerate : Int, releaseResources : Bool ) : Bool {
		if ( !slReady || !framegenReady )
			return false;

		if ( mode != Off && reflexMode == Off && !setLowLatencyOptions(LowLatencyMode.On) )
			return false;

		dlssgOptions.mode = switch ( mode ) {
			case Off: DLSSGModeNative.OFF;
			case On: DLSSGModeNative.ON;
			case Auto: DLSSGModeNative.AUTO;
			case Dynamic: DLSSGModeNative.DYNAMIC;
		}
		dlssgOptions.numFramesToGenerate = numFramesToGenerate;
		if ( mode != Off )
			dlssgFrames = numFramesToGenerate;

		dlssgOptions.flags = DLSSGFlag.RETAIN_RESOURCES_WHEN_OFF;
		if ( Dlss.dlssgSetOptions(dlssgOptions) != 0 )
			return false;

		dlssgMode = mode;
		refreshDLSSGState();
		if ( mode == Off && releaseResources )
			Dlss.freeResources(DLSSFeature.FRAMEGEN);

		return true;
	}
	#end

	public function getFrameGenMode() : h3d.impl.Driver.FrameGenMode {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: dlssgMode;
			#end
			#if fsr
			case UpscalingProvider.FSR: fsrFgMode;
			#end
			default: Off;
		}
	}

	#if dlss
	function refreshDLSSGState() : Bool {
		if ( !slReady || !framegenReady || Dlss.dlssgGetState(dlssgStateInfo) != 0 )
			return false;

		dlssgSettings.status = dlssgStateInfo.status;
		dlssgSettings.minWidthOrHeight = dlssgStateInfo.minWidthOrHeight;
		dlssgSettings.framesPresented = dlssgStateInfo.numFramesActuallyPresented;
		dlssgSettings.maxFramesToGenerate = dlssgStateInfo.numFramesToGenerateMax;
		dlssgSettings.dynamicSupported = dlssgStateInfo.dynamicMFGSupported != 0;
		dlssgSettings.vsyncSupported = dlssgStateInfo.vsyncSupportAvailable != 0;
		if ( dlssgSettings.status != 0 )
			dlssgLastStatus = dlssgSettings.status;
		return true;
	}
	#end

	public function getFrameGenSettings() : h3d.impl.Driver.FrameGenSettings {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: slReady && framegenReady ? dlssgSettings : null;
			#end
			#if fsr
			case UpscalingProvider.FSR: fsrProxy != null ? fsrFgSettings : null;
			#end
			default: null;
		}
	}

	static var frameGenTags = new Map<h3d.impl.Driver.UpscalingTag, h3d.mat.Texture>();

	function isFrameGenActive() : Bool {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: framegenReady && dlssgMode != Off;
			#end
			#if fsr
			case UpscalingProvider.FSR: fsrProxy != null && fsrFgMode != Off;
			#end
			default: false;
		}
	}

	function isFrameGenUICompositedBySwapChain() : Bool {
		#if fsr
		return frameGenProvider == UpscalingProvider.FSR && fsrProxy != null;
		#else
		return false;
		#end
	}

	function getHudlessTexture() : h3d.mat.Texture {
		if ( !isFrameGenActive() )
			return null;
		switch ( frameGenUIMode ) {
			case HudLess:
			case UITexture if ( !isFrameGenUICompositedBySwapChain() ):
			default: return null;
		}
		var index = DX12Driver.FRAME_GEN_ASYNC ? presentCount & 1 : 0;
		var t = hudlessTextures[index];
		if ( t == null || t.isDisposed() || t.width != driver.currentWidth || t.height != driver.currentHeight ) {
			if ( t != null )
				t.dispose();
			t = new h3d.mat.Texture(driver.currentWidth, driver.currentHeight, [Target], RGBA);
			t.setName('frameGenHudless$index');
			t.preventAutoDispose();
			hudlessTextures[index] = t;
		}
		if ( t.t == null )
			t.alloc();
		return t;
	}

	function disposeFrameGenTextures() {
		#if fsr
		if ( fsrUiRegistered && fsrProxy != null )
			Fsr.registerUiResource(null, COMMON, 0);
		fsrUiRegistered = false;
		#end
		for ( t in hudlessTextures )
			if ( t != null )
				t.dispose();
		hudlessTextures = [];
		hudlessCaptured = -1;
		if ( frameGenUITarget != null ) {
			frameGenUITarget.dispose();
			frameGenUITarget = null;
		}
		frameGenUIDrawn = -1;
	}

	function copyBackBuffer( to : h3d.mat.Texture ) {
		to.lastFrame = driver.frameCount;
		driver.transition(driver.frame.backBuffer, COPY_SOURCE);
		driver.transition(to.t, COPY_DEST);
		driver.flushTransitions();
		var dst = driver.tmp.dstTextureLocation;
		var src = driver.tmp.srcTextureLocation;
		dst.res = to.t.res;
		src.res = driver.frame.backBuffer.res;
		dst.type = SUBRESOURCE_INDEX;
		src.type = SUBRESOURCE_INDEX;
		dst.subResourceIndex = 0;
		src.subResourceIndex = 0;
		driver.frame.commandList.copyTextureRegion(dst, 0, 0, 0, src, null);
		to.flags.set(WasCleared);
		driver.transition(driver.frame.backBuffer, RENDER_TARGET);
	}

	public function setFrameGenUIMode( mode : h3d.impl.Driver.FrameGenUIMode ) {
		if ( mode == frameGenUIMode )
			return;
		frameGenUIMode = mode;
		disposeFrameGenTextures();
	}

	public function getFrameGenUIMode() : h3d.impl.Driver.FrameGenUIMode {
		return frameGenUIMode;
	}

	public function markFrameGenHudless( ?source : h3d.mat.Texture ) {
		var hudless = getHudlessTexture();
		if ( hudless == null )
			return;
		if ( source == null )
			copyBackBuffer(hudless);
		else if ( !driver.copyTexture(source, hudless) )
			h3d.pass.Copy.run(source, hudless);
		hudlessCaptured = presentCount;
	}

	public function getFrameGenUITarget() : h3d.mat.Texture {
		if ( frameGenUIMode != UITexture )
			return null;
		var t = frameGenUITarget;
		if ( t == null || t.isDisposed() || t.width != driver.currentWidth || t.height != driver.currentHeight ) {
			if ( t != null )
				t.dispose();
			t = new h3d.mat.Texture(driver.currentWidth, driver.currentHeight, [Target], RGBA);
			t.setName("frameGenUI");
			t.preventAutoDispose();
			frameGenUITarget = t;
		}
		return t;
	}

	public function compositeFrameGenUI() {
		var ui = frameGenUITarget;
		if ( ui == null || ui.t == null || frameGenUIMode != UITexture )
			return;
		frameGenUIDrawn = presentCount;
		if ( isFrameGenUICompositedBySwapChain() )
			return;
		markFrameGenHudless();
		h3d.pass.Copy.run(ui, null, AlphaAdd);
	}

	function prepareFrameGenInputs() {
		if ( frameGenUIMode == BackBuffer )
			return;
		var hudless = getHudlessTexture();
		if ( hudless != null ) {
			if ( hudlessCaptured != presentCount )
				copyBackBuffer(hudless);
			driver.transition(hudless.t, NON_PIXEL_SHADER_RESOURCE);
		}
		var ui = frameGenUIMode == UITexture && frameGenUIDrawn == presentCount ? frameGenUITarget : null;
		if ( ui != null )
			driver.transition(ui.t, ALL_SHADER_RESOURCE);
		driver.flushTransitions();

		#if fsr
		if ( isFrameGenUICompositedBySwapChain() ) {
			if ( ui != null ) {
				Fsr.registerUiResource(ui.t.res, ui.t.state, FsrUiCompositionFlag.USE_PREMUL_ALPHA | FsrUiCompositionFlag.ENABLE_INTERNAL_UI_DOUBLE_BUFFERING);
				fsrUiRegistered = true;
			} else if ( fsrUiRegistered ) {
				Fsr.registerUiResource(null, COMMON, 0);
				fsrUiRegistered = false;
			}
		}
		#end

		#if dlss
		if ( frameGenProvider == UpscalingProvider.DLSS && isFrameGenActive() && (hudless != null || ui != null) ) {
			frameGenTags.clear();
			if ( hudless != null )
				frameGenTags.set(HUDLess, hudless);
			if ( ui != null )
				frameGenTags.set(UIColorAndAlpha, ui);
			tagDlssResources(frameGenTags);
		}
		#end
	}

	public function lowLatencyAvailable() {
		#if fsr
		if ( antiLag2Ready )
			return true;
		#end
		#if dlss
		return slReady && reflexReady && reflexState != null && reflexState.lowLatencyAvailable != 0;
		#else
		return false;
		#end
	}

	public function lowLatencyFlashIndicatorDriverControlled() {
		#if dlss
		return slReady && reflexReady && reflexState != null && reflexState.flashIndicatorDriverControlled != 0;
		#else
		return false;
		#end
	}

	public function debugUpscaling() : String {
		var buf = new StringBuf();
		buf.add("=== Upscaling Debug ===\n");
		if ( !DX12Driver.ENABLE_UPSCALING ) {
			buf.add("Upscaling is disabled (ENABLE_UPSCALING = false)\n");
			return buf.toString();
		}
		buf.add('providers: upscaler=${upscalerProvider.toString()} frameGen=${frameGenProvider.toString()}\n');
		var name = getUpscalerName();
		if ( name == null ) {
			buf.add('No upscaler available (UPSCALER = ${DX12Driver.UPSCALER})\n');
			#if dlss
			if ( DX12Driver.UPSCALER == UpscalerSelection.FSR )
				buf.add("DLSS: not selected\n");
			else if ( slInitResult != 0 )
				buf.add('DLSS: Streamline init failed ($slInitResult)\n');
			else if ( dlssSupportResult < 0 )
				buf.add("DLSS: Streamline device setup failed\n");
			else
				buf.add('DLSS: not supported on this adapter ($dlssSupportResult)\n');
			#else
			buf.add("DLSS: not compiled (-D dlss)\n");
			#end
			#if fsr
			if ( DX12Driver.UPSCALER == UpscalerSelection.DLSS )
				buf.add("FSR: not selected\n");
			else if ( !fsrLoaded )
				buf.add('FSR: init failed ($fsrInitResult)\n');
			else
				buf.add("FSR: no upscaler provider for this device\n");
			#else
			buf.add("FSR: not compiled (-D fsr)\n");
			#end
			return buf.toString();
		}
		buf.add('upscaler=$name mode=$upscalingMode\n');
		var input = upscalingColorIn;
		var output = upscalingColorOut;
		if ( upscalingFrame < 0 || input == null || output == null ) {
			buf.add("Upscaling was never applied\n");
			return buf.toString();
		}
		buf.add('render=${input.width}x${input.height} output=${output.width}x${output.height}\n');
		var issues = [];
		var age = driver.frameCount - upscalingFrame;
		if ( age > 1 )
			issues.push('not applied for $age frames');
		function checkInput( t : h3d.mat.Texture, tname : String ) {
			if ( t == null )
				issues.push('missing $tname');
			else if ( t.width != input.width || t.height != input.height )
				issues.push('$tname is ${t.width}x${t.height}');
		}
		checkInput(upscalingDepth, "depth");
		checkInput(upscalingMotionVectors, "motion vectors");
		if ( upscalingMode != Off && upscalingMode != NativeAA ) {
			var optimal = getUpscalingSettings(upscalingMode, output.width, output.height);
			if ( optimal != null && (optimal.renderWidth != input.width || optimal.renderHeight != input.height) )
				issues.push('render size differs from optimal ${optimal.renderWidth}x${optimal.renderHeight}');
		} else if ( input.width != output.width || input.height != output.height )
			issues.push("render size differs from output size");
		#if fsr
		if ( upscalerProvider == UpscalingProvider.FSR ) {
			if ( fsrContext == null )
				issues.push("FSR context creation failed");
			else if ( fsrLastResult != FsrResult.Ok )
				issues.push('FSR dispatch failed ($fsrLastResult)');
			if ( DX12Driver.UPSCALER_DEBUG )
				buf.add("FSR debug checker on, warnings go to the log\n");
		}
		#end
		#if dlss
		var dlssResult : SlResult = cast dlssLastResult;
		if ( dlssReady && dlssResult == SlResult.WarnOutOfVRAM ) {
			var mem = driver.getMemoryUsage();
			issues.push('DLSS out of VRAM warning (${Std.int(mem.allocated / 1048576)} / ${Std.int(mem.total / 1048576)} MB)');
		} else if ( dlssReady && dlssResult != SlResult.Ok )
			issues.push('DLSS evaluate failed ($dlssLastResult)');
		#end
		if ( issues.length == 0 )
			buf.add("status=Ok\n");
		for ( issue in issues )
			buf.add('status: $issue\n');
		return buf.toString();
	}

	public function debugFrameGen() : String {
		return switch ( frameGenProvider ) {
			#if dlss
			case UpscalingProvider.DLSS: debugDlssg();
			#end
			#if fsr
			case UpscalingProvider.FSR: debugFsrFrameGen();
			#end
			default: debugNoFrameGen();
		}
	}

	function debugNoFrameGen() : String {
		var buf = new StringBuf();
		buf.add("=== Frame Generation Debug ===\n");
		if ( !DX12Driver.ENABLE_UPSCALING || !DX12Driver.FRAME_GEN ) {
			buf.add('Frame generation is disabled (ENABLE_UPSCALING = ${DX12Driver.ENABLE_UPSCALING}, FRAME_GEN = ${DX12Driver.FRAME_GEN})\n');
			return buf.toString();
		}
		buf.add('No frame generation provider (FRAME_GEN_PROVIDER = ${DX12Driver.FRAME_GEN_PROVIDER})\n');
		#if dlss
		if ( DX12Driver.FRAME_GEN_PROVIDER == UpscalerSelection.FSR )
			buf.add("DLSS-G: not selected\n");
		else if ( slInitResult != 0 )
			buf.add('DLSS-G: Streamline init failed ($slInitResult)\n');
		else
			buf.add("DLSS-G: not supported on this adapter\n");
		#else
		buf.add("DLSS-G: not compiled (-D dlss)\n");
		#end
		#if fsr
		if ( DX12Driver.FRAME_GEN_PROVIDER == UpscalerSelection.DLSS )
			buf.add("FSR FG: not selected\n");
		else if ( !fsrLoaded )
			buf.add('FSR FG: init failed ($fsrInitResult)\n');
		else if ( fsrSwapChainResult != FsrResult.Ok && fsrSwapChainResult != FsrResult.NotCreated )
			buf.add('FSR FG: swapchain creation failed ($fsrSwapChainResult)\n');
		else
			buf.add("FSR FG: no frame generation provider for this device\n");
		#else
		buf.add("FSR FG: not compiled (-D fsr)\n");
		#end
		return buf.toString();
	}

	#if fsr
	function debugFsrFrameGen() : String {
		var buf = new StringBuf();
		buf.add('=== $fsrFgName Debug ===\n');
		if ( fsrProxy == null ) {
			buf.add('Frame generation swapchain unavailable ($fsrSwapChainResult)\n');
			return buf.toString();
		}
		var state = fsrFgContext == null ? (fsrFgPendingRelease ? "releasing" : "no context") : "context";
		buf.add('mode=$fsrFgMode state=$state async=${DX12Driver.FRAME_GEN_ASYNC} debugFlags=${DX12Driver.FRAME_GEN_DEBUG_FLAGS} upscaler=${upscalerProvider.toString()}\n');
		buf.add('display=${driver.currentWidth}x${driver.currentHeight}');
		if ( fsrFgContext != null )
			buf.add(' context=${fsrFgContextWidth}x${fsrFgContextHeight} flags=$fsrFgContextFlags');
		buf.add('\n');
		buf.add('frameID=$fsrFgFrameId lastConfigured=$fsrFgConfiguredFrame lastPrepared=$fsrFgPreparedFrame\n');
		buf.add('framesPresentedPerFrame=${fsrFgSettings.framesPresented}\n');
		var total = 0.;
		var aliasable = 0.;
		if ( fsrFgContext != null && Fsr.queryFrameGenMemory(fsrFgContext, total, aliasable) == FsrResult.Ok )
			buf.add('memory: frameGen=${Std.int(total / 1048576)}MB (aliasable ${Std.int(aliasable / 1048576)}MB)');
		if ( Fsr.querySwapChainMemory(total, aliasable) == FsrResult.Ok )
			buf.add(' swapchain=${Std.int(total / 1048576)}MB');
		buf.add('\n');
		var status = fsrFgSettings.status;
		if ( status == 0 ) {
			buf.add("status=Ok\n");
		} else {
			if ( status & FSR_FG_STATUS_CONTEXT_FAILED != 0 ) buf.add('status: context creation failed ($fsrFgContextResult)\n');
			if ( status & FSR_FG_STATUS_CONFIGURE_FAILED != 0 ) buf.add('status: configure failed ($fsrFgConfigureResult)\n');
			if ( status & FSR_FG_STATUS_PREPARE_FAILED != 0 ) buf.add('status: prepare failed ($fsrFgPrepareResult)\n');
			if ( status & FSR_FG_STATUS_NOT_PREPARED != 0 ) buf.add("status: setFrameGenParams not called this frame\n");
		}
		return buf.toString();
	}
	#end

	#if dlss
	function debugDlssg() : String {
		var buf = new StringBuf();
		buf.add("=== DLSS-G Debug ===\n");
		if ( !slReady ) {
			buf.add("Streamline is not ready\n");
			return buf.toString();
		}
		if ( !framegenReady ) {
			buf.add("Frame generation is not supported on this adapter\n");
			return buf.toString();
		}
		buf.add('mode=$dlssgMode framesToGenerate=$dlssgFrames reflexMode=$reflexMode\n');
		var state = getFrameGenSettings();
		buf.add('framesPresentedPerFrame=${state.framesPresented}\n');
		buf.add('minWidthOrHeight=${state.minWidthOrHeight} maxFramesToGenerate=${state.maxFramesToGenerate} ');
		buf.add('dynamicSupported=${state.dynamicSupported} vsyncSupported=${state.vsyncSupported}\n');
		var status = state.status == 0 ? dlssgLastStatus : state.status;
		if ( status == 0 ) {
			buf.add("status=Ok\n");
		} else {
			if ( status & 1 != 0 ) buf.add("status: output resolution too low\n");
			if ( status & 2 != 0 ) buf.add("status: Reflex not active at runtime\n");
			if ( status & 4 != 0 ) buf.add("status: HDR format not supported\n");
			if ( status & 8 != 0 ) buf.add("status: common constants invalid\n");
			if ( status & 16 != 0 ) buf.add("status: GetCurrentBackBufferIndex not called\n");
		}
		if ( driver.currentWidth < state.minWidthOrHeight || driver.currentHeight < state.minWidthOrHeight )
			buf.add('backbuffer ${driver.currentWidth}x${driver.currentHeight} is below minWidthOrHeight\n');
		return buf.toString();
	}
	#end

	public function debugLowLatency() : String {
		#if fsr
		if ( antiLag2Ready || !#if dlss (slReady && reflexReady) #else false #end ) {
			var buf = new StringBuf();
			buf.add("=== Anti-Lag 2 Debug ===\n");
			if ( !antiLag2Ready ) {
				buf.add('Anti-Lag 2 is not available ($antiLag2Result)\n');
				return buf.toString();
			}
			buf.add('mode=$antiLag2Mode maxFps=$antiLag2MaxFps lastResult=$antiLag2Result');
			if ( fsrProxy != null )
				buf.add(' frameGen=${fsrFgMode} (frame type signaled through the swapchain)');
			buf.add('\n');
			return buf.toString();
		}
		#end
		#if dlss
		var buf = new StringBuf();
		buf.add("=== Reflex Debug ===\n");
		if ( !slReady || !reflexReady ) {
			buf.add("Streamline or Reflex are not ready\n");
			return buf.toString();
		}
		if ( reflexState == null )
			reflexState = new ReflexStateInfo();
		Dlss.reflexGetState(reflexState);
		buf.add('lowLatencyAvailable=${reflexState.lowLatencyAvailable} ');
		buf.add('latencyReportAvailable=${reflexState.latencyReportAvailable} ');
		buf.add('flashIndicatorDriverControlled=${reflexState.flashIndicatorDriverControlled} ');
		buf.add('statsWindowMessage=${reflexState.statsWindowMessage}\n');
		if ( reflexState.lowLatencyAvailable == 0 ) buf.add("Low latency is not available.\n");
		if ( reflexState.latencyReportAvailable == 0 ) buf.add("Latency report are not available.\n");
		var reports = [];
		for ( i in 0...Dlss.REFLEX_FRAME_REPORT_COUNT ) {
			var r = new ReflexFrameReport();
			var res = Dlss.reflexGetFrameReport(i, r);
			if ( res == 0 && r.frameID > 0 )
				reports.push(r);
		}
		if ( reports.length == 0 ) {
			buf.add("Empty reports.\n");
			return buf.toString();
		}
		reports.sort((a, b) -> a.frameID < b.frameID ? -1 : (a.frameID > b.frameID ? 1 : 0));
		var totalPcLatency = 0.;
		var totalGpuFrameUs = 0.;
		buf.add('\nframeID   simMs   renderMs   driverMs   osQueueMs   gpuMs   pcLatencyMs   gpuFrameTimeUs\n');
		for ( r in reports ) {
			inline function ms(a:Float, b:Float) return (b - a) / 1000.0;
			var simDur = ms(r.simStartTime, r.simEndTime);
			var renderDur = ms(r.renderSubmitStartTime, r.renderSubmitEndTime);
			var drvDur = ms(r.driverStartTime, r.driverEndTime);
			var osDur = ms(r.osRenderQueueStartTime, r.osRenderQueueEndTime);
			var gpuDur = ms(r.gpuRenderStartTime, r.gpuRenderEndTime);
			var pcLatency = ms(r.simStartTime, r.presentEndTime);
			buf.add('${r.frameID}   ${simDur}   ${renderDur}   ${drvDur}   ${osDur}   ${gpuDur}   ${pcLatency}   ${r.gpuFrameTimeUs}\n');
			totalPcLatency += pcLatency;
			totalGpuFrameUs += r.gpuFrameTimeUs;
			if (r.driverStartTime <= 0 || r.gpuRenderStartTime <= 0 || r.osRenderQueueStartTime <= 0)
				buf.add("One or more driver/OS/GPU timestamps are 0.\n");
		}
		var n = reports.length;
		buf.add('\nSampled ${n} frames. Avg PC latency: ${totalPcLatency / n} ms. Avg GPU frame time: ${totalGpuFrameUs / n} us.\n');
		return buf.toString();
		#end
		return "DLSS Undefined";
	}
}

#end
