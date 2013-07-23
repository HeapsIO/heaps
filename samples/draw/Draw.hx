class Draw {
	
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	
	function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.backgroundColor = 0xFF000000;
		engine.init();
	}
	
	function init() {
		scene = new h2d.Scene();
		
		var g = new h2d.Graphics(scene);
		g.beginFill(0xFF0000);
		g.drawRect(10, 10, 100, 100);
		g.addHole();
		g.drawRect(20, 20, 80, 80);
		g.beginFill(0x00FF00, 0.5);
		g.lineStyle(1, 0xFF00FF);
		g.drawCircle(100, 100, 30);
		g.endFill();
		
		hxd.System.setLoop(update);
		
	}
	
	function update() {
		engine.render(scene);
	}
	
	static function main() {
		new Draw();
	}
	
}