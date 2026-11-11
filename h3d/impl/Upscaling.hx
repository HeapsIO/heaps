package h3d.impl;

#if (hldx && dx12 && dlss && !macro)
import heaps.dlss.Dlss;
#end
#if (hldx && dx12 && fsr && !macro)
import heaps.fsr.Fsr;
#end

enum UpscalingFeature {
	Upscaler;
	FrameGen;
	LowLatency;
}

enum abstract UpscalingProvider(String) from String to String {
	var AUTO = "auto";
	var DLSS = "dlss";
	var FSR = "fsr";
}

enum UpscalingMode {
	Off;
	NativeAA;
	Quality;
	Balanced;
	Performance;
	UltraPerformance;
}

enum FrameGenMode {
	Off;
	On;
	Auto;
	Dynamic;
}

enum FrameGenUIMode {
	BackBuffer;
	HudLess;
	UITexture;
}

enum LowLatencyMode {
	Off;
	On;
	OnWithBoost;
}

enum LatencyMarker {
	SimulationStart;
	SimulationEnd;
	TriggerFlash;
}

class UpscalingInputs {
	public var color : h3d.mat.Texture;
	public var depth : h3d.mat.Texture;
	public var motionVectors : h3d.mat.Texture;
	public var output : h3d.mat.Texture;
	public function new() {
	}
}

@:struct class UpscalingParams {
	public var cameraViewToClip : h3d.Matrix;
	public var clipToCameraView : h3d.Matrix;
	public var clipToPrevClip : h3d.Matrix;
	public var prevClipToClip : h3d.Matrix;
	public var jitterOffsetX : Float;
	public var jitterOffsetY : Float;
	public var mvecScaleX : Float;
	public var mvecScaleY : Float;
	public var cameraPos : h3d.Vector;
	public var cameraUp : h3d.Vector;
	public var cameraRight : h3d.Vector;
	public var cameraFwd : h3d.Vector;
	public var cameraNear : Float;
	public var cameraFar : Float;
	public var cameraFOV : Float;
	public var cameraAspectRatio : Float;
	public var motionVectorsInvalidValue : Float;
	public var depthInverted : Bool;
	public var cameraMotionIncluded : Bool;
	public var reset : Bool;
	public var orthographicProjection : Bool;
	public var motionVectorsDilated : Bool;
	public var motionVectorsJittered : Bool;
	public var colorBufferHDR : Bool;
	public var autoExposure : Bool;
	public function new() {
	}
}

class UpscalingSettings {
	public var renderWidth : Int;
	public var renderHeight : Int;
	public function new() {
	}
}

class FrameGenSettings {
	public var status : Int;
	public var minWidthOrHeight : Int;
	public var framesPresented : Int;
	public var maxFramesToGenerate : Int;
	public var dynamicSupported : Bool;
	public var vsyncSupported : Bool;
	public function new() {
	}
}

@:allow(h3d.impl.Upscaling)
class UpscalingBackend {

	public var provider(default, null) : UpscalingProvider;
	public var wanted(default, null) : haxe.EnumFlags<UpscalingFeature>;
	public var supported(default, null) : haxe.EnumFlags<UpscalingFeature>;

	public function new( provider : UpscalingProvider ) {
		this.provider = provider;
	}

	public function beforeCreateDevice() {
	}

	public function afterCreateDevice() {
	}

	public function release( unused : haxe.EnumFlags<UpscalingFeature> ) {
	}

	public function afterCreateQueue() {
	}

	public function afterCreateSwapChain() {
	}

	public function beginFrame() {
	}

	public function begin() {
	}

	public function beforePresent() {
	}

	public function beforeQueuePresent() {
	}

	public function afterQueuePresent() {
	}

	public function beforeResize() {
	}

	public function releaseResizeResources() {
	}

	public function afterResize() {
	}

	public function dispose() {
	}

	public function isAvailable( f : UpscalingFeature ) : Bool {
		return supported.has(f);
	}

	public function getName( f : UpscalingFeature ) : String {
		return (provider : String).toUpperCase();
	}

	public function getStatus( f : UpscalingFeature ) : String {
		return wanted.has(f) ? "not supported" : "not selected";
	}

	public function debug( f : UpscalingFeature ) : String {
		return "";
	}

	public function getRenderSize( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		return null;
	}

	public function upscale( inputs : UpscalingInputs, params : UpscalingParams, mode : UpscalingMode ) {
	}

	public function releaseUpscaler() {
	}

	public function setFrameGenMode( mode : FrameGenMode, numFramesToGenerate : Int, releaseResources : Bool ) : Bool {
		return false;
	}

	public function getFrameGenMode() : FrameGenMode {
		return Off;
	}

	public function getFrameGenSettings() : FrameGenSettings {
		return null;
	}

	public function prepareFrameGen( inputs : UpscalingInputs, params : UpscalingParams ) {
	}

	public function setFrameGenUI( hudless : h3d.mat.Texture, ui : h3d.mat.Texture ) {
	}

	public function composesFrameGenUI() : Bool {
		return false;
	}

	public function getHudlessBufferCount() : Int {
		return 1;
	}

	public function setLowLatencyMode( mode : LowLatencyMode, frameLimitUs : Int ) : Bool {
		return false;
	}

	public function lowLatencySleep() {
	}

	public function latencyMarker( m : LatencyMarker ) {
	}

	public function isFlashIndicatorDriverControlled() : Bool {
		return false;
	}
}

class Upscaling {

	public static var ENABLED = true;
	public static var UPSCALER : UpscalingProvider = AUTO;
	public static var FRAME_GEN = true;
	public static var FRAME_GEN_PROVIDER : UpscalingProvider = AUTO;
	public static var LOW_LATENCY = true;
	public static var DEBUG = false;
	public static var PRIORITY : Array<UpscalingProvider> = [DLSS, FSR];

	var driver : Driver;
	var backends : Array<UpscalingBackend>;
	var upscaler : UpscalingBackend;
	var frameGen : UpscalingBackend;
	var latency : UpscalingBackend;
	var pendingRelease : Array<UpscalingBackend> = [];
	var resetHistory = false;
	var lowLatencyMode : LowLatencyMode = Off;
	var frameLimitUs = 0;
	var presentCount = 0;

	var lastInputs = new UpscalingInputs();
	var lastFrame = -1;
	var lastMode : UpscalingMode = Off;

	var frameGenUIMode : FrameGenUIMode = BackBuffer;
	var hudlessTextures : Array<h3d.mat.Texture> = [];
	var hudlessCaptured = -1;
	var frameGenUITarget : h3d.mat.Texture;
	var frameGenUIDrawn = -1;

	public function new( driver : Driver, backends : Array<UpscalingBackend> ) {
		this.driver = driver;
		this.backends = backends;
	}

	public function isSupported( f : UpscalingFeature ) : Bool {
		var b = getBackend(f);
		return b != null && b.isAvailable(f);
	}

	public function getName( f : UpscalingFeature ) : String {
		var b = getBackend(f);
		return b == null ? null : b.getName(f);
	}

	public function getUpscalers() : Array<UpscalingProvider> {
		return [for( b in backends ) if( b.supported.has(Upscaler) ) b.provider];
	}

	public function getUpscaler() : UpscalingProvider {
		return upscaler == null ? null : upscaler.provider;
	}

	public function setUpscaler( provider : UpscalingProvider ) : Bool {
		for( b in backends ) {
			if( b.provider != provider || !b.supported.has(Upscaler) )
				continue;
			if( b != upscaler ) {
				pendingRelease.remove(b);
				if( upscaler != null && !pendingRelease.contains(upscaler) )
					pendingRelease.push(upscaler);
				upscaler = b;
				resetHistory = true;
			}
			return true;
		}
		return false;
	}

	public function getRenderSize( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		return upscaler == null ? null : upscaler.getRenderSize(mode, targetWidth, targetHeight);
	}

	public function upscale( inputs : UpscalingInputs, params : UpscalingParams, mode : UpscalingMode ) {
		if( upscaler == null )
			return;
		if( resetHistory ) {
			params.reset = true;
			resetHistory = false;
		}
		lastFrame = hxd.Timer.frameCount;
		lastMode = mode;
		lastInputs.color = inputs.color;
		lastInputs.depth = inputs.depth;
		lastInputs.motionVectors = inputs.motionVectors;
		lastInputs.output = inputs.output;
		upscaler.upscale(inputs, params, mode);
	}

