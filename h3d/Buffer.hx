package h3d;

enum BufferFlag {
	/**
		Indicate that the buffer content will be often modified.
	**/
	Dynamic;
	/**
		The buffer contains only triangles. Imply Managed. Make sure the position is aligned on 3 vertices multiples.
	**/
	Triangles;
	/**
		The buffer contains only quads. Imply Managed. Make sure the position is aligned on 4 vertices multiples.
	**/
	Quads;
	/**
		Will allocate the memory as part of an shared buffer pool, preventing a lot of small GPU buffers to be allocated.
	**/
	Managed;
	/**
		Used internaly
	**/
	NoAlloc;
}

class Buffer {

	public var buffer(default,null) : h3d.impl.ManagedBuffer;
	public var position(default,null) : Int;
	public var vertices(default,null) : Int;
	public var next(default,null) : Buffer;
	public var flags(default, null) : haxe.EnumFlags<BufferFlag>;
	
	public function new(vertices, stride, ?flags : Array<BufferFlag>) {
		this.vertices = vertices;
		this.flags = new haxe.EnumFlags();
		if( flags != null )
			for( f in flags )
				this.flags.set(f);
		if( this.flags.has(Quads) || this.flags.has(Triangles) )
			this.flags.set(Managed);
		if( !this.flags.has(NoAlloc) )
			h3d.Engine.getCurrent().mem.allocBuffer(this, stride);
	}

	public function isDisposed() {
		return buffer == null || buffer.isDisposed();
	}
	
	public function dispose() {
		if( buffer != null ) {
			buffer.freeBuffer(this);
			buffer = null;
			if( next != null ) next.dispose();
		}
	}
	
	/**
		Returns the total number of vertices including the potential next buffers if it is split.
	**/
	public function totalVertices() {
		var count = 0;
		var b = this;
		while( b != null ) {
			count += b.vertices;
			b = b.next;
		}
		return count;
	}
	
	public function uploadVector( buf : hxd.FloatBuffer, bufPos : Int, vertices : Int ) {
		var cur = this;
		while( vertices > 0 ) {
			if( cur == null ) throw "Too many vertices";
			var count = vertices > cur.vertices ? cur.vertices : vertices;
			cur.buffer.uploadVertexBuffer(cur.position, count, buf, bufPos);
			bufPos += count * buffer.stride;
			vertices -= count;
			cur = cur.next;
		}
	}
	
	public function uploadBytes( data : haxe.io.Bytes, dataPos : Int, vertices : Int ) {
		var cur = this;
		while( vertices > 0 ) {
			if( cur == null ) throw "Too many vertices";
			var count = vertices > cur.vertices ? cur.vertices : vertices;
			cur.buffer.uploadVertexBytes(cur.position, count, data, dataPos);
			dataPos += count * buffer.stride * 4;
			vertices -= count;
			cur = cur.next;
		}
	}
	
	public static function ofFloats( v : hxd.FloatBuffer, stride : Int, ?flags, ?vertices ) {
		var nvert = vertices == null ? Std.int(v.length / stride) : vertices;
		var b = new Buffer(nvert, stride, flags);
		b.uploadVector(v, 0, nvert);
		return b;
	}
	
}

class BufferOffset {
	public var id : Int;
	public var buffer : Buffer;
	public var offset : Int;
	
	/*
		This is used to return a list of BufferOffset without allocating an array
	*/
	public var next : BufferOffset;
	
	static var UID = 0;
	
	public function new(buffer, offset) {
		this.id = UID++;
		this.buffer = buffer;
		this.offset = offset;
	}
	public function dispose() {
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
		next = null;
	}
}