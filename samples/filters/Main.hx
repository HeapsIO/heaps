import hxd.Key in K;

class Main extends hxd.App {

	var spr : h2d.Sprite;
	var bmp : h2d.Bitmap;
	var disp : h2d.Tile;

	override function init() {
		engine.backgroundColor = 0x002000;

		spr = new h2d.Sprite(s2d);
		spr.x = s2d.width * 0.5;
		spr.y = s2d.height * 0.5;

		bmp = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), spr);
		bmp.colorKey = 0xFFFFFF;


		disp = hxd.Res.normalmap.toTile();

		setFilters(4);

		var help = new h2d.Text(hxd.Res.customFont.toFont(), s2d);
		help.x = help.y = 5;
		help.text = "1:Blur 2:Glow 3:DropShadow 4:Displacement +/-:Scale";
	}

	override function update(dt:Float) {
		for( i in 1...5 )
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
		disp.scrollDiscrete(0.01 * dt, 0.02 * dt);
	}

	function setFilters(i) {
		var scale = 4;
		switch( i ) {
		case 1:
			spr.filters = [new h2d.filter.Blur(2, 3, 100)];
		case 2:
			spr.filters = [new h2d.filter.Glow(0xFF00FF, 100, 1)];
		case 3:
			spr.filters = [new h2d.filter.DropShadow()];
		case 4:
			scale = 1;
			spr.filters = [new h2d.filter.Displacement(disp)];
		}
		spr.setScale(scale);
		bmp.setScale(1 / scale);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}