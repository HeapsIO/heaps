package h2d.filter;

@:dox(hide)
class Hide extends Filter {

	public var frame : Int;
	public var input : h2d.Tile;
	public var maskVisible : Bool;

	public var inputWidth:Int;
	public var inputHeight:Int;

	public function new() {
		super();
		this.boundsExtend = 1;
	}

	override function draw( ctx : RenderContext, input : h2d.Tile ) {
		this.frame = ctx.frame;
		this.input = input;
		this.inputWidth = input.iwidth;
		this.inputHeight = input.iheight;
		return maskVisible ? input : null;
	}

}

/**
	A base class for filters that utilize separate Objects as a masking object.

	Not intended to be used directly.

	Masking objects have a number of restrictions on them, see `AbstractMask.mask` for details.
**/
class AbstractMask extends Filter {

	var hide : Hide;
	var maskMatrix : h2d.col.Matrix;
	var tmpMatrix : h2d.col.Matrix;
	var obj : h2d.Object;
	var bindCount : Int = 0;
	/**
		The Object contents of which serve as a mask to the filtered Object.

		Masking Objects have following limitations:
		* It cannot be a parent of the filtered Object.
		* It should not contain any filters.
		* It should be present in the object tree and precede the Object it masks in the rendering order (rendered before it).
		* Same masking Object cannot be used by multiple mask filters.
	**/
	public var mask(default, set) : h2d.Object;
	/**
		When enabled, masking Object will be visible to the user. Hidden otherwise. ( default : false )
	**/
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
				if( hxd.impl.Api.isOfType(m.filter,Hide) ) throw "Same mask can't be part of several filters";
				throw "Can't set mask with filter "+m.filter;
			}
			m.filter = hide;
		}
		hide.input = null;
		return m;
	}

	function getMaskTexture( ctx : h2d.RenderContext, tile : h2d.Tile ) {
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

		var resolutionScale = ctx.getFilterScale(@:privateAccess h2d.Object.tmpPoint);
		// move from tex a to tex b
		maskMatrix.x /= tile.width / resolutionScale.x;
		maskMatrix.y /= tile.height / resolutionScale.y;

		maskMatrix.scale(tile.width / hide.inputWidth, tile.height / hide.inputHeight);
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

	override function set_resolutionScale(v:Float):Float
	{
		hide.resolutionScale = v;
		return super.set_resolutionScale(v);
	}

	override function set_useScreenResolution(v:Bool):Bool
	{
		hide.useScreenResolution = v;
		return super.set_useScreenResolution(v);
	}

}