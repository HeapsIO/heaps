package h3d.pass;

@:access(h3d.mat.Pass)
class Default extends Base {

	var manager : ShaderManager;
	var globals(get, never) : hxsl.Globals;
	var defaultSort = new SortByMaterial().sort;

	inline function get_globals() return ctx.globals;

	public function new(name) {
		super(name);
		manager = new ShaderManager(getOutputs());
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
		ctx.setupTarget();
		setupShaders(passes);
		if( sort == null )
			defaultSort(passes);
		else
			sort(passes);
		var buf = ctx.shaderBuffers, prevShader = null;
		for( p in passes ) {
			#if sceneprof h3d.impl.SceneProf.mark(p.obj); #end
			ctx.globalModelView = p.obj.absPos;
			if( p.shader.hasGlobal(ctx.globalModelViewInverse_id.toInt()) )
				ctx.globalModelViewInverse = p.obj.getInvPos();
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