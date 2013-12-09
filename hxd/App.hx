package hxd;

class App {
	
	var engine : h3d.Engine;
	var s3d : h3d.scene.Scene;
	var s2d : h2d.Scene;
	
	public function new() {
		engine = new h3d.Engine();
		engine.onReady = setup;
		engine.init();
	}
	
	function setup() {
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		s3d.addPass(s2d);
		init();
		hxd.Timer.skip();
		loop();
		hxd.System.setLoop(loop);
		hxd.Key.initialize();
	}
	
	function init() {
	}
	
	function loop() {
		hxd.Timer.update();
		s2d.checkEvents();
		update(hxd.Timer.tmod);
		engine.render(s3d);
	}
	
	function update( dt : Float ) {
	}
	
}