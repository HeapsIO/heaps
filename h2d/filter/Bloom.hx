package h2d.filter;

/**
	Applies a bloom effect to the filtered Object.
	Produces feathers to light areas in the objects.
**/
class Bloom extends Blur {

	var bloom : h3d.pass.ScreenFx<h3d.shader.Bloom>;
	/**
		The bloom luminosity multiplier.
	**/
	public var amount(get, set) : Float;
	/**
		The bloom luminosity exponent.
	**/
	public var power(get, set) : Float;

	/**
		@param power The bloom luminosity exponent.
		@param amount The bloom luminosity multiplier.
		@param radius The bloom glow distance in pixels.
		@param gain The bloom color intensity.
		@param quality The sample count on each pixel as a tradeoff of speed/quality.
	**/
	public function new( power = 2., amount = 1., radius = 1., gain = 1., quality = 1. ) {
		super(radius,gain,quality);
		bloom = new h3d.pass.ScreenFx(new h3d.shader.Bloom());
		bloom.shader.power = power;
		bloom.shader.amount = amount;
		@:privateAccess bloom.pass.blend(One, One);
	}

	inline function get_amount() return bloom.shader.amount;
	inline function set_amount(v) return bloom.shader.amount = v;
	inline function get_power() return bloom.shader.power;
	inline function set_power(v) return bloom.shader.power = v;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var dst = ctx.textures.allocTileTarget("dest", t);
		h3d.pass.Copy.run(t.getTexture(), dst);
		var blurred = super.draw(ctx, t);
		bloom.shader.texture = blurred.getTexture();
		ctx.engine.pushTarget(dst);
		bloom.render();
		ctx.engine.popTarget();
		return h2d.Tile.fromTexture(dst);
	}


}
