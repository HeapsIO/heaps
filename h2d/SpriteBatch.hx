package h2d;

import h2d.RenderContext;
import h2d.impl.BatchDrawState;

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
	A base class for `SpriteBatch` elements which can be extended with custom logic.

	See `BasicElement` as an example of custom element logic.
**/
@:allow(h2d.SpriteBatch)
class BatchElement {
	/**
		Element X position.
	**/
	public var x : Float = 0;
	/**
		Element Y position.
	**/
	public var y : Float = 0;
	/**
		Shortcut to set both `BatchElement.scaleX` and `BatchElement.scaleY` at the same time.

		Equivalent to `el.scaleX = el.scaleY = scale`.
	**/
	public var scale(never,set) : Float;
	/**
		X-axis scaling factor of the element.

		This variable is used only if `SpriteBatch.hasRotationScale` is set to `true`.
	**/
	public var scaleX : Float = 1;
	/**
		Y-axis scaling factor of the element.

		This variable is used only if `SpriteBatch.hasRotationScale` is set to `true`.
	**/
	public var scaleY : Float = 1;
	/**
		Element rotation in radians.

		This variable is used only if `SpriteBatch.hasRotationScale` is set to `true`.
	**/
	public var rotation : Float = 0;
	/**
		Red tint value (0...1 range) of the element.
	**/
	public var r : Float = 1;
	/**
		Green tint value (0...1 range) of the element.
	**/
	public var g : Float = 1;
	/**
		Blue tint value (0...1 range) of the element.
	**/
	public var b : Float = 1;
	/**
		Alpha value of the element.
	**/
	public var a : Float = 1;
	/**
		The Tile this element renders.

		Due to implementation specifics, this Tile instance is used only to provide rendering area, not the Texture itself,
		as `SpriteBatch.tile` used as a source of rendered texture.
	**/
	public var t : Tile;
	/**
		Alpha value of the element.
		Alias of `BatchElement.a`.
	**/
	public var alpha(get,set) : Float;
	/**
		If set to `false`, element will not be rendered.
	**/
	public var visible : Bool = true;
	/**
		Reference to parent SpriteBatch instance.
	**/
	public var batch(default, null) : SpriteBatch;

	var prev : BatchElement;
	var next : BatchElement;

	/**
		Create a new BatchElement instance with provided Tile.
		@param t The tile used to render this BatchElement.
	**/
	public function new( t : Tile ) {
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
		Override this method to perform custom logic per batch element.
		Update method called only if `SpriteBatch.hasUpdate` is set to `true`.
		@param dt The elapsed time in seconds since last update from `RenderContext.elapsedTime`.
		@returns If method returns `false`, element will be removed from the SpriteBatch.
	**/
	@:dox(show)
	function update(et:Float) {
		return true;
	}

	/**
		Remove this BatchElement from the parent SpriteBatch instance.
	**/
	public function remove() {
		if( batch != null )
			batch.delete(this);
	}

}

/**
	A simple `BatchElement` that provides primitive simulation of velocity, friction and gravity.

	Parent `SpriteBatch` should have `SpriteBatch.hasUpdate` set to `true` in order for BasicElement to work properly.
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
		The gravity applied to vertical velocity in pixels per second.
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
	An active batched tile renderer.

	Compared to `TileGroup` which is expected to be used as a static geometry,
	SpriteBatch uploads GPU buffer each frame by collecting data from added `BatchElement` instance.
	Due to that, dynamically removing and adding new geometry is fairly simple.

	Usage note: While SpriteBatch allows for multiple unique textures, each texture swap causes a new drawcall,
	and due to that it's recommended to minimize the amount of used textures per SpriteBatch instance,
	ideally limiting to only one texture.
**/
class SpriteBatch extends Drawable {

	/**
		The Tile used as a base Texture to draw contents with.
	**/
	public var tile : Tile;
	/**
		Enables usage of rotation and scaling of SpriteBatch elements at the cost of extra calculus.

		Makes use of `BatchElement.scaleX`, `BatchElement.scaleY` and `BatchElement.rotation`.
	**/
	public var hasRotationScale : Bool = false;
	/**
		Enables usage of `update` method in SpriteBatch elements.
	**/
	public var hasUpdate : Bool = false;
	var first : BatchElement;
	var last : BatchElement;
	var tmpBuf : hxd.FloatBuffer;
	var buffer : h3d.Buffer;
	var state : BatchDrawState;
	var empty : Bool;

	/**
		Create new SpriteBatch instance.
		@param t The Tile used as a base Texture to draw contents with.
		@param parent An optional parent `h2d.Object` instance to which SpriteBatch adds itself if set.
	**/
	public function new(t,?parent) {
		super(parent);
		tile = t;
		state = new BatchDrawState();
	}

	/**
		Adds a new BatchElement to the SpriteBatch.
		@param e The element to add.
		@param before When set, element will be added to the beginning of the element chain (rendered first).
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
		Removes all elements from the SpriteBatch.

		Usage note: Does not clear the `BatchElement.batch` nor `next`/`prev` variables on the child elements.
	**/
	public function clear() {
		first = last = null;
		flush();
	}

	/**
		Creates a new BatchElement and returns it. Shortcut to `add(new BatchElement(t))`
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
		if( first == null ) {
			return;
		}
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var e = first;
		var tmp = tmpBuf;
		var bufferVertices = 0;
		state.clear();

		while( e != null ) {
			if( !e.visible ) {
				e = e.next;
				continue;
			}

			var t = e.t;
			state.setTile(t);
			state.add(4);

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
		empty = bufferVertices == 0;
		if( bufferVertices > 0 )
			buffer = h3d.Buffer.ofSubFloats(tmpBuf, 8, bufferVertices, [Dynamic, Quads, RawFormat]);
	}

	override function draw( ctx : RenderContext ) {
		drawWith(ctx, this);
	}

	@:allow(h2d)
	function drawWith( ctx:RenderContext, obj : Drawable ) {
		if( first == null || buffer == null || buffer.isDisposed() || empty ) return;
		if( !ctx.beginDrawBatchState(obj) ) return;
		var engine = ctx.engine;
		state.drawQuads(ctx, buffer);
	}

	/**
		Checks if SpriteBatch contains any elements.
	**/
	public inline function isEmpty() {
		return first == null;
	}

	/**
		Returns an Iterator of all SpriteBatch elements.

		Adding or removing the elements will affect the Iterator results.
	**/
	public inline function getElements() {
		return new ElementsIterator(first);
	}

	override function onRemove() {
		super.onRemove();
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
		state.clear();
	}
}