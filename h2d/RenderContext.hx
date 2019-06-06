package h2d;

class RenderContext extends h3d.impl.RenderContext {

	static inline var BUFFERING = false;

	public var globalAlpha = 1.;
	public var buffer : hxd.FloatBuffer;
	public var bufPos : Int;
	public var scene : h2d.Scene;
	public var defaultSmooth : Bool = false;
	public var killAlpha : Bool;
	public var front2back : Bool;

	public var onBeginDraw : h2d.Drawable->Bool; // return false to cancel drawing
	public var onEnterFilter : h2d.Object->Bool;
	public var onLeaveFilter : h2d.Object->Void;

	public var tmpBounds = new h2d.col.Bounds();
	var texture : h3d.mat.Texture;
	var baseShader : h3d.shader.Base2d;
	var manager : h3d.pass.ShaderManager;
	var compiledShader : hxsl.RuntimeShader;
	var buffers : h3d.shader.Buffers;
	var fixedBuffer : h3d.Buffer;
	var pass : h3d.mat.Pass;
	var currentShaders : hxsl.ShaderList;
	var baseShaderList : hxsl.ShaderList;
	var currentObj : Drawable;
	var stride : Int;
	var targetsStack : Array<{ t : h3d.mat.Texture, x : Int, y : Int, w : Int, h : Int, hasRZ : Bool, rzX:Float, rzY:Float, rzW:Float, rzH:Float }>;
	var targetsStackIndex : Int;
	var hasUVPos : Bool;
	var filterStack : Array<h2d.Object>;
	var inFilter : Object;
	var inFilterBlend : BlendMode;

	var curX : Int;
	var curY : Int;
	var curWidth : Int;
	var curHeight : Int;

	var hasRenderZone : Bool;
	var renderX : Float;
	var renderY : Float;
	var renderW : Float;
	var renderH : Float;
	var currentBlend : BlendMode;
	var baseFlipY : Float;
	var targetFlipY : Float;

	public function new(scene) {
		super();
		this.scene = scene;
		if( BUFFERING )
			buffer = new hxd.FloatBuffer();
		bufPos = 0;
		manager = new h3d.pass.ShaderManager();
		pass = new h3d.mat.Pass("",null);
		pass.depth(true, Always);
		pass.culling = None;
		baseShader = new h3d.shader.Base2d();
		baseShader.setPriority(100);
		baseShader.zValue = 0.;
		baseShaderList = new hxsl.ShaderList(baseShader);
		targetsStack = [];
		targetsStackIndex = 0;
		filterStack = [];
	}

	override function dispose() {
		super.dispose();
		if( fixedBuffer != null ) fixedBuffer.dispose();
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
		targetFlipY = engine.driver.hasFeature(BottomLeftCoords) ? -1 : 1;
		baseFlipY = engine.getCurrentTarget() != null ? targetFlipY : 1;
		inFilter = null;
		curWidth = scene.width;
		curHeight = scene.height;
		manager.globals.set("time", time);
		// todo : we might prefer to auto-detect this by running a test and capturing its output
		baseShader.pixelAlign = #if flash true #else false #end;
		baseShader.halfPixelInverse.set(0.5 / engine.width, 0.5 / engine.height);
		baseShader.viewport.set( -scene.width * 0.5 - scene.offsetX, -scene.height * 0.5 - scene.offsetY, 2 / scene.width * scene.ratioX, -2 * baseFlipY / scene.height * scene.ratioY);
		baseShader.filterMatrixA.set(1, 0, 0);
		baseShader.filterMatrixB.set(0, 1, 0);
		baseShaderList.next = null;
		initShaders(baseShaderList);
		engine.selectMaterial(pass);
		textures.begin();
	}

	public function allocTarget(name, filter = false) {
		var t = textures.allocTarget(name, scene.width, scene.height, false);
		t.filter = filter ? Linear : Nearest;
		return t;
	}

	public function clear(color) {
		engine.clear(color);
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
		if( targetsStackIndex != 0 ) throw "Missing popTarget()";
	}

	public function pushFilter( spr : h2d.Object ) {
		if( filterStack.length == 0 && onEnterFilter != null )
			if( !onEnterFilter(spr) ) return false;
		filterStack.push(spr);
		inFilter = spr;
		return true;
	}

