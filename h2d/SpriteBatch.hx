package h2d;

@:allow(h2d.SpriteBatch)
class BatchElement {
	public var x : Float;
	public var y : Float;
	public var scale : Float;
	public var rotation : Float;
	public var alpha : Float;
	public var t : Tile;
	public var batch(default, null) : SpriteBatch;
	
	var prev : BatchElement;
	var next : BatchElement;
	
	function new(t) {
		x = 0; y = 0; alpha = 1;
		rotation = 0; scale = 1;
		this.t = t;
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
		shader.hasVertexAlpha = true;
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
				tmp[pos++] = e.alpha;
				var px = t.dx + hx, py = t.dy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v;
				tmp[pos++] = e.alpha;
				var px = t.dx, py = t.dy + hy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.alpha;
				var px = t.dx + hx, py = t.dy + hy;
				tmp[pos++] = (px * ca - py * sa) * e.scale + e.x;
				tmp[pos++] = (py * ca + px * sa) * e.scale + e.y;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.alpha;
			} else {
				var sx = e.x + t.dx;
				var sy = e.y + t.dy;
				tmp[pos++] = sx;
				tmp[pos++] = sy;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v;
				tmp[pos++] = e.alpha;
				tmp[pos++] = sx + t.width + 0.1;
				tmp[pos++] = sy;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v;
				tmp[pos++] = e.alpha;
				tmp[pos++] = sx;
				tmp[pos++] = sy + t.height + 0.1;
				tmp[pos++] = t.u;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.alpha;
				tmp[pos++] = sx + t.width + 0.1;
				tmp[pos++] = sy + t.height + 0.1;
				tmp[pos++] = t.u2;
				tmp[pos++] = t.v2;
				tmp[pos++] = e.alpha;
			}
			e = e.next;
		}
		var buffer = h3d.Buffer.ofFloats(tmpBuf, 5, [Dynamic, Quads], Std.int(pos/5));
		setupShader(ctx.engine, tile, 0);
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}
	
	public inline function isEmpty() {
		return first == null;
	}
	
}