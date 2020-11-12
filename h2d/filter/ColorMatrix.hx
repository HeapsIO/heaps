package h2d.filter;

/**
	Applies a color correction filter based on the provided matrix.

	Matrix values are as following:
	```
	     red        green      blue       alpha
	[   redMult,   redMult,   redMult,   redMult ]
	[ greenMult, greenMult, greenMult, greenMult ]
	[  blueMult,  blueMult,  blueMult,  blueMult ]
	[ alphaMult, alphaMult, alphaMult, alphaMult ]
	```
	An identity matrix will result in an unmodified colors:
	```
	[1, 0, 0, 0]
	[0, 1, 0, 0]
	[0, 0, 1, 0]
	[0, 0, 0, 1]
	```

	@see `Ambient`
**/
class ColorMatrix extends Filter {

	/**
		The matrix used to apply color correction.
	**/
	public var matrix(get, set) : h3d.Matrix;

	var pass : h3d.pass.ColorMatrix;

	/**
		Create a new ColorMatrix filter.

		@param m The matrix used to modify the resulting colors.
	**/
	public function new( ?m : h3d.Matrix ) {
		super();
		pass = new h3d.pass.ColorMatrix(m);
		pass.shader.useAlpha = true;
	}

	inline function get_matrix() return pass.matrix;
	inline function set_matrix(m) return pass.matrix = m;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var tout = ctx.textures.allocTileTarget("colorMatrixOut", t);
		pass.apply(t.getTexture(), tout);
		return h2d.Tile.fromTexture(tout);
	}

	/**
		Returns a ColorMatrix filter which results in a grayscale image (0 saturation).
	**/
	public static function grayed() {
		var m = new h3d.Matrix();
		m.identity();
		m.colorSaturate(-1);
		return new ColorMatrix(m);
	}

}
