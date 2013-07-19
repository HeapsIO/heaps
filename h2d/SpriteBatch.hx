package h2d;

@:allow(h2d.SpriteBatch)
class BatchElement {
	public var x : Float;
	public var y : Float;
	public var alpha : Float;
	public var t : Tile;
	public var batch(default, null) : SpriteBatch;
	
	var prev : BatchElement;
	var next : BatchElement;
	
	function new(b,t) {
		x = 0; y = 0; alpha = 1;
		this.batch = b;
		this.t = t;
	}
	
	public inline function remove() {
		batch.delete(this);
	}
	
}

class SpriteBatch extends Drawable {

	public var tile : Tile;
	var first : BatchElement;
	var last : BatchElement;
	var tmpBuf : hxd.FloatBuffer;
		
	public function new(t,?parent) {
		super(parent);
		tile = t;
		shader.hasVertexAlpha = true;
	}
	
	public function alloc(t) {
		var e = new BatchElement(this, t);
		if( first == null )
			first = last = e;
		else {
			last.next = e;
			e.prev = last;
			last = e;
		}
		return e;
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
	
	override function draw( ctx : RenderContext ) {
		if( first == null )
			return;
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var e = first;
		var tmp = tmpBuf;
		while( e != null ) {
			var t = e.t;
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
			e = e.next;
		}
		var stride = 5;
		var nverts = Std.int(pos / stride);
		var buffer = ctx.engine.mem.alloc(nverts, stride, 4);
		buffer.uploadVector(tmpBuf, 0, nverts);
		setupShader(ctx.engine, tile, 0);
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}
	
	public inline function isEmpty() {
		return first == null;
	}
	
}