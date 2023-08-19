package h3d.impl;

import h3d.impl.Driver;
import h3d.impl.WebGpuApi;
import h3d.mat.Pass;

class WebGpuShader {
	public var inputs : InputNames;
	public var pipeline : GPURenderPipeline;
	public function new() {
	}
}

class WebGpuFrame {
	public var colorTex : GPUTexture;
	public var depthTex : GPUTexture;
	public var colorView : GPUTextureView;
	public var depthView : GPUTextureView;
	public var toDelete : Array<{ function destroy() : Void; }> = [];
	public function new() {
	}
}

class WebGpuDriver extends h3d.impl.Driver {

	var canvas : js.html.CanvasElement;
	var context : GPUCanvasContext;
	var device : GPUDevice;

	var commandList : GPUCommandEncoder;
	var renderPass : GPURenderPassEncoder;
	var renderPassDesc : GPURenderPassDescriptor;
	var needClear : Bool;
	var currentShader : WebGpuShader;
	var shaderCache : Map<Int, WebGpuShader> = new Map();
	var frames : Array<WebGpuFrame> = [];
	var frame : WebGpuFrame;
	var frameCount : Int = 0;

	public function new() {
		inst = this;
	}

	override function isDisposed() {
		return false;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		var gpu = GPU.get();
		if( gpu == null )
			throw "Device does not support WebGPU";
		gpu.requestAdapter().then(function(adapt) {
			adapt.requestDevice().then(function(device) {
				this.device = device;
				canvas = @:privateAccess hxd.Window.getInstance().canvas;
				context = cast canvas.getContext("webgpu");
				resize(canvas.width, canvas.height);
				onCreate(false);
			});
		});
	}

	override function resize(width:Int, height:Int) {
		if( canvas.style.width == "" ) {
			canvas.style.width = Std.int(width / js.Browser.window.devicePixelRatio)+"px";
			canvas.style.height = Std.int(height / js.Browser.window.devicePixelRatio)+"px";
		}
		canvas.width = width;
		canvas.height = height;

		context.configure({
			device : device,
			format : Bgra8unorm,
			usage : (RENDER_ATTACHMENT:GPUTextureUsageFlags) | COPY_SRC,
			alphaMode : Opaque,
		});

		if( frames != null ) {
			for( f in frames ) {
				f.depthTex.destroy();
				for( t in f.toDelete )
					t.destroy();
			}
		}

		frames = [];
		for( i in 0...2 ) {
			var f = new WebGpuFrame();
			f.depthTex = device.createTexture({
				size : { width : width, height : height },
				dimension : D2,
				format : Depth24plus_stencil8,
				usage : (RENDER_ATTACHMENT:GPUTextureUsageFlags) | COPY_SRC,
			});
			f.depthView = f.depthTex.createView();
			frames.push(f);
		}

		frameCount = 0;
		beginFrame();
	}

	override function setRenderTarget(tex:Null<h3d.mat.Texture>, layer:Int = 0, mipLevel:Int = 0) {
		flushPass();
		if( tex == null ) {
			renderPassDesc = {
				colorAttachments : [{
					view : frame.colorView,
					loadOp : Load,
					storeOp: Store
				}],
				depthStencilAttachment: {
					view : frame.depthView,
					depthLoadOp: Load,
					depthStoreOp: Store,
					stencilLoadOp: Load,
					stencilStoreOp: Store,
				},
			};
			return;
		}
		throw "TODO";
	}

	function beginFrame() {
		if( device == null ) return;
		frame = frames[(frameCount++)%frames.length];
		frame.colorTex = context.getCurrentTexture();
		frame.colorView = frame.colorTex.createView();
		for( t in frame.toDelete )
			t.destroy();
		frame.toDelete = [];
		commandList = device.createCommandEncoder();
		setRenderTarget(null);
		currentShader = null;
	}

	function beginPass() {
		if( renderPass != null )
			return;
		renderPass = commandList.beginRenderPass(renderPassDesc);
		for( c in renderPassDesc.colorAttachments )
			c.clearValue = js.Lib.undefined;
		var depth = renderPassDesc.depthStencilAttachment;
		if( depth != null ) {
			depth.depthClearValue = js.Lib.undefined;
			depth.stencilClearValue = js.Lib.undefined;
		}
		needClear = false;
	}

	function flushPass() {
		if( needClear ) {
			if( renderPass != null ) throw "assert";
			beginPass();
		}
		if( renderPass != null ) {
			renderPass.end();
			renderPass = null;
		}
	}

	function flushFrame() {
		flushPass();
		if( commandList != null ) {
			device.queue.submit([commandList.finish()]);
			commandList = null;
		}
		frame = frame == frames[0] ? frames[1] : frames[0];
	}

	override function begin(frame:Int) {
		beginFrame();
	}

