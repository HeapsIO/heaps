package h2d;

class RenderContext extends h3d.impl.RenderContext {

	static inline var BUFFERING = false;

	public var globalAlpha = 1.;
	public var buffer : hxd.FloatBuffer;
	public var bufPos : Int;
	public var textures : h3d.impl.TextureCache;
	public var scene : h2d.Scene;

	public var tmpBounds = new h2d.col.Bounds();
	var texture : h3d.mat.Texture;
	var baseShader : h3d.shader.Base2d;
	var manager : h3d.shader.Manager;
	var compiledShader : hxsl.RuntimeShader;
	var buffers : h3d.shader.Buffers;
	var fixedBuffer : h3d.Buffer;
	var pass : h3d.mat.Pass;
	var currentShaders : hxsl.ShaderList;
	var baseShaderList : hxsl.ShaderList;
	var currentObj : Drawable;
	var stride : Int;
	var targetsStack : Array<{ t : h3d.mat.Texture, x : Int, y : Int, w : Int, h : Int }>;
	var hasUVPos : Bool;
	var inFilter : Bool;

	var curX : Int;
	var curY : Int;
	var curWidth : Int;
	var curHeight : Int;

	public function new(scene) {
		super();
		this.scene = scene;
		if( BUFFERING )
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

	public inline function hasBuffering() {
		return BUFFERING;
	}

	public function begin() {
		texture = null;
		currentObj = null;
		bufPos = 0;
		stride = 0;
		curX = 0;
		curY = 0;
		inFilter = false;
		curWidth = scene.width;
		curHeight = scene.height;
		manager.globals.set("time", time);
		// todo : we might prefer to auto-detect this by running a test and capturing its output
		baseShader.pixelAlign = #if flash true #else false #end;
		baseShader.halfPixelInverse.set(0.5 / engine.width, 0.5 / engine.height);
		baseShader.viewport.set( -scene.width * 0.5, -scene.height * 0.5, 2 / scene.width, -2 / scene.height);
		baseShader.filterMatrixA.set(1, 0, 0);
		baseShader.filterMatrixB.set(0, 1, 0);
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
		engine.pushTarget(t);
		initShaders(baseShaderList);
		if( width < 0 ) width = t == null ? scene.width : t.width;
		if( height < 0 ) height = t == null ? scene.height : t.height;
		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewport.set( -width * 0.5 - startX, -height * 0.5 - startY, 2 / width, -2 / height);
		targetsStack.push( { t : t, x : startX, y : startY, w : width, h : height } );
		curX = startX;
		curY = startY;
		curWidth = width;
		curHeight = height;
	}

	public function popTarget( restore = true ) {
		flush();
		var tinf = targetsStack.pop();
		if( tinf == null ) throw "Too many popTarget()";
		engine.popTarget();

		if( !restore ) return;

		tinf = targetsStack[targetsStack.length - 1];
		var t = tinf == null ? null : tinf.t;
		var startX = tinf == null ? 0 : tinf.x;
		var startY = tinf == null ? 0 : tinf.y;
		var width = tinf == null ? scene.width : tinf.w;
		var height = tinf == null ? scene.height : tinf.h;
		initShaders(baseShaderList);
		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewport.set( -width * 0.5 - startX, -height * 0.5 - startY, 2 / width, -2 / height);
		curX = startX;
		curY = startY;
		curWidth = width;
		curHeight = height;
	}

	public inline function flush() {
		if( hasBuffering() ) _flush();
	}

	function _flush() {
		if( bufPos == 0 ) return;
		beforeDraw();
		var nverts = Std.int(bufPos / stride);
		var tmp = new h3d.Buffer(nverts, stride, [Quads,Dynamic,RawFormat]);
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
		baseShader.color.set(obj.color.r, obj.color.g, obj.color.b, obj.color.a * globalAlpha);
		baseShader.absoluteMatrixA.set(obj.matA, obj.matC, obj.absX);
		baseShader.absoluteMatrixB.set(obj.matB, obj.matD, obj.absY);
		beforeDraw();
	}

	@:access(h2d.Drawable)
	public function beginDrawBatch( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		beginDraw(obj, texture, false);
	}

	@:access(h2d.Drawable)
	public function drawTile( obj : h2d.Drawable, tile : h2d.Tile ) {

		var matA, matB, matC, matD, absX, absY;
		if( inFilter ) {
			var f1 = baseShader.filterMatrixA;
			var f2 = baseShader.filterMatrixB;
			matA = obj.matA * f1.x + obj.matB * f1.y;
			matB = obj.matA * f2.x + obj.matB * f2.y;
			matC = obj.matC * f1.x + obj.matD * f1.y;
			matD = obj.matC * f2.x + obj.matD * f2.y;
			absX = obj.absX * f1.x + obj.absY * f1.y + f1.z;
			absY = obj.absX * f2.x + obj.absY * f2.y + f2.z;
		} else {
			matA = obj.matA;
			matB = obj.matB;
			matC = obj.matC;
			matD = obj.matD;
			absX = obj.absX;
			absY = obj.absY;
		}

		// check if our tile is outside of the viewport
		if( matB == 0 && matC == 0 ) {
			var tx = tile.dx + tile.width * 0.5;
			var ty = tile.dy + tile.height * 0.5;
			var tr = (tile.width > tile.height ? tile.width : tile.height) * 1.5 * hxd.Math.max(hxd.Math.abs(obj.matA),hxd.Math.abs(obj.matD));
			var cx = absX + tx * matA - curX;
			var cy = absY + ty * matD - curY;
			if( cx < -tr || cy < -tr || cx - tr > curWidth || cy - tr > curHeight ) return;
		} else {
			var xMin = 1e20, yMin = 1e20, xMax = -1e20, yMax = -1e20;
			inline function calc(x:Int, y:Int) {
				var px = (x + tile.dx) * matA + (y + tile.dy) * matC;
				var py = (x + tile.dx) * matB + (y + tile.dy) * matD;
				if( px < xMin ) xMin = px;
				if( px > xMax ) xMax = px;
				if( py < yMin ) yMin = py;
				if( py > yMax ) yMax = py;
			}
			var hw = tile.width * 0.5;
			var hh = tile.height * 0.5;
			calc(0, 0);
			calc(tile.width, 0);
			calc(0, tile.height);
			calc(tile.width, tile.height);
			var cx = absX - curX;
			var cy = absY - curY;
			if( cx + xMax < 0 || cy + yMax < 0 || cx + xMin > curWidth || cy + yMin > curHeight )
				return;
		}

		beginDraw(obj, tile.getTexture(), true, true);
		baseShader.color.set(obj.color.r, obj.color.g, obj.color.b, obj.color.a * globalAlpha);
		baseShader.absoluteMatrixA.set(tile.width * obj.matA, tile.height * obj.matC, obj.absX + tile.dx * obj.matA + tile.dy * obj.matC);
		baseShader.absoluteMatrixB.set(tile.width * obj.matB, tile.height * obj.matD, obj.absY + tile.dx * obj.matB + tile.dy * obj.matD);
		baseShader.uvPos.set(tile.u, tile.v, tile.u2 - tile.u, tile.v2 - tile.v);
		beforeDraw();
		if( fixedBuffer == null || fixedBuffer.isDisposed() ) {
			fixedBuffer = new h3d.Buffer(4, 8, [Quads, RawFormat]);
			var k = new hxd.FloatBuffer();
			for( v in [0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] )
				k.push(v);
			fixedBuffer.uploadVector(k, 0, 4);
		}
		engine.renderQuadBuffer(fixedBuffer);
	}

	@:access(h2d.Drawable)
	function beginDraw(	obj : h2d.Drawable, texture : h3d.mat.Texture, isRelative : Bool, hasUVPos = false ) {
		var stride = 8;
		if( hasBuffering() && currentObj != null && (texture != this.texture || stride != this.stride || obj.blendMode != currentObj.blendMode || obj.filter != currentObj.filter) )
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
		if( objShaders != null || curShaders != null || baseShader.isRelative != isRelative || baseShader.hasUVPos != hasUVPos )
			shaderChanged = true;
		if( shaderChanged ) {
			flush();
			baseShader.hasUVPos = hasUVPos;
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