	public function setFrameGenMode( mode : FrameGenMode, numFramesToGenerate = 1, releaseResources = false ) : Bool {
		if( frameGen == null )
			return false;
		if( mode != Off && latency != null && lowLatencyMode == Off )
			latency.setLowLatencyMode(On, frameLimitUs);
		return frameGen.setFrameGenMode(mode, numFramesToGenerate, releaseResources);
	}

	public function getFrameGenMode() : FrameGenMode {
		return frameGen == null ? Off : frameGen.getFrameGenMode();
	}

	public function getFrameGenSettings() : FrameGenSettings {
		return frameGen == null ? null : frameGen.getFrameGenSettings();
	}

	public function prepareFrameGen( inputs : UpscalingInputs, params : UpscalingParams ) {
		if( frameGen != null )
			frameGen.prepareFrameGen(inputs, params);
	}

	public function setFrameGenUIMode( mode : FrameGenUIMode ) {
		if( mode == frameGenUIMode )
			return;
		frameGenUIMode = mode;
		disposeFrameGenTextures();
	}

	public function getFrameGenUIMode() : FrameGenUIMode {
		return frameGenUIMode;
	}

	public function markFrameGenHudless( ?source : h3d.mat.Texture ) {
		var hudless = getHudlessTexture();
		if( hudless == null )
			return;
		if( source == null )
			driver.copyBackBuffer(hudless);
		else if( !driver.copyTexture(source, hudless) )
			h3d.pass.Copy.run(source, hudless);
		hudlessCaptured = presentCount;
	}

	public function getFrameGenUITarget() : h3d.mat.Texture {
		if( frameGenUIMode != UITexture )
			return null;
		var engine = h3d.Engine.getCurrent();
		var t = frameGenUITarget;
		if( t == null || t.isDisposed() || t.width != engine.width || t.height != engine.height ) {
			if( t != null )
				t.dispose();
			t = new h3d.mat.Texture(engine.width, engine.height, [Target], RGBA);
			t.setName("frameGenUI");
			t.preventAutoDispose();
			frameGenUITarget = t;
		}
		return t;
	}

	public function compositeFrameGenUI() {
		var ui = frameGenUITarget;
		if( ui == null || ui.t == null || frameGenUIMode != UITexture )
			return;
		frameGenUIDrawn = presentCount;
		if( frameGen != null && frameGen.composesFrameGenUI() )
			return;
		markFrameGenHudless();
		h3d.pass.Copy.run(ui, null, AlphaAdd);
	}

	public function setLowLatencyMode( mode : LowLatencyMode, frameLimitUs = 0 ) : Bool {
		lowLatencyMode = mode;
		this.frameLimitUs = frameLimitUs;
		if( latency == null )
			return false;
		if( mode == Off && getFrameGenMode() != Off )
			mode = On;
		return latency.setLowLatencyMode(mode, frameLimitUs);
	}

	public function getLowLatencyMode() : LowLatencyMode {
		return lowLatencyMode;
	}

	public function lowLatencySleep() {
		if( latency != null )
			latency.lowLatencySleep();
	}

	public function latencyMarker( m : LatencyMarker ) {
		if( latency != null )
			latency.latencyMarker(m);
	}

	public function isFlashIndicatorDriverControlled() : Bool {
		return latency != null && latency.isFlashIndicatorDriverControlled();
	}

	public function debug( f : UpscalingFeature ) : String {
		var buf = new StringBuf();
		buf.add(switch( f ) {
			case Upscaler: "=== Upscaling Debug ===\n";
			case FrameGen: "=== Frame Generation Debug ===\n";
			case LowLatency: "=== Low Latency Debug ===\n";
		});
		if( !ENABLED ) {
			buf.add("Upscaling is disabled (Upscaling.ENABLED = false)\n");
			return buf.toString();
		}
		if( f == FrameGen && !FRAME_GEN ) {
			buf.add("Frame generation is disabled (Upscaling.FRAME_GEN = false)\n");
			return buf.toString();
		}
		var b = getBackend(f);
		if( b == null ) {
			buf.add('No provider (UPSCALER = $UPSCALER, FRAME_GEN_PROVIDER = $FRAME_GEN_PROVIDER, LOW_LATENCY = $LOW_LATENCY)\n');
			if( backends.length == 0 )
				buf.add("No backend for this driver\n");
			for( b in backends )
				buf.add('${b.getName(f)}: ${b.getStatus(f)}\n');
			return buf.toString();
		}
		buf.add('provider=${b.getName(f)} upscaler=${getName(Upscaler)} frameGen=${getName(FrameGen)} lowLatency=${getName(LowLatency)}\n');
		if( f == Upscaler )
			debugUpscaler(buf);
		else
			buf.add(b.debug(f));
		return buf.toString();
	}

	function debugUpscaler( buf : StringBuf ) {
		buf.add('mode=$lastMode available=${getUpscalers()}\n');
		var input = lastInputs.color;
		var output = lastInputs.output;
		if( lastFrame < 0 || input == null || output == null ) {
			buf.add("Upscaling was never applied\n");
			return;
		}
		buf.add('render=${input.width}x${input.height} output=${output.width}x${output.height}\n');
		var issues = [];
		var age = hxd.Timer.frameCount - lastFrame;
		if( age > 1 )
			issues.push('not applied for $age frames');
		function checkInput( t : h3d.mat.Texture, name : String ) {
			if( t == null )
				issues.push('missing $name');
			else if( t.width != input.width || t.height != input.height )
				issues.push('$name is ${t.width}x${t.height}');
		}
		checkInput(lastInputs.depth, "depth");
		checkInput(lastInputs.motionVectors, "motion vectors");
		if( lastMode != Off && lastMode != NativeAA ) {
			var optimal = getRenderSize(lastMode, output.width, output.height);
			if( optimal != null && (optimal.renderWidth != input.width || optimal.renderHeight != input.height) )
				issues.push('render size differs from optimal ${optimal.renderWidth}x${optimal.renderHeight}');
		} else if( input.width != output.width || input.height != output.height )
			issues.push("render size differs from output size");
		for( issue in issues )
			buf.add('status: $issue\n');
		var details = upscaler.debug(Upscaler);
		buf.add(details);
		if( issues.length == 0 && details.indexOf("status:") < 0 )
			buf.add("status=Ok\n");
	}

	public function beforeCreateDevice() {
		upscaler = null;
		frameGen = null;
		latency = null;
		pendingRelease = [];
		for( b in backends ) {
			b.wanted = getWanted(b);
			b.supported = new haxe.EnumFlags();
			b.beforeCreateDevice();
		}
	}

	public function afterCreateDevice() {
		for( b in backends )
			b.afterCreateDevice();
		frameGen = getPreferred(FrameGen);
		latency = frameGen != null && frameGen.supported.has(LowLatency) ? frameGen : getPreferred(LowLatency);
		for( b in backends ) {
			var unused = new haxe.EnumFlags<UpscalingFeature>();
			if( b != frameGen && b.supported.has(FrameGen) )
				unused.set(FrameGen);
			if( b != latency && b.supported.has(LowLatency) )
				unused.set(LowLatency);
			if( unused.toInt() == 0 )
				continue;
			b.release(unused);
			b.supported = new haxe.EnumFlags(b.supported.toInt() & ~unused.toInt());
		}
		refresh();
	}

	public function afterCreateQueue() {
		for( b in backends )
			b.afterCreateQueue();
		refresh();
	}

	public function afterCreateSwapChain() {
		for( b in backends )
			b.afterCreateSwapChain();
		refresh();
	}

	public function beginFrame() {
		while( pendingRelease.length > 0 )
			pendingRelease.pop().releaseUpscaler();
		for( b in backends )
			b.beginFrame();
	}

	public function begin() {
		for( b in backends )
			b.begin();
	}

	public function beforePresent() {
		for( b in backends )
			b.beforePresent();
		prepareFrameGenUI();
	}

	public function beforeQueuePresent() {
		for( b in backends )
			b.beforeQueuePresent();
	}

	public function afterQueuePresent() {
		presentCount++;
		for( b in backends )
			b.afterQueuePresent();
	}

	public function beforeResize() {
		for( b in backends )
			b.beforeResize();
	}

	public function releaseResizeResources() {
		for( b in backends )
			b.releaseResizeResources();
		disposeFrameGenTextures();
	}

	public function afterResize() {
		for( b in backends )
			b.afterResize();
	}

