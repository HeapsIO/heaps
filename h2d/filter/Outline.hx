package h2d.filter;

/**
	Provies a solid color outline to the filtered object by utilizing `h3d.pass.Outline` render pass.
**/
class Outline extends Filter {
	/**
		Width of the outline. See [h3d.pass.Outline.size].
	**/
	public var size(get, set) : Float;
	/**
		Color of the outline, excluding alpha. See [h3d.pass.Outline.color].
	**/
	public var color(get, set) : Int;
	/**
		Represents sample count with quality/speed tradeoff.
		Larger value leads to more samples and more accurate outline in exchange to calculation speed.
		See [h3d.pass.Outline.quality]
	**/
	public var quality(get, set) : Float;
	public var multiplyAlpha(get, set) : Bool;

	var pass : h3d.pass.Outline;

	public function new(size = 4.0, color = 0xFF000000, quality = 0.3, multiplyAlpha = true) {
		super();
		smooth = true;
		pass = new h3d.pass.Outline(size, color, quality, multiplyAlpha);
	}

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
