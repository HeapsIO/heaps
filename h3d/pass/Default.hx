package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.mat.Pass)
class Default extends Base {

	var manager : ShaderManager;
	var globals(get, never) : hxsl.Globals;
	var cachedBuffer : h3d.shader.Buffers;
	var shaderCount : Int = 1;
	var textureCount : Int = 1;
	var shaderIdMap : Array<Int>;
	var textureIdMap : Array<Int>;
	var sortPasses = true;
	var logEnable(get, never) : Bool;

	inline function get_globals() return manager.globals;

	@global("camera.view") var cameraView : h3d.Matrix = ctx.camera.mcam;
	@global("camera.zNear") var cameraNear : Float = ctx.camera.zNear;
	@global("camera.zFar") var cameraFar : Float = ctx.camera.zFar;
	@global("camera.proj") var cameraProj : h3d.Matrix = ctx.camera.mproj;
	@global("camera.position") var cameraPos : h3d.Vector = ctx.camera.pos;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector = new h3d.Vector(ctx.camera.mproj._11,ctx.camera.mproj._22,ctx.camera.mproj._33,ctx.camera.mproj._44);
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix = ctx.camera.m;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix = ctx.camera.getInverseViewProj();
	@global("global.time") var globalTime : Float = ctx.time;
	@global("global.pixelSize") var pixelSize : h3d.Vector = new h3d.Vector(2 / ctx.engine.width, 2 / ctx.engine.height);
	@global("global.modelView") var globalModelView : h3d.Matrix;
	@global("global.modelViewInverse") var globalModelViewInverse : h3d.Matrix;

	public function new(name) {
		super(name);
		manager = new ShaderManager(getOutputs());
		shaderIdMap = [];
		textureIdMap = [];
		initGlobals();
	}

	inline function get_logEnable() {
		#if debug
		return ctx.engine.driver.logEnable;
		#else
		return false;
		#end
	}

	function getOutputs() : Array<hxsl.Output> {
		return [Value("output.color")];
	}

	override function compileShader( p : h3d.mat.Pass ) {
		var o = new Object();
		o.pass = p;
		setupShaders(o);
		return manager.compileShaders(o.shaders);
	}

	function processShaders( p : Object, shaders : hxsl.ShaderList ) {
		var p = ctx.extraShaders;
		while( p != null ) {
			shaders = ctx.allocShaderList(p.s, shaders);
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
					ctx.lightSystem.initGlobals(globals);
					lightInit = true;
				}
				shaders = ctx.lightSystem.computeLight(p.obj, shaders);
			}
			p.shader = manager.compileShaders(shaders);
			p.shaders = shaders;
			var t = p.shader.fragment.textures;
			if( t == null )
				p.texture = 0;
			else {
				var t : h3d.mat.Texture = manager.getParamValue(t, shaders, true);
				p.texture = t == null ? 0 : t.id;
			}
			p = p.next;
		}
	}

	function uploadParams() {
		manager.fillParams(cachedBuffer, ctx.drawPass.shader, ctx.drawPass.shaders);
		ctx.engine.uploadShaderBuffers(cachedBuffer, Params);
		ctx.engine.uploadShaderBuffers(cachedBuffer, Textures);
	}

	inline function log( str : String ) {
		ctx.engine.driver.log(str);
	}

	function drawObject( p : Object ) {
		ctx.drawPass = p;
		ctx.engine.selectMaterial(p.pass);
		@:privateAccess p.obj.draw(ctx);
	}

	@:access(h3d.scene)
	override function draw( passes : Object ) {
		for( g in ctx.sharedGlobals )
			globals.fastSet(g.gid, g.value);
		setGlobals();
		setupShaders(passes);
		var p = passes;
		var shaderStart = shaderCount, textureStart = textureCount;
		while( p != null ) {
			if( shaderIdMap[p.shader.id] < shaderStart #if js || shaderIdMap[p.shader.id] == null #end )
				shaderIdMap[p.shader.id] = shaderCount++;
			if( textureIdMap[p.texture] < textureStart #if js || textureIdMap[p.shader.id] == null #end )
				textureIdMap[p.texture] = textureCount++;
			p = p.next;
		}
		if( sortPasses )
			passes = haxe.ds.ListSort.sortSingleLinked(passes, function(o1:Object, o2:Object) {
				var d = shaderIdMap[o1.shader.id] - shaderIdMap[o2.shader.id];
				if( d != 0 ) return d;
				return textureIdMap[o1.texture] - textureIdMap[o2.texture];
			});
		ctx.uploadParams = uploadParams;
		var p = passes;
		var buf = cachedBuffer, prevShader = null;
		var drawTri = 0, drawCalls = 0, shaderSwitches = 0;
		if( ctx.engine.driver.logEnable ) {
			if( logEnable ) log("Pass " + (passes == null ? "???" : passes.pass.name) + " start");
			drawTri = ctx.engine.drawTriangles;
			drawCalls = ctx.engine.drawCalls;
			shaderSwitches = ctx.engine.shaderSwitches;
		}
		while( p != null ) {
			if( logEnable ) log("Render " + p.obj + "." + p.pass.name);
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
				ctx.engine.uploadShaderBuffers(buf, Buffers);
			}
			drawObject(p);
			p = p.next;
		}
		if( logEnable ) {
			log("Pass " + (passes == null ? "???" : passes.pass.name) + " end");
			log("\t" + (ctx.engine.drawTriangles - drawTri) + " tri " + (ctx.engine.drawCalls - drawCalls) + " calls " + (ctx.engine.shaderSwitches - shaderSwitches) + " shaders");
		}
		ctx.nextPass();
		return passes;
	}

}