class GraphicsDraw extends hxd.App {

	var bclone : h2d.Bitmap;
	var texture : h3d.mat.Texture;
	var pg : h2d.Graphics;

	override function init() {
		var g = new h2d.Graphics(s2d);
		g.beginFill(0xFF0000);
		g.drawRect(10, 10, 100, 100);
		g.beginFill(0x00FF00, 0.5);
		g.lineStyle(1, 0xFF00FF);
		g.drawCircle(100, 100, 30);
		g.endFill();

		// check pie + draw texture

		var g = new h2d.Graphics(s2d);
		var bmp = new hxd.BitmapData(64, 64);
		for( x in 0...64 )
			for( y in 0...64 )
				bmp.setPixel(x, y, 0xFF000000 | (x * 4) | ((y * 4) << 8));
		var tile = h2d.Tile.fromBitmap(bmp);
		bmp.dispose();
		g.lineStyle();

		g.beginTileFill(-32,-32,tile);
		g.drawPie(0, 0, 32, Math.PI / 3, Math.PI * 5 / 4);
		g.endFill();

		g.beginTileFill(100, -64, 2, 2, tile);
		g.drawRect(100, -64, 128, 128);
		g.endFill();

		g.x = 200;
		g.y = 100;

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

		// check drawTo texture

		texture = new h3d.mat.Texture(256, 256,[Target]);
		var b = new h2d.Bitmap(h2d.Tile.fromTexture(texture), s2d);
		b.y = 256;

		// test capture bitmap

		bclone = new h2d.Bitmap(h2d.Tile.fromTexture(new h3d.mat.Texture(256, 256)), s2d);
		bclone.y = 512;

		// set up graphics instance for use in redraw()

		pg = new h2d.Graphics();
		pg.filter = new h2d.filter.Blur(2,2,10);
		pg.beginFill(0xFF8040, 0.8);
	}

	function redraw(t:h3d.mat.Texture) {
		pg.clear();
		for( i in 0...100 ) {
			var r = (0.1 + Math.random()) * 10;
			var s = Math.random() * Math.PI * 2;
			var a = Math.random() * Math.PI * 2;
			pg.drawPie(Math.random() * 256, Math.random() * 256, r, s, a);
		}
		pg.drawTo(t);

		var pix = t.capturePixels();
		bclone.tile.getTexture().uploadPixels(pix);
		pix.dispose();
	}

	override function update(dt:Float) {
		redraw(texture);
	}

	static function main() {
		new GraphicsDraw();
	}

}