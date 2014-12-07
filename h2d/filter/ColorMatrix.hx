package h2d.filter;

class ColorMatrix extends Filter {

	public var matrix(get, set) : h3d.Matrix;

	var pass : h3d.pass.ColorMatrix;

	public function new( ?m : h3d.Matrix ) {
		super();
		pass = new h3d.pass.ColorMatrix(m);
	}

	inline function get_matrix() return pass.matrix;
	inline function set_matrix(m) return pass.matrix = m;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var tout = ctx.textures.allocTarget("colorMatrixOut", ctx, t.width, t.height, false);
		pass.apply(t.getTexture(), tout);
		return h2d.Tile.fromTexture(tout);
	}

}