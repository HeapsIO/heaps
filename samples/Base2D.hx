class Base2D extends hxd.App {

	var spr : h2d.Sprite;
	var tf : h2d.Text;

	override function init() {
		// creates a new sprite and put it at the center of the sceen
		spr = new h2d.Sprite(s2d);
		spr.x = Std.int(s2d.width / 2);
		spr.y = Std.int(s2d.height / 2);

		// load the haxe logo png into a tile
		var tile = hxd.Res.hxlogo.toTile();

		// change its pivot so it is centered
		tile = tile.center();

		for( i in 0...15 ) {
			// creates a bitmap into the sprite
			var bmp = new h2d.Bitmap(tile, spr);

			// move its position
			bmp.x = Math.cos(i * Math.PI / 8) * 100;
			bmp.y = Math.sin(i * Math.PI / 8) * 100;

			// makes it transparent by 10%
			bmp.alpha = 0.1;

			// makes the colors adds to the background
			bmp.blendMode = Add;
		}

		#if (lime || !(cpp || hl))
		// load a true type font, can be not very high quality
		var font = hxd.Res.trueTypeFont.build(64);

		// creates a text display with the given font
		tf = new h2d.Text(font, s2d);

		// set the text color
		tf.textColor = 0xFFFFFF;

		// adds a red shadow
		tf.dropShadow = { dx : 3, dy : 3, color : 0xFF0000, alpha : 0.8 };

		// set the text color
		tf.text = "Héllò h2d !";

		// set the text position
		tf.x = 20;
		tf.y = s2d.height - 80;

		#end

		// load a bitmap font Resource
		var font = hxd.Res.customFont.toFont();

		// creates another text field with this font
		var tf = new h2d.Text(font, s2d);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "Héllò h2d !";

		tf.y = 20;
		tf.x = 20;
		tf.scale(7);
	}

	// if we the window has been resized
	override function onResize() {

		if( spr == null ) return;

		// center our sprite
		spr.x = Std.int(s2d.width / 2);
		spr.y = Std.int(s2d.height / 2);

		// move our text up/down accordingly
		if( tf != null ) tf.y = s2d.height - 80;
	}

	override function update(dt:Float) {
		// rotate our sprite every frame
		if( spr != null ) spr.rotation += 0.01 * dt;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Base2D();
	}

}