	public function dispose() {
		disposeFrameGenTextures();
		var i = backends.length;
		while( i-- > 0 )
			backends[i].dispose();
		upscaler = null;
		frameGen = null;
		latency = null;
		pendingRelease = [];
	}

	function getWanted( b : UpscalingBackend ) {
		var f = new haxe.EnumFlags<UpscalingFeature>();
		if( !ENABLED )
			return f;
		if( UPSCALER == AUTO || UPSCALER == b.provider )
			f.set(Upscaler);
		if( FRAME_GEN && (FRAME_GEN_PROVIDER == AUTO || FRAME_GEN_PROVIDER == b.provider) )
			f.set(FrameGen);
		if( LOW_LATENCY )
			f.set(LowLatency);
		return f;
	}

	function getPreferred( f : UpscalingFeature ) {
		for( p in PRIORITY )
			for( b in backends )
				if( b.provider == p && b.supported.has(f) )
					return b;
		for( b in backends )
			if( b.supported.has(f) )
				return b;
		return null;
	}

	function getBackend( f : UpscalingFeature ) {
		return switch( f ) {
			case Upscaler: upscaler;
			case FrameGen: frameGen;
			case LowLatency: latency;
		}
	}

	function refresh() {
		if( upscaler == null || !upscaler.supported.has(Upscaler) )
			upscaler = getPreferred(Upscaler);
		if( frameGen != null && !frameGen.supported.has(FrameGen) )
			frameGen = null;
		if( latency != null && !latency.supported.has(LowLatency) )
			latency = null;
	}

	@:allow(h3d.impl)
	function getHudlessTexture() : h3d.mat.Texture {
		if( getFrameGenMode() == Off )
			return null;
		switch( frameGenUIMode ) {
		case HudLess:
		case UITexture if( !frameGen.composesFrameGenUI() ):
		default: return null;
		}
		var engine = h3d.Engine.getCurrent();
		var index = presentCount % frameGen.getHudlessBufferCount();
		var t = hudlessTextures[index];
		if( t == null || t.isDisposed() || t.width != engine.width || t.height != engine.height ) {
			if( t != null )
				t.dispose();
			t = new h3d.mat.Texture(engine.width, engine.height, [Target], RGBA);
			t.setName('frameGenHudless$index');
			t.preventAutoDispose();
			hudlessTextures[index] = t;
		}
		if( t.t == null )
			t.alloc();
		return t;
	}

	function prepareFrameGenUI() {
		if( frameGen == null || frameGenUIMode == BackBuffer )
			return;
		var hudless = getHudlessTexture();
		if( hudless != null && hudlessCaptured != presentCount )
			driver.copyBackBuffer(hudless);
		var ui = frameGenUIMode == UITexture && frameGenUIDrawn == presentCount ? frameGenUITarget : null;
		frameGen.setFrameGenUI(hudless, ui);
	}

	function disposeFrameGenTextures() {
		if( frameGen != null )
			frameGen.setFrameGenUI(null, null);
		for( t in hudlessTextures )
			if( t != null )
				t.dispose();
		hudlessTextures = [];
		hudlessCaptured = -1;
		if( frameGenUITarget != null ) {
			frameGenUITarget.dispose();
			frameGenUITarget = null;
		}
		frameGenUIDrawn = -1;
	}
}

#if (hldx && dx12 && dlss && !macro)

@:access(h3d.impl.DX12Driver)
class DX12DlssBackend extends UpscalingBackend {

	public static var CHECK_SIGNATURE = true;

	static var optimalSettings = new DLSSOptimalSettings();
	static var settings = new UpscalingSettings();
	static var options = new DLSSOptions();
	static var constants = new DLSSConstants();
	static var dlssgOptions = new DLSSGOptions();
	static var dlssgStateInfo = new DLSSGStateInfo();
	static var dlssgSettings = new FrameGenSettings();
	static var matCameraViewToClip = new DLSSMatrix();
	static var matClipToCameraView = new DLSSMatrix();
	static var matClipToLensClip = new DLSSMatrix();
	static var matClipToPrevClip = new DLSSMatrix();
	static var matPrevClipToClip = new DLSSMatrix();
	static var vecCameraPos = new DLSSVector();
	static var vecCameraUp = new DLSSVector();
	static var vecCameraRight = new DLSSVector();
	static var vecCameraFwd = new DLSSVector();

	var driver : DX12Driver;
	var slInitResult = -1;
	var slReady : Bool;
	var dlssSupportResult = -1;
	var dlssReady : Bool;
	var framegenReady : Bool;
	var pclReady : Bool;
	var reflexReady : Bool;
	var reflexState : ReflexStateInfo;
	var reflexMode : LowLatencyMode = Off;
	var frameToken : DLSSFrameToken;
	var pclFlashRequested : Bool;
	var dlssgMode : FrameGenMode = Off;
	var dlssgFrames = 1;
	var dlssgLastStatus = 0;
	var resizeDlssgMode : FrameGenMode = Off;
	var constantsFrame = -1;
	var lastResult = 0;
	var tagTypes : Array<DLSSBufferType> = [];
	var tagTextures : Array<h3d.mat.Texture> = [];

	public function new( driver : DX12Driver ) {
		super(DLSS);
		this.driver = driver;
	}

	override function beforeCreateDevice() {
		slReady = false;
		dlssReady = false;
		framegenReady = false;
		pclReady = false;
		reflexReady = false;
		slInitResult = -1;
		dlssSupportResult = -1;
		frameToken = null;
		dlssgMode = Off;
		reflexMode = Off;
		if( wanted.toInt() == 0 )
			return;
		var features = [];
		if( wanted.has(Upscaler) ) features.push(DLSSFeature.DLSS);
		if( wanted.has(FrameGen) ) features.push(DLSSFeature.FRAMEGEN);
		if( wanted.has(LowLatency) || wanted.has(FrameGen) ) features.push(DLSSFeature.REFLEX);
		var nativeFeatures = new hl.NativeArray<Int>(features.length);
		for( i => f in features )
			nativeFeatures[i] = f;
		slInitResult = Dlss.init(Upscaling.DEBUG, nativeFeatures, CHECK_SIGNATURE);
		slReady = slInitResult == 0;
	}

	override function afterCreateDevice() {
		supported = new haxe.EnumFlags();
		if( !slReady )
			return;
		var adapter = dx.Dx12.getAdapter();
		var dlssOk = false;
		if( wanted.has(Upscaler) ) {
			dlssSupportResult = Dlss.isFeatureSupported(adapter, DLSSFeature.DLSS);
			dlssOk = dlssSupportResult == 0;
		}
		var dlssgOk = wanted.has(FrameGen) && Dlss.isFeatureSupported(adapter, DLSSFeature.FRAMEGEN) == 0;
		var reflexOk = (wanted.has(LowLatency) || dlssgOk) && Dlss.isFeatureSupported(adapter, DLSSFeature.REFLEX) == 0;
		if( !dlssOk && !dlssgOk && !reflexOk ) {
			Dlss.shutdown();
			slReady = false;
			return;
		}
		dx.Dx12.setDevice(Dlss.upgradeDevice(driver.nativeDevice));
		slReady = Dlss.setDevice(dx.Dx12.getDevice()) == 0;
		if( !slReady )
			return;
		if( wanted.has(FrameGen) && !dlssgOk )
			Dlss.setFeatureLoaded(DLSSFeature.FRAMEGEN, false);
		dlssReady = dlssOk;
		framegenReady = dlssgOk;
		if( reflexOk ) {
			pclReady = Dlss.isFeatureSupported(adapter, DLSSFeature.PCL) == 0 && Dlss.pclInitStats() == 0;
			if( reflexState == null )
				reflexState = new ReflexStateInfo();
			reflexReady = Dlss.reflexSetOptions(ReflexModeNative.OFF, 0, false, PCLHotKey.USE_PING_MESSAGE, 0) == 0;
		}
		if( dlssReady ) supported.set(Upscaler);
		if( framegenReady ) supported.set(FrameGen);
		if( reflexReady ) supported.set(LowLatency);
	}

	override function release( unused : haxe.EnumFlags<UpscalingFeature> ) {
		if( unused.has(FrameGen) && framegenReady ) {
			Dlss.setFeatureLoaded(DLSSFeature.FRAMEGEN, false);
			framegenReady = false;
		}
		if( unused.has(LowLatency) )
			reflexReady = false;
	}

	override function afterCreateQueue() {
		if( !slReady )
			return;
		#if (hldx > version("1.16.0"))
		driver.nativeQueue = Dlss.getNativeQueue(driver.directQueue);
		#end
		dx.Dx12.setFactory(Dlss.upgradeFactory(driver.nativeFactory));
	}

