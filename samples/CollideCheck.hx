class CollideCheck extends hxd.App {

	static var RW = 100;
	static var RH = 30;

	var rrect : h2d.Graphics;
	var line : h2d.Graphics;

	override function init() {
		var size = RW - RH;
		var k = 10;
		rrect = new h2d.Graphics(s2d);

		rrect.beginFill(0xFFFFFFFF);
		for( i in 0...k+1 ) {
			var a = Math.PI * i / k - Math.PI / 2;
			rrect.lineTo(size + RH * Math.cos(a), RH * Math.sin(a));
		}
		for( i in 0...k+1 ) {
			var a = Math.PI * i / k + Math.PI / 2;
			rrect.lineTo(-size + RH * Math.cos(a), RH * Math.sin(a));
		}
		rrect.endFill();

		rrect.x = s2d.width >> 1;
		rrect.y = s2d.height >> 1;
		rrect.rotation = Math.PI / 3;

		line = new h2d.Graphics(s2d);
		line.beginFill(0xFFFFFFFF);
		line.drawRect(0, -0.5, 100, 1);
		line.endFill();

		//var r = new h2d.col.RoundRect(rrect.x, rrect.y, RW, RH, rrect.rotation);
		//mapCol( function(pt) return r.distance(pt) );
	}

	function mapCol( dist : h2d.col.Point -> Float, scale = 1. ) {
		var pt = new h2d.col.Point();
		var bmp = hxd.Pixels.alloc(s2d.width, s2d.height, BGRA);
		for( x in 0...bmp.width )
			for( y in 0...bmp.height ) {
				pt.x = x + 0.5;
				pt.y = y + 0.5;
				var d = dist(pt);
				if( d < 0 ) {
					var c = Std.int( -d * scale * 4 + 0x20 );
					if( c > 0xFF ) c = 0xFF;
					bmp.setPixel(x, y, 0xFF000000 | (c << 16));
				} else {
					var c = Std.int( d * scale );
					if( c > 0xFF ) c = 0xFF;
					bmp.setPixel(x, y, 0xFF000000 | c);
				}
			}
		var view = new h2d.Bitmap(h2d.Tile.fromPixels(bmp));
		view.alpha = 0.5;
		s2d.add(view, 0);
		bmp.dispose();
	}

	override function update(dt:Float) {
		var px = s2d.mouseX;
		var py = s2d.mouseY;

		var r = new h2d.col.RoundRect(rrect.x, rrect.y, RW * 2, RH * 2, rrect.rotation);
		var pt = new h2d.col.Point(px, py);

		rrect.rotation += 0.002;
		rrect.color.set(0, 0, 1);

		line.x = px;
		line.y = py;
		var n = r.getNormalAt(pt);
		line.rotation = Math.atan2(n.y, n.x);

		if( r.inside(pt) )
			rrect.color.set(0, 1, 0);
	}

	static function main() {
		new CollideCheck();
	}

}

