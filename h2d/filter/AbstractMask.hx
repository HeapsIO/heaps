package h2d.filter;

class Hide extends Filter {

	public var frame : Int;
	public var input : h2d.Tile;
	public var maskVisible : Bool;

	public function new() {
		super();
		this.boundsExtend = 1;
	}

	override function draw( ctx : RenderContext, input : h2d.Tile ) {
		this.frame = ctx.frame;
		this.input = input;
		return maskVisible ? input : null;
	}

}

class AbstractMask extends Filter {

	var hide : Hide;
	var maskMatrix : h2d.col.Matrix;
	var tmpMatrix : h2d.col.Matrix;
	var obj : h2d.Object;
	var bindCount : Int;
	public var mask(default, set) : h2d.Object;
	public var maskVisible(default, set) : Bool;

	function new(mask) {
		super();
		hide = new Hide();
		this.mask = mask;
		this.maskMatrix = new h2d.col.Matrix();
		tmpMatrix = new h2d.col.Matrix();
	}

	function set_maskVisible(b) {
		hide.maskVisible = b;
		return maskVisible = b;
	}

	override function bind(s:Object) {
		bindCount++;
		if( bindCount == 1 )
			this.mask = mask;
	}

	override function unbind(s:Object) {
		bindCount--;
		if( bindCount == 0 )
			this.mask = mask;
	}

	function set_mask(m:h2d.Object) {
		if( mask != null ) {
			if( mask.filter == hide )
				mask.filter = null;
		}
		mask = m;
		if( m != null && bindCount > 0 ) {
			if( m.filter != null ) {
				if( Std.is(m.filter,Hide) ) throw "Same mask can't be part of several filters";
				throw "Can't set mask with filter "+m.filter;
			}
			m.filter = hide;
		}
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
		t.filter = smooth ? Linear : Nearest;

		return t;
	}

	override function sync( ctx : RenderContext, obj : h2d.Object ) {
		this.obj = obj;
		if( mask == null || hide.frame != ctx.frame ) {
			var p = obj;
			while( p != null ) {
				if( p == mask ) throw "You can't mask with one of the object parents";
				p = p.parent;
			}
			hide.input = null;
		}
	}

}