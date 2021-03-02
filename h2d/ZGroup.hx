package h2d;

@:access(h2d.RenderContext)
private class State {
	public var depthWrite  : Bool;
	public var depthTest   : h3d.mat.Data.Compare;
	public var front2back  : Bool;
	public var killAlpha   : Bool;
	public var onBeginDraw : h2d.Drawable->Bool;

	public function new() { }

	public function loadFrom( ctx : RenderContext ) {
		depthWrite  = ctx.pass.depthWrite;
		depthTest   = ctx.pass.depthTest;
		front2back  = ctx.front2back;
		killAlpha   = ctx.killAlpha;
		onBeginDraw = ctx.onBeginDraw;
	}

	public function applyTo( ctx : RenderContext ) {
		ctx.pass.depth(depthWrite, depthTest);
		ctx.front2back  = front2back;
		ctx.killAlpha   = killAlpha;
		ctx.onBeginDraw = onBeginDraw;
	}
}

private class DepthEntry {
	public var spr   : Object;
	public var depth : Float;
	public var keep  : Bool;
	public var next  : DepthEntry;
	public function new() { }
}

@:dox(hide)
class DepthMap {
	var map      : Map<Object, DepthEntry>;
	var curIndex : Int;
	var free     : DepthEntry;
	var first    : DepthEntry;

	public function new() {
		map = new Map();
	}

	function push(spr : Object) {
		var e = map.get(spr);
		if (e == null) {
			if (free != null) {
				e = free;
				free = e.next;
			} else {
				e = new DepthEntry();
			}
			e.next = first;
			first = e;
			map.set(spr, e);
		}

		e.spr   = spr;
		e.keep  = true;
		e.depth = curIndex++;
	}

	function populate(spr : Object) {
		for (c in spr) {
			if (!c.visible) continue;
			push(c);
			populate(c);
		}
	}

	public function build(spr : Object) {
		curIndex = 0;

		var e = first;
		while (e != null) {
			e.keep = false;
			e = e.next;
		}

		push(spr);
		populate(spr);

		var p = null;
		var e = first;
		while (e != null) {
			if (e.keep) {
				e.depth = 1 - e.depth / curIndex;
				p = e;
				e = e.next;
			} else {
				var next = e.next;
				map.remove(e.spr);
				e.spr = null;
				e.next = free;
				free = e;

				if (p == null) first = next;
				else p.next = next;
				e = next;
			}
		}
	}

	inline public function getDepth(spr : Object) {
		return map.get(spr).depth;
	}

	public function clear(){
		map = new Map();
		free = null;
		first = null;
	}
}

/**
	An advanced double-pass rendering class that utilizes a z-culling on an opaque objects.

	For optimization to work properly, all opaque objects should have `Object.blendMode` set to `None`.

	Rendering is done in two passes:
	* An opaque pass only renders objects with `blendeMode = None`, with `RenderContext.front2back` and `RenderContext.killAlpha` enabled.
	* Transparent pass renders the rest of the objects (which are not marked as opaque) as usual.

	That allows to perform a z-cull depth test on the objects and reduce the overall GPU strain.

	Additionally, ZGroup places a limitation on filter usage. They are not drawn in opaque pass, which can lead to undefined behavior.
**/
@:access(h2d.RenderContext)
class ZGroup extends Layers
{
	var depthMap : DepthMap;
	var ctx : RenderContext;

	var normalState : State;
	var transpState : State;
	var opaqueState : State;
	var onEnterFilterCached : Object -> Bool;
	var onLeaveFilterCached : Object -> Void;

	/**
		Create a new ZGroup instance/
		@param parent An optional parent `h2d.Object` instance to which ZGroup adds itself if set.
	**/
	public function new(?parent) {
		super(parent);

		depthMap = new DepthMap();

		opaqueState = new State();
		opaqueState.depthWrite  = true;
		opaqueState.depthTest   = LessEqual;
		opaqueState.front2back  = true;
		opaqueState.killAlpha   = true;
		opaqueState.onBeginDraw = onBeginOpaqueDraw;

		transpState = new State();
		transpState.depthWrite  = true;
		transpState.depthTest   = LessEqual;
		transpState.front2back  = false;
		transpState.killAlpha   = false;
		transpState.onBeginDraw = onBeginTranspDraw;

		normalState = new State();
		onEnterFilterCached = onEnterFilter;
		onLeaveFilterCached = onLeaveFilter;
	}

	override function drawRec(ctx:RenderContext) {
		if( !visible ) return;

		this.ctx = ctx;

		depthMap.build(this);
		ctx.engine.clear(null, 1);

		var oldOnEnterFilter = ctx.onEnterFilter;
		var oldOnLeaveFilter = ctx.onLeaveFilter;
		normalState.loadFrom(ctx);

		ctx.onEnterFilter = onEnterFilterCached;
		ctx.onLeaveFilter = onLeaveFilterCached;

		opaqueState.applyTo(ctx);
		super.drawRec(ctx);

		transpState.applyTo(ctx);
		super.drawRec(ctx);

		normalState.applyTo(ctx);
		ctx.onEnterFilter = oldOnEnterFilter;
		ctx.onLeaveFilter = oldOnLeaveFilter;
	}

	function onBeginOpaqueDraw(obj : h2d.Drawable) : Bool {
		if (obj.blendMode != None) return false;
		ctx.baseShader.zValue = depthMap.getDepth(obj);
		return true;
	}

	function onBeginTranspDraw(obj : h2d.Drawable) : Bool {
		if (obj.blendMode == None) return false;
		ctx.baseShader.zValue = depthMap.getDepth(obj);
		return true;
	}

	function onEnterFilter(spr : Object) {
		if (ctx.front2back) return false; // opaque pass : do not render the filter
		normalState.applyTo(ctx);
		return true;
	}

	function onLeaveFilter(spr : Object) {
		transpState.applyTo(ctx);
	}
}