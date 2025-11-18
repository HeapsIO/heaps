package h3d.impl;

#if (hldx && dx12)

import h3d.impl.Driver;
import dx.Dx12;
import haxe.Int64;
import h3d.mat.Pass;
import h3d.mat.Stencil;

private typedef Driver = Dx12;

class TempBuffer {
	public var next : TempBuffer;
	public var buffer : GpuResource;
	public var size : Int;
	public var lastUse : Int;
	public function new() {
	}
	public inline function count() {
		var b = this;
		var k = 0;
		while( b != null ) {
			k++;
			b = b.next;
		}
		return k;
	}
}

class ManagedHeapArray {

	var heaps : Array<ManagedHeap>;
	var type : DescriptorHeapType;
	var size : Int;
	var cursor : Int;

	public function new(type,size) {
		this.type = type;
		this.size = size;
		heaps = [];
	}

	public function reset() {
		cursor = 0;
	}

	public function next() {
		var h = heaps[cursor++];
		if( h == null ) {
			h = new ManagedHeap(type, size);
			heaps.push(h);
		} else
			h.clear();
		return h;
	}

}

@:struct class BumpAllocation {
	public var resource : GpuResource = null;
	public var cpuAddress : hl.Bytes = null;
	public var offset : Int = 0;
	public var byteSize : Int = 0;
	public function new() {
	}
}

class BumpAllocator {
	var resource : GpuResource;
	var capacity : Int;
	var cpuAddress : hl.Bytes;
	var heap : HeapProperties;
	var offset : Int = 0;
	var next : BumpAllocator;

	public function new( size : Int ) {
		this.capacity = size;
		heap = new HeapProperties();
		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = BUFFER;
		desc.width = capacity;
		desc.height = 1;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.layout = ROW_MAJOR;
		heap.type = UPLOAD;
		resource = Driver.createCommittedResource(heap, flags, desc, GENERIC_READ, null);
		cpuAddress = resource.map(0, null);
	}

	public function reset() {
		offset = 0;
		if ( next != null) {
			next.release();
			next = null;
		}
	}

	public function release() {
		resource.release();
		resource = null;
		offset = 0;
		capacity = 0;
		heap = null;
		cpuAddress = null;
		if ( next != null) {
			next.release();
			next = null;
		}
	}

	public inline function alloc( size : Int, alignment = 256, allocation : BumpAllocation ) {
		var sz = size & ~(alignment - 1);
		if( sz != size ) sz += alignment;
		return tryAlloc(sz, alignment, allocation);
	}

	function tryAlloc( size, alignment = 256, allocation : BumpAllocation ) {
		var offsetAligned = offset & ~(alignment - 1);
		if( offsetAligned != offset ) offsetAligned += alignment;
		var newOffset = size + offsetAligned;
		if ( newOffset > capacity ) {
			if ( next == null )
				next = new BumpAllocator(hxd.Math.imax(Std.int(capacity*3/2), size));
			return next.tryAlloc(size, alignment, allocation);
		}
		allocation.byteSize = size;
		allocation.offset = offsetAligned;
		allocation.cpuAddress = cpuAddress.offset(offsetAligned);
		allocation.resource = resource;
		offset = newOffset;
		return allocation;
	}
}

class DxFrame {
	public var backBuffer : ResourceData;
	public var backBufferView : Address;
	public var depthBuffer : GpuResource;
	public var allocator : CommandAllocator;
	public var commandList : CommandList;
	public var fenceValue : Int64;
	public var toRelease : Array<Resource> = [];
	public var tmpBufToNullify : Array<Texture> = [];
	public var tmpBufToRelease : Array<dx.Dx12.GpuResource> = [];
	public var shaderResourceViews : ManagedHeap;
	public var samplerViews : ManagedHeap;
	public var shaderResourceCache : ManagedHeapArray;
	public var samplerCache : ManagedHeapArray;
	public var availableBuffers : TempBuffer;
	public var usedBuffers : TempBuffer;
	public var queryHeaps : Array<QueryHeap> = [];
	public var queriesPending : Array<Query> = [];
	public var queryCurrentHeap : Int;
	public var queryHeapOffset : Int;
	public var queryBuffer : GpuResource;
	public var bumpAllocator : BumpAllocator;
	public function new() {
	}
}

class ShaderRegisters {
	public var globals : Int;
	public var params : Int;
	public var buffers : Int;
	public var cbvCount : Int;
	public var storageCount : Int;
	public var textures : Int;
	public var samplers : Int;
	public var texturesCount : Int;
	public var texturesTypes : Array<hxsl.Ast.Type>;
	public var bufferTypes : Array<hxsl.Ast.BufferKind>;
	public var bufferStrides : Array<Int>;
	public var srv : Address;
	public var samplersView : Address;
	public var lastHeapCount : Int;
	public var lastTextures : Array<Texture> = [];
	public var lastTexturesBits : Array<Int>= [];
	public function new() {
	}
}

class CompiledShader {
	public var vertexRegisters : ShaderRegisters;
	public var fragmentRegisters : ShaderRegisters;
	public var format : hxd.BufferFormat;
	public var pipeline : GraphicsPipelineStateDesc;
	public var pipelines : PipelineCache<GraphicsPipelineState> = new PipelineCache();
	public var rootSignature : RootSignature;
	public var inputLayout : hl.CArray<InputElementDesc>;
	public var inputCount : Int;
	public var shader : hxsl.RuntimeShader;
	public var isCompute : Bool;
	public var computePipeline : ComputePipelineState;
	public function new() {
	}
}

@:struct class SrvArgs {
	public var res : GpuResource;
	@:packed public var resourceDesc : Tex2DSRV;
	@:packed public var samplerDesc : SamplerDesc;
	public var srvAddr : Address;
	public var samplerAddr : Address;
}

@:struct class TempObjects {

	public var renderTargets : hl.BytesAccess<Address>;
	public var depthStencils : hl.BytesAccess<Address>;
	public var copyableInfosBytes : hl.Bytes;
	public var vertexViews : hl.CArray<VertexBufferView>;
	public var descriptors2 : hl.NativeArray<DescriptorHeap>;
	public var barriers : hl.CArray<ResourceBarrier>;
	public var resourcesToTransition : hl.NativeArray<ResourceData>;
	public var maxBarriers : Int;
	public var barrierCount : Int;
	@:packed public var heap(default,null) : HeapProperties;
	@:packed public var barrier(default,null) : ResourceBarrier;
	@:packed public var clearColor(default,null) : ClearColor;
	@:packed public var clearValue(default,null) : ClearValue;
	@:packed public var viewport(default,null) : Viewport;
	@:packed public var rect(default,null) : Rect;
	@:packed public var bufferSRV(default,null) : BufferSRV;
	@:packed public var samplerDesc(default,null) : SamplerDesc;
	@:packed public var vertexGlobalDesc(default,null) : ConstantBufferViewDesc;
	@:packed public var fragmentGlobalDesc(default,null) : ConstantBufferViewDesc;
	@:packed public var cbvDesc(default,null) : ConstantBufferViewDesc;
	@:packed public var rtvDesc(default,null) : RenderTargetViewDesc;
	@:packed public var uavDesc(default,null) : UAVBufferViewDesc;
	@:packed public var wtexDesc(default,null) : UAVTextureViewDesc;
	@:packed public var subResourceData(default, null) : SubResourceData;
	@:packed public var bumpAllocation(default,null) : BumpAllocation;
	@:packed public var srcTextureLocation(default, null) : TextureCopyLocation;
	@:packed public var dstTextureLocation(default, null) : TextureCopyLocation;

	public var pass : h3d.mat.Pass;

	public function new() {
		renderTargets = new hl.Bytes(8 * 8);
		depthStencils = new hl.Bytes(8);
		copyableInfosBytes = new hl.Bytes(8 * 3);
		vertexViews = hl.CArray.alloc(VertexBufferView, 16);
		maxBarriers = 100;
		barriers = hl.CArray.alloc( ResourceBarrier, maxBarriers );
		var allSubresource = #if (hldx >= version("1.16.0")) Driver.getConstant(RESOURCE_BARRIER_ALL_SUBRESOURCES) #else 0xffffffff #end;
		for ( i in 0...maxBarriers )
			barriers[i].subResource = allSubresource;
		resourcesToTransition = new hl.NativeArray(maxBarriers);
		barrierCount = 0;
		pass = new h3d.mat.Pass("default");
		pass.stencil = new h3d.mat.Stencil();
		bufferSRV.dimension = BUFFER;
		bufferSRV.flags = RAW;
		bufferSRV.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
		samplerDesc.comparisonFunc = NEVER;
		samplerDesc.maxLod = 1e30;
		descriptors2 = new hl.NativeArray(2);
		uavDesc.viewDimension = BUFFER;
		barrier.subResource = -1; // all
	}

}

class ManagedHeap {

	public var stride(default,null) : Int;
	var size : Int;
	var cursor : Int;
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
		cursor = 0;
		this.size = size;
		address = heap.getHandle(false);
		cpuToGpu = desc.flags == SHADER_VISIBLE ? ( heap.getHandle(true).value - address.value ) : 0;
	}

	public dynamic function onFree( prev : DescriptorHeap ) {
		throw "Too many buffers";
	}

	public function alloc( count : Int ) {
		if( cursor + count > size ) {
			cursor = 0;
			var prev = heap;
			allocHeap((size * 3) >> 1);
			onFree(prev);
		}
		var pos = cursor;
		cursor += count;
		return address.offset(pos * stride);
	}

	inline function get_available() {
		return size - cursor;
	}

	public function clear() {
		cursor = 0;
	}

	public inline function toGPU( address : Address ) : Address {
		return new Address(address.value + cpuToGpu);
	}

}

class ResourceData {
	public var res : GpuResource;
	public var state : ResourceState;
	public var targetState : ResourceState;
	public function new() {
	}
}

class VertexBufferData extends ResourceData {
	public var view : dx.Dx12.VertexBufferView;
	public var iview : dx.Dx12.IndexBufferView;
	public var size : Int;
}

class TextureUploadBuffer {
	public var tmpBuf : dx.Dx12.GpuResource;
	public var lastMipMapUploadPerSide : hl.Bytes;
	public function new() {
	}
}

class TextureData extends ResourceData {
	public var format : DxgiFormat;
	public var color : h3d.Vector4;
	public var uploadBuffer : TextureUploadBuffer;
	var clearColorChanges : Int;
	public function setClearColor( c : h3d.Vector4 ) {
		var color = color;
		if( clearColorChanges > 10 || (color.r == c.r && color.g == c.g && color.b == c.b && color.a == c.a) )
			return false;
		clearColorChanges++;
		color.load(c);
		return true;
	}
}

class QueryData {
	public var heap : Int;
	public var offset : Int;
	public var result : Float;
	public function new() {
	}
}

class DX12Driver extends h3d.impl.Driver {

	var pipelineBuilder = new PipelineCache.PipelineBuilder();

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
	var indirectCommand : CommandSignature;

	var currentFrame : Int;
	var fenceValue : Int64 = 0;
	var currentPass : h3d.mat.Pass;

	var currentWidth : Int;
	var currentHeight : Int;

	var currentShader : CompiledShader;
	var compiledShaders : Map<Int,CompiledShader> = new Map();
	var compiler : ShaderCompiler;
	var currentIndex : Buffer;