	override function afterCreateSwapChain() {
		if( slReady && driver.swapChain != null )
			driver.setSwapChain(Dlss.upgradeSwapChain(driver.swapChain));
	}

	override function beginFrame() {
		if( !slReady )
			return;
		frameToken = Dlss.getNewFrameToken(driver.frameCount);
		if( reflexReady )
			Dlss.reflexGetState(reflexState);
	}

	override function begin() {
		pclMarker(PCLMarker.RENDER_SUBMIT_START);
	}

	override function beforeQueuePresent() {
		pclMarker(PCLMarker.RENDER_SUBMIT_END);
		pclMarker(PCLMarker.PRESENT_START);
	}

	override function afterQueuePresent() {
		pclMarker(PCLMarker.PRESENT_END);
		if( dlssgMode == Off )
			dlssgSettings.framesPresented = 1;
		else if( refreshDLSSGState() && dlssgSettings.status != 0 )
			setDlssgMode(Off, 1, false);
	}

	override function beforeResize() {
		resizeDlssgMode = dlssgMode;
		if( framegenReady && dlssgMode != Off )
			setDlssgMode(Off, 1, false);
	}

	override function afterResize() {
		if( framegenReady && resizeDlssgMode != Off )
			setDlssgMode(resizeDlssgMode, dlssgFrames, false);
	}

	override function dispose() {
		if( !slReady )
			return;
		if( dlssgMode != Off ) {
			setDlssgMode(Off, 1, true);
			Dlss.setFeatureLoaded(DLSSFeature.FRAMEGEN, false);
		}
		driver.waitGpu();
		Dlss.shutdown();
		slReady = false;
		dlssReady = false;
		framegenReady = false;
		pclReady = false;
		reflexReady = false;
		frameToken = null;
		supported = new haxe.EnumFlags();
	}

	override function isAvailable( f : UpscalingFeature ) : Bool {
		return switch( f ) {
			case LowLatency: reflexReady && reflexState != null && reflexState.lowLatencyAvailable != 0;
			default: supported.has(f);
		}
	}

	override function getName( f : UpscalingFeature ) : String {
		return switch( f ) {
			case Upscaler: "DLSS";
			case FrameGen: "DLSS-G";
			case LowLatency: "Reflex";
		}
	}

	override function getStatus( f : UpscalingFeature ) : String {
		if( !wanted.has(f) )
			return "not selected";
		if( slInitResult != 0 )
			return 'Streamline init failed ($slInitResult)';
		return switch( f ) {
			case Upscaler: dlssSupportResult < 0 ? "Streamline device setup failed" : 'not supported on this adapter ($dlssSupportResult)';
			case FrameGen: "not supported on this adapter";
			case LowLatency: "not supported on this adapter";
		}
	}

	override function debug( f : UpscalingFeature ) : String {
		return switch( f ) {
			case Upscaler: debugDlss();
			case FrameGen: debugDlssg();
			case LowLatency: debugReflex();
		}
	}

	function getMode( mode : UpscalingMode ) : DLSSModeNative {
		return switch( mode ) {
			case Off: DLSSModeNative.OFF;
			case NativeAA: DLSSModeNative.DLAA;
			case Quality: DLSSModeNative.MAXQUALITY;
			case Balanced: DLSSModeNative.BALANCED;
			case Performance: DLSSModeNative.MAXPERFORMANCE;
			case UltraPerformance: DLSSModeNative.ULTRAPERFORMANCE;
		}
	}

	override function getRenderSize( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		options.mode = getMode(mode);
		options.outputWidth = targetWidth;
		options.outputHeight = targetHeight;
		Dlss.getOptimalSettings(options, optimalSettings);
		settings.renderWidth = optimalSettings.optimalRenderWidth;
		settings.renderHeight = optimalSettings.optimalRenderHeight;
		return settings;
	}

	override function upscale( inputs : UpscalingInputs, params : UpscalingParams, mode : UpscalingMode ) {
		var output = inputs.output;
		if( !dlssReady || frameToken == null || output == null )
			return;
		options.mode = getMode(mode);
		options.outputWidth = output.width;
		options.outputHeight = output.height;
		options.colorBufferHDR = params.colorBufferHDR;
		options.preset = mode == NativeAA ? DLSSPreset.PRESET_L : DLSSPreset.PRESET_K;
		Dlss.setOptions(options);

		var cmd = driver.beginExternalCommands();
		addTag(DLSSBufferType.COLORIN, inputs.color);
		addTag(DLSSBufferType.MOTIONVECTORS, inputs.motionVectors);
		addTag(DLSSBufferType.DEPTH, inputs.depth);
		addTag(DLSSBufferType.COLOROUT, output);
		flushTags(cmd);
		setConstants(params);
		lastResult = Dlss.evaluateFeature(frameToken, cmd, DLSSFeature.DLSS);
		driver.endExternalCommands();
	}

	override function releaseUpscaler() {
		if( !dlssReady )
			return;
		driver.waitGpu();
		Dlss.freeResources(DLSSFeature.DLSS);
	}

	override function setFrameGenMode( mode : FrameGenMode, numFramesToGenerate : Int, releaseResources : Bool ) : Bool {
		return setDlssgMode(mode, numFramesToGenerate, releaseResources);
	}

	override function getFrameGenMode() : FrameGenMode {
		return dlssgMode;
	}

	override function getFrameGenSettings() : FrameGenSettings {
		return slReady && framegenReady ? dlssgSettings : null;
	}

	override function prepareFrameGen( inputs : UpscalingInputs, params : UpscalingParams ) {
		if( !framegenReady )
			return;
		addTag(DLSSBufferType.MOTIONVECTORS, inputs.motionVectors);
		addTag(DLSSBufferType.DEPTH, inputs.depth);
		flushTags(driver.frame.commandList);
		setConstants(params);
	}

	override function setFrameGenUI( hudless : h3d.mat.Texture, ui : h3d.mat.Texture ) {
		if( hudless == null && ui == null )
			return;
		if( hudless != null )
			driver.transition(hudless.t, NON_PIXEL_SHADER_RESOURCE);
		if( ui != null )
			driver.transition(ui.t, ALL_SHADER_RESOURCE);
		driver.flushTransitions();
		if( !framegenReady || dlssgMode == Off )
			return;
		addTag(DLSSBufferType.HUDLESSCOLOR, hudless);
		addTag(DLSSBufferType.UICOLORANDALPHA, ui);
		flushTags(driver.frame.commandList);
	}

	override function setLowLatencyMode( mode : LowLatencyMode, frameLimitUs : Int ) : Bool {
		if( !reflexReady )
			return false;
		var native = switch( mode ) {
			case Off: ReflexModeNative.OFF;
			case On: ReflexModeNative.LOW_LATENCY;
			case OnWithBoost: ReflexModeNative.LOW_LATENCY_WITH_BOOST;
		}
		if( Dlss.reflexSetOptions(native, frameLimitUs, false, PCLHotKey.USE_PING_MESSAGE, 0) != 0 )
			return false;
		reflexMode = mode;
		return true;
	}

	override function lowLatencySleep() {
		if( reflexReady && frameToken != null )
			Dlss.reflexSleep(frameToken);
	}

	override function latencyMarker( m : LatencyMarker ) {
		switch( m ) {
		case SimulationStart:
			if( pclReady && frameToken != null ) {
				pclMarker(PCLMarker.SIMULATION_START);
				Dlss.pclPollPing(frameToken);
			}
		case SimulationEnd:
			pclMarker(PCLMarker.SIMULATION_END);
			if( pclFlashRequested ) {
				pclMarker(PCLMarker.TRIGGER_FLASH);
				pclFlashRequested = false;
			}
		case TriggerFlash:
			pclFlashRequested = true;
		}
	}

	override function isFlashIndicatorDriverControlled() : Bool {
		return reflexReady && reflexState != null && reflexState.flashIndicatorDriverControlled != 0;
	}

	inline function pclMarker( marker : PCLMarker ) {
		if( slReady && pclReady && frameToken != null )
			Dlss.pclSetMarker(frameToken, marker);
	}

	function addTag( type : DLSSBufferType, t : h3d.mat.Texture ) {
		if( t == null || t.t == null )
			return;
		tagTypes.push(type);
		tagTextures.push(t);
	}

