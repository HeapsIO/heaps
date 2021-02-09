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

	/**
		When enabled, the borders will ignore the final scale of the `h2d.ScaleGrid` to be rendered pixel perfect.
		This does not change the values of `borderLeft`, `borderRight`, `borderTop` or `borderBottom`.

		Center tile is always stretched.
	 */
	public var ignoreScale(default, set) : Bool;

	var contentTile : h2d.Tile;
	var currentScaleX = 1.;
	var currentScaleY = 1.;

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

	function set_ignoreScale(b) {
		if(ignoreScale == b) return b;
		this.ignoreScale = b;
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
		var needUpdate = false;
		if(ignoreScale){
			var s = getAbsPos().getScale();
			if(currentScaleX != s.x || currentScaleY != s.y){
				needUpdate = true;
				currentScaleX = s.x;
				currentScaleY = s.y;
			}
		}

		if( content.isEmpty() || tile != contentTile ) {
			contentTile = tile;
			needUpdate = true;
		}

		if(needUpdate){
			clear();
			updateContent();
		}
	}

	function updateContent() {
		var bt = borderTop, bb = borderBottom, bl = borderLeft, br = borderRight;
		var unscaledBl : Float = bl, unscaledBr : Float = br, unscaledBt : Float = bt, unscaledBb : Float = bb;
		var invScaleX = 1.;
		var invScaleY = 1.;
		if(ignoreScale){
			var s = getAbsPos().getScale();
			if(s.x == 0. || s.y == 0.)
				return;

			invScaleX /= s.x;
			invScaleY /= s.y;

			unscaledBl *= invScaleX;
			unscaledBr *= invScaleX;
			unscaledBt *= invScaleY;
			unscaledBb *= invScaleY;
		}

		// 4 corners
		var t = tile.sub(0, 0, bl, bt);
		t.scaleToSize(unscaledBl, unscaledBt);
		content.addColor(0, 0, curColor, t);
		t = tile.sub(tile.width - br, 0, br, bt);
		t.scaleToSize(unscaledBr, unscaledBt);
		content.addColor(width - unscaledBr, 0, curColor, t);
		t = tile.sub(0, tile.height - bb, bl, bb);
		t.scaleToSize(unscaledBl, unscaledBb);
		content.addColor(0, height-unscaledBb, curColor, t);
		t = tile.sub(tile.width - br, tile.height - bb, br, bb);
		t.scaleToSize(unscaledBr, unscaledBb);
		content.addColor(width - unscaledBr, height - unscaledBb, curColor, t);

		var innerTileWidth = tile.width - (br + bl);
		var innerTileHeight = tile.height - (bb + bt);
		var innerWidth = width - (unscaledBl + unscaledBr);
		var innerHeight = height - (unscaledBt + unscaledBb);

		if( !tileBorders ) {
			// top
			var t = tile.sub(bl, 0, innerTileWidth, bt);
			t.scaleToSize(innerWidth, unscaledBt);
			content.addColor(unscaledBl, 0, curColor, t);

			// bottom
			var t = tile.sub(bl, tile.height - bb, innerTileWidth, bb);
			t.scaleToSize(innerWidth, unscaledBb);
			content.addColor(unscaledBl, innerHeight + unscaledBt, curColor, t);

			// left
			var t = tile.sub(0, bt, bl, innerTileHeight);
			t.scaleToSize(unscaledBl, innerHeight);
			content.addColor(0, unscaledBt, curColor, t);

			// right
			var t = tile.sub(tile.width - br, bt, br, innerTileHeight);
			t.scaleToSize(unscaledBr, innerHeight);
			content.addColor(innerWidth + unscaledBl, unscaledBt, curColor, t);
		} else {
			var unscaledInnerTileWidth = innerTileWidth * invScaleX;
			var unscaledInnerTileHeight = innerTileHeight * invScaleY;

			var rw = Std.int(innerWidth / unscaledInnerTileWidth);
			for( x in 0...rw ) {
				// top
				var t = tile.sub(bl, 0, innerTileWidth, bt);
				t.scaleToSize(unscaledInnerTileWidth, unscaledBt);
				content.addColor(unscaledBl + x * unscaledInnerTileWidth, 0, curColor, t);

				// bottom
				t = tile.sub(bl, tile.height - bb, innerTileWidth, bb);
				t.scaleToSize(unscaledInnerTileWidth, unscaledBb);
				content.addColor(unscaledBl + x * unscaledInnerTileWidth, height - unscaledBb, curColor, t);
			}
			var dx = innerWidth - rw * unscaledInnerTileWidth;
			if( dx > 0 ) {
				// top
				var t =  tile.sub(bl, 0, dx / invScaleX, bt);
				t.scaleToSize(dx, unscaledBt);
				content.addColor(unscaledBl + rw * unscaledInnerTileWidth, 0, curColor, t);

				// bottom
				t =  tile.sub(bl, tile.height - bb, dx / invScaleX, bb);
				t.scaleToSize(dx, unscaledBb);
				content.addColor(unscaledBl + rw * unscaledInnerTileWidth, height - unscaledBb, curColor, t);
			}

			var rh = Std.int(innerHeight / unscaledInnerTileHeight);
			for( y in 0...rh ) {
				// left
				var t = tile.sub(0, bt, bl, innerTileHeight);
				t.scaleToSize(unscaledBl, unscaledInnerTileHeight);
				content.addColor(0, unscaledBt + y * unscaledInnerTileHeight, curColor, t);

				// right
				t = tile.sub(tile.width - br, bt, br, innerTileHeight);
				t.scaleToSize(unscaledBr, unscaledInnerTileHeight);
				content.addColor(width - unscaledBr, unscaledBt + y * unscaledInnerTileHeight, curColor, t);
			}
			var dy = innerHeight - rh * unscaledInnerTileHeight;
			if( dy > 0 ) {
				// left
				var t = tile.sub(0, bt, bl, dy / invScaleY);
				t.scaleToSize(unscaledBl, dy);
				content.addColor(0, bt + rh * unscaledInnerTileHeight, curColor, t);

				// right
				t = tile.sub(tile.width - br, bt, br, dy / invScaleY);
				t.scaleToSize(unscaledBr, dy);
				content.addColor(width - unscaledBr, unscaledBt + rh * unscaledInnerTileHeight, curColor, t);
			}
		}

		var t = tile.sub(bl, bt, innerTileWidth, innerTileHeight);
		t.scaleToSize(width - (unscaledBr + unscaledBl), height - (unscaledBt + unscaledBb));
		content.addColor(unscaledBl, unscaledBt, curColor, t);
	}

	override function sync( ctx : RenderContext ) {
		checkUpdate();
		super.sync(ctx);
	}
}