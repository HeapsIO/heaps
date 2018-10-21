class Base2D extends hxd.App {

	var obj : h2d.Object;
	var tf : h2d.Text;

	override function init() {
		// creates a new object and put it at the center of the sceen
		obj = new h2d.Object(s2d);
		obj.x = Std.int(s2d.width / 2);
		obj.y = Std.int(s2d.height / 2);

		// load the haxe logo png into a tile
		var tile = hxd.Res.hxlogo.toTile();

		// change its pivot so it is centered
		tile = tile.center();

		for( i in 0...15 ) {
			// creates a bitmap into the object
			var bmp = new h2d.Bitmap(tile, obj);

			// move its position
			bmp.x = Math.cos(i * Math.PI / 8) * 100;
			bmp.y = Math.sin(i * Math.PI / 8) * 100;

			// makes it transparent by 10%
			bmp.alpha = 0.1;

			// makes the colors adds to the background
			bmp.blendMode = Add;
		}

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

		if( obj == null ) return;

		// center our object
		obj.x = Std.int(s2d.width / 2);
		obj.y = Std.int(s2d.height / 2);

		// move our text up/down accordingly
		if( tf != null ) tf.y = s2d.height - 80;
	}

	override function update(dt:Float) {
		// rotate our object every frame
		if( obj != null ) obj.rotation += 0.6 * dt;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Base2D();
	}

}