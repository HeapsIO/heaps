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
	public var scale : Float;
	public var rotation : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;
	public var t : Tile;
	public var alpha(get,set) : Float;
	public var batch(default, null) : SpriteBatch;

	var prev : BatchElement;
	var next : BatchElement;

	function new(t) {
		x = 0; y = 0; r = 1; g = 1; b = 1; a = 1;
		rotation = 0; scale = 1;
		this.t = t;
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

	public inline function remove() {
		batch.delete(this);
	}

}

class SpriteBatch extends Drawable {

	public var tile : Tile;
	public var hasRotationScale : Bool;
	public var hasUpdate : Bool;
	var first : BatchElement;
	var last : BatchElement;
	var tmpBuf : hxd.FloatBuffer;

	public function new(t,?parent) {
		super(parent);
		tile = t;
	}

	public function add(e:BatchElement) {
		e.batch = this;
		if( first == null )
			first = last = e;
		else {
			last.next = e;
			e.prev = last;
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
	}

	override function getBoundsRec( relativeTo, out ) {
		super.getBoundsRec(relativeTo, out);
		var e = first;
		while( e != null ) {
			var t = e.t;
			if( hasRotationScale ) {
				var ca = Math.cos(e.rotation), sa = Math.sin(e.rotation);
				var hx = t.width, hy = t.height;
				var px = t.dx, py = t.dy;
				var x, y;

				x = (px * ca - py * sa) * e.scale + e.x;
				y = (py * ca + px * sa) * e.scale + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);

				var px = t.dx + hx, py = t.dy;
				x = (px * ca - py * sa) * e.scale + e.x;
				y = (py * ca + px * sa) * e.scale + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);

				var px = t.dx, py = t.dy + hy;
				x = (px * ca - py * sa) * e.scale + e.x;
				y = (py * ca + px * sa) * e.scale + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);

				var px = t.dx + hx, py = t.dy + hy;
				x = (px * ca - py * sa) * e.scale + e.x;
				y = (py * ca + px * sa) * e.scale + e.y;
				addBounds(relativeTo, out, x, y, 1e-10, 1e-10);
			} else
				addBounds(relativeTo, out, e.x + tile.dx, e.y + tile.dy, tile.width, tile.height);
			e = e.next;
		}
	}

	override function draw( ctx : RenderContext ) {
		if( first == null )
			return;
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var e = first;
		var tmp = tmpBuf;
		while( e != null ) {
			var t = e.t;
			if( hasRotationScale ) {
				var ca = Math.cos(e.rotation), sa = Math.sin(e.rotation);
				var hx = t.width, hy = t.height;
				var px = t.dx, py = t.dy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				var px = t.dx + hx, py = t.dy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				var px = t.dx, py = t.dy + hy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.r;
				tmp[pos++] = e.g;
				tmp[pos++] = e.b;
				tmp[pos++] = e.a;
				var px = t.dx + hx, py = t.dy + hy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
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
		var buffer = h3d.Buffer.ofSubFloats(tmpBuf, 8, Std.int(pos/8), [Dynamic, Quads, RawFormat]);
		ctx.beginDrawObject(this, tile.getTexture());
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}

	public inline function isEmpty() {
		return first == null;
	}

	public inline function getElements() {
		return new ElementsIterator(first);
	}

}