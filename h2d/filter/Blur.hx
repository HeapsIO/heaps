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
	public var passes(get, set) : Int;

	/**
		How much the blur lighten/darken the image (default = 1)
	**/
	public var gain(get, set) : Float;

	/**
		Increment to use a reduced size temporary texture and make use of hardware blur.
	**/
	public var reduceSize : Int = 0;

	var pass : h3d.pass.Blur;

	public function new( quality = 1, passes = 1, sigma = 1. ) {
		super();
		smooth = true;
		pass = new h3d.pass.Blur(quality, passes, sigma);
	}

	inline function get_quality() return pass.quality;
	inline function set_quality(v) return pass.quality = v;
	inline function get_sigma() return pass.sigma;
	inline function set_sigma(v) return pass.sigma = v;
	inline function get_passes() return pass.passes;
	inline function set_passes(v) return pass.passes = v;
	inline function get_gain() return pass.gain;
	inline function set_gain(v) return pass.gain = v;

	override function sync( ctx : RenderContext, s : Sprite ) {
		boundsExtend = (quality * 2) * passes;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = t.getTexture();
		if( reduceSize > 0 ) {
			out = ctx.textures.allocTarget("blurOut", t.width >> reduceSize, t.height >> reduceSize, false);
			h3d.pass.Copy.run(t.getTexture(), out);
		}
		var tex = ctx.textures.allocTarget("blurTmp", out.width, out.height, false);
		tex.filter = smooth ? Linear : Nearest;
		pass.apply(out, tex);
		if( reduceSize <= 0 )
			return t;
		var tt = h2d.Tile.fromTexture(out);
		tt.scaleToSize(t.width, t.height);
		return tt;
	}

}