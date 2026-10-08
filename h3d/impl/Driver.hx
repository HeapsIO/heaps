package h3d.impl;

#if macro
typedef GPUBuffer = {};
typedef Texture = {};
typedef Query = {};
typedef DriverImpl = Driver;
#elseif js
typedef GPUBuffer = js.html.webgl.Buffer;
typedef Texture = { t : js.html.webgl.Texture, width : Int, height : Int, internalFmt : Int, pixelFmt : Int, bits : Int, bind : Int #if multidriver, driver : Driver #end };
typedef Query = {};
typedef DriverImpl = GlDriver;
#elseif hlsdl
typedef GPUBuffer = sdl.GL.Buffer;
typedef Texture = { t : sdl.GL.Texture, width : Int, height : Int, internalFmt : Int, pixelFmt : Int, bits : Int, bind : Int #if multidriver, driver : Driver #end };
typedef Query = { q : sdl.GL.Query, kind : QueryKind };
typedef DriverImpl = GlDriver;
#elseif usegl
typedef GPUBuffer = haxe.GLTypes.Buffer;
typedef Texture = { t : haxe.GLTypes.Texture, width : Int, height : Int, internalFmt : Int, pixelFmt : Int, bits : Int, bind : Int };
typedef Query = { q : haxe.GLTypes.Query, kind : QueryKind };
typedef DriverImpl = GlDriver;
#elseif (hldx && dx12)
typedef GPUBuffer = DX12Driver.BufferData;
typedef Texture = h3d.impl.DX12Driver.TextureData;
typedef Query = h3d.impl.DX12Driver.QueryData;
typedef DriverImpl = DX12Driver;
#elseif hldx
typedef GPUBuffer = dx.Resource;
typedef Texture = { res : dx.Resource, view : dx.Driver.ShaderResourceView, ?depthView : dx.Driver.DepthStencilView, ?readOnlyDepthView : dx.Driver.DepthStencilView, rt : Array<dx.Driver.RenderTargetView>, ?views : Array<dx.Driver.ShaderResourceView> };
typedef Query = {};
typedef DriverImpl = Driver;
#elseif usesys
typedef GPUBuffer = haxe.GraphicsDriver.GPUBuffer;
typedef Texture = haxe.GraphicsDriver.Texture;
typedef Query = haxe.GraphicsDriver.Query;
typedef DriverImpl = Driver;
#else
typedef GPUBuffer = {};
typedef Texture = {};
typedef Query = {};
typedef DriverImpl = Driver;
#end

enum Feature {
	/*
		Do the shader support standard derivates functions (ddx ddy).
	*/
	StandardDerivatives;
	/*
		Can use allocate floating point textures.
	*/
	FloatTextures;
	/*
		Can we allocate custom depth buffers. If not, default depth buffer
		(queried with DepthBuffer.getDefault()) will be clear if we change
		the render target resolution or format.
	*/
	AllocDepthBuffer;
	/*
		Is our driver hardware accelerated or CPU emulated.
	*/
	HardwareAccelerated;
	/*
		Allows to render on several render targets with a single draw.
	*/
	MultipleRenderTargets;
	/*
		Does it supports query objects API.
	*/
	Queries;
	/*
		Supports gamma correct textures
	*/
	SRGBTextures;
	/*
		Allows advanced shader operations (webgl2, opengl3+, directx 9.0c+)
	*/
	ShaderModel3;
	/*
		Tells if the driver uses bottom-left coordinates for textures.
	*/
	BottomLeftCoords;
	/*
		Supports rendering in wireframe mode.
	*/
	Wireframe;
	/*
		Supports instanced rendering
	*/
	InstancedRendering;
	/*
		Supports bindless
	*/
	Bindless;
	Upscaling;
	/*
		Can render into a single layer of a depth texture array.
	*/
	DepthTextureArray;
	/*
		Supports compute shaders and read/write storage buffers.
	*/
	ComputeShaders;
	/*
		Sampler arrays can be indexed by a non-constant, dynamically uniform expression.
	*/
	DynamicSamplerIndex;
	/*
		Supports depth clamping instead of clipping against the near and far planes.
	*/
	DepthClamp;
	/*
		Textures can allocate only their less detailed mip levels (see Texture.setResidentMip).
	*/
	ResidentMips;
}

enum QueryKind {
	/**
		The result will give the GPU Timestamp (in nanoseconds, 1e-9 seconds) at the time the endQuery is performed
	**/
	TimeStamp;
	/**
		The result will give the number of samples that passes the depth buffer between beginQuery/endQuery range
	**/
	Samples;
	/**
		The result will give the GPU elapsed time (in nanoseconds, 1e-9 seconds) between beginQuery/endQuery range
	**/
	TimeElapsed;
}

enum RenderFlag {
	/**
		0 = LeftHanded (default), 1 = RightHanded. Affects the meaning of triangle culling value.
	**/
	CameraHandness;
}

enum UpscalingTag {
	Depth;
	MotionVectors;
	ColorIn;
	ColorOut;
	HUDLess;
	UIColorAndAlpha;
	UIAlpha;
}

@:struct class UpscalingParams {
	public var cameraViewToClip : Matrix;
	public var clipToCameraView : Matrix;
	public var clipToPrevClip : Matrix;
	public var prevClipToClip : Matrix;
	public var jitterOffsetX : Float;
	public var jitterOffsetY : Float;
	public var mvecScaleX : Float;
	public var mvecScaleY : Float;
	public var cameraPos : Vector;
	public var cameraUp : Vector;
	public var cameraRight : Vector;
	public var cameraFwd : Vector;
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

@struct class UpscalingSettings {
	public var renderWidth : Int;
	public var renderHeight : Int;
	public function new() {
	}
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

enum LowLatencyMode {
	Off;
	On;
	OnWithBoost;
}

class Driver {

	static var SHADER_CACHE : h3d.impl.ShaderCache;
	var shaderCache = SHADER_CACHE;

	public static function setShaderCache( cache : h3d.impl.ShaderCache ) {
		SHADER_CACHE = cache;
	}

	public var logEnable : Bool;


	public function hasFeature( f : Feature ) {
		return false;
	}

	public static var requestedFeatures(default, null) = new haxe.EnumFlags<Feature>();
	public static function requestFeature( f : Feature ) : Bool {
		if( h3d.Engine.getCurrent() != null )
			throw "Driver.requestFeature(" + f + ") must be called before the engine is created";
		var accepted = DriverImpl.onFeatureRequested(f);
		if( accepted )
			requestedFeatures.set(f);
		return accepted;
	}

	static function onFeatureRequested( f : Feature ) : Bool {
		return false;
	}

	public function setRenderFlag( r : RenderFlag, value : Int ) {
	}

	public function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return false;
	}

	public function isDisposed() {
		return true;
	}

	public function dispose() {
	}

	public function begin( frame : Int ) {
	}

	public inline function log( str : String ) {
		#if debug
		if( logEnable ) logImpl(str);
		#end
	}

	public function generateMipMaps( texture : h3d.mat.Texture ) {
		throw "Mipmaps auto generation is not supported on this platform";
	}

	public function getNativeShaderCode( shader : hxsl.RuntimeShader ) : String {
		return null;
	}

	public function warmupShader( shader : hxsl.RuntimeShader ) {
	}

	function logImpl( str : String ) {
	}

	public function clear( ?color : h3d.Vector4, ?depth : Float, ?stencil : Int ) {
	}

	public function getMemoryUsage() : Null<{ total : Float, allocated : Float, free : Float }>  {
		return null;
	}

	public function captureRenderBuffer( pixels : hxd.Pixels ) {
	}

	public function capturePixels( tex : h3d.mat.Texture, layer : Int, mipLevel : Int, ?region : h2d.col.IBounds ) : hxd.Pixels {
		throw "Can't capture pixels on this platform";
		return null;
	}

	public function getDriverName( details : Bool ) {
		return "Not available";
	}

	public function init( onCreate : Bool -> Void, forceSoftware = false ) {
	}

	public function resize( width : Int, height : Int ) {
	}

	public function selectShader( shader : hxsl.RuntimeShader ) {
		return false;
	}

	public function selectMaterial( pass : h3d.mat.Pass ) {
	}

	public function selectTextureHandles( handles : Array<h3d.mat.TextureHandle> ) {
	}

	public function selectBufferHandles( handles : Array<h3d.BufferHandle> ) {
	}


	public function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
	}

	public function flushShaderBuffers() {
	}

	public function selectBuffer( buffer : Buffer ) {
	}

	public function selectMultiBuffers( format : hxd.BufferFormat.MultiFormat, buffers : Array<h3d.Buffer> ) {
	}

	public function draw( ibuf : Buffer, startIndex : Int, ntriangles : Int ) {
	}

	public function drawInstanced( ibuf : Buffer, commands : h3d.impl.InstanceBuffer ) {
	}

	public function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
	}

	public function setRenderTarget( tex : Null<h3d.mat.Texture>, layer = 0, mipLevel = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
	}

	public function setRenderTargets( textures : Array<h3d.mat.Texture>, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
	}

	public function setDepth( tex : Null<h3d.mat.Texture>, layer = 0 ) {
		if( layer != 0 )
			throw "Not implemented";
	}

	public function setDepthClamp( enabled : Bool ) {
	}

	public function setDepthBias( depthBias : Float,  slopeScaledBias : Float ) {
	}

	public function allocDepthBuffer( b : h3d.mat.Texture ) : Texture {
		return null;
	}

	public function disposeDepthBuffer( b : h3d.mat.Texture ) {
	}

	public function getDefaultDepthBuffer() : h3d.mat.Texture {
		return null;
	}

	public function present() {
	}

	public function end() {
	}

	public function setDebug( b : Bool ) {
	}

	public function allocTexture( t : h3d.mat.Texture ) : Texture {
		return null;
	}

	public function allocBuffer( b : h3d.Buffer ) : GPUBuffer {
		return null;
	}

	public function allocInstanceBuffer( b : h3d.impl.InstanceBuffer, bytes : haxe.io.Bytes ) {
	}

	public function uploadInstanceBufferBytes(b : h3d.impl.InstanceBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
	}

	public function disposeTexture( t : h3d.mat.Texture ) {
	}

	public function disposeBuffer( b : Buffer ) {
	}

	public function disposeInstanceBuffer( b : h3d.impl.InstanceBuffer ) {
	}

	public function uploadIndexData( i : Buffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
	}

	public function uploadBufferData( b : Buffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
	}

	public function uploadBufferBytes( b : Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
	}

	public function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
	}

	public function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
	}

	public function readBufferBytes( b : Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
	}

	public function readBufferBytesAsync( b : Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int, callback : Void -> Void ) {
	}

	/**
		Returns true if we could copy the texture, false otherwise (not supported by driver or mismatch in size/format)
	**/
	public function copyTexture( from : h3d.mat.Texture, to : h3d.mat.Texture ) {
		return false;
	}

	/**
		Reallocates the allocated texture so its most detailed mip level is `mip`, keeping the content
		of the mip levels common to both allocations. Returns false if not supported or out of memory,
		in which case the texture is unchanged. Requires the ResidentMips feature.
	**/
	public function setResidentMip( t : h3d.mat.Texture, mip : Int ) : Bool {
		return false;
	}

	// --- MARKING API

	public function beginEvent( name : String ) {
	}

	public function endEvent() {
	}

	// --- QUERY API

	public function allocQuery( queryKind : QueryKind ) : Query {
		return null;
	}

	public function deleteQuery( q : Query ) {
	}

	public function beginQuery( q : Query ) {
	}

	public function endQuery( q : Query ) {
	}

	public function queryResultAvailable( q : Query ) {
		return true;
	}

	public function queryResult( q : Query ) {
		return 0.;
	}

	// --- COMPUTE

	public function computeDispatch( x : Int = 1, y : Int = 1, z : Int = 1, barrier: Bool = true ) {
		throw "Compute shaders are not implemented on this platform";
	}

	public function memoryBarrier(){
		throw "Compute shaders are not implemented on this platform";
	}

	// --- Bindless

	public function getTextureHandle( t : h3d.mat.Texture ) : h3d.mat.TextureHandle {
		throw "Bindless is not implemented on this platform";
	}

	public function getBufferHandle( b : h3d.Buffer ) : h3d.BufferHandle {
		throw "Bindless is not implemented on this platform";
	}

	public function isUpscalingSupported() : Bool {
		return false;
	}

	public function isFrameGenSupported() : Bool {
		return false;
	}

	public function getUpscalerName() : String {
		return null;
	}

	public function getUpscalingSettings( mode : UpscalingMode, targetWidth : Int, targetHeight : Int ) : UpscalingSettings {
		return null;
	}

	public function applyUpscaling( resources : Map<UpscalingTag, h3d.mat.Texture>, params : UpscalingParams, mode : UpscalingMode ) {
	}

	public function setFrameGenResources( resources : Map<UpscalingTag, h3d.mat.Texture> ) {
	}

	public function clearFrameGenResources() {
	}

	public function setFrameGenParams( params : UpscalingParams ) {
	}

	public function setFrameGenMode( mode : FrameGenMode, numFramesToGenerate : Int = 1, releaseResources = false ) : Bool {
		return false;
	}

	public function getFrameGenMode() : FrameGenMode {
		return Off;
	}

	public function getFrameGenSettings() : FrameGenSettings {
		return null;
	}

	public function latencyMarkerSimulationStart() {
	}

	public function latencyMarkerSimulationEnd() {
	}

	public function latencyMarkerTriggerFlash() {
	}

	public function lowLatencySleep() {
	}

	public function setLowLatencyOptions( mode : LowLatencyMode, frameLimitUs : Int = 0 ) {
		return false;
	}

	public function lowLatencyAvailable() {
		return false;
	}

	public function lowLatencyFlashIndicatorDriverControlled() {
		return false;
	}

	public function debugUpscaling() : String {
		return "";
	}

	public function debugLowLatency() : String {
		return "";
	}

	public function debugFrameGen() : String {
		return "";
	}

	public function shutdownUpscaling() {
	}
}