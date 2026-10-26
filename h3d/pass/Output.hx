package h3d.pass;

@:access(h3d.mat.Pass)
class Output {

	public var name(default, null) : String;
	var ctx : h3d.scene.RenderContext;
	var output : OutputShader;
	var globals(get, never) : hxsl.Globals;
	var defaultSort = new SortByMaterial().sort;

	inline function get_globals() return ctx.globals;

	public function new(name, ?output) {
		this.name = name;
		this.output = new OutputShader(output);
	}

	public function setContext( ctx ) {
		this.ctx = ctx;
	}

	public function dispose() {
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
		var lightInit = false, failed = false;
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
			p.shaders = shaders;
			ctx.drawPass = p;
			if( !h3d.impl.RenderError.guard(compileShader(p), Compile(p)) ) {
				p.shader = null;
				failed = true;
				continue;
			}
			var t = p.shader.fragment.textures;
			if( t == null || t.type.match(TArray(_)) )
				p.texture = 0;
			else {
				var t : h3d.mat.Texture = ctx.getParamValue(t, shaders, true);
				p.texture = t == null ? 0 : t.id;
			}
		}
		ctx.drawPass = null;
		if( failed )
			passes.filter(p -> p.shader != null);
	}

	function compileShader( p : h3d.pass.PassObject ) {
		p.shader = output.compileShaders(ctx.globals, p.shaders, p.pass.batchMode ? Batch : Default);
	}

	inline function log( str : String ) {
		ctx.engine.driver.log(str);
	}

	@:access(h3d.scene)
	function setupObject( p : h3d.pass.PassObject ) {
		ctx.drawPass = p;
		ctx.globalPreviousModelView = p.obj.prevAbsPos ?? p.obj.absPos;
		ctx.globalModelView = p.obj.absPos;
		if( p.shader.hasGlobal(ctx.globalModelViewInverse_id.toInt()) )
			ctx.globalModelViewInverse = p.obj.getInvPos();
	}

	function setupShader( shader : hxsl.RuntimeShader ) {
		ctx.engine.selectShader(shader);
		if( ctx.engine.shaderFailed )
			return;
		var buf = ctx.shaderBuffers;
		buf.grow(shader);
		ctx.fillGlobals(buf, shader);
		ctx.engine.uploadShaderBuffers(buf, Globals);
	}

	function uploadParams( p : h3d.pass.PassObject ) {
		if( p.pass.dynamicParameters )
			return;
		var buf = ctx.shaderBuffers;
		ctx.currentObject = p.obj;
		ctx.fillParams(buf, p.shader, p.shaders);
		ctx.currentObject = null;
		ctx.engine.uploadInstanceShaderBuffers(buf);
	}

	function drawObject( p : h3d.pass.PassObject ) {
		if( ctx.useReverseDepth ) {
			p.pass.reverseDepthTest();
			ctx.engine.selectMaterial(p.pass);
			p.pass.reverseDepthTest();
		} else {
			ctx.engine.selectMaterial(p.pass);
		}
		p.obj.drawn = true;
		@:privateAccess p.obj.draw(ctx);
	}

	function beginEvent( name : String ) {
		ctx.engine.driver.beginEvent(name);
		#if sceneprof h3d.impl.SceneProf.begin('draw_$name', ctx.frame); #end
	}

	function endEvent() {
		ctx.engine.driver.endEvent();
		#if sceneprof h3d.impl.SceneProf.end(); #end
	}

	@:access(h3d.scene)
	public function draw( passes : h3d.pass.PassList, ?sort : h3d.pass.PassList -> Void ) {
		if( passes.isEmpty() )
			return;
		beginEvent(@:privateAccess passes.current.pass.name);
		ctx.setupTarget();
		setupShaders(passes);
		if( sort == null )
			defaultSort(passes);
		else
			sort(passes);
		var prevShader = null;
		for( p in passes ) {
			#if sceneprof h3d.impl.SceneProf.mark(p.obj); #end
			setupObject(p);
			if( prevShader != p.shader ) {
				prevShader = p.shader;
				setupShader(p.shader);
			}
			if( ctx.engine.shaderFailed )
				continue;
			if( !h3d.impl.RenderError.guard(uploadParams(p), Params(p.shader)) ) {
				ctx.currentObject = null;
				continue;
			}
			h3d.impl.RenderError.guard(drawObject(p), Draw(p));
		}
		endEvent();
		ctx.nextPass();
	}
}