	function flushTags( cmd : dx.Dx12.CommandList ) {
		var count = tagTypes.length;
		if( count > 0 && frameToken != null ) {
			var resources = hl.CArray.alloc(DLSSResource, count);
			for( i in 0...count ) {
				var t = tagTextures[i];
				var r = resources[i];
				r.res = t.t.res;
				r.width = t.width;
				r.height = t.height;
				r.type = tagTypes[i];
				r.state = t.t.state;
				r.lifecycle = DLSSResourceLifecycle.VALID_UNTIL_PRESENT;
				t.lastFrame = driver.frameCount;
			}
			Dlss.setTagForFrame(frameToken, resources, count, cmd);
		}
		tagTypes.resize(0);
		tagTextures.resize(0);
	}

	inline static function loadVec( vec : DLSSVector, v : h3d.Vector ) {
		vec.x = cast(v.x, Single);
		vec.y = cast(v.y, Single);
		vec.z = cast(v.z, Single);
	}

	inline static function loadMat( mat : DLSSMatrix, m : h3d.Matrix ) {
		mat._11 = cast(m._11, Single); mat._12 = cast(m._12, Single); mat._13 = cast(m._13, Single); mat._14 = cast(m._14, Single);
		mat._21 = cast(m._21, Single); mat._22 = cast(m._22, Single); mat._23 = cast(m._23, Single); mat._24 = cast(m._24, Single);
		mat._31 = cast(m._31, Single); mat._32 = cast(m._32, Single); mat._33 = cast(m._33, Single); mat._34 = cast(m._34, Single);
		mat._41 = cast(m._41, Single); mat._42 = cast(m._42, Single); mat._43 = cast(m._43, Single); mat._44 = cast(m._44, Single);
	}

	function setConstants( params : UpscalingParams ) {
		if( !slReady || frameToken == null || constantsFrame == driver.frameCount )
			return;
		constantsFrame = driver.frameCount;

		loadMat(matCameraViewToClip, params.cameraViewToClip);
		loadMat(matClipToCameraView, params.clipToCameraView);
		loadMat(matClipToPrevClip, params.clipToPrevClip);
		loadMat(matPrevClipToClip, params.prevClipToClip);

		loadVec(vecCameraPos, params.cameraPos);
		loadVec(vecCameraUp, params.cameraUp);
		loadVec(vecCameraRight, params.cameraRight);
		loadVec(vecCameraFwd, params.cameraFwd);

		var c = constants;
		c.cameraViewToClip = matCameraViewToClip;
		c.clipToCameraView = matClipToCameraView;
		c.clipToLensClip = matClipToLensClip;
		c.clipToPrevClip = matClipToPrevClip;
		c.prevClipToClip = matPrevClipToClip;
		c.jitterOffsetX = params.jitterOffsetX;
		c.jitterOffsetY = params.jitterOffsetY;
		c.mvecScaleX = params.mvecScaleX;
		c.mvecScaleY = params.mvecScaleY;
		c.cameraPinholeOffsetX = 0.0;
		c.cameraPinholeOffsetY = 0.0;
		c.cameraPos = vecCameraPos;
		c.cameraUp = vecCameraUp;
		c.cameraRight = vecCameraRight;
		c.cameraFwd = vecCameraFwd;
		c.cameraNear = params.cameraNear;
		c.cameraFar = params.cameraFar;
		c.cameraFOV = params.cameraFOV;
		c.cameraAspectRatio = params.cameraAspectRatio;
		c.motionVectorsInvalidValue = params.motionVectorsInvalidValue;
		c.depthInverted = params.depthInverted;
		c.cameraMotionIncluded = params.cameraMotionIncluded;
		c.motionVectors3D = false;
		c.reset = params.reset;
		c.orthographicProjection = params.orthographicProjection;
		c.motionVectorsDilated = params.motionVectorsDilated;
		c.motionVectorsJittered = params.motionVectorsJittered;
		c.minRelativeLinearDepthObjectSeparation = 40.0;

		Dlss.setConstants(frameToken, c);
	}

	function setDlssgMode( mode : FrameGenMode, numFramesToGenerate : Int, releaseResources : Bool ) : Bool {
		if( !slReady || !framegenReady )
			return false;
		if( mode != Off && reflexMode == Off )
			return false;

		dlssgOptions.mode = switch( mode ) {
			case Off: DLSSGModeNative.OFF;
			case On: DLSSGModeNative.ON;
			case Auto: DLSSGModeNative.AUTO;
			case Dynamic: DLSSGModeNative.DYNAMIC;
		}
		dlssgOptions.numFramesToGenerate = numFramesToGenerate;
		if( mode != Off )
			dlssgFrames = numFramesToGenerate;

		dlssgOptions.flags = DLSSGFlag.RETAIN_RESOURCES_WHEN_OFF;
		if( Dlss.dlssgSetOptions(dlssgOptions) != 0 )
			return false;

		dlssgMode = mode;
		refreshDLSSGState();
		if( mode == Off && releaseResources )
			Dlss.freeResources(DLSSFeature.FRAMEGEN);
		return true;
	}

	function refreshDLSSGState() : Bool {
		if( !slReady || !framegenReady || Dlss.dlssgGetState(dlssgStateInfo) != 0 )
			return false;
		var s = dlssgSettings;
		s.status = dlssgStateInfo.status;
		s.minWidthOrHeight = dlssgStateInfo.minWidthOrHeight;
		s.framesPresented = dlssgStateInfo.numFramesActuallyPresented;
		s.maxFramesToGenerate = dlssgStateInfo.numFramesToGenerateMax;
		s.dynamicSupported = dlssgStateInfo.dynamicMFGSupported != 0;
		s.vsyncSupported = dlssgStateInfo.vsyncSupportAvailable != 0;
		if( s.status != 0 )
			dlssgLastStatus = s.status;
		return true;
	}

	function debugDlss() : String {
		var result : SlResult = cast lastResult;
		if( result == SlResult.WarnOutOfVRAM ) {
			var mem = driver.getMemoryUsage();
			return 'status: DLSS out of VRAM warning (${Std.int(mem.allocated / 1048576)} / ${Std.int(mem.total / 1048576)} MB)\n';
		}
		if( result != SlResult.Ok )
			return 'status: DLSS evaluate failed ($lastResult)\n';
		return "";
	}

	function debugDlssg() : String {
		var buf = new StringBuf();
		var state = dlssgSettings;
		buf.add('mode=$dlssgMode framesToGenerate=$dlssgFrames reflexMode=$reflexMode\n');
		buf.add('framesPresentedPerFrame=${state.framesPresented}\n');
		buf.add('minWidthOrHeight=${state.minWidthOrHeight} maxFramesToGenerate=${state.maxFramesToGenerate} ');
		buf.add('dynamicSupported=${state.dynamicSupported} vsyncSupported=${state.vsyncSupported}\n');
		var status = state.status == 0 ? dlssgLastStatus : state.status;
		if( status == 0 ) {
			buf.add("status=Ok\n");
		} else {
			if( status & 1 != 0 ) buf.add("status: output resolution too low\n");
			if( status & 2 != 0 ) buf.add("status: Reflex not active at runtime\n");
			if( status & 4 != 0 ) buf.add("status: HDR format not supported\n");
			if( status & 8 != 0 ) buf.add("status: common constants invalid\n");
			if( status & 16 != 0 ) buf.add("status: GetCurrentBackBufferIndex not called\n");
		}
		if( driver.currentWidth < state.minWidthOrHeight || driver.currentHeight < state.minWidthOrHeight )
			buf.add('backbuffer ${driver.currentWidth}x${driver.currentHeight} is below minWidthOrHeight\n');
		return buf.toString();
	}

