package h2d;

class ScaleGrid extends h2d.TileGroup {


	public var borderWidth(default,set) : Int;
	public var borderHeight(default,set) : Int;

	public var width(default,set) : Float;
	public var height(default,set) : Float;

	public var tileBorders(default, set) : Bool;

	var contentTile : h2d.Tile;

	public function new( tile, borderW, borderH, ?parent ) {
		super(tile,parent);
		borderWidth = borderW;
		borderHeight = borderH;
		width = tile.width;
		height = tile.height;
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
		if( borderWidth == w ) return w;
		this.borderWidth = w;
		clear();
		return w;
	}

	function set_borderHeight(h) {
		if( borderHeight == h ) return h;
		this.borderHeight = h;
		clear();
		return h;
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
		var bw = borderWidth, bh = borderHeight;

		// 4 corners
		content.addColor(0, 0, curColor, tile.sub(0, 0, bw, bh));
		content.addColor(width - bw, 0, curColor, tile.sub(tile.width - bw, 0, bw, bh));
		content.addColor(0, height-bh, curColor, tile.sub(0, tile.height - bh, bw, bh));
		content.addColor(width - bw, height - bh, curColor, tile.sub(tile.width - bw, tile.height - bh, bw, bh));

		var sizeX = tile.width - bw * 2;
		var sizeY = tile.height - bh * 2;

		if( !tileBorders ) {

			var w = width - bw * 2;
			var h = height - bh * 2;

			var t = tile.sub(bw, 0, sizeX, bh);
			t.scaleToSize(w, bh);
			content.addColor(bw, 0, curColor, t);

			var t = tile.sub(bw, tile.height - bh, sizeX, bh);
			t.scaleToSize(w, bh);
			content.addColor(bw, h + bh, curColor, t);

			var t = tile.sub(0, bh, bw, sizeY);
			t.scaleToSize(bw, h);
			content.addColor(0, bh, curColor, t);

			var t = tile.sub(tile.width - bw, bh, bw, sizeY);
			t.scaleToSize(bw, h);
			content.addColor(w + bw, bh, curColor, t);

		} else {

			var rw = Std.int((width - bw * 2) / sizeX);
			for( x in 0...rw ) {
				content.addColor(bw + x * sizeX, 0, curColor, tile.sub(bw, 0, sizeX, bh));
				content.addColor(bw + x * sizeX, height - bh, curColor, tile.sub(bw, tile.height - bh, sizeX, bh));
			}
			var dx = width - bw * 2 - rw * sizeX;
			if( dx > 0 ) {
				content.addColor(bw + rw * sizeX, 0, curColor, tile.sub(bw, 0, dx, bh));
				content.addColor(bw + rw * sizeX, height - bh, curColor, tile.sub(bw, tile.height - bh, dx, bh));
			}

			var rh = Std.int((height - bh * 2) / sizeY);
			for( y in 0...rh ) {
				content.addColor(0, bh + y * sizeY, curColor, tile.sub(0, bh, bw, sizeY));
				content.addColor(width - bw, bh + y * sizeY, curColor, tile.sub(tile.width - bw, bh, bw, sizeY));
			}
			var dy = height - bh * 2 - rh * sizeY;
			if( dy > 0 ) {
				content.addColor(0, bh + rh * sizeY, curColor, tile.sub(0, bh, bw, dy));
				content.addColor(width - bw, bh + rh * sizeY, curColor, tile.sub(tile.width - bw, bh, bw, dy));
			}
		}

		var t = tile.sub(bw, bh, sizeX, sizeY);
		t.scaleToSize(width - bw * 2,height - bh * 2);
		content.addColor(bw, bh, curColor, t);
	}

	override function sync( ctx : RenderContext ) {
		checkUpdate();
		super.sync(ctx);
	}

}