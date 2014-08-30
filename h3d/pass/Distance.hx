package h3d.pass;

class Distance extends Default {

	var distanceMapId : Int;
	public var enableSky : Bool = false;

	public function new() {
		super();
		priority = 10;
		lightSystem = null;
		distanceMapId = hxsl.Globals.allocID("distanceMap");
	}

	override function getOutputs() {
		return ["output.position", "output.distance"];
	}

	override function draw( name : String, passes ) {
		var texture = getTargetTexture("distanceMap", ctx.engine.width, ctx.engine.height);
		ctx.engine.setTarget(texture);
		ctx.engine.clear(enableSky ? 0 : 0xFF0000, 1);
		passes = super.draw(name, passes);
		ctx.engine.setTarget(null);
		ctx.sharedGlobals.set(distanceMapId, texture);
		return passes;
	}

}