package h3d.impl;

#if (hldx && !dx12)

import h3d.impl.Driver;
import dx.Driver;
import h3d.mat.Pass;

private class ShaderContext {
	public var shader : Shader;
	public var globalsSize : Int;
	public var paramsSize : Int;
	public var texturesCount : Int;
	public var bufferCount : Int;
	public var paramsContent : hl.Bytes;
	public var globals : dx.Resource;
	public var params : dx.Resource;
	public var samplersMap : Array<Int>;
	public var texturesTypes : Array<hxsl.Ast.Type>;
	#if debug
	public var debugSource : String;
	#end
	public function new(shader) {
		this.shader = shader;
	}
}

private class CompiledShader {
	public var vertex : ShaderContext;
	public var fragment : ShaderContext;
	public var format : hxd.BufferFormat;
	public var perInst : Array<Int>;
	public var layouts : Map<Int, Layout>;
	public var vertexBytes : haxe.io.Bytes;
	public var semanticNames : Array<String>;
	public function new() {
	}
}

enum PipelineKind {
	Vertex;
	Pixel;
}

class PipelineState {
	public var kind : PipelineKind;
	public var samplers = new hl.NativeArray<SamplerState>(64);
	public var samplerBits = new Array<Int>();
	public var resources = new hl.NativeArray<ShaderResourceView>(64);
	public var buffers = new hl.NativeArray<dx.Resource>(16);
	public function new(kind) {
		this.kind = kind;
		for(i in 0...64 ) samplerBits[i] = -1;
	}
}

class DirectXDriver extends h3d.impl.Driver {

	static inline var NTARGETS = 8;
	static inline var VIEWPORTS_ELTS = 6 * NTARGETS;
	static inline var RECTS_ELTS = 4 * NTARGETS;
	static inline var BLEND_FACTORS = NTARGETS;

	var driver : DriverInstance;
	var shaders : Map<Int,CompiledShader>;

	var hasDeviceError = false;

	var defaultTarget : RenderTargetView;
	var defaultDepth : Texture;
	var defaultDepthInst : h3d.mat.Texture;
	var extraDepthInst : h3d.mat.Texture;

	var viewport : hl.BytesAccess<hl.F32> = new hl.Bytes(4 * VIEWPORTS_ELTS);
	var rects : hl.BytesAccess<Int> = new hl.Bytes(4 * RECTS_ELTS);
	var box = new dx.Resource.ResourceBox();
	var strides : Array<Int> = [];
	var offsets : Array<Int> = [];
	var currentShader : CompiledShader;
	var currentIndex : h3d.Buffer;
	var currentDepth : Texture;
	var currentLayout : Layout;
	var currentTargets = new hl.NativeArray<RenderTargetView>(16);
	var currentTargetResources = new hl.NativeArray<ShaderResourceView>(16);
	var vertexShader : PipelineState;
	var pixelShader : PipelineState;
	var currentVBuffers = new hl.NativeArray<dx.Resource>(16);
	var frame : Int;
	var currentMaterialBits = -1;
	var currentStencilMaskBits = -1;
	var currentStencilOpBits = -1;
	var currentStencilRef = 0;
	var currentColorMask = -1;
	var currentColorMaskIndex = -1;
	var colorMaskIndexes : Map<Int, Int>;
	var colorMaskIndex = 1;
	var targetsCount = 1;
	var allowDraw = false;
	var maxSamplers = 16;

	var depthStates : Map<Int,{ def : DepthStencilState, stencils : Array<{ op : Int, mask : Int, state : DepthStencilState }> }>;
	var blendStates : Map<Int,BlendState>;
	var rasterStates : Map<Int,RasterState>;
	var samplerStates : Map<Int,SamplerState>;
	var currentDepthState : DepthStencilState;
	var currentBlendState : BlendState;
	var currentRasterState : RasterState;
	var blendFactors : hl.BytesAccess<hl.F32> = new hl.Bytes(4 * BLEND_FACTORS);

	var outputWidth : Int;
	var outputHeight : Int;
	var hasScissor = false;
	var shaderVersion : String;

	var window : dx.Window;
	var curTexture : h3d.mat.Texture;

	var mapCount : Int;
	var updateResCount : Int;
	var onContextLost : Void -> Void;

	public var backBufferFormat : dx.Format = R8G8B8A8_UNORM;
	public var depthStencilFormat : dx.Format = D24_UNORM_S8_UINT;

	public function new() {
		window = @:privateAccess dx.Window.windows[0];
		Driver.setErrorHandler(onDXError);
		reset();
	}

	public dynamic function getDriverFlags() : dx.Driver.DriverInitFlags {
		var options : dx.Driver.DriverInitFlags = None;
		#if debug
		options |= DebugLayer;
		#end
		return options;
	}

	function reset() {
		allowDraw = false;
		targetsCount = 1;
		currentMaterialBits = -1;
		currentStencilMaskBits = -1;
		currentStencilOpBits = -1;
		if( shaders != null ) {
			for( s in shaders ) {
				s.fragment.shader.release();
				s.vertex.shader.release();
				for( l in s.layouts )
					l.release();
				s.layouts = [];
			}
		}
		if( depthStates != null ) for( s in depthStates ) { if( s.def != null ) s.def.release(); for( s in s.stencils ) if( s.state != null ) s.state.release(); }
		if( blendStates != null ) for( s in blendStates ) if( s != null ) s.release();
		if( rasterStates != null ) for( s in rasterStates ) if( s != null ) s.release();
		if( samplerStates != null ) for( s in samplerStates ) if( s != null ) s.release();
		shaders = new Map();
		depthStates = new Map();
		blendStates = new Map();
		rasterStates = new Map();
		samplerStates = new Map();
		vertexShader = new PipelineState(Vertex);
		pixelShader = new PipelineState(Pixel);
		colorMaskIndexes = new Map();

		try
			driver = Driver.create(window, backBufferFormat, getDriverFlags())
		catch( e : Dynamic )
			throw "Failed to initialize DirectX driver (" + e + ")";

		if( driver == null ) throw "Failed to initialize DirectX driver";

		var version = Driver.getSupportedVersion();
		shaderVersion = if( version < 10 ) "3_0" else if( version < 11 ) "4_0" else "5_0";

		Driver.iaSetPrimitiveTopology(TriangleList);
		// Create a default depth buffer to mimic opengl.
		defaultDepthInst = new h3d.mat.Texture(-1, -1, Depth24Stencil8);
		defaultDepthInst.name = "defaultDepth";
		for( i in 0...VIEWPORTS_ELTS )
			viewport[i] = 0;
		for( i in 0...RECTS_ELTS )
			rects[i] = 0;
		for( i in 0...BLEND_FACTORS )
			blendFactors[i] = 0;
	}

	override function dispose() {
		Driver.disposeDriver(driver);
		driver = null;
	}

	function onDXError(code:Int,reason:Int,line:Int) {
		if( code != 0x887A0005 /*DXGI_ERROR_DEVICE_REMOVED*/ )
			throw "DXError "+StringTools.hex(code)+" line "+line;
		//if( !hasDeviceError ) trace("DX_REMOVED "+StringTools.hex(reason)+":"+line);
		hasDeviceError = true;
	}