	function debugReflex() : String {
		var buf = new StringBuf();
		if( reflexState == null )
			reflexState = new ReflexStateInfo();
		Dlss.reflexGetState(reflexState);
		buf.add('mode=$reflexMode ');
		buf.add('lowLatencyAvailable=${reflexState.lowLatencyAvailable} ');
		buf.add('latencyReportAvailable=${reflexState.latencyReportAvailable} ');
		buf.add('flashIndicatorDriverControlled=${reflexState.flashIndicatorDriverControlled} ');
		buf.add('statsWindowMessage=${reflexState.statsWindowMessage}\n');
		if( reflexState.lowLatencyAvailable == 0 ) buf.add("Low latency is not available.\n");
		if( reflexState.latencyReportAvailable == 0 ) buf.add("Latency report are not available.\n");
		var reports = [];
		for( i in 0...Dlss.REFLEX_FRAME_REPORT_COUNT ) {
			var r = new ReflexFrameReport();
			if( Dlss.reflexGetFrameReport(i, r) == 0 && r.frameID > 0 )
				reports.push(r);
		}
		if( reports.length == 0 ) {
			buf.add("Empty reports.\n");
			return buf.toString();
		}
		reports.sort((a, b) -> a.frameID < b.frameID ? -1 : (a.frameID > b.frameID ? 1 : 0));
		var totalPcLatency = 0.;
		var totalGpuFrameUs = 0.;
		buf.add('\nframeID   simMs   renderMs   driverMs   osQueueMs   gpuMs   pcLatencyMs   gpuFrameTimeUs\n');
		for( r in reports ) {
			inline function ms( a : Float, b : Float ) return (b - a) / 1000.0;
			var pcLatency = ms(r.simStartTime, r.presentEndTime);
			buf.add('${r.frameID}   ${ms(r.simStartTime, r.simEndTime)}   ${ms(r.renderSubmitStartTime, r.renderSubmitEndTime)}   ${ms(r.driverStartTime, r.driverEndTime)}   ${ms(r.osRenderQueueStartTime, r.osRenderQueueEndTime)}   ${ms(r.gpuRenderStartTime, r.gpuRenderEndTime)}   ${pcLatency}   ${r.gpuFrameTimeUs}\n');
			totalPcLatency += pcLatency;
			totalGpuFrameUs += r.gpuFrameTimeUs;
			if( r.driverStartTime <= 0 || r.gpuRenderStartTime <= 0 || r.osRenderQueueStartTime <= 0 )
				buf.add("One or more driver/OS/GPU timestamps are 0.\n");
		}
		var n = reports.length;
		buf.add('\nSampled ${n} frames. Avg PC latency: ${totalPcLatency / n} ms. Avg GPU frame time: ${totalGpuFrameUs / n} us.\n');
		return buf.toString();
	}
}

#end

#if (hldx && dx12 && fsr && !macro)

@:access(h3d.impl.DX12Driver)
@:access(h3d.impl.Upscaling)
class DX12FsrBackend extends UpscalingBackend {

	public static var FRAME_GEN_ASYNC = false;
	public static var FRAME_GEN_DEBUG_FLAGS = 0;
	public static var DEBUG_VIEW = false;

	static inline var FG_STATUS_CONTEXT_FAILED = 1;
	static inline var FG_STATUS_CONFIGURE_FAILED = 2;
	static inline var FG_STATUS_PREPARE_FAILED = 4;
	static inline var FG_STATUS_NOT_PREPARED = 8;

	static var params = new FsrDispatchParams();
	static var fgConfig = new FsrFrameGenConfig();
	static var fgPrepare = new FsrFrameGenPrepareParams();
	static var fgSettings = new FrameGenSettings();

	var driver : DX12Driver;
	var loaded : Bool;
	var initResult = -1;

	var context : FsrContext;
	var contextWidth = -1;
	var contextHeight = -1;
	var contextFlags = -1;
	var lastResult = 0;
	var settings = new UpscalingSettings();
	var settingsMode : UpscalingMode = null;
	var settingsWidth = -1;
	var settingsHeight = -1;

	var proxy : FsrSwapChain;
	var swapChainResult : Int = FsrResult.NotCreated;
	var fgName : String;
	var fgContext : FsrContext;
	var fgContextWidth = -1;
	var fgContextHeight = -1;
	var fgContextFlags = -1;
	var fgContextResult = 0;
	var fgMode : FrameGenMode = Off;
	var fgPendingRelease : Bool;
	var fgFrameId = 0;
	var fgConfiguredFrame = -1;
	var fgPreparedFrame = -1;
	var fgConfigureResult = 0;
	var fgPrepareResult = 0;
	var uiRegistered : Bool;

	var antiLag2Ready : Bool;
	var antiLag2Result = 0;
	var antiLag2Mode : LowLatencyMode = Off;
	var antiLag2MaxFps = 0;

	public function new( driver : DX12Driver ) {
		super(FSR);
		this.driver = driver;
	}

	override function beforeCreateDevice() {
		initResult = -1;
		swapChainResult = FsrResult.NotCreated;
		fgName = null;
		fgMode = Off;
		antiLag2Result = 0;
		antiLag2Mode = Off;
	}

	override function afterCreateDevice() {
		supported = new haxe.EnumFlags();
		var device = driver.nativeDevice;
		if( wanted.has(Upscaler) || wanted.has(FrameGen) ) {
			initResult = Fsr.init(device, Upscaling.DEBUG ? FsrDebugLevel.WARNINGS : FsrDebugLevel.ERRORS);
			loaded = initResult == FsrResult.Ok;
			if( loaded ) {
				if( wanted.has(Upscaler) && Fsr.isEffectAvailable(device, FsrEffect.UPSCALE) )
					supported.set(Upscaler);
				if( wanted.has(FrameGen) && Fsr.isEffectAvailable(device, FsrEffect.FRAME_GENERATION) )
					supported.set(FrameGen);
			} else
				trace('FSR unavailable ($initResult)');
		}
		if( wanted.has(LowLatency) ) {
			antiLag2Result = Fsr.antiLag2Init(device);
			antiLag2Ready = antiLag2Result == 0;
			if( antiLag2Ready )
				supported.set(LowLatency);
		}
	}

	override function release( unused : haxe.EnumFlags<UpscalingFeature> ) {
		if( unused.has(LowLatency) && antiLag2Ready ) {
			Fsr.antiLag2DeInit();
			antiLag2Ready = false;
		}
	}

	override function afterCreateQueue() {
		if( !supported.has(FrameGen) )
			return;
		var res = 0;
		proxy = Fsr.createSwapChain(@:privateAccess driver.window.win, driver.nativeFactory, driver.nativeQueue, driver.window.width, driver.window.height, DX12Driver.BUFFER_COUNT, R8G8B8A8_UNORM, res);
		swapChainResult = res;
		if( proxy == null ) {
			trace('FSR frame generation swapchain unavailable ($res)');
			supported.unset(FrameGen);
			return;
		}
		driver.setSwapChain(proxy);
		var version = Fsr.getEffectVersion(driver.nativeDevice, FsrEffect.FRAME_GENERATION);
		fgName = version == null ? "FSR FG" : "FSR FG " + version;
	}

	override function beforePresent() {
		if( proxy != null )
			finishFrameGen();
	}

	override function beforeQueuePresent() {
		if( antiLag2Ready && proxy != null )
			antiLag2Result = Fsr.antiLag2Present(proxy, antiLag2Mode != Off);
	}

	override function afterQueuePresent() {
		if( proxy == null )
			return;
		fgFrameId++;
		if( fgPendingRelease ) {
			fgPendingRelease = false;
			destroyFgContext();
		}
	}

	override function releaseResizeResources() {
		destroyContext();
		destroyFgContext();
	}

	override function dispose() {
		if( proxy != null ) {
			destroyFgContext();
			Fsr.destroySwapChainContext();
			var swapChain = driver.swapChain;
			driver.setSwapChain(null);
			var refsLeft = Fsr.releaseSwapChain(swapChain);
			if( Upscaling.DEBUG || refsLeft != 0 )
				trace('FSR frame generation swapchain released ($refsLeft refs left)');
			proxy = null;
		}
		destroyContext();
		if( antiLag2Ready ) {
			Fsr.antiLag2DeInit();
			antiLag2Ready = false;
		}
		if( loaded ) {
			Fsr.shutdown();
			loaded = false;
		}
		uiRegistered = false;
		supported = new haxe.EnumFlags();
	}

	override function getName( f : UpscalingFeature ) : String {
		return switch( f ) {
			case Upscaler: context != null ? "FSR " + Fsr.getVersion(context) : "FSR";
			case FrameGen: fgName != null ? fgName : "FSR FG";
			case LowLatency: "Anti-Lag 2";
		}
	}

	override function getStatus( f : UpscalingFeature ) : String {
		if( !wanted.has(f) )
			return "not selected";
		return switch( f ) {
			case Upscaler:
				loaded ? "no upscaler provider for this device" : 'init failed ($initResult)';
			case FrameGen:
				if( !loaded )
					'init failed ($initResult)';
				else if( swapChainResult != FsrResult.Ok && swapChainResult != FsrResult.NotCreated )
					'swapchain creation failed ($swapChainResult)';
				else
					"no frame generation provider for this device";
			case LowLatency:
				'not available ($antiLag2Result)';
		}
	}

