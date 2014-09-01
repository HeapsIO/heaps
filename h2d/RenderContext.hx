package h2d;

class RenderContext {

	public var engine : h3d.Engine;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;

	public var buffer : hxd.FloatBuffer;
	public var bufPos : Int;

	var texture : h3d.mat.Texture;
	var baseShader : h3d.shader.Base2d;
	var manager : h3d.shader.Manager;
	var compiledShader : hxsl.RuntimeShader;
	var buffers : h3d.shader.Buffers;
	var pass : h3d.mat.Pass;
	var currentShaders : Array<hxsl.Shader>;
	var currentObj : Drawable;
	var stride : Int;

	public function new() {
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.Stage.getInstance().getFrameRate();
		buffer = new hxd.FloatBuffer();
		bufPos = 0;
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		pass = new h3d.mat.Pass("",null);
		pass.depth(true, Always);
		pass.culling = None;
		baseShader = new h3d.shader.Base2d();
		baseShader.zValue = 0.;
	}

	public function begin() {
		texture = null;
		currentObj = null;
		bufPos = 0;
		stride = 0;
		initShaders([baseShader]);
		engine.selectMaterial(pass);
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
	}

	public function setTarget( t : h3d.mat.Texture ) {
		flush();
		engine.setTarget(t);
		begin();
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
		switch( currentObj.blendMode ) {
		case Normal:
			pass.blend(SrcAlpha, OneMinusSrcAlpha);
		case None:
			pass.blend(One, Zero);
		case Add:
			pass.blend(SrcAlpha, One);
		case SoftAdd:
			pass.blend(OneMinusDstColor, One);
		case Multiply:
			pass.blend(DstColor, OneMinusSrcAlpha);
		case Erase:
			pass.blend(Zero, OneMinusSrcAlpha);
		}
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
		if( obj.shaders.length + 1 != currentShaders.length )
			shaderChanged = true;
		else {
			for( i in 0...obj.shaders.length ) {
				var s = obj.shaders[i];
				var t = currentShaders[i + 1];
				if( s == t ) continue;
				paramsChanged = true;
				s.updateConstants(manager.globals);
				@:privateAccess {
					if( s.instance != t.instance )
						shaderChanged = true;
				}
			}
		}
		if( baseShader.isRelative != isRelative )
			shaderChanged = true;
		if( shaderChanged ) {
			flush();
			var ns = obj.shaders.copy();
			ns.unshift(baseShader);
			baseShader.isRelative = isRelative;
			initShaders(ns);
		} else if( paramsChanged ) {
			flush();
			// copy so the next flush will fetch their params
			for( i in 0...obj.shaders.length )
				currentShaders[i+1] = obj.shaders[i];
		}

		this.texture = texture;
		this.stride = stride;
		this.currentObj = obj;
	}

}