package hxd;

class App {

	public var engine : h3d.Engine;
	public var s3d : h3d.scene.Scene;
	public var s2d : h2d.Scene;
	public var sevents : hxd.SceneEvents;

	public var wantedFPS(get, set) : Float;
	var isDisposed : Bool;

	public function new(?engine) {
		if( engine != null ) {
			this.engine = engine;
			engine.onReady = setup;
			haxe.Timer.delay(setup, 0);
		} else {
			hxd.System.start(function() {
				this.engine = engine = new h3d.Engine();
				engine.onReady = setup;
				engine.init();
			});
		}
	}

	function get_wantedFPS() return hxd.Timer.wantedFPS;
	function set_wantedFPS(fps) return hxd.Timer.wantedFPS = fps;

	function onResize() {
	}

	function setup() {
		var initDone = false;
		engine.onResized = function() {
			if( s2d == null ) return; // if disposed
			s2d.checkResize();
			if( initDone ) onResize();
		};
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		s3d.addPass(s2d);
		sevents = new hxd.SceneEvents();
		sevents.addScene(s2d);
		sevents.addScene(s3d);
		loadAssets(function() {
			initDone = true;
			init();
			hxd.Timer.skip();
			mainLoop();
			hxd.System.setLoop(mainLoop);
			hxd.Key.initialize();
		});
	}

	function dispose() {
		isDisposed = true;
		s2d.dispose();
		s3d.dispose();
		sevents.dispose();
	}

	function loadAssets( onLoaded ) {
		onLoaded();
	}

	function init() {
	}

	function mainLoop() {
		hxd.Timer.update();
		sevents.checkEvents();
		if( isDisposed ) return;
		update(hxd.Timer.tmod);
		if( isDisposed ) return;
		s2d.setElapsedTime(Timer.tmod/60);
		s3d.setElapsedTime(Timer.tmod / 60);
		#if debug
		if( hxd.Key.isDown(hxd.Key.CTRL) && hxd.Key.isPressed(hxd.Key.F12) ) {
			var driver = engine.driver;
			var old = driver.logEnable;
			var log = new h3d.impl.LogDriver(driver);
			log.logLines = [];
			engine.setDriver(log);
			try {
				engine.render(s3d);
			} catch( e : Dynamic ) {
				log.logLines.push(Std.string(e));
			}
			driver.logEnable = old;
			engine.setDriver(driver);
			hxd.File.saveBytes("log.txt", haxe.io.Bytes.ofString(log.logLines.join("\n")));
		}
		#else
			engine.render(s3d);
		#end
	}

	function update( dt : Float ) {
	}

}