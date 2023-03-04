package h3d.impl;

import h3d.impl.Driver;
import h3d.impl.WebGpuApi;
import h3d.mat.Pass;

class WebGpuDriver extends h3d.impl.Driver {

	var canvas : js.html.CanvasElement;
	var context : GPUCanvasContext;
	var device : GPUDevice;

	var colorTex : GPUTexture;
	var depthTex : GPUTexture;
	var colorView : GPUTextureView;
	var depthView : GPUTextureView;
	var commandList : GPUCommandEncoder;
	var renderPass : GPURenderPassEncoder;
	var renderPassDesc : GPURenderPassDescriptor;
	var needClear : Bool;

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
				beginFrame();
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

		colorTex = context.getCurrentTexture();
		colorView = colorTex.createView();
		depthTex = device.createTexture({
			size : { width : width, height : height },
			dimension : D2,
			format : Depth24plus_stencil8,
			usage : (RENDER_ATTACHMENT:GPUTextureUsageFlags) | COPY_SRC,
		});
		depthView = depthTex.createView();
	}

	override function setRenderTarget(tex:Null<h3d.mat.Texture>, layer:Int = 0, mipLevel:Int = 0) {
		flushPass();
		if( tex == null ) {
			renderPassDesc = {
				colorAttachments : [{
					view : colorView,
					loadOp : Load,
					storeOp: Store
				}],
				depthStencilAttachment: {
					view : depthView,
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
		colorTex = context.getCurrentTexture();
		colorView = colorTex.createView();
		commandList = device.createCommandEncoder();
		setRenderTarget(null);
	}

	function flushPass() {
		if( needClear ) {
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
		return cast {};
	}

	override function allocIndexes(count:Int, is32:Bool):IndexBuffer {
		return cast {};
	}

	static var inst : WebGpuDriver;
	static function checkReady() {
		return true;
	}

}
