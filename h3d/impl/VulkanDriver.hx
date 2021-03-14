package h3d.impl;
import h3d.impl.Driver;

class VulkanDriver extends Driver {

	var ctx : sdl.Vulkan.VKContext;
	var cur : hxsl.RuntimeShader;

	public function new() {
		ctx = @:privateAccess hxd.Window.getInstance().window.vkctx;
		if( !ctx.beginFrame() ) throw "assert";
	}

	override function hasFeature( f : Feature ) {
		return true;
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return true;
	}

	override function logImpl(str:String) {
		#if sys
		Sys.println(str);
		#else
		trace(str);
		#end
	}

	override function isDisposed() {
		return false;
	}

	override function getDriverName( details : Bool ) {
		return "Vulkan";
	}

	override function present() {
		ctx.endFrame();
		if( !ctx.beginFrame() ) {
			var win = hxd.Window.getInstance();
			ctx.initSwapchain(win.width, win.height);
			if( !ctx.beginFrame() )
				throw "assert";
		}
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		onCreate(false);
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		if( cur == shader ) return false;
		cur = shader;
		return true;
	}

	override function getShaderInputNames() : InputNames {
		var names = [];
		for( v in cur.vertex.data.vars )
			if( v.kind == Input )
				names.push(v.name);
		return InputNames.get(names);
	}

	override function begin(frame:Int) {
		sdl.Vulkan.clearColorImage(0, Math.random(), 0, 1);
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		return cast {};
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		return cast {};
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return cast {};
	}

}