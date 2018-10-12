import hxd.Key in K;

class Filters extends hxd.App {

	var obj : h2d.Object;
	var bmp : h2d.Bitmap;
	var mask : h2d.Graphics;
	var disp : h2d.Tile;

	override function init() {
		engine.backgroundColor = 0x002000;

		mask = new h2d.Graphics(s2d);
		mask.beginFill(0xFF0000, 0.5);
		mask.drawCircle(0, 0, 60);
		mask.x = s2d.width*0.5-20;
		mask.y = s2d.height*0.5-50;

		obj = new h2d.Object(s2d);
		obj.x = s2d.width * 0.5;
		obj.y = s2d.height * 0.5;

		bmp = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), obj);
		bmp.colorKey = 0xFFFFFF;

		disp = hxd.Res.normalmap.toTile();
		setFilters(6);

		var help = new h2d.Text(hxd.Res.customFont.toFont(), s2d);
		help.x = help.y = 5;
		help.text = "0:Disable 1:Blur 2:Glow 3:DropShadow 4:Displacement 5:Glow(Knockout) 6:Mix 7:ColorMatrix 8:Mask +/-:Scale";
	}

	override function update(dt:Float) {
		for( i in 0...10 )
			if( K.isPressed(K.NUMBER_0 + i) || K.isPressed(K.NUMPAD_0+i) )
				setFilters(i);
		if( K.isPressed(K.NUMPAD_ADD) ) {
			obj.scale(1.25);
			bmp.scale(1 / 1.25);
		}
		if( K.isPressed(K.NUMPAD_SUB) ) {
			obj.scale(1 / 1.25);
			bmp.scale(1.25);
			if( obj.scaleX < 1 ) {
				obj.setScale(1);
				bmp.setScale(1);
			}
		}
		bmp.x = -bmp.tile.width * 0.5 * bmp.scaleX;
		bmp.y = -bmp.tile.height * 0.5 * bmp.scaleY;
		disp.scrollDiscrete(1.2 * dt, 2.4 * dt);
	}

	function setFilters(i) {
		switch( i ) {
		case 0:
			obj.filter = null;
		case 1:
			obj.filter = new h2d.filter.Blur(5);
		case 2:
			obj.filter = new h2d.filter.Glow(0xFFFFFF, 100, 5);
		case 3:
			obj.filter = new h2d.filter.DropShadow(8,Math.PI/4);
		case 4:
			obj.filter = new h2d.filter.Displacement(disp,4,4);
		case 5:
			var g = new h2d.filter.Glow(0xFFFFFF, 100, 2);
			g.knockout = true;
			obj.filter = g;
		case 6:
			var g = new h2d.filter.Glow(0xFFA500, 50, 2);
			g.knockout = true;
			obj.filter = new h2d.filter.Group([g, new h2d.filter.Displacement(disp, 3, 3), new h2d.filter.Blur(3), new h2d.filter.DropShadow(8, Math.PI / 4)]);
		case 7:
			var m = new h3d.Matrix();
			m.identity();
			m.colorContrast(0.5);
			m.colorHue(Math.PI / 4);
			m.colorSaturate(-0.5);
			obj.filter = new h2d.filter.ColorMatrix(m);
		case 8:
			obj.filter = new h2d.filter.Mask(mask);
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Filters();
	}

}