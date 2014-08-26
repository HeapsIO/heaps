package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.mat.Pass)
class Base {

	var ctx : h3d.scene.RenderContext;
	var manager : h3d.shader.Manager;
	var globals(get, never) : hxsl.Globals;
	var priority : Int = 0;
	var cachedBuffer : h3d.shader.Buffers;
	public var lightSystem : LightSystem;

	inline function get_globals() return manager.globals;

	@global("camera.view") var cameraView : h3d.Matrix = ctx.camera.mcam;
	@global("camera.proj") var cameraProj : h3d.Matrix = ctx.camera.mproj;
	@global("camera.position") var cameraPos : h3d.Vector = ctx.camera.pos;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector = new h3d.Vector(ctx.camera.mproj._11,ctx.camera.mproj._22,ctx.camera.mproj._33,ctx.camera.mproj._44);
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix = ctx.camera.m;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix = ctx.camera.getInverseViewProj();
	@global("global.time") var globalTime : Float = ctx.time;
	@global("global.modelView") var globalModelView : h3d.Matrix;
	@global("global.modelViewInverse") var globalModelViewInverse : h3d.Matrix;
	@global("global.flipY") var globalFlipY : Float = {
		var t = ctx.engine.getTarget();
		t != null && !t.flags.has(TargetNoFlipY) ? -1 : 1;
	}

	public function new() {
		manager = new h3d.shader.Manager(getOutputs());
		initGlobals();
		lightSystem = new LightSystem(globals);
	}

	function getOutputs() {
		return ["output.position", "output.color"];
	}

	public function compileShader( p : h3d.mat.Pass ) {
		return manager.compileShaders(p.getShadersRec());
	}

	function initBuffer( s : hxsl.RuntimeShader, shaders : hxsl.ShaderList ) {
		if( cachedBuffer == null )
			cachedBuffer = new h3d.shader.Buffers(s);
		else
			cachedBuffer.grow(s);
		var buf = cachedBuffer;
		manager.fillGlobals(buf, s);
		manager.fillParams(buf, s, shaders);
		return buf;
	}

	@:access(h3d.scene)
	function setupShaders( passes : Object ) {
		var p = passes;
		var lightInit = false;
		while( p != null ) {
			var shaders = p.pass.getShadersRec();
			if( p.pass.enableLights && lightSystem != null ) {
				if( !lightInit )
					lightSystem.initLights(ctx.lights);
				shaders = lightSystem.computeLight(p.obj, shaders);
			}
			p.shader = manager.compileShaders(shaders);
			p.shaders = shaders;
			p = p.next;
		}
	}

	static inline function sortByShader( o1 : Object, o2 : Object ) {
		var d = o1.shader.id - o2.shader.id;
		if( d != 0 ) return d;
		// TODO : sort by textures
		return 0;
	}

	@:access(h3d.scene)
	public function draw( ctx : h3d.scene.RenderContext, passes : Object ) {
		this.ctx = ctx;
		for( k in ctx.sharedGlobals.keys() )
			globals.fastSet(k, ctx.sharedGlobals.get(k));
		setGlobals();
		setupShaders(passes);
		passes = haxe.ds.ListSort.sortSingleLinked(passes, sortByShader);
		var p = passes;
		var curShaderID = -1;
		while( p != null ) {
			globalModelView = p.obj.absPos;
			//if( p.shader.hasGlobal(globalModelViewInverseId) )
			globalModelViewInverse = p.obj.getInvPos();
			ctx.engine.selectShader(p.shader);
			var buf = initBuffer(p.shader, p.shaders);
			ctx.engine.selectMaterial(p.pass);
			if( p.shader.id != curShaderID ) {
				curShaderID = p.shader.id;
				ctx.engine.uploadShaderBuffers(buf, Globals);
			}
			ctx.engine.uploadShaderBuffers(buf, Params);
			ctx.engine.uploadShaderBuffers(buf, Textures);
			ctx.drawPass = p;
			p.obj.draw(ctx);
			p = p.next;
		}
		ctx.drawPass = null;
		this.ctx = null;
		return passes;
	}

}