package h3d.pass;

class Normal extends Default {

	var normalMapId : Int;

	public function new() {
		super();
		priority = 10;
		normalMapId = hxsl.Globals.allocID("normalMap");
	}

	override function getOutputs() : Array<hxsl.Output> {
		return [PackNormal(Value("output.normal"))];
	}

	override function draw( passes ) {
		var texture = tcache.allocTarget("normalMal", ctx, ctx.engine.width, ctx.engine.height);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0x808080, 1);
		passes = super.draw(passes);
		ctx.engine.popTarget();
		ctx.setGlobalID(normalMapId, texture);
		return passes;
	}

}