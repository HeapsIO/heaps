package h3d.scene.fwd;

class DepthPass extends h3d.pass.Output {

	var depthMapId : Int;
	public var enableSky : Bool = false;

	public function new() {
		super("depth",  [PackFloat(Value("output.depth"))]);
		depthMapId = hxsl.Globals.allocID("depthMap");
	}

	override function draw( passes, ?sort ) {
		var texture = ctx.textures.allocTarget("depthMap", ctx.engine.width, ctx.engine.height, true);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(enableSky ? 0 : 0xFF0000, 1);
		super.draw(passes, sort);
		ctx.engine.popTarget();
		ctx.globals.fastSet(depthMapId, { texture : texture });
	}

}

class NormalPass extends h3d.pass.Output {

	var normalMapId : Int;

	public function new() {
		super("normal", [PackNormal(Value("output.normal"))]);
		normalMapId = hxsl.Globals.allocID("normalMap");
	}

	override function draw( passes, ?sort ) {
		var texture = ctx.textures.allocTarget("normalMap", ctx.engine.width, ctx.engine.height);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0x808080, 1);
		super.draw(passes, sort);
		ctx.engine.popTarget();
		ctx.globals.fastSet(normalMapId, texture);
	}

}

class Renderer extends h3d.scene.Renderer {

	var def(get, never) : h3d.pass.Output;
	public var depth : h3d.pass.Output = new DepthPass();
	public var normal : h3d.pass.Output = new NormalPass();
	public var shadow = new h3d.pass.DefaultShadowMap(1024);

	public function new() {
		super();
		defaultPass = new h3d.pass.Output("default");
		allPasses = [defaultPass, depth, normal, shadow];
	}

	inline function get_def() return defaultPass;

	// can be overriden for benchmark purposes
	function renderPass(p:h3d.pass.Output, passes, ?sort) {
		p.draw(passes, sort);
	}

	override function getPassByName(name:String):h3d.pass.Output {
		if( name == "alpha" || name == "additive" )
			return defaultPass;
		return super.getPassByName(name);
	}

	override function render() {
		if( has("shadow") )
			renderPass(shadow,get("shadow"));

		if( has("depth") )
			renderPass(depth,get("depth"));

		if( has("normal") )
			renderPass(normal,get("normal"));

		renderPass(defaultPass, get("default") );
		renderPass(defaultPass, get("alpha"), backToFront );
		renderPass(defaultPass, get("additive") );
	}

}