	override function resize(width:Int, height:Int)  {
		if( defaultDepth != null ) {
			defaultDepth.depthView.release();
			defaultDepth.readOnlyDepthView.release();
			defaultDepth.view.release();
			defaultDepth.res.release();
		}
		if( defaultTarget != null ) {
			defaultTarget.release();
			defaultTarget = null;
		}

		if( !Driver.resize(width, height, backBufferFormat) )
			throw "Failed to resize backbuffer to " + width + "x" + height;

		var depthDesc = new Texture2dDesc();
		depthDesc.width = width;
		depthDesc.height = height;
		depthDesc.format = R24G8_TYPELESS;
		depthDesc.usage = Default;
		depthDesc.mipLevels = 1;
		depthDesc.arraySize = 1;
		depthDesc.sampleCount = 1;
		depthDesc.sampleQuality = 0;
		depthDesc.bind = DepthStencil | ShaderResource;
		var depth = Driver.createTexture2d(depthDesc);
		if( depth == null ) throw "Failed to create depthBuffer";
		var depthView = Driver.createDepthStencilView(depth,D24_UNORM_S8_UINT, false);
		var readOnlyDepthView = Driver.createDepthStencilView(depth, D24_UNORM_S8_UINT, true);

		var vdesc = new ShaderResourceViewDesc();
		vdesc.format = R24_UNORM_X8_TYPELESS;
		vdesc.dimension = Texture2D;
		vdesc.arraySize = 1;
		vdesc.start = 0;
		vdesc.count = -1;
		var shaderView = Driver.createShaderResourceView(depth, vdesc);

		defaultDepth = { res : depth, view : shaderView, depthView : depthView, readOnlyDepthView : readOnlyDepthView, rt : null };
		@:privateAccess {
			defaultDepthInst.t = defaultDepth;
			defaultDepthInst.width = width;
			defaultDepthInst.height = height;
		}

		var buf = Driver.getBackBuffer();
		defaultTarget = Driver.createRenderTargetView(buf);
		Driver.clearColor(defaultTarget, 0, 0, 0, 0);
		buf.release();

		outputWidth = width;
		outputHeight = height;

		setRenderTarget(null);

		if( extraDepthInst != null ) @:privateAccess {
			extraDepthInst.width = width;
			extraDepthInst.height = height;
			if( extraDepthInst.t != null ) disposeDepthBuffer(extraDepthInst);
			extraDepthInst.t = allocDepthBuffer(extraDepthInst);
		}
	}

	override function begin(frame:Int) {
		mapCount = 0;
		updateResCount = 0;
		this.frame = frame;
		setRenderTarget(null);
	}

	override function isDisposed() {
		return hasDeviceError;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		onContextLost = onCreate.bind(true);
		haxe.Timer.delay(onCreate.bind(false), 1);
	}

	override function clear(?color:h3d.Vector4, ?depth:Float, ?stencil:Int) {
		if( color != null ) {
			for( i in 0...targetsCount )
				Driver.clearColor(currentTargets[i], color.r, color.g, color.b, color.a);
			if (targetsCount == 0)
				Driver.clearColor(defaultTarget, color.r, color.g, color.b, color.a);
		}
		if( currentDepth != null && (depth != null || stencil != null) )
			Driver.clearDepthStencilView(currentDepth.depthView, depth, stencil);
	}

	override function getDriverName(details:Bool) {
		var desc = "DirectX" + Driver.getSupportedVersion();
		if( details ) desc += " " + Driver.getDeviceName();
		return desc;
	}

	public function forceDeviceError() {
		hasDeviceError = true;
	}

	override function present() {
		if( defaultTarget == null ) return;
		var old = hxd.System.allowTimeout;
		if( old ) hxd.System.allowTimeout = false;
		Driver.present(window.vsync ? 1 : 0, None);
		if( old ) hxd.System.allowTimeout = true;

		if( hasDeviceError ) {
			Sys.println("----------- OnContextLost ----------");
			hasDeviceError = false;
			dispose();
			reset();
			onContextLost();
		}

	}

	override function getDefaultDepthBuffer():h3d.mat.Texture {
		// Create an extra depth buffer to fit opengl default frame buffer.
		if( extraDepthInst == null ) @:privateAccess {
			extraDepthInst = new h3d.mat.Texture(0, 0, Depth24Stencil8);
			extraDepthInst.name = "extraDepth";
			extraDepthInst.width = outputWidth;
			extraDepthInst.height = outputHeight;
			extraDepthInst.t = allocDepthBuffer(extraDepthInst);
		}
		return extraDepthInst;
	}

	override function allocBuffer(b:Buffer):GPUBuffer {
		var size = b.getMemSize();
		var res = b.flags.has(UniformBuffer) ? dx.Driver.createBuffer(size, Dynamic, ConstantBuffer, CpuWrite, None, 0, null) :
				dx.Driver.createBuffer(size, Default, b.flags.has(IndexBuffer) ? IndexBuffer : VertexBuffer, None, None, 0, null);
		if( res == null ) return null;
		return res;
	}

	override function allocDepthBuffer( b : h3d.mat.Texture ) : Texture {
		var depthDesc = new Texture2dDesc();
		depthDesc.width = b.width;
		depthDesc.height = b.height;
		depthDesc.mipLevels = 1;
		depthDesc.arraySize = 1;
		depthDesc.format = R24G8_TYPELESS;
		depthDesc.sampleCount = 1;
		depthDesc.sampleQuality = 0;
		depthDesc.usage = Default;
		depthDesc.bind = DepthStencil | ShaderResource;
		var depth = Driver.createTexture2d(depthDesc);
		if( depth == null )
			return null;
		var vdesc = new ShaderResourceViewDesc();
		vdesc.format = R24_UNORM_X8_TYPELESS;
		vdesc.dimension = Texture2D;
		vdesc.arraySize = 1;
		vdesc.start = 0;
		vdesc.count = -1;
		var srv = Driver.createShaderResourceView(depth,vdesc);
		var depthView = Driver.createDepthStencilView(depth,D24_UNORM_S8_UINT, false);
		var readOnlyDepthView = Driver.createDepthStencilView(depth, D24_UNORM_S8_UINT, true);
		return { res : depth, view : srv, depthView : depthView, readOnlyDepthView : readOnlyDepthView, rt : null };
	}

	override function disposeDepthBuffer(b:h3d.mat.Texture) @:privateAccess {
		var d = b.t;
		b.t = null;
		d.depthView.release();
		d.readOnlyDepthView.release();
		d.view.release();
		d.res.release();
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		var rt = curTexture;
		if( rt == null )
			throw "Can't capture main render buffer in DirectX";
		captureTexPixels(pixels, rt, 0, 0);
	}

	override function isSupportedFormat( fmt : hxd.PixelFormat ) {
		return switch( fmt ) {
		case RGB8, RGB16F, ARGB, BGRA, SRGB, RGB16U: false;
		default: true;
		}
	}

