package h3d.pass;

class Normal extends Default {

	var normalMapId : Int;

	public function new() {
		super();
		priority = 10;
		normalMapId = hxsl.Globals.allocID("normalMap");
	}

	override function getOutputs() {
		return ["output.position", "output.normal"];
	}

	override function draw( name : String, passes ) {
		var texture = getTargetTexture("normalMal", ctx.engine.width, ctx.engine.height);
		ctx.engine.setTarget(texture);
		ctx.engine.clear(0, 1);
		passes = super.draw(name, passes);
		ctx.engine.setTarget(null);
		ctx.sharedGlobals.set(normalMapId, texture);
		return passes;
	}

}