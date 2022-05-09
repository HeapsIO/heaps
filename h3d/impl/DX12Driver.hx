package h3d.impl;

#if (hldx && dx12)

import h3d.impl.Driver;
import dx.Dx12;
import haxe.Int64;

private typedef Driver = Dx12;

class DxFrame {
	public var backbuffer : Resource;
	public var allocator : CommandAllocator;
	public var commandList : CommandList;
	public var fenceValue : Int64;
	public function new() {
	}
}

class CompiledShader {
	public var inputNames : InputNames;
	public function new() {
	}
}

class DX12Driver extends h3d.impl.Driver {

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
	var barrier = new ResourceBarrier();
	var clearColor = new ClearColor();
	var fenceValue : Int64 = 0;

	var currentWidth : Int;
	var currentHeight : Int;

	var currentShader : CompiledShader;
	var compiledShaders : Map<Int,CompiledShader> = new Map();
	var compiler : ShaderCompiler;

	static var BUFFER_COUNT = 2;

	public function new() {
		window = @:privateAccess dx.Window.windows[0];
		reset();
	}

	function reset() {
		var flags = new DriverInitFlags();
		flags.set(Debug);
		driver = Driver.create(window, flags);
		frames = [];
		for(i in 0...BUFFER_COUNT) {
			var f = new DxFrame();
			f.allocator = new CommandAllocator(Direct);
			f.commandList = new CommandList(Direct, f.allocator, null);
			f.commandList.close();
			frames.push(f);
		}
		fence = new Fence(0, None);
		fenceEvent = new WaitEvent(false);

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

		barrier.resource = frame.backbuffer;
		barrier.subResource = -1;
		barrier.stateBefore = Present;
		barrier.stateAfter = RenderTarget;
		frame.commandList.resourceBarrier(barrier);

		clearColor.r = 0.4;
		clearColor.g = 0.6;
		clearColor.b = 0.9;
		clearColor.a = 1.0;
		frame.commandList.clearRenderTargetView(rtvAddress.offset(currentFrame * rtvDescSize), clearColor);
	}

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
		var signSize = 0;
		var signBytes = Driver.serializeRootSignature(sign, 1, signSize);
		var sign = new RootSignature(signBytes,signSize);
		var p = new GraphicsPipelineStateDesc();
		var state = Driver.createGraphicsPipelineState(p);
		throw "TODO";
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

		if( !Driver.resize(width, height, BUFFER_COUNT) )
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

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return {};
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		return {};
	}

	function waitForFrame( index : Int ) {
		var frame = frames[index];
		if( fence.getValue() < frame.fenceValue ) {
			fence.setEvent(frame.fenceValue, fenceEvent);
			fenceEvent.wait(-1);
		}
	}

	override function present() {
		barrier.resource = frame.backbuffer;
		barrier.subResource = -1;
		barrier.stateBefore = RenderTarget;
		barrier.stateAfter = Present;
		frame.commandList.resourceBarrier(barrier);

		frame.commandList.close();
		frame.commandList.execute();

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
