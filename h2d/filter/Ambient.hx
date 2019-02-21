package h2d.filter;

class Ambient extends AbstractMask {

	public var power(get, set) : Float;
	public var invert(get, set) : Bool;
	var pass : h3d.pass.ColorMatrix;

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
		pass.apply(t.getTexture(), out, getMaskTexture(t), maskMatrix);
		return h2d.Tile.fromTexture(out);
	}

}