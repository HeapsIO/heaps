class Demo {
	
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	var spr : h2d.Sprite;
	
	function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.backgroundColor = 0;
		engine.init();
	}
	
	function init() {
		scene = new h2d.Scene();
		
		var font = new h2d.Font("Arial", 16);
		var tf = new h2d.Text(font, scene);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 2, dy : 2, color : 0xFF0000, alpha : 0.5 };
		tf.text = "Hello h2d !";
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, update);
		
		var b = new flash.display.BitmapData(64, 64, true, 0);
		b.perlinNoise(64, 64, 3, 42, true, true, 7);
		var tile = h2d.Tile.fromBitmap(b);
		b.dispose();
		
		spr = new h2d.Sprite(scene);
		spr.x = engine.width >> 1;
		spr.y = engine.height >> 1;
		
		for( i in 0...16 ) {
			var bmp = new h2d.Bitmap(tile, spr);
			bmp.x = Math.cos(i * Math.PI / 8) * 100 - (tile.width>>1);
			bmp.y = Math.sin(i * Math.PI / 8) * 100 - (tile.height>>1);
			bmp.alpha = 0.5;
			bmp.blendMode = Add;
		}
	}
	
	function update(_) {
		spr.rotation += 0.01;
		engine.render(scene);
	}
	
	static function main() {
		new Demo();
	}
	
}