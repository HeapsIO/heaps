package h2d.filter;

class Blur extends Filter {

	/**
		Gives the blur quality : 0 for disable, 1 for 3x3, 2 for 5x5, etc.
	**/
	public var quality(get, set) : Int;

	/**
		The amount of blur (gaussian blur value).
	**/
	public var sigma(get, set) : Float;

	/**
		The number of blur passes we perform (default = 1)
	**/
	public var passes(get,set) : Int;

	var pass : h3d.pass.Blur;

	public function new( quality = 1, passes = 1, sigma = 1. ) {
		super();
		pass = new h3d.pass.Blur(quality, passes, sigma);
	}

	inline function get_quality() return pass.quality;
	inline function set_quality(v) return pass.quality = v;
	inline function get_sigma() return pass.sigma;
	inline function set_sigma(v) return pass.sigma = v;
	inline function get_passes() return pass.passes;
	inline function set_passes(v) return pass.passes = v;

	override function sync( ctx : RenderContext, s : Sprite ) {
		boundsExtend = (quality * 2) * passes;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		pass.apply(t.getTexture(), ctx.textures.allocTarget("blurTmp",ctx,t.width,t.height,false));
		return t;
	}

}