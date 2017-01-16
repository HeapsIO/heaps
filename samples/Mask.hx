class Mask extends hxd.App {

	var spr : h2d.Sprite;
	var spr2 : h2d.Sprite;
	var cache : h2d.CachedBitmap;
	var time : Float = 0.;

	override function init() {
		var mask = new h2d.Mask(160, 160, s2d);
		mask.x = 200;
		mask.y = 150;
		spr = new h2d.Sprite(mask);
		spr.x = spr.y = 80;
		for( i in 0...10 ) {
			var b = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), spr);
			b.scale(0.4);
			b.x = Std.random(200) - 100;
			b.y = Std.random(200) - 100;
		}

		engine.backgroundColor = 0x200000;
		cache = new h2d.CachedBitmap(s2d, 160, 160);
		cache.blendMode = None;
		cache.x = 400;
		cache.y = 150;
		cache.colorMatrix = h3d.Matrix.I();
		spr2 = new h2d.Sprite(cache);
		spr2.x = spr2.y = 80;
		for( i in 0...10 ) {
			var b = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), spr2);
			b.scale(0.4);
			b.x = Std.random(200) - 100;
			b.y = Std.random(200) - 100;
		}
	}

	override function update(dt:Float) {
		spr.rotation += 0.01 * dt;
		spr2.rotation += 0.01 * dt;
		time += dt/60;
		cache.freezed = (time % 2.) > 1;
		cache.colorMatrix.identity();
		cache.colorMatrix.colorHue(time);
		cache.colorMatrix.colorSaturation(cache.freezed ? -1 : 0);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Mask();
	}

}