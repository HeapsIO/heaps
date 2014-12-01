package h2d;

class RenderContext extends h3d.impl.RenderContext {

	public var buffer : hxd.FloatBuffer;
	public var bufPos : Int;

	public var textures : h3d.impl.TextureCache;

	public var tmpBounds = new h2d.col.Bounds();
	var texture : h3d.mat.Texture;
	var baseShader : h3d.shader.Base2d;
	var manager : h3d.shader.Manager;
	var compiledShader : hxsl.RuntimeShader;
	var buffers : h3d.shader.Buffers;
	var pass : h3d.mat.Pass;
	var currentShaders : hxsl.ShaderList;
	var baseShaderList : hxsl.ShaderList;
	var currentObj : Drawable;
	var stride : Int;
	var s2d : Scene;
	var targetsStack : Array<{ t : h3d.mat.Texture, x : Int, y : Int, w : Int, h : Int }>;

	public function new(s2d) {
		super();
		this.s2d = s2d;
		buffer = new hxd.FloatBuffer();
		bufPos = 0;
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		pass = new h3d.mat.Pass("",null);
		pass.depth(true, Always);
		pass.culling = None;
		baseShader = new h3d.shader.Base2d();
		baseShader.priority = 100;
		baseShader.zValue = 0.;
		baseShaderList = new hxsl.ShaderList(baseShader);
		targetsStack = [];
		textures = new h3d.impl.TextureCache();
	}

	public function begin() {
		texture = null;
		currentObj = null;
		bufPos = 0;
		stride = 0;
		// todo : we might prefer to auto-detect this by running a test and capturing its output
		baseShader.pixelAlign = #if flash true #else false #end;
		baseShader.halfPixelInverse.set(0.5 / engine.width, 0.5 / engine.height);
		baseShader.viewport.set( -s2d.width * 0.5, -s2d.height * 0.5, 2 / s2d.width, -2 / s2d.height);
		baseShaderList.next = null;
		initShaders(baseShaderList);
		engine.selectMaterial(pass);
		textures.begin(this);
	}

	function initShaders( shaders ) {
		currentShaders = shaders;
		compiledShader = manager.compileShaders(shaders);
		if( buffers == null )
			buffers = new h3d.shader.Buffers(compiledShader);
		else
			buffers.grow(compiledShader);
		manager.fillGlobals(buffers, compiledShader);
		engine.selectShader(compiledShader);
		engine.uploadShaderBuffers(buffers, Globals);
	}

	public function end() {
		flush();
		texture = null;
		currentObj = null;
		baseShaderList.next = null;
		if( targetsStack.length != 0 ) throw "Missing popTarget()";
	}

	public function pushTarget( t : h3d.mat.Texture, startX = 0, startY = 0, width = -1, height = -1 ) {
		flush();
		engine.setTarget(t);
		initShaders(baseShaderList);
		if( width < 0 ) width = t == null ? s2d.width : t.width;
		if( height < 0 ) height = t == null ? s2d.height : t.height;
		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewport.set( -width * 0.5 - startX, -height * 0.5 - startY, 2 / width, -2 / height);
		targetsStack.push( { t : t, x : startX, y : startY, w : width, h : height } );
	}

	public function popTarget( restore = true ) {
		flush();
		var tinf = targetsStack.pop();
		if( tinf == null ) throw "Too many popTarget()";

		if( !restore ) return;

		tinf = targetsStack[targetsStack.length - 1];
		var t = tinf == null ? null : tinf.t;
		var startX = tinf == null ? 0 : tinf.x;
		var startY = tinf == null ? 0 : tinf.y;
		var width = tinf == null ? s2d.width : tinf.w;
		var height = tinf == null ? s2d.height : tinf.h;
		engine.setTarget(t);
		initShaders(baseShaderList);
		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewport.set( -width * 0.5 - startX, -height * 0.5 - startY, 2 / width, -2 / height);
	}

	public function flush() {
		if( bufPos == 0 ) return;
		beforeDraw();
		var nverts = Std.int(bufPos / stride);
		var tmp = new h3d.Buffer(nverts, stride, [Quads, Dynamic, RawFormat]);
		tmp.uploadVector(buffer, 0, nverts);
		engine.renderQuadBuffer(tmp);
		tmp.dispose();
		bufPos = 0;
		texture = null;
	}

	public function beforeDraw() {
		if( texture == null ) texture = h3d.mat.Texture.fromColor(0xFF00FF);
		baseShader.texture = texture;
		texture.filter = currentObj.filter ? Linear : Nearest;
		texture.wrap = currentObj.tileWrap ? Repeat : Clamp;
		pass.setBlendMode(currentObj.blendMode);
		manager.fillParams(buffers, compiledShader, currentShaders);
		engine.selectMaterial(pass);
		engine.uploadShaderBuffers(buffers, Params);
		engine.uploadShaderBuffers(buffers, Textures);
	}

	@:access(h2d.Drawable)
	public function beginDrawObject( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		beginDraw(obj, texture, true);
		baseShader.color.set(obj.color.r, obj.color.g, obj.color.b, obj.color.a);
		baseShader.absoluteMatrixA.set(obj.matA, obj.matC, obj.absX);
		baseShader.absoluteMatrixB.set(obj.matB, obj.matD, obj.absY);
		beforeDraw();
	}

	@:access(h2d.Drawable)
	public function beginDrawBatch( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		beginDraw(obj, texture, false);
	}

	@:access(h2d.Drawable)
	function beginDraw(	obj : h2d.Drawable, texture : h3d.mat.Texture, isRelative : Bool ) {
		var stride = 8;
		if( currentObj != null && (texture != this.texture || stride != this.stride || obj.blendMode != currentObj.blendMode || obj.filter != currentObj.filter) )
			flush();
		var shaderChanged = false, paramsChanged = false;
		var objShaders = obj.shaders;
		var curShaders = currentShaders.next;
		while( objShaders != null && curShaders != null ) {
			var s = objShaders.s;
			var t = curShaders.s;
			objShaders = objShaders.next;
			curShaders = curShaders.next;
			if( s == t ) continue;
			paramsChanged = true;
			s.updateConstants(manager.globals);
			@:privateAccess {
				if( s.instance != t.instance )
					shaderChanged = true;
			}
		}
		if( objShaders != null || curShaders != null || baseShader.isRelative != isRelative )
			shaderChanged = true;
		if( shaderChanged ) {
			flush();

			baseShader.isRelative = isRelative;
			baseShader.updateConstants(manager.globals);
			baseShaderList.next = obj.shaders;
			initShaders(baseShaderList);
		} else if( paramsChanged ) {
			flush();
			if( currentShaders != baseShaderList ) throw "!";
			// the next flush will fetch their params
			currentShaders.next = obj.shaders;
		}

		this.texture = texture;
		this.stride = stride;
		this.currentObj = obj;
	}

}