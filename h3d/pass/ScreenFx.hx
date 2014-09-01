package h3d.pass;

class ScreenFx<T:hxsl.Shader> {

	public var shader : T;
	var pass : h3d.mat.Pass;
	var manager : h3d.shader.Manager;
	var plan : h3d.prim.Primitive;
	var engine : h3d.Engine;
	var fullClearRequired : Bool;
	var shaders : hxsl.ShaderList;

	public function new(shader) {
		this.shader = shader;
		shaders = new hxsl.ShaderList(shader);
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		pass = new h3d.mat.Pass(Std.string(this), new hxsl.ShaderList(shader));
		pass.culling = None;
		pass.depth(false, Always);
		plan = new h3d.prim.Plan2D();
		engine = h3d.Engine.getCurrent();
		fullClearRequired = engine.hasFeature(FullClearRequired);
	}

	public function render() {
		var rts = manager.compileShaders(shaders);
		engine.selectMaterial(pass);
		engine.selectShader(rts);
		var buf = new h3d.shader.Buffers(rts);
		manager.fillGlobals(buf, rts);
		manager.fillParams(buf, rts, shaders);
		engine.uploadShaderBuffers(buf, Globals);
		engine.uploadShaderBuffers(buf, Params);
		engine.uploadShaderBuffers(buf, Textures);
		plan.render(engine);
	}

	public function dispose() {
		plan.dispose();
	}

}