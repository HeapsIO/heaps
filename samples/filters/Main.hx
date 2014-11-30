import hxd.Key in K;

class Main extends hxd.App {

	var spr : h2d.Sprite;

	override function init() {
		engine.backgroundColor = 0x002000;
		var scale = 4;
		spr = new h2d.Sprite(s2d);
		spr.x = s2d.width * 0.5;
		spr.y = s2d.height * 0.5;
		spr.scale(scale);
		var bmp = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), spr);
		bmp.scale(1 / scale);
		bmp.colorKey = 0xFFFFFF;
		bmp.x = -bmp.tile.width * 0.5 * bmp.scaleX;
		bmp.y = -bmp.tile.height * 0.5 * bmp.scaleY;

		setFilters(2);

		var help = new h2d.Text(hxd.Res.customFont.toFont(), s2d);
		help.x = help.y = 5;
		help.text = "1:Blur 2:Glow";
	}

	override function update(dt:Float) {
		spr.rotation += 0.01 * dt;
		for( i in 1...3 )
			if( K.isPressed(K.NUMBER_0 + i) )
				setFilters(i);
	}

	function setFilters(i) {
		switch( i ) {
		case 1:
			spr.filters = [new h2d.filter.Blur(2, 100, 3)];
		case 2:
			spr.filters = [new h2d.filter.Glow(0xFF00FF, 100, 1)];
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}