package hxd;

class App {

	public var engine : h3d.Engine;
	public var s3d : h3d.scene.Scene;
	public var s2d : h2d.Scene;

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
		engine.onResized = function() {
			s2d.checkResize();
			onResize();
		};
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
		s2d.setElapsedTime(Timer.tmod/60);
		s3d.setElapsedTime(Timer.tmod / 60);
		#if debug
		if( hxd.Key.isDown(hxd.Key.CTRL) && hxd.Key.isPressed(hxd.Key.F12) ) {
			var driver = engine.driver;
			var old = driver.logEnable;
			var log = new h3d.impl.LogDriver(driver);
			log.logLines = [];
			@:privateAccess engine.driver = log;
			try {
				engine.render(s3d);
			} catch( e : Dynamic ) {
				log.logLines.push(Std.string(e));
			}
			driver.logEnable = old;
			@:privateAccess engine.driver = driver;
			hxd.File.saveBytes("log.txt", haxe.io.Bytes.ofString(log.logLines.join("\n")));
		} else
		#end
			engine.render(s3d);
	}

	function update( dt : Float ) {
	}

}