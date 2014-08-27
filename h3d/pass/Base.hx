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
	public var name(default, null) : String;

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

	public function new(name) {
		this.name = name;
		manager = new h3d.shader.Manager(getOutputs());
		initGlobals();
		lightSystem = new LightSystem(globals);
	}

	function getOutputs() {
		return ["output.position", "output.color"];
	}

	public function compileShader( p : h3d.mat.Pass ) {
		var out = [for( s in p.getShadersRec() ) s];
		out.reverse();
		return manager.compileShaders(out);
	}

	@:access(h3d.scene)
	function setupShaders( passes : Object ) {
		var p = passes;
		var lightInit = false;
		var instances = [];
		while( p != null ) {
			var shaders = p.pass.getShadersRec();
			if( p.pass.enableLights && lightSystem != null ) {
				if( !lightInit ) {
					lightSystem.initLights(ctx.lights);
					lightInit = true;
				}
				shaders = lightSystem.computeLight(p.obj, shaders);
			}
			var count = 0;
			for( s in shaders )
				p.shaders[count++] = s;
			// TODO : allow reversed shader compilation !
			// reverse
			for( n in 0...count >> 1 ) {
				var n2 = count - 1 - n;
				var tmp = p.shaders[n];
				p.shaders[n] = p.shaders[n2];
				p.shaders[n2] = tmp;
			}
			for( i in 0...count ) {
				var s = p.shaders[i];
 				s.updateConstants(globals);
				instances[i] = @:privateAccess s.instance;
			}
			instances[count] = null; // mark end
			p.shader = manager.compileInstances(instances);
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
	public function draw( ctx : h3d.scene.RenderContext, passes : Object ) {
		this.ctx = ctx;
		for( k in ctx.sharedGlobals.keys() )
			globals.fastSet(k, ctx.sharedGlobals.get(k));
		setGlobals();
		setupShaders(passes);
		passes = haxe.ds.ListSort.sortSingleLinked(passes, sortByShader);
		ctx.uploadParams = uploadParams;
		var p = passes;
		var buf = cachedBuffer, prevShader = null;
		log("Pass " + name+ " start");
		while( p != null ) {
			log("Render " + p.obj + "." + name);
			globalModelView = p.obj.absPos;
			if( p.shader.hasGlobal(globalModelViewInverse_id.toInt()) )
				globalModelViewInverse = p.obj.getInvPos();
			if( prevShader != p.shader ) {
				prevShader = p.shader;
				ctx.engine.selectShader(p.shader);
				ctx.engine.selectMaterial(p.pass);
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
			p.obj.draw(ctx);
			p = p.next;
		}
		log("Pass " + name + " end");
		ctx.drawPass = null;
		this.ctx = null;
		return passes;
	}

}