	function getTextureFormat( t : h3d.mat.Texture ) : dx.Format {
		return switch( t.format ) {
		case RGBA: R8G8B8A8_UNORM;
		case RGBA16F: R16G16B16A16_FLOAT;
		case RGBA32F: R32G32B32A32_FLOAT;
		case R32F: R32_FLOAT;
		case R16F: R16_FLOAT;
		case R8: R8_UNORM;
		case RG8: R8G8_UNORM;
		case RG16F: R16G16_FLOAT;
		case RG32F: R32G32_FLOAT;
		case RGB32F: R32G32B32_FLOAT;
		case RGB10A2: R10G10B10A2_UNORM;
		case RG11B10UF: R11G11B10_FLOAT;
		case SRGB_ALPHA: R8G8B8A8_UNORM_SRGB;
		case R16U: R16_UNORM;
		case RG16U: R16G16_UNORM;
		case RGBA16U: R16G16B16A16_UNORM;
		case S3TC(n):
			switch( n ) {
			case 1: BC1_UNORM;
			case 2: BC2_UNORM;
			case 3: BC3_UNORM;
			case 4: BC4_UNORM;
			case 5: BC5_UNORM;
			case 6: BC6H_UF16;
			case 7: BC7_UNORM;
			default: throw "assert";
			}
		default: throw "Unsupported texture format " + t.format;
		}
	}

	override function allocTexture(t:h3d.mat.Texture):Texture {

		var mips = 1;
		if( t.flags.has(MipMapped) )
			mips = t.mipLevels;

		var rt = t.flags.has(Target);
		var isCube = t.flags.has(Cube);
		var isArray = t.flags.has(IsArray);

		var desc = new Texture2dDesc();
		desc.width = t.width;
		desc.height = t.height;
		desc.format = getTextureFormat(t);

		if( t.format.match(S3TC(_)) && (t.width & 3 != 0 || t.height & 3 != 0) )
			throw t+" is compressed "+t.width+"x"+t.height+" but should be a 4x4 multiple";

		desc.usage = Default;
		desc.bind = ShaderResource;
		desc.mipLevels = mips;
		if( rt )
			desc.bind |= RenderTarget;
		if( isCube ) {
			desc.arraySize = 6;
			desc.misc |= TextureCube;
		}
		if( isArray )
			desc.arraySize = t.layerCount;
		if( t.flags.has(MipMapped) && !t.flags.has(ManualMipMapGen) ) {
			if( t.format.match(S3TC(_)) )
				throw "Cannot generate mipmaps for compressed texture "+t;
			desc.bind |= RenderTarget;
			desc.misc |= GenerateMips;
		}
		var tex = Driver.createTexture2d(desc);
		if( tex == null )
			return null;

		t.lastFrame = frame;
		t.flags.unset(WasCleared);

		return { res : tex, view : makeTexView(t, tex, 0), rt : rt ? [] : null };
	}

	function makeTexView( t : h3d.mat.Texture, tex, startMip ) {
		var isCube = t.flags.has(Cube);
		var isArray = t.flags.has(IsArray);
		var vdesc = new ShaderResourceViewDesc();
		vdesc.format = getTextureFormat(t);
		vdesc.dimension = isCube ? TextureCube : isArray ? Texture2DArray : Texture2D;
		vdesc.arraySize = isArray ? t.layerCount : isCube ? 6 : 0;
		vdesc.start = startMip; // top mip level
		vdesc.count = -1; // all mip levels
		return Driver.createShaderResourceView(tex, vdesc);
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		var tt = t.t;
		if( tt == null ) return;
		t.t = null;
		if( tt.view != null ) tt.view.release();
		if( tt.res != null ) tt.res.release();
		if( tt.views != null )
			for( v in tt.views )
				if( v != null )
					v.release();
		if( tt.rt != null )
			for( rt in tt.rt )
				if( rt != null )
					rt.release();
	}

	override function disposeBuffer(b:Buffer) {
		b.vbuf.release();
	}

	override function generateMipMaps(texture:h3d.mat.Texture) {
		if( hasDeviceError ) return;
		Driver.generateMips(texture.t.view);
	}

	function updateBuffer( res : dx.Resource, bytes : hl.Bytes, startByte : Int, bytesCount : Int ) {
		box.left = startByte;
		box.top = 0;
		box.front = 0;
		box.right = startByte + bytesCount;
		box.bottom = 1;
		box.back = 1;
		res.updateSubresource(0, box, bytes, 0, 0);
		updateResCount++;
	}

	override function uploadIndexData(i:Buffer, startIndice:Int, indiceCount:Int, buf:hxd.IndexBuffer, bufPos:Int) {
		if( hasDeviceError ) return;
		var bits = i.format.strideBytes >> 1;
		updateBuffer(i.vbuf, hl.Bytes.getArray(buf.getNative()).offset(bufPos << bits), startIndice << bits, indiceCount << bits);
	}

	override function uploadBufferData(b:Buffer, startVertex:Int, vertexCount:Int, buf:hxd.FloatBuffer, bufPos:Int) {
		if( hasDeviceError ) return;
		var data = hl.Bytes.getArray(buf.getNative()).offset(bufPos<<2);
		if( b.flags.has(UniformBuffer) ) {
			if( startVertex != 0 ) throw "assert";
			var ptr = b.vbuf.map(0, WriteDiscard, true, null);
			if( ptr == null ) throw "Can't map buffer";
			ptr.blit(0, data, 0, vertexCount * b.format.strideBytes);
			b.vbuf.unmap(0);
			return;
		}
		updateBuffer(b.vbuf, data, startVertex * b.format.strideBytes, vertexCount * b.format.strideBytes);
	}

	override function uploadBufferBytes(b:Buffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		if( hasDeviceError ) return;
		if( b.flags.has(UniformBuffer) ) {
			if( startVertex != 0 ) throw "assert";
			var ptr = b.vbuf.map(0, WriteDiscard, true, null);
			if( ptr == null ) throw "Can't map buffer";
			ptr.blit(0, buf, 0, vertexCount * b.format.strideBytes);
			b.vbuf.unmap(0);
			return;
		}
		updateBuffer(b.vbuf, @:privateAccess buf.b.offset(bufPos), startVertex * b.format.strideBytes, vertexCount * b.format.strideBytes);
	}

	override function readBufferBytes(b:Buffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		var stride = b.format.strideBytes;
		var tmp = dx.Driver.createBuffer(vertexCount * stride, Staging, None, CpuRead | CpuWrite, None, 0, null);
		box.left = startVertex * stride;
		box.top = 0;
		box.front = 0;
		box.right = (startVertex + vertexCount) * stride;
		box.bottom = 1;
		box.back = 1;
		tmp.copySubresourceRegion(0, 0, 0, 0, b.vbuf, 0, box);
		var ptr = tmp.map(0, Read, true, null);
		@:privateAccess buf.b.blit(bufPos, ptr, 0, vertexCount * stride);
		tmp.unmap(0);
		tmp.release();
	}

	override function capturePixels(tex:h3d.mat.Texture, layer:Int, mipLevel:Int, ?region:h2d.col.IBounds) : hxd.Pixels {
		var pixels : hxd.Pixels;
		if (region != null) {
			if (region.xMax > tex.width) region.xMax = tex.width;
			if (region.yMax > tex.height) region.yMax = tex.height;
			if (region.xMin < 0) region.xMin = 0;
			if (region.yMin < 0) region.yMin = 0;
			var w = region.width >> mipLevel;
			var h = region.height >> mipLevel;
			if( w == 0 ) w = 1;
			if( h == 0 ) h = 1;
			pixels = hxd.Pixels.alloc(w, h, tex.format);
			captureTexPixels(pixels, tex, layer, mipLevel, region.xMin, region.yMin);
		} else {
			var w = tex.width >> mipLevel;
			var h = tex.height >> mipLevel;
			if( w == 0 ) w = 1;
			if( h == 0 ) h = 1;
			pixels = hxd.Pixels.alloc(w, h, tex.format);
			captureTexPixels(pixels, tex, layer, mipLevel);
		}
		return pixels;
	}

