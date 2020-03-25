class Mask extends hxd.App {

	var obj : h2d.Object;
	var mask : h2d.Mask;
	var time : Float = 0.;

	override function init() {
		mask = new h2d.Mask(160, 160, s2d);
		mask.x = 200;
		mask.y = 150;

		// Mask-sized rectangle to display mask boundaries
		// and make scroll movement more apparent.
		new h2d.Bitmap(h2d.Tile.fromColor(0x222222, mask.width, mask.height), mask);
		// Limit scroll
		mask.scrollBounds = h2d.col.Bounds.fromValues(-mask.width/2, -mask.height/2,mask.width*2, mask.height*2);

		obj = new h2d.Object(mask);
		obj.x = obj.y = 80;
		for( i in 0...10 ) {
			var b = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), obj);
			b.scale(0.4);
			b.x = Std.random(200) - 100;
			b.y = Std.random(200) - 100;
		}
		var info = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		info.setPosition(5, 5);
		info.text = "Arrows: move scrollX/Y\nSpace: reset scroll to 0,0";

	}

	override function update(dt:Float) {
		time += dt;
		obj.rotation += 0.6 * dt;
		if (hxd.Key.isDown(hxd.Key.LEFT)) mask.scrollX -= 100 * dt;
		if (hxd.Key.isDown(hxd.Key.RIGHT)) mask.scrollX += 100 * dt;
		if (hxd.Key.isDown(hxd.Key.UP)) mask.scrollY -= 100 * dt;
		if (hxd.Key.isDown(hxd.Key.DOWN)) mask.scrollY += 100 * dt;
		if (hxd.Key.isReleased(hxd.Key.SPACE)) mask.scrollTo(0, 0);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Mask();
	}

}