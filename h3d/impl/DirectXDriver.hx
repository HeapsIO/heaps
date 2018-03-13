package h3d.impl;

#if (hldx && haxe_ver < 4)

class DirectXDriver extends h3d.impl.Driver {

	public function new() {
		throw "HL DirectX support requires Haxe 4.0+";
	}

}

#elseif hldx

import h3d.impl.Driver;
import dx.Driver;
import h3d.mat.Pass;

private class ShaderContext {
	public var shader : Shader;
	public var globalsSize : Int;
	public var paramsSize : Int;
	public var texturesCount : Int;
	public var textures2DCount : Int;
	public var paramsContent : hl.Bytes;
	public var globals : dx.Resource;
	public var params : dx.Resource;
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
	public var layout : Layout;
	public var inputs : Array<String>;
	public var offsets : Array<Int>;
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

	var defaultTarget : RenderTargetView;
	var defaultDepth : DepthBuffer;
	var defaultDepthInst : h3d.mat.DepthBuffer;
	var extraDepthInst : h3d.mat.DepthBuffer;

	var viewport : hl.BytesAccess<hl.F32> = new hl.Bytes(4 * VIEWPORTS_ELTS);
	var rects : hl.BytesAccess<Int> = new hl.Bytes(4 * RECTS_ELTS);
	var box = new dx.Resource.ResourceBox();
	var strides : Array<Int> = [];
	var offsets : Array<Int> = [];
	var currentShader : CompiledShader;
	var currentIndex : IndexBuffer;
	var currentDepth : DepthBuffer;
	var currentTargets = new hl.NativeArray<RenderTargetView>(16);
	var vertexShader = new PipelineState(Vertex);
	var pixelShader = new PipelineState(Pixel);
	var currentVBuffers = new hl.NativeArray<dx.Resource>(16);
	var frame : Int;
	var currentMaterialBits = -1;
	var targetsCount = 1;

	var depthStates : Map<Int,DepthStencilState> = new Map();
	var blendStates : Map<Int,BlendState> = new Map();
	var rasterStates : Map<Int,RasterState> = new Map();
	var samplerStates : Map<Int,SamplerState> = new Map();
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

	public var backBufferFormat : dx.Format = R8G8B8A8_UNORM;
	public var depthStencilFormat : dx.Format = D24_UNORM_S8_UINT;

	public function new() {
		shaders = new Map();
		window = @:privateAccess dx.Window.windows[0];
		var options : dx.Driver.DriverInitFlags = None;
		#if debug
		options |= DebugLayer;
		#end

		try
			driver = Driver.create(window, backBufferFormat, options)
		catch( e : Dynamic )
			throw "Failed to initialize DirectX driver (" + e+")";

		if( driver == null ) throw "Failed to initialize DirectX driver";

		var version = Driver.getSupportedVersion();
		shaderVersion = if( version < 10 ) "3_0" else if( version < 11 ) "4_0" else "5_0";

		Driver.iaSetPrimitiveTopology(TriangleList);
		defaultDepthInst = new h3d.mat.DepthBuffer(-1, -1);
		for( i in 0...VIEWPORTS_ELTS )
			viewport[i] = 0;
		for( i in 0...RECTS_ELTS )
			rects[i] = 0;
		for( i in 0...BLEND_FACTORS )
			blendFactors[i] = 0;
	}