	var tmp : TempObjects;
	var currentRenderTargets : Array<h3d.mat.Texture> = [];
	var defaultDepth : h3d.mat.Texture;
	var depthEnabled = true;
	var curStencilRef : Int = -1;
	var lastRtvDesc : RenderTargetViewDesc;
	var rtWidth : Int;
	var rtHeight : Int;
	var frameCount : Int;
	var tsFreq : haxe.Int64;
	var heapCount : Int;
	var currentPipelineState : PipelineState;
	var lastVertexGlobalBind : Int = -1;
	var lastFragmentGlobalBind : Int = -1;
	var useDepthClamp : Bool = false;

	public static var INITIAL_RT_COUNT = 1024;
	public static var INITIAL_SRV_COUNT = 1024;
	public static var INITIAL_SAMPLER_COUNT = 1024;
	public static var INITIAL_BUMP_ALLOCATOR_SIZE = 2 * 1024 * 1024;
	public static var BUFFER_COUNT = #if console 3 #else 2 #end;
	public static var DEVICE_NAME = null;
	public static var DEBUG = false; // requires dxil.dll when set to true

	public function new() {
		window = @:privateAccess dx.Window.windows[0];
		reset();
	}

	override function hasFeature(f:Feature) {
		return switch(f) {
		case Queries, BottomLeftCoords:
			false;
		default:
			true;
		};
	}

	override function isSupportedFormat(fmt:h3d.mat.Data.TextureFormat):Bool {
		return true;
	}

	function reset() {
		var flags = new DriverInitFlags();
		if( DEBUG ) flags.set(DriverInitFlag.DEBUG);
		driver = Driver.create(window, flags, DEVICE_NAME);
		frames = [];
		for(i in 0...BUFFER_COUNT) {
			var f = new DxFrame();
			f.backBuffer = new ResourceData();
			f.allocator = new CommandAllocator(DIRECT);
			f.commandList = new CommandList(DIRECT, f.allocator, null);
			f.commandList.close();
			f.shaderResourceCache = new ManagedHeapArray(CBV_SRV_UAV, INITIAL_SRV_COUNT);
			f.samplerCache = new ManagedHeapArray(SAMPLER, INITIAL_SAMPLER_COUNT);
			if ( f.bumpAllocator != null )
				f.bumpAllocator.release();
			f.bumpAllocator = new BumpAllocator(INITIAL_BUMP_ALLOCATOR_SIZE);
			frames.push(f);
		}
		fence = new Fence(0, NONE);
		fenceEvent = new WaitEvent(false);
		tmp = new TempObjects();

		renderTargetViews = new ManagedHeap(RTV, INITIAL_RT_COUNT);
		depthStenciViews = new ManagedHeap(DSV, INITIAL_RT_COUNT);
		renderTargetViews.onFree = function(prev) frame.toRelease.push(prev);
		depthStenciViews.onFree = function(prev) frame.toRelease.push(prev);
		if ( h3d.Engine.getCurrent() != null ) {
			defaultDepth = new h3d.mat.Texture(0,0, Depth24Stencil8);
			defaultDepth.t = new TextureData();

			defaultDepth.t.state = defaultDepth.t.targetState = DEPTH_WRITE;
			defaultDepth.name = "defaultDepth";
		}



		var desc = new CommandSignatureDesc();
		var adesc = hl.CArray.alloc(IndirectArgumentDesc, 1);
		desc.byteStride = 5 * 4;
		desc.numArgumentDescs = 1;
		desc.argumentDescs = adesc;
		adesc[0].type = DRAW_INDEXED;
		indirectCommand = Driver.createCommandSignature(desc,null);

		tsFreq = Driver.getTimestampFrequency();

		compiler = new ShaderCompiler();
		resize(window.width, window.height);
	}

	function beginFrame() {
		frameCount = hxd.Timer.frameCount;
		heapCount++;
		currentFrame = Driver.getCurrentBackBufferIndex();
		var prevFrame = frame;
		frame = frames[currentFrame];
		defaultDepth.t.res = frame.depthBuffer;
		frame.allocator.reset();
		frame.commandList.reset(frame.allocator, null);
		frame.bumpAllocator.reset();
		while( frame.toRelease.length > 0 )
			frame.toRelease.pop().release();
		while( frame.tmpBufToRelease.length > 0 ) {
			var tmpBuf = frame.tmpBufToRelease.pop();
			if ( tmpBuf != null )
				tmpBuf.release();
		}
		if ( prevFrame != null ) {
			while ( prevFrame.tmpBufToNullify.length > 0 ) {
				var t = prevFrame.tmpBufToNullify.pop();
				t.uploadBuffer = null;
			}
		}
		beginQueries();

		var used = frame.usedBuffers;
		var b = frame.availableBuffers;
		var prev = null;
		while( b != null ) {
			if( b.lastUse < frameCount - 120 ) {
				b.buffer.release();
				b = b.next;
			} else {
				var n = b.next;
				b.next = used;
				used = b;
				b = n;
			}
		}
		frame.availableBuffers = used;
		frame.usedBuffers = null;

		transition(frame.backBuffer, RENDER_TARGET);
		frame.commandList.iaSetPrimitiveTopology(TRIANGLELIST);

		renderTargetViews.clear();
		depthStenciViews.clear();
		curStencilRef = -1;
		currentIndex = null;

		frame.backBufferView = renderTargetViews.alloc(1);
		Driver.createRenderTargetView(frame.backBuffer.res, null, frame.backBufferView);
		setRenderTarget(null);

		frame.shaderResourceCache.reset();
		frame.samplerCache.reset();
		frame.shaderResourceViews = frame.shaderResourceCache.next();
		frame.samplerViews = frame.samplerCache.next();

		var arr = tmp.descriptors2;
		arr[0] = @:privateAccess frame.shaderResourceViews.heap;
		arr[1] = @:privateAccess frame.samplerViews.heap;
		frame.commandList.setDescriptorHeaps(arr);
	}

