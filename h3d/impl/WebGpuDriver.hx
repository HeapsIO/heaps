package h3d.impl;

import h3d.impl.Driver;
import h3d.impl.WebGpuApi;
import h3d.mat.Pass;
using hxsl.Ast;

class WebGpuSubShader {
	public var kind : GPUShaderStage;
	public var module : GPUShaderModule;
	public var paramsBufferSize : Int = 0;
	public var globalsBufferSize : Int = 0;
	public var paramsGroup : Int = 0;
	public var globalsGroup : Int = 0;
	public var texturesGroup : Int = 0;
	public var texturesCount : Int;
	public function new() {
	}
}

class WebGpuShader {
	public var format : hxd.BufferFormat;
	public var vertex : WebGpuSubShader;
	public var fragment : WebGpuSubShader;
	public var layout : GPUPipelineLayout;
	public var inputCount : Int;
	public var pipelines : PipelineCache<GPURenderPipeline> = new PipelineCache();
	public var groups : Array<GPUBindGroupLayout>;
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
	var pipelineBuilder = new PipelineCache.PipelineBuilder();
	var curStencilRef : Int;

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
		pipelineBuilder.setRenderTarget(tex, depthBinding != NotBound);
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

	override function setRenderTargets(textures:Array<h3d.mat.Texture>, depthBinding:h3d.Engine.DepthBinding = ReadWrite) {
		pipelineBuilder.setRenderTargets(textures, depthBinding != NotBound);
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
		curStencilRef = -1;
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

	override function allocTexture(t:h3d.mat.Texture):Texture {
		var tex = device.createTexture({
			size : { width : t.width, height : t.height },
			mipLevelCount : t.mipLevels,
			format : switch( t.format ) {
			case RGBA: Rgba8unorm;
			default: throw "Unsupported texture format "+t.format;
			},
			usage : TEXTURE_BINDING | COPY_DST,
		});
		return { tex : tex, view : tex.createView() };
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

	override function uploadTextureBitmap(t:h3d.mat.Texture, bmp:hxd.BitmapData, mipLevel:Int, side:Int) {
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	}

	override function uploadTexturePixels(t:h3d.mat.Texture, pixels:hxd.Pixels, mipLevel:Int, side:Int) {
		var bpp = hxd.Pixels.calcStride(pixels.width,pixels.format);
		device.queue.writeTexture({ texture : t.t.tex, mipLevel : mipLevel, origin : side == 0 ? js.Lib.undefined : { z : side } }, pixels.bytes.getData(), { bytesPerRow : bpp }, { width : pixels.width, height : pixels.height });
	}

	function isSampler(t) {
		return switch( t ) {
		case TArray(t,_) if( t.isSampler() ): true;
		default: t.isSampler();
		}
	}

	function compileShaderPart( shader : hxsl.RuntimeShader.RuntimeShaderData, groups : Array<Array<GPUBindGroupLayoutEntry>>, kind ) {
		var comp = new hxsl.WgslOut();
		var sh = new WebGpuSubShader();
		var textures = [];
		sh.kind = kind;
		for( v in shader.data.vars ) {
			switch( v.kind ) {
			case Param, Global:
				switch(v.type) {
				case TArray(t, SConst(n)) if( t.isSampler() ):
					for( i in 0...n )
						textures.push(t);
					continue;
				case t if( t.isSampler() ):
					textures.push(t);
					continue;
				default:
				}
				var index = groups.length;
				var size = hxsl.Ast.Tools.size(v.type) * 4;
				groups.push([{
					binding: 0,
					visibility : kind,
					buffer : {
						type : Uniform,
						hasDynamicOffset : false,
						minBindingSize: size,
					}
				}]);
				switch( v.kind ) {
				case Param:
					sh.paramsBufferSize = size;
					sh.paramsGroup = index;
					comp.paramsGroup = index;
				case Global:
					sh.globalsBufferSize = size;
					sh.globalsGroup = index;
					comp.globalsGroup = index;
				default:
				}
			default:
			}
		}

		if( textures.length > 0 ) {
			var index = groups.length;
			groups.push([
				for( t in textures ) {
					binding : 0,
					visibility : kind,
					texture: {
						sampleType : Float,
						viewDimension : D2,
					}
				}
			]);
			groups.push([
				for( t in textures ) {
					binding : 0,
					visibility : kind,
					sampler: {
						type : Filtering,
					}
				}
			]);
			sh.texturesGroup = comp.texturesGroup = index;
		}
		sh.texturesCount = textures.length;

		var source = comp.run(shader.data);
		#if debug_shaders
		trace(source);
		#end
		sh.module = device.createShaderModule({ code : source });
		return sh;
	}

	function makeShader( shader : hxsl.RuntimeShader ) {
		var sh = new WebGpuShader();
		var format : Array<hxd.BufferFormat.BufferInput> = [];
		for( v in shader.vertex.data.vars ) {
			switch( v.kind ) {
			case Input:
				var t = hxd.BufferFormat.InputFormat.fromHXSL(v.type);
				format.push({ name : v.name, type : t });
			default:
			}
		}
		var groupsDecls = [];
		sh.format = hxd.BufferFormat.make(format);
		sh.vertex = compileShaderPart(shader.vertex,groupsDecls,VERTEX);
		sh.fragment = compileShaderPart(shader.fragment,groupsDecls,FRAGMENT);
		#if debug_shaders
		trace(groupsDecls);
		#end
		sh.groups = [for( g in groupsDecls ) device.createBindGroupLayout({ entries: g })];
		sh.layout = device.createPipelineLayout({ bindGroupLayouts: sh.groups });
		sh.inputCount = format.length;
		return sh;
	}

	override function selectMaterial( pass : h3d.mat.Pass ) {
		pipelineBuilder.selectMaterial(pass);
		var st = pass.stencil;
		if( st != null && curStencilRef != st.reference ) {
			curStencilRef = st.reference;
			renderPass.setStencilReference(st.reference);
		}
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
		pipelineBuilder.setShader(shader);
		return true;
	}

	override function selectBuffer(buffer:Buffer) {
		var map = buffer.format.resolveMapping(currentShader.format);
		for( i in 0...currentShader.inputCount ) {
			renderPass.setVertexBuffer(i, buffer.vbuf);
			pipelineBuilder.setBuffer(i, map[i], buffer.format.strideBytes);
		}
	}

	override function uploadShaderBuffers(buffers:h3d.shader.Buffers, which:h3d.shader.Buffers.BufferKind) {
		_uploadShaderBuffers(buffers.vertex, which, currentShader.vertex);
		_uploadShaderBuffers(buffers.fragment, which, currentShader.fragment);
	}

	function createSampler( t : h3d.mat.Texture ) {
		return device.createSampler();
	}

	function _uploadShaderBuffers(buffers:h3d.shader.Buffers.ShaderBuffers, which:h3d.shader.Buffers.BufferKind, sh:WebGpuSubShader) {
		switch( which ) {
		case Globals, Params:
			var size = which == Params ? sh.paramsBufferSize : sh.globalsBufferSize;
			if( size == 0 )
				return;
			var buffer = device.createBuffer({
				size : size,
				usage : UNIFORM,
				mappedAtCreation : true,
			});
			var map = buffer.getMappedRange();
			new js.lib.Float32Array(map).set(cast (which == Params ? buffers.params : buffers.globals));
			buffer.unmap();
			var index = which == Params ? sh.paramsGroup : sh.globalsGroup;
			var group = device.createBindGroup({
				layout : currentShader.groups[index],
				entries: [{
					binding: 0,
					resource: {
						buffer : buffer,
					}
				}],
			});
			renderPass.setBindGroup(index, group);
		case Textures:
			if( sh.texturesCount == 0 )
				return;
			var index = sh.texturesGroup;
			var group = device.createBindGroup({
				layout : currentShader.groups[index],
				entries: [
					for( i in 0...sh.texturesCount ) {
						binding : i,
						resource : {
							var t = buffers.tex[i];
							if( t.t == null && t.realloc != null ) t.realloc();
							t.t.view;
						}
					}
				]
			});
			var samplers = device.createBindGroup({
				layout : currentShader.groups[index+1],
				entries: [
					for( i in 0...sh.texturesCount ) {
						binding : i,
						resource : createSampler(buffers.tex[i]),
					}
				]
			});
			renderPass.setBindGroup(index, group);
			renderPass.setBindGroup(index+1, samplers);
		case Buffers:
			if( buffers.buffers == null || buffers.buffers.length == 0 )
				return;
			throw "TODO";
		}
	}

	function flushPipeline() {
		if( !pipelineBuilder.needFlush ) return;
		var cache = pipelineBuilder.lookup(currentShader.pipelines, currentShader.inputCount);
		if( cache.pipeline == null )
			cache.pipeline = makePipeline(currentShader);
		renderPass.setPipeline(cache.pipeline);
	}

	function makePipeline( sh : WebGpuShader ) {
		var buffers : Array<GPUVertexBufferLayout> = [];
		var pass = pipelineBuilder.getCurrentPass();
		var targets = [{
			format : Bgra8unorm,
			writeMask : pass.colorMask,
			blend : {
				color : {
					operation : OP[pass.blendOp.getIndex()],
					srcFactor : BLEND[pass.blendSrc.getIndex()],
					dstFactor : BLEND[pass.blendDst.getIndex()],
				},
				alpha : {
					operation : OP[pass.blendAlphaOp.getIndex()],
					srcFactor : BLEND[pass.blendAlphaSrc.getIndex()],
					dstFactor : BLEND[pass.blendAlphaDst.getIndex()],
				},
			},
		}];
		for( i in 0...sh.inputCount ) {
			var inf = pipelineBuilder.getBufferInput(i);
			var type = @:privateAccess currentShader.format.inputs[i].type;
			if( inf.precision != F32 ) throw "TODO";
			buffers.push({
				attributes: [{ shaderLocation : i, offset : inf.offset, format :
					switch( type ) {
					case DFloat: Float32;
					case DVec2: Float32x2;
					case DVec3: Float32x3;
					case DVec4: Float32x4;
					case DBytes4: Uint8x4;
					}
				}],
				arrayStride : pipelineBuilder.getBufferStride(i),
				stepMode: GPUVertexStepMode.Vertex,
			});
		}
		var pipeline = device.createRenderPipeline({
			layout : sh.layout,
			vertex : { module : sh.vertex.module, entryPoint : "main", buffers : buffers },
			fragment : { module : sh.fragment.module, entryPoint : "main", targets : targets },
			primitive : { frontFace : CW, cullMode : switch( pass.culling ) { case None, Both: None; case Back: Back; case Front: Front; }, topology : Triangle_list },
			depthStencil : {
				depthWriteEnabled: pass.depthWrite,
				depthCompare: COMPARE[pass.depthTest.getIndex()],
				format: Depth24plus_stencil8
			}
		});
		return pipeline;
	}

	override function draw(ibuf:IndexBuffer, startIndex:Int, ntriangles:Int) {
		flushPipeline();
		renderPass.setIndexBuffer(ibuf.buf, ibuf.stride==2?Uint16:Uint32, startIndex*ibuf.stride);
		renderPass.drawIndexed(ntriangles*3);
	}

	static var COMPARE : Array<GPUCompareFunction> = [
		Always,
		Never,
		Equal,
		Not_equal,
		Greater,
		Greater_equal,
		Less,
		Less_equal,
	];

	static var OP : Array<GPUBlendOperation> = [
		Add,
		Subtract,
		Reverse_subtract,
		Min,
		Max,
	];

	static var BLEND : Array<GPUBlendFactor> = [
		One,
		Zero,
		Src_alpha,
		Src,
		Dst_alpha,
		Dst,
		One_minus_src_alpha,
		One_minus_src,
		One_minus_dst_alpha,
		One_minus_dst,
	];

	static var inst : WebGpuDriver;
	static function checkReady() {
		return true;
	}

}
