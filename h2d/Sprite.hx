package h2d;
import hxd.Math;

@:allow(h2d.Tools)
class Sprite {

	static var nullDrawable : h2d.Drawable;

	var childs : Array<Sprite>;
	public var parent(default, null) : Sprite;
	public var numChildren(get, never) : Int;

	public var x(default,set) : Float;
	public var y(default, set) : Float;
	public var scaleX(default,set) : Float;
	public var scaleY(default,set) : Float;
	public var rotation(default, set) : Float;
	public var visible : Bool;
	public var name : String;
	public var alpha : Float = 1.;

	public var filters : Array<h2d.filter.Filter>;

	var matA : Float;
	var matB : Float;
	var matC : Float;
	var matD : Float;
	var absX : Float;
	var absY : Float;

	var posChanged : Bool;
	var allocated : Bool;
	var lastFrame : Int;

	public function new( ?parent : Sprite ) {
		matA = 1; matB = 0; matC = 0; matD = 1; absX = 0; absY = 0;
		x = 0; y = 0; scaleX = 1; scaleY = 1; rotation = 0;
		posChanged = parent != null;
		visible = true;
		childs = [];
		filters = [];
		if( parent != null )
			parent.addChild(this);
	}

	public function getBounds( ?relativeTo : Sprite, ?out : h2d.col.Bounds ) : h2d.col.Bounds {
		if( out == null ) out = new h2d.col.Bounds();
		if( relativeTo != null )
			relativeTo.syncPos();
		if( relativeTo != this )
			syncPos();
		getBoundsRec(relativeTo, out);
		if( out.isEmpty() ) {
			addBounds(relativeTo, out, -1, -1, 2, 2);
			out.xMax = out.xMin = (out.xMax + out.xMin) * 0.5;
			out.yMax = out.yMin = (out.yMax + out.yMin) * 0.5;
		}
		return out;
	}

	function getBoundsRec( relativeTo : Sprite, out : h2d.col.Bounds ) {
		if( posChanged ) {
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
		}
		var n = childs.length;
		if( n == 0 ) {
			out.empty();
			return;
		}
		if( n == 1 ) {
			var c = childs[0];
			if( c.visible ) c.getBounds(relativeTo, out) else out.empty();
			return;
		}
		var xmin = hxd.Math.POSITIVE_INFINITY, ymin = hxd.Math.POSITIVE_INFINITY;
		var xmax = hxd.Math.NEGATIVE_INFINITY, ymax = hxd.Math.NEGATIVE_INFINITY;
		for( c in childs ) {
			if( !c.visible ) continue;
			c.getBoundsRec(relativeTo, out);
			if( out.xMin < xmin ) xmin = out.xMin;
			if( out.yMin < ymin ) ymin = out.yMin;
			if( out.xMax > xmax ) xmax = out.xMax;
			if( out.yMax > ymax ) ymax = out.yMax;
		}
		out.xMin = xmin;
		out.yMin = ymin;
		out.xMax = xmax;
		out.yMax = ymax;
	}

	function addBounds( relativeTo : Sprite, out : h2d.col.Bounds, dx : Float, dy : Float, width : Float, height : Float ) {

		if( width <= 0 || height <= 0 ) return;

		if( relativeTo == null  ) {
			var x, y;
			out.addPos(dx * matA + dy * matC + absX, dx * matB + dy * matD + absY);
			out.addPos((dx + width) * matA + dy * matC + absX, (dx + width) * matB + dy * matD + absY);
			out.addPos(dx * matA + (dy + height) * matC + absX, dx * matB + (dy + height) * matD + absY);
			out.addPos((dx + width) * matA + (dy + height) * matC + absX, (dx + width) * matB + (dy + height) * matD + absY);
			return;
		}

		if( relativeTo == this ) {
			if( out.xMin > dx ) out.xMin = dx;
			if( out.yMin > dy ) out.yMin = dy;
			if( out.xMax < dx + width ) out.xMax = dx + width;
			if( out.yMax < dy + height ) out.yMax = dy + height;
			return;
		}


		var det = 1 / (relativeTo.matA * relativeTo.matD - relativeTo.matB * relativeTo.matC);
		var rA = relativeTo.matD * det;
		var rB = -relativeTo.matB * det;
		var rC = -relativeTo.matC * det;
		var rD = relativeTo.matA * det;
		var rX = absX - relativeTo.absX;
		var rY = absY - relativeTo.absY;

		var x, y;

		x = dx * matA + dy * matC + rX;
		y = dx * matB + dy * matD + rY;
		out.addPos(x * rA + y * rC, x * rB + y * rD);

		x = (dx + width) * matA + dy * matC + rX;
		y = (dx + width) * matB + dy * matD + rY;
		out.addPos(x * rA + y * rC, x * rB + y * rD);

		x = dx * matA + (dy + height) * matC + rX;
		y = dx * matB + (dy + height) * matD + rY;
		out.addPos(x * rA + y * rC, x * rB + y * rD);

		x = (dx + width) * matA + (dy + height) * matC + rX;
		y = (dx + width) * matB + (dy + height) * matD + rY;
		out.addPos(x * rA + y * rC, x * rB + y * rD);
	}

