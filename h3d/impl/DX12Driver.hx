package h3d.impl;

#if (hldx && dx12)

import h3d.impl.Driver;
import dx.Dx12;
import haxe.Int64;
import h3d.mat.Pass;

private typedef Driver = Dx12;

class DxFrame {
	public var backBuffer : GpuResource;
	public var depthBuffer : GpuResource;
	public var allocator : CommandAllocator;
	public var commandList : CommandList;
	public var fenceValue : Int64;
	public var toRelease : Array<Resource> = [];
	public var shaderResourceViews : ManagedHeap;
	public var samplerViews : ManagedHeap;
	public function new() {
	}
}

class CachedPipeline {
	public var bytes : hl.Bytes;
	public var size : Int;
	public var pipeline : GraphicsPipelineState;
	public function new() {
	}
}

class ShaderRegisters {
	public var globals : Int;
	public var params : Int;
	public var textures : Int;
	public var samplers : Int;
	public var texturesCount : Int;
	public function new() {
	}
}

class CompiledShader {
	public var vertexRegisters : ShaderRegisters;
	public var fragmentRegisters : ShaderRegisters;
	public var inputCount : Int;
	public var inputNames : InputNames;
	public var pipeline : GraphicsPipelineStateDesc;
	public var pipelines : Map<Int,hl.NativeArray<CachedPipeline>> = new Map();
	public var rootSignature : RootSignature;
	public var inputLayout : hl.CArray<InputElementDesc>;
	public var inputOffsets : Array<Int>;
	public var shader : hxsl.RuntimeShader;
	public function new() {
	}
}

@:struct class TempObjects {

	public var renderTargets : hl.BytesAccess<Address>;
	public var depthStencils : hl.BytesAccess<Address>;
	public var vertexViews : hl.CArray<VertexBufferView>;
	public var descriptors2 : hl.NativeArray<DescriptorHeap>;
	@:packed public var heap(default,null) : HeapProperties;
	@:packed public var barrier(default,null) : ResourceBarrier;
	@:packed public var clearColor(default,null) : ClearColor;
	@:packed public var clearValue(default,null) : ClearValue;
	@:packed public var viewport(default,null) : Viewport;
	@:packed public var rect(default,null) : Rect;
	@:packed public var tex2DSRV(default,null) : Tex2DSRV;
	@:packed public var texCubeSRV(default,null) : TexCubeSRV;
	@:packed public var tex2DArraySRV(default,null) : Tex2DArraySRV;
	@:packed public var bufferSRV(default,null) : BufferSRV;
	@:packed public var samplerDesc(default,null) : SamplerDesc;
	@:packed public var cbvDesc(default,null) : ConstantBufferViewDesc;

	public var pass : h3d.mat.Pass;

	public function new() {
		renderTargets = new hl.Bytes(8 * 8);
		depthStencils = new hl.Bytes(8);
		vertexViews = hl.CArray.alloc(VertexBufferView, 16);
		pass = new h3d.mat.Pass("default");
		pass.stencil = new h3d.mat.Stencil();
		tex2DSRV.dimension = TEXTURE2D;
		texCubeSRV.dimension = TEXTURECUBE;
		tex2DArraySRV.dimension = TEXTURE2DARRAY;
		tex2DSRV.mipLevels = texCubeSRV.mipLevels = tex2DArraySRV.mipLevels = -1;
		tex2DSRV.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
		texCubeSRV.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
		tex2DArraySRV.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
		bufferSRV.dimension = BUFFER;
		bufferSRV.flags = RAW;
		bufferSRV.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
		samplerDesc.comparisonFunc = NEVER;
		samplerDesc.maxLod = 1e30;
		descriptors2 = new hl.NativeArray(2);
		barrier.subResource = -1; // all
	}

}

class ManagedHeap {

	public var stride(default,null) : Int;
	var size : Int;
	var start : Int;
	var cursor : Int;
	var limit : Int;
	var type : DescriptorHeapType;
	var heap : DescriptorHeap;
	var address : Address;
	var cpuToGpu : Int64;

	public var available(get,never) : Int;

	public function new(type,size=8) {
		this.type = type;
		this.stride = Driver.getDescriptorHandleIncrementSize(type);
		allocHeap(size);
	}

	function allocHeap( size : Int ) {
		var desc = new DescriptorHeapDesc();
		desc.type = type;
		desc.numDescriptors = size;
		if( type == CBV_SRV_UAV || type == SAMPLER )
			desc.flags = SHADER_VISIBLE;
		heap = new DescriptorHeap(desc);
		limit = cursor = start = 0;
		this.size = size;
		address = heap.getHandle(false);
		cpuToGpu = heap.getHandle(true).value - address.value;
	}

	public dynamic function onFree( prev : DescriptorHeap ) {
		throw "Too many buffers";
	}

	public function alloc( count : Int ) {
		if( cursor >= limit && cursor + count > size )
			cursor = 0;
		if( cursor < limit && cursor + count >= limit ) {
			var prev = heap;
			allocHeap((size * 3) >> 1);
			onFree(prev);
		}
		var pos = cursor;
		cursor += count;
		return address.offset(pos * stride);
	}

	inline function get_available() {
		var d = limit - cursor;
		return d <= 0 ? size - d : d;
	}

	public inline function grow( onFree ) {
		var prev = heap;
		allocHeap((size*3)>>1);
		onFree(prev);
		return heap;
	}

	public function clear() {
		limit = cursor = start = 0;
	}

	public function next() {
		limit = start;
		start = cursor;
	}

	public inline function toGPU( address : Address ) : Address {
		return new Address(address.value + cpuToGpu);
	}

}

class ResourceData {
	public var res : GpuResource;
	public var state : ResourceState;
	public function new() {
	}
}

class IndexBufferData extends ResourceData {
	public var view : IndexBufferView;
	public var count : Int;
	public var bits : Int;
}

class VertexBufferData extends ResourceData {
	public var view : dx.Dx12.VertexBufferView;
	public var stride : Int;
}

