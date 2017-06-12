
class AdjustColor extends SampleApp {

	var hue = 0.;
	var sat = 0.;
	var bright = 0.;
	var contrast = 0.;

	var bmps : Array<h2d.Bitmap>;

	override function init() {
		super.init();

		engine.backgroundColor = 0x404040;

		bmps = [];
		for( i in 0...4 ) {
			var gradient = new hxd.BitmapData(256, 256);
			var red = (i + 1) & 1;
			var green = ((i + 1) >> 1) & 1;
			var blue = (i + 1) >> 2;
			for( x in 0...gradient.width )
				for( y in 0...gradient.height )
					gradient.setPixel(x,y, 0xFF000000 | ((x << 16) * red) | ((y << 8) * green) | (((x + y) >> 1) * blue));

			var bmp = new h2d.Bitmap(h2d.Tile.fromBitmap(gradient), s2d);
			bmp.x = 50 + (i&1) * 270;
			bmp.y = 100 + (i >> 1) * 270;
			bmps.push(bmp);
		}

		addSlider("Hue", function() return hue, function(s) hue = s, -180, 180);
		addSlider("Saturation", function() return sat, function(s) sat = s, -100, 100);
		addSlider("Brightness", function() return bright, function(s) bright = s, -100, 100);
		addSlider("Contrast", function() return contrast, function(s) contrast = s, -100, 100);
	}

	override function update(dt:Float) {
		for( b in bmps )
			b.adjustColor({ saturation : sat / 100, lightness : bright / 100, hue : hue * Math.PI / 180, contrast : contrast / 100 });
	}

	public static function main() {
		new AdjustColor();
	}


}