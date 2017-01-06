import hxd.Key in K;

class Filters extends hxd.App {

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
		setFilters(6);

		var help = new h2d.Text(hxd.Res.customFont.toFont(), s2d);
		help.x = help.y = 5;
		help.text = "0:Disable 1:Blur 2:Glow 3:DropShadow 4:Displacement 5:Glow(Knockout) 6:Mix 7:ColorMatrix +/-:Scale";
	}

	override function update(dt:Float) {
		for( i in 0...8 )
			if( K.isPressed(K.NUMBER_0 + i) || K.isPressed(K.NUMPAD_0+i) )
				setFilters(i);
		if( K.isPressed(K.NUMPAD_ADD) ) {
			spr.scale(1.25);
			bmp.scale(1 / 1.25);
		}
		if( K.isPressed(K.NUMPAD_SUB) ) {
			spr.scale(1 / 1.25);
			bmp.scale(1.25);
			if( spr.scaleX < 1 ) {
				spr.setScale(1);
				bmp.setScale(1);
			}
		}
		bmp.x = -bmp.tile.width * 0.5 * bmp.scaleX;
		bmp.y = -bmp.tile.height * 0.5 * bmp.scaleY;
		disp.scrollDiscrete(0.02 * dt, 0.04 * dt);
	}

	function setFilters(i) {
		switch( i ) {
		case 0:
			spr.filters = [];
		case 1:
			spr.filters = [new h2d.filter.Blur(2, 1, 100)];
		case 2:
			spr.filters = [new h2d.filter.Glow(0xFFFFFF, 100, 2)];
		case 3:
			spr.filters = [new h2d.filter.DropShadow(8,Math.PI/4,0,1,2,2)];
		case 4:
			spr.filters = [new h2d.filter.Displacement(disp,4,4)];
		case 5:
			var g = new h2d.filter.Glow(0xFFFFFF, 100, 2);
			g.knockout = true;
			spr.filters = [g];
		case 6:
			var g = new h2d.filter.Glow(0xFFA500, 50, 2, 2);
			g.knockout = true;
			spr.filters = [g, new h2d.filter.Displacement(disp, 3, 3), new h2d.filter.Blur(3, 2, 0.8), new h2d.filter.DropShadow(8, Math.PI / 4, 0, 1, 3, 3, 0.5)];
		case 7:
			var m = new h3d.Matrix();
			m.identity();
			m.colorContrast(0.5);
			m.colorHue(Math.PI / 4);
			m.colorSaturation(-0.5);
			spr.filters = [new h2d.filter.ColorMatrix(m)];
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Filters();
	}

}