	public function getSpritesCount() {
		var k = 0;
		for( c in childs )
			k += c.getSpritesCount() + 1;
		return k;
	}

	public function localToGlobal( ?pt : h2d.col.Point ) {
		syncPos();
		if( pt == null ) pt = new h2d.col.Point();
		var px = pt.x * matA + pt.y * matC + absX;
		var py = pt.x * matB + pt.y * matD + absY;
		pt.x = px;
		pt.y = py;
		return pt;
	}

	public function globalToLocal( pt : h2d.col.Point ) {
		syncPos();
		pt.x -= absX;
		pt.y -= absY;
		var invDet = 1 / (matA * matD - matB * matC);
		var px = (pt.x * matD - pt.y * matC) * invDet;
		var py = (-pt.x * matB + pt.y * matA) * invDet;
		pt.x = px;
		pt.y = py;
		return pt;
	}

	function getScene() {
		var p = this;
		while( p.parent != null ) p = p.parent;
		return Std.instance(p, Scene);
	}

	public function addChild( s : Sprite ) {
		addChildAt(s, childs.length);
	}

	public function addChildAt( s : Sprite, pos : Int ) {
		if( pos < 0 ) pos = 0;
		if( pos > childs.length ) pos = childs.length;
		var p = this;
		while( p != null ) {
			if( p == s ) throw "Recursive addChild";
			p = p.parent;
		}
		if( s.parent != null ) {
			// prevent calling onDelete
			var old = s.allocated;
			s.allocated = false;
			s.parent.removeChild(s);
			s.allocated = old;
		}
		childs.insert(pos, s);
		if( !allocated && s.allocated )
			s.onDelete();
		s.parent = this;
		s.posChanged = true;
		// ensure that proper alloc/delete is done if we change parent
		if( allocated ) {
			if( !s.allocated )
				s.onAlloc();
			else
				s.onParentChanged();
		}
	}

	// called when we're allocated already but moved in hierarchy
	function onParentChanged() {
	}

	// kept for internal init
	function onAlloc() {
		allocated = true;
		for( c in childs )
			c.onAlloc();
	}

	// kept for internal cleanup
	function onDelete() {
		allocated = false;
		for( c in childs )
			c.onDelete();
	}

	function getMatrix( m : h2d.col.Matrix ) {
		m.a = matA;
		m.b = matB;
		m.c = matC;
		m.d = matD;
		m.x = absX;
		m.y = absY;
	}

	public function removeChild( s : Sprite ) {
		if( childs.remove(s) ) {
			if( s.allocated ) s.onDelete();
			s.parent = null;
		}
	}

	// shortcut for parent.removeChild
	public inline function remove() {
		if( this != null && parent != null ) parent.removeChild(this);
	}

	public function drawTo( t : h3d.mat.Texture ) {
		var s = getScene();
		var needDispose = s == null;
		if( s == null ) s = new h2d.Scene();
		@:privateAccess s.drawImplTo(this, t);
		if( needDispose ) s.dispose();
	}

	function draw( ctx : RenderContext ) {
	}

	function sync( ctx : RenderContext ) {
		var changed = posChanged;
		if( changed ) {
			calcAbsPos();
			posChanged = false;
		}

		lastFrame = ctx.frame;
		var p = 0, len = childs.length;
		while( p < len ) {
			var c = childs[p];
			if( c == null )
				break;
			if( c.lastFrame != ctx.frame ) {
				if( changed ) c.posChanged = true;
				c.sync(ctx);
			}
			// if the object was removed, let's restart again.
			// our lastFrame ensure that no object will get synched twice
			if( childs[p] != c ) {
				p = 0;
				len = childs.length;
			} else
				p++;
		}
	}

	function syncPos() {
		if( parent != null ) parent.syncPos();
		if( posChanged ) {
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
		}
	}

