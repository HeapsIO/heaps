class Blur extends SampleApp {

	var bmp : h2d.Bitmap;
	var blur : h2d.filter.Blur;
	var gfx : h2d.Graphics;
	var text : h2d.Text;

	override function init() {
		super.init();

		bmp = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), s2d);
		bmp.x = bmp.y = 100;

		blur = new h2d.filter.Blur();
		bmp.filter = blur;

		gfx = new h2d.Graphics(s2d);
		gfx.x = 500;
		gfx.y = 500;
		gfx.scale(16);

		text = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		text.y = 720;
		text.x = 5;

		addSlider("Radius", function() return blur.radius, function(v) { blur.radius = v; sync(); }, 0, 40).width = 200;
		addSlider("Linear", function() return blur.linear, function(b) { blur.linear = b; sync(); });
		addSlider("Gain", function() return blur.gain, function(b) { blur.gain = b; sync(); }, 0, 2);
		addSlider("Quality", function() return blur.quality, function(v) { blur.quality = v; sync(); }, 0, 1);

		sync();
	}

	function sync() @:privateAccess {

		gfx.clear();
		blur.pass.calcValues();

		gfx.beginFill(0xFF0000,0.2);
		gfx.drawRect(-blur.radius,0,blur.radius*2,10);
		gfx.endFill();

		gfx.lineStyle(0.1,0xFF0000, 0.5);
		for( i in 0...Math.ceil(blur.radius) ) {
			gfx.moveTo(i, 0);
			gfx.lineTo(i, 10);
			gfx.moveTo(-i, 0);
			gfx.lineTo(-i, 10);
		}

		gfx.lineStyle(0.1,0xFFFFFF);
		var q = blur.pass.values.length - 1;
		for( i in -q...q+1 ) {
			var x = blur.pass.offsets[i < 0 ? -i : i] * i;
			var y = (1 - blur.pass.values[i < 0 ? -i : i]) * 10;
			if( i == -q )
				gfx.moveTo(x,y);
			else
				gfx.lineTo(x,y);
		}
		gfx.lineStyle();

		gfx.beginFill(0x00FF00);
		for( i in -q...q+1 ) {
			var x = blur.pass.offsets[i < 0 ? -i : i] * i;
			var y = (1 - blur.pass.values[i < 0 ? -i : i]) * 10;
			gfx.drawCircle(x,y,0.3,8);
		}

		var k = blur.pass.values.length * 2 - 1;
		text.text = k+"x"+k+"\n"+[for( v in blur.pass.values ) hxd.Math.fmt(v)].toString()+"\n"+[for( i in 0...q+1 ) hxd.Math.fmt(blur.pass.offsets[i]*i)].toString();
	}

	static function main() {
		hxd.Res.initEmbed();
		new Blur();
	}

}