	function captureTexPixels( pixels: hxd.Pixels, tex:h3d.mat.Texture, layer:Int, mipLevel:Int, x : Int = 0, y : Int = 0)  {

		if( pixels.width == 0 || pixels.height == 0 )
			return pixels;

		var desc = new Texture2dDesc();
		desc.width = pixels.width;
		desc.height = pixels.height;
		desc.access = CpuRead | CpuWrite;
		desc.usage = Staging;
		desc.format = getTextureFormat(tex);

		if( hasDeviceError ) throw "Can't capture if device disposed";

		var tmp = dx.Driver.createTexture2d(desc);
		if( tmp == null )
			throw "Capture failed: can't create tmp texture";

		if (x != 0 || y != 0) {
			box.left = x;
			box.right = x + desc.width;
			box.top = y;
			box.bottom = y + desc.height;
			box.back = 1;
			box.front = 0;
			tmp.copySubresourceRegion(0,0,0,0,tex.t.res,tex.mipLevels * layer + mipLevel, box);
		} else {
			tmp.copySubresourceRegion(0,0,0,0,tex.t.res,tex.mipLevels * layer + mipLevel, null);
		}

		var pitch = 0;
		var stride = hxd.Pixels.calcStride(desc.width, tex.format);
		var ptr = tmp.map(0, Read, true, pitch);

		if( hasDeviceError ) throw "Device was disposed during capturePixels";

		if( pitch == stride )
			@:privateAccess pixels.bytes.b.blit(0, ptr, 0, desc.height * stride);
		else {
			for( i in 0...desc.height )
				@:privateAccess pixels.bytes.b.blit(i * stride, ptr, i * pitch, stride);
		}
		tmp.unmap(0);
		tmp.release();
		return pixels;
	}

	override function uploadTextureBitmap(t:h3d.mat.Texture, bmp:hxd.BitmapData, mipLevel:Int, side:Int) {
		if( hasDeviceError ) return;
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	}

	override function uploadTexturePixels(t:h3d.mat.Texture, pixels:hxd.Pixels, mipLevel:Int, side:Int) {
		pixels.convert(t.format);
		if( hasDeviceError ) return;
		var mipLevels = t.mipLevels;
		if( mipLevel >= mipLevels ) throw "Mip level outside texture range : " + mipLevel + " (max = " + (mipLevels - 1) + ")";
		var stride = @:privateAccess pixels.stride;
		switch( t.format ) {
		case S3TC(n): stride = pixels.width * ((n == 1 || n == 4) ? 2 : 4); // "uncompressed" stride ?
		default:
		}
		t.t.res.updateSubresource(mipLevel + side * mipLevels, null, (pixels.bytes:hl.Bytes).offset(pixels.offset), stride, 0);
		updateResCount++;
		t.flags.set(WasCleared);
	}

	static inline var SCISSOR_BIT = Pass.reserved_mask;

	override public function selectMaterial(pass:h3d.mat.Pass) {
		var bits = @:privateAccess pass.bits;
		var mask = pass.colorMask;

		if( hasScissor ) bits |= SCISSOR_BIT;

		var stOpBits = pass.stencil != null ? @:privateAccess pass.stencil.opBits : -1;
		var stMaskBits = pass.stencil != null ? @:privateAccess pass.stencil.maskBits : -1;

		if( bits == currentMaterialBits && stOpBits == currentStencilOpBits && stMaskBits == currentStencilMaskBits && mask == currentColorMask )
			return;

		currentMaterialBits = bits;
		currentStencilOpBits = stOpBits;
		currentStencilMaskBits = stMaskBits;

		var depthBits = bits & (Pass.depthWrite_mask | Pass.depthTest_mask);
		var depths = depthStates.get(depthBits);
		var depth = null;
		var st = pass.stencil;
		if( depths != null ) {
			if( st == null )
				depth = depths.def;
			else {
				for( s in depths.stencils )
					@:privateAccess if( s.op == st.opBits && s.mask == (st.maskBits & ~h3d.mat.Stencil.reference_mask) ) {
						depth = s.state;
						break;
					}
			}
		}
		if( depth == null ) {
			var cmp = Pass.getDepthTest(bits);
			var desc = new DepthStencilDesc();
			desc.depthEnable = cmp != 0;
			desc.depthFunc = COMPARE[cmp];
			desc.depthWrite = Pass.getDepthWrite(bits) != 0;
			if( st != null ) {
				desc.stencilEnable = true;
				desc.stencilReadMask = st.readMask;
				desc.stencilWriteMask = st.writeMask;
				desc.frontFaceFunc = COMPARE[st.frontTest.getIndex()];
				desc.frontFacePass = STENCIL_OP[st.frontPass.getIndex()];
				desc.frontFaceFail = STENCIL_OP[st.frontSTfail.getIndex()];
				desc.frontFaceDepthFail = STENCIL_OP[st.frontDPfail.getIndex()];
				desc.backFaceFunc = COMPARE[st.backTest.getIndex()];
				desc.backFacePass = STENCIL_OP[st.backPass.getIndex()];
				desc.backFaceFail = STENCIL_OP[st.backSTfail.getIndex()];
				desc.backFaceDepthFail = STENCIL_OP[st.backDPfail.getIndex()];
			}
			depth = Driver.createDepthStencilState(desc);
			if( depths == null ) {
				depths = { def : null, stencils : [] };
				depthStates.set(depthBits, depths);
			}
			if( pass.stencil == null )
				depths.def = depth;
			else
				depths.stencils.push(@:privateAccess { op : st.opBits, mask : st.maskBits & ~h3d.mat.Stencil.reference_mask, state : depth });
		}
		if( depth != currentDepthState || (st != null && st.reference != currentStencilRef) ) {
			var ref = st == null ? 0 : st.reference;
			currentDepthState = depth;
			currentStencilRef = ref;
			Driver.omSetDepthStencilState(depth, ref);
		}

		var rasterBits = bits & (Pass.culling_mask | SCISSOR_BIT | Pass.wireframe_mask);
		var raster = rasterStates.get(rasterBits);
		if( raster == null ) {
			var desc = new RasterizerDesc();
			if ( pass.wireframe ) {
				desc.fillMode = WireFrame;
				desc.cullMode = None;
			} else {
				desc.fillMode = Solid;
				desc.cullMode = CULL[Pass.getCulling(bits)];
			}
			desc.depthClipEnable = true;
			desc.scissorEnable = bits & SCISSOR_BIT != 0;
			raster = Driver.createRasterizerState(desc);
			rasterStates.set(rasterBits, raster);
		}

		allowDraw = pass.culling != Both;

		if( raster != currentRasterState ) {
			currentRasterState = raster;
			Driver.rsSetState(raster);
		}

		var bitsMask = Pass.blendSrc_mask | Pass.blendDst_mask | Pass.blendAlphaSrc_mask | Pass.blendAlphaDst_mask | Pass.blendOp_mask | Pass.blendAlphaOp_mask;
		if ( currentColorMask != mask ) {
			currentColorMaskIndex = colorMaskIndexes.get(mask);
			if ( currentColorMaskIndex == 0 ) {
				if ( bitsMask & colorMaskIndex != 0 )
					throw "Too many color mask configurations";
				currentColorMaskIndex = colorMaskIndex++;
				colorMaskIndexes.set(mask, currentColorMaskIndex);
			}
		}
		currentColorMask = mask;

		var blendBits = (bits & bitsMask) | currentColorMaskIndex;
		var blend = blendStates.get(blendBits);
		if( blend == null ) {
			var desc = new RenderTargetBlendDesc();
			desc.srcBlend = BLEND[Pass.getBlendSrc(bits)];
			desc.destBlend = BLEND[Pass.getBlendDst(bits)];
			desc.srcBlendAlpha = BLEND_ALPHA[Pass.getBlendAlphaSrc(bits)];
			desc.destBlendAlpha = BLEND_ALPHA[Pass.getBlendAlphaDst(bits)];
			desc.blendOp = BLEND_OP[Pass.getBlendOp(bits)];
			desc.blendOpAlpha = BLEND_OP[Pass.getBlendAlphaOp(bits)];
			desc.renderTargetWriteMask = mask & 15;
			desc.blendEnable = !(desc.srcBlend == One && desc.srcBlendAlpha == One && desc.destBlend == Zero && desc.destBlendAlpha == Zero && desc.blendOp == Add && desc.blendOpAlpha == Add);
			var maski = mask >> 4;
			if ( maski > 0 ) {
				var tmp = new hl.NativeArray(targetsCount);
				tmp[0] = desc;
				for ( i in 1...targetsCount ) {
					if ( maski & 15 > 0 ) {
						var desci = new RenderTargetBlendDesc();
						desci.srcBlend = desc.srcBlend;
						desci.destBlend = desc.destBlend;
						desci.srcBlendAlpha = desc.srcBlendAlpha;
						desci.destBlendAlpha = desc.destBlendAlpha;
						desci.blendOp = desc.blendOp;
						desci.blendOpAlpha = desc.blendOpAlpha;
						desci.renderTargetWriteMask = maski & 15;
						desci.blendEnable = desc.blendEnable;
						tmp[i] = desci;
					} else {
						tmp[i] = desc;
					}
					maski = maski >> 4;
				}
				blend = Driver.createBlendState(false, true, tmp, targetsCount);
			} else {
				var tmp = new hl.NativeArray(1);
				tmp[0] = desc;
				blend = Driver.createBlendState(false, false, tmp, 1);
			}
			blendStates.set(blendBits, blend);
		}
		if( blend != currentBlendState ) {
			currentBlendState = blend;
			Driver.omSetBlendState(blend, blendFactors, -1);
		}
	}