class TextureData extends ResourceData {
	public var format : DxgiFormat;
}

class DepthBufferData extends ResourceData {
}

class QueryData {
}

class DX12Driver extends h3d.impl.Driver {

	static inline var PSIGN_MATID = 0;
	static inline var PSIGN_COLOR_MASK = PSIGN_MATID + 4;
	static inline var PSIGN_STENCIL_MASK = PSIGN_COLOR_MASK + 1;
	static inline var PSIGN_STENCIL_OPS = PSIGN_STENCIL_MASK + 3;
	static inline var PSIGN_RENDER_TARGETS = PSIGN_STENCIL_OPS + 4;
	static inline var PSIGN_BUF_OFFSETS = PSIGN_RENDER_TARGETS + 8;

	var pipelineSignature = new hl.Bytes(64);
	var adlerOut = new hl.Bytes(4);

	var driver : DriverInstance;
	var hasDeviceError = false;
	var window : dx.Window;
	var onContextLost : Void -> Void;
	var frames : Array<DxFrame>;
	var frame : DxFrame;
	var fence : Fence;
	var fenceEvent : WaitEvent;

	var renderTargetViews : ManagedHeap;
	var depthStenciViews : ManagedHeap;

	var currentFrame : Int;
	var fenceValue : Int64 = 0;
	var needPipelineFlush = false;
	var currentPass : h3d.mat.Pass;

	var currentWidth : Int;
	var currentHeight : Int;

	var currentShader : CompiledShader;
	var compiledShaders : Map<Int,CompiledShader> = new Map();
	var compiler : ShaderCompiler;

	var tmp : TempObjects;
	var currentRenderTargets : Array<h3d.mat.Texture> = [];
	var depthEnabled = true;

	static var BUFFER_COUNT = 2;

	public function new() {
		window = @:privateAccess dx.Window.windows[0];
		reset();
	}

	function reset() {
		var flags = new DriverInitFlags();
		flags.set(DEBUG);
		driver = Driver.create(window, flags);
		frames = [];
		for(i in 0...BUFFER_COUNT) {
			var f = new DxFrame();
			f.allocator = new CommandAllocator(DIRECT);
			f.commandList = new CommandList(DIRECT, f.allocator, null);
			f.commandList.close();
			f.shaderResourceViews = new ManagedHeap(CBV_SRV_UAV, 1024);
			f.samplerViews = new ManagedHeap(SAMPLER, 1024);
			frames.push(f);
		}
		fence = new Fence(0, NONE);
		fenceEvent = new WaitEvent(false);
		tmp = new TempObjects();

		renderTargetViews = new ManagedHeap(RTV);
		depthStenciViews = new ManagedHeap(DSV);
		renderTargetViews.onFree = function(prev) frame.toRelease.push(prev);
		depthStenciViews.onFree = function(prev) frame.toRelease.push(prev);

		compiler = new ShaderCompiler();
		resize(window.width, window.height);
	}

	function beginFrame() {
		currentFrame = Driver.getCurrentBackBufferIndex();
		frame = frames[currentFrame];
		frame.allocator.reset();
		frame.commandList.reset(frame.allocator, null);
		while( frame.toRelease.length > 0 )
			frame.toRelease.pop().release();

		var b = tmp.barrier;
		b.resource = frame.backBuffer;
		b.subResource = -1;
		b.stateBefore = PRESENT;
		b.stateAfter = RENDER_TARGET;
		frame.commandList.resourceBarrier(b);
		frame.commandList.iaSetPrimitiveTopology(TRIANGLELIST);

		renderTargetViews.next();
		depthStenciViews.next();

		setRenderTarget(null);

		var arr = tmp.descriptors2;
		arr[0] = @:privateAccess frame.shaderResourceViews.heap;
		arr[1] = @:privateAccess frame.samplerViews.heap;
		frame.commandList.setDescriptorHeaps(arr);

		frame.shaderResourceViews.clear();
		frame.samplerViews.clear();
	}

	override function clear(?color:Vector, ?depth:Float, ?stencil:Int) {
		if( color != null ) {
			var clear = tmp.clearColor;
			clear.r = color.r;
			clear.g = color.g;
			clear.b = color.b;
			clear.a = color.a;
			frame.commandList.clearRenderTargetView(tmp.renderTargets[0], clear);
		}
		if( depth != null || stencil != null )
			frame.commandList.clearDepthStencilView(tmp.depthStencils[0], depth != null ? (stencil != null ? BOTH : DEPTH) : STENCIL, (depth:Float), stencil);
	}

	function waitGpu() {
		Driver.signal(fence, fenceValue);
		fence.setEvent(fenceValue, fenceEvent);
		fenceEvent.wait(-1);
		fenceValue++;
	}

	override function resize(width:Int, height:Int)  {

		if( currentWidth == width && currentHeight == height )
			return;

		currentWidth = width;
		currentHeight = height;

		if( frame != null )
			frame.commandList.close();

		waitGpu();

		for( f in frames ) {
			if( f.backBuffer != null )
				f.backBuffer.release();
			if( f.depthBuffer != null )
				f.depthBuffer.release();
		}

		Driver.resize(width, height, BUFFER_COUNT, R8G8B8A8_UNORM);

		renderTargetViews.clear();
		depthStenciViews.clear();

		for( i => f in frames ) {
			f.backBuffer = Driver.getBackBuffer(i);
			f.backBuffer.setName("Backbuffer#"+i);

			var desc = new ResourceDesc();
			var flags = new haxe.EnumFlags();
			desc.dimension = TEXTURE2D;
			desc.width = width;
			desc.height = height;
			desc.depthOrArraySize = 1;
			desc.mipLevels = 1;
			desc.sampleDesc.count = 1;
			desc.format = D24_UNORM_S8_UINT;
			desc.flags.set(ALLOW_DEPTH_STENCIL);
			tmp.heap.type = DEFAULT;

			tmp.clearValue.format = desc.format;
			tmp.clearValue.depth = 1;
			tmp.clearValue.stencil= 0;
			f.depthBuffer = Driver.createCommittedResource(tmp.heap, flags, desc, DEPTH_WRITE, tmp.clearValue);
			f.depthBuffer.setName("Depthbuffer#"+i);
		}

		beginFrame();
	}