	override function clear(?color:Vector4, ?depth:Float, ?stencil:Int) {
		flushTransitions();
		if( color != null ) {
			var clear = tmp.clearColor;
			clear.r = color.r;
			clear.g = color.g;
			clear.b = color.b;
			clear.a = color.a;
			var count = currentRenderTargets.length;
			var needRebind = false;
			for( i in 0...count ) {
				var tex = currentRenderTargets[i];
				if( tex != null && tex.t.setClearColor(color) ) {
					needRebind = true;
					// update texture to use another clear value
					var prev = tex.t;
					tex.t = allocTexture(tex);
					@:privateAccess tex.t.clearColorChanges = prev.clearColorChanges;
					frame.toRelease.push(prev.res);
					Driver.createRenderTargetView(tex.t.res, lastRtvDesc, tmp.renderTargets[i]);
				}
				tex.flags.set(WasCleared);
				frame.commandList.clearRenderTargetView(tmp.renderTargets[i], clear);
			}
			if ( needRebind )
				frame.commandList.omSetRenderTargets(count, tmp.renderTargets, true, depthEnabled ? getDepthViewFromTexture(currentRenderTargets[0], currentRenderTargets[0].depthBuffer.t.state & DEPTH_WRITE == COMMON ) : null);
			// clear backbuffer
			if( count == 0 )
				frame.commandList.clearRenderTargetView(frame.backBufferView, clear);
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

		if( defaultDepth == null || (currentWidth == width && currentHeight == height) )
			return;

		currentWidth = rtWidth = width;
		currentHeight = rtHeight = height;
		@:privateAccess defaultDepth.width = width;
		@:privateAccess defaultDepth.height = height;

		if( frame != null )
			flushFrame(true);

		waitGpu();

		for( f in frames ) {
			if( f.backBuffer.res != null ) {
				if ( f.backBuffer.targetState != f.backBuffer.state )
					cancelTransition(f.backBuffer);
				f.backBuffer.res.release();
			}
			if( f.depthBuffer != null )
				f.depthBuffer.release();
		}

		Driver.resize(width, height, BUFFER_COUNT, R8G8B8A8_UNORM);

		renderTargetViews.clear();
		depthStenciViews.clear();

		for( i => f in frames ) {
			f.backBuffer.res = Driver.getBackBuffer(i);
			f.backBuffer.res.setName("Backbuffer#"+i);
			f.backBuffer.state = f.backBuffer.targetState = PRESENT;

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
		if( details ) desc += " "+Driver.getDeviceName();
		return desc;
	}

	public function forceDeviceError() {
		hasDeviceError = true;
	}

	inline function cancelTransition( res : ResourceData ) {
		var found = false;
		for (i in 0...tmp.barrierCount) {
			if (tmp.resourcesToTransition[i] == res) {
				tmp.barrierCount -= 1;
				for (j in i...tmp.barrierCount) {
					tmp.resourcesToTransition[j] = tmp.resourcesToTransition[j + 1];
				}
				found = true;
				break;
			}
		}
		if (!found)
			throw "Resource not found";
		res.targetState = res.state;
	}

	function transition( res : ResourceData, to : ResourceState ) {
		if( res.targetState == to )
			return;

		if ( res.state == to ) {
			cancelTransition(res);
			return;
		}

		if( tmp.maxBarriers == tmp.barrierCount) {
			flushTransitions();
			tmp.maxBarriers += 100;
			tmp.barriers = hl.CArray.alloc(ResourceBarrier, tmp.maxBarriers);
			var allSubresource = #if (hldx >= version("1.16.0")) Driver.getConstant(RESOURCE_BARRIER_ALL_SUBRESOURCES) #else 0xffffffff #end;
			for ( i in 0...tmp.maxBarriers )
				tmp.barriers[i].subResource = allSubresource;
			tmp.resourcesToTransition = new hl.NativeArray<ResourceData>(tmp.maxBarriers);
		}

		// If state is different from targetState, a barrier has already been requested so we just have to update the targetState
		if (res.state == res.targetState)
			tmp.resourcesToTransition[tmp.barrierCount++] = res;
		res.targetState = to;
	}

	function flushTransitions() {
		if (tmp.barrierCount > 0) {
			var totalBarrier = 0;
			for (i in 0...tmp.barrierCount) {
				var res = tmp.resourcesToTransition[i];

				// Resource has been disposed
				if (res.res == null)
					continue;

				var b = tmp.barriers[totalBarrier];
				b.resource = res.res;
				b.stateBefore = res.state;
				b.stateAfter = res.targetState;
				res.state = res.targetState;
				totalBarrier++;
			}
			if (totalBarrier > 0)
				#if (hldx >= version("1.15.0"))
				frame.commandList.resourceBarriers(tmp.barriers, totalBarrier);
				#else
				for (i in 0...totalBarrier)
					frame.commandList.resourceBarrier(tmp.barriers[i]);
				#end
			tmp.barrierCount = 0;
		}
	}

	function getDepthViewFromTexture( tex : h3d.mat.Texture, readOnly : Bool ) {
		if ( tex != null && tex.depthBuffer == null ) {
			depthEnabled = false;
			return null;
		}
		if ( tex != null ) {
			var w = tex.depthBuffer.width;
			var h = tex.depthBuffer.height;
			if( w != tex.width || h != tex.height )
				throw "Depth size mismatch";
		}
		return getDepthView(tex == null ? null : tex.depthBuffer, readOnly);
	}

	function getDepthView( depthBuffer : h3d.mat.Texture, readOnly : Bool ) {
		if ( depthBuffer == null )
			depthBuffer = getDefaultDepthBuffer();
		var depthView = depthStenciViews.alloc(1);
		var viewDesc = new DepthStencilViewDesc();
		viewDesc.arraySize = 1;
		viewDesc.mipSlice = 0;
		viewDesc.firstArraySlice = 0;
		viewDesc.format = toDxgiDepthFormat(depthBuffer.format);
		viewDesc.viewDimension = TEXTURE2D;
		if ( readOnly ) {
			viewDesc.flags.set(READ_ONLY_DEPTH);
			viewDesc.flags.set(READ_ONLY_STENCIL);
		}
		Driver.createDepthStencilView(depthBuffer.t.res, viewDesc, depthView);
		var depths = tmp.depthStencils;
		depths[0] = depthView;
		depthEnabled = true;
		var acceptedState = readOnly ? DEPTH_READ | DEPTH_WRITE : DEPTH_WRITE;
		if ( depthBuffer.t.state & acceptedState == COMMON )
			transition(depthBuffer.t, readOnly ? DEPTH_READ : DEPTH_WRITE);
		return depths;
	}

	override function getDefaultDepthBuffer():h3d.mat.Texture {
		return defaultDepth;
	}

	function initViewport(w,h) {
		rtWidth = w;
		rtHeight = h;
		tmp.viewport.width = w;
		tmp.viewport.height = h;
		tmp.viewport.maxDepth = 1;
		tmp.rect.top = 0;
		tmp.rect.left = 0;
		tmp.rect.right = w;
		tmp.rect.bottom = h;
		frame.commandList.rsSetScissorRects(1, tmp.rect);
		frame.commandList.rsSetViewports(1, tmp.viewport);
	}

	override function setRenderTarget(tex:Null<h3d.mat.Texture>, layer:Int = 0, mipLevel:Int = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite) {

		if( tex != null ) {
			if( tex.t == null ) tex.alloc();
			transition(tex.t, RENDER_TARGET);
		}

		depthEnabled = depthBinding != NotBound;

		var isArr = tex != null && (tex.flags.has(IsArray) || tex.flags.has(Cube));
		var is3D = tex != null && tex.flags.has(Is3D);
		var desc = null;
		if( layer != 0 || mipLevel != 0 || isArr || is3D ) {
			desc = tmp.rtvDesc;
			desc.format = tex.t.format;
			if( isArr ) {
				desc.viewDimension = TEXTURE2DARRAY;
				desc.mipSlice = mipLevel;
				desc.firstArraySlice = layer;
				desc.arraySize = 1;
				desc.planeSlice = 0;
			} else if ( is3D ) {
				desc.viewDimension = TEXTURE3D;
				desc.mipSlice = mipLevel;
				desc.firstArraySlice = layer;
				desc.arraySize = 1;
				desc.planeSlice = 0;
			} else {
				desc.viewDimension = TEXTURE2D;
				desc.mipSlice = mipLevel;
				desc.planeSlice = 0;
			}
		}
		lastRtvDesc = desc;
		if (tex != null) {
			var texView = renderTargetViews.alloc(1);
			Driver.createRenderTargetView(tex.t.res, desc, texView);
			tmp.renderTargets[0] = texView;
		}
		else {
			tmp.renderTargets[0] = frame.backBufferView;
		}

		if ( tex != null && !tex.flags.has(WasCleared) ) {
			tex.flags.set(WasCleared);
			var clear = tmp.clearColor;
			clear.r = 0;
			clear.g = 0;
			clear.b = 0;
			clear.a = 0;
			flushTransitions();
			frame.commandList.clearRenderTargetView(tmp.renderTargets[0], clear);
		}
		frame.commandList.omSetRenderTargets(1, tmp.renderTargets, true, depthEnabled ? getDepthViewFromTexture(tex, depthBinding == ReadOnly ) : null);

		while( currentRenderTargets.length > 0 ) currentRenderTargets.pop();
		if( tex != null ) currentRenderTargets.push(tex);

		var w = tex == null ? currentWidth : tex.width >> mipLevel;
		var h = tex == null ? currentHeight : tex.height >> mipLevel;
		if( w == 0 ) w = 1;
		if( h == 0 ) h = 1;
		initViewport(w, h);
		pipelineBuilder.setRenderTarget(tex, depthEnabled);
	}

	function toDxgiDepthFormat( format : hxd.PixelFormat ) {
		switch( format ) {
			case null:
				return cast 0;
			case Depth16:
				return  D16_UNORM;
			case Depth24Stencil8, Depth24:
				return  D24_UNORM_S8_UINT;
			case Depth32:
				return  D32_FLOAT;
			default:
				throw "Unsupported depth format "+ format;
		}
	}

	override function setRenderTargets(textures:Array<h3d.mat.Texture>, depthBinding : h3d.Engine.DepthBinding = ReadWrite) {
		while( currentRenderTargets.length > textures.length )
			currentRenderTargets.pop();

		depthEnabled = depthBinding != NotBound;

		lastRtvDesc = null;

		var t0 = textures[0];
		var texViews = renderTargetViews.alloc(textures.length);
		for( i => t in textures ) {
			if ( t.t == null ) {
				t.alloc();
				if ( hasDeviceError ) return;
			}
			var view = texViews.offset(renderTargetViews.stride * i);
			Driver.createRenderTargetView(t.t.res, null, view);
			tmp.renderTargets[i] = view;
			currentRenderTargets[i] = t;
			transition( t.t, RENDER_TARGET);
			if ( !t.flags.has(WasCleared) ) {
				t.flags.set(WasCleared);
				var clear = tmp.clearColor;
				clear.r = 0;
				clear.g = 0;
				clear.b = 0;
				clear.a = 0;
				flushTransitions();
				frame.commandList.clearRenderTargetView(tmp.renderTargets[i], clear);
			}
		}
		frame.commandList.omSetRenderTargets(textures.length, tmp.renderTargets, true, depthEnabled ? getDepthViewFromTexture(t0, depthBinding == ReadOnly) : null);
		initViewport(t0.width, t0.height);

		pipelineBuilder.setRenderTargets(textures, depthEnabled);
	}

	override function setDepth(depthBuffer : h3d.mat.Texture) {
		var view = getDepthView(depthBuffer, false);
		depthEnabled = true;
		frame.commandList.omSetRenderTargets(0, null, true, view);

		while( currentRenderTargets.length > 0 ) currentRenderTargets.pop();

		initViewport(depthBuffer.width, depthBuffer.height);
		pipelineBuilder.setDepth(depthBuffer);
	}

	override function setDepthClamp( enabled : Bool ) {
		useDepthClamp = enabled;
	}

	override function setDepthBias( depthBias : Float, slopeScaledBias : Float ) {
		pipelineBuilder.setDepthBias(depthBias, slopeScaledBias);
	}

	override function setRenderZone(x:Int, y:Int, width:Int, height:Int) {
		if( width < 0 && height < 0 && x == 0 && y == 0 ) {
			tmp.rect.left = 0;
			tmp.rect.top = 0;
			tmp.rect.right = rtWidth;
			tmp.rect.bottom = rtHeight;
			frame.commandList.rsSetScissorRects(1, tmp.rect);
		} else {
			tmp.rect.left = x;
			tmp.rect.top = y;
			tmp.rect.right = x + width;
			tmp.rect.bottom = y + height;
			frame.commandList.rsSetScissorRects(1, tmp.rect);
		}
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		var rt = currentRenderTargets[0];
		if( rt == null )
			throw "Can't capture main render buffer in DirectX";
		captureTexPixels(pixels, rt, 0, 0);
	}

	override function capturePixels(tex:h3d.mat.Texture, layer:Int, mipLevel:Int, ?region:h2d.col.IBounds):hxd.Pixels {
		var pixels : hxd.Pixels;
		var oldRTs = [for ( rt in currentRenderTargets) rt];
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

		if(oldRTs.length > 0){
			setRenderTargets(oldRTs);
		}

		return pixels;
	}

	function captureTexPixels( pixels: hxd.Pixels, tex:h3d.mat.Texture, layer:Int, mipLevel:Int, x : Int = 0, y : Int = 0)  {

		if( pixels.width == 0 || pixels.height == 0 )
			return;

		var totalSize : hl.BytesAccess<Int64> = tmp.copyableInfosBytes;
		var src = tmp.srcTextureLocation;
		src.res = tex.t.res;
		src.type = SUBRESOURCE_INDEX;
		src.subResourceIndex = mipLevel + layer * tex.mipLevels;
		var srcDesc = makeTextureDesc(tex);

		var dst = tmp.dstTextureLocation;
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
		flushTransitions();
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

	function getBinaryPayload( code : String, profile ) {
		var bin = code.indexOf("//BIN=");
		if( bin >= 0 ) {
			var end = code.indexOf("#", bin);
			if( end >= 0 )
				return haxe.crypto.Base64.decode(code.substr(bin + 6, end - bin - 6));
		}
		if( shaderCache != null )
			return shaderCache.resolveShaderBinary(code, profile);
		return null;
	}

	static final SHADER_ARGS : Array<String>= [/*"-Zi"*/];
	function compileSource( sh : hxsl.RuntimeShader.RuntimeShaderData, profile, baseRegister, rootStr = "" ) {
		var out = new hxsl.HlslOut();
		out.baseRegister = baseRegister;
		if( sh.code == null ) {
			sh.code = out.run(sh.data);
			sh.code = rootStr + sh.code;
		}
		var key = profile;
		for ( arg in SHADER_ARGS )
			key += arg;
		var bytes = getBinaryPayload(sh.code, key);
		if( bytes == null ) {
			bytes = compiler.compile(sh.code, profile, SHADER_ARGS);
			if( shaderCache != null )
				shaderCache.saveCompiledShader(sh.code, bytes, key);
		}
		return bytes;
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		var out = new hxsl.HlslOut();
		var vsSource = out.run(shader.vertex.data);
		if( shader.mode == Compute )
			return vsSource;
		var out = new hxsl.HlslOut();
		var psSource = out.run(shader.fragment.data);
		return vsSource+"\n\n\n\n"+psSource;
	}

	function stringifyRootSignature( sign : RootSignatureDesc, name : String, params : hl.CArray<RootParameterDescriptorTable>, paramsCount : Int ) : String {
		var s = '#define ${name} "RootFlags(';
		if ( sign.flags.toInt() == 0 )
			s += '0'; // no flags
		else {
			// RootFlags
			for ( f in haxe.EnumTools.getConstructors(RootSignatureFlag) ) {
				if ( !sign.flags.has(haxe.EnumTools.createByName(RootSignatureFlag, f)) )
					continue;
				s += Std.string(f) + '|';
			}
			s = s.substr(0, s.length - 1);
		}
		s += ')",';

		for ( i in 0...paramsCount ) {
			var param = params[i];
			var vis = "SHADER_VISIBILITY_"+switch( param.shaderVisibility ) { case VERTEX: "VERTEX"; case PIXEL: "PIXEL"; default: "ALL"; };
			if ( param.parameterType == CONSTANTS ) {
				var p = unsafeCastTo(param, RootParameterConstants);
				var shaderRegister = p.shaderRegister;
				s += 'RootConstants(num32BitConstants=${p.num32BitValues},b${shaderRegister}, visibility=${vis}),';
			} else {
				try {
					var p = param;
					if( p.descriptorRanges == null ) continue;
					s += 'DescriptorTable(';
					for ( i in 0...p.numDescriptorRanges) {
						var descRange = p.descriptorRanges[i];
						var baseShaderRegister = descRange.baseShaderRegister;
						switch ( descRange.rangeType) {
							case CBV:
								s += 'CBV(b${baseShaderRegister}, numDescriptors = ${descRange.numDescriptors}),';
							case SRV:
								s += 'SRV(t${baseShaderRegister}, numDescriptors = ${descRange.numDescriptors}),';
							case SAMPLER:
								var baseShaderRegister = descRange.baseShaderRegister;
								s += 'Sampler(s${baseShaderRegister}, space=${descRange.registerSpace}, numDescriptors = ${descRange.numDescriptors}),';
							case UAV:
								var reg = descRange.baseShaderRegister;
								s += 'UAV(u${reg}, numDescriptors = ${descRange.numDescriptors}),';
						}
					}
					s += 'visibility = ${vis}),';
				} catch ( e : Dynamic ) {
					continue;
				}
			}
		}

		s += '\n';
		return s;
	}

	inline function unsafeCastTo<T,R>( v : T, c : Class<R> ) : R {
		#if (haxe_ver < 5)
		var arr = new hl.NativeArray<T>(1);
		arr[0] = v;
		return (cast arr : hl.NativeArray<R>)[0];
		#else
		return hl.Api.unsafeCast(v);
		#end
	}

	function computeRootSignature( shader : hxsl.RuntimeShader ) {
		var allocatedParams = 16;
		var params = hl.CArray.alloc(RootParameterDescriptorTable,allocatedParams);
		var paramsCount = 0, regCount = 0;
		var ranges = [];
		var globalsParamsCBV = false;
		var vertexParamsCBV = false;
		var fragmentParamsCBV = false;

		function allocDescTable(vis, rangeCount = 1) {
			var p = params[paramsCount++];
			p.parameterType = DESCRIPTOR_TABLE;
			p.numDescriptorRanges = rangeCount;
			var rangeArr = hl.CArray.alloc(DescriptorRange,rangeCount);
			for ( i in 0...rangeCount) {
				var range = rangeArr[i];
				#if (hldx >= version("1.15.0"))
				range.offsetInDescriptorsFromTableStart = Driver.getConstant(DESCRIPTOR_RANGE_OFFSET_APPEND);
				#else
				range.offsetInDescriptorsFromTableStart = 0xffffffff;
				#end
				ranges.push(range);
			}
			p.descriptorRanges = rangeArr;
			p.shaderVisibility = vis;
			return rangeArr;
		}

		function allocConsts(size,vis,type) {
			var reg = regCount++;
			if( size == 0 ) return -1;

			if( type != null ) {
				var pid = paramsCount;
				var r = allocDescTable(vis)[0];
				r.rangeType = type;
				r.numDescriptors = 1;
				r.baseShaderRegister = reg;
				r.registerSpace = 0;
				return pid | 0x100;
			}

			var pid = paramsCount++;
			var p = unsafeCastTo(params[pid], RootParameterConstants);
			p.parameterType = CONSTANTS;
			p.shaderRegister = reg;
			p.shaderVisibility = vis;
			p.num32BitValues = size << 2;
			return pid;
		}


		function allocParams( sh : hxsl.RuntimeShader.RuntimeShaderData ) {
			var vis = switch( sh.kind ) {
			case Vertex: VERTEX;
			case Fragment: PIXEL;
			default: ALL;
			}
			var regs = new ShaderRegisters();
			regs.globals = allocConsts(sh.globalsSize, vis, globalsParamsCBV ? CBV : null);
			regs.params = allocConsts(sh.paramsSize, vis, (sh.kind == Fragment ? fragmentParamsCBV : vertexParamsCBV) ? CBV : null);
			regs.buffers = paramsCount;
			if( sh.bufferCount > 0 ) {
				regs.bufferTypes = [];
				regs.bufferStrides = [];
				var uavCount = 0;
				var p = sh.buffers;
				while( p != null ) {
					switch( p.type ) {
						case TBuffer(type,_,kind):
							regs.bufferTypes.push(kind);
							var stride = switch ( kind ) {
								case Uniform, Partial:
									regs.cbvCount++;
									hxsl.Ast.Tools.size(type) << 2;
								case Storage, StoragePartial:
									regs.storageCount++;
									hxsl.Ast.Tools.size(type.match(TInt|TFloat) ? type : TVec(4, VFloat)) << 2;
								case RW, RWPartial:
									uavCount++;
									hxsl.Ast.Tools.size(type.match(TInt|TFloat) ? type : TVec(4, VFloat)) << 2;
								default:
									throw "assert";
							}
							regs.bufferStrides.push(stride);
						default:
							throw "assert";
					}
					p = p.next;
				}

				var rangeCount = 0;
				rangeCount += regs.cbvCount > 0 ? 1 : 0;
				rangeCount += regs.storageCount > 0 ? 1 : 0;
				rangeCount += uavCount > 0 ? 1 : 0;
				var rangArr = allocDescTable(vis, rangeCount);
				var i = 0;
				if ( regs.cbvCount > 0 ) {
					var r = rangArr[i];
					r.rangeType = CBV;
					r.baseShaderRegister = regCount;
					r.registerSpace = 0;
					r.numDescriptors = regs.cbvCount;
					regCount += regs.cbvCount;
					i++;
				}
				if ( regs.storageCount > 0 ) {
					var r = rangArr[i];
					r.rangeType = SRV;
					r.baseShaderRegister = regs.texturesCount;
					r.registerSpace = 0;
					r.numDescriptors = regs.storageCount;
					i++;
				}
				if ( uavCount > 0 ) {
					var r = rangArr[i];
					r.rangeType = UAV;
					r.baseShaderRegister = regCount;
					r.registerSpace = 0;
					r.numDescriptors = uavCount;
					regCount += uavCount;
					i++;
				}
			}
			if( sh.texturesCount > 0 ) {
				regs.texturesTypes = [];
				var uavCount = 0;

				var p = sh.data.vars;
				for( v in sh.data.vars ) {
					switch( v.type ) {
					case TArray(t = TSampler(_) | TRWTexture(_), SConst(n)):
						for( i in 0...n )
							regs.texturesTypes.push(t);
						if( t.match(TSampler(_)) )
							regs.texturesCount += n;
						else {
							uavCount += n;
						}
					default:
					}
				}

				regs.textures = paramsCount;
				var rangeCount = 0;
				rangeCount += regs.texturesCount > 0 ? 1 : 0;
				rangeCount += uavCount > 0 ? 1 : 0;
				var rangeArr = allocDescTable(vis, rangeCount);
				var i = 0;
				if( regs.texturesCount > 0 ) {

					var r = rangeArr[i];
					r.rangeType = SRV;
					r.baseShaderRegister = regs.storageCount;
					r.registerSpace = 0;
					r.numDescriptors = regs.texturesCount;
					i++;

					regs.samplers = paramsCount;
					var r = allocDescTable(vis)[0];
					r.rangeType = SAMPLER;
					r.baseShaderRegister = 0;
					r.registerSpace = 0;
					r.numDescriptors = regs.texturesCount;
				}

				if ( uavCount > 0 ) {
					var r = rangeArr[i];
					r.rangeType = UAV;
					r.baseShaderRegister = regCount;
					r.registerSpace = 0;
					r.numDescriptors = uavCount;
					regCount += uavCount;
					i++;
				}
			}
			return regs;
		}

		// Costs in units:
		// Descriptor Tables cost 1 each
		// Root CBVs cost 2 each
		// Root SRVs cost 2 each
		// Root UAVs cost 2 each
		// Root Constants cost 1 per 32-bit value
		function calcSize( sh : hxsl.RuntimeShader.RuntimeShaderData ) {
			var s = (sh.globalsSize + sh.paramsSize) << 2;
			// 1 descriptor table for all textures and 1 descriptor table for all samplers
			s += ( sh.texturesCount > 0 ) ? 2 : 0;
			// 1 descriptor table for all buffers
			s += ( sh.bufferCount > 0 ) ? 1 : 0;
			return s;
		}

		var totalVertex = calcSize(shader.vertex);
		var isCompute = shader.mode == Compute;
		var totalFragment = isCompute ? 0 : calcSize(shader.fragment);
		var total = totalVertex + totalFragment;

		if( total > 64 ) {
			var vertexParamCostGain = 1 - (shader.vertex.paramsSize << 2);
			var fragmentParamCostGain = isCompute ? 0 : 1 - (shader.fragment.paramsSize << 2);

			// Remove the size cost of the root constant and add one descriptor table.
			var withoutVP = total + vertexParamCostGain;
			var withoutFP = total + fragmentParamCostGain;
			if( withoutVP <= 64 || ( withoutFP > 64 && withoutVP > 64 ) ) {
				vertexParamsCBV = true;
				total = withoutVP;
			}
			if( total > 64 && !isCompute ) {
				fragmentParamsCBV = true;
				total = total + fragmentParamCostGain;
			}
			if( total > 64 ) {
				globalsParamsCBV = true;
				var vertexGlobalCostGain = 1 - (shader.vertex.globalsSize << 2);
				var fragmentGlobalCostGain = isCompute ? 0 : 1 - (shader.fragment.globalsSize << 2);
				var withoutGlobal = total + vertexGlobalCostGain + fragmentGlobalCostGain;
				if ( withoutGlobal > 64 )
					throw "Too many params. Should not be possible if every params fall into descriptor table.";
			}
		}

		var regs = [];
		for( s in shader.getShaders() )
			regs.push({ start : regCount, registers : allocParams(s) });
		if( paramsCount > allocatedParams )
			throw "ASSERT : Too many parameters";

		var sign = new RootSignatureDesc();
		if( shader.mode == Compute ) {
			sign.flags.set(DENY_PIXEL_SHADER_ROOT_ACCESS);
			sign.flags.set(DENY_VERTEX_SHADER_ROOT_ACCESS);
		} else
			sign.flags.set(ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);
		sign.flags.set(DENY_HULL_SHADER_ROOT_ACCESS);
		sign.flags.set(DENY_DOMAIN_SHADER_ROOT_ACCESS);
		sign.flags.set(DENY_GEOMETRY_SHADER_ROOT_ACCESS);
		#if !xbogdk
		sign.flags.set(DENY_AMPLIFICATION_SHADER_ROOT_ACCESS);
		sign.flags.set(DENY_MESH_SHADER_ROOT_ACCESS);
		#end
		sign.numParameters = paramsCount;
		sign.parameters = cast params;

		return { sign : sign, registers : regs, params : params, paramsCount : paramsCount, ranges : ranges };
	}

	function compileShader( shader : hxsl.RuntimeShader ) : CompiledShader {

		var res = computeRootSignature(shader);

		var c = new CompiledShader();

		var rootStr = stringifyRootSignature(res.sign, "ROOT_SIGNATURE", res.params, res.paramsCount);
		var vs = shader.mode == Compute ? null : compileSource(shader.vertex, "vs_6_0", 0, rootStr);
		var ps = shader.mode == Compute ? null : compileSource(shader.fragment, "ps_6_0", res.registers[1].start, rootStr);
		var cs = shader.mode == Compute ? compileSource(shader.compute, "cs_6_0", 0, rootStr) : null;

		var signSize = 0;
		var signBytes = Driver.serializeRootSignature(res.sign, 1, signSize);
		var sign = new RootSignature(signBytes,signSize);
		c.rootSignature = sign;
		c.shader = shader;

		if( shader.mode == Compute ) {
			c.isCompute = true;
			var desc = new ComputePipelineStateDesc();
			desc.rootSignature = sign;
			desc.cs.shaderBytecode = cs;
			desc.cs.bytecodeLength = cs.length;
			c.computePipeline = Driver.createComputePipelineState(desc);
			c.vertexRegisters = res.registers[0].registers;
			return c;
		}

		c.vertexRegisters = res.registers[0].registers;
		c.fragmentRegisters = res.registers[1].registers;

		var inputs = [];
		for( v in shader.vertex.data.vars )
			switch( v.kind ) {
			case Input: inputs.push(v);
			default:
			}

		var inputLayout = hl.CArray.alloc(InputElementDesc, inputs.length);
		var format : Array<hxd.BufferFormat.BufferInput> = [];
		var allNames = new Map();
		var varNames = new Map();
		for ( i => v in inputs)
			hxsl.HlslOut.varName(v, varNames, allNames);
		for( i => v in inputs ) {
			var d = inputLayout[i];
			var perInst = 0;
			if( v.qualifiers != null )
				for( q in v.qualifiers )
					switch( q ) {
					case PerInstance(k): perInst = k;
					default:
					}
			d.semanticName = @:privateAccess hxsl.HlslOut.semanticName(varNames.get(v.id)).toUtf8();
			d.inputSlot = i;
			format.push({ name : v.name, type : hxd.BufferFormat.InputFormat.fromHXSL(v.type) });
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
		p.inputLayout.inputElementDescs = inputLayout;
		p.inputLayout.numElements = inputs.length;

		//Driver.createGraphicsPipelineState(p);

		c.format = hxd.BufferFormat.make(format);
		c.pipeline = p;
		c.inputLayout = inputLayout;
		c.inputCount = inputs.length;

		for( i in 0...inputs.length )
			inputLayout[i].alignedByteOffset = 1; // will trigger error if not set in makePipeline()
	   return c;
	}

	function disposeResource( r : ResourceData ) {
		frame.toRelease.push(r.res);
		r.res = null;
		r.state = r.targetState = PRESENT;
	}

	// ----- BUFFERS

	function allocGPU( size : Int, heapType, state, uav=false ) {
		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		flags.set(CREATE_NOT_ZEROED);
		desc.dimension = BUFFER;
		desc.width = size;
		desc.height = 1;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.layout = ROW_MAJOR;
		if( uav ) desc.flags.set(ALLOW_UNORDERED_ACCESS);
		tmp.heap.type = heapType;
		return Driver.createCommittedResource(tmp.heap, flags, desc, state, null);
	}

	override function allocBuffer( m : h3d.Buffer ) : GPUBuffer {
		var buf = new VertexBufferData();
		var size = m.getMemSize();
		var bufSize = m.flags.has(UniformBuffer) || m.flags.has(ReadWriteBuffer) ? calcCBVSize(size) : size;
		buf.state = buf.targetState = COPY_DEST;
		buf.res = allocGPU(bufSize, DEFAULT, COMMON,  m.flags.has(ReadWriteBuffer));
		if( m.flags.has(UniformBuffer) ) {
			// no view
		} else if( m.flags.has(IndexBuffer) ) {
			var view = new IndexBufferView();
			view.bufferLocation = buf.res.getGpuVirtualAddress();
			view.format = m.format.strideBytes == 4 ? R32_UINT : R16_UINT;
			view.sizeInBytes = size;
			buf.iview = view;
		} else {
			var view = new VertexBufferView();
			view.bufferLocation = buf.res.getGpuVirtualAddress();
			view.sizeInBytes = size;
			view.strideInBytes = m.format.strideBytes;
			buf.view = view;
		}
		buf.size = bufSize;
		return buf;
	}

	override function allocInstanceBuffer(b:InstanceBuffer, bytes:haxe.io.Bytes) {
		var dataSize = b.commandCount * 5 * 4;
		var buf = new VertexBufferData();
		buf.state = buf.targetState = COPY_DEST;
		buf.res = allocGPU(dataSize, DEFAULT, COMMON);
		var alloc = allocDynamicBuffer(bytes, dataSize);
		frame.commandList.copyBufferRegion(buf.res, 0, alloc.resource, alloc.offset, dataSize);
		b.data = buf;
	}

	override function uploadInstanceBufferBytes(b : InstanceBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var strideBytes = 5 * 4;
		updateBuffer(b.data, @:privateAccess buf.b.offset(bufPos), startVertex * strideBytes, vertexCount * strideBytes);
	}

	override function disposeBuffer(v:Buffer) {
		disposeResource(v.vbuf);
	}

	override function disposeInstanceBuffer(b:InstanceBuffer) {
		frame.toRelease.push((b.data.res:GpuResource));
		// disposeResource(b.data);
		b.data = null;
	}

	function updateBuffer( b : ResourceData, bytes : hl.Bytes, startByte : Int, bytesCount : Int ) {
		var alloc = allocDynamicBuffer(bytes, bytesCount);
		transition(b, COPY_DEST);
		flushTransitions();
		frame.commandList.copyBufferRegion(b.res, startByte, alloc.resource, alloc.offset, bytesCount);
	}

	override function uploadIndexData(i:Buffer, startIndice:Int, indiceCount:Int, buf:hxd.IndexBuffer, bufPos:Int) {
		var bits = i.format.strideBytes >> 1;
		updateBuffer(i.vbuf, hl.Bytes.getArray(buf.getNative()).offset(bufPos << bits), startIndice << bits, indiceCount << bits);
	}

	override function uploadBufferData(b:Buffer, startVertex:Int, vertexCount:Int, buf:hxd.FloatBuffer, bufPos:Int) {
		var data = hl.Bytes.getArray(buf.getNative()).offset(bufPos<<2);
		updateBuffer(b.vbuf, data, startVertex * b.format.strideBytes, vertexCount * b.format.strideBytes);
	}

	override function uploadBufferBytes(b:Buffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		updateBuffer(b.vbuf, @:privateAccess buf.b.offset(bufPos), startVertex * b.format.strideBytes, vertexCount * b.format.strideBytes);
	}

	override function readBufferBytes(b:Buffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		var stride = b.format.strideBytes;

		var totalSize = vertexCount*stride;

		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = BUFFER;
		desc.width = totalSize;
		desc.height = 1;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.layout = ROW_MAJOR;
		tmp.heap.type = READBACK;
		var tmpBuf = Driver.createCommittedResource(tmp.heap, flags, desc, COPY_DEST, null);

		transition(b.vbuf, COPY_SOURCE);
		flushTransitions();

		frame.commandList.copyBufferRegion(tmpBuf, 0, b.vbuf.res, startVertex*stride, totalSize);

		flushFrame();
		waitGpu();

		var output = tmpBuf.map(0, null);
		@:privateAccess buf.b.blit(bufPos, output, 0, totalSize);
		tmpBuf.release();

		beginFrame();
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

	function makeTextureDesc(t:h3d.mat.Texture) {
		var desc = new ResourceDesc();
		desc.dimension = t.flags.has(Is3D) ? TEXTURE3D : TEXTURE2D;
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
		flags.set(CREATE_NOT_ZEROED);
		var desc = makeTextureDesc(t);
		var td = new TextureData();
		td.format = desc.format;
		tmp.heap.type = DEFAULT;

		var clear = null;
		if( isRT ) {
			var color = t.t == null || t.t.color == null ? new h3d.Vector4(0,0,0,0) : t.t.color; // reuse prev color
			desc.flags.set(ALLOW_RENDER_TARGET);
			clear = tmp.clearValue;
			clear.format = desc.format;
			clear.color.r = color.r;
			clear.color.g = color.g;
			clear.color.b = color.b;
			clear.color.a = color.a;
			td.color = color;
		}
		if( t.flags.has(Writable) )
			desc.flags.set(ALLOW_UNORDERED_ACCESS);

		td.state = td.targetState = isRT ? RENDER_TARGET : COPY_DEST;
		td.res = Driver.createCommittedResource(tmp.heap, flags, desc, isRT ? RENDER_TARGET : COMMON, clear);
		td.res.setName(t.name == null ? "Texture#"+t.id : t.name);
		t.lastFrame = frameCount;
		t.flags.unset(WasCleared);

		return td;
	}

	override function allocDepthBuffer(b:h3d.mat.Texture):Texture {
		var td = new TextureData();
		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		flags.set(CREATE_NOT_ZEROED);
		desc.dimension = TEXTURE2D;
		desc.width = b.width;
		desc.height = b.height;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.format = toDxgiDepthFormat(b.format);
		desc.flags.set(ALLOW_DEPTH_STENCIL);
		#if console
		desc.flags = new haxe.EnumFlags<ResourceFlag>( desc.flags.toInt() | 0x00800000 ); // FORCE_TEXTURE_COMPATIBILITY
		#end
		tmp.heap.type = DEFAULT;

		tmp.clearValue.format = desc.format;
		tmp.clearValue.depth = 1;
		tmp.clearValue.stencil= 0;
		td.state = td.targetState = DEPTH_WRITE;
		td.res = Driver.createCommittedResource(tmp.heap, flags, desc, DEPTH_WRITE, tmp.clearValue);
		return td;
	}

	override function disposeTexture(t:h3d.mat.Texture) {
		disposeResource(t.t);
		t.t = null;
	}

	override function disposeDepthBuffer(t:h3d.mat.Texture) {
		disposeResource(t.t);
		t.t = null;
	}

	override function uploadTextureBitmap(t:h3d.mat.Texture, bmp:hxd.BitmapData, mipLevel:Int, side:Int) {
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	}

	override function uploadTexturePixels(t:h3d.mat.Texture, pixels:hxd.Pixels, mipLevel:Int, side:Int) {
		pixels.convert(t.format);
		if( mipLevel >= t.mipLevels ) throw "Mip level outside texture range : " + mipLevel + " (max = " + (t.mipLevels - 1) + ")";

		var is3d = t.flags.has(Is3D);
		var subRes = is3d ? mipLevel : mipLevel + side * t.mipLevels;
		var tmpSize = t.t.res.getRequiredIntermediateSize(subRes, 1).low;
		if ( is3d )
			tmpSize = Std.int(tmpSize / t.layerCount );

		#if (hldx >= version("1.15.0"))
		var textureAlignment = Driver.getConstant(TEXTURE_DATA_PLACEMENT_ALIGNMENT);
		#else
		var textureAlignment = 512;
		#end
		var allocation = frame.bumpAllocator.alloc(tmpSize, textureAlignment, tmp.bumpAllocation);

		transition(t.t, COPY_DEST);
		flushTransitions();

		var dst = tmp.dstTextureLocation;
		dst.res = t.t.res;
		dst.subResourceIndex = subRes;
		dst.type = SUBRESOURCE_INDEX;
		var dstDesc = makeTextureDesc(t);

		var src = tmp.srcTextureLocation;
		src.res = allocation.resource;
		src.type = PLACED_FOOTPRINT;

		var numRow : hl.BytesAccess<Int64> = tmp.copyableInfosBytes;
		var rowSizeInBytes : hl.BytesAccess<Int64> = tmp.copyableInfosBytes.offset(8);
		Driver.getCopyableFootprints(dstDesc, subRes, 1, allocation.offset, src.placedFootprint, numRow, rowSizeInBytes, null);

		var rowPitch = src.placedFootprint.footprint.rowPitch;
		var data = (pixels.bytes:hl.Bytes).offset(pixels.offset);
		var numRow = numRow[0].low;
		var rowSizeInBytes = rowSizeInBytes[0].low;
		for ( i in 0...numRow)
			allocation.cpuAddress.blit(rowPitch * i, data, rowSizeInBytes * i, rowSizeInBytes);

		src.placedFootprint.footprint.depth = 1;
		frame.commandList.copyTextureRegion(dst, 0, 0, is3d ? side : 0, src, null);

		t.flags.set(WasCleared);
	}

	override function copyTexture(from:h3d.mat.Texture, to:h3d.mat.Texture):Bool {
		if( from.t == null || from.format != to.format || from.width != to.width || from.height != to.height || from.layerCount != to.layerCount || from.mipLevels != to.mipLevels )
			return false;
		if( to.t == null ) {
			var prev = from.lastFrame;
			from.preventAutoDispose();
			to.alloc();
			from.lastFrame = prev;
			if( from.t == null ) throw "assert";
			if( to.t == null ) return false;
		}
		transition( from.t, COPY_SOURCE);
		transition( to.t, COPY_DEST);
		flushTransitions();
		var dst = tmp.dstTextureLocation;
		var src = tmp.srcTextureLocation;
		dst.res = to.t.res;
		src.res = from.t.res;
		dst.type = SUBRESOURCE_INDEX;
		src.type = SUBRESOURCE_INDEX;
		var is3d = to.flags.has(Is3D);
		var subResCount = is3d ? to.mipLevels : to.layerCount * to.mipLevels;
		for ( i in 0...subResCount ) {
			dst.subResourceIndex = i;
			src.subResourceIndex = i;
			frame.commandList.copyTextureRegion(dst, 0, 0, 0, src, null);
		}
		to.flags.set(WasCleared);
		for( t in currentRenderTargets )
			if( t == to || t == from )
				transition( t.t, RENDER_TARGET );
		return true;
	}

	// ----- PIPELINE UPDATE

	override function uploadShaderBuffers(buffers:h3d.shader.Buffers, which:h3d.shader.Buffers.BufferKind) {
		uploadBuffers(buffers, buffers.vertex, which, currentShader.shader.vertex, currentShader.vertexRegisters);
		if( !currentShader.isCompute )
			uploadBuffers(buffers, buffers.fragment, which, currentShader.shader.fragment, currentShader.fragmentRegisters);
	}

	function calcCBVSize( dataSize : Int ) {
		// the view must be a mult of 256
		var sz = dataSize & ~0xFF;
		if( sz != dataSize ) sz += 0x100;
		return sz;
 	}

	function allocDynamicBuffer( data : hl.Bytes, dataSize : Int ) : BumpAllocation {
		var allocation = frame.bumpAllocator.alloc(dataSize, tmp.bumpAllocation);
		allocation.cpuAddress.blit(0, data, 0, dataSize);
		return allocation;
	}

	function hasBuffersTexturesChanged ( buf : h3d.shader.Buffers.ShaderBuffers, regs : ShaderRegisters ) : Bool {
		var changed = regs.lastHeapCount != heapCount;
		if( !changed ) {
			for( i in 0...regs.texturesTypes.length )
				if( regs.lastTextures[i] != ( buf.tex[i] != null ? buf.tex[i].t : null ) || regs.lastTexturesBits[i] != ( buf.tex[i] != null ? buf.tex[i].bits : -1 ) ) {
					changed = true;
					break;
				}
		}
		return changed;
	}

	var srvRingBuf : hl.CArray<SrvArgs>;
	var srvHead : haxe.atomic.AtomicInt = new haxe.atomic.AtomicInt(1);
	var srvTail : haxe.atomic.AtomicInt = new haxe.atomic.AtomicInt(0);
	var srvThreadLaunched : Bool = false;

	inline function computeSRVBufferDistance() : Int {
		return (srvHead.load() + (~(srvTail.load() - 1 ) & 0xFF)) & 0xFF;
	}

	inline function processSRV() {
		var index = (srvTail.load() + 1) & 0xFF;
		var args = srvRingBuf[index];
		Driver.createShaderResourceView(args.res, args.resourceDesc, args.srvAddr);
		Driver.createSampler(args.samplerDesc, args.samplerAddr);
		srvTail.store(index);
	}

	function runThread() {
		while(true) {
			// Check if ring buffer is empty
			if ( computeSRVBufferDistance() != 1 )
				processSRV();
			else
				Sys.sleep(0);
		}
	}

	inline function toDepthFormat(format : h3d.mat.Data.TextureFormat ) : DxgiFormat {
		var fmt = switch (format) {
			case Depth16:
				R16_UNORM;
			case Depth24, Depth24Stencil8:
				R24_UNORM_X8_TYPELESS;
			case Depth32:
				R32_FLOAT;
			default:
				throw "Unsupported depth format "+ format;
		}
		return fmt;
	}

	function createSRV( t : h3d.mat.Texture, srvAddr : Address, samplerAddr : Address ) {
		if (!srvThreadLaunched) {
			srvThreadLaunched = true;
			srvRingBuf = hl.CArray.alloc(SrvArgs, 256);
			#if !console
			var thread = sys.thread.Thread.create(runThread);
			#if (haxe_ver >= 5) thread.name = "DX12"; #else thread.setName("DX12"); #end
			#end
		}

		// Check if ring buffer is full
		var count = 0;
		while( true ) {
			if( computeSRVBufferDistance() != 0 ) break;
			count++;
			if( count > 100000 ) {
				// we sometimes get thread starvation by just doing the while loop.
				// this might allow the SRV thread to catch up and get atomic locks.
				Sys.sleep(0);
				count = 0;
			}
		};

		var srvArgs = srvRingBuf[srvHead.load()];

		if( t.flags.has(Cube) ) {
			var desc = unsafeCastTo(srvArgs.resourceDesc, TexCubeSRV);
			desc.format = t.t.format;
			desc.dimension = TEXTURECUBE;
			desc.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
			desc.mostDetailedMip = t.startingMip;
			desc.mipLevels = -1;
			desc.resourceMinLODClamp = 0;
		} else if( t.flags.has(IsArray) ) {
			var desc = unsafeCastTo(srvArgs.resourceDesc, Tex2DArraySRV);
			desc.format = t.t.format;
			desc.dimension = TEXTURE2DARRAY;
			desc.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
			desc.mostDetailedMip = t.startingMip;
			desc.mipLevels = -1;
			desc.firstArraySlice = 0;
			desc.arraySize = t.layerCount;
			desc.planeSlice = 0;
			desc.resourceMinLODClamp = 0;
		} else if ( t.flags.has(Is3D) ) {
			var desc = unsafeCastTo(srvArgs.resourceDesc, Tex3DSRV);
			desc.format = t.t.format;
			desc.dimension = TEXTURE3D;
			desc.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
			desc.mostDetailedMip = t.startingMip;
			desc.mipLevels = -1;
			desc.resourceMinLODClamp = 0;
		} else {
			var desc = srvArgs.resourceDesc;
			desc.format = t.isDepth() ? toDepthFormat(t.format) : t.t.format;
			desc.dimension = TEXTURE2D;
			desc.shader4ComponentMapping = ShaderComponentMapping.DEFAULT;
			desc.mostDetailedMip = t.startingMip;
			desc.mipLevels = -1;
			desc.planeSlice = 0;
			desc.resourceMinLODClamp = 0;
		}

		var desc = srvArgs.samplerDesc;
		desc.comparisonFunc = NEVER;
		desc.maxLod = 1e30;
		desc.filter = switch( [t.filter, t.mipMap] ) {
			case [Nearest, None|Nearest]: MIN_MAG_MIP_POINT;
			case [Nearest, Linear]: MIN_MAG_POINT_MIP_LINEAR;
			case [Linear, None|Nearest]: MIN_MAG_LINEAR_MIP_POINT;
			case [Linear, Linear]: MIN_MAG_MIP_LINEAR;
		}
		desc.addressU = desc.addressV = desc.addressW = switch( t.wrap ) {
			case Clamp: CLAMP;
			case Repeat: WRAP;
			case Mirror: MIRROR;
		}
		desc.mipLODBias = t.lodBias;

		srvArgs.res = t.t.res;
		srvArgs.srvAddr = srvAddr;
		srvArgs.samplerAddr = samplerAddr;
		srvHead.store((srvHead.load() + 1) & 0xFF);

		#if console
		processSRV();
		#end
	}

	function uploadBuffers( buffers : h3d.shader.Buffers, buf : h3d.shader.Buffers.ShaderBuffers, which:h3d.shader.Buffers.BufferKind, shader : hxsl.RuntimeShader.RuntimeShaderData, regs : ShaderRegisters ) {
		switch( which ) {
		case Params:
			if( shader.paramsSize > 0 ) {
				var data = hl.Bytes.getArray(buf.params.toData());
				var dataSize = shader.paramsSize << 4;
				if( regs.params & 0x100 != 0 ) {
					// update CBV
					var srv = frame.shaderResourceViews.alloc(1);
					var alloc = allocDynamicBuffer(data,dataSize);
					var desc = tmp.cbvDesc;
					desc.bufferLocation = alloc.resource.getGpuVirtualAddress() + alloc.offset;
					desc.sizeInBytes = alloc.byteSize;
					Driver.createConstantBufferView(desc, srv);
					if( currentShader.isCompute )
						frame.commandList.setComputeRootDescriptorTable(regs.params & 0xFF, frame.shaderResourceViews.toGPU(srv));
					else
						frame.commandList.setGraphicsRootDescriptorTable(regs.params & 0xFF, frame.shaderResourceViews.toGPU(srv));
				} else if( currentShader.isCompute )
					frame.commandList.setComputeRoot32BitConstants(regs.params, dataSize >> 2, data, 0);
				else
					frame.commandList.setGraphicsRoot32BitConstants(regs.params, dataSize >> 2, data, 0);
			}
		case Globals:
			var isFragment = shader.kind == Fragment;
			var bind = -1;
			if( shader.globalsSize > 0 ) {
				var data = hl.Bytes.getArray(buf.globals.toData());
				var dataSize = shader.globalsSize << 4;
				if( regs.globals & 0x100 != 0 ) {
					// update CBV
					var srv = frame.shaderResourceViews.alloc(1);
					var alloc = allocDynamicBuffer(data,dataSize);
					var desc = isFragment ? tmp.fragmentGlobalDesc : tmp.vertexGlobalDesc;
					desc.bufferLocation = alloc.resource.getGpuVirtualAddress() + alloc.offset;
					desc.sizeInBytes = alloc.byteSize;
					Driver.createConstantBufferView(desc, srv);
					bind = regs.globals & 0xFF;
					if( currentShader.isCompute )
						frame.commandList.setComputeRootDescriptorTable(bind, frame.shaderResourceViews.toGPU(srv));
					else
						frame.commandList.setGraphicsRootDescriptorTable(bind, frame.shaderResourceViews.toGPU(srv));
				} else if( currentShader.isCompute )
					frame.commandList.setComputeRoot32BitConstants(regs.globals, dataSize >> 2, data, 0);
				else
					frame.commandList.setGraphicsRoot32BitConstants(regs.globals, dataSize >> 2, data, 0);
			}
			if ( isFragment )
				lastFragmentGlobalBind = bind;
			else
				lastVertexGlobalBind = bind;

		case Textures:
			if( shader.texturesCount > 0 ) {
				if ( hasBuffersTexturesChanged(buf, regs) ) {
					regs.lastHeapCount = heapCount;
					regs.srv = frame.shaderResourceViews.alloc(shader.texturesCount);
					regs.samplersView = frame.samplerViews.alloc(regs.texturesCount);
					if ( regs.lastTextures.length < shader.texturesCount ) {
						regs.lastTextures.resize(shader.texturesCount);
						regs.lastTexturesBits.resize(shader.texturesCount);
					}
					var regIndex = regs.buffers + shader.bufferCount;
					var textureIndex = 0;
					var uavIndex = regs.texturesCount;
					for( i in 0...shader.texturesCount ) {
						var t = buf.tex[i];
						var pt = regs.texturesTypes[i];
						if( t == null || t.isDisposed() ) {
							switch ( pt ) {
							case TSampler(TCube, false):
								t = h3d.mat.Texture.defaultCubeTexture();
							case TSampler(_, false):
								var color = h3d.mat.Defaults.loadingTextureColor;
								t = h3d.mat.Texture.fromColor(color, (color >>> 24) / 255);
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
								currentShader = null;
								selectShader(s.shader);
								uploadShaderBuffers(buffers,Globals);
								uploadShaderBuffers(buffers,Params);
								uploadShaderBuffers(buffers,Textures);
								return;
							}
						}

						regs.lastTextures[i] = buf.tex[i] != null ? buf.tex[i].t : null;
						regs.lastTexturesBits[i] = buf.tex[i] != null ? buf.tex[i].bits : -1;

						switch( pt ) {
						case TRWTexture(dim,arr,chans):
							var tdim : hxsl.Ast.TexDimension = t.flags.has(Cube) ? TCube : dim;
							var fmt;
							if( (arr != t.flags.has(IsArray)) || dim != tdim )
								throw "Texture format does not match: "+t+"["+t.format+"] should be "+hxsl.Ast.Tools.toString(pt);
							var srv = frame.shaderResourceViews.alloc(1);
							if( !t.flags.has(Writable) )
								throw "Texture was allocated without Writable flag";
							transition(t.t, UNORDERED_ACCESS);
							var desc = tmp.wtexDesc;
							desc.format = cast getTextureFormat(t);
							desc.viewDimension = switch( [dim,arr] ) {
							case [T1D, false]: TEXTURE1D;
							case [T2D, false]: TEXTURE2D;
							case [T3D, false]: TEXTURE3D;
							case [T1D, true]: TEXTURE1DARRAY;
							case [T2D, true]: TEXTURE2DARRAY;
							default: throw "Unsupported RWTexture "+t;
							}
							desc.mipSlice = t.startingMip;
							desc.planeSlice = 0;
							if(t.flags.has(Is3D)){
								desc.wSlice = t.get_layerCount();
							}
							if( arr ) {
								desc.firstArraySlice = 0;
								desc.arraySize = 1;
							}
							Driver.createUnorderedAccessView(t.t.res, null, desc, regs.srv.offset(uavIndex * frame.shaderResourceViews.stride));
							uavIndex++;
							continue;
						default:
							t.lastFrame = frameCount;
							var state = if ( shader.kind == Fragment )
								PIXEL_SHADER_RESOURCE;
							else
								NON_PIXEL_SHADER_RESOURCE;
							transition(t.t, state);
							createSRV(t, regs.srv.offset(textureIndex * frame.shaderResourceViews.stride), regs.samplersView.offset(textureIndex * frame.samplerViews.stride));
							textureIndex++;
						}
					}
				} else {
					for( i in 0...shader.texturesCount ) {
						var t = buf.tex[i];
						if (t == null || t.t == null)
							continue;
						var pt = regs.texturesTypes[i];
						var state = switch( pt ) {
						case TRWTexture(_,_,_):
							UNORDERED_ACCESS;
						default:
							(shader.kind == Fragment ? PIXEL_SHADER_RESOURCE : NON_PIXEL_SHADER_RESOURCE);
						}
						transition(t.t, state);
					}
				}

				if( currentShader.isCompute ) {
					frame.commandList.setComputeRootDescriptorTable(regs.textures, frame.shaderResourceViews.toGPU(regs.srv));
					if ( regs.texturesCount > 0 )
						frame.commandList.setComputeRootDescriptorTable(regs.samplers, frame.samplerViews.toGPU(regs.samplersView));
				} else {
					frame.commandList.setGraphicsRootDescriptorTable(regs.textures, frame.shaderResourceViews.toGPU(regs.srv));
					if ( regs.texturesCount > 0 )
						frame.commandList.setGraphicsRootDescriptorTable(regs.samplers, frame.samplerViews.toGPU(regs.samplersView));
				}
			}
		case Buffers:
			if( shader.bufferCount > 0 ) {
				var srv = frame.shaderResourceViews.alloc(shader.bufferCount);
				var cbvIndex = 0;
				var storageIndex = regs.cbvCount;
				var uavIndex = regs.cbvCount + regs.storageCount;
				for( i in 0...shader.bufferCount ) {
					var b = buf.buffers[i];
					var cbv = b.vbuf;
					switch( regs.bufferTypes[i] ) {
					case Uniform:
						if( cbv.view != null )
							throw "Buffer was allocated without UniformBuffer flag";
						transition(cbv, VERTEX_AND_CONSTANT_BUFFER);
						var desc = tmp.cbvDesc;
						desc.bufferLocation = cbv.res.getGpuVirtualAddress();
						desc.sizeInBytes = cbv.size;
						Driver.createConstantBufferView(desc, srv.offset(cbvIndex * frame.shaderResourceViews.stride));
						cbvIndex++;
					case Storage:
						var state = shader.kind == Fragment ? PIXEL_SHADER_RESOURCE : NON_PIXEL_SHADER_RESOURCE;
						transition(cbv, state);
						var desc = tmp.bufferSRV;
						var stride = regs.bufferStrides[i];
						desc.numElements = Std.int(cbv.size / stride);
						desc.structureByteStride = stride;
						desc.flags = NONE;
						Driver.createShaderResourceView(cbv.res, desc, srv.offset(storageIndex * frame.shaderResourceViews.stride));
						storageIndex++;
					case RW:
						if( !b.flags.has(ReadWriteBuffer) )
							throw "Buffer was allocated without ReadWriteBuffer flag";
						transition(cbv, UNORDERED_ACCESS);
						var desc = tmp.uavDesc;
						var stride = regs.bufferStrides[i];
						desc.numElements = Std.int(cbv.size / stride);
						desc.structureSizeInBytes = stride;
						Driver.createUnorderedAccessView(cbv.res, null, desc, srv.offset(uavIndex * frame.shaderResourceViews.stride));
						uavIndex++;
					default:
						throw "assert";
					}
				}
				if( currentShader.isCompute )
					frame.commandList.setComputeRootDescriptorTable(regs.buffers, frame.shaderResourceViews.toGPU(srv));
				else
					frame.commandList.setGraphicsRootDescriptorTable(regs.buffers, frame.shaderResourceViews.toGPU(srv));
			}
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
		pipelineBuilder.setShader(shader);
		if( sh.isCompute ) {
			frame.commandList.setComputeRootSignature(currentShader.rootSignature);
			if ( currentPipelineState != currentShader.computePipeline ) {
				frame.commandList.setPipelineState(currentShader.computePipeline);
				currentPipelineState = currentShader.computePipeline;
			}
		} else {
			frame.commandList.setGraphicsRootSignature(currentShader.rootSignature);
		}
		return true;
	}

	override function selectMaterial( pass : h3d.mat.Pass ) @:privateAccess {
		var depthClamp = pass.depthClamp;
		pass.depthClamp = depthClamp || useDepthClamp;
		pipelineBuilder.selectMaterial(pass);
		pass.depthClamp = depthClamp;
		var st = pass.stencil;
		if( st != null && curStencilRef != st.reference ) {
			curStencilRef = st.reference;
			frame.commandList.omSetStencilRef(st.reference);
		}
	}

	override function selectBuffer(buffer:Buffer) {
		var views = tmp.vertexViews;
		var bview = buffer.vbuf.view;
		var map = buffer.format.resolveMapping(currentShader.format);
		var vbuf = buffer.vbuf;
		for( i in 0...currentShader.inputCount ) {
			var v = views[i];
			var inf = map[i];
			v.bufferLocation = bview.bufferLocation;
			v.sizeInBytes = bview.sizeInBytes;
			v.strideInBytes = bview.strideInBytes;
			pipelineBuilder.setBuffer(i, inf, v.strideInBytes);
		}
		transition(vbuf, VERTEX_AND_CONSTANT_BUFFER);
		frame.commandList.iaSetVertexBuffers(0, currentShader.inputCount, views[0]);
	}

	override function selectMultiBuffers(formats:hxd.BufferFormat.MultiFormat,buffers:Array<h3d.Buffer>) {
		var views = tmp.vertexViews;
		var map = formats.resolveMapping(currentShader.format);
		for( i in 0...map.length ) {
			var v = views[i];
			var inf = map[i];
			var vbuf = @:privateAccess buffers[inf.bufferIndex].vbuf;
			var bview = vbuf.view;
			v.bufferLocation = bview.bufferLocation;
			v.sizeInBytes = bview.sizeInBytes;
			v.strideInBytes = bview.strideInBytes;
			transition(vbuf, VERTEX_AND_CONSTANT_BUFFER );
			pipelineBuilder.setBuffer(i, inf, v.strideInBytes);
		}
		frame.commandList.iaSetVertexBuffers(0, map.length, views[0]);
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
	static var STENCIL_OP : Array<StencilOp> = [KEEP, ZERO, REPLACE, INCR_SAT, INCR, DECR_SAT, DECR, INVERT];

	function makePipeline( shader : CompiledShader ) {
		var p = shader.pipeline;
		var pass = pipelineBuilder.getCurrentPass();
		var depth = pipelineBuilder.getDepthProps();
		if( pass.wireframe ) pass.culling = None;

		var rtCount = currentRenderTargets.length;
		if( rtCount == 0 ) rtCount = 1;

		p.numRenderTargets = rtCount;

		p.rasterizerState.cullMode = CULL[pass.culling.getIndex()];
		p.rasterizerState.fillMode = pass.wireframe ? WIREFRAME : SOLID;
		p.depthStencilDesc.depthEnable = pass.depthTest != Always;
		p.depthStencilDesc.depthWriteMask = !pass.depthWrite || !depthEnabled ? ZERO : ALL;
		p.depthStencilDesc.depthFunc = COMP[pass.depthTest.getIndex()];
		p.rasterizerState.depthClipEnable = !pass.depthClamp;
		p.rasterizerState.depthBias = Std.int(depth.bias);
		p.rasterizerState.slopeScaledDepthBias = depth.slopeScaledBias;

		var bl = p.blendState;
		for( i in 0...rtCount ) {
			var t = bl.renderTargets[i];

			t.blendEnable = pass.blendSrc != One || pass.blendDst != Zero;
			t.srcBlend = BLEND[pass.blendSrc.getIndex()];
			t.dstBlend = BLEND[pass.blendDst.getIndex()];
			t.srcBlendAlpha = BLEND_ALPHA[pass.blendAlphaSrc.getIndex()];
			t.dstBlendAlpha = BLEND_ALPHA[pass.blendAlphaDst.getIndex()];
			t.blendOp = BLEND_OP[pass.blendOp.getIndex()];
			t.blendOpAlpha = BLEND_OP[pass.blendAlphaOp.getIndex()];
			t.renderTargetWriteMask = pass.colorMask;

			var t = currentRenderTargets[i];
			p.rtvFormats[i] = t == null ? R8G8B8A8_UNORM : t.t.format;
		}
		p.dsvFormat = toDxgiDepthFormat(depth.format);
		for ( i in rtCount...8 )
			p.rtvFormats[i] = DxgiFormat.UNKNOWN;

		for( i in 0...shader.inputCount ) {
			var d = shader.inputLayout[i];

			var inf = pipelineBuilder.getBufferInput(i);
			d.alignedByteOffset = inf.offset;
			d.format = @:privateAccess switch( [shader.format.inputs[i].type, inf.precision] ) {
			case [DFloat, F32]: R32_FLOAT;
			case [DFloat, F16]: R16_FLOAT;
			case [DFloat, S8]: R8_SNORM;
			case [DFloat, U8]: R8_UNORM;
			case [DVec2, F32]: R32G32_FLOAT;
			case [DVec2, F16]: R16G16_FLOAT;
			case [DVec2, S8]: R8G8_SNORM;
			case [DVec2, U8]: R8G8_UNORM;
			case [DVec3, F32]: R32G32B32_FLOAT;
			case [DVec3, F16]: R16G16B16A16_FLOAT; // padding
			case [DVec3, S8]: R8G8B8A8_SNORM; // padding
			case [DVec3, U8]: R8G8B8A8_UNORM; // padding
			case [DVec4, F32]: R32G32B32A32_FLOAT;
			case [DVec4, F16]: R16G16B16A16_FLOAT;
			case [DVec4, S8]: R8G8B8A8_SNORM;
			case [DVec4, U8]: R8G8B8A8_UNORM;
			case [DBytes4, _]: R8G8B8A8_UINT;
			default: throw "assert";
			};
		}


		var stencil = pass.stencil;
		var st = p.depthStencilDesc;
		st.stencilEnable = stencil != null;
		if( stencil != null ) {
			var front = st.frontFace;
			var back = st.backFace;
			st.stencilReadMask = stencil.readMask;
			st.stencilWriteMask = stencil.writeMask;
			front.stencilFunc = COMP[stencil.frontTest.getIndex()];
			front.stencilPassOp = STENCIL_OP[stencil.frontPass.getIndex()];
			front.stencilFailOp = STENCIL_OP[stencil.frontSTfail.getIndex()];
			front.stencilDepthFailOp = STENCIL_OP[stencil.frontDPfail.getIndex()];
			back.stencilFunc = COMP[stencil.backTest.getIndex()];
			back.stencilPassOp = STENCIL_OP[stencil.backPass.getIndex()];
			back.stencilFailOp = STENCIL_OP[stencil.backSTfail.getIndex()];
			back.stencilDepthFailOp = STENCIL_OP[stencil.backDPfail.getIndex()];
		}

		return Driver.createGraphicsPipelineState(p);
	}

	function flushPipeline() {
		if( !pipelineBuilder.needFlush ) return;
		var cache = pipelineBuilder.lookup(currentShader.pipelines, currentShader.inputCount);
		if( cache.pipeline == null )
			cache.pipeline = makePipeline(currentShader);
		if ( currentPipelineState != cache.pipeline ) {
			frame.commandList.setPipelineState(cache.pipeline);
			currentPipelineState = cache.pipeline;
		}
	}

	// QUERIES

	static inline var QUERY_COUNT = 128;

	override function allocQuery( queryKind : QueryKind ) : Query {
		if( queryKind != TimeStamp )
			throw "Not implemented";
		return new Query();
	}

	override function deleteQuery( q : Query ) {
		// nothing to do
	}

	override function beginQuery( q : Query ) {
		// nothing
	}

	override function endQuery( q : Query ) {
		var heap = frame.queryHeaps[frame.queryCurrentHeap];
		if( heap == null ) {
			var desc = new QueryHeapDesc();
			desc.type = TIMESTAMP;
			desc.count = QUERY_COUNT;
			heap = Driver.createQueryHeap(desc);
			frame.queryHeaps[frame.queryCurrentHeap] = heap;
			if( frame.queryBuffer != null ) {
				frame.queryBuffer.release();
				frame.queryBuffer = null;
			}
		}
		q.offset = frame.queryHeapOffset++;
		q.heap = frame.queryCurrentHeap;
		frame.commandList.endQuery(heap, TIMESTAMP, q.offset);
		frame.queriesPending.push(q);
		if( frame.queryHeapOffset == QUERY_COUNT ) {
			frame.queryHeapOffset = 0;
			frame.queryCurrentHeap++;
		}
	}

	override function queryResultAvailable( q : Query ) {
		return q.heap < 0;
	}

	override function queryResult( q : Query ) {
		return q.result;
	}

	function beginQueries() {
		if( frame.queryBuffer == null || frame.queriesPending.length == 0 )
			return;
		var ptr : hl.BytesAccess<Int64> = frame.queryBuffer.map(0, null);
		while( true ) {
			var q = frame.queriesPending.pop();
			if( q == null ) break;
			if( q.heap >= 0 ) {
				var position = q.heap * QUERY_COUNT + q.offset;
				var v = ptr[position];
				q.result = ((v / tsFreq).low + (v % tsFreq).low / tsFreq.low) * 1e9;
				q.heap = -1;
			}
		}
		frame.queryBuffer.unmap(0, null);
	}

	function flushQueries() {
		if( frame.queryHeapOffset > 0 )
			frame.queryCurrentHeap++;
		if( frame.queryCurrentHeap == 0 )
			return;
		if( frame.queryBuffer == null )
			frame.queryBuffer = allocGPU(frame.queryHeaps.length * QUERY_COUNT * 8, READBACK, COPY_DEST);
		var position = 0;
		for( i in 0...frame.queryCurrentHeap ) {
			var count = i < frame.queryCurrentHeap - 1 ? QUERY_COUNT : frame.queryHeapOffset;
			frame.commandList.resolveQueryData(frame.queryHeaps[i], TIMESTAMP, 0, count, frame.queryBuffer, position);
			position += count * 8;
		}
		frame.queryCurrentHeap = 0;
		frame.queryHeapOffset = 0;
	}

	// --- DRAW etc.

	override function draw( ibuf : Buffer, startIndex : Int, ntriangles : Int ) {
		flushPipeline();
		if( currentIndex != ibuf ) {
			currentIndex = ibuf;
			transition(ibuf.vbuf, INDEX_BUFFER);
			frame.commandList.iaSetIndexBuffer(ibuf.vbuf.iview);
		}
		flushTransitions();
		frame.commandList.drawIndexedInstanced(ntriangles * 3,1,startIndex,0,0);
	}

	override function drawInstanced(ibuf:Buffer, commands:InstanceBuffer) {
		flushPipeline();
		if( currentIndex != ibuf ) {
			currentIndex = ibuf;
			transition(ibuf.vbuf, INDEX_BUFFER);
			frame.commandList.iaSetIndexBuffer(ibuf.vbuf.iview);
		}
		if( commands.data != null ) {
			transition(commands.data, INDIRECT_ARGUMENT);
			if ( commands.countBuffer != null )
				transition(commands.countBuffer, INDIRECT_ARGUMENT);
			flushTransitions();
			frame.commandList.executeIndirect(indirectCommand, commands.commandCount, commands.data.res, commands.offset * InstanceBuffer.ELEMENT_SIZE, commands.countBuffer != null ? commands.countBuffer.res : null, commands.countOffset * 4);
		} else {
			flushTransitions();
			frame.commandList.drawIndexedInstanced(commands.indexCount, commands.commandCount, commands.startIndex, 0, 0);
		}
	}

	override function flushShaderBuffers() {
		if( frame.shaderResourceViews.available < 128 || frame.samplerViews.available < 64 ) {
			frame.shaderResourceViews = frame.shaderResourceCache.next();
			frame.samplerViews = frame.samplerCache.next();
			heapCount++;
			var arr = tmp.descriptors2;
			arr[0] = @:privateAccess frame.shaderResourceViews.heap;
			arr[1] = @:privateAccess frame.samplerViews.heap;
			frame.commandList.setDescriptorHeaps(arr);
			inline function rebindGlobal(bindSlot, desc) {
				if ( bindSlot >= 0 ) {
					var srv = frame.shaderResourceViews.alloc(1);
					Driver.createConstantBufferView(desc, srv);
					if( currentShader.isCompute )
						frame.commandList.setComputeRootDescriptorTable(bindSlot, frame.shaderResourceViews.toGPU(srv));
					else
						frame.commandList.setGraphicsRootDescriptorTable(bindSlot, frame.shaderResourceViews.toGPU(srv));
				}
			}

			rebindGlobal(lastVertexGlobalBind, tmp.vertexGlobalDesc);
			rebindGlobal(lastFragmentGlobalBind, tmp.fragmentGlobalDesc);
		}
	}

	function flushSRV() {
		var count = 0;
		while( true ) {
			if( computeSRVBufferDistance() == 1 ) break;
			count++;
			if( count > 100000 ) {
				// we sometimes get thread starvation by just doing the while loop.
				// this might allow the SRV thread to catch up and get atomic locks.
				Sys.sleep(0);
				count = 0;
			}
		}
	}

	function flushFrame( onResize : Bool = false ) {
		flushQueries();
		frame.commandList.close();
		flushSRV();
		frame.commandList.execute();
		currentPipelineState = null;
		currentShader = null;
		Driver.flushMessages();
		frame.fenceValue = fenceValue++;
		Driver.signal(fence, frame.fenceValue);
	}

	override function present() {

		transition(frame.backBuffer, PRESENT);
		flushTransitions();
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

	override function computeDispatch( x : Int = 1, y : Int = 1, z : Int = 1, barrier : Bool = true ) {
		flushTransitions();
		frame.commandList.dispatch(x,y,z);
		if( barrier )
			memoryBarrier();
	}

	override function memoryBarrier() {
		var barrier = tmp.barrier;
		barrier.resource = null;
		@:privateAccess barrier.type = UAV;
		frame.commandList.resourceBarrier(barrier);
	}

}

#end
