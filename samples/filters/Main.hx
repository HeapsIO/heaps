import hxd.Key in K;

class Main extends hxd.App {

	var spr : h2d.Sprite;
	var bmp : h2d.Bitmap;

	override function init() {
		engine.backgroundColor = 0x002000;
		var scale = 4;

		spr = new h2d.Sprite(s2d);
		spr.x = s2d.width * 0.5;
		spr.y = s2d.height * 0.5;
		spr.scale(scale);

		bmp = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), spr);
		bmp.scale(1 / scale);
		bmp.colorKey = 0xFFFFFF;

		setFilters(3);

		var help = new h2d.Text(hxd.Res.customFont.toFont(), s2d);
		help.x = help.y = 5;
		help.text = "1:Blur 2:Glow 3:DropShadow +/-:Scale";
	}

	override function update(dt:Float) {
		spr.rotation += 0.01 * dt;
		for( i in 1...4 )
			if( K.isPressed(K.NUMBER_0 + i) )
				setFilters(i);
		if( K.isPressed(K.NUMPAD_ADD) ) {
			spr.scale(1.25);
			bmp.scale(1 / 1.25);
		}
		if( K.isPressed(K.NUMPAD_SUB) ) {
			spr.scale(1 / 1.25);
			bmp.scale(1.25);
		}
		bmp.x = -bmp.tile.width * 0.5 * bmp.scaleX;
		bmp.y = -bmp.tile.height * 0.5 * bmp.scaleY;
	}

	function setFilters(i) {
		switch( i ) {
		case 1:
			spr.filters = [new h2d.filter.Blur(2, 3, 100)];
		case 2:
			spr.filters = [new h2d.filter.Glow(0xFF00FF, 100, 1)];
		case 3:
			spr.filters = [new h2d.filter.DropShadow()];
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}