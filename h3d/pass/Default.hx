package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.mat.Pass)
class Default extends Base {

	var manager : h3d.shader.Manager;
	var globals(get, never) : hxsl.Globals;
	var cachedBuffer : h3d.shader.Buffers;
	var tcache : TextureCache;

	inline function get_globals() return manager.globals;

	@global("camera.view") var cameraView : h3d.Matrix = ctx.camera.mcam;
	@global("camera.proj") var cameraProj : h3d.Matrix = ctx.camera.mproj;
	@global("camera.position") var cameraPos : h3d.Vector = ctx.camera.pos;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector = new h3d.Vector(ctx.camera.mproj._11,ctx.camera.mproj._22,ctx.camera.mproj._33,ctx.camera.mproj._44);
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix = ctx.camera.m;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix = ctx.camera.getInverseViewProj();
	@global("global.time") var globalTime : Float = ctx.time;
	@global("global.pixelSize") var pixelSize : h3d.Vector = new h3d.Vector(2 / ctx.engine.width, 2 / ctx.engine.height);
	@global("global.modelView") var globalModelView : h3d.Matrix;
	@global("global.modelViewInverse") var globalModelViewInverse : h3d.Matrix;
	@global("global.flipY") var globalFlipY : Float = {
		var t = ctx.engine.getTarget();
		t != null && !t.flags.has(TargetNoFlipY) ? -1 : 1;
	}

	public function new() {
		super();
		manager = new h3d.shader.Manager(getOutputs());
		tcache = new TextureCache();
		initGlobals();
	}

	override function getTexture( index = 0 ) : h3d.mat.Texture {
		return tcache.get(index);
	}

	override function dispose() {
		super.dispose();
		tcache.dispose();
	}

	function getOutputs() {
		return ["output.position", "output.color"];
	}

	override function compileShader( p : h3d.mat.Pass ) {
		return manager.compileShaders(p.getShadersRec());
	}

	function processShaders( p : Object, shaders : hxsl.ShaderList ) {
		var p = ctx.extraShaders;
		while( p != null ) {
			shaders = new hxsl.ShaderList(p.s, shaders);
			p = p.next;
		}
		return shaders;
	}

	@:access(h3d.scene)
	function setupShaders( passes : Object ) {
		var p = passes;
		var lightInit = false;
		while( p != null ) {
			var shaders = p.pass.getShadersRec();
			shaders = processShaders(p, shaders);
			if( p.pass.enableLights && ctx.lightSystem != null ) {
				if( !lightInit ) {
					ctx.lightSystem.initLights(globals, ctx.lights);
					lightInit = true;
				}
				shaders = ctx.lightSystem.computeLight(p.obj, shaders);
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

	function uploadParams() {
		manager.fillParams(cachedBuffer, ctx.drawPass.shader, ctx.drawPass.shaders);
		ctx.engine.uploadShaderBuffers(cachedBuffer, Params);
		ctx.engine.uploadShaderBuffers(cachedBuffer, Textures);
	}

	inline function log( str : String ) {
		ctx.engine.driver.log(str);
	}

	@:access(h3d.scene)
	override function draw( passes : Object ) {
		for( k in ctx.sharedGlobals.keys() )
			globals.fastSet(k, ctx.sharedGlobals.get(k));
		setGlobals();
		setupShaders(passes);
		passes = haxe.ds.ListSort.sortSingleLinked(passes, sortByShader);
		ctx.uploadParams = uploadParams;
		var p = passes;
		var buf = cachedBuffer, prevShader = null;
		log("Pass " + (passes == null ? "???" : passes.pass.name) + " start");
		while( p != null ) {
			log("Render " + p.obj + "." + p.pass.name);
			globalModelView = p.obj.absPos;
			if( p.shader.hasGlobal(globalModelViewInverse_id.toInt()) )
				globalModelViewInverse = p.obj.getInvPos();
			if( prevShader != p.shader ) {
				prevShader = p.shader;
				ctx.engine.selectShader(p.shader);
				if( buf == null )
					buf = cachedBuffer = new h3d.shader.Buffers(p.shader);
				else
					buf.grow(p.shader);
				manager.fillGlobals(buf, p.shader);
				ctx.engine.uploadShaderBuffers(buf, Globals);
			}
			if( !p.pass.dynamicParameters ) {
				manager.fillParams(buf, p.shader, p.shaders);
				ctx.engine.uploadShaderBuffers(buf, Params);
				ctx.engine.uploadShaderBuffers(buf, Textures);
			}
			ctx.drawPass = p;
			ctx.engine.selectMaterial(p.pass);
			p.obj.draw(ctx);
			p = p.next;
		}
		log("Pass " + (passes == null ? "???" : passes.pass.name) + " end");
		ctx.drawPass = null;
		return passes;
	}

}