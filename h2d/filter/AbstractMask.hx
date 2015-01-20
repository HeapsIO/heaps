package h2d.filter;

class Hide extends Filter {

	public var frame : Int;
	public var input : h2d.Tile;

	override function draw( ctx : RenderContext, input : h2d.Tile ) {
		this.frame = ctx.frame;
		this.input = input;
		return null;
	}

}

class AbstractMask extends Filter {

	var hide : Hide;
	var maskMatrix : h2d.col.Matrix;
	var tmpMatrix : h2d.col.Matrix;
	var obj : h2d.Sprite;
	public var mask(default, set) : h2d.Sprite;

	function new(mask) {
		super();
		hide = new Hide();
		this.mask = mask;
		this.maskMatrix = new h2d.col.Matrix();
		tmpMatrix = new h2d.col.Matrix();
	}

	function set_mask(m:h2d.Sprite) {
		if( mask != null )
			mask.filters.remove(hide);
		mask = m;
		if( m != null )
			m.filters.push(hide);
		hide.input = null;
		return m;
	}

	function getMaskTexture( tile : h2d.Tile ) {
		var t = hide.input == null ? null : hide.input.getTexture();
		if( t == null ) return null;

		// Note : this does not seem to work very nice with rotations
		// because of the not uniform final scaling. let's fix that some other day

		@:privateAccess mask.getMatrix(maskMatrix);
		maskMatrix.prependTranslate(hide.input.dx, hide.input.dy);
		maskMatrix.invert();
		@:privateAccess obj.getMatrix(tmpMatrix);
		tmpMatrix.prependTranslate(tile.dx, tile.dy);
		maskMatrix.multiply(tmpMatrix, maskMatrix);

		// move from tex a to tex b
		maskMatrix.x /= tile.width;
		maskMatrix.y /= tile.height;

		maskMatrix.scale(tile.width / t.width, tile.height / t.height);
		t.filter = filter ? Linear : Nearest;

		return t;
	}

	override function sync( ctx : RenderContext, obj : h2d.Sprite ) {
		this.obj = obj;
		if( mask == null || hide.frame != ctx.frame )
			hide.input = null;
	}

}