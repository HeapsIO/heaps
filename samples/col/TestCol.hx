class TestCol extends hxd.App {

	static var RW = 100;
	static var RH = 30;
	
	var rrect : h2d.Graphics;
	
	override function init() {
		
		var size = RW - RH;
		var k = 10;
		rrect = new h2d.Graphics(s2d);

		rrect.beginFill(0xFFFFFFFF);
		for( i in 0...k+1 ) {
			var a = Math.PI * i / k - Math.PI / 2;
			rrect.addPoint(size + RH * Math.cos(a), RH * Math.sin(a));
		}
		for( i in 0...k+1 ) {
			var a = Math.PI * i / k + Math.PI / 2;
			rrect.addPoint(-size + RH * Math.cos(a), RH * Math.sin(a));
		}
		rrect.endFill();
		
		rrect.x = s2d.width >> 1;
		rrect.y = s2d.height >> 1;
		rrect.rotation = Math.PI / 3;
		rrect.color = new h3d.Vector();
		
		//var r = new h2d.col.RoundRect(rrect.x, rrect.y, RW, RH, rrect.rotation);
		//mapCol( function(pt) return r.distance(pt) );
	}
	
	function mapCol( dist : h2d.col.Point -> Float, scale = 1. ) {
		var pt = new h2d.col.Point();
		var bmp = new hxd.BitmapData(s2d.width, s2d.height);
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
		var view = new h2d.Bitmap(h2d.Tile.fromBitmap(bmp));
		view.alpha = 0.5;
		s2d.addChildAt(view, 0);
		bmp.dispose();
	}
	
	override function update(dt:Float) {
		var px = s2d.mouseX;
		var py = s2d.mouseY;
		var r = new h2d.col.RoundRect(rrect.x, rrect.y, RW, RH, rrect.rotation);
		
		
		rrect.color.set(0, 0, 1);
		
		if( r.inside(new h2d.col.Point(px, py)) )
			rrect.color.set(0, 1, 0);
	}
	
	static function main() {
		new TestCol();
	}
	
}