	function getBinaryPayload( vertex : Bool, code : String ) {
		var bin = code.indexOf("//BIN=");
		if( bin >= 0 ) {
			var end = code.indexOf("#", bin);
			if( end >= 0 )
				return haxe.crypto.Base64.decode(code.substr(bin + 6, end - bin - 6));
		}
		if( shaderCache != null ) {
			var bytes = shaderCache.resolveShaderBinary(code, shaderVersion);
			if( bytes != null ) {
				try {
					var sh = vertex ? Driver.createVertexShader(bytes) : Driver.createPixelShader(bytes);
					// shader can't be compiled !
					if( sh == null )
						return null;
				}
				catch( d : Dynamic)
					return null;
				return bytes;
			}
		}
		return null;
	}

	function addBinaryPayload( bytes ) {
		return "\n//BIN=" + haxe.crypto.Base64.encode(bytes) + "#\n";
	}

	function compileShader( shader : hxsl.RuntimeShader.RuntimeShaderData, compileOnly = false ) {
		var h = new hxsl.HlslOut();
		if( shader.code == null ){
			shader.code = h.run(shader.data);
			#if !heaps_compact_mem
			shader.data.funs = null;
			#end
		}
		var bytes = getBinaryPayload(shader.kind == Vertex, shader.code);
		if( bytes == null ) {
			bytes = try dx.Driver.compileShader(shader.code, "", "main", (shader.kind==Vertex?"vs_":"ps_") + shaderVersion, OptimizationLevel3) catch( err : String ) {
				err = ~/^\(([0-9]+),([0-9]+)-([0-9]+)\)/gm.map(err, function(r) {
					var line = Std.parseInt(r.matched(1));
					var char = Std.parseInt(r.matched(2));
					var end = Std.parseInt(r.matched(3));
					return "\n<< " + shader.code.split("\n")[line - 1].substr(char-1,end - char + 1) +" >>";
				});
				throw "Shader compilation error " + err + "\n\nin\n\n" + shader.code;
			}
			if( shaderCache == null )
				shader.code += addBinaryPayload(bytes);
		}
		if( compileOnly )
			return { s : null, bytes : bytes };
		var s = shader.kind == Vertex ? Driver.createVertexShader(bytes) : Driver.createPixelShader(bytes);
		if( s == null ) {
			if( hasDeviceError ) return null;
			throw "Failed to create shader\n" + shader.code;
		}

		if( shaderCache != null )
			shaderCache.saveCompiledShader(shader.code, bytes, shaderVersion);

		var ctx = new ShaderContext(s);
		ctx.globalsSize = shader.globalsSize;
		ctx.paramsSize = shader.paramsSize;
		ctx.paramsContent = new hl.Bytes(shader.paramsSize * 16);
		ctx.paramsContent.fill(0, shader.paramsSize * 16, 0xDD);
		ctx.texturesCount = shader.texturesCount;
		ctx.texturesTypes = [];

		var p = shader.textures;
		while( p != null ) {
			switch( p.type ) {
			case TArray( t = TSampler(_) | TRWTexture(_) | TChannel(_), SConst(n) ):
				for( i in 0...n )
					ctx.texturesTypes.push(t);
			case TSampler(_), TRWTexture(_), TChannel(_):
				ctx.texturesTypes.push(p.type);
			default:
			}
			p = p.next;
		}
		ctx.bufferCount = shader.bufferCount;
		ctx.globals = dx.Driver.createBuffer(shader.globalsSize * 16, Dynamic, ConstantBuffer, CpuWrite, None, 0, null);
		ctx.params = dx.Driver.createBuffer(shader.paramsSize * 16, Dynamic, ConstantBuffer, CpuWrite, None, 0, null);
		ctx.samplersMap = [];

		var samplers = new hxsl.HlslOut.Samplers();
		for( v in shader.data.vars )
			samplers.make(v, ctx.samplersMap);

		#if debug
		ctx.debugSource = shader.code;
		#end
		return { s : ctx, bytes : bytes };
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		function dumpShader(s:hxsl.RuntimeShader.RuntimeShaderData) {
			var code = new hxsl.HlslOut().run(s.data);
			try {
				var scomp = compileShader(s, true).bytes;
				code += "\n// ASM=\n" + Driver.disassembleShader(scomp, None, null) + "\n\n";
			} catch( e : Dynamic ) {
			}
			return code;
		}
		return dumpShader(shader.vertex)+"\n\n"+dumpShader(shader.fragment);
	}

	override function hasFeature(f:Feature) {
		return switch(f) {
		case Queries, BottomLeftCoords:
			false;
		default:
			true;
		};
	}

	override function copyTexture(from:h3d.mat.Texture, to:h3d.mat.Texture) {
		if( from.t == null || from.format != to.format || from.width != to.width || from.height != to.height || from.layerCount != to.layerCount )
			return false;
		if( to.t == null ) {
			var prev = from.lastFrame;
			from.preventAutoDispose();
			to.alloc();
			from.lastFrame = prev;
			if( from.t == null ) throw "assert";
			if( to.t == null ) return false;
		}
		to.t.res.copyResource(from.t.res);
		to.flags.set(WasCleared);
		return true;
	}

