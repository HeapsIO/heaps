package h3d.pass;

class ScreenFx<T:hxsl.Shader> {

	public var shader : T;
	var pass : h3d.mat.Pass;
	var manager : ShaderManager;
	var plan : h3d.prim.Primitive;
	var engine : h3d.Engine;
	var shaders : hxsl.ShaderList;
	var buffers : h3d.shader.Buffers;

	public function new(shader) {
		this.shader = shader;
		shaders = new hxsl.ShaderList(shader);
		manager = new ShaderManager();
		pass = new h3d.mat.Pass(Std.string(this), new hxsl.ShaderList(shader));
		pass.culling = None;
		pass.depth(false, Always);
		plan = h3d.prim.Plan2D.get();
		engine = h3d.Engine.getCurrent();
	}

	public function setGlobals( ctx :  h3d.scene.RenderContext ) {
		for( g in @:privateAccess ctx.sharedGlobals )
			manager.globals.fastSet(g.gid, g.value);
	}

	public function addShader<T:hxsl.Shader>(s:T) {
		shaders = hxsl.ShaderList.addSort(s, shaders);
		return pass.addShader(s);
	}

	public function render() {
		var rts = manager.compileShaders(shaders);
		engine.selectMaterial(pass);
		engine.selectShader(rts);
		if( buffers == null )
			buffers = new h3d.shader.Buffers(rts);
		else
			buffers.grow(rts);
		manager.fillGlobals(buffers, rts);
		manager.fillParams(buffers, rts, shaders);
		engine.uploadShaderBuffers(buffers, Globals);
		engine.uploadShaderBuffers(buffers, Params);
		engine.uploadShaderBuffers(buffers, Textures);
		plan.render(engine);
	}

	public function dispose() {
	}

}