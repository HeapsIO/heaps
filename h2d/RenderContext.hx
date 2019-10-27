package h2d;

typedef CameraStackEntry = {
	va : Float, vb : Float, vc : Float, vd : Float, vx : Float, vy : Float
};
typedef TargetStackEntry = CameraStackEntry & {
	t : h3d.mat.Texture, hasRZ : Bool, rzX:Float, rzY:Float, rzW:Float, rzH:Float
};

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
	var targetsStack : Array<TargetStackEntry>;
	var targetsStackIndex : Int;
	var cameraStack : Array<CameraStackEntry>;
	var cameraStackIndex : Int;
	var curTarget : h3d.mat.Texture;
	var hasUVPos : Bool;
	var filterStack : Array<h2d.Object>;
	var inFilter : Object;
	var inFilterBlend : BlendMode;

	var viewA : Float;
	var viewB : Float;
	var viewC : Float;
	var viewD : Float;
	var viewX : Float;
	var viewY : Float;

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
		cameraStack = [];
		cameraStackIndex = 0;
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
		viewA = scene.viewportA;
		viewB = 0;
		viewC = 0;
		viewD = scene.viewportD;
		viewX = scene.viewportX;
		viewY = scene.viewportY;

		targetFlipY = engine.driver.hasFeature(BottomLeftCoords) ? -1 : 1;
		baseFlipY = engine.getCurrentTarget() != null ? targetFlipY : 1;
		inFilter = null;
		manager.globals.set("time", time);
		// todo : we might prefer to auto-detect this by running a test and capturing its output
		baseShader.pixelAlign = #if flash true #else false #end;
		baseShader.halfPixelInverse.set(0.5 / engine.width, 0.5 / engine.height);
		baseShader.viewportA.set(scene.viewportA, 0, scene.viewportX);
		baseShader.viewportB.set(0, scene.viewportD * -baseFlipY, scene.viewportY * -baseFlipY);
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

	@:access(h2d.Camera)
	public function setCamera( cam : h2d.Camera ) {
		if (cameraStackIndex == cameraStack.length) {
			cameraStack.push({
				va: viewA, vb: viewB,
				vc: viewC, vd: viewD,
				vx: viewX, vy: viewY
			});
		} else {
			var inf = cameraStack[cameraStackIndex];
			inf.va = viewA;
			inf.vb = viewB;
			inf.vc = viewC;
			inf.vd = viewD;
			inf.vx = viewX;
			inf.vy = viewY;
		}
		cameraStackIndex++;
		var tmpA = viewA;
		var tmpB = viewB;
		var tmpC = viewC;
		var tmpD = viewD;
		viewA = cam.matA * tmpA + cam.matB * tmpC;
		viewB = cam.matA * tmpB + cam.matB * tmpD;
		viewC = cam.matC * tmpA + cam.matD * tmpC;
		viewD = cam.matC * tmpB + cam.matD * tmpD;
		viewX = cam.absX * tmpA + cam.absY * tmpC + viewX;
		viewY = cam.absX * tmpB + cam.absY * tmpD + viewY;
		var flipY = curTarget != null ? -targetFlipY : -baseFlipY;
		baseShader.viewportA.set(viewA, viewC, viewX);
		baseShader.viewportB.set(viewB * flipY, viewD * flipY, viewY * flipY);
	}

	public function resetCamera() {
		if (cameraStackIndex == 0) throw "Too many resetCamera()";
		var inf = cameraStack[--cameraStackIndex];
		viewA = inf.va;
		viewB = inf.vb;
		viewC = inf.vc;
		viewD = inf.vd;
		viewX = inf.vx;
		viewY = inf.vy;
		var flipY = curTarget != null ? -targetFlipY : -baseFlipY;
		baseShader.viewportA.set(viewA, viewC, viewX);
		baseShader.viewportB.set(viewB * flipY, viewD * flipY, viewY * flipY);
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

		targetsStackIndex++;
		if ( targetsStackIndex > targetsStack.length ) {
			targetsStack.push( {
				t: curTarget,
				va: viewA, vb: viewB,
				vc: viewC, vd: viewD,
				vx: viewX, vy: viewY,
				hasRZ: hasRenderZone,
				rzX: renderX, rzY: renderY,
				rzW: renderW, rzH: renderH
			} );
		} else {
			var o = targetsStack[targetsStackIndex - 1];
			o.t = curTarget;
			o.va = viewA;
			o.vb = viewB;
			o.vc = viewC;
			o.vd = viewD;
			o.vx = viewX;
			o.vy = viewY;
			o.hasRZ = hasRenderZone;
			o.rzX = renderX;
			o.rzY = renderY;
			o.rzW = renderW;
			o.rzH = renderH;
		}

		if( width < 0 ) width = t == null ? scene.width : t.width;
		if( height < 0 ) height = t == null ? scene.height : t.height;

		viewA = 2 / width;
		viewB = 0;
		viewC = 0;
		viewD = 2 / height;
		viewX = -1 - startX * viewA;
		viewY = -1 - startY * viewD;

		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewportA.set(viewA, viewC, viewX);
		baseShader.viewportB.set(viewB * -targetFlipY, viewD * -targetFlipY, viewY * -targetFlipY);
		curTarget = t;
		currentBlend = null;
		if( hasRenderZone ) clearRenderZone();
	}

	public function popTarget() {
		flush();
		if( targetsStackIndex <= 0 ) throw "Too many popTarget()";
		engine.popTarget();

		var tinf = targetsStack[--targetsStackIndex];
		var t : h3d.mat.Texture = curTarget = tinf.t;
		viewA = tinf.va;
		viewB = tinf.vb;
		viewC = tinf.vc;
		viewD = tinf.vd;
		viewX = tinf.vx;
		viewY = tinf.vy;
		var flipY = t == null ? -baseFlipY : -targetFlipY;

		initShaders(baseShaderList);
		baseShader.halfPixelInverse.set(0.5 / (t == null ? engine.width : t.width), 0.5 / (t == null ? engine.height : t.height));
		baseShader.viewportA.set(viewA, viewC, viewX);
		baseShader.viewportB.set(viewB * flipY, viewD * flipY, viewY * flipY);

		if ( tinf.hasRZ ) setRenderZone(tinf.rzX, tinf.rzY, tinf.rzW, tinf.rzH);
	}

	public function setRenderZone( x : Float, y : Float, w : Float, h : Float ) {
		hasRenderZone = true;
		renderX = x;
		renderY = y;
		renderW = w;
		renderH = h;
		var scaleX = scene.viewportA * engine.width / 2;
		var scaleY = scene.viewportD * engine.height / 2;
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
		
		engine.setRenderZone(
			Std.int(x * scaleX + (scene.viewportX+1) * (engine.width / 2) + 1e-10),
			Std.int(y * scaleY + (scene.viewportY+1) * (engine.height / 2) + 1e-10),
			Std.int(w * scaleX + 1e-10),
			Std.int(h * scaleY + 1e-10)
		);
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
			var tmpA = obj.matA * f1.x + obj.matB * f1.y;
			var tmpB = obj.matA * f2.x + obj.matB * f2.y;
			var tmpC = obj.matC * f1.x + obj.matD * f1.y;
			var tmpD = obj.matC * f2.x + obj.matD * f2.y;
			var tmpX = obj.absX * f1.x + obj.absY * f1.y + f1.z;
			var tmpY = obj.absX * f2.x + obj.absY * f2.y + f2.z;
			matA = tmpA * viewA + tmpB * viewC;
			matB = tmpA * viewB + tmpB * viewD;
			matC = tmpC * viewA + tmpD * viewC;
			matD = tmpC * viewB + tmpD * viewD;
			absX = tmpX * viewA + tmpY * viewC + viewX;
			absY = tmpX * viewB + tmpY * viewD + viewY;
		} else {
			matA = obj.matA * viewA + obj.matB * viewC;
			matB = obj.matA * viewB + obj.matB * viewD;
			matC = obj.matC * viewA + obj.matD * viewC;
			matD = obj.matC * viewB + obj.matD * viewD;
			absX = obj.absX * viewA + obj.absY * viewC + viewX;
			absY = obj.absX * viewB + obj.absY * viewD + viewY;
		}

		// check if our tile is outside of the viewport
		if( matB == 0 && matC == 0 ) {
			var tx = tile.dx + tile.width * 0.5;
			var ty = tile.dy + tile.height * 0.5;
			var tr = (tile.width > tile.height ? tile.width : tile.height) * 1.5 * hxd.Math.max(hxd.Math.abs(matA),hxd.Math.abs(matD));
			var cx = absX + tx * matA;
			var cy = absY + ty * matD;
			if ( cx + tr < -1 || cx - tr > 1 || cy + tr < -1 || cy - tr > 1) return false;
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
			if (absX + xMax < -1 || absY + yMax < -1 || absX + xMin > 1 || absY + yMin > 1)
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