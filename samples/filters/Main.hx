import hxd.Key in K;

class Main extends hxd.App {

	var spr : h2d.Sprite;

	override function init() {
		engine.debug = true;
		var scale = 1;
		spr = new h2d.Sprite(s2d);
		spr.filters = [new h2d.filter.Blur(2,100,3)];
		spr.x = s2d.width * 0.5;
		spr.y = s2d.height * 0.5;
		spr.scale(scale);
		var bmp = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), spr);
		bmp.scale(1 / scale);
		bmp.colorKey = 0xFFFFFF;
		bmp.x = -bmp.tile.width * 0.5 * bmp.scaleX;
		bmp.y = -bmp.tile.height * 0.5 * bmp.scaleY;
	}

	override function update(dt:Float) {
		spr.rotation += 0.01 * dt;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}