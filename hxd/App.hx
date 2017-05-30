package hxd;

class App implements h3d.IDrawable {

	public var engine(default,null) : h3d.Engine;
	public var s3d(default,null) : h3d.scene.Scene;
	public var s2d(default,null) : h2d.Scene;
	public var sevents(default,null) : hxd.SceneEvents;

	public var wantedFPS(get, set) : Float;
	var isDisposed : Bool;

	public function new() {
		var engine = h3d.Engine.getCurrent();
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

	public function setScene( scene : hxd.SceneEvents.InteractiveScene, disposePrevious = true ) {
		var new2D = Std.instance(scene, h2d.Scene);
		var new3D = Std.instance(scene, h3d.scene.Scene);
		if( new2D != null )
			sevents.removeScene(s2d);
		if( new3D != null )
			sevents.removeScene(s3d);
		sevents.addScene(scene);
		if( disposePrevious ) {
			if( new2D != null )
				s2d.dispose();
			else if( new3D != null )
				s3d.dispose();
			else
				throw "Can't dispose previous scene";
		}
		if( new2D != null )
			this.s2d = new2D;
		if( new3D != null )
			this.s3d = new3D;
	}

	function setScene2D( s2d : h2d.Scene, disposePrevious = true ) {
		sevents.removeScene(this.s2d);
		sevents.addScene(s2d,0);
		if( disposePrevious )
			this.s2d.dispose();
		this.s2d = s2d;
	}

	public function render(e:h3d.Engine) {
		s3d.render(e);
		s2d.render(e);
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
				engine.render(this);
			} catch( e : Dynamic ) {
				log.logLines.push(Std.string(e));
			}
			driver.logEnable = old;
			engine.setDriver(driver);
			hxd.File.saveBytes("log.txt", haxe.io.Bytes.ofString(log.logLines.join("\n")));
			return;
		}
		#end
		engine.render(this);
	}

	function update( dt : Float ) {
	}

}