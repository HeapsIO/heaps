package h2d.filter;

/**
	Provides a solid color outline to the filtered object by utilizing `h3d.pass.Outline` render pass.
**/
class Outline extends Filter {
	/**
		The width of the outline.
		@see `h3d.pass.Outline.size`
	**/
	public var size(get, set) : Float;
	/**
		The color of the outline.
		@see `h3d.pass.Outline.color`
	**/
	public var color(get, set) : Int;
	/**
		Represents sample count with quality/speed tradeoff.
		Larger value leads to more samples and more accurate outline in exchange to calculation speed.
		@see `h3d.pass.Outline.quality`
	**/
	public var quality(get, set) : Float;
	/**
		Premultiplies the resulting color with its alpha when enabled.
		@see `h2d.pass.Outline.multiplyAlpha`
	**/
	public var multiplyAlpha(get, set) : Bool;
	/**
		The transparency of the outline.
	**/
	public var alpha(get, set) : Float;

	var pass : h3d.pass.Outline;

	/**
		Create a new Outline filter.
		@param size Width of the outline.
		@param color The color of the outline.
		@param quality The sample count with quality/speed tradeoff.
		@param multiplyAlpha Enable alpha premultiplying of the resulting color.
	**/
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
