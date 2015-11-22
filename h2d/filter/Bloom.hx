package h2d.filter;

class Bloom extends Blur {

	var bloom : h3d.pass.ScreenFx<h3d.shader.Bloom>;
	public var amount(get, set) : Float;
	public var power(get, set) : Float;

	public function new( power = 2., amount = 1., quality = 2, passes = 1, sigma = 1 ) {
		super(quality, passes, sigma);
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
		var dst = ctx.textures.allocTarget("dest", ctx, t.width, t.height, false);
		dst.clear(0, 0);
		h3d.pass.Copy.run(t.getTexture(), dst);
		var blurred = super.draw(ctx, t);
		bloom.shader.texture = blurred.getTexture();
		ctx.engine.pushTarget(dst);
		bloom.render();
		ctx.engine.popTarget();
		return h2d.Tile.fromTexture(dst);
	}


}