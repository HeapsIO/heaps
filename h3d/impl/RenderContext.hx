package h3d.impl;

class RenderContext {

	public var engine : h3d.Engine;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;
	public var textures : h3d.impl.TextureCache;
	public var globals : hxsl.Globals;

	function new() {
		engine = h3d.Engine.getCurrent();
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.System.getDefaultFrameRate();
		textures = new h3d.impl.TextureCache();
		globals = new hxsl.Globals();
	}

	public function setCurrent() {
		inst = this;
	}

	public function clearCurrent() {
		if( inst == this )
			inst = null;
		else
			throw "Context has changed";
	}

	public function dispose() {
		textures.dispose();
	}

	static var inst : RenderContext;
	public static function get() return inst;
	public static inline function getType<T:RenderContext>( cl : Class<h3d.impl.RenderContext> ) {
		return Std.downcast(inst, cl);
	}

}