	public function popFilter() {
		var spr = filterStack.pop();
		if( filterStack.length > 0 ) {
			inFilter = filterStack[filterStack.length - 1];
		} else {
			inFilter = null;
			if( onLeaveFilter != null ) onLeaveFilter(spr);
		}
	}

	public function pushTarget( t : h3d.mat.Texture, startX = 0, startY = 0, width = -1, height = -1 ) {
		flush();
		engine.pushTarget(t);
		initShaders(baseShaderList);
		if( width < 0 ) width = t == null ? scene.width : t.width;
		if( height < 0 ) height = t == null ? scene.height : t.height;
		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewport.set( -width * 0.5 - startX, -height * 0.5 - startY, 2 / width, -2 * targetFlipY / height);
		targetsStackIndex++;
		if( targetsStackIndex > targetsStack.length ){
			targetsStack.push( { t : t, x : startX, y : startY, w : width, h : height, hasRZ: hasRenderZone, rzX: renderX, rzY:renderY, rzW:renderW, rzH:renderH } );
		}else{
			var o = targetsStack[targetsStackIndex-1];
			o.t = t;
			o.x = startX;
			o.y = startY;
			o.w = width;
			o.h = height;
			o.hasRZ = hasRenderZone;
			o.rzX = renderX;
			o.rzY = renderY;
			o.rzW = renderW;
			o.rzH = renderH;
		}
		curX = startX;
		curY = startY;
		curWidth = width;
		curHeight = height;
		currentBlend = null;
		if( hasRenderZone ) clearRenderZone();
	}

	public function popTarget( restore = true ) {
		flush();
		if( targetsStackIndex <= 0 ) throw "Too many popTarget()";
		var pinf = targetsStack[--targetsStackIndex];
		engine.popTarget();

		if( restore ) {
			var tinf = targetsStack[targetsStackIndex - 1];
			var t : h3d.mat.Texture;
			var startX : Int, startY : Int, width : Int, height : Int;
			var ratioX : Float, ratioY : Float, offsetX : Float, offsetY : Float;
			if ( tinf == null ) {
				t = null;
				startX = 0;
				startY = 0;
				width = scene.width;
				height = scene.height;
				ratioX = scene.ratioX;
				ratioY = scene.ratioY;
				offsetX = scene.offsetX;
				offsetY = scene.offsetY;
			} else {
				t = tinf.t;
				startX = tinf.x;
				startY = tinf.y;
				width = tinf.w;
				height = tinf.h;
				ratioX = 1;
				ratioY = 1;
				offsetX = 0;
				offsetY = 0;
			}
			initShaders(baseShaderList);
			baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
			baseShader.viewport.set( -width * 0.5 - startX - offsetX, -height * 0.5 - startY - offsetY, 2 / width * ratioX, -2 * (t == null ? baseFlipY : targetFlipY) / height * ratioY);
			curX = startX;
			curY = startY;
			curWidth = width;
			curHeight = height;
		}

		if( pinf.hasRZ ) setRenderZone(pinf.rzX, pinf.rzY, pinf.rzW, pinf.rzH);
	}

	public function setRenderZone( x : Float, y : Float, w : Float, h : Float ) {
		hasRenderZone = true;
		renderX = x;
		renderY = y;
		renderW = w;
		renderH = h;
		var scaleX = engine.width * scene.ratioX / scene.width;
		var scaleY = engine.height * scene.ratioY / scene.height;
		if( inFilter != null ) {
			var fa = baseShader.filterMatrixA;
			var fb = baseShader.filterMatrixB;
			var x2 = x + w, y2 = y + h;
			var rx1 = x * fa.x + y * fa.y + fa.z;
			var ry1 = x * fb.x + y * fb.y + fb.z;
			var rx2 = x2 * fa.x + y2 * fa.y + fa.z;
			var ry2 = x2 * fb.x + y2 * fb.y + fb.z;
			x = rx1;
			y = ry1;
			w = rx2 - rx1;
			h = ry2 - ry1;
		}
		engine.setRenderZone(Std.int((x - curX + scene.viewportX) * scaleX + 1e-10), Std.int((y - curY + scene.viewportY) * scaleY + 1e-10), Std.int(w * scaleX + 1e-10), Std.int(h * scaleY + 1e-10));
	}

