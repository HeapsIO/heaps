package h3d.pass;

class ScreenFx<T:h3d.shader.ScreenShader> {

	public var shader : T;
	public var pass : h3d.mat.Pass;
	var manager : ShaderManager;
	var plane : h3d.prim.Primitive;
	var engine : h3d.Engine;
	var shaders : hxsl.ShaderList;
	var buffers : h3d.shader.Buffers;

	public function new(shader, ?output) {
		this.shader = shader;
		shaders = new hxsl.ShaderList(shader);
		manager = new ShaderManager(output);
		pass = new h3d.mat.Pass(Std.string(this), new hxsl.ShaderList(shader));
		pass.culling = None;
		pass.depth(false, Always);
		plane = h3d.prim.Plane2D.get();
		engine = h3d.Engine.getCurrent();
	}

	function copy( src, dst ) {
		h3d.pass.Copy.run(src,dst);
	}

	public function setGlobals( ctx :  h3d.scene.RenderContext ) {
		for( g in @:privateAccess ctx.sharedGlobals )
			manager.globals.fastSet(g.gid, g.value);
	}

	public function addShader<T:hxsl.Shader>(s:T) {
		shaders = hxsl.ShaderList.addSort(s, shaders);
		return pass.addShader(s);
	}

	public function removeShader(s:hxsl.Shader) {
		var prev : hxsl.ShaderList = null;
		var cur = shaders;
		while( cur != null ) {
			if( cur.s == s ) {
				if( prev == null ) shaders = cur.next else prev.next = cur.next;
				return true;
			}
			prev = cur;
			cur = cur.next;
		}
		return false;
	}

	public function getShader<T:hxsl.Shader>(cl:Class<T>) : T {
		for( s in shaders ) {
			var si = Std.instance(s, cl);
			if( si != null ) return si;
		}
		return null;
	}

	public function render() {
		var rts = manager.compileShaders(shaders);
		shader.flipY = engine.driver.hasFeature(BottomLeftCoords) && engine.getCurrentTarget() != null ? -1 : 1;
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
		plane.render(engine);
	}

	public function dispose() {
	}

}