package h3d.pass;

class Clear {

	var shader : h3d.shader.Clear;
	var pass : h3d.mat.Pass;
	var manager : h3d.shader.Manager;
	var plan : h3d.prim.Plan2D;

	public function new() {
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		shader = new h3d.shader.Clear();
		pass = new h3d.mat.Pass("clear", new hxsl.ShaderList(shader));
		pass.culling = None;
		plan = new h3d.prim.Plan2D();
	}

	public function apply( ?color : h3d.Vector, ?depth : Float ) {
		pass.depth(depth != null, Always);
		shader.depth = depth != null ? depth : 0;
		if( color != null ) shader.color.load(color);

		var shaders : Array<hxsl.Shader> = [shader];
		var rts = manager.compileShaders(shaders);
		var engine = h3d.Engine.getCurrent();
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

}