	public inline function clearRenderZone() {
		hasRenderZone = false;
		engine.setRenderZone();
	}

	function drawLayer( layer : Int ) {
		@:privateAccess scene.drawLayer(this, layer);
	}

	public function drawScene() {
		@:privateAccess scene.drawRec(this);
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
		texture.filter = (currentObj.smooth == null ? defaultSmooth : (currentObj.smooth:Bool)) ? Linear : Nearest;
		texture.wrap = currentObj.tileWrap && (currentObj.filter == null || inFilter != null) ? Repeat : Clamp;
		var blend = currentObj.blendMode;
		if( inFilter == currentObj && blend == Erase ) blend = Add; // add THEN erase
		if( inFilterBlend != null ) blend = inFilterBlend;
		if( blend != currentBlend ) {
			currentBlend = blend;
			pass.setBlendMode(blend);
			#if flash
			// flash does not allow blend separate operations
			// this will get us good color but wrong alpha
			#else
			// accummulate correctly alpha values
			if( blend == Alpha || blend == Add ) {
				pass.blendAlphaSrc = One;
				// when merging
				if( inFilterBlend != null )
					pass.blendSrc = One;
			}
			#end
		}
		manager.fillParams(buffers, compiledShader, currentShaders);
		engine.selectMaterial(pass);
		engine.uploadShaderBuffers(buffers, Params);
		engine.uploadShaderBuffers(buffers, Textures);
		engine.uploadShaderBuffers(buffers, Buffers);
	}

	inline function setupColor( obj : h2d.Drawable ) {
		if( inFilter == obj )
			baseShader.color.set(1,1,1,1);
		else if( inFilterBlend != null ) {
			// alpha premult
			var alpha = obj.color.a * globalAlpha;
			baseShader.color.set(obj.color.r * alpha, obj.color.g * alpha, obj.color.b * alpha, alpha);
		} else
			baseShader.color.set(obj.color.r, obj.color.g, obj.color.b, obj.color.a * globalAlpha);
	}

	@:access(h2d.Drawable)
	public function beginDrawObject( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		if ( !beginDraw(obj, texture, true) ) return false;
		setupColor(obj);
		baseShader.absoluteMatrixA.set(obj.matA, obj.matC, obj.absX);
		baseShader.absoluteMatrixB.set(obj.matB, obj.matD, obj.absY);
		beforeDraw();
		return true;
	}

	@:access(h2d.Drawable)
	public function beginDrawBatch( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		return beginDraw(obj, texture, false);
	}

	@:access(h2d.Drawable)
	public function drawTile( obj : h2d.Drawable, tile : h2d.Tile ) {
		var matA, matB, matC, matD, absX, absY;
		if( inFilter != null ) {
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
			if( cx < -tr || cy < -tr || cx - tr > curWidth || cy - tr > curHeight ) return false;
		} else {
			var xMin = 1e20, yMin = 1e20, xMax = -1e20, yMax = -1e20;
			inline function calc(x:Float, y:Float) {
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
				return false;
		}

		if( !beginDraw(obj, tile.getTexture(), true, true) ) return false;

		setupColor(obj);
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
		return true;
	}

	@:access(h2d.Drawable)
	function beginDraw(	obj : h2d.Drawable, texture : h3d.mat.Texture, isRelative : Bool, hasUVPos = false ) {
		if( onBeginDraw != null && !onBeginDraw(obj) )
			return false;

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
			var prevInst = @:privateAccess t.instance;
			if( s != t )
				paramsChanged = true;
			s.updateConstants(manager.globals);
			if( @:privateAccess s.instance != prevInst )
				shaderChanged = true;
		}
		if( objShaders != null || curShaders != null || baseShader.isRelative != isRelative || baseShader.hasUVPos != hasUVPos || baseShader.killAlpha != killAlpha )
			shaderChanged = true;
		if( shaderChanged ) {
			flush();
			baseShader.hasUVPos = hasUVPos;
			baseShader.isRelative = isRelative;
			baseShader.killAlpha = killAlpha;
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

		return true;
	}

}