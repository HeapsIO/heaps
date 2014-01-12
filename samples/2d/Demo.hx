class Demo {
	
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	var spr : h2d.Sprite;
	
	function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.backgroundColor = 0xFF000000;
		engine.init();
	}
	
	function init() {
		scene = new h2d.Scene();

		var tile = hxd.Res.hxlogo.toTile();
		spr = new h2d.Sprite(scene);
		spr.x = engine.width >> 1;
		spr.y = engine.height >> 1;
		
		for( i in 0...16 ) {
			var bmp = new h2d.Bitmap(tile, spr);
			bmp.x = Math.cos(i * Math.PI / 8) * 100 - (tile.width>>1);
			bmp.y = Math.sin(i * Math.PI / 8) * 100 - (tile.height>>1);
			bmp.alpha = 0.5;
		}

		var font = hxd.Res.CustomFont.build(32,{ antiAliasing : true });
		var tf = new h2d.Text(font, scene);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "Héllò h2d !";
		tf.x = 20;
		tf.y = 450;
		tf.scale(4);

		var font = hxd.Res.Minecraftia.build(16,{ antiAliasing : false });
		var tf = new h2d.Text(font, scene);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "Héllò h2d !";
		tf.x = 20;
		tf.scale(7);
		

		hxd.System.setLoop(update);
	}
	
	function update() {
		spr.rotation += 0.01;
		engine.render(scene);
	}
	
	static function main() {
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		new Demo();
	}
	
}