	override function debug( f : UpscalingFeature ) : String {
		return switch( f ) {
			case Upscaler: debugFsr();
			case FrameGen: debugFrameGen();
			case LowLatency: debugAntiLag2();
		}
	}

	function getQuality( mode : UpscalingMode ) : FsrQuality {
		return switch( mode ) {
			case Off, NativeAA: FsrQuality.NATIVE_AA;
			case Quality: FsrQuality.QUALITY;
			case Balanced: FsrQuality.BALANCED;
			case Performance: FsrQuality.PERFORMANCE;
			case UltraPerformance: FsrQuality.ULTRA_PERFORMANCE;
		}
	}

	override function getRenderSize( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		if( mode == settingsMode && targetWidth == settingsWidth && targetHeight == settingsHeight )
			return settings;
		var renderWidth = targetWidth;
		var renderHeight = targetHeight;
		var res = Fsr.getRenderResolution(driver.nativeDevice, getQuality(mode), targetWidth, targetHeight, renderWidth, renderHeight);
		if( res != FsrResult.Ok ) {
			trace('FSR render resolution query failed ($res)');
			renderWidth = targetWidth;
			renderHeight = targetHeight;
		}
		settings.renderWidth = renderWidth;
		settings.renderHeight = renderHeight;
		settingsMode = mode;
		settingsWidth = targetWidth;
		settingsHeight = targetHeight;
		return settings;
	}

	override function upscale( inputs : UpscalingInputs, p : UpscalingParams, mode : UpscalingMode ) {
		var color = inputs.color;
		var depth = inputs.depth;
		var motionVectors = inputs.motionVectors;
		var output = inputs.output;
		if( color?.t == null || depth?.t == null || motionVectors?.t == null || output?.t == null )
			return;

		var flags = 0;
		if( p.autoExposure )
			flags |= FsrCreateFlag.AUTO_EXPOSURE;
		if( p.colorBufferHDR )
			flags |= FsrCreateFlag.HIGH_DYNAMIC_RANGE;
		else
			flags |= FsrCreateFlag.NON_LINEAR_COLORSPACE;
		if( p.depthInverted )
			flags |= FsrCreateFlag.DEPTH_INVERTED;
		if( p.motionVectorsJittered )
			flags |= FsrCreateFlag.MOTION_VECTORS_JITTER_CANCELLATION;
		if( Upscaling.DEBUG ) {
			flags |= FsrCreateFlag.DEBUG_CHECKING;
			flags |= FsrCreateFlag.DEBUG_VISUALIZATION;
		}

		if( output.width != contextWidth || output.height != contextHeight || flags != contextFlags ) {
			destroyContext();
			var res = 0;
			context = Fsr.createContext(driver.nativeDevice, flags, output.width, output.height, output.width, output.height, res);
			contextWidth = output.width;
			contextHeight = output.height;
			contextFlags = flags;
			if( context == null )
				trace('FSR context creation failed ($res)');
			else
				trace('FSR ${Fsr.getVersion(context)} context ${output.width}x${output.height}');
		}
		if( context == null )
			return;

		var cmd = driver.beginExternalCommands();

		var d = params;
		d.color = color.t.res;
		d.colorState = color.t.state;
		d.depth = depth.t.res;
		d.depthState = depth.t.state;
		d.motionVectors = motionVectors.t.res;
		d.motionVectorsState = motionVectors.t.state;
		d.output = output.t.res;
		d.outputState = output.t.state;
		d.jitterOffsetX = p.jitterOffsetX;
		d.jitterOffsetY = p.jitterOffsetY;
		d.motionVectorScaleX = p.mvecScaleX * color.width;
		d.motionVectorScaleY = p.mvecScaleY * color.height;
		d.renderWidth = color.width;
		d.renderHeight = color.height;
		d.upscaleWidth = output.width;
		d.upscaleHeight = output.height;
		d.enableSharpening = false;
		d.sharpness = 0.;
		d.frameTimeDelta = hxd.Timer.elapsedTime * 1000.;
		d.preExposure = 1.;
		d.reset = p.reset;
		d.cameraNear = p.cameraNear;
		d.cameraFar = p.cameraFar;
		d.cameraFovAngleVertical = hxd.Math.degToRad(p.cameraFOV);
		d.viewSpaceToMetersFactor = 1.;
		var dispatchFlags = 0;
		if( !p.colorBufferHDR )
			dispatchFlags |= FsrDispatchFlag.NON_LINEAR_COLOR_SRGB;
		if( Upscaling.DEBUG && DEBUG_VIEW )
			dispatchFlags |= FsrDispatchFlag.DRAW_DEBUG_VIEW;
		d.flags = dispatchFlags;

		driver.beginEvent("FSR");
		var res = Fsr.dispatch(context, cmd, d);
		driver.endEvent();
		driver.endExternalCommands();
		if( res != lastResult ) {
			if( res != FsrResult.Ok )
				trace('FSR dispatch failed ($res)');
			lastResult = res;
		}

		color.lastFrame = driver.frameCount;
		depth.lastFrame = driver.frameCount;
		motionVectors.lastFrame = driver.frameCount;
		output.lastFrame = driver.frameCount;
	}

	override function releaseUpscaler() {
		destroyContext();
	}

	function destroyContext() {
		if( context != null ) {
			driver.waitGpu();
			Fsr.destroyContext(context);
			context = null;
		}
		contextWidth = -1;
		contextHeight = -1;
		contextFlags = -1;
	}

	override function setFrameGenMode( mode : FrameGenMode, numFramesToGenerate : Int, releaseResources : Bool ) : Bool {
		if( proxy == null )
			return false;
		if( mode == Off ) {
			fgMode = Off;
			if( releaseResources && fgContext != null )
				fgPendingRelease = true;
		} else {
			fgMode = On;
			fgPendingRelease = false;
		}
		return true;
	}

	override function getFrameGenMode() : FrameGenMode {
		return fgMode;
	}

	override function getFrameGenSettings() : FrameGenSettings {
		return proxy != null ? fgSettings : null;
	}

	override function composesFrameGenUI() : Bool {
		return proxy != null;
	}

	override function getHudlessBufferCount() : Int {
		return FRAME_GEN_ASYNC ? 2 : 1;
	}

	override function setFrameGenUI( hudless : h3d.mat.Texture, ui : h3d.mat.Texture ) {
		if( hudless != null || ui != null ) {
			if( hudless != null )
				driver.transition(hudless.t, NON_PIXEL_SHADER_RESOURCE);
			if( ui != null )
				driver.transition(ui.t, ALL_SHADER_RESOURCE);
			driver.flushTransitions();
		}
		if( proxy == null )
			return;
		if( ui != null ) {
			Fsr.registerUiResource(ui.t.res, ui.t.state, FsrUiCompositionFlag.USE_PREMUL_ALPHA | FsrUiCompositionFlag.ENABLE_INTERNAL_UI_DOUBLE_BUFFERING);
			uiRegistered = true;
		} else if( uiRegistered ) {
			Fsr.registerUiResource(null, COMMON, 0);
			uiRegistered = false;
		}
	}

	function configureFrameGen( enabled : Bool ) : Int {
		var cfg = fgConfig;
		var hudless = enabled ? driver.upscaling.getHudlessTexture() : null;
		cfg.swapChain = proxy;
		cfg.hudless = hudless == null ? null : hudless.t.res;
		cfg.hudlessState = hudless == null ? COMMON : NON_PIXEL_SHADER_RESOURCE;
		cfg.flags = FRAME_GEN_DEBUG_FLAGS;
		cfg.rectX = 0;
		cfg.rectY = 0;
		cfg.rectWidth = driver.currentWidth;
		cfg.rectHeight = driver.currentHeight;
		cfg.frameID = fgFrameId;
		cfg.enabled = enabled;
		cfg.allowAsyncWorkloads = FRAME_GEN_ASYNC;
		cfg.onlyPresentGenerated = false;
		return Fsr.configureFrameGen(fgContext, cfg);
	}

	function destroyFgContext() {
		if( fgContext != null ) {
			driver.waitGpu();
			configureFrameGen(false);
			Fsr.waitForPresents();
			Fsr.destroyContext(fgContext);
			fgContext = null;
		}
		fgContextWidth = -1;
		fgContextHeight = -1;
		fgContextFlags = -1;
		fgContextResult = 0;
	}

