class Main extends hxd.App {
	
	var spr : h2d.Sprite;
	
	override function init() {
		var tile = hxd.Res.hxlogo.toTile();
		spr = new h2d.Sprite(s2d);
		spr.x = s2d.width >> 1;
		spr.y = s2d.height >> 1;
		
		for( i in 0...15 ) {
			var bmp = new h2d.Bitmap(tile, spr);
			bmp.x = Math.cos(i * Math.PI / 8) * 100 - (tile.width>>1);
			bmp.y = Math.sin(i * Math.PI / 8) * 100 - (tile.height>>1);
			bmp.alpha = 0.5;
		}

		//var font = hxd.Res.CustomFont.build(32, { antiAliasing : true } );
		var font = hxd.res.FontBuilder.getFont("Arial", 32);
		
		var tf = new h2d.Text(font, s2d);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { x : 0.5, y : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "Héllò h2d !";
		tf.x = 20;
		tf.y = 450;
		tf.scale(4);

		//var font = hxd.Res.Minecraftia.build(16,{ antiAliasing : false });
		var font = hxd.res.FontBuilder.getFont("Arial", 16);

		var tf = new h2d.Text(font, s2d);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { x : 0.5, y : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "Héllò h2d !";
		
		tf.x = 20;
		tf.scale(7);
	}
	
	override function update(dt:Float) {
		spr.rotation += 0.01 * dt;
	}
	
	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
	
}