	override function begin(frame:Int) {
	}

	override function isDisposed() {
		return hasDeviceError;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		onContextLost = onCreate.bind(true);
		haxe.Timer.delay(onCreate.bind(false), 1);
	}

	override function getDriverName(details:Bool) {
		var desc = "DX12";
		return desc;
	}

	public function forceDeviceError() {
		hasDeviceError = true;
	}

	function transition( res : ResourceData, to : ResourceState ) {
		if( res.state == to )
			return;
		var b = tmp.barrier;
		b.resource = res.res;
		b.stateBefore = res.state;
		b.stateAfter = to;
		frame.commandList.resourceBarrier(b);
		res.state = to;
	}

	override function setRenderTarget(tex:Null<h3d.mat.Texture>, layer:Int = 0, mipLevel:Int = 0) {

		if( tex != null ) transition(tex.t, RENDER_TARGET);

		var texView = renderTargetViews.alloc(1);
		Driver.createRenderTargetView(tex == null ? frame.backBuffer : tex.t.res, null, texView);
		tmp.renderTargets[0] = texView;
		var depths = null;
		if( tex == null || tex.depthBuffer != null ) {
			var depthView = depthStenciViews.alloc(1);
			Driver.createDepthStencilView(tex == null ? frame.depthBuffer : @:privateAccess tex.depthBuffer.b.res, null, depthView);
			depths = tmp.depthStencils;
			depths[0] = depthView;
			depthEnabled = true;
		} else
			depthEnabled = false;
		frame.commandList.omSetRenderTargets(1, tmp.renderTargets, true, depths);

		while( currentRenderTargets.length > 0 ) currentRenderTargets.pop();
		if( tex != null ) currentRenderTargets.push(tex);

		var w = tex == null ? currentWidth : tex.width;
		var h = tex == null ? currentHeight : tex.height;
		tmp.viewport.width = w;
		tmp.viewport.height = h;
		tmp.viewport.maxDepth = 1;
		tmp.rect.right = w;
		tmp.rect.bottom = h;
		frame.commandList.rsSetScissorRects(1, tmp.rect);
		frame.commandList.rsSetViewports(1, tmp.viewport);

		pipelineSignature.setI32(PSIGN_RENDER_TARGETS, tex == null ? 0 : getRTBits(tex) | (depths == null ? 0 : 0x80000000));
		needPipelineFlush = true;
	}

	function getRTBits( tex : h3d.mat.Texture ) {
		inline function mk(channels,format) {
			return ((channels - 1) << 2) | (format + 1);
		}
		return switch( tex.format ) {
		case RGBA: mk(4,0);
		case R8: mk(1, 0);
		case RG8: mk(2, 0);
		case RGB8: mk(3, 0);
		case R16F: mk(1,1);
		case RG16F: mk(2,1);
		case RGB16F: mk(3,1);
		case RGBA16F: mk(4,1);
		case R32F: mk(1,2);
		case RG32F: mk(2,2);
		case RGB32F: mk(3,2);
		case RGBA32F: mk(4,2);
		default: throw "Unsupported RT format "+tex.format;
		}
	}

	override function setRenderTargets(textures:Array<h3d.mat.Texture>) {
		throw "TODO";
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		var rt = currentRenderTargets[0];
		if( rt == null )
			throw "Can't capture main render buffer in DirectX";
		captureTexPixels(pixels, rt, 0, 0);
	}

	override function capturePixels(tex:h3d.mat.Texture, layer:Int, mipLevel:Int, ?region:h2d.col.IBounds):hxd.Pixels {
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
			return;

		var totalSize : hl.BytesAccess<Int64> = new hl.Bytes(8);
		var src = new TextureCopyLocation();
		src.res = tex.t.res;
		src.subResourceIndex = mipLevel + layer * tex.mipLevels;
		var srcDesc = makeTextureDesc(tex);

		var dst = new TextureCopyLocation();
		dst.type = PLACED_FOOTPRINT;
		Driver.getCopyableFootprints(srcDesc, src.subResourceIndex, 1, 0, dst.placedFootprint, null, null, totalSize);

		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = BUFFER;
		desc.width = totalSize[0];
		desc.height = 1;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.layout = ROW_MAJOR;
		tmp.heap.type = READBACK;
		var tmpBuf = Driver.createCommittedResource(tmp.heap, flags, desc, COPY_DEST, null);

		var box = new Box();
		box.left = x;
		box.right = pixels.width;
		box.top = y;
		box.bottom = pixels.height;
		box.back = 1;

		transition(tex.t, COPY_SOURCE);
		dst.res = tmpBuf;
		frame.commandList.copyTextureRegion(dst, 0, 0, 0, src, box);

		flushFrame();
		waitGpu();

		var output = tmpBuf.map(0, null);
		var stride = hxd.Pixels.calcStride(pixels.width, tex.format);
		var rowStride = dst.placedFootprint.footprint.rowPitch;
		if( rowStride == stride )
			(pixels.bytes:hl.Bytes).blit(pixels.offset, output, 0, stride * pixels.height);
		else {
			for( i in 0...pixels.height )
				(pixels.bytes:hl.Bytes).blit(pixels.offset + i * stride, output, i * rowStride, stride);
		}

		tmpBuf.unmap(0,null);
		tmpBuf.release();

		beginFrame();
	}

	// ---- SHADERS -----

	static var VERTEX_FORMATS = [null,null,R32G32_FLOAT,R32G32B32_FLOAT,R32G32B32A32_FLOAT];

