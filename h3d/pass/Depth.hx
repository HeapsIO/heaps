package h3d.pass;

class Depth extends Default {

	var depthMapId : Int;
	public var enableSky : Bool = false;

	public function new() {
		super();
		priority = 10;
		depthMapId = hxsl.Globals.allocID("depthMap");
	}

	override function getOutputs() {
		return ["output.position", "output.depth"];
	}

	override function draw( name : String, passes ) {
		var texture = getTargetTexture("depthMap", ctx.engine.width, ctx.engine.height);
		ctx.engine.setTarget(texture);
		ctx.engine.clear(enableSky ? 0 : 0xFF0000, 1);
		passes = super.draw(name, passes);
		ctx.engine.setTarget(null);
		ctx.sharedGlobals.set(depthMapId, texture);
		return passes;
	}

}