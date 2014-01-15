package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.pass.Pass)
class Base {

	var ctx : h3d.scene.RenderContext;
	var manager : h3d.shader.Manager;
	var globals(get, never) : hxsl.Globals;
	inline function get_globals() return manager.globals;

	@global("camera.view") var cameraView : h3d.Matrix = ctx.camera.mcam;
	@global("camera.proj") var cameraProj : h3d.Matrix = ctx.camera.mproj;
	@global("camera.position") var cameraPos : h3d.Vector = ctx.camera.pos;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector = new h3d.Vector(ctx.camera.mproj._11,ctx.camera.mproj._22,ctx.camera.mproj._33,ctx.camera.mproj._44);
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix = ctx.camera.m;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix = ctx.camera.getInverseViewProj();
	@global("global.time") var globalTime : Float = ctx.time;
	@global("global.modelView") var globalModelView : h3d.Matrix;
	
	public function new() {
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		initGlobals();
	}
	
	public function compileShader( p : Pass ) {
		return manager.compileShaders(p.getShadersRec());
	}
	
	function allocBuffer( s : hxsl.RuntimeShader, shaders : Array<hxsl.Shader> ) {
		var buf = new h3d.shader.Buffers(s);
		manager.fillGlobals(buf, s);
		manager.fillParams(buf, s, shaders);
		return buf;
	}
	
	@:access(h3d.scene.Object)
	public function draw( ctx : h3d.scene.RenderContext, passes : Object ) {
		this.ctx = ctx;
		setGlobals();
		var p = passes;
		while( p != null ) {
			var shaders = p.pass.getShadersRec();
			var shader = compileShader(p.pass);
			// TODO : sort passes by shader/textures
			globalModelView.set(globals, p.obj.absPos);
			// TODO : reuse buffers between calls
			var buf = allocBuffer(shader, shaders);
			ctx.engine.selectShader(shader);
			ctx.engine.selectMaterial(p.pass);
			ctx.engine.uploadShaderBuffers(buf, Globals);
			ctx.engine.uploadShaderBuffers(buf, Params);
			ctx.engine.uploadShaderBuffers(buf, Textures);
			p.obj.draw(ctx);
			p = p.next;
		}
		this.ctx = null;
	}
	
}