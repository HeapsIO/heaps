package h2d.filter;

class Ambient extends AbstractMask {

	public var power(get, set) : Float;
	var pass : h3d.pass.ColorMatrix;

	public function new( mask, ?m : h3d.Matrix ) {
		pass = new h3d.pass.ColorMatrix(m);
		super(mask);
	}

	inline function get_power() return pass.maskPower;
	inline function set_power(v) return pass.maskPower = v;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = ctx.textures.allocTarget("ambientTmp", ctx, t.width, t.height, false);
		pass.apply(t.getTexture(), out, getMaskTexture(t), maskMatrix);
		return h2d.Tile.fromTexture(out);
	}

}