package h3d.impl;

@:allow(h3d)
private class FreeCell {
	var pos : Int;
	var count : Int;
	var next : FreeCell;
	function new(pos,count,next) {
		this.pos = pos;
		this.count = count;
		this.next = next;
	}
}

@:allow(h3d.impl.MemoryManager)
class ManagedBuffer {

	var mem : MemoryManager;
	public var stride(default,null) : Int;
	public var size(default,null) : Int;
	public var flags(default, null) : haxe.EnumFlags<Buffer.BufferFlag>;

	var vbuf : Driver.VertexBuffer;
	var freeList : FreeCell;
	var next : ManagedBuffer;
	#if track_alloc
	var allocHead : Buffer;
	#end

	public function new( stride, size, ?flags : Array<Buffer.BufferFlag> ) {
		this.flags = new haxe.EnumFlags();
		if( flags != null )
			for( f in flags )
				this.flags.set(f);
		this.size = size;
		this.stride = stride;
		this.freeList = new FreeCell(0, size, null);
		#if !noEngine
		this.mem = h3d.Engine.getCurrent().mem;
		mem.allocManaged(this);
		#end
	}

	public function uploadVertexBuffer( start : Int, vertices : Int, buf : hxd.FloatBuffer, bufPos = 0 ) {
		mem.driver.uploadVertexBuffer(vbuf, start, vertices, buf, bufPos);
	}

	public function uploadVertexBytes( start : Int, vertices : Int, data : haxe.io.Bytes, dataPos = 0 ) {
		mem.driver.uploadVertexBytes(vbuf, start, vertices, data, dataPos);
	}

	public function readVertexBytes( start : Int, vertices : Int, data : haxe.io.Bytes, dataPos = 0 ) {
		mem.driver.readVertexBytes(vbuf, start, vertices, data, dataPos);
	}

	public function alloc(vertices,align) {
		var p = allocPosition(vertices, align);
		if( p < 0 )
			return null;
		var b = new Buffer(vertices, stride, [NoAlloc]);
		@:privateAccess {
			b.position = p;
			b.buffer = this;
		};
		#if track_alloc
		@:privateAccess b.allocNext = allocHead;
		allocHead = b;
		#end
		return b;
	}

	public function getFreeVertices() {
		var m = 0;
		var l = freeList;
		while( l != null ) {
			m += l.count;
			l = l.next;
		}
		return m;
	}

	function allocPosition( nvert : Int, align : Int ) {
		var free = freeList;
		while( free != null ) {
			if( free.count >= nvert ) {
				var d = (align - (free.pos % align)) % align;
				if( d == 0 )
					break;
				// insert some padding
				if( free.count >= nvert + d ) {
					free.next = new FreeCell(free.pos + d, free.count - d, free.next);
					free.count = d;
					free = free.next;
					break;
				}
			}
			free = free.next;
		}
		if( free == null )
			return -1;
		var pos = free.pos;
		free.pos += nvert;
		free.count -= nvert;
		return pos;
	}

	function allocBuffer( b : Buffer ) {
		var align = b.flags.has(Quads) ? 4 : (b.flags.has(Triangles) ? 3 : 1);
		var p = allocPosition(b.vertices, align);
		if( p < 0 ) return false;
		@:privateAccess {
			b.position = p;
			b.buffer = this;
		};
		#if track_alloc
		@:privateAccess b.allocNext = allocHead;
		allocHead = b;
		#end
		return true;
	}

	@:allow(h3d.Buffer.dispose)
	function freeBuffer( b : Buffer ) {
		var prev : FreeCell = null;
		var f = freeList;
		var nvert = b.vertices;
		var end = b.position + nvert;
		while( f != null ) {
			if( f.pos == end ) {
				f.pos -= nvert;
				f.count += nvert;
				if( prev != null && prev.pos + prev.count == f.pos ) {
					prev.count += f.count;
					prev.next = f.next;
				}
				nvert = 0;
				break;
			}
			if( f.pos > end ) {
				if( prev != null && prev.pos + prev.count == b.position )
					prev.count += nvert;
				else {
					var n = new FreeCell(b.position, nvert, f);
					if( prev == null ) freeList = n else prev.next = n;
				}
				nvert = 0;
				break;
			}
			prev = f;
			f = f.next;
		}
		if( nvert != 0 )
			throw "assert";
		#if track_alloc
		@:privateAccess {
			var cur = allocHead, prev : Buffer = null;
			while( cur != null ) {
				if( cur == b ) {
					if( prev == null )
						allocHead = b.allocNext;
					else
						prev.allocNext = b.allocNext;
					break;
				}
				prev = cur;
				cur = cur.allocNext;
			}
		}
		#end
		if( freeList.count == size && !flags.has(Managed) )
			dispose();
	}

	public function dispose() {
		mem.freeManaged(this);
	}

	public inline function isDisposed() {
		return vbuf == null;
	}

}