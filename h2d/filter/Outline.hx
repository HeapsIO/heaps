package h2d.filter;

class Outline extends Filter {
	public var size(get, set) : Float;
	public var color(get, set) : Int;
	public var quality(get, set) : Float;
	public var multiplyAlpha(get, set) : Bool;
	public var alpha(get, set) : Float;

	var pass : h3d.pass.Outline;

	public function new(size = 4.0, color = 0x000000, quality = 0.3, multiplyAlpha = true) {
		super();
		smooth = true;
		pass = new h3d.pass.Outline(size, color, quality, multiplyAlpha);
	}

	inline function get_alpha() return pass.alpha;
	inline function set_alpha(v) return pass.alpha = v;

	inline function get_size() return pass.size;

	inline function set_size(v) return pass.size = v;

	inline function get_color() return pass.color;

	inline function set_color(v) return pass.color = v;

	inline function get_quality() return pass.quality;

	inline function set_quality(v) return pass.quality = v;

	inline function get_multiplyAlpha() return pass.multiplyAlpha;

	inline function set_multiplyAlpha(v) return pass.multiplyAlpha = v;

	override function sync(ctx : RenderContext, s : Object) {
		boundsExtend = pass.size * 2;
	}

	override function draw(ctx : RenderContext, t : h2d.Tile) {
		var out = t.getTexture();
		var old = out.filter;
		out.filter = Linear;
		pass.apply(ctx, out);
		out.filter = old;
		return t;
	}
}
