package h2d;
import hxd.Math;

@:allow(h2d.Tools)
class Sprite {

	static var nullDrawable : h2d.Drawable;

	var children : Array<Sprite>;
	var parentContainer : Sprite;
	public var parent(default, null) : Sprite;
	public var numChildren(get, never) : Int;

	public var x(default,set) : Float;
	public var y(default, set) : Float;
	public var scaleX(default,set) : Float;
	public var scaleY(default,set) : Float;
	public var rotation(default, set) : Float;
	public var visible(default, set) : Bool;
	public var name : String;
	public var alpha : Float = 1.;

	public var filter(default,set) : h2d.filter.Filter;

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
		children = [];
		if( parent != null )
			parent.addChild(this);
	}

	/**
		Returns the bounds of the sprite for its whole content, recursively.
		If relativeTo is null, it will return the bounds in the absolute coordinates.
		If not, it will return the bounds relative to the specified sprite coordinates.
		You can pass an already allocated bounds or getBounds will allocate one for you and return it.
	**/
	public function getBounds( ?relativeTo : Sprite, ?out : h2d.col.Bounds ) : h2d.col.Bounds {
		if( out == null ) out = new h2d.col.Bounds() else out.empty();
		if( relativeTo != null )
			relativeTo.syncPos();
		if( relativeTo != this )
			syncPos();
		getBoundsRec(relativeTo, out, false);
		if( out.isEmpty() ) {
			addBounds(relativeTo, out, -1, -1, 2, 2);
			out.xMax = out.xMin = (out.xMax + out.xMin) * 0.5;
			out.yMax = out.yMin = (out.yMax + out.yMin) * 0.5;
		}
		return out;
	}

	/**
		This is similar to getBounds(parent), but instead of the full content, it will return
		the size based on the alignement of the Sprite. For instance for a text, getBounds will returns
		the full glyphs size whereas getSize() will ignore the pixels under the baseline.
	**/
	public function getSize( ?out : h2d.col.Bounds ) : h2d.col.Bounds {
		if( out == null ) out = new h2d.col.Bounds() else out.empty();
		syncPos();
		getBoundsRec(parent, out, true);
		if( out.isEmpty() ) {
			addBounds(parent, out, -1, -1, 2, 2);
			out.xMax = out.xMin = (out.xMax + out.xMin) * 0.5;
			out.yMax = out.yMin = (out.yMax + out.yMin) * 0.5;
		}
		out.offset( -x, -y);
		return out;
	}

	public function find<T>( f : Sprite -> Null<T> ) : Null<T> {
		var v = f(this);
		if( v != null )
			return v;
		for( o in children ) {
			var v = o.find(f);
			if( v != null ) return v;
		}
		return null;
	}

	public function findAll<T>( f : Sprite -> Null<T>, ?arr : Array<T> ) : Array<T> {
		if( arr == null ) arr = [];
		var v = f(this);
		if( v != null )
			arr.push(v);
		for( o in children )
			o.findAll(f,arr);
		return arr;
	}

	function set_filter(f) {
		if( filter != null && allocated ) filter.unbind(this);
		filter = f;
		if( f != null && allocated ) f.bind(this);
		return f;
	}

	function getBoundsRec( relativeTo : Sprite, out : h2d.col.Bounds, forSize : Bool ) {
		if( posChanged ) {
			calcAbsPos();
			for( c in children )
				c.posChanged = true;
			posChanged = false;
		}
		var n = children.length;
		if( n == 0 ) {
			out.empty();
			return;
		}
		if( n == 1 ) {
			var c = children[0];
			if( c.visible ) c.getBoundsRec(relativeTo, out,forSize) else out.empty();
			return;
		}
		var xmin = hxd.Math.POSITIVE_INFINITY, ymin = hxd.Math.POSITIVE_INFINITY;
		var xmax = hxd.Math.NEGATIVE_INFINITY, ymax = hxd.Math.NEGATIVE_INFINITY;
		for( c in children ) {
			if( !c.visible ) continue;
			c.getBoundsRec(relativeTo, out, forSize);
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

		var r = relativeTo.matA * relativeTo.matD - relativeTo.matB * relativeTo.matC;
		if( r == 0 )
			return;

		var det = 1 / r;
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
		for( c in children )
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

	function set_visible(b) {
		if( visible == b )
			return b;
		visible = b;
		onContentChanged();
		return b;
	}

	public function addChild( s : Sprite ) {
		addChildAt(s, children.length);
	}

	public function addChildAt( s : Sprite, pos : Int ) {
		if( pos < 0 ) pos = 0;
		if( pos > children.length ) pos = children.length;
		var p = this;
		while( p != null ) {
			if( p == s ) throw "Recursive addChild";
			p = p.parent;
		}
		if( s.parent != null ) {
			// prevent calling onRemove
			var old = s.allocated;
			s.allocated = false;
			s.parent.removeChild(s);
			s.allocated = old;
		}
		children.insert(pos, s);
		if( !allocated && s.allocated )
			s.onRemove();
		s.parent = this;
		s.parentContainer = parentContainer;
		s.posChanged = true;
		// ensure that proper alloc/delete is done if we change parent
		if( allocated ) {
			if( !s.allocated )
				s.onAdd();
			else
				s.onParentChanged();
		}
		onContentChanged();
	}

	inline function onContentChanged() {
		if( parentContainer != null ) parentContainer.contentChanged(this);
	}

	// called when we're allocated already but moved in hierarchy
	function onParentChanged() {
		for( c in children )
			c.onParentChanged();
	}

	// kept for internal init
	function onAdd() {
		allocated = true;
		if( filter != null )
			filter.bind(this);
		for( c in children )
			c.onAdd();
	}

	// kept for internal cleanup
	function onRemove() {
		allocated = false;
		if( filter != null )
			filter.unbind(this);
		for( c in children )
			c.onRemove();
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
		if( children.remove(s) ) {
			if( s.allocated ) s.onRemove();
			s.parent = null;
			if( s.parentContainer != null ) s.setParentContainer(null);
			s.posChanged = true;
			onContentChanged();
		}
	}

	function setParentContainer( c : Sprite ) {
		parentContainer = c;
		for( s in children )
			s.setParentContainer(c);
	}

	public function removeChildren() {
		while( numChildren>0 )
			removeChild( getChildAt(0) );
	}

	/**
		Same as parent.removeChild(this), but does nothing if parent is null.
		In order to capture add/removal from scene, you can override onAdd/onRemove/onParentChanged
	**/
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
		var p = 0, len = children.length;
		while( p < len ) {
			var c = children[p];
			if( c == null )
				break;
			if( c.lastFrame != ctx.frame ) {
				if( changed ) c.posChanged = true;
				c.sync(ctx);
			}
			// if the object was removed, let's restart again.
			// our lastFrame ensure that no object will get synched twice
			if( children[p] != c ) {
				p = 0;
				len = children.length;
			} else
				p++;
		}
	}

	function syncPos() {
		if( parent != null ) parent.syncPos();
		if( posChanged ) {
			calcAbsPos();
			for( c in children )
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
		if( !ctx.beginDrawBatch(nullDrawable, tile.getTexture()) ) return;

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
		var matA, matB, matC, matD, absX, absY;
		@:privateAccess if( ctx.inFilter != null ) {
			var f1 = ctx.baseShader.filterMatrixA;
			var f2 = ctx.baseShader.filterMatrixB;
			matA = this.matA * f1.x + this.matB * f1.y;
			matB = this.matA * f2.x + this.matB * f2.y;
			matC = this.matC * f1.x + this.matD * f1.y;
			matD = this.matC * f2.x + this.matD * f2.y;
			absX = this.absX * f1.x + this.absY * f1.y + f1.z;
			absY = this.absX * f2.x + this.absY * f2.y + f2.z;
		} else {
			matA = this.matA;
			matB = this.matB;
			matC = this.matC;
			matD = this.matD;
			absX = this.absX;
			absY = this.absY;
		}

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
		@:privateAccess {
			if( view.xMin < ctx.curX ) view.xMin = ctx.curX;
			if( view.yMin < ctx.curY ) view.yMin = ctx.curY;
			if( view.xMax > ctx.curX + ctx.curWidth ) view.xMax = ctx.curX + ctx.curWidth;
			if( view.yMax > ctx.curY + ctx.curHeight ) view.yMax = ctx.curY + ctx.curHeight;
		}

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
		bounds.doIntersect(view);
	}

	function drawFilters( ctx : RenderContext ) {
		if( !ctx.pushFilter(this) ) return;

		var bounds = ctx.tmpBounds;
		var total = new h2d.col.Bounds();
		var maxExtent = -1.;
		filter.sync(ctx, this);
		if( filter.autoBounds ) {
			maxExtent = filter.boundsExtend;
		} else {
			filter.getBounds(this, bounds);
			total.addBounds(bounds);
		}
		if( maxExtent >= 0 ) {
			getBounds(this, bounds);
			bounds.xMin -= maxExtent;
			bounds.yMin -= maxExtent;
			bounds.xMax += maxExtent;
			bounds.yMax += maxExtent;
			total.addBounds(bounds);
		}

		clipBounds(ctx, total);

		var xMin = Math.floor(total.xMin + 1e-10);
		var yMin = Math.floor(total.yMin + 1e-10);
		var width = Math.ceil(total.xMax - xMin - 1e-10);
		var height = Math.ceil(total.yMax - yMin - 1e-10);

		if( width <= 0 || height <= 0 || total.xMax < total.xMin ) return;

		var t = ctx.textures.allocTarget("filterTemp", ctx, width, height, false);
		ctx.pushTarget(t, xMin, yMin, width, height);
		ctx.engine.clear(0);

		// reset transform and update children
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

		shader.filterMatrixA.set(invA, invC, invX);
		shader.filterMatrixB.set(invB, invD, invY);
		ctx.globalAlpha = 1;
		draw(ctx);
		for( c in children )
			c.drawRec(ctx);
		ctx.flush();

		var finalTile = h2d.Tile.fromTexture(t);
		finalTile.dx = xMin;
		finalTile.dy = yMin;

		var prev = finalTile;
		finalTile = filter.draw(ctx, finalTile);
		if( finalTile != prev && finalTile != null ) {
			finalTile.dx += xMin;
			finalTile.dy += yMin;
		}

		shader.filterMatrixA.load(oldA);
		shader.filterMatrixB.load(oldB);

		ctx.popTarget();
		ctx.popFilter();

		if( finalTile == null )
			return;

		ctx.globalAlpha = oldAlpha * alpha;
		emitTile(ctx, finalTile);
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
			for( c in children )
				c.posChanged = true;
			posChanged = false;
		}
		if( filter != null ) {
			drawFilters(ctx);
		} else {
			var old = ctx.globalAlpha;
			ctx.globalAlpha *= alpha;
			if( ctx.front2back ) {
				var nchilds = children.length;
				for (i in 0...nchilds) children[nchilds - 1 - i].drawRec(ctx);
				draw(ctx);
			} else {
				draw(ctx);
				for( c in children ) c.drawRec(ctx);
			}
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
		return children[n];
	}

	public function getChildIndex( s ) {
		for( i in 0...children.length )
			if( children[i] == s )
				return i;
		return -1;
	}

	inline function get_numChildren() {
		return children.length;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(children);
	}

	function toString() {
		var c = Type.getClassName(Type.getClass(this));
		return name == null ? c : name + "(" + c + ")";
	}

	// ---- additional methods for containers (h2d.Flow)

	/**
		This is called by our children if we have defined their parentContainer when they get resized
	**/
	function contentChanged( s : Sprite ) {
	}

	/**
		This can be called by a parent container to constraint the size of its children.
		Negative value mean that constraint is to be disable.
	**/
	function constraintSize( maxWidth : Float, maxHeight : Float ) {
	}

}