	function compileSource( sh : hxsl.RuntimeShader.RuntimeShaderData, profile, baseRegister ) {
		var args = [];
		var out = new hxsl.HlslOut();
		out.baseRegister = baseRegister;
		var source = out.run(sh.data);
		return compiler.compile(source, profile, args);
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		var out = new hxsl.HlslOut();
		var vsSource = out.run(shader.vertex.data);
		var out = new hxsl.HlslOut();
		var psSource = out.run(shader.fragment.data);
		return vsSource+"\n\n\n\n"+psSource;
	}

	function compileShader( shader : hxsl.RuntimeShader ) : CompiledShader {

		var params = hl.CArray.alloc(RootParameterConstants,8);
		var paramsCount = 0, regCount = 0;
		var texDescs = [];
		var vertexParamsCBV = false;
		var fragmentParamsCBV = false;
		var c = new CompiledShader();

		inline function unsafeCastTo<T,R>( v : T, c : Class<R> ) : R {
			var arr = new hl.NativeArray<T>(1);
			arr[0] = v;
			return (cast arr : hl.NativeArray<R>)[0];
		}

		function allocDescTable(vis) {
			var p = unsafeCastTo(params[paramsCount++], RootParameterDescriptorTable);
			p.parameterType = DESCRIPTOR_TABLE;
			p.numDescriptorRanges = 1;
			var range = new DescriptorRange();
			texDescs.push(range);
			p.descriptorRanges = range;
			p.shaderVisibility = vis;
			return range;
		}

		function allocConsts(size,vis,useCBV) {
			var reg = regCount++;
			if( size == 0 ) return -1;

			if( useCBV ) {
				var pid = paramsCount;
				var r = allocDescTable(vis);
				r.rangeType = CBV;
				r.numDescriptors = 1;
				r.baseShaderRegister = reg;
				r.registerSpace = 0;
				return pid | 0x100;
			}

			var pid = paramsCount++;
			var p = params[pid];
			p.parameterType = CONSTANTS;
			p.shaderRegister = reg;
			p.shaderVisibility = vis;
			p.num32BitValues = size << 2;
			return pid;
		}


		function allocParams( sh : hxsl.RuntimeShader.RuntimeShaderData ) {
			var vis = sh.vertex ? VERTEX : PIXEL;
			var regs = new ShaderRegisters();
			regs.globals = allocConsts(sh.globalsSize, vis, false);
			regs.params = allocConsts(sh.paramsSize, vis, sh.vertex ? vertexParamsCBV : fragmentParamsCBV);
			if( sh.texturesCount > 0 ) {
				regs.texturesCount = sh.texturesCount;
				regs.textures = paramsCount;

				var r = allocDescTable(vis);
				r.rangeType = SRV;
				r.baseShaderRegister = 0;
				r.registerSpace = 0;
				r.numDescriptors = sh.texturesCount;

				regs.samplers = paramsCount;
				var r = allocDescTable(vis);
				r.rangeType = SAMPLER;
				r.baseShaderRegister = 0;
				r.registerSpace = 0;
				r.numDescriptors = sh.texturesCount;
			}
			return regs;
		}

		function calcSize( sh : hxsl.RuntimeShader.RuntimeShaderData ) {
			var s = (sh.globalsSize + sh.paramsSize) << 2;
			if( sh.texturesCount > 0 ) s += 2;
			return s;
		}

		var totalVertex = calcSize(shader.vertex);
		var totalFragment = calcSize(shader.fragment);
		var total = totalVertex + totalFragment;

		if( total > 64 ) {
			var withoutVP = total - (shader.vertex.paramsSize << 2);
			var withoutFP = total - (shader.fragment.paramsSize << 2);
			if( total > 64 && (withoutVP < 64 || withoutFP > 64) ) {
				vertexParamsCBV = true;
				total -= (shader.vertex.paramsSize << 2);
			}
			if( total > 64 ) {
				fragmentParamsCBV = true;
				total -= (shader.fragment.paramsSize << 2);
			}
			if( total > 64 )
				throw "Too many globals";
		}

		c.vertexRegisters = allocParams(shader.vertex);
		var fragmentRegStart = regCount;
		c.fragmentRegisters = allocParams(shader.fragment);

		if( paramsCount > params.length )
			throw "ASSERT : Too many parameters";

		var vs = compileSource(shader.vertex, "vs_6_0", 0);
		var ps = compileSource(shader.fragment, "ps_6_0", fragmentRegStart);

		var inputs = [];
		for( v in shader.vertex.data.vars )
			switch( v.kind ) {
			case Input: inputs.push(v);
			default:
			}


		var sign = new RootSignatureDesc();
		sign.flags.set(ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);
		sign.flags.set(DENY_HULL_SHADER_ROOT_ACCESS);
		sign.flags.set(DENY_DOMAIN_SHADER_ROOT_ACCESS);
		sign.flags.set(DENY_GEOMETRY_SHADER_ROOT_ACCESS);
		sign.numParameters = paramsCount;
		sign.parameters = params[0];

		var signSize = 0;
		var signBytes = Driver.serializeRootSignature(sign, 1, signSize);
		var sign = new RootSignature(signBytes,signSize);

		var inputLayout = hl.CArray.alloc(InputElementDesc, inputs.length);
		var inputOffsets = [];
		var offset = 0;
		for( i => v in inputs ) {
			var d = inputLayout[i];
			var perInst = 0;
			inputOffsets.push(offset);
			if( v.qualifiers != null )
				for( q in v.qualifiers )
					switch( q ) {
					case PerInstance(k): perInst = k;
					default:
					}
			d.semanticName = @:privateAccess hxsl.HlslOut.semanticName(v.name).toUtf8();
			d.format = switch( v.type ) {
				case TFloat: offset++; R32_FLOAT;
				case TVec(2, VFloat): offset += 2; R32G32_FLOAT;
				case TVec(3, VFloat): offset += 3;R32G32B32_FLOAT;
				case TVec(4, VFloat): offset += 4;R32G32B32A32_FLOAT;
				case TBytes(4): offset++; R8G8B8A8_UINT;
				default:
					throw "Unsupported input type " + hxsl.Ast.Tools.toString(v.type);
			};
			d.inputSlot = i;
			if( perInst > 0 ) {
				d.inputSlotClass = PER_INSTANCE_DATA;
				d.instanceDataStepRate = perInst;
			} else
				d.inputSlotClass = PER_VERTEX_DATA;
		}

		var p = new GraphicsPipelineStateDesc();
		p.rootSignature = sign;
		p.vs.bytecodeLength = vs.length;
		p.vs.shaderBytecode = vs;
		p.ps.bytecodeLength = ps.length;
		p.ps.shaderBytecode = ps;
		p.rasterizerState.fillMode = SOLID;
		p.rasterizerState.cullMode = NONE;
		p.primitiveTopologyType = TRIANGLE;
		p.numRenderTargets = 1;
		p.rtvFormats[0] = R8G8B8A8_UNORM;
		p.dsvFormat = UNKNOWN;
		p.sampleDesc.count = 1;
		p.sampleMask = -1;
		p.inputLayout.inputElementDescs = inputLayout[0];
		p.inputLayout.numElements = inputLayout.length;

		//Driver.createGraphicsPipelineState(p);

		c.inputNames = InputNames.get([for( v in inputs ) v.name]);
		c.pipeline = p;
		c.rootSignature = sign;
		c.inputLayout = inputLayout;
		c.inputCount = inputs.length;
		c.inputOffsets = inputOffsets;
		c.shader = shader;

		for( i in 0...inputs.length )
			inputLayout[i].alignedByteOffset = 1; // will trigger error if not set in makePipeline()
	   return c;
	}