	override function resize(width:Int, height:Int)  {
		if( defaultDepth != null ) {
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
		depthDesc.format = depthStencilFormat;
		depthDesc.bind = DepthStencil;
		var depth = Driver.createTexture2d(depthDesc);
		if( depth == null ) throw "Failed to create depthBuffer";
		var depthView = Driver.createDepthStencilView(depth,depthStencilFormat);
		defaultDepth = { res : depth, view : depthView };
		@:privateAccess {
			defaultDepthInst.b = defaultDepth;
			defaultDepthInst.width = width;
			defaultDepthInst.height = height;
		}

		var buf = Driver.getBackBuffer();
		defaultTarget = Driver.createRenderTargetView(buf);
		buf.release();

		outputWidth = width;
		outputHeight = height;

		setRenderTarget(null);

		if( extraDepthInst != null ) @:privateAccess {
			extraDepthInst.width = width;
			extraDepthInst.height = height;
			extraDepthInst.dispose();
			extraDepthInst.b = allocDepthBuffer(extraDepthInst);
		}
	}

	override function begin(frame:Int) {
		mapCount = 0;
		updateResCount = 0;
		this.frame = frame;
		setRenderTarget(null);
	}

	override function isDisposed() {
		return false;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		haxe.Timer.delay(onCreate.bind(false), 1);
	}

	override function clear(?color:h3d.Vector, ?depth:Float, ?stencil:Int) {
		if( color != null ) {
			for( i in 0...targetsCount )
				Driver.clearColor(currentTargets[i], color.r, color.g, color.b, color.a);
		}
		if( currentDepth != null && (depth != null || stencil != null) )
			Driver.clearDepthStencilView(currentDepth.view, depth, stencil);
	}

	override function getDriverName(details:Bool) {
		var desc = "DirectX" + Driver.getSupportedVersion();
		if( details ) desc += " " + Driver.getDeviceName();
		return desc;
	}

	override function present() {
		var old = hxd.System.allowTimeout;
		if( old ) hxd.System.allowTimeout = false;
		Driver.present(window.vsync ? 1 : 0, None);
		if( old ) hxd.System.allowTimeout = true;
	}

	override function getDefaultDepthBuffer():h3d.mat.DepthBuffer {
		if( extraDepthInst == null )
			extraDepthInst = new h3d.mat.DepthBuffer(outputWidth, outputHeight);
		return extraDepthInst;
	}

	override function allocVertexes(m:ManagedBuffer):VertexBuffer {
		var res = dx.Driver.createBuffer(m.size * m.stride * 4, Default, VertexBuffer, None, None, 0, null);
		if( res == null ) return null;
		return { res : res, count : m.size, stride : m.stride };
	}

	override function allocIndexes( count : Int ) : IndexBuffer {
		var res = dx.Driver.createBuffer(count << 1, Default, IndexBuffer, None, None, 0, null);
		if( res == null ) return null;
		return { res : res, count : count };
	}

	override function allocDepthBuffer(b:h3d.mat.DepthBuffer):DepthBuffer {
		var depthDesc = new Texture2dDesc();
		depthDesc.width = b.width;
		depthDesc.height = b.height;
		depthDesc.format = D24_UNORM_S8_UINT;
		depthDesc.bind = DepthStencil;
		var depth = Driver.createTexture2d(depthDesc);
		if( depth == null )
			return null;
		return { res : depth, view : Driver.createDepthStencilView(depth,depthDesc.format) };
	}

	override function disposeDepthBuffer(b:h3d.mat.DepthBuffer) @:privateAccess {
		var d = b.b;
		b.b = null;
		d.view.release();
		d.res.release();
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		var rt = curTexture;
		if( rt == null )
			throw "Can't capture main render buffer in DirectX";
		captureTexPixels(pixels, rt, 0, 0);
	}

	function getTextureFormat( t : h3d.mat.Texture ) : dx.Format {
		return switch( t.format ) {
		case RGBA: R8G8B8A8_UNORM;
		case RGBA16F: R16G16B16A16_FLOAT;
		case RGBA32F: R32G32B32A32_FLOAT;
		case ALPHA32F: R32_FLOAT;
		case ALPHA16F: R16_FLOAT;
		case ALPHA8: R8_UNORM;
		default: throw "Unsupported texture format " + t.format;
		}
	}

	override function allocTexture(t:h3d.mat.Texture):Texture {

		var mips = 1;
		if( t.flags.has(MipMapped) ) {
			while( t.width >= 1 << mips || t.height >= 1 << mips ) mips++;
		}

		var rt = t.flags.has(Target);
		var isCube = t.flags.has(Cube);

		var desc = new Texture2dDesc();
		desc.width = t.width;
		desc.height = t.height;
		desc.format = getTextureFormat(t);
		desc.usage = Default;
		desc.bind = ShaderResource;
		desc.mipLevels = mips;
		if( rt )
			desc.bind |= RenderTarget;
		if( isCube ) {
			desc.arraySize = 6;
			desc.misc |= TextureCube;
		}
		if( t.flags.has(MipMapped) && !t.flags.has(ManualMipMapGen) ) {
			desc.bind |= RenderTarget;
			desc.misc |= GenerateMips;
		}
		var tex = Driver.createTexture2d(desc);
		if( tex == null )
			return null;

		t.lastFrame = frame;
		t.flags.unset(WasCleared);

		var vdesc = new ShaderResourceViewDesc();
		vdesc.format = desc.format;
		vdesc.dimension = isCube ? TextureCube : Texture2D;
		vdesc.arraySize = desc.arraySize;
		vdesc.start = 0; // top mip level
		vdesc.count = -1; // all mip levels
		var view = Driver.createShaderResourceView(tex, vdesc);
		return { res : tex, view : view, rt : rt ? [] : null, mips : mips };
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		var tt = t.t;
		if( tt == null ) return;
		t.t = null;
		tt.view.release();
		tt.res.release();
		if( tt.rt != null )
			for( rt in tt.rt )
				if( rt != null )
					rt.release();
	}

	override function disposeVertexes(v:VertexBuffer) {
		v.res.release();
	}

	override function disposeIndexes(i:IndexBuffer) {
		i.res.release();
	}

	override function generateMipMaps(texture:h3d.mat.Texture) {
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

	override function uploadIndexBuffer(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:hxd.IndexBuffer, bufPos:Int) {
		updateBuffer(i.res, hl.Bytes.getArray(buf.getNative()).offset(bufPos << 1), startIndice << 1, indiceCount << 1);
	}

	override function uploadIndexBytes(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		updateBuffer(i.res, @:privateAccess buf.b.offset(bufPos << 1), startIndice << 1, indiceCount << 1);
	}

	override function uploadVertexBuffer(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:hxd.FloatBuffer, bufPos:Int) {
		updateBuffer(v.res, hl.Bytes.getArray(buf.getNative()).offset(bufPos<<2), startVertex * v.stride << 2, vertexCount * v.stride << 2);
	}

	override function uploadVertexBytes(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		updateBuffer(v.res, @:privateAccess buf.b.offset(bufPos << 2), startVertex * v.stride << 2, vertexCount * v.stride << 2);
	}

	override function readIndexBytes(v:IndexBuffer, startIndice:Int, indiceCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		var tmp = dx.Driver.createBuffer(indiceCount << 1, Staging, None, CpuRead | CpuWrite, None, 0, null);
		box.left = startIndice << 1;
		box.top = 0;
		box.front = 0;
		box.right = (startIndice + indiceCount) << 1;
		box.bottom = 1;
		box.back = 1;
		tmp.copySubresourceRegion(0, 0, 0, 0, v.res, 0, box);
		var ptr = tmp.map(0, Read, true, null);
		@:privateAccess buf.b.blit(bufPos, ptr, 0, indiceCount << 1);
		tmp.unmap(0);
		tmp.release();
	}

	override function readVertexBytes(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		var tmp = dx.Driver.createBuffer(vertexCount * v.stride * 4, Staging, None, CpuRead | CpuWrite, None, 0, null);
		box.left = startVertex * v.stride * 4;
		box.top = 0;
		box.front = 0;
		box.right = (startVertex + vertexCount) * 4 * v.stride;
		box.bottom = 1;
		box.back = 1;
		tmp.copySubresourceRegion(0, 0, 0, 0, v.res, 0, box);
		var ptr = tmp.map(0, Read, true, null);
		@:privateAccess buf.b.blit(bufPos, ptr, 0, vertexCount * v.stride * 4);
		tmp.unmap(0);
		tmp.release();
	}

	override function capturePixels(tex:h3d.mat.Texture, face:Int, mipLevel:Int) : hxd.Pixels {
		var pixels = hxd.Pixels.alloc(tex.width >> mipLevel, tex.height >> mipLevel, tex.format);
		captureTexPixels(pixels, tex, face, mipLevel);
		return pixels;
	}

	function captureTexPixels( pixels: hxd.Pixels, tex:h3d.mat.Texture, face:Int, mipLevel:Int)  {
		var desc = new Texture2dDesc();
		desc.width = pixels.width;
		desc.height = pixels.height;
		desc.access = CpuRead | CpuWrite;
		desc.usage = Staging;
		desc.format = getTextureFormat(tex);
		var tmp = dx.Driver.createTexture2d(desc);
		if( tmp == null )
			throw "Capture failed: can't create tmp texture";

		tmp.copySubresourceRegion(0,0,0,0,tex.t.res,tex.t.mips * face + mipLevel, null);

		var pitch = 0;
		var ptr = tmp.map(0, Read, true, pitch);
		if( pitch == desc.width * 4 )
			@:privateAccess pixels.bytes.b.blit(0, ptr, 0, desc.width * desc.height * 4);
		else {
			for( i in 0...desc.height )
				@:privateAccess pixels.bytes.b.blit(i * desc.width * 4, ptr, i * pitch, desc.width * 4);
		}
		tmp.unmap(0);
		tmp.release();
		return pixels;
	}

	override function uploadTextureBitmap(t:h3d.mat.Texture, bmp:hxd.BitmapData, mipLevel:Int, side:Int) {
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	}

	override function uploadTexturePixels(t:h3d.mat.Texture, pixels:hxd.Pixels, mipLevel:Int, side:Int) {
		pixels.convert(RGBA);
		if( mipLevel >= t.t.mips ) throw "Mip level outside texture range : " + mipLevel + " (max = " + (t.t.mips - 1) + ")";
		t.t.res.updateSubresource(mipLevel + side * t.t.mips, null, pixels.bytes, pixels.width << 2, 0);
		updateResCount++;
	}

	static inline var SCISSOR_BIT = 1 << (Pass.colorMask_offset + 4);

	override public function selectMaterial(pass:h3d.mat.Pass) {
		var bits = @:privateAccess pass.bits;

		if( hasScissor ) bits |= SCISSOR_BIT;

		if( bits == currentMaterialBits )
			return;

		currentMaterialBits = bits;

		var depthBits = bits & (Pass.depthWrite_mask | Pass.depthTest_mask);
		if( pass.stencil != null ) throw "TODO";
		var depth = depthStates.get(depthBits);
		if( depth == null ) {
			var cmp = Pass.getDepthTest(bits);
			var desc = new DepthStencilDesc();
			desc.depthEnable = cmp != 0;
			desc.depthFunc = COMPARE[cmp];
			desc.depthWrite = Pass.getDepthWrite(bits) != 0;
			depth = Driver.createDepthStencilState(desc);
			depthStates.set(depthBits, depth);
		}
		if( depth != currentDepthState ) {
			currentDepthState = depth;
			Driver.omSetDepthStencilState(depth);
		}

		var rasterBits = bits & (Pass.culling_mask | SCISSOR_BIT);
		var raster = rasterStates.get(rasterBits);
		if( raster == null ) {
			var desc = new RasterizerDesc();
			desc.fillMode = Solid;
			desc.cullMode = CULL[Pass.getCulling(bits)];
			if( pass.culling == Both ) throw "Culling:Both Not supported in DirectX";
			desc.depthClipEnable = true;
			desc.scissorEnable = bits & SCISSOR_BIT != 0;
			raster = Driver.createRasterizerState(desc);
			rasterStates.set(rasterBits, raster);
		}
		if( raster != currentRasterState ) {
			currentRasterState = raster;
			Driver.rsSetState(raster);
		}

		var blendBits = bits & (Pass.blendSrc_mask | Pass.blendDst_mask | Pass.blendAlphaSrc_mask | Pass.blendAlphaDst_mask | Pass.blendOp_mask | Pass.blendAlphaOp_mask | Pass.colorMask_mask);
		var blend = blendStates.get(blendBits);
		if( blend == null ) {
			var desc = new RenderTargetBlendDesc();
			desc.srcBlend = BLEND[Pass.getBlendSrc(bits)];
			desc.destBlend = BLEND[Pass.getBlendDst(bits)];
			desc.srcBlendAlpha = BLEND_ALPHA[Pass.getBlendAlphaSrc(bits)];
			desc.destBlendAlpha = BLEND_ALPHA[Pass.getBlendAlphaDst(bits)];
			desc.blendOp = BLEND_OP[Pass.getBlendOp(bits)];
			desc.blendOpAlpha = BLEND_OP[Pass.getBlendAlphaOp(bits)];
			desc.renderTargetWriteMask = Pass.getColorMask(bits);
			desc.blendEnable = !(desc.srcBlend == One && desc.srcBlendAlpha == One && desc.destBlend == Zero && desc.destBlendAlpha == Zero && desc.blendOp == Add && desc.blendOpAlpha == Add);
			var tmp = new hl.NativeArray(1);
			tmp[0] = desc;
			blend = Driver.createBlendState(false, false, tmp, 1);
			blendStates.set(blendBits, blend);
		}
		if( blend != currentBlendState ) {
			currentBlendState = blend;
			Driver.omSetBlendState(blend, blendFactors, -1);
		}
	}

	function compileShader( shader : hxsl.RuntimeShader.RuntimeShaderData, compileOnly = false ) {
		var h = new hxsl.HlslOut();
		if( shader.code == null ){
			shader.code = h.run(shader.data);
			shader.data.funs = null;
		}
		var bytes = try dx.Driver.compileShader(shader.code, "", "main", (shader.vertex?"vs_":"ps_")+shaderVersion, OptimizationLevel3) catch( err : String ) {
			err = ~/^\(([0-9]+),([0-9]+)-([0-9]+)\)/gm.map(err, function(r) {
				var line = Std.parseInt(r.matched(1));
				var char = Std.parseInt(r.matched(2));
				var end = Std.parseInt(r.matched(3));
				return "\n<< " + shader.code.split("\n")[line - 1].substr(char-1,end - char + 1) +" >>";
			});
			throw "Shader compilation error " + err + "\n\nin\n\n" + shader.code;
		}
		if( compileOnly )
			return { s : null, bytes : bytes };
		var s = shader.vertex ? Driver.createVertexShader(bytes) : Driver.createPixelShader(bytes);
		if( s == null )
			throw "Failed to create shader\n" + shader.code;

		var ctx = new ShaderContext(s);
		ctx.globalsSize = shader.globalsSize;
		ctx.paramsSize = shader.paramsSize;
		ctx.paramsContent = new hl.Bytes(shader.paramsSize * 16);
		ctx.paramsContent.fill(0, shader.paramsSize * 16, 0xDD);
		ctx.texturesCount = shader.textures2DCount + shader.texturesCubeCount;
		ctx.textures2DCount = shader.textures2DCount;
		ctx.globals = dx.Driver.createBuffer(shader.globalsSize * 16, Dynamic, ConstantBuffer, CpuWrite, None, 0, null);
		ctx.params = dx.Driver.createBuffer(shader.paramsSize * 16, Dynamic, ConstantBuffer, CpuWrite, None, 0, null);
		#if debug
		ctx.debugSource = shader.code;
		#end
		return { s : ctx, bytes : bytes };
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		var v = compileShader(shader.vertex, true).bytes;
		var f = compileShader(shader.fragment, true).bytes;
		return Driver.disassembleShader(v, None, null) + "\n" + Driver.disassembleShader(f, None, null);
		//return "// vertex:\n" + new hxsl.HlslOut().run(shader.vertex.data) + "// fragment:\n" + new hxsl.HlslOut().run(shader.fragment.data);
	}

	override function hasFeature(f:Feature) {
		return switch(f) {
		case StandardDerivatives, FloatTextures, AllocDepthBuffer, HardwareAccelerated, MultipleRenderTargets:
			true;
		case Queries:
			false;
		};
	}

	override function copyTexture(from:h3d.mat.Texture, to:h3d.mat.Texture) {
		if( from.t == null || from.format != to.format || from.width != to.width || from.height != to.height )
			return false;
		if( to.t == null )
			to.alloc();
		to.t.res.copyResource(from.t.res);
		to.flags.set(WasCleared);
		return true;
	}

	var tmpTextures = new Array<h3d.mat.Texture>();
	override function setRenderTarget(tex:Null<h3d.mat.Texture>, face = 0, mipLevel = 0) {
		if( tex == null ) {
			curTexture = null;
			currentDepth = defaultDepth;
			currentTargets[0] = defaultTarget;
			targetsCount = 1;
			Driver.omSetRenderTargets(1, currentTargets, currentDepth.view);
			viewport[2] = outputWidth;
			viewport[3] = outputHeight;
			viewport[5] = 1.;
			Driver.rsSetViewports(1, viewport);
			return;
		}
		tmpTextures[0] = tex;
		_setRenderTargets(tmpTextures, face, mipLevel);
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

	override function setRenderTargets(textures:Array<h3d.mat.Texture>) {
		_setRenderTargets(textures, 0, 0);
	}

	function _setRenderTargets( textures:Array<h3d.mat.Texture>, face : Int, mipLevel : Int ) {
		if( textures.length == 0 ) {
			setRenderTarget(null);
			return;
		}
		var tex = textures[0];
		curTexture = textures[0];
		if( tex.depthBuffer != null && (tex.depthBuffer.width != tex.width || tex.depthBuffer.height != tex.height) )
			throw "Invalid depth buffer size : does not match render target size";
		currentDepth = @:privateAccess (tex.depthBuffer == null ? null : tex.depthBuffer.b);
		for( i in 0...textures.length ) {
			var tex = textures[i];
			if( tex.t == null )
				tex.alloc();
			if( tex.t.rt == null )
				throw "Can't render to texture which is not allocated with Target flag";
			var index = mipLevel * 6 + face;
			var rt = tex.t.rt[index];
			if( rt == null ) {
				var cube = tex.flags.has(Cube);
				var v = new dx.Driver.RenderTargetDesc(getTextureFormat(tex), cube ? Texture2DArray : Texture2D);
				v.mipMap = mipLevel;
				v.firstSlice = face;
				v.sliceCount = 1;
				rt = Driver.createRenderTargetView(tex.t.res, v);
				tex.t.rt[index] = rt;
			}
			tex.lastFrame = frame;
			currentTargets[i] = rt;
			unbind(tex.t.view);
			// prevent garbage
			if( !tex.flags.has(WasCleared) ) {
				tex.flags.set(WasCleared);
				Driver.clearColor(rt, 0, 0, 0, 0);
			}
		}
		Driver.omSetRenderTargets(textures.length, currentTargets, currentDepth == null ? null : currentDepth.view);
		targetsCount = textures.length;

		viewport[2] = tex.width >> mipLevel;
		viewport[3] = tex.height >> mipLevel;
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
			s.vertex = vertex.s;
			s.fragment = compileShader(shader.fragment).s;
			s.inputs = [];
			s.offsets = [];

			var layout = [], offset = 0;
			for( v in shader.vertex.data.vars )
				if( v.kind == Input ) {
					var e = new LayoutElement();
					e.semanticName = @:privateAccess v.name.toUtf8();
					e.inputSlot = layout.length;
					e.format = switch( v.type ) {
					case TFloat: R32_FLOAT;
					case TVec(2, VFloat): R32G32_FLOAT;
					case TVec(3, VFloat): R32G32B32_FLOAT;
					case TVec(4, VFloat): R32G32B32A32_FLOAT;
					case TBytes(4): R8G8B8A8_UINT;
					default:
						throw "Unsupported input type " + hxsl.Ast.Tools.toString(v.type);
					};
					e.inputSlotClass = PerVertexData;
					layout.push(e);
					s.offsets.push(offset);
					s.inputs.push(v.name);

					var size = switch( v.type ) {
					case TVec(n, _): n;
					case TBytes(n): n;
					case TFloat: 1;
					default: throw "assert " + v.type;
					}

					offset += size;
				}

			var n = new hl.NativeArray(layout.length);
			for( i in 0...layout.length )
				n[i] = layout[i];
			s.layout = Driver.createInputLayout(n, vertex.bytes, vertex.bytes.length);
			if( s.layout == null )
				throw "Failed to create input layout";
			shaders.set(shader.id, s);
		}
		if( s == currentShader )
			return false;
		currentShader = s;
		dx.Driver.vsSetShader(s.vertex.shader);
		dx.Driver.psSetShader(s.fragment.shader);
		dx.Driver.iaSetInputLayout(s.layout);
		return true;
	}

	override function getShaderInputNames():Array<String> {
		return currentShader.inputs;
	}

	override function selectBuffer(buffer:Buffer) {
		var vbuf = @:privateAccess buffer.buffer.vbuf;
		var start = -1, max = -1, position = 0;
		for( i in 0...currentShader.inputs.length ) {
			if( currentVBuffers[i] != vbuf.res || offsets[i] != currentShader.offsets[i] << 2 ) {
				currentVBuffers[i] = vbuf.res;
				strides[i] = buffer.buffer.stride << 2;
				offsets[i] = currentShader.offsets[i] << 2;
				if( start < 0 ) start = i;
				max = i;
			}
		}
		if( max >= 0 )
			Driver.iaSetVertexBuffers(start, max - start + 1, currentVBuffers.getRef().offset(start), hl.Bytes.getArray(strides).offset(start << 2), hl.Bytes.getArray(offsets).offset(start << 2));
	}

	override function selectMultiBuffers(bl:Buffer.BufferOffset) {
		var index = 0;
		var start = -1, max = -1;
		while( bl != null ) {
			var vbuf = @:privateAccess bl.buffer.buffer.vbuf;
			if( currentVBuffers[index] != vbuf.res || offsets[index] != bl.offset << 2 ) {
				currentVBuffers[index] = vbuf.res;
				offsets[index] = bl.offset << 2;
				strides[index] = bl.buffer.buffer.stride << 2;
				if( start < 0 ) start = index;
				max = index;
			}
			index++;
			bl = bl.next;
		}
		if( max >= 0 )
			Driver.iaSetVertexBuffers(start, max - start + 1, currentVBuffers.getRef().offset(start), hl.Bytes.getArray(strides).offset(start << 2), hl.Bytes.getArray(offsets).offset(start << 2));
	}

	override function uploadShaderBuffers(buffers:h3d.shader.Buffers, which:h3d.shader.Buffers.BufferKind) {
		uploadBuffers(vertexShader, currentShader.vertex, buffers.vertex, which);
		uploadBuffers(pixelShader, currentShader.fragment, buffers.fragment, which);
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

	function uploadBuffers( state : PipelineState, shader : ShaderContext, buffers : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind ) {
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
		case Textures:
			var start = -1, max = -1;
			var sstart = -1, smax = -1;
			for( i in 0...shader.texturesCount ) {
				var t = buffers.tex[i];
				if( t == null || t.isDisposed() ) {
					if( i < shader.textures2DCount ) {
						var color = h3d.mat.Defaults.loadingTextureColor;
						t = h3d.mat.Texture.fromColor(color, (color >>> 24) / 255);
					} else {
						t = h3d.mat.Texture.defaultCubeTexture();
					}
				}
				if( t != null && t.t == null && t.realloc != null ) {
					t.alloc();
					t.realloc();
				}
				t.lastFrame = frame;

				var view = t.t.view;
				if( view != state.resources[i] ) {
					state.resources[i] = view;
					max = i;
					if( start < 0 ) start = i;
				}

				var bits = @:privateAccess t.bits;
				if( bits != state.samplerBits[i] ) {
					var ss = samplerStates.get(bits);
					if( ss == null ) {
						var desc = new SamplerDesc();
						desc.filter = FILTER[t.mipMap.getIndex()][t.filter.getIndex()];
						desc.addressU = desc.addressV = desc.addressW = WRAP[t.wrap.getIndex()];
						// if mipMap = None && hasMipmaps : don't set per-sampler maxLod !
						// only the first sampler maxLod seems to be taken into account :'(
						desc.minLod = 0;
						desc.maxLod = 1e30;
						ss = Driver.createSamplerState(desc);
						samplerStates.set(bits, ss);
					}
					state.samplerBits[i] = bits;
					state.samplers[i] = ss;
					smax = i;
					if( sstart < 0 ) sstart = i;
				}
			}
			switch( state.kind) {
			case Vertex:
				if( max >= 0 ) Driver.vsSetShaderResources(start, max - start + 1, state.resources.getRef().offset(start));
				if( smax >= 0 ) Driver.vsSetSamplers(sstart, smax - sstart + 1, state.samplers.getRef().offset(sstart));
			case Pixel:
				if( max >= 0 ) Driver.psSetShaderResources(start, max - start + 1, state.resources.getRef().offset(start));
				if( smax >= 0 ) Driver.psSetSamplers(sstart, smax - sstart + 1, state.samplers.getRef().offset(sstart));
			}
		}
	}

	override function draw(ibuf:IndexBuffer, startIndex:Int, ntriangles:Int) {
		if( currentIndex != ibuf ) {
			currentIndex = ibuf;
			dx.Driver.iaSetIndexBuffer(ibuf.res,false,0);
		}
		dx.Driver.drawIndexed(ntriangles * 3, startIndex, 0);
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
		// Min / Max : not supported by Heaps for now
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
		//Mirror , Border , MirrorOnce
	];
}

#end
