package h3d.scene;

private typedef SMap<T> = #if flash haxe.ds.UnsafeStringMap<T> #else Map<String,T> #end

class DepthPass extends h3d.pass.Default {

	var depthMapId : Int;
	public var enableSky : Bool = false;
	public var reduceSize : Int = 0;

	public function new() {
		super("depth");
		depthMapId = hxsl.Globals.allocID("depthMap");
	}

	override function getOutputs() : Array<hxsl.Output> {
		return [PackFloat(Value("output.depth"))];
	}

	override function draw( passes ) {
		var texture = ctx.textures.allocTarget("depthMap", ctx.engine.width >> reduceSize, ctx.engine.height >> reduceSize, true);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(enableSky ? 0 : 0xFF0000, 1);
		passes = super.draw(passes);
		ctx.engine.popTarget();
		ctx.setGlobalID(depthMapId, { texture : texture });
		return passes;
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

	override function draw( passes ) {
		var texture = ctx.textures.allocTarget("normalMap", ctx.engine.width, ctx.engine.height);
		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0x808080, 1);
		passes = super.draw(passes);
		ctx.engine.popTarget();
		ctx.setGlobalID(normalMapId, texture);
		return passes;
	}

}
class DefaultRenderer extends Renderer {

	var def(get, never) : h3d.pass.Base;
	public var depth : h3d.pass.Base = new DepthPass();
	public var normal : h3d.pass.Base = new NormalPass();
	public var shadow = new h3d.pass.ShadowMap(1024);

	public function new() {
		super();
		defaultPass = new h3d.pass.Default("default");
		allPasses = [defaultPass, depth, normal, shadow];
	}

	inline function get_def() return defaultPass;

	// can be overriden for benchmark purposes
	function renderPass(p:h3d.pass.Base, passes) {
		p.draw(passes);
	}

	override function render() {
		if( has("shadow") )
			renderPass(shadow,get("shadow"));

		if( has("depth") )
			renderPass(depth,get("depth"));

		if( has("normal") )
			renderPass(normal,get("normal"));

		renderPass(defaultPass, getSort("default", true) );
		renderPass(defaultPass, getSort("alpha") );
		renderPass(defaultPass, get("additive") );
	}

}