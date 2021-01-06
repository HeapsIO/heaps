package h2d;

/**
	A simple 9-slice bitmap renderer.

	Enables rendering of the Tile as a stretchable surface with unscaled corners, stretched center and either stretched or tiled borders.
	Set `ScaleGrid.width` and `ScaleGrid.height` to resize the ScaleGrid.
**/
class ScaleGrid extends h2d.TileGroup {

	/**
		The width of the left border in pixels.
	**/
	public var borderLeft(default, set) : Int;
	/**
		The width of the right border in pixels.
	**/
	public var borderRight(default, set) : Int;
	/**
		The height of the top border in pixels.
	**/
	public var borderTop(default, set) : Int;
	/**
		The height of the bottom border in pixels.
	**/
	public var borderBottom(default, set) : Int;
	/**
		Set the width of left and right borders altogether.
	**/
	public var borderWidth(never,set) : Int;
	/**
		Set the height of top and bottom borders altogether.
	**/
	public var borderHeight(never,set) : Int;
	/**
		The width of the bitmap. Setting to values less than `borderLeft + borderRight` leads to undefined results.
	**/
	public var width(default,set) : Float;
	/**
		The height of the bitmap. Setting to values less than `borderTop + borderBottom` leads to undefined results.
	**/
	public var height(default,set) : Float;
	/**
		When enabled, borders will be tiled along the edges instead of stretching to match the desired dimensions.

		Center tile is always stretched.
	**/
	public var tileBorders(default, set) : Bool;

	var contentTile : h2d.Tile;

	/**
		Create a new ScaleGrid with specified parameters.
		@param tile The source tile which will be sliced.
		@param borderW The width of the left and right borders in pixels.
		@param borderH The height of the top and bottom borders in pixels.
		@param parent An optional parent `h2d.Object` instance to which ScaleGrid adds itself if set.
	**/
	public function new( tile, borderL, borderT, ?borderR, ?borderB, ?parent ) {
		super(tile,parent);

		borderLeft = borderL;
		borderRight = (borderR != null)? borderR : borderL;
		borderTop = borderT;
		borderBottom = (borderB != null)? borderB : borderT;
		width = tile.width;
		height = tile.height;
		content.useAllocator = true;
	}

	function set_tileBorders(b) {
		if( tileBorders == b ) return b;
		this.tileBorders = b;
		clear();
		return b;
	}

	function set_width(w) {
		if( width == w ) return w;
		this.width = w;
		clear();
		return w;
	}

	function set_height(h) {
		if( height == h ) return h;
		this.height = h;
		clear();
		return h;
	}

	function set_borderWidth(w) {
		if( borderLeft == w && borderRight == w ) return w;
		@:bypassAccessor borderLeft = w;
		@:bypassAccessor borderRight = w;
		clear();
		return w;
	}

	function set_borderHeight(h) {
		if( borderTop == h && borderBottom == h ) return h;
		@:bypassAccessor borderTop = h;
		@:bypassAccessor borderBottom = h;
		clear();
		return h;
	}

	function set_borderTop(top) {
		if( borderTop == top ) return top;
		this.borderTop = top;
		clear();
		return top;
	}

	function set_borderBottom(bot) {
		if( borderBottom == bot ) return bot;
		this.borderBottom = bot;
		clear();
		return bot;
	}

	function set_borderLeft(left) {
		if( borderLeft == left ) return left;
		this.borderLeft = left;
		clear();
		return left;
	}

	function set_borderRight(right) {
		if( borderRight == right ) return right;
		this.borderRight = right;
		clear();
		return right;
	}

	override function getBoundsRec(relativeTo, out, forSize) {
		checkUpdate();
		super.getBoundsRec(relativeTo, out, forSize);
	}

	function checkUpdate() {
		if( content.isEmpty() || tile != contentTile ) {
			clear();
			contentTile = tile;
			updateContent();
		}
	}

	function updateContent() {
		var bt = borderTop, bb = borderBottom, bl = borderLeft, br = borderRight;

		// 4 corners
		content.addColor(0, 0, curColor, tile.sub(0, 0, bl, bt));
		content.addColor(width - br, 0, curColor, tile.sub(tile.width - br, 0, br, bt));
		content.addColor(0, height-bb, curColor, tile.sub(0, tile.height - bb, bl, bb));
		content.addColor(width - br, height - bb, curColor, tile.sub(tile.width - br, tile.height - bb, br, bb));

		var sizeX = tile.width - (br + bl);
		var sizeY = tile.height - (bb + bt);

		if( !tileBorders ) {

			var w = width - (br + bl);
			var h = height - (bb + bt);

			// top
			var t = tile.sub(bl, 0, sizeX, bt);
			t.scaleToSize(w, bt);
			content.addColor(bl, 0, curColor, t);

			// bottom
			var t = tile.sub(bl, tile.height - bb, sizeX, bb);
			t.scaleToSize(w, bb);
			content.addColor(bl, h + bt, curColor, t);

			// left
			var t = tile.sub(0, bt, bl, sizeY);
			t.scaleToSize(bl, h);
			content.addColor(0, bt, curColor, t);

			// right
			var t = tile.sub(tile.width - br, bt, br, sizeY);
			t.scaleToSize(br, h);
			content.addColor(w + bl, bt, curColor, t);

		} else {

			var rw = Std.int((width - (bl + br)) / sizeX);
			for( x in 0...rw ) {
				content.addColor(bl + x * sizeX, 0, curColor, tile.sub(bl, 0, sizeX, bt));
				content.addColor(bl + x * sizeX, height - bb, curColor, tile.sub(bl, tile.height - bb, sizeX, bb));
			}
			var dx = width - (bl + br) - rw * sizeX;
			if( dx > 0 ) {
				content.addColor(bl + rw * sizeX, 0, curColor, tile.sub(bl, 0, dx, bt));
				content.addColor(bl + rw * sizeX, height - bb, curColor, tile.sub(bl, tile.height - bb, dx, bb));
			}

			var rh = Std.int((height - (bt + bb)) / sizeY);
			for( y in 0...rh ) {
				content.addColor(0, bt + y * sizeY, curColor, tile.sub(0, bt, bl, sizeY));
				content.addColor(width - br, bt + y * sizeY, curColor, tile.sub(tile.width - br, bt, br, sizeY));
			}
			var dy = height - (bt + bb) - rh * sizeY;
			if( dy > 0 ) {
				content.addColor(0, bt + rh * sizeY, curColor, tile.sub(0, bt, bl, dy));
				content.addColor(width - br, bt + rh * sizeY, curColor, tile.sub(tile.width - br, bt, br, dy));
			}
		}

		var t = tile.sub(bl, bt, sizeX, sizeY);
		t.scaleToSize(width - (br+bl),height - (bt+bb));
		content.addColor(bl, bt, curColor, t);
	}

	override function sync( ctx : RenderContext ) {
		checkUpdate();
		super.sync(ctx);
	}

}