import h2d.Bitmap;
import h2d.Tile;
import haxe.Resource;
import hxd.BitmapData;

class Demo {
	
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	
	function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.backgroundColor = 0xFF00FF00;
		engine.init();
	}
	
	function init() {
		trace("initing");
		scene = new h2d.Scene();
		
		var s = new h2d.Sprite(scene);
		var tileHaxe = hxd.Res.haxe.toTile();
		trace(tileHaxe.width);
		tileHaxe = tileHaxe.center( Std.int(tileHaxe.width / 2), Std.int(tileHaxe.height / 2) );
		for (i in 0...1) {
			var e = new Bitmap(tileHaxe, scene);
			e.x = i * 40 + 40;
			e.y = 40;
			//e.alpha = 0.5 + Std.random(5) / 10;
			s.addChild(e);
		}
		
		trace("inited");
		hxd.System.setLoop(update);
	}
	
	function update() {
		trace("updateing");
		engine.render(scene);
		trace("updated");
	}
	
	static function main() {
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		new Demo();
	}
	
}