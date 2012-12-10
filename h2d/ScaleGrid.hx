package h2d;

class ScaleGrid extends h2d.TileGroup {
	

	public var borderWidth : Int;
	public var borderHeight : Int;
	
	public var width(default,set) : Int;
	public var height(default,set) : Int;
	
	public function new( tile, borderW, borderH, ?parent ) {
		super(tile,parent);
		borderWidth = borderW;
		borderHeight = borderH;
		width = tile.width;
		height = tile.height;
	}
	
	function set_width(w) {
		this.width = w;
		reset();
		return w;
	}

	function set_height(h) {
		this.height = h;
		reset();
		return h;
	}
	
	override function draw( engine : h3d.Engine ) {
		if( content.isEmpty() ) {
			var bw = borderWidth, bh = borderHeight;
			
			content.add(0, 0, tile.sub(0, 0, bw, bh));
			content.add(width - bw, 0, tile.sub(tile.width - bw, 0, bw, bh));
			content.add(0, height-bh, tile.sub(0, tile.height - bh, bw, bh));
			content.add(width - bw, height - bh, tile.sub(tile.width - bw, tile.height - bh, bw, bh));
			
			var sizeX = tile.width - bw * 2;
			var sizeY = tile.height - bh * 2;
			
			var rw = Std.int((width - bw * 2) / sizeX);
			for( x in 0...rw ) {
				content.add(bw + x * sizeX, 0, tile.sub(bw, 0, sizeX, bh));
				content.add(bw + x * sizeX, height - bh, tile.sub(bw, tile.height - bh, sizeX, bh));
			}
			var dx = width - bw * 2 - rw * sizeX;
			if( dx > 0 ) {
				content.add(bw + rw * sizeX, 0, tile.sub(bw, 0, dx, bh));
				content.add(bw + rw * sizeX, height - bh, tile.sub(bw, tile.height - bh, dx, bh));
			}

			var rh = Std.int((height - bh * 2) / sizeY);
			for( y in 0...rh ) {
				content.add(0, bh + y * sizeY, tile.sub(0, bh, bw, sizeY));
				content.add(width - bw, bh + y * sizeY, tile.sub(tile.width - bw, bh, bw, sizeY));
			}
			var dy = height - bh * 2 - rh * sizeY;
			if( dy > 0 ) {
				content.add(0, bh + rh * sizeY, tile.sub(0, bh, bw, dy));
				content.add(width - bw, bh + rh * sizeY, tile.sub(tile.width - bw, bh, bw, dy));
			}
			
			var t = tile.sub(bw, bh, sizeX, sizeY);
			t.scaleToSize(width - bw * 2,height - bh * 2);
			content.add(bw, bh, t);
			
		}
		super.draw(engine);
	}
	
}