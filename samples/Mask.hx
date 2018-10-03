class Mask extends hxd.App {

	var obj : h2d.Object;
	var time : Float = 0.;

	override function init() {
		var mask = new h2d.Mask(160, 160, s2d);
		mask.x = 200;
		mask.y = 150;
		obj = new h2d.Object(mask);
		obj.x = obj.y = 80;
		for( i in 0...10 ) {
			var b = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), obj);
			b.scale(0.4);
			b.x = Std.random(200) - 100;
			b.y = Std.random(200) - 100;
		}
	}

	override function update(dt:Float) {
		time += dt/60;
		obj.rotation += 0.01 * dt;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Mask();
	}

}