	override function present() {
		flushFrame();
	}

	override function clear(?color:h3d.Vector, ?depth:Float, ?stencil:Int) {
		if( renderPass != null )
			flushPass();
		if( color != null ) {
			for( c in renderPassDesc.colorAttachments ) {
				c.clearValue = { r : color.r, g : color.g, b : color.b, a : color.a };
				c.loadOp = Clear;
			}
		}
		var ds = renderPassDesc.depthStencilAttachment;
		if( ds != null ) {
			if( depth != null ) {
				ds.depthClearValue = depth;
				ds.depthLoadOp = Clear;
			}
			if( stencil != null ) {
				ds.stencilClearValue = stencil;
				ds.stencilLoadOp = Clear;
			}
		}
		needClear = true;
	}

	override function getDriverName(details:Bool) {
		return "WebGPU";
	}

	override function allocVertexes(m:ManagedBuffer):VertexBuffer {
		return allocBuffer(VERTEX,m.size,m.stride << 2);
	}

	override function allocIndexes(count:Int, is32:Bool):IndexBuffer {
		return allocBuffer(INDEX,count,is32?2:4);
	}

	function allocBuffer(type:GPUBufferUsage,count,stride) {
		var buf = device.createBuffer({
			size : count * stride,
			usage : (type:GPUBufferUsageFlags) | COPY_DST,
			mappedAtCreation: false,
		});
		return { buf : buf, count : count, stride : stride };
	}

	override function uploadVertexBytes(v:VertexBuffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		uploadBuffer(v,startVertex,vertexCount,buf,bufPos);
	}

	override function uploadIndexBytes(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		uploadBuffer(i,startIndice,indiceCount,buf,bufPos);
	}

	function uploadBuffer(b:VertexBuffer,start:Int,count:Int,buf:haxe.io.Bytes, bufPos:Int) {
		var size = count * b.stride;
		var tmpBuf = device.createBuffer({
			size : size,
			usage : (MAP_WRITE:GPUBufferUsageFlags) | COPY_SRC,
			mappedAtCreation : true,
		});
		new js.lib.Uint8Array(tmpBuf.getMappedRange()).set(cast buf.getData(), bufPos);
		tmpBuf.unmap();
		// copy
		commandList.copyBufferToBuffer(tmpBuf,0,b.buf,start*b.stride,size);
		// delete later
		frame.toDelete.push(tmpBuf);
	}


	function compile( shader : hxsl.RuntimeShader.RuntimeShaderData ) {
		var comp = new hxsl.WgslOut();
		var source = comp.run(shader.data);
		trace(source);
		return device.createShaderModule({ code : source });
	}

	function makeShader( shader : hxsl.RuntimeShader ) {
		var sh = new WebGpuShader();
		var attribNames = [];
		for( v in shader.vertex.data.vars ) {
			if( v.kind != Input ) continue;
			attribNames.push(v.name);
		}
		sh.inputs = InputNames.get(attribNames);

		var vertex = compile(shader.vertex);
		var fragment = compile(shader.fragment);

		var layout = device.createPipelineLayout({ bindGroupLayouts: [] });
		var pipeline = device.createRenderPipeline({
			layout : layout,
			vertex : { module : vertex, entryPoint : "main", buffers : [
				{
					attributes: [{ shaderLocation : 0, offset : 0, format : Float32x3 }],
					arrayStride: 4 * 3,
					stepMode: GPUVertexStepMode.Vertex
				},
				{
					attributes: [{ shaderLocation : 1, offset : 0, format : Float32x3 }],
					arrayStride: 4 * 3, // sizeof(float) * 3
					stepMode: GPUVertexStepMode.Vertex
				}
			]},
			fragment : { module : fragment, entryPoint : "main", targets : [{ format : Bgra8unorm }] },
			primitive : { frontFace : CW, cullMode : None, topology : Triangle_list },
			depthStencil : {
				depthWriteEnabled: true,
				depthCompare: Less,
				format: Depth24plus_stencil8
			}
		});

		sh.pipeline = pipeline;

		return sh;
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var sh = shaderCache.get(shader.id);
		if( sh == null ) {
			sh = makeShader(shader);
			shaderCache.set(shader.id, sh);
		}
		if( sh == currentShader )
			return false;
		currentShader = sh;
		beginPass();
		renderPass.setPipeline(sh.pipeline);
		return true;
	}

	override function getShaderInputNames():InputNames {
		return currentShader.inputs;
	}

	override function draw(ibuf:IndexBuffer, startIndex:Int, ntriangles:Int) {
		renderPass.setIndexBuffer(ibuf.buf, ibuf.stride==2?Uint16:Uint32, startIndex*ibuf.stride);
		renderPass.draw(ntriangles*3);
	}

	static var inst : WebGpuDriver;
	static function checkReady() {
		return true;
	}

}
