package h3d.impl;

#if (hldx && dx12)

import h3d.impl.Driver;
import dx.Dx12;
import haxe.Int64;
import h3d.mat.Pass;

private typedef Driver = Dx12;

class DxFrame {
	public var backbuffer : Resource;
	public var allocator : CommandAllocator;
	public var commandList : CommandList;
	public var fenceValue : Int64;
	public var toRelease : Array<Resource> = [];
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

class CompiledShader {
	public var inputCount : Int;
	public var inputNames : InputNames;
	public var pipeline : GraphicsPipelineStateDesc;
	public var pipelines : Map<Int,hl.NativeArray<CachedPipeline>> = new Map();
	public var rootSignature : RootSignature;
	public var inputLayout : hl.CArray<InputElementDesc>;
	public function new() {
	}
}

@:struct class TempObjects {

	public var renderTargets : hl.BytesAccess<Address>;
	public var depthStencils : hl.BytesAccess<Address>;
	public var vertexViews : hl.CArray<VertexBufferView>;
	@:packed public var heap(default,null) : HeapProperties;
	@:packed public var barrier(default,null) : ResourceBarrier;
	@:packed public var clearColor(default,null) : ClearColor;
	@:packed public var viewport(default,null) : Viewport;
	@:packed public var rect(default,null) : Rect;

	public var pass : h3d.mat.Pass;

	public function new() {
		renderTargets = new hl.Bytes(8 * 8);
		depthStencils = new hl.Bytes(8 * 8);
		vertexViews = hl.CArray.alloc(VertexBufferView, 16);
		pass = new h3d.mat.Pass("default");
		pass.stencil = new h3d.mat.Stencil();
	}

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
	var heap : DescriptorHeap;
	var rtvDescSize : Int;
	var rtvAddress : Address;
	var currentFrame : Int;
	var fenceValue : Int64 = 0;
	var needPipelineFlush = false;
	var currentPass : h3d.mat.Pass;
	var renderTargetCount = 1;

	var currentWidth : Int;
	var currentHeight : Int;

	var currentShader : CompiledShader;
	var compiledShaders : Map<Int,CompiledShader> = new Map();
	var compiler : ShaderCompiler;

	var tmp : TempObjects;

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
			frames.push(f);
		}
		fence = new Fence(0, NONE);
		fenceEvent = new WaitEvent(false);
		tmp = new TempObjects();

		var inf = new DescriptorHeapDesc();
		inf.type = RTV;
		inf.numDescriptors = BUFFER_COUNT;
		heap = new DescriptorHeap(inf);
		rtvDescSize = Driver.getDescriptorHandleIncrementSize(RTV);
		rtvAddress = heap.getHandle(false);

