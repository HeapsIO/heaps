package h2d;

private class ElementsIterator {
	var e : BatchElement;
	public inline function new(e) {
		this.e = e;
	}
	public inline function hasNext() {
		return e != null;
	}
	public inline function next() {
		var n = e;
		e = @:privateAccess e.next;
		return n;
	}
}

/**
	`h2d.SpriteBatch.BatchElement` is a base class for SpriteBatch elements which can be extended with custom logic.
	See `h2d.SpriteBatch.BasicElement` as an example.
**/
@:allow(h2d.SpriteBatch)
class BatchElement {
	/**
		Element X position.
	**/
	public var x : Float;
	/**
		Element Y position.
	**/
	public var y : Float;
	/**
		Shortcut to set both `scaleX` and `scaleY` at the same time.
		Equivalent to `el.scaleX = el.scaleY = scale`.
	**/
	public var scale(never,set) : Float;
	/**
		X-axis scaling factor of the element.
		This variable is used only if `SpriteBatch.hasRotationScale` is set to `true`.
	**/
	public var scaleX : Float;
	/**
		Y-axis scaling factor of the element.
		This variable is used only if `SpriteBatch.hasRotationScale` is set to `true`.
	**/
	public var scaleY : Float;
	/**
		Element rotation in radians.
		This variable is used only if `SpriteBatch.hasRotationScale` is set to `true`.
	**/
	public var rotation : Float;
	/**
		Red tint value (0...1 range) of the element. ( default : 1 )
	**/
	public var r : Float;
	/**
		Green tint value (0...1 range) of the element. ( default : 1 )
	**/
	public var g : Float;
	/**
		Blue tint value (0...1 range) of the element. ( default : 1 )
	**/
	public var b : Float;
	/**
		Alpha value of the element. ( default : 1 )
	**/
	public var a : Float;
	/**
		The Tile this element renders.
	**/
	public var t : Tile;
	/**
		Alpha value of the element. ( default : 1 )
		Alias `element.a`.
	**/
	public var alpha(get,set) : Float;
	/**
		If set to `false`, element will not be rendered.
	**/
	public var visible : Bool;
	/**
		Reference to parent SpriteBatch instance.
	**/
	public var batch(default, null) : SpriteBatch;

	var prev : BatchElement;
	var next : BatchElement;

	/**
		Create new BatchElement instance with provided Tile.
	**/
	public function new( t : Tile ) {
		x = 0; y = 0; r = 1; g = 1; b = 1; a = 1;
		rotation = 0; scaleX = scaleY = 1;
		visible = true;
		this.t = t;
	}

	inline function set_scale(v) {
		return scaleX = scaleY = v;
	}

	inline function get_alpha() {
		return a;
	}

	inline function set_alpha(v) {
		return a = v;
	}

	/**
		Update method is called only if `SpriteBatch.hasUpdate` is set to `true`.
		@param dt The elapsed time in seconds since last update from `RenderContext.elapsedTime`.
		@returns If method returns `false`, element will be removed from SpriteBatch.
	**/
	@:dox(show)
	function update(et:Float) {
		return true;
	}

	/**
		Remove this BatchElement from parent SpriteBatch instance.
	**/
	public function remove() {
		if( batch != null )
			batch.delete(this);
	}

}

/**
	`h2d.SpriteBatch.BasicElement` is a BatchElement that provides simple simulation of velocity, friction and gravity.
	Parent BatchElement should have `hasUpdate` set to true in order for element to work properly.
**/
class BasicElement extends BatchElement {

	/**
		X-axis velocity of the element.
	**/
	public var vx : Float = 0.;
	/**
		Y-axis velocity of the element.
	**/
	public var vy : Float = 0.;
	/**
		The velocity friction.
		When not `1`, multiplies velocity by `pow(friction, dt * 60)`.
	**/
	public var friction : Float = 1.;
	/**
		The gravity applied to vertical velocity.
	**/
	public var gravity : Float = 0.;

	override function update(dt:Float) {
		vy += gravity * dt;
		x += vx * dt;
		y += vy * dt;
		if( friction != 1 ) {
			var p = Math.pow(friction, dt * 60);
			vx *= p;
			vy *= p;
		}
		return true;
	}

}

/**
  `h2d.SpriteBatch` is an active batched renderer.
	It's limited to one unique Texture, but provides benefit of rendering everything in a single drawcall.

	SpriteBatch uploads GPU buffer each frame by collecting data from added BatchElement instances.
	Due to that, dynamically removing and adding new geometry is fairly simple.
**/
class SpriteBatch extends Drawable {

	/**
		The Tile used as a base Texture to draw contents with.
	**/
	public var tile : Tile;
	/**
		Enables usage of rotation and scaling of SpriteBatch elements at the cost of extra calculus.
	**/
	public var hasRotationScale : Bool;
	/**
		Enables usage of `update` method in SpriteBatch elements.
	**/
	public var hasUpdate : Bool;
	var first : BatchElement;
	var last : BatchElement;
	var tmpBuf : hxd.FloatBuffer;
	var buffer : h3d.Buffer;
	var bufferVertices : Int;

	/**
		Create new SpriteBatch instance with provided base Tile and parent.
	**/
	public function new(t,?parent) {
		super(parent);
		tile = t;
	}

