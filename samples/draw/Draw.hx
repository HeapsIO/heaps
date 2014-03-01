class Draw extends hxd.App {
	
	override function init() {
		var g = new h2d.Graphics(s2d);
		g.beginFill(0xFF0000);
		g.drawRect(10, 10, 100, 100);
		g.addHole();
		g.drawRect(20, 20, 80, 80);
		g.beginFill(0x00FF00, 0.5);
		g.lineStyle(1, 0xFF00FF);
		g.drawCircle(100, 100, 30);
		g.endFill();
		
		// check the size and alignment of scaled bitmaps
		
		var bmp = new hxd.BitmapData(256, 256);
		bmp.clear(0xFFFF00FF);
		bmp.fill(19, 21, 13, 15, 0xFF202020);
		bmp.fill(19, 20, 13, 1, 0xFFFF0000);
		bmp.fill(18, 21, 1, 15, 0xFF00FF00);
		bmp.fill(19+13, 21, 1, 15, 0xFF0000FF);
		bmp.fill(19, 21 + 15, 13, 1, 0xFF00FFFF);
		var tile = h2d.Tile.fromBitmap(bmp);
		
		bmp.dispose();
		
		var b = new h2d.Bitmap(tile.sub(19, 21, 13, 15), s2d);
		b.x = 200;
		b.y = 200;
		b.scale(32);
		
		var b = new h2d.Bitmap(tile.sub(18, 20, 15, 17), s2d);
		b.x = 300;
		b.y = 300;
		b.scale(13);

	}
	
	static function main() {
		new Draw();
	}
	
}