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

@:allow(h2d.SpriteBatch)
class BatchElement {
	public var x : Float;
	public var y : Float;
	public var scale(never,set) : Float;
	public var scaleX : Float;
	public var scaleY : Float;
	public var rotation : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;
	public var t : Tile;
	public var alpha(get,set) : Float;
	public var visible : Bool;
	public var batch(default, null) : SpriteBatch;

	var prev : BatchElement;
	var next : BatchElement;

	public function new(t) {
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

	function update(et:Float) {
		return true;
	}

	public function remove() {
		if( batch != null )
			batch.delete(this);
	}

}

class BasicElement extends BatchElement {

	public var vx : Float = 0.;
	public var vy : Float = 0.;
	public var friction : Float = 1.;
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

class SpriteBatch extends Drawable {

	public var tile : Tile;
	public var hasRotationScale : Bool;
	public var hasUpdate : Bool;
	var first : BatchElement;
	var last : BatchElement;
	var tmpBuf : hxd.FloatBuffer;
	var buffer : h3d.Buffer;

	public function new(t,?parent) {
		super(parent);
		tile = t;
	}

	public function add(e:BatchElement) {
		e.batch = this;
		if( first == null ) {
			first = last = e;
			e.prev = e.next = null;
		} else {
			last.next = e;
			e.prev = last;
			e.next = null;
			last = e;
		}
		return e;
	}

	public function alloc(t) {
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
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
		if( first == null )
			return;
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
		buffer = h3d.Buffer.ofSubFloats(tmpBuf, 8, Std.int(pos/8), [Dynamic, Quads, RawFormat]);
	}

	override function draw( ctx : RenderContext ) {
		if( first == null || buffer == null || buffer.isDisposed() ) return;
		if( !ctx.beginDrawObject(this, tile.getTexture()) ) return;
		ctx.engine.renderQuadBuffer(buffer);
	}

	public inline function isEmpty() {
		return first == null;
	}

	public inline function getElements() {
		return new ElementsIterator(first);
	}

	override function onDelete()  {
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
	}
}