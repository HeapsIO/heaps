package h2d.filter;

/**
	A ColorMatrix filer that applies color correction depending on the masked area.

	Uses masked objects `red*alpha` channels to determine the transition from original color and transformed color.

	_Hacking_: Through accessing color matrix shader directly via `@:privateAccess ambient.pass.shader.maskChannel`
	it's possible to modify which channels affect the resulting transition value.

	@see `ColorMatrix`
**/
class Ambient extends AbstractMask {

	/**
		The exponent of the mask color values that affects transition speed.
	**/
	public var power(get, set) : Float;

	/**
		Whether to apply ambient color correction inside masked (when enabled) area or outside of it (when disabled).
	**/
	public var invert(get, set) : Bool;

	var pass : h3d.pass.ColorMatrix;

	/**
		Create new Ambient filter.
		@param mask An `Object` that will be used for masking. See `AbstractMask.mask` for limitations.
		@param m The color matrix that is applied to the area dictated by `Ambient.invert`.
	**/
	public function new( mask, ?m : h3d.Matrix ) {
		pass = new h3d.pass.ColorMatrix(m);
		super(mask);
	}

	inline function get_power() return pass.maskPower;
	inline function set_power(v) return pass.maskPower = v;
	inline function get_invert() return pass.shader.maskInvert;
	inline function set_invert(v) return pass.shader.maskInvert = v;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = ctx.textures.allocTileTarget("ambientTmp", t);
		pass.apply(t.getTexture(), out, getMaskTexture(ctx, t), maskMatrix);
		return h2d.Tile.fromTexture(out);
	}

}