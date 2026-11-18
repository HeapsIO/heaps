class BitmapDataDraw extends hxd.App {

	override function init() {
		var source = new hxd.BitmapData(8, 8);
		source.lock();
		for( y in 0...8 )
			for( x in 0...8 )
				source.setPixel(x, y, y < 4 ? (x < 4 ? 0xFFFF0000 : 0xFF00FF00) : (x < 4 ? 0xFF0000FF : 0));
		source.unlock();

		var output = new hxd.BitmapData(128, 64);
		output.clear(0xFF202020);
		// Nearest-neighbor and smooth scaling of the same source, including transparency.
		output.drawScaled(8, 8, 48, 48, source, 0, 0, 8, 8, None, false);
		output.drawScaled(72, 8, 48, 48, source, 0, 0, 8, 8, None, true);
		if( output.getPixel(0, 0) != 0xFF202020 || output.getPixel(8, 8) != 0xFFFF0000 || output.getPixel(48, 48) != 0 )
			throw "BitmapData.drawScaled did not preserve the background or replace transparent pixels";

		#if js
		// Cropping and overlapping self-draw must read the original source pixels.
		var cropped = source.clone();
		cropped.draw(2, 0, cropped, 0, 0, 6, 8, None);
		if( cropped.getPixel(4, 0) != 0xFFFF0000 || cropped.getPixel(6, 0) != 0xFF00FF00 )
			throw "BitmapData.draw did not preserve the source of an overlapping copy";

		// The JavaScript implementation also supports default alpha compositing.
		var overlay = new hxd.BitmapData(1, 1);
		overlay.setPixel(0, 0, 0x80FF0000);
		var blended = new hxd.BitmapData(1, 1);
		blended.clear(0xFF0000FF);
		blended.draw(0, 0, overlay, 0, 0, 1, 1);
		if( blended.getPixel(0, 0) != 0xFF80007F )
			throw "BitmapData.draw did not alpha-composite the source";
		overlay.dispose();
		blended.dispose();
		cropped.dispose();
		#end

		var bitmap = new h2d.Bitmap(h2d.Tile.fromBitmap(output), s2d);
		bitmap.setScale(3);
		bitmap.setPosition(20, 20);
		source.dispose();
		output.dispose();
	}

	static function main() {
		new BitmapDataDraw();
	}

}