	override function getShaderInputNames() : InputNames {
		return currentShader.inputNames;
	}

	function disposeResource( r : ResourceData ) {
		frame.toRelease.push(r.res);
		r.res = null;
		r.state = PRESENT;
	}

	// ----- BUFFERS

	function allocBuffer( size : Int, heapType, state ) {
		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = BUFFER;
		desc.width = size;
		desc.height = 1;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.layout = ROW_MAJOR;
		tmp.heap.type = heapType;
		return Driver.createCommittedResource(tmp.heap, flags, desc, state, null);
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		var buf = new VertexBufferData();
		var size = (m.size * m.stride) << 2;
		buf.state = COPY_DEST;
		buf.res = allocBuffer(size, DEFAULT, COPY_DEST);
		var view = new VertexBufferView();
		view.bufferLocation = buf.res.getGpuVirtualAddress();
		view.sizeInBytes = size;
		view.strideInBytes = m.stride << 2;
		buf.view = view;
		buf.stride = m.stride;
		return buf;
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		var buf = new IndexBufferData();
		buf.state = COPY_DEST;
		buf.count = count;
		buf.bits = is32?2:1;
		var size = count << buf.bits;
		buf.res = allocBuffer(size, DEFAULT, COPY_DEST);
		var view = new IndexBufferView();
		view.bufferLocation = buf.res.getGpuVirtualAddress();
		view.format = is32 ? R32_UINT : R16_UINT;
		view.sizeInBytes = size;
		buf.view = view;
		return buf;
	}

	override function disposeVertexes(v:VertexBuffer) {
		disposeResource(v);
	}

	override function disposeIndexes(v:IndexBuffer) {
		disposeResource(v);
	}

	function updateBuffer( res : GpuResource, bytes : hl.Bytes, startByte : Int, bytesCount : Int ) {
		var tmpBuf = allocBuffer(bytesCount, UPLOAD, GENERIC_READ);
		var ptr = tmpBuf.map(0, null);
		ptr.blit(0, bytes, 0, bytesCount);
		tmpBuf.unmap(0,null);
		frame.commandList.copyBufferRegion(res, startByte, tmpBuf, 0, bytesCount);
		frame.toRelease.push(tmpBuf);
	}

	override function uploadIndexBuffer(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:hxd.IndexBuffer, bufPos:Int) {
		transition(i, COPY_DEST);
		updateBuffer(i.res, hl.Bytes.getArray(buf.getNative()).offset(bufPos << i.bits), startIndice << i.bits, indiceCount << i.bits);
		transition(i, INDEX_BUFFER);
	}

	override function uploadIndexBytes(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		transition(i, COPY_DEST);
		updateBuffer(i.res, @:privateAccess buf.b.offset(bufPos << i.bits), startIndice << i.bits, indiceCount << i.bits);
		transition(i, INDEX_BUFFER);
	}

	override function uploadVertexBuffer(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:hxd.FloatBuffer, bufPos:Int) {
		var data = hl.Bytes.getArray(buf.getNative()).offset(bufPos<<2);
		transition(v, COPY_DEST);
		updateBuffer(v.res, data, startVertex * v.stride << 2, vertexCount * v.stride << 2);
		transition(v, VERTEX_AND_CONSTANT_BUFFER);
	}

	override function uploadVertexBytes(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		transition(v, COPY_DEST);
		updateBuffer(v.res, @:privateAccess buf.b.offset(bufPos << 2), startVertex * v.stride << 2, vertexCount * v.stride << 2);
		transition(v, VERTEX_AND_CONSTANT_BUFFER);
	}

	// ------------ TEXTURES -------

