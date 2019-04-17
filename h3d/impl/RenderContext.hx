package h3d.impl;

class RenderContext {

	public var engine : h3d.Engine;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;
	public var textures : h3d.impl.TextureCache;

	function new() {
		engine = h3d.Engine.getCurrent();
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.System.getDefaultFrameRate();
		textures = new h3d.impl.TextureCache(this);
	}

	public function dispose() {
		textures.dispose();
	}
}