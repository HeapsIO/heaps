package hxd;

class App {

	public var engine : h3d.Engine;
	public var s3d : h3d.scene.Scene;
	public var s2d : h2d.Scene;

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
		loadAssets(function() {
			initDone = true;
			init();
			hxd.Timer.skip();
			mainLoop();
			hxd.System.setLoop(mainLoop);
			hxd.Key.initialize();
		});
	}

	function loadAssets( onLoaded ) {
		onLoaded();
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
			engine.setDriver(log);
			try {
				engine.render(s3d);
			} catch( e : Dynamic ) {
				log.logLines.push(Std.string(e));
			}
			driver.logEnable = old;
			engine.setDriver(driver);
			hxd.File.saveBytes("log.txt", haxe.io.Bytes.ofString(log.logLines.join("\n")));
		} else {
			var scnDriver = Std.instance(engine.driver, h3d.impl.ScnDriver);
			if( hxd.Key.isDown(hxd.Key.CTRL) && hxd.Key.isDown(hxd.Key.F11) ) {
				if( scnDriver == null ) {
					engine.setDriver(new h3d.impl.ScnDriver(engine.driver));
					engine.mem.onContextLost();
					engine.onContextLost();
					engine.resize(engine.width, engine.height);
					engine.render(s3d); // first render to perform allocations
				}
			} else if( scnDriver != null ) {
				engine.setDriver(scnDriver.getDriver());
				hxd.File.saveBytes("record.scn", scnDriver.getBytes());
			}
			engine.render(s3d);
		}
		#else
			engine.render(s3d);
		#end
	}

	function update( dt : Float ) {
	}

}