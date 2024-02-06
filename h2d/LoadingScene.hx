package h2d;

class LoadingScene extends h2d.Scene {

	var presentCooldown : Float;
	public function new(presentCooldown : Float) {
		super();
		this.presentCooldown = presentCooldown;
	}

	override function render( engine : h3d.Engine ) {
		hxd.Timer.update();
		var dt = hxd.Timer.dt;
		ctx.elapsedTime += dt;
		if ( ctx.elapsedTime < presentCooldown )
			return;
		ctx.elapsedTime = 0.0;
		hxd.System.timeoutTick();
		super.render(engine);
		engine.driver.present();
	}
}
