package h2d.filter;

/**
	Utilizes the `h3d.pass.Blur` render pass to perform a blurring operation on the filtered object.
**/
class Blur extends Filter {

	/**
		@see `h3d.pass.Blur.radius`
	**/
	public var radius(get, set) : Float;

	/**
		@see `h3d.pass.Blur.linear`
	**/
	public var linear(get, set) : Float;

	/**
		@see `h3d.pass.Blur.gain`
	**/
	public var gain(get, set) : Float;

	/**
		@see `h3d.pass.Blur.quality`
	**/
	public var quality(get, set) : Float;

	var pass : h3d.pass.Blur;

	/**
		Create a new Blur filter.
		@param radius The blur distance in pixels.
		@param gain The color gain when blurring.
		@param quality The sample count on each pixel as a tradeoff of speed/quality.
		@param linear Linear blur power. Set to 0 for gaussian blur.
	**/
	public function new( radius = 1., gain = 1., quality = 1., linear = 0. ) {
		super();
		smooth = true;
		pass = new h3d.pass.Blur(radius, gain, linear, quality);
	}

	inline function get_quality() return pass.quality;
	inline function set_quality(v) return pass.quality = v;
	inline function get_radius() return pass.radius;
	inline function set_radius(v) return pass.radius = v;
	inline function get_gain() return pass.gain;
	inline function set_gain(v) return pass.gain = v;
	inline function get_linear() return pass.linear;
	inline function set_linear(v) return pass.linear = v;

	override function sync( ctx : RenderContext, s : Object ) {
		boundsExtend = radius * 2;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = t.getTexture();
		var old = out.filter;
		out.filter = Linear;
		pass.apply(ctx, out);
		out.filter = old;
		return t;
	}

}
