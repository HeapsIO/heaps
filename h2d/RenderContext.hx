package h2d;

private typedef CameraStackEntry = {
	va : Float, vb : Float, vc : Float, vd : Float, vx : Float, vy : Float
};
private typedef TargetStackEntry = CameraStackEntry & {
	t : h3d.mat.Texture, hasRZ : Bool, rzX:Float, rzY:Float, rzW:Float, rzH:Float
};

private typedef RenderZoneStack = { hasRZ:Bool, x:Float, y:Float, w:Float, h:Float };

/**
	A 2D scene renderer.

	Passed during `Object.sync` and `Object.drawRec` and can be accessed directly via `Scene.renderer`.
**/
@:access(h2d.Scene)
class RenderContext extends h3d.impl.RenderContext {

	static inline var BUFFERING = #if heaps_emit_tile_buffering true #else false #end;

	/**
		Current transparency value used for rendering objects.
		Automatically managed by `Object`.
	**/
	public var globalAlpha = 1.;
	/**
		Temporary vertex buffer used to emit Tiles when `RenderContext.BUFFERING` is on.
		Otherwise it's `null`. Internal usage only.
	**/
	@:dox(hide)
	public var buffer : hxd.FloatBuffer;
	/**
		Current temporary buffer position. Internal usage only.
	**/
	@:dox(hide)
	public var bufPos : Int;
	/**
		The 2D scene attached to this RenderContext instance.
	**/
	public var scene : h2d.Scene;
	/**
		<span class="label">Internal usage</span>

		Determines texture filtering method (Linear or Nearest).
		Not recommended to use - assign `Scene.defaultSmooth` instead.
	**/
	public var defaultSmooth : Bool = false;
	/**
		When enabled, pixels with alpha value below 0.001 will be discarded.
	**/
	public var killAlpha : Bool;
	/**
		When enabled, causes `Object` to render its children in reverse order.
	**/
	public var front2back : Bool;

	/**
		Sent before Drawable is rendered.
		Drawable won't be rendered if callback returns `false`.
	**/
	public var onBeginDraw : h2d.Drawable->Bool;
	/**
		Sent before filter begins rendering.
		Filter (and it's object tree) won't be rendered if callback returns `false`.
	**/
	public var onEnterFilter : h2d.Object->Bool;
	/**
		Send after filter has been rendered.
	**/
	public var onLeaveFilter : h2d.Object->Void;

	/**
		<span class="label">Internal usage</span>

		Used to calculate filter rendering bounds.
	**/
	@:dox(hide)
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
	var renderZoneStack:Array<RenderZoneStack> = [];
	var renderZoneIndex:Int = 0;
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

	/**
		Create a new RenderContext and attach it to specified Scene.
		@param scene The scene which RenderContext will render.
	**/
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

	/**
		Tells if tile buffering is enabled.
	**/
	@:dox(hide)
	public inline function hasBuffering() {
		return BUFFERING;
	}

	/**
		<span class="label">Internal usage</span>

		Prepares RenderContext to begin rendering a new frame.
	**/
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
		manager.globals.set("global.time", time);
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

	/**
		Allocated a cached render target Texture with specified name, filter mode and current `Scene.width` and `Scene.height`.
		@returns Either precached Texture under same name or newly allocated one.
	**/
	public function allocTarget(name, filter = false) {
		var t = textures.allocTarget(name, scene.width, scene.height, false);
		t.filter = filter ? Linear : Nearest;
		return t;
	}

	/**
		Clears current render target with specified color.
	**/
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

	/**
		<span class="label">Internal usage</span>

		Performers cleanup after frame is rendered.
	**/
	public function end() {
		flush();
		texture = null;
		currentObj = null;
		baseShaderList.next = null;
		if ( targetsStackIndex != 0 ) throw "Missing popTarget()";
		if ( cameraStackIndex != 0 ) throw "Missing popCamera()";
	}