	function calcAbsPos() {
		if( parent == null ) {
			var cr, sr;
			if( rotation == 0 ) {
				cr = 1.; sr = 0.;
				matA = scaleX;
				matB = 0;
				matC = 0;
				matD = scaleY;
			} else {
				cr = Math.cos(rotation);
				sr = Math.sin(rotation);
				matA = scaleX * cr;
				matB = scaleX * sr;
				matC = scaleY * -sr;
				matD = scaleY * cr;
			}
			absX = x;
			absY = y;
		} else {
			// M(rel) = S . R . T
			// M(abs) = M(rel) . P(abs)
			if( rotation == 0 ) {
				matA = scaleX * parent.matA;
				matB = scaleX * parent.matB;
				matC = scaleY * parent.matC;
				matD = scaleY * parent.matD;
			} else {
				var cr = Math.cos(rotation);
				var sr = Math.sin(rotation);
				var tmpA = scaleX * cr;
				var tmpB = scaleX * sr;
				var tmpC = scaleY * -sr;
				var tmpD = scaleY * cr;
				matA = tmpA * parent.matA + tmpB * parent.matC;
				matB = tmpA * parent.matB + tmpB * parent.matD;
				matC = tmpC * parent.matA + tmpD * parent.matC;
				matD = tmpC * parent.matB + tmpD * parent.matD;
			}
			absX = x * parent.matA + y * parent.matC + parent.absX;
			absY = x * parent.matB + y * parent.matD + parent.absY;
		}
	}

	function emitTile( ctx : RenderContext, tile : h2d.Tile ) {
		if( nullDrawable == null )
			nullDrawable = new h2d.Drawable(null);
		if( !ctx.hasBuffering() ) {
			nullDrawable.absX = absX;
			nullDrawable.absY = absY;
			nullDrawable.matA = matA;
			nullDrawable.matB = matB;
			nullDrawable.matC = matC;
			nullDrawable.matD = matD;
			ctx.drawTile(nullDrawable, tile);
			return;
		}
		ctx.beginDrawBatch(nullDrawable, tile.getTexture());

		var ax = absX + tile.dx * matA + tile.dy * matC;
		var ay = absY + tile.dx * matB + tile.dy * matD;
		var buf = ctx.buffer;
		var pos = ctx.bufPos;
		buf.grow(pos + 4 * 8);

		inline function emit(v:Float) buf[pos++] = v;

		emit(ax);
		emit(ay);
		emit(tile.u);
		emit(tile.v);
		emit(1.);
		emit(1.);
		emit(1.);
		emit(ctx.globalAlpha);


		var tw = tile.width;
		var th = tile.height;
		var dx1 = tw * matA;
		var dy1 = tw * matB;
		var dx2 = th * matC;
		var dy2 = th * matD;

		emit(ax + dx1);
		emit(ay + dy1);
		emit(tile.u2);
		emit(tile.v);
		emit(1.);
		emit(1.);
		emit(1.);
		emit(ctx.globalAlpha);

		emit(ax + dx2);
		emit(ay + dy2);
		emit(tile.u);
		emit(tile.v2);
		emit(1.);
		emit(1.);
		emit(1.);
		emit(ctx.globalAlpha);

		emit(ax + dx1 + dx2);
		emit(ay + dy1 + dy2);
		emit(tile.u2);
		emit(tile.v2);
		emit(1.);
		emit(1.);
		emit(1.);
		emit(ctx.globalAlpha);

		ctx.bufPos = pos;
	}

	/**
		Will clip a local bounds with our global viewport
	**/
	function clipBounds( ctx : RenderContext, bounds : h2d.col.Bounds ) {
		var view = ctx.tmpBounds;

		// intersect our transformed local view with our viewport in global space
		view.empty();
		inline function add(x:Float, y:Float) {
			view.addPos(x * matA + y * matC + absX, x * matB + y * matD + absY);
		}
		add(bounds.xMin, bounds.yMin);
		add(bounds.xMax, bounds.yMin);
		add(bounds.xMin, bounds.yMax);
		add(bounds.xMax, bounds.yMax);

		// clip with our scene
		if( view.xMin < 0 ) view.xMin = 0;
		if( view.yMin < 0 ) view.yMin = 0;
		@:privateAccess if( view.xMax > ctx.curWidth ) view.xMax = ctx.curWidth;
		@:privateAccess if( view.yMax > ctx.curHeight ) view.yMax = ctx.curHeight;

		// inverse our matrix
		var invDet = 1 / (matA * matD - matB * matC);
		inline function add(x:Float, y:Float) {
			x -= absX;
			y -= absY;
			view.addPos((x * matD - y * matC) * invDet, ( -x * matB + y * matA) * invDet);
		}

		// intersect our resulting viewport with our calculated local space
		var sxMin = view.xMin;
		var syMin = view.yMin;
		var sxMax = view.xMax;
		var syMax = view.yMax;
		view.empty();
		add(sxMin, syMin);
		add(sxMax, syMin);
		add(sxMin, syMax);
		add(sxMax, syMax);

		// intersects
		bounds.intersectWith(view);
	}

