package h3d.impl;

import h3d.impl.Driver;
import h3d.impl.WebGpuApi;
import h3d.mat.Pass;

class WebGpuShader {
	public var format : hxd.BufferFormat;
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
	var commandUpload : GPUCommandEncoder;
	var renderPass : GPURenderPassEncoder;
	var renderPassDesc : GPURenderPassDescriptor;
	var needClear : Bool;
	var currentShader : WebGpuShader;
	var shadersCache : Map<Int, WebGpuShader> = new Map();
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

	override function setRenderTarget(tex:Null<h3d.mat.Texture>, layer:Int = 0, mipLevel:Int = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
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
		if( commandList != null || commandUpload != null ) {
			var arr = [];
			if( commandUpload != null ) arr.push(commandUpload.finish());
			if( commandList != null ) arr.push(commandList.finish());
			device.queue.submit(arr);
			commandUpload = null;
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

	override function allocBuffer( b : h3d.Buffer ):GPUBuffer {
		return _allocBuffer(VERTEX,b.vertices,b.format.strideBytes);
	}

	override function allocIndexes(count:Int, is32:Bool):IndexBuffer {
		var stride = is32?4:2;
		var buf = _allocBuffer(INDEX,count,stride);
		return { buf : buf, stride : stride };
	}

	function _allocBuffer(type:GPUBufferUsage,count,stride) {
		var totSize = count * stride;
		return device.createBuffer({
			size : (totSize + 3) & ~3,
			usage : (type:GPUBufferUsageFlags),
			mappedAtCreation: true,
		});
	}

	override function uploadBufferData( b : Buffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var buf : js.lib.Float32Array = buf.getNative();
		var buf = new js.lib.Float32Array(buf.buffer, bufPos * 4, vertexCount * b.format.strideBytes >> 2);
		uploadBuffer(b.vbuf,b.format.stride,startVertex,vertexCount,buf,0);
	}

	override function uploadBufferBytes(v:h3d.Buffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		uploadBuffer(v.vbuf,v.format.stride,startVertex,vertexCount,cast buf.getData(),bufPos);
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var buf = new js.lib.Uint16Array(buf.getNative());
		var sub = new js.lib.Uint16Array(buf.buffer, bufPos * i.stride, indiceCount);
		uploadBuffer(i.buf,i.stride,startIndice,indiceCount,sub,0);
	}

	override function uploadIndexBytes(i:IndexBuffer, startIndice:Int, indiceCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		uploadBuffer(i.buf,i.stride,startIndice,indiceCount,cast buf.getData(),bufPos);
	}

	function uploadBuffer(buf:GPU_Buffer,stride:Int,start:Int,count:Int,data:Dynamic,bufPos:Int) {
		/*
		var size = ((count * stride) + 3) & ~3;
		var tmpBuf = device.createBuffer({
			size : size,
			usage : (MAP_WRITE:GPUBufferUsageFlags) | COPY_SRC,
			mappedAtCreation : true,
		});
		new js.lib.Uint8Array(tmpBuf.getMappedRange()).set(data, bufPos);
		tmpBuf.unmap();
		// copy
		if( commandUpload == null )
			commandUpload = device.createCommandEncoder();
		commandUpload.copyBufferToBuffer(tmpBuf,0,buf,start*stride,size);
		// delete later
		frame.toDelete.push(tmpBuf);
		*/
		var map = buf.getMappedRange();
		if( data is js.lib.Uint16Array )
			new js.lib.Uint16Array(map).set(data,bufPos);
		else if( data is js.lib.Float32Array )
			new js.lib.Float32Array(map).set(data,bufPos);
		else
			new js.lib.Uint8Array(map).set(data,bufPos);
		buf.unmap();
	}


	function compile( shader : hxsl.RuntimeShader.RuntimeShaderData ) {
		var comp = new hxsl.WgslOut();
		var source = comp.run(shader.data);
		trace(source);
		return device.createShaderModule({ code : source });
	}

	function makeShader( shader : hxsl.RuntimeShader ) {
		var sh = new WebGpuShader();
		var format : Array<hxd.BufferFormat.BufferInput> = [];
		for( v in shader.vertex.data.vars ) {
			if( v.kind != Input ) continue;
			var t = hxd.BufferFormat.InputFormat.fromHXSL(v.type);
			format.push({ name : v.name, type : t });
		}
		sh.format = hxd.BufferFormat.make(format);

		var vertex = compile(shader.vertex);
		var fragment = compile(shader.fragment);

		var layout = device.createPipelineLayout({ bindGroupLayouts: [] });
		var pipeline = device.createRenderPipeline({
			layout : layout,
			vertex : { module : vertex, entryPoint : "main", buffers : [
				{
					attributes: [{ shaderLocation : 0, offset : 0, format : Float32x3 }],
					arrayStride: 4 * 6,
					stepMode: GPUVertexStepMode.Vertex
				},
				{
					attributes: [{ shaderLocation : 1, offset : 3*4, format : Float32x3 }],
					arrayStride: 4 * 6, // sizeof(float) * 3
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
		var sh = shadersCache.get(shader.id);
		if( sh == null ) {
			sh = makeShader(shader);
			shadersCache.set(shader.id, sh);
		}
		if( sh == currentShader )
			return false;
		currentShader = sh;
		beginPass();
		renderPass.setPipeline(sh.pipeline);
		return true;
	}

	override function selectBuffer(b:Buffer) {
		for( i in 0...@:privateAccess currentShader.format.inputs.length )
			renderPass.setVertexBuffer(i, b.vbuf);
	}

	override function draw(ibuf:IndexBuffer, startIndex:Int, ntriangles:Int) {
		renderPass.setIndexBuffer(ibuf.buf, ibuf.stride==2?Uint16:Uint32, startIndex*ibuf.stride);
		renderPass.drawIndexed(ntriangles*3);
	}

	static var inst : WebGpuDriver;
	static function checkReady() {
		return true;
	}

}
