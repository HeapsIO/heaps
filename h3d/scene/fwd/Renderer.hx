package h3d.scene.fwd;

private typedef SMap<T> = #if flash haxe.ds.UnsafeStringMap<T> #else Map<String,T> #end

class DepthPass extends h3d.pass.Default {

	var depthMapId : Int;
	public var enableSky : Bool = false;

	public function new() {
		super("depth");
		depthMapId = hxsl.Globals.allocID("depthMap");
	}

	override function getOutputs() : Array<hxsl.Output> {
		return [PackFloat(Value("output.depth"))];
	}

	override function draw( passes, ?sort ) {
		var texture = ctx.textures.allocTarget("depthMap", ctx.engine.width, ctx.engine.height, true);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(enableSky ? 0 : 0xFF0000, 1);
		super.draw(passes, sort);
		ctx.engine.popTarget();
		ctx.setGlobalID(depthMapId, { texture : texture });
	}

}

class NormalPass extends h3d.pass.Default {

	var normalMapId : Int;

	public function new() {
		super("normal");
		normalMapId = hxsl.Globals.allocID("normalMap");
	}

	override function getOutputs() : Array<hxsl.Output> {
		return [PackNormal(Value("output.normal"))];
	}

	override function draw( passes, ?sort ) {
		var texture = ctx.textures.allocTarget("normalMap", ctx.engine.width, ctx.engine.height);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0x808080, 1);
		super.draw(passes, sort);
		ctx.engine.popTarget();
		ctx.setGlobalID(normalMapId, texture);
	}

}

class Renderer extends h3d.scene.Renderer {

	var def(get, never) : h3d.pass.Base;
	public var depth : h3d.pass.Base = new DepthPass();
	public var normal : h3d.pass.Base = new NormalPass();
	public var shadow = new h3d.pass.DefaultShadowMap(1024);

	public function new() {
		super();
		defaultPass = new h3d.pass.Default("default");
		allPasses = [defaultPass, depth, normal, shadow];
	}

	inline function get_def() return defaultPass;

	// can be overriden for benchmark purposes
	function renderPass(p:h3d.pass.Base, passes, ?sort) {
		p.draw(passes, sort);
	}

	override function getPassByName(name:String):h3d.pass.Base {
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