	var tmpTextures = new Array<h3d.mat.Texture>();
	override function setRenderTarget(tex:Null<h3d.mat.Texture>, layer = 0, mipLevel = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite) {
		if( tex == null ) {
			curTexture = null;
			currentDepth = defaultDepth;
			currentTargets[0] = defaultTarget;
			currentTargetResources[0] = null;
			targetsCount = 1;
			var depthView = switch (depthBinding) {
			case NotBound:
				null;
			case ReadOnly:
				currentDepth.readOnlyDepthView;
			default:
				currentDepth.depthView;
			}
			Driver.omSetRenderTargets(1, currentTargets, depthView);
			viewport[2] = outputWidth;
			viewport[3] = outputHeight;
			viewport[5] = 1.;
			Driver.rsSetViewports(1, viewport);
			return;
		}
		tmpTextures[0] = tex;
		_setRenderTargets(tmpTextures, layer, mipLevel, depthBinding);
	}

	function unbind( res ) {
		for( i in 0...64 ) {
			if( vertexShader.resources[i] == res ) {
				vertexShader.resources[i] = null;
				Driver.vsSetShaderResources(i, 1, vertexShader.resources.getRef().offset(i));
			}
			if( pixelShader.resources[i] == res ) {
				pixelShader.resources[i] = null;
				Driver.psSetShaderResources(i, 1, pixelShader.resources.getRef().offset(i));
			}
		}
	}

	override function setRenderTargets(textures:Array<h3d.mat.Texture>, depthBinding : h3d.Engine.DepthBinding = ReadWrite) {
		_setRenderTargets(textures, 0, 0, depthBinding);
	}

	function _setRenderTargets( textures:Array<h3d.mat.Texture>, layer : Int, mipLevel : Int, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		if( textures.length == 0 ) {
			setRenderTarget(null, depthBinding);
			return;
		}
		if( hasDeviceError )
			return;
		var tex = textures[0];
		curTexture = textures[0];
		if( tex.depthBuffer != null && (tex.depthBuffer.width != tex.width || tex.depthBuffer.height != tex.height) )
			throw "Invalid depth buffer size : does not match render target size";
		currentDepth = @:privateAccess (tex.depthBuffer == null ? null : tex.depthBuffer.t);
		for( i in 0...textures.length ) {
			var tex = textures[i];
			if( tex.t == null ) {
				tex.alloc();
				if( hasDeviceError ) return;
			}
			if( tex.t.rt == null )
				throw "Can't render to texture which is not allocated with Target flag";
			var index = mipLevel * tex.layerCount + layer;
			var rt = tex.t.rt[index];
			if( rt == null ) {
				var arr = tex.flags.has(Cube) || tex.flags.has(IsArray);
				var v = new dx.Driver.RenderTargetDesc(getTextureFormat(tex), arr ? Texture2DArray : Texture2D);
				v.mipMap = mipLevel;
				v.firstSlice = layer;
				v.sliceCount = 1;
				rt = Driver.createRenderTargetView(tex.t.res, v);
				tex.t.rt[index] = rt;
			}
			tex.lastFrame = frame;
			currentTargets[i] = rt;
			currentTargetResources[i] = tex.t.view;
			unbind(tex.t.view);
			// prevent garbage
			if( !tex.flags.has(WasCleared) ) {
				tex.flags.set(WasCleared);
				Driver.clearColor(rt, 0, 0, 0, 0);
			}
		}
		var depthView = if ( currentDepth == null )
			null;
		else {
			switch ( depthBinding ) {
			case NotBound:
				null;
			case ReadOnly:
				currentDepth.readOnlyDepthView;
			default:
				currentDepth.depthView;
			}
		}
		Driver.omSetRenderTargets(textures.length, currentTargets, depthView);
		targetsCount = textures.length;

		var w = tex.width >> mipLevel; if( w == 0 ) w = 1;
		var h = tex.height >> mipLevel; if( h == 0 ) h = 1;
		viewport[2] = w;
		viewport[3] = h;
		viewport[5] = 1.;
		Driver.rsSetViewports(1, viewport);
	}

	override function setDepth( depthBuffer : h3d.mat.Texture ) {
		if( hasDeviceError )
			return;
		currentDepth = @:privateAccess (depthBuffer == null ? null : depthBuffer.t);
		depthBuffer.lastFrame = frame;
		unbind(currentDepth.view);
		Driver.omSetRenderTargets(0, null, currentDepth.depthView);
		targetsCount = 0;

		var w = depthBuffer.width; if( w == 0 ) w = 1;
		var h = depthBuffer.height; if( h == 0 ) h = 1;
		viewport[2] = w;
		viewport[3] = h;
		viewport[5] = 1.;
		Driver.rsSetViewports(1, viewport);
	}

	override function setRenderZone(x:Int, y:Int, width:Int, height:Int) {
		if( x == 0 && y == 0 && width < 0 && height < 0 ) {
			hasScissor = false;
			return;
		}
		if( x < 0 ) {
			width += x;
			x = 0;
		}
		if( y < 0 ) {
			height += y;
			y = 0;
		}
		if( width < 0 ) width = 0;
		if( height < 0 ) height = 0;
		hasScissor = true;
		rects[0] = x;
		rects[1] = y;
		rects[2] = x + width;
		rects[3] = y + height;
		Driver.rsSetScissorRects(1, rects);
	}

	override function selectShader(shader:hxsl.RuntimeShader) {
		var s = shaders.get(shader.id);
		if( s == null ) {
			s = new CompiledShader();
			var vertex = compileShader(shader.vertex);
			var fragment = compileShader(shader.fragment);
			if( hasDeviceError ) return false;
			s.vertex = vertex.s;
			s.fragment = fragment.s;
			s.vertexBytes = vertex.bytes;
			s.perInst = [];
			s.layouts = new Map();
			var format : Array<hxd.BufferFormat.BufferInput> = [];
			var allNames = new Map();
			var varNames = new Map();
			var semanticNames = [];
			for( v in shader.vertex.data.vars )
				if( v.kind == Input ) {
					var perInst = 0;
					if( v.qualifiers != null )
						for( q in v.qualifiers )
							switch( q ) {
							case PerInstance(k): perInst = k;
							default:
							}
					s.perInst.push(perInst);
					var t = hxd.BufferFormat.InputFormat.fromHXSL(v.type);
					semanticNames.push(hxsl.HlslOut.semanticName(hxsl.HlslOut.varName(v, varNames, allNames)));
					format.push({ name : v.name, type : t });
				}
			s.format = hxd.BufferFormat.make(format);
			s.semanticNames = semanticNames;
			shaders.set(shader.id, s);
		}
		if( s == currentShader )
			return false;
		setShader(s);
		return true;
	}

	function setShader( s : CompiledShader ) {
		currentShader = s;
		dx.Driver.vsSetShader(s.vertex.shader);
		dx.Driver.psSetShader(s.fragment.shader);
		currentLayout = null;
	}