	/**
		<span class="label">Internal usage</span>

		Applies Camera `cam` transform to current viewport and pushes it onto the camera stack.
		Should call `RenderContext.popCamera` when rendering is complete.
	**/
	@:access(h2d.Camera)
	public function pushCamera( cam : h2d.Camera ) {
		var entry = cameraStack[cameraStackIndex++];
		if ( entry == null ) {
			entry = { va: 0, vb: 0, vc: 0, vd: 0, vx: 0, vy: 0 };
			cameraStack.push(entry);
		}
		var tmpA = viewA;
		var tmpB = viewB;
		var tmpC = viewC;
		var tmpD = viewD;

		entry.va = tmpA;
		entry.vb = tmpB;
		entry.vc = tmpC;
		entry.vd = tmpD;
		entry.vx = viewX;
		entry.vy = viewY;

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

	/**
		<span class="label">Internal usage</span>

		Restores previous viewport state prior to camera rendering, removing it from the camera stack.
	**/
	public function popCamera() {
		if (cameraStackIndex == 0) throw "Too many popCamera()";
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

	/**
		<span class="label">Internal usage</span>

		Prepares to render Filter and pushes provided Object onto filter stack.

		@returns true if filter is allowed to render, false otherwise (see `RenderContext.onEnterFilter`)
	**/
	public function pushFilter( spr : h2d.Object ) {
		if( filterStack.length == 0 && onEnterFilter != null )
			if( !onEnterFilter(spr) ) return false;
		filterStack.push(spr);
		inFilter = spr;
		return true;
	}

	/**
		<span class="label">Internal usage</span>

		Finalizes Filter rendering and removes top-most Object from filter stack.
	**/
	public function popFilter() {
		var spr = filterStack.pop();
		if( filterStack.length > 0 ) {
			inFilter = filterStack[filterStack.length - 1];
		} else {
			inFilter = null;
			if( onLeaveFilter != null ) onLeaveFilter(spr);
		}
	}

	/**
		Sets provided texture as a render target and pushes it onto target stack.
		If only part of the Texture should be rendered onto, method should be used with `pushRenderZone()` to avoid rendering outside specified texture area.

		@param t Texture to which RenderContext will render to. Texture should be allocated as a render target (have `Target` flag).
		@param startX X offset of rendering area on the Texture.
		@param startY Y offset of rendering area on the Texture.
		@param width Width of the clipping area on the Texture. If equals to `-1`, will use texture width.
		@param height Height of the clipping area on the Texture. If equals to `-1` will use texture height.
	**/
	public function pushTarget( t : h3d.mat.Texture, startX = 0, startY = 0, width = -1, height = -1 ) {
		flush();
		engine.pushTarget(t);
		initShaders(baseShaderList);

		var entry = targetsStack[targetsStackIndex++];
		if ( entry == null ) {
			entry = { t: null, va: 0, vb: 0, vc: 0, vd: 0, vx: 0, vy: 0, hasRZ: false, rzX: 0, rzY: 0, rzW: 0, rzH: 0 };
			targetsStack.push(entry);
		}
		entry.t = curTarget;
		entry.va = viewA;
		entry.vb = viewB;
		entry.vc = viewC;
		entry.vd = viewD;
		entry.vx = viewX;
		entry.vy = viewY;
		entry.hasRZ = hasRenderZone;
		entry.rzX = renderX;
		entry.rzY = renderY;
		entry.rzW = renderW;
		entry.rzH = renderH;

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
		if( hasRenderZone ) clearRZ();
	}

	/**
		Pushes an array of render targets onto target stack.
	**/
	public function pushTargets( texs : Array<h3d.mat.Texture> ) {
		pushTarget(texs[0]);
		if( texs.length > 1 ) {
			engine.popTarget();
			engine.pushTargets(texs);
		}
	}

	/**
		Pops current render target from the target stack.
		If last texture was removed from the stack, will restore the primary render buffer as a render target.
	**/
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

		if ( tinf.hasRZ ) setRZ(tinf.rzX, tinf.rzY, tinf.rzW, tinf.rzH);
	}

	/**
		Sets rectangular render zone area, saving previous render zone settings.
		To respect previous render zone area, use `RenderContext.clipRenderZone` method.

		`RenderContext.popRenderZone` should be called afterwards to clear render zone stack.
	**/
	public function pushRenderZone( x : Float, y : Float, w : Float, h : Float ) {
		var inf = renderZoneStack[renderZoneIndex++];
		if ( inf == null ) {
			inf = { hasRZ: hasRenderZone, x: renderX, y: renderY, w: renderW, h: renderH };
			renderZoneStack[renderZoneIndex - 1] = inf;
		} else if ( hasRenderZone ) {
			inf.hasRZ = true;
			inf.x = renderX;
			inf.y = renderY;
			inf.w = renderW;
			inf.h = renderH;
		} else {
			inf.hasRZ = false;
		}

		setRZ(x, y, w, h);
	}

	/**
		Restores previous render zone settings.
	**/
	public function popRenderZone() {
		if (renderZoneIndex == 0) throw "Too many popRenderZone()";
		var inf = renderZoneStack[--renderZoneIndex];
		if (inf.hasRZ) {
			setRZ(inf.x, inf.y, inf.w, inf.h);
		} else {
			clearRZ();
		}
	}

	public function getCurrentRenderZone() {
		if( !hasRenderZone )
			return null;
		return h2d.col.Bounds.fromValues(renderX, renderY, renderW, renderH);
	}

	/**
		Pushes new render zone with respect to the old render zone settings by clipping new and old render zones,
		pushing the intersection area result.
		Used so that any call to the clipRenderZone respects the already set zone, and can't render outside of it.
	**/
	public function clipRenderZone( x : Float, y : Float, w : Float, h : Float ) {
		if (!hasRenderZone) {
			pushRenderZone( x, y, w, h );
			return;
		}

		x = Math.max( x, renderX );
		y = Math.max( y, renderY );
		var x2 = Math.min( x + w, renderX + renderW );
		var y2 = Math.min( y + h, renderY + renderH );
		if (x2 < x) x2 = x;
		if (y2 < y) y2 = y;

		pushRenderZone( x, y, x2 - x, y2 - y );
	}

	function setRZ( x : Float, y : Float, w : Float, h : Float ) {
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

	inline function clearRZ() {
		hasRenderZone = false;
		engine.setRenderZone();
	}

	@:dox(hide) @:noCompletion @:deprecated("Use pushRenderZone")
	public inline function setRenderZone( x : Float, y : Float, w : Float, h : Float ) {
		pushRenderZone(x, y, w, h);
	}

	@:dox(hide) @:noCompletion @:deprecated("Use popRenderZone")
	public inline function clearRenderZone() {
		popRenderZone();
	}

	function drawLayer( layer : Int ) {
		@:privateAccess scene.drawLayer(this, layer);
	}

	/**
		Renders the assigned Scene. Same as `s2d.drawRec(s2d.renderer)`.
	**/
	public function drawScene() {
		@:privateAccess scene.drawRec(this);
	}

	/**
		Flushes buffered tile data if one present.
	**/
	@:dox(hide)
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

	/**
		<span class="label">Internal usage</span>

		Should be called before performing a new draw call in order to sync shader data and other parameters.
	**/
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
			// accumulate correctly alpha values
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
		if( inFilter == obj ) {
			baseShader.color.set(obj.color.r,obj.color.g,obj.color.b,obj.color.a);
		}
		else if( inFilterBlend != null ) {
			baseShader.color.set(globalAlpha,globalAlpha,globalAlpha,globalAlpha);
		} else
			baseShader.color.set(obj.color.r, obj.color.g, obj.color.b, obj.color.a * globalAlpha);
	}

	// BatchState render
	/**
		Prepares rendering with BatchState.
		Each state draw should be preceded with `swapTexture` call.
	**/
	@:access(h2d.Drawable)
	public function beginDrawBatchState( obj : h2d.Drawable ) {
		if ( !beginDraw(obj, null, true) ) return false;
		setupColor(obj);
		baseShader.absoluteMatrixA.set(obj.matA, obj.matC, obj.absX);
		baseShader.absoluteMatrixB.set(obj.matB, obj.matD, obj.absY);
		return true;
	}

	/**
		Swap current active texture and prepares for next drawcall.
	**/
	public inline function swapTexture( texture : h3d.mat.Texture ) {
		this.texture = texture;
		beforeDraw();
	}

	/**
		Prepares rendering of the Drawable object with specified texture.
		@returns true if rendering is prepared, false otherwise (see `RenderContext.onBeginDraw`)
	**/
	@:access(h2d.Drawable)
	public function beginDrawObject( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		if ( !beginDraw(obj, texture, true) ) return false;
		setupColor(obj);
		baseShader.absoluteMatrixA.set(obj.matA, obj.matC, obj.absX);
		baseShader.absoluteMatrixB.set(obj.matB, obj.matD, obj.absY);
		beforeDraw();
		return true;
	}

	/**
		Begins buffered Tile render of the Drawable object.
		@returns true if rendering is prepared, false otherwise (see `RenderContext.onBeginDraw`)
	**/
	@:dox(hide)
	@:access(h2d.Drawable)
	public function beginDrawBatch( obj : h2d.Drawable, texture : h3d.mat.Texture ) {
		return beginDraw(obj, texture, false);
	}

	/**
		Renders a Tile with the transform of the given Drawable.

		@returns `true` if tile was drawn, `false` otherwise.
		Tile is not drawn if it's either outside of the rendering area or was cancelled by `RenderContext.onBeginDraw`.
	**/
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
