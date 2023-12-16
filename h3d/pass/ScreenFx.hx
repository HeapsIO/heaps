package h3d.pass;

class ScreenFx<T:h3d.shader.ScreenShader> {

	public var shader : T;
	public var pass : h3d.mat.Pass;
	public var primitive : h3d.prim.Primitive;
	var manager : ShaderManager;
	var _engine : h3d.Engine;
	var engine(get,never) : h3d.Engine;
	var buffers : h3d.shader.Buffers;

	public function new(shader, ?output) {
		this.shader = shader;
		manager = new ShaderManager(output);
		pass = new h3d.mat.Pass("screenfx", new hxsl.ShaderList(shader));
		pass.culling = None;
		pass.depth(false, Always);
	}

	function get_engine() {
		if( _engine == null ) _engine = h3d.Engine.getCurrent();
		return _engine;
	}

	function copy( src, dst ) {
		h3d.pass.Copy.run(src,dst);
	}

	public inline function addShader<T:hxsl.Shader>(s:T) {
		return pass.addShader(s);
	}

	public inline function removeShader(s:hxsl.Shader) {
		return pass.removeShader(s);
	}

	public inline function getShader<T:hxsl.Shader>(cl:Class<T>) : T {
		return pass.getShader(cl);
	}

	public function render() {
		if( primitive == null )
			primitive = h3d.prim.Plane2D.get();
		shader.flipY = engine.driver.hasFeature(BottomLeftCoords) && engine.getCurrentTarget() != null ? -1 : 1;
		var shaders = @:privateAccess pass.shaders;
		var ctx = h3d.impl.RenderContext.get();
		var isNewCtx = false;
		if( ctx == null ) {
			isNewCtx = true;
			ctx = @:privateAccess new h3d.impl.RenderContext();
			ctx.setCurrent();
		}
		var rts = manager.compileShaders(ctx.globals, shaders);
		engine.selectMaterial(pass);
		engine.selectShader(rts);
		if( buffers == null )
			buffers = new h3d.shader.Buffers(rts);
		else
			buffers.grow(rts);
		ctx.fillGlobals(buffers, rts);
		ctx.fillParams(buffers, rts, shaders);
		engine.uploadShaderBuffers(buffers, Globals);
		engine.uploadShaderBuffers(buffers, Params);
		engine.uploadShaderBuffers(buffers, Textures);
		engine.uploadShaderBuffers(buffers, Buffers);
		primitive.render(engine);
		if( isNewCtx )
			ctx.clearCurrent();
	}

	public function dispose() {
	}

	public static function run( shader : h3d.shader.ScreenShader, output : h3d.mat.Texture, ?layer : Int ) {
		var engine = h3d.Engine.getCurrent();
		engine.pushTarget(output,layer);
		new ScreenFx(shader).render();
		engine.popTarget();
	}

}