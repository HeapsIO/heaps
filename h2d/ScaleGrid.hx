package h2d;

class ScaleGrid extends h2d.TileGroup {


	public var borderWidth : Int;
	public var borderHeight : Int;

	public var width(default,set) : Int;
	public var height(default,set) : Int;

	public var tileBorders(default, set) : Bool;

	public var holdPosition(default, set) : Float = 0.5;
	public var holdSize : Null<Int>;
	public var holdVertical : Bool;

	public function new( tile, borderW, borderH, ?holdSize : Int, ?holdVertical = false, ?parent ) {
		super(tile,parent);
		borderWidth = borderW;
		borderHeight = borderH;
		width = tile.width;
		height = tile.height;
		this.holdSize = holdSize;
		this.holdVertical = holdVertical;
	}

	function set_holdPosition(v) {
		v = Math.max(0, Math.min(1, v));
		this.holdPosition = v;
		clear();
		return v;
	}

	function set_tileBorders(b) {
		this.tileBorders = b;
		clear();
		return b;
	}

	function set_width(w) {
		this.width = w;
		clear();
		return w;
	}

	function set_height(h) {
		this.height = h;
		clear();
		return h;
	}

	override function getBoundsRec(relativeTo, out, forSize) {
		if( content.isEmpty() ) updateContent();
		super.getBoundsRec(relativeTo, out, forSize);
	}

	function drawContent() {
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

	function drawHoldContent() {
		if( tileBorders ) throw("TODO");

		var bw : Int = borderWidth, bh : Int = borderHeight;
		var holdw = holdVertical ? holdSize : 0, holdh = holdVertical ? 0 : holdSize;
		var wpos = holdVertical ? holdPosition : 0.5, hpos = holdVertical ? 0.5 : holdPosition;
		var sizeX1 = Math.floor(((tile.width - bw * 2) - holdw) * 0.5);
		var sizeX2 = Math.ceil(((tile.width - bw * 2) - holdw) * 0.5);
		var sizeY1 = Math.floor(((tile.height - bh * 2) - holdh) * 0.5);
		var sizeY2 = Math.ceil(((tile.height - bh * 2) - holdh) * 0.5);
		var w1 = Math.floor(((width - bw * 2) - holdw) * wpos);
		var w2 = Math.ceil(((width - bw * 2) - holdw) * (1 - wpos));
		var h1 = Math.floor(((height - bh * 2) - holdh) * hpos);
		var h2 = Math.ceil(((height - bh * 2) - holdh) * (1 - hpos));

		// 4 corners
		content.addColor(0, 0, curColor, tile.sub(0, 0, bw, bh));
		content.addColor(bw + w1 + w2 + holdw, 0, curColor, tile.sub(bw + sizeX1 + sizeX2 + holdw, 0, bw, bh));
		content.addColor(0, bh + h1 + h2 + holdh, curColor, tile.sub(0, bh + sizeY1 + sizeY2 + holdh, bw, bh));
		content.addColor(bw + w1 + w2 + holdw, bh + h1 + h2 + holdh, curColor, tile.sub(bw + sizeX1 + sizeX2 + holdw, bh + sizeY1 + sizeY2 + holdh, bw, bh));

		//8 borders
		//top (left part)
		var t = tile.sub(bw, 0, sizeX1, bh);
		t.scaleToSize(w1, bh);
		content.addColor(bw, 0, curColor, t);
		//top (right part)
		var t = tile.sub(bw + sizeX1 + holdw, 0, sizeX2, bh);
		t.scaleToSize(w2, bh);
		content.addColor(bw + w1 + holdw, 0, curColor, t);
		//bottom (left part)
		var t = tile.sub(bw, bh + sizeY1 + sizeY2 + holdh, sizeX1, bh);
		t.scaleToSize(w1, bh);
		content.addColor(bw, bh + h1 + h2 + holdh, curColor, t);
		//bottom (right part)
		var t = tile.sub(bw + sizeX1 + holdw, bh + sizeY1 + sizeY2 + holdh, sizeX2, bh);
		t.scaleToSize(w2, bh);
		content.addColor(bw + w1 + holdw, bh + h1 + h2 + holdh, curColor, t);
		//left (top part)
		var t = tile.sub(0, bh, bw, sizeY1);
		t.scaleToSize(bw, h1);
		content.addColor(0, bh, curColor, t);
		//left (bottom part)
		var t = tile.sub(0, bh + sizeY1 + holdh, bw, sizeY2);
		t.scaleToSize(bw, h2);
		content.addColor(0, bh + h1 + holdh, curColor, t);
		//right (top part)
		var t = tile.sub(bw + sizeX1 + sizeX2 + holdw, bh, bw, sizeY1);
		t.scaleToSize(bw, h1);
		content.addColor(bw + w1 + w2 + holdw, bh, curColor, t);
		//right (bottom part)
		var t = tile.sub(bw + sizeX1 + sizeX2 + holdw, bh + sizeY1 + holdh, bw, sizeY2);
		t.scaleToSize(bw, h2);
		content.addColor(bw + w1 + w2 + holdw, bh + h1 + holdh, curColor, t);

		//top middle
		var t = tile.sub(bw + sizeX1, 0, holdw, bh);
		content.addColor(bw + w1, 0, curColor, t);
		//bottom middle
		var t = tile.sub(bw + sizeX1, bh + sizeY1 + sizeY2 + holdh, holdw, bh);
		content.addColor(bw + w1, bh + h1 + h2 + holdh, curColor, t);
		//left middle
		var t = tile.sub(0, bh + sizeY1, bw, holdh);
		content.addColor(0, bh + h1, curColor, t);
		//right middle
		var t = tile.sub(bw + sizeX1 + sizeX2 + holdw, bh + sizeY1, bw, holdh);
		content.addColor(bw + w1 + w2 + holdw, bh + h1, curColor, t);
		//center
		var t = tile.sub(bw, bh, sizeX1 + sizeX2 + holdw, sizeY1 + sizeY2 + holdh);
		t.scaleToSize(w1 + w2 + holdw, h1 + h2 + holdh);
		content.addColor(bw, bh, curColor, t);
	}

	function updateContent() {
		if(holdSize == null) drawContent();
		else drawHoldContent();
	}

	override function sync( ctx : RenderContext ) {
		if( content.isEmpty() ) {
			content.dispose();
			updateContent();
		}
		super.sync(ctx);
	}

}