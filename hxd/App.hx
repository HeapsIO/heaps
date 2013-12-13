package hxd;

class App {
	
	var engine : h3d.Engine;
	var s3d : h3d.scene.Scene;
	var s2d : h2d.Scene;
	
	public function new(?engine) {
		if( engine != null ) {
			this.engine = engine;
			haxe.Timer.delay(setup, 0);
		} else {
			this.engine = engine = new h3d.Engine();
			engine.onReady = setup;
			engine.init();
		}
	}
	
	function onResize() {
	}
	
	function setup() {
		engine.onResized = onResize;
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		s3d.addPass(s2d);
		init();
		hxd.Timer.skip();
		mainLoop();
		hxd.System.setLoop(mainLoop);
		hxd.Key.initialize();
	}
	
	function init() {
	}
	
	function mainLoop() {
		hxd.Timer.update();
		s2d.checkEvents();
		update(hxd.Timer.tmod);
		engine.render(s3d);
	}
	
	function update( dt : Float ) {
	}
	
}