class Mask extends hxd.App {

	var spr : h2d.Sprite;
	var spr2 : h2d.Sprite;
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
	}

	override function update(dt:Float) {
		time += dt/60;
		spr.rotation += 0.01 * dt;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Mask();
	}

}