	/**
		Adds new BatchElement to the SpriteBatch.
		@param e The element to add.
		@param before When set, element will be added to the beginning of element chain (rendered first).
	**/
	public function add(e:BatchElement,before=false) {
		e.batch = this;
		if( first == null ) {
			first = last = e;
			e.prev = e.next = null;
		} else if( before ) {
			e.prev = null;
			e.next = first;
			first.prev = e;
			first = e;
		} else {
			last.next = e;
			e.prev = last;
			e.next = null;
			last = e;
		}
		return e;
	}

	/**
		Removes all elements from SpriteBatch.
		Usage note: Does not clear `BatchElement.batch` variables on child elements.
	**/
	public function clear() {
		first = last = null;
		flush();
	}

	/**
		Creates new BatchElement and returns it. Shortcut to `add(new BatchElement(t))`
		@param t The Tile element will render.
	**/
	public function alloc( t : Tile ) : BatchElement {
		return add(new BatchElement(t));
	}

	@:allow(h2d.BatchElement)
	function delete(e : BatchElement) {
		if( e.prev == null ) {
			if( first == e )
				first = e.next;
		} else
			e.prev.next = e.next;
		if( e.next == null ) {
			if( last == e )
				last = e.prev;
		} else
			e.next.prev = e.prev;
		e.batch = null;
	}

	override function sync(ctx) {
		super.sync(ctx);
		if( hasUpdate ) {
			var e = first;
			while( e != null ) {
				if( !e.update(ctx.elapsedTime) )
					e.remove();
				e = e.next;
			}
		}
		flush();
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
		var e = first;
		while( e != null ) {
			var t = e.t;
			if( hasRotationScale ) {
				var ca = Math.cos(e.rotation), sa = Math.sin(e.rotation);
				var hx = t.width, hy = t.height;
				var px = t.dx * e.scaleX, py = t.dy * e.scaleY;
				var x, y;

				x = px * ca - py * sa + e.x;
				y = py * ca + px * sa + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);

				var px = (t.dx + hx) * e.scaleX, py = t.dy * e.scaleY;
				x = px * ca - py * sa + e.x;
				y = py * ca + px * sa + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);

				var px = t.dx * e.scaleX, py = (t.dy + hy) * e.scaleY;
				x = px * ca - py * sa + e.x;
				y = py * ca + px * sa + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);

				var px = (t.dx + hx) * e.scaleX, py = (t.dy + hy) * e.scaleY;
				x = px * ca - py * sa + e.x;
				y = py * ca + px * sa + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);
			} else
				addBounds(relativeTo, out, e.x + t.dx, e.y + t.dy, t.width, t.height);
			e = e.next;
		}
	}

	function flush() {
		if( first == null ){
			bufferVertices = 0;
			return;
		}
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var e = first;
		var tmp = tmpBuf;
		while( e != null ) {
			if( !e.visible ) {
				e = e.next;
				continue;
			}

			var t = e.t;

			tmp.grow(pos + 8 * 4);

			if( hasRotationScale ) {
				var ca = Math.cos(e.rotation), sa = Math.sin(e.rotation);
				var hx = t.width, hy = t.height;
				var px = t.dx * e.scaleX, py = t.dy * e.scaleY;
				tmp[pos++] = px * ca - py * sa + e.x;
				tmp[pos++] = py * ca + px * sa + e.y;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				var px = (t.dx + hx) * e.scaleX, py = t.dy * e.scaleY;
				tmp[pos++] = px * ca - py * sa + e.x;
				tmp[pos++] = py * ca + px * sa + e.y;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				var px = t.dx * e.scaleX, py = (t.dy + hy) * e.scaleY;
				tmp[pos++] = px * ca - py * sa + e.x;
				tmp[pos++] = py * ca + px * sa + e.y;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				var px = (t.dx + hx) * e.scaleX, py = (t.dy + hy) * e.scaleY;
				tmp[pos++] = px * ca - py * sa + e.x;
				tmp[pos++] = py * ca + px * sa + e.y;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
			} else {
				var sx = e.x + t.dx;
				var sy = e.y + t.dy;
				tmp[pos++] = sx;
				tmp[pos++] = sy;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				tmp[pos++] = sx + t.width + 0.1;
				tmp[pos++] = sy;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				tmp[pos++] = sx;
				tmp[pos++] = sy + t.height + 0.1;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				tmp[pos++] = sx + t.width + 0.1;
				tmp[pos++] = sy + t.height + 0.1;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
			}
			e = e.next;
		}
		bufferVertices = pos>>3;
		if( buffer != null && !buffer.isDisposed() ) {
			if( buffer.vertices >= bufferVertices ){
				buffer.uploadVector(tmpBuf, 0, bufferVertices);
				return;
			}
			buffer.dispose();
			buffer = null;
		}
		if( bufferVertices > 0 )
			buffer = h3d.Buffer.ofSubFloats(tmpBuf, 8, bufferVertices, [Dynamic, Quads, RawFormat]);
	}

	override function draw( ctx : RenderContext ) {
		drawWith(ctx, this);
	}

	@:allow(h2d)
	function drawWith( ctx:RenderContext, obj : Drawable ) {
		if( first == null || buffer == null || buffer.isDisposed() || bufferVertices == 0 ) return;
		if( !ctx.beginDrawObject(obj, tile.getTexture()) ) return;
		ctx.engine.renderQuadBuffer(buffer, 0, bufferVertices>>1);
	}

	/**
		Checks if SpriteBatch contains any elements.
	**/
	public inline function isEmpty() {
		return first == null;
	}

	/**
		Returns an Iterator of SpriteBatch elements.
	**/
	public inline function getElements() {
		return new ElementsIterator(first);
	}

	override function onRemove()  {
		super.onRemove();
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
	}
}