	override function prepareFrameGen( inputs : UpscalingInputs, p : UpscalingParams ) {
		var depth = inputs.depth;
		var motionVectors = inputs.motionVectors;
		if( proxy == null || fgConfiguredFrame == fgFrameId )
			return;

		var enabled = fgMode != Off && depth?.t != null && motionVectors?.t != null;
		if( enabled ) {
			var flags = 0;
			if( p.depthInverted )
				flags |= FsrFrameGenCreateFlag.DEPTH_INVERTED;
			if( p.motionVectorsJittered )
				flags |= FsrFrameGenCreateFlag.MOTION_VECTORS_JITTER_CANCELLATION;
			if( Upscaling.DEBUG )
				flags |= FsrFrameGenCreateFlag.DEBUG_CHECKING;
			if( FRAME_GEN_ASYNC )
				flags |= FsrFrameGenCreateFlag.ASYNC_WORKLOAD_SUPPORT;
			if( driver.currentWidth != fgContextWidth || driver.currentHeight != fgContextHeight || flags != fgContextFlags ) {
				destroyFgContext();
				var res = 0;
				fgContext = Fsr.createFrameGenContext(driver.nativeDevice, flags, driver.currentWidth, driver.currentHeight, driver.currentWidth, driver.currentHeight, dx.Dx12.DxgiFormat.R8G8B8A8_UNORM, dx.Dx12.DxgiFormat.UNKNOWN, res);
				fgContextResult = res;
				fgContextWidth = driver.currentWidth;
				fgContextHeight = driver.currentHeight;
				fgContextFlags = flags;
				if( fgContext == null )
					trace('FSR frame generation context creation failed ($res)');
				else if( Upscaling.DEBUG )
					trace('$fgName context ${driver.currentWidth}x${driver.currentHeight}');
			}
		}
		if( fgContext == null )
			return;

		fgConfigureResult = configureFrameGen(enabled);
		fgConfiguredFrame = fgFrameId;
		if( !enabled || fgConfigureResult != FsrResult.Ok )
			return;

		var cmd = driver.beginExternalCommands();

		var d = fgPrepare;
		d.depth = depth.t.res;
		d.depthState = depth.t.state;
		d.motionVectors = motionVectors.t.res;
		d.motionVectorsState = motionVectors.t.state;
		d.renderWidth = motionVectors.width;
		d.renderHeight = motionVectors.height;
		d.jitterOffsetX = p.jitterOffsetX;
		d.jitterOffsetY = p.jitterOffsetY;
		d.motionVectorScaleX = p.mvecScaleX * motionVectors.width;
		d.motionVectorScaleY = p.mvecScaleY * motionVectors.height;
		d.frameTimeDelta = hxd.Timer.elapsedTime * 1000.;
		d.reset = p.reset;
		d.cameraNear = p.cameraNear;
		d.cameraFar = p.cameraFar;
		d.cameraFovAngleVertical = hxd.Math.degToRad(p.cameraFOV);
		d.viewSpaceToMetersFactor = 1.;
		d.cameraPositionX = p.cameraPos.x;
		d.cameraPositionY = p.cameraPos.y;
		d.cameraPositionZ = p.cameraPos.z;
		d.cameraUpX = p.cameraUp.x;
		d.cameraUpY = p.cameraUp.y;
		d.cameraUpZ = p.cameraUp.z;
		d.cameraRightX = p.cameraRight.x;
		d.cameraRightY = p.cameraRight.y;
		d.cameraRightZ = p.cameraRight.z;
		d.cameraForwardX = p.cameraFwd.x;
		d.cameraForwardY = p.cameraFwd.y;
		d.cameraForwardZ = p.cameraFwd.z;
		d.frameID = fgFrameId;
		d.flags = FRAME_GEN_DEBUG_FLAGS;

		driver.beginEvent("FSR FG Prepare");
		fgPrepareResult = Fsr.dispatchFrameGenPrepare(fgContext, cmd, d);
		driver.endEvent();
		driver.endExternalCommands();
		fgPreparedFrame = fgFrameId;

		depth.lastFrame = driver.frameCount;
		motionVectors.lastFrame = driver.frameCount;
	}

	function finishFrameGen() {
		if( fgContext != null && fgConfiguredFrame != fgFrameId ) {
			fgConfigureResult = configureFrameGen(false);
			fgConfiguredFrame = fgFrameId;
		}
		var prepared = fgPreparedFrame == fgFrameId;
		var status = 0;
		if( fgMode != Off ) {
			if( fgContext == null && fgContextFlags != -1 )
				status |= FG_STATUS_CONTEXT_FAILED;
			if( fgConfigureResult != FsrResult.Ok )
				status |= FG_STATUS_CONFIGURE_FAILED;
			if( prepared && fgPrepareResult != FsrResult.Ok )
				status |= FG_STATUS_PREPARE_FAILED;
			if( !prepared )
				status |= FG_STATUS_NOT_PREPARED;
		}
		var s = fgSettings;
		s.status = status;
		s.framesPresented = fgMode != Off && prepared && fgPrepareResult == FsrResult.Ok && fgConfigureResult == FsrResult.Ok ? 2 : 1;
		s.maxFramesToGenerate = 1;
		s.minWidthOrHeight = 0;
		s.dynamicSupported = false;
		s.vsyncSupported = true;
	}

	override function setLowLatencyMode( mode : LowLatencyMode, frameLimitUs : Int ) : Bool {
		if( !antiLag2Ready )
			return false;
		antiLag2Mode = mode;
		antiLag2MaxFps = frameLimitUs > 0 ? Math.round(1000000 / frameLimitUs) : 0;
		return true;
	}

	override function lowLatencySleep() {
		if( antiLag2Ready )
			antiLag2Result = Fsr.antiLag2Update(antiLag2Mode != Off, antiLag2MaxFps);
	}

	function debugFsr() : String {
		var buf = new StringBuf();
		if( context == null )
			buf.add("status: FSR context creation failed\n");
		else if( lastResult != FsrResult.Ok )
			buf.add('status: FSR dispatch failed ($lastResult)\n');
		if( Upscaling.DEBUG )
			buf.add("FSR debug checker on, warnings go to the log\n");
		return buf.toString();
	}

	function debugFrameGen() : String {
		var buf = new StringBuf();
		var state = fgContext == null ? (fgPendingRelease ? "releasing" : "no context") : "context";
		buf.add('mode=$fgMode state=$state async=$FRAME_GEN_ASYNC debugFlags=$FRAME_GEN_DEBUG_FLAGS\n');
		buf.add('display=${driver.currentWidth}x${driver.currentHeight}');
		if( fgContext != null )
			buf.add(' context=${fgContextWidth}x${fgContextHeight} flags=$fgContextFlags');
		buf.add('\n');
		buf.add('frameID=$fgFrameId lastConfigured=$fgConfiguredFrame lastPrepared=$fgPreparedFrame\n');
		buf.add('framesPresentedPerFrame=${fgSettings.framesPresented}\n');
		var total = 0.;
		var aliasable = 0.;
		if( fgContext != null && Fsr.queryFrameGenMemory(fgContext, total, aliasable) == FsrResult.Ok )
			buf.add('memory: frameGen=${Std.int(total / 1048576)}MB (aliasable ${Std.int(aliasable / 1048576)}MB)');
		if( Fsr.querySwapChainMemory(total, aliasable) == FsrResult.Ok )
			buf.add(' swapchain=${Std.int(total / 1048576)}MB');
		buf.add('\n');
		var status = fgSettings.status;
		if( status == 0 ) {
			buf.add("status=Ok\n");
		} else {
			if( status & FG_STATUS_CONTEXT_FAILED != 0 ) buf.add('status: context creation failed ($fgContextResult)\n');
			if( status & FG_STATUS_CONFIGURE_FAILED != 0 ) buf.add('status: configure failed ($fgConfigureResult)\n');
			if( status & FG_STATUS_PREPARE_FAILED != 0 ) buf.add('status: prepare failed ($fgPrepareResult)\n');
			if( status & FG_STATUS_NOT_PREPARED != 0 ) buf.add("status: prepareFrameGen not called this frame\n");
		}
		return buf.toString();
	}

	function debugAntiLag2() : String {
		var buf = new StringBuf();
		buf.add('mode=$antiLag2Mode maxFps=$antiLag2MaxFps lastResult=$antiLag2Result');
		if( proxy != null )
			buf.add(' frameGen=$fgMode (frame type signaled through the swapchain)');
		buf.add('\n');
		return buf.toString();
	}
}

#end
