package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.mat.Pass)
class Default extends Base {

	var manager : ShaderManager;
	var globals(get, never) : hxsl.Globals;
	var defaultSort = new SortByMaterial().sort;

	inline function get_globals() return ctx.globals;

	@global("camera.view") var cameraView : h3d.Matrix = ctx.camera.mcam;
	@global("camera.zNear") var cameraNear : Float = ctx.camera.zNear;
	@global("camera.zFar") var cameraFar : Float = ctx.camera.zFar;
	@global("camera.proj") var cameraProj : h3d.Matrix = ctx.camera.mproj;
	@global("camera.position") var cameraPos : h3d.Vector = ctx.camera.pos;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector4 = new h3d.Vector4(ctx.camera.mproj._11,ctx.camera.mproj._22,ctx.camera.mproj._33,ctx.camera.mproj._44);
	@global("camera.projFlip") var cameraProjFlip : Float = ctx.engine.driver.hasFeature(BottomLeftCoords) && ctx.engine.getCurrentTarget() != null ? -1 : 1;
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix = ctx.camera.m;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix = ctx.camera.getInverseViewProj();
	@global("global.time") var globalTime : Float = ctx.time;
	@global("global.pixelSize") var pixelSize : h3d.Vector = getCurrentPixelSize();
	@global("global.modelView") var globalModelView : h3d.Matrix;
	@global("global.modelViewInverse") var globalModelViewInverse : h3d.Matrix;

	public function new(name) {
		super(name);
		manager = new ShaderManager(getOutputs());
		initGlobals();
	}

	function getCurrentPixelSize() {
		var t = ctx.engine.getCurrentTarget();
		return new h3d.Vector(2 / (t == null ? ctx.engine.width : t.width), 2 / (t == null ? ctx.engine.height : t.height));
	}

	function getOutputs() : Array<hxsl.Output> {
		return [Value("output.color")];
	}

	override function compileShader( p : h3d.mat.Pass ) {
		var o = @:privateAccess new h3d.pass.PassObject();
		o.pass = p;
		setupShaders(new h3d.pass.PassList(o));
		return manager.compileShaders(ctx.globals, o.shaders, p.batchMode ? Batch : Default);
	}

	function processShaders( p : h3d.pass.PassObject, shaders : hxsl.ShaderList ) {
		var p = ctx.extraShaders;
		while( p != null ) {
			shaders = ctx.allocShaderList(p.s, shaders);
			p = p.next;
		}
		return shaders;
	}

	@:access(h3d.scene)
	function setupShaders( passes : h3d.pass.PassList ) {
		var lightInit = false;
		for( p in passes ) {
			var shaders = p.pass.getShadersRec();
			shaders = processShaders(p, shaders);
			if( p.pass.enableLights && ctx.lightSystem != null ) {
				if( !lightInit ) {
					ctx.lightSystem.initGlobals(globals);
					lightInit = true;
				}
				shaders = ctx.lightSystem.computeLight(p.obj, shaders);
			}
			p.shader = manager.compileShaders(ctx.globals, shaders, p.pass.batchMode ? Batch : Default);
			p.shaders = shaders;
			var t = p.shader.fragment.textures;
			if( t == null || t.type.match(TArray(_)) )
				p.texture = 0;
			else {
				var t : h3d.mat.Texture = ctx.getParamValue(t, shaders, true);
				p.texture = t == null ? 0 : t.id;
			}
		}
	}

	inline function log( str : String ) {
		ctx.engine.driver.log(str);
	}

	function drawObject( p : h3d.pass.PassObject ) {
		ctx.drawPass = p;
		ctx.engine.selectMaterial(p.pass);
		@:privateAccess p.obj.draw(ctx);
	}

	public static var onShaderError : Dynamic -> PassObject -> Void;

	@:access(h3d.scene)
	override function draw( passes : h3d.pass.PassList, ?sort : h3d.pass.PassList -> Void ) {
		if( passes.isEmpty() )
			return;
		#if sceneprof h3d.impl.SceneProf.begin("draw", ctx.frame); #end
		setGlobals();
		setupShaders(passes);
		if( sort == null )
			defaultSort(passes);
		else
			sort(passes);
		var buf = ctx.shaderBuffers, prevShader = null;
		for( p in passes ) {
			#if sceneprof h3d.impl.SceneProf.mark(p.obj); #end
			globalModelView = p.obj.absPos;
			if( p.shader.hasGlobal(globalModelViewInverse_id.toInt()) )
				globalModelViewInverse = p.obj.getInvPos();
			if( prevShader != p.shader ) {
				prevShader = p.shader;
				if( onShaderError != null ) {
					try {
						ctx.engine.selectShader(p.shader);
					} catch(e : Dynamic) {
						onShaderError(e, p);
						continue;
					}
				} else {
					ctx.engine.selectShader(p.shader);
				}
				if( buf == null )
					buf = ctx.shaderBuffers = new h3d.shader.Buffers(p.shader);
				else
					buf.grow(p.shader);
				ctx.fillGlobals(buf, p.shader);
				ctx.engine.uploadShaderBuffers(buf, Globals);
			}
			if( !p.pass.dynamicParameters ) {
				ctx.fillParams(buf, p.shader, p.shaders);
				ctx.engine.uploadShaderBuffers(buf, Params);
				ctx.engine.uploadShaderBuffers(buf, Textures);
				ctx.engine.uploadShaderBuffers(buf, Buffers);
			}
			drawObject(p);
		}
		#if sceneprof h3d.impl.SceneProf.end(); #end
		ctx.nextPass();
	}
}