	function makeLayout( mapping : Array<hxd.BufferFormat.BufferMapping> ) {
		var layout = new hl.NativeArray(mapping.length);
		for( index => input in @:privateAccess currentShader.format.inputs ) {
			var inf = mapping[index];
			var e = new LayoutElement();
			var name = currentShader.semanticNames[index];
			e.semanticName = @:privateAccess name.toUtf8();
			e.inputSlot = index;
			e.format = switch( [input.type, inf.precision] ) {
			case [DFloat, F32]: R32_FLOAT;
			case [DFloat, F16]: R16_FLOAT;
			case [DVec2, F32]: R32G32_FLOAT;
			case [DVec2, F16]: R16G16_FLOAT;
			case [DVec3, F32]: R32G32B32_FLOAT;
			case [DVec4, F32]: R32G32B32A32_FLOAT;
			case [DVec3|DVec4, S8]: R8G8B8A8_SNORM;
			case [DVec3|DVec4, U8]: R8G8B8A8_UNORM;
			case [DVec3|DVec4, F16]: R16G16B16A16_FLOAT;
			case [DBytes4, F32]: R8G8B8A8_UINT;
			default:
				throw "Unsupported input type " + input.type+"."+inf.precision;
			};
			var perInst = currentShader.perInst[index];
			if( perInst > 0 ) {
				e.inputSlotClass = PerInstanceData;
				e.instanceDataStepRate = perInst;
			} else
				e.inputSlotClass = PerVertexData;
			layout[index] = e;
		}
		var l = Driver.createInputLayout(layout, currentShader.vertexBytes, currentShader.vertexBytes.length);
		if( l == null )
			throw "Failed to create input layout";
		return l;
	}

	override function selectBuffer(buffer:Buffer) {
		if( hasDeviceError ) return;
		// select layout
		var layout = currentShader.layouts.get(buffer.format.uid);
		if( layout == null ) {
			layout = makeLayout(buffer.format.resolveMapping(currentShader.format));
			currentShader.layouts.set(buffer.format.uid, layout);
		}
		if( layout != currentLayout ) {
			dx.Driver.iaSetInputLayout(layout);
			currentLayout = layout;
		}
		var map = buffer.format.resolveMapping(currentShader.format);
		var vbuf = buffer.vbuf;
		var start = -1, max = -1;
		var stride = buffer.format.strideBytes;
		for( i in 0...map.length ) {
			var inf = map[i];
			if( currentVBuffers[i] != vbuf || offsets[i] != inf.offset || strides[i] != stride ) {
				currentVBuffers[i] = vbuf;
				strides[i] = stride;
				offsets[i] = inf.offset;
				if( start < 0 ) start = i;
				max = i;
			}
		}
		if( max >= 0 )
			Driver.iaSetVertexBuffers(start, max - start + 1, currentVBuffers.getRef().offset(start), hl.Bytes.getArray(strides).offset(start << 2), hl.Bytes.getArray(offsets).offset(start << 2));
	}

	override function selectMultiBuffers(formats:hxd.BufferFormat.MultiFormat,buffers:Array<Buffer>) {
		if( hasDeviceError ) return;
		var layout = currentShader.layouts.get(-formats.uid-1);
		if( layout == null ) {
			layout = makeLayout(formats.resolveMapping(currentShader.format));
			currentShader.layouts.set(-formats.uid-1, layout);
		}
		if( layout != currentLayout ) {
			dx.Driver.iaSetInputLayout(layout);
			currentLayout = layout;
		}
		var map = formats.resolveMapping(currentShader.format);
		var start = -1, max = -1, force = false;
		for( i in 0...map.length ) {
			var inf = map[i];
			var buf = buffers[inf.bufferIndex];
			if( currentVBuffers[i] != buf.vbuf || offsets[i] != inf.offset || strides[i] != buf.format.strideBytes ) {
				currentVBuffers[i] = buf.vbuf;
				strides[i] = buf.format.strideBytes;
				offsets[i] = inf.offset;
				if( start < 0 ) start = i;
				max = i;
			}
		}
		if( max >= 0 )
			Driver.iaSetVertexBuffers(start, max - start + 1, currentVBuffers.getRef().offset(start), hl.Bytes.getArray(strides).offset(start << 2), hl.Bytes.getArray(offsets).offset(start << 2));
	}

	override function uploadShaderBuffers(buffers:h3d.shader.Buffers, which:h3d.shader.Buffers.BufferKind) {
		if( hasDeviceError ) return;
		uploadBuffers(buffers, vertexShader, currentShader.vertex, buffers.vertex, which);
		uploadBuffers(buffers, pixelShader, currentShader.fragment, buffers.fragment, which);
	}

	function uploadShaderBuffer( sbuffer : dx.Resource, buffer : haxe.ds.Vector<hxd.impl.Float32>, size : Int, prevContent : hl.Bytes ) {
		if( size == 0 ) return;
		var data = hl.Bytes.getArray(buffer.toData());
		var bytes = size << 4;
		if( prevContent != null ) {
			if( prevContent.compare(0, data, 0, bytes) == 0 )
				return;
			prevContent.blit(0, data, 0, bytes);
			mapCount++;
		}
		var ptr = sbuffer.map(0, WriteDiscard, true, null);
		if( ptr == null ) throw "Can't map buffer " + sbuffer;
		ptr.blit(0, data, 0, bytes);
		sbuffer.unmap(0);
	}