		compiler = new ShaderCompiler();
	}

	function beginFrame() {
		currentFrame = Driver.getCurrentBackBufferIndex();
		frame = frames[currentFrame];
		frame.allocator.reset();
		frame.commandList.reset(frame.allocator, null);
		while( frame.toRelease.length > 0 )
			frame.toRelease.pop().release();

		var b = tmp.barrier;
		b.resource = frame.backbuffer;
		b.subResource = -1;
		b.stateBefore = PRESENT;
		b.stateAfter = RENDER_TARGET;
		frame.commandList.resourceBarrier(b);

		var clear = tmp.clearColor;
		clear.r = 0.4;
		clear.g = 0.6;
		clear.b = 0.9;
		clear.a = 1.0;
		frame.commandList.clearRenderTargetView(rtvAddress.offset(currentFrame * rtvDescSize), clear);

		tmp.viewport.width = currentWidth;
		tmp.viewport.height = currentHeight;
		tmp.viewport.maxDepth = 1;
		tmp.rect.right = currentWidth;
		tmp.rect.bottom = currentHeight;
		frame.commandList.iaSetPrimitiveTopology(TRIANGLELIST);
		frame.commandList.rsSetScissorRects(1, tmp.rect);
		frame.commandList.rsSetViewports(1, tmp.viewport);

		tmp.renderTargets[0] = rtvAddress.offset(currentFrame * rtvDescSize);
		frame.commandList.omSetRenderTargets(1, tmp.renderTargets, true, null);
	}

	static var VERTEX_FORMATS = [null,null,R32G32_FLOAT,R32G32B32_FLOAT,R32G32B32A32_FLOAT];

	function compileShader( shader : hxsl.RuntimeShader ) : CompiledShader {
		function compileSource( sh : hxsl.RuntimeShader.RuntimeShaderData, profile ) {
			var args = [];
			var out = new hxsl.HlslOut();
			var source = out.run(sh.data);
			return compiler.compile(source, profile, args);
		}
		var vs = compileSource(shader.vertex, "vs_6_0");
		var ps = compileSource(shader.fragment, "ps_6_0");
		var sign = new RootSignatureDesc();
		sign.flags.set(ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

		var signSize = 0;
		var signBytes = Driver.serializeRootSignature(sign, 1, signSize);
		var sign = new RootSignature(signBytes,signSize);

		var inputs = [];
		for( v in shader.vertex.data.vars )
			if( v.kind == Input )
				inputs.push(v);

		var inputLayout = hl.CArray.alloc(InputElementDesc, inputs.length);
		for( i => v in inputs ) {
			var d = inputLayout[i];
			var perInst = 0;
			if( v.qualifiers != null )
				for( q in v.qualifiers )
					switch( q ) {
					case PerInstance(k): perInst = k;
					default:
					}
			d.semanticName = @:privateAccess hxsl.HlslOut.semanticName(v.name).toUtf8();
			d.format = switch( v.type ) {
				case TFloat: R32_FLOAT;
				case TVec(2, VFloat): R32G32_FLOAT;
				case TVec(3, VFloat): R32G32B32_FLOAT;
				case TVec(4, VFloat): R32G32B32A32_FLOAT;
				case TBytes(4): R8G8B8A8_UINT;
				default:
					throw "Unsupported input type " + hxsl.Ast.Tools.toString(v.type);
			};
			d.inputSlot = i;
			if( perInst > 0 ) {
				d.inputSlotClass = PER_INSTANCE_DATA;
				d.instanceDataStepRate = perInst;
			} else
				d.inputSlotClass = PER_VERTEX_DATA;
			d.alignedByteOffset = 1; // will trigger error if not set in makePipeline()
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
		p.sampleDesc.count = 1;
		p.sampleMask = -1;
		p.inputLayout.inputElementDescs = inputLayout[0];
		p.inputLayout.numElements = inputLayout.length;

		var c = new CompiledShader();
		c.inputNames = InputNames.get([for( v in inputs ) v.name]);
		c.pipeline = p;
		c.rootSignature = sign;
		c.inputLayout = inputLayout;
		c.inputCount = inputs.length;
		return c;
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
		return true;
	}

	override function getShaderInputNames() : InputNames {
		return currentShader.inputNames;
	}

	override function dispose() {
	}

	override function resize(width:Int, height:Int)  {

		if( currentWidth == width && currentHeight == height )
			return;

		currentWidth = width;
		currentHeight = height;

		if( frame != null )
			frame.commandList.close();

		Driver.signal(fence, fenceValue);
		fence.setEvent(fenceValue, fenceEvent);
		fenceEvent.wait(-1);
		fenceValue++;

		for( f in frames )
			if( f.backbuffer != null )
				f.backbuffer.release();

		if( !Driver.resize(width, height, BUFFER_COUNT, R8G8B8A8_UNORM) )
			throw "Failed to resize backbuffer to " + width + "x" + height;

		for( i => f in frames ) {
			f.backbuffer = Driver.getBackBuffer(i);
			Driver.createRenderTargetView(f.backbuffer, null, rtvAddress.offset(i * rtvDescSize));
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

	function allocBuffer( size : Int, isCpu : Bool ) {
		var desc = new ResourceDesc();
		var flags = new haxe.EnumFlags();
		desc.dimension = BUFFER;
		desc.width = size;
		desc.height = 1;
		desc.depthOrArraySize = 1;
		desc.mipLevels = 1;
		desc.sampleDesc.count = 1;
		desc.layout = ROW_MAJOR;
		tmp.heap.type = isCpu ? UPLOAD : DEFAULT;
		return Driver.createCommittedResource(tmp.heap, flags, desc, isCpu ? GENERIC_READ : COPY_DEST, null);
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		var size = (m.size * m.stride) << 2;
		var res = allocBuffer(size, false);
		var view = new VertexBufferView();
		view.bufferLocation = res.getGpuVirtualAddress();
		view.sizeInBytes = size;
		view.strideInBytes = m.stride << 2;
		return { res : res, view : view, stride : m.stride };
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		var bits = is32?2:1;
		var size = count << bits;
		var res = allocBuffer(size, false);
		var view = new IndexBufferView();
		view.bufferLocation = res.getGpuVirtualAddress();
		view.format = is32 ? R32_UINT : R16_UINT;
		view.sizeInBytes = size;
		return { res : res, count : count, bits : bits, view : view };
	}

	function updateBuffer( res : GpuResource, bytes : hl.Bytes, startByte : Int, bytesCount : Int, targetState ) {
		var tmpBuf = allocBuffer(bytesCount, true);
		var ptr = tmpBuf.map(0, null);
		ptr.blit(0, bytes, 0, bytesCount);
		tmpBuf.unmap(0,null);
		frame.commandList.copyBufferRegion(res, startByte, tmpBuf, 0, bytesCount);
		var b = tmp.barrier;
		b.resource = res;
		b.stateBefore = COPY_DESC;
		b.stateAfter = targetState;
		frame.commandList.resourceBarrier(b);
		frame.toRelease.push(tmpBuf);
	}

	override function uploadIndexBuffer(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:hxd.IndexBuffer, bufPos:Int) {
		updateBuffer(i.res, hl.Bytes.getArray(buf.getNative()).offset(bufPos << i.bits), startIndice << i.bits, indiceCount << i.bits, INDEX_BUFFER);
	}

	override function uploadIndexBytes(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		updateBuffer(i.res, @:privateAccess buf.b.offset(bufPos << i.bits), startIndice << i.bits, indiceCount << i.bits, INDEX_BUFFER);
	}

	override function uploadVertexBuffer(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:hxd.FloatBuffer, bufPos:Int) {
		var data = hl.Bytes.getArray(buf.getNative()).offset(bufPos<<2);
		updateBuffer(v.res, data, startVertex * v.stride << 2, vertexCount * v.stride << 2, VERTEX_AND_CONSTANT_BUFFER);
	}

	override function uploadVertexBytes(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		updateBuffer(v.res, @:privateAccess buf.b.offset(bufPos << 2), startVertex * v.stride << 2, vertexCount * v.stride << 2, VERTEX_AND_CONSTANT_BUFFER);
	}

	function waitForFrame( index : Int ) {
		var frame = frames[index];
		if( fence.getValue() < frame.fenceValue ) {
			fence.setEvent(frame.fenceValue, fenceEvent);
			fenceEvent.wait(-1);
		}
	}

	override function selectBuffer(buffer:Buffer) {
		throw "TODO";
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

		p.numRenderTargets = renderTargetCount;
		p.rasterizerState.cullMode = CULL[cull];
		p.rasterizerState.fillMode = wire == 0 ? SOLID : WIREFRAME;
		p.depthStencilDesc.depthEnable = cmp != 0;
		p.depthStencilDesc.depthWriteMask = dw == 0 ? ZERO : ALL;
		p.depthStencilDesc.depthFunc = COMP[cmp];

		var bl = p.blendState;
		for( i in 0...renderTargetCount ) {
			var t = bl.renderTargets[i];
			t.blendEnable = csrc != 0 || cdst != 1;
			t.srcBlend = BLEND[csrc];
			t.dstBlend = BLEND[cdst];
			t.srcBlendAlpha = BLEND_ALPHA[asrc];
			t.dstBlendAlpha = BLEND_ALPHA[adst];
			t.blendOp = BLEND_OP[cop];
			t.blendOpAlpha = BLEND_OP[aop];
			t.renderTargetWriteMask = colorMask;
		}
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
		frame.commandList.setGraphicsRootSignature(currentShader.rootSignature);
		frame.commandList.setPipelineState(cp.pipeline);
	}

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		flushPipeline();
		frame.commandList.iaSetIndexBuffer(ibuf.view);
		frame.commandList.drawIndexedInstanced(ibuf.count,1,0,0,0);
	}

	override function present() {
		var barrier = tmp.barrier;
		barrier.resource = frame.backbuffer;
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

}

#end