	function drawFilters( ctx : RenderContext ) {
		var bounds = ctx.tmpBounds;
		var total = new h2d.col.Bounds();
		var maxExtent = -1.;
		for( f in filters ) {
			f.sync(ctx, this);
			if( f.autoBounds ) {
				if( f.boundsExtend > maxExtent ) maxExtent = f.boundsExtend;
			} else {
				f.getBounds(this, bounds);
				total.add(bounds);
			}
		}
		if( maxExtent >= 0 ) {
			getBounds(this, bounds);
			bounds.xMin -= maxExtent;
			bounds.yMin -= maxExtent;
			bounds.xMax += maxExtent;
			bounds.yMax += maxExtent;
			total.add(bounds);
		}

		clipBounds(ctx, total);

		var xMin = Math.floor(total.xMin + 1e-10);
		var yMin = Math.floor(total.yMin + 1e-10);
		var width = Math.ceil(total.xMax - xMin - 1e-10);
		var height = Math.ceil(total.yMax - yMin - 1e-10);

		if( width <= 0 || height <= 0 || total.xMax < total.xMin ) return;

		var t = ctx.textures.allocTarget("filterTemp", ctx, width, height, false);
		ctx.pushTarget(t, xMin, yMin);
		ctx.engine.clear(0);

		// reset transform and update childs
		var oldAlpha = ctx.globalAlpha;
		var shader = @:privateAccess ctx.baseShader;
		var oldA = shader.filterMatrixA.clone();
		var oldB = shader.filterMatrixB.clone();
		var oldF = @:privateAccess ctx.inFilter;

		// 2x3 inverse matrix
		var invDet = 1 / (matA * matD - matB * matC);
		var invA = matD * invDet;
		var invB = -matB * invDet;
		var invC = -matC * invDet;
		var invD = matA * invDet;
		var invX = -(absX * invA + absY * invC);
		var invY = -(absX * invB + absY * invD);

		@:privateAccess ctx.inFilter = true;
		shader.filterMatrixA.set(invA, invC, invX);
		shader.filterMatrixB.set(invB, invD, invY);
		ctx.globalAlpha = 1;
		draw(ctx);
		for( c in childs )
			c.drawRec(ctx);
		ctx.flush();
		shader.filterMatrixA.load(oldA);
		shader.filterMatrixB.load(oldB);
		@:privateAccess ctx.inFilter = oldF;

		var final = h2d.Tile.fromTexture(t);
		final.dx = xMin;
		final.dy = yMin;
		for( f in filters ) {
			final = f.draw(ctx, final);
			if( final == null ) {
				ctx.popTarget();
				return;
			}
			final.dx = xMin;
			final.dy = yMin;
		}

		ctx.popTarget();

		ctx.globalAlpha = oldAlpha * alpha;
		emitTile(ctx, final);
		ctx.globalAlpha = oldAlpha;
		ctx.flush();
	}

	function drawRec( ctx : RenderContext ) {
		if( !visible ) return;
		// fallback in case the object was added during a sync() event and we somehow didn't update it
		if( posChanged ) {
			// only sync anim, don't update() (prevent any event from occuring during draw())
			// if( currentAnimation != null ) currentAnimation.sync();
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
		}
		if( filters.length > 0 ) {
			drawFilters(ctx);
		} else {
			var old = ctx.globalAlpha;
			ctx.globalAlpha *= alpha;
			draw(ctx);
			for( c in childs )
				c.drawRec(ctx);
			ctx.globalAlpha = old;
		}
	}

	inline function set_x(v) {
		posChanged = true;
		return x = v;
	}

	inline function set_y(v) {
		posChanged = true;
		return y = v;
	}

	inline function set_scaleX(v) {
		posChanged = true;
		return scaleX = v;
	}

	inline function set_scaleY(v) {
		posChanged = true;
		return scaleY = v;
	}

	inline function set_rotation(v) {
		posChanged = true;
		return rotation = v;
	}

	public function move( dx : Float, dy : Float ) {
		x += dx * Math.cos(rotation);
		y += dy * Math.sin(rotation);
	}

	public inline function setPos( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
	}

	public inline function rotate( v : Float ) {
		rotation += v;
	}

	public inline function scale( v : Float ) {
		scaleX *= v;
		scaleY *= v;
	}

	public inline function setScale( v : Float ) {
		scaleX = v;
		scaleY = v;
	}

	public inline function getChildAt( n ) {
		return childs[n];
	}

	public function getChildIndex( s ) {
		for( i in 0...childs.length )
			if( childs[i] == s )
				return i;
		return -1;
	}

	inline function get_numChildren() {
		return childs.length;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(childs);
	}

	function toString() {
		var c = Type.getClassName(Type.getClass(this));
		return name == null ? c : name + "(" + c + ")";
	}

}