	function getTextureFormat( t : h3d.mat.Texture ) : DxgiFormat {
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

	function makeTextureDesc(t:h3d.mat.Texture) {
		var desc = new ResourceDesc();
		desc.dimension = TEXTURE2D;
		desc.width = t.width;
		desc.height = t.height;
		desc.depthOrArraySize = t.layerCount;
		desc.mipLevels = t.mipLevels;
		desc.sampleDesc.count = 1;
		desc.format = getTextureFormat(t);
		return desc;
	}

	override function allocTexture(t:h3d.mat.Texture):Texture {

		if( t.format.match(S3TC(_)) && (t.width & 3 != 0 || t.height & 3 != 0) )
			throw t+" is compressed "+t.width+"x"+t.height+" but should be a 4x4 multiple";

		var isRT = t.flags.has(Target);

		var flags = new haxe.EnumFlags();
		var desc = makeTextureDesc(t);
		var td = new TextureData();
		td.format = desc.format;
		tmp.heap.type = DEFAULT;

		var clear = null;
		if( isRT ) {
			desc.flags.set(ALLOW_RENDER_TARGET);
			clear = tmp.clearValue;
			clear.format = desc.format;
			clear.color.r = 0;
			clear.color.g = 0;
			clear.color.b = 0;
			clear.color.a = 0;
		}

		td.state = isRT ? RENDER_TARGET : COPY_DEST;
		td.res = Driver.createCommittedResource(tmp.heap, flags, desc, isRT ? RENDER_TARGET : COPY_DEST, clear);
		td.res.setName(t.name == null ? "Texture#"+t.id : t.name);

		return td;
	}

	override function allocDepthBuffer(b:h3d.mat.DepthBuffer):DepthBuffer {
		var td = new DepthBufferData();
		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = TEXTURE2D;
		desc.width = b.width;
		desc.height = b.height;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.format = D24_UNORM_S8_UINT;
		desc.flags.set(ALLOW_DEPTH_STENCIL);
		tmp.heap.type = DEFAULT;

		tmp.clearValue.format = desc.format;
		tmp.clearValue.depth = 1;
		tmp.clearValue.stencil= 0;
		td.state = DEPTH_WRITE;
		td.res = Driver.createCommittedResource(tmp.heap, flags, desc, DEPTH_WRITE, tmp.clearValue);
		return td;
	}

	override function disposeTexture(t:h3d.mat.Texture) {
		disposeResource(t.t);
		t.t = null;
	}

	override function disposeDepthBuffer(b:h3d.mat.DepthBuffer) {
		disposeResource(@:privateAccess b.b);
	}

	override function uploadTextureBitmap(t:h3d.mat.Texture, bmp:hxd.BitmapData, mipLevel:Int, side:Int) {
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	}

	override function uploadTexturePixels(t:h3d.mat.Texture, pixels:hxd.Pixels, mipLevel:Int, side:Int) {
		pixels.convert(t.format);
		pixels.setFlip(false);
		if( mipLevel >= t.mipLevels ) throw "Mip level outside texture range : " + mipLevel + " (max = " + (t.mipLevels - 1) + ")";

		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = BUFFER;
		desc.width = pixels.width;
		desc.height = pixels.height;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.format = t.t.format;

		tmp.heap.type = UPLOAD;
		var subRes = mipLevel + side * t.mipLevels;
		var tmpSize = t.t.res.getRequiredIntermediateSize(subRes, 1).low;
		var tmpBuf = allocBuffer(tmpSize, UPLOAD, GENERIC_READ);

		var upd = new SubResourceData();
		var stride = @:privateAccess pixels.stride;
		upd.data = (pixels.bytes:hl.Bytes).offset(pixels.offset);
		upd.rowPitch = stride;
		upd.slicePitch = pixels.dataSize;

		transition(t.t, COPY_DEST);
		if( !Driver.updateSubResource(frame.commandList, t.t.res, tmpBuf, 0, subRes, 1, upd) )
			throw "Failed to update sub resource";
		transition(t.t, PIXEL_SHADER_RESOURCE);

		frame.toRelease.push(tmpBuf);
		t.flags.set(WasCleared);
	}

	// ----- PIPELINE UPDATE

	override function uploadShaderBuffers(buffers:h3d.shader.Buffers, which:h3d.shader.Buffers.BufferKind) {
		uploadBuffers(buffers.vertex, which, currentShader.shader.vertex, currentShader.vertexRegisters);
		uploadBuffers(buffers.fragment, which, currentShader.shader.fragment, currentShader.fragmentRegisters);
	}

	function calcCBVSize( dataSize : Int ) {
		// the view must be a mult of 256
		var sz = dataSize & ~0xFF;
		if( sz != dataSize ) sz += 0x100;
		return sz;
 	}

	function allocDynamicCBV( data : hl.Bytes, dataSize : Int ) {
		var tmpBuf = allocBuffer(calcCBVSize(dataSize), UPLOAD, GENERIC_READ);
		var ptr = tmpBuf.map(0, null);
		ptr.blit(0, data, 0, dataSize);
		tmpBuf.unmap(0,null);
		frame.toRelease.push(tmpBuf);
		return tmpBuf;
	}

	function uploadBuffers( buf : h3d.shader.Buffers.ShaderBuffers, which:h3d.shader.Buffers.BufferKind, shader : hxsl.RuntimeShader.RuntimeShaderData, regs : ShaderRegisters ) {
		switch( which ) {
		case Params:
			if( shader.paramsSize > 0 ) {
				var data = hl.Bytes.getArray(buf.params.toData());
				var dataSize = shader.paramsSize << 4;
				if( regs.params & 0x100 != 0 ) {
					// update CBV
					var srv = frame.shaderResourceViews.alloc(1);
					var cbv = allocDynamicCBV(data,dataSize);
					var desc = tmp.cbvDesc;
					desc.bufferLocation = cbv.getGpuVirtualAddress();
					desc.sizeInBytes = calcCBVSize(dataSize);
					Driver.createConstantBufferView(desc, srv);
					frame.commandList.setGraphicsRootDescriptorTable(regs.params & 0xFF, frame.shaderResourceViews.toGPU(srv));
				} else
					frame.commandList.setGraphicsRoot32BitConstants(regs.params, dataSize >> 2, data, 0);
			}
		case Globals:
			if( shader.globalsSize > 0 )
				frame.commandList.setGraphicsRoot32BitConstants(regs.globals, shader.globalsSize << 2, hl.Bytes.getArray(buf.globals.toData()), 0);
		case Textures:
			if( regs.texturesCount > 0 ) {
				var srv = frame.shaderResourceViews.alloc(regs.texturesCount);
				var sampler = frame.samplerViews.alloc(regs.texturesCount);
				for( i in 0...regs.texturesCount ) {
					var t = buf.tex[i];
					var tdesc : ShaderResourceViewDesc;
					if( t.flags.has(Cube) ) {
						var desc = tmp.texCubeSRV;
						desc.format = t.t.format;
						tdesc = desc;
					} else if( t.flags.has(IsArray) ) {
						var desc = tmp.tex2DArraySRV;
						desc.format = t.t.format;
						desc.arraySize = t.layerCount;
						tdesc = desc;
					} else {
						var desc = tmp.tex2DSRV;
						desc.format = t.t.format;
						tdesc = desc;
					}
					transition(t.t, shader.vertex ? NON_PIXEL_SHADER_RESOURCE : PIXEL_SHADER_RESOURCE);
					Driver.createShaderResourceView(t.t.res, tdesc, srv.offset(i * frame.shaderResourceViews.stride));

					var desc = tmp.samplerDesc;
					desc.filter = switch( [t.filter, t.mipMap] ) {
					case [Nearest, None|Nearest]: MIN_MAG_MIP_POINT;
					case [Nearest, Linear]: MIN_MAG_POINT_MIP_LINEAR;
					case [Linear, None|Nearest]: MIN_MAG_LINEAR_MIP_POINT;
					case [Linear, Linear]: MIN_MAG_MIP_LINEAR;
					}
					desc.addressU = desc.addressV = desc.addressW = switch( t.wrap ) {
					case Clamp: CLAMP;
					case Repeat: WRAP;
					}
					desc.mipLODBias = t.lodBias;
					Driver.createSampler(desc, sampler.offset(i * frame.samplerViews.stride));
				}

				frame.commandList.setGraphicsRootDescriptorTable(regs.textures, frame.shaderResourceViews.toGPU(srv));
				frame.commandList.setGraphicsRootDescriptorTable(regs.samplers, frame.samplerViews.toGPU(sampler));
			}
		case Buffers:
			if( buf.buffers != null && buf.buffers.length > 0 ) throw "TODO";
		}
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var sh = compiledShaders.get(shader.id);
		if( sh == null ) {
			sh = compileShader(shader);
			compiledShaders.set(shader.id, sh);
		}
		if( currentShader == sh )
			return false;
		currentShader = sh;
		needPipelineFlush = true;
		frame.commandList.setGraphicsRootSignature(currentShader.rootSignature);
		return true;
	}

	override function selectMaterial( pass : h3d.mat.Pass ) @:privateAccess {
		needPipelineFlush = true;
		pipelineSignature.setI32(PSIGN_MATID, pass.bits);
		pipelineSignature.setUI8(PSIGN_COLOR_MASK, pass.colorMask);
		var st = pass.stencil;
		if( st != null ) {
			pipelineSignature.setI32(PSIGN_STENCIL_MASK, st.maskBits);
			pipelineSignature.setI32(PSIGN_STENCIL_OPS, st.opBits);
		} else {
			pipelineSignature.setI32(PSIGN_STENCIL_MASK, 0);
			pipelineSignature.setI32(PSIGN_STENCIL_OPS, 0);
		}
	}

	override function selectBuffer(buffer:Buffer) {
		var views = tmp.vertexViews;
		var bview = @:privateAccess buffer.buffer.vbuf.view;
		for( i in 0...currentShader.inputCount ) {
			var v = views[i];
			v.bufferLocation = bview.bufferLocation;
			v.sizeInBytes = bview.sizeInBytes;
			v.strideInBytes = bview.strideInBytes;
			pipelineSignature.setUI8(PSIGN_BUF_OFFSETS + i, currentShader.inputOffsets[i]);
		}
		needPipelineFlush = true;
		frame.commandList.iaSetVertexBuffers(0, currentShader.inputCount, views[0]);
	}

	override function selectMultiBuffers(buffers:h3d.Buffer.BufferOffset) {
		var views = tmp.vertexViews;
		var bufferCount = 0;
		while( buffers != null ) {
			var v = views[bufferCount];
			var bview = @:privateAccess buffers.buffer.buffer.vbuf.view;
			v.bufferLocation = bview.bufferLocation;
			v.sizeInBytes = bview.sizeInBytes;
			v.strideInBytes = bview.strideInBytes;
			pipelineSignature.setUI8(PSIGN_BUF_OFFSETS + bufferCount, buffers.offset);
			buffers = buffers.next;
			bufferCount++;
		}
		needPipelineFlush = true;
		frame.commandList.iaSetVertexBuffers(0, bufferCount, views[0]);
	}


	static var CULL : Array<CullMode> = [NONE,BACK,FRONT,NONE];
	static var BLEND_OP : Array<BlendOp> = [ADD,SUBTRACT,REV_SUBTRACT,MIN,MAX];
	static var COMP : Array<ComparisonFunc> = [ALWAYS, NEVER, EQUAL, NOT_EQUAL, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL];
	static var BLEND : Array<Blend> = [
		ONE,ZERO,SRC_ALPHA,SRC_COLOR,DEST_ALPHA,DEST_COLOR,INV_SRC_ALPHA,INV_SRC_COLOR,INV_DEST_ALPHA,INV_DEST_COLOR,
		SRC1_COLOR,SRC1_ALPHA,INV_SRC1_COLOR,INV_SRC1_ALPHA,SRC_ALPHA_SAT
	];
	static var BLEND_ALPHA : Array<Blend> = [
		ONE,ZERO,SRC_ALPHA,SRC_ALPHA,DEST_ALPHA,DEST_ALPHA,INV_SRC_ALPHA,INV_SRC_ALPHA,INV_DEST_ALPHA,INV_DEST_ALPHA,
		SRC1_ALPHA,SRC1_ALPHA,INV_SRC1_ALPHA,INV_SRC1_ALPHA,SRC_ALPHA_SAT,
	];

	function makePipeline( shader : CompiledShader ) {
		var p = shader.pipeline;
		var passBits = pipelineSignature.getI32(PSIGN_MATID);
		var colorMask = pipelineSignature.getUI8(PSIGN_COLOR_MASK);
		var stencilMask = pipelineSignature.getI32(PSIGN_STENCIL_MASK) & 0xFFFFFF;
		var stencilOp = pipelineSignature.getI32(PSIGN_STENCIL_OPS);

		var csrc = Pass.getBlendSrc(passBits);
		var cdst = Pass.getBlendDst(passBits);
		var asrc = Pass.getBlendAlphaSrc(passBits);
		var adst = Pass.getBlendAlphaDst(passBits);
		var cop = Pass.getBlendOp(passBits);
		var aop = Pass.getBlendAlphaOp(passBits);
		var dw = Pass.getDepthWrite(passBits);
		var cmp = Pass.getDepthTest(passBits);
		var cull = Pass.getCulling(passBits);
		var wire = Pass.getWireframe(passBits);
		if( wire != 0 ) cull = 0;

		var rtCount = p.numRenderTargets;
		if( rtCount == 0 ) rtCount = 1;

		p.numRenderTargets = rtCount;
		p.rasterizerState.cullMode = CULL[cull];
		p.rasterizerState.fillMode = wire == 0 ? SOLID : WIREFRAME;
		p.depthStencilDesc.depthEnable = cmp != 0;
		p.depthStencilDesc.depthWriteMask = dw == 0 || !depthEnabled ? ZERO : ALL;
		p.depthStencilDesc.depthFunc = COMP[cmp];

		var bl = p.blendState;
		for( i in 0...rtCount ) {
			var t = bl.renderTargets[i];
			t.blendEnable = csrc != 0 || cdst != 1;
			t.srcBlend = BLEND[csrc];
			t.dstBlend = BLEND[cdst];
			t.srcBlendAlpha = BLEND_ALPHA[asrc];
			t.dstBlendAlpha = BLEND_ALPHA[adst];
			t.blendOp = BLEND_OP[cop];
			t.blendOpAlpha = BLEND_OP[aop];
			t.renderTargetWriteMask = colorMask;

			var t = currentRenderTargets[i];
			p.rtvFormats[i] = t == null ? R8G8B8A8_UNORM : t.t.format;
		}
		p.dsvFormat = depthEnabled ? D24_UNORM_S8_UINT : UNKNOWN;

		for( i in 0...shader.inputCount ) {
			var d = shader.inputLayout[i];
			d.alignedByteOffset = pipelineSignature.getUI8(PSIGN_BUF_OFFSETS + i) << 2;
		}

		if( stencilMask != 0 || stencilOp != 0 ) throw "TODO:stencil";

		return Driver.createGraphicsPipelineState(p);
	}

	function flushPipeline() {
		if( !needPipelineFlush ) return;
		needPipelineFlush = false;
		var signature = pipelineSignature;
		var signatureSize = PSIGN_BUF_OFFSETS + currentShader.inputCount;
		hl.Format.digest(adlerOut, signature, signatureSize, 3);
		var hash = adlerOut.getI32(0);
		var pipes = currentShader.pipelines.get(hash);
		if( pipes == null )
			pipes = new hl.NativeArray(1);
		var insert = -1;
		for( i in 0...pipes.length ) {
			var p = pipes[i];
			if( p == null ) {
				insert = i;
				break;
			}
			if( p.size == signatureSize && p.bytes.compare(0, signature, 0, signatureSize) == 0 ) {
				frame.commandList.setPipelineState(p.pipeline);
				return;
			}
		}
		if( insert < 0 ) {
			var pipes2 = new hl.NativeArray(pipes.length + 1);
			pipes2.blit(0, pipes, 0, insert);
			currentShader.pipelines.set(hash, pipes2);
			pipes = pipes2;
		}
		var cp = new CachedPipeline();
		cp.bytes = signature.sub(0, signatureSize);
		cp.size = signatureSize;
		cp.pipeline = makePipeline(currentShader);
		pipes[insert] = cp;
		frame.commandList.setPipelineState(cp.pipeline);
	}

	// --- DRAW etc.

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		flushPipeline();
		frame.commandList.iaSetIndexBuffer(ibuf.view);
		frame.commandList.drawIndexedInstanced(ibuf.count,1,0,0,0);
		if( frame.shaderResourceViews.available < 128 || frame.samplerViews.available < 64 ) {
			var arr = tmp.descriptors2;
			arr[0] = frame.shaderResourceViews.grow(function(prev) frame.toRelease.push(prev));
			arr[1] = frame.samplerViews.grow(function(prev) frame.toRelease.push(prev));
			frame.commandList.setDescriptorHeaps(arr);
		}
	}

	function flushFrame() {

		// necessary even if we don't present so we don't get an error at begin frame
		var barrier = tmp.barrier;
		barrier.resource = frame.backBuffer;
		barrier.subResource = -1;
		barrier.stateBefore = RENDER_TARGET;
		barrier.stateAfter = PRESENT;
		frame.commandList.resourceBarrier(barrier);

		frame.commandList.close();
		frame.commandList.execute();
		currentShader = null;
		Driver.flushMessages();
		frame.fenceValue = fenceValue++;
		Driver.signal(fence, frame.fenceValue);
	}

	override function present() {
		flushFrame();
		Driver.present(window.vsync);

		waitForFrame(Driver.getCurrentBackBufferIndex());
		beginFrame();

		if( hasDeviceError ) {
			Sys.println("----------- OnContextLost ----------");
			hasDeviceError = false;
			dispose();
			reset();
			onContextLost();
		}

	}

	function waitForFrame( index : Int ) {
		var frame = frames[index];
		if( fence.getValue() < frame.fenceValue ) {
			fence.setEvent(frame.fenceValue, fenceEvent);
			fenceEvent.wait(-1);
		}
	}

}

#end