	function uploadBuffers( buf : h3d.shader.Buffers, state : PipelineState, shader : ShaderContext, buffers : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Globals:
			if( shader.globalsSize > 0 ) {
				uploadShaderBuffer(shader.globals, buffers.globals, shader.globalsSize, null);
				if( state.buffers[0] != shader.globals ) {
					state.buffers[0] = shader.globals;
					switch( state.kind ) {
					case Vertex:
						Driver.vsSetConstantBuffers(0, 1, state.buffers);
					case Pixel:
						Driver.psSetConstantBuffers(0, 1, state.buffers);
					}
				}
			}
		case Params:
			if( shader.paramsSize > 0 ) {
				uploadShaderBuffer(shader.params, buffers.params, shader.paramsSize, shader.paramsContent);
				if( state.buffers[1] != shader.params ) {
					state.buffers[1] = shader.params;
					switch( state.kind ) {
					case Vertex:
						Driver.vsSetConstantBuffers(1, 1, state.buffers.getRef().offset(1));
					case Pixel:
						Driver.psSetConstantBuffers(1, 1, state.buffers.getRef().offset(1));
					}
				}
			}
		case Buffers:
			var first = -1;
			var max = -1;
			for( i in 0...shader.bufferCount ) {
				var buf = buffers.buffers[i].vbuf;
				var tid = i + 2;
				if( buf != state.buffers[tid] ) {
					state.buffers[tid] = buf;
					if( first < 0 ) first = tid;
					max = tid;
				}
			}
			if( max >= 0 )
				switch( state.kind ) {
				case Vertex:
					Driver.vsSetConstantBuffers(first,max-first+1,state.buffers.getRef().offset(first));
				case Pixel:
					Driver.psSetConstantBuffers(first,max-first+1,state.buffers.getRef().offset(first));
				}
		case Textures:
			var start = -1, max = -1;
			var sstart = -1, smax = -1;
			for( i in 0...shader.texturesCount ) {
				var t = buffers.tex[i];
				var tt = shader.texturesTypes[i];
				if( t == null || t.isDisposed() ) {
					switch( tt ) {
					case TSampler(T2D,_):
						var color = h3d.mat.Defaults.loadingTextureColor;
						t = h3d.mat.Texture.fromColor(color, (color >>> 24) / 255);
					case TSampler(TCube,_):
						t = h3d.mat.Texture.defaultCubeTexture();
					default:
						throw "Missing texture";
					}
				}
				if( t != null && t.t == null && t.realloc != null ) {
					var s = currentShader;
					t.alloc();
					t.realloc();
					if( hasDeviceError ) return;
					if( s != currentShader ) {
						// realloc triggered a shader change !
						// we need to reset the original shader and reupload everything
						setShader(s);
						uploadShaderBuffers(buf,Globals);
						uploadShaderBuffers(buf,Params);
						uploadShaderBuffers(buf,Textures);
						return;
					}
				}
				t.lastFrame = frame;

				var view = t.t.view;
				if( t.startingMip > 0 ) {
					if( t.t.views == null ) t.t.views = [];
					view = t.t.views[t.startingMip];
					if( view == null ) {
						view = makeTexView(t, t.t.res, t.startingMip);
						t.t.views[t.startingMip] = view;
					}
				}
				if( view != state.resources[i] || t.t.depthView != null ) {
					state.resources[i] = view;
					max = i;
					if( start < 0 ) start = i;
				}

				var sidx = shader.samplersMap[i];
				var samplerBits = @:privateAccess t.bits & ~h3d.mat.Texture.startingMip_mask;
				if( sidx < maxSamplers && samplerBits != state.samplerBits[sidx] ) {
					var ss = samplerStates.get(samplerBits);
					if( ss == null ) {
						var desc = new SamplerDesc();
						desc.filter = FILTER[t.mipMap.getIndex()][t.filter.getIndex()];
						desc.addressU = desc.addressV = desc.addressW = WRAP[t.wrap.getIndex()];
						// if mipMap = None && hasMipmaps : don't set per-sampler maxLod !
						// only the first sampler maxLod seems to be taken into account :'(
						desc.minLod = 0;
						desc.maxLod = 1e30;
						desc.mipLodBias = t.lodBias;
						ss = Driver.createSamplerState(desc);
						samplerStates.set(samplerBits, ss);
					}
					state.samplerBits[sidx] = samplerBits;
					state.samplers[sidx] = ss;
					if( sidx > smax ) smax = sidx;
					if( sstart < 0 || sidx < sstart ) sstart = sidx;
				}
			}
			switch( state.kind) {
			case Vertex:
				if( max >= 0 ) {
					#if dxdebug
					for( i in 0...max )
						for( r in 0...targetsCount )
							if( currentTargetResources[r] == state.resources[i] )
								throw "Texture bound in output is set in shader";
					#end
					Driver.vsSetShaderResources(start, max - start + 1, state.resources.getRef().offset(start));
				}
				if( smax >= 0 ) Driver.vsSetSamplers(sstart, smax - sstart + 1, state.samplers.getRef().offset(sstart));
			case Pixel:
				if( max >= 0 ) {
					#if dxdebug
					for( i in 0...max )
						for( r in 0...targetsCount )
							if( currentTargetResources[r] == state.resources[i] )
								throw "Texture bound in output is set in shader";
					#end
					Driver.psSetShaderResources(start, max - start + 1, state.resources.getRef().offset(start));
				}
				if( smax >= 0 ) Driver.psSetSamplers(sstart, smax - sstart + 1, state.samplers.getRef().offset(sstart));
			}
		}
	}

	override function draw(ibuf:Buffer, startIndex:Int, ntriangles:Int) {
		if( !allowDraw )
			return;
		if( currentIndex != ibuf ) {
			currentIndex = ibuf;
			dx.Driver.iaSetIndexBuffer(ibuf.vbuf,ibuf.format.strideBytes == 4,0);
		}
		dx.Driver.drawIndexed(ntriangles * 3, startIndex, 0);
	}

	override function allocInstanceBuffer(b:InstanceBuffer, buf : haxe.io.Bytes) {
		b.data = dx.Driver.createBuffer(b.commandCount * 5 * 4, Default, UnorderedAccess, None, DrawIndirectArgs, 4, buf);
	}

	override function uploadInstanceBufferBytes(b : InstanceBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		if( hasDeviceError ) return;
		var strideBytes = 5 * 4;
		updateBuffer(b.data, @:privateAccess buf.b.offset(bufPos), startVertex * strideBytes, vertexCount * strideBytes);
	}

	override function disposeInstanceBuffer(b:InstanceBuffer) {
		(b.data : dx.Resource).release();
		b.data = null;
	}

	override function drawInstanced(ibuf:Buffer, commands:InstanceBuffer) {
		if( !allowDraw )
			return;
		if( currentIndex != ibuf ) {
			currentIndex = ibuf;
			dx.Driver.iaSetIndexBuffer(ibuf.vbuf,ibuf.format.strideBytes == 4,0);
		}
		if( commands.data == null ) {
			#if( (hldx == "1.8.0") || (hldx == "1.9.0") )
			throw "Requires HLDX 1.10+";
			#else
			dx.Driver.drawIndexedInstanced(commands.indexCount, commands.commandCount, commands.startIndex, 0, 0);
			#end
		} else {
			for( i in 0...commands.commandCount )
				dx.Driver.drawIndexedInstancedIndirect(commands.data,i * 20);
		}
	}

	static var COMPARE : Array<ComparisonFunc> = [
		Always,
		Never,
		Equal,
		NotEqual,
		Greater,
		GreaterEqual,
		Less,
		LessEqual
	];

	static var CULL : Array<CullMode> = [
		None,
		Back,
		Front,
		None,
	];

	static var STENCIL_OP : Array<StencilOp> = [
		Keep,
		Zero,
		Replace,
		IncrSat,
		Incr,
		DecrSat,
		Decr,
		Invert,
	];

	static var BLEND : Array<Blend> = [
		One,
		Zero,
		SrcAlpha,
		SrcColor,
		DestAlpha,
		DestColor,
		InvSrcAlpha,
		InvSrcColor,
		InvDestAlpha,
		InvDestColor,
		Src1Color,
		Src1Alpha,
		InvSrc1Color,
		InvSrc1Alpha,
		SrcAlphaSat,
		// BlendFactor/InvBlendFactor : not supported by Heaps for now
	];

	static var BLEND_ALPHA : Array<Blend> = [
		One,
		Zero,
		SrcAlpha,
		SrcAlpha,
		DestAlpha,
		DestAlpha,
		InvSrcAlpha,
		InvSrcAlpha,
		InvDestAlpha,
		InvDestAlpha,
		Src1Alpha,
		Src1Alpha,
		InvSrc1Alpha,
		InvSrc1Alpha,
		SrcAlphaSat,
		// BlendFactor/InvBlendFactor : not supported by Heaps for now
	];


	static var BLEND_OP : Array<BlendOp> = [
		Add,
		Subtract,
		RevSubstract,
		Min,
		Max
	];

	static var FILTER : Array<Array<Filter>> = [
		[MinMagMipPoint,MinMagMipLinear],
		[MinMagMipPoint,MinMagLinearMipPoint],
		[MinMagPointMipLinear, MinMagMipLinear],
		// Anisotropic , Comparison, Minimum, Maximum
	];

	static var WRAP : Array<AddressMode> = [
		Clamp,
		Wrap,
		Mirror,
		// Border , MirrorOnce
	];
}

#end
