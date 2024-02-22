package h2d;

class LoadingScene extends h2d.Scene {

	var presentCooldown : Float;
	public function new(presentCooldown : Float) {
		super();
		this.presentCooldown = presentCooldown;
	}

	var lastPresentTime : Float = 0.0;
	public override function render( engine : h3d.Engine ) {
		var time = haxe.Timer.stamp();
		if ( time - lastPresentTime < presentCooldown)
			return;
		lastPresentTime = time;

	#if usesys
		haxe.System.emitEvents(@:privateAccess hxd.Window.inst.event);
	#elseif hldx
		dx.Loop.processEvents(@:privateAccess hxd.Window.inst.onEvent);
	#elseif hlsdl
		sdl.Sdl.processEvents(@:privateAccess hxd.Window.inst.onEvent);
	#end
		super.render(engine);
		engine.driver.present();
	}
}
