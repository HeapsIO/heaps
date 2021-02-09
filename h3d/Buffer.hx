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
		Directly map the buffer content to the shader inputs, without assuming [pos:vec3,normal:vec3,uv:vec2] default prefix.
	**/
	RawFormat;
	/**
		Used internaly
	**/
	NoAlloc;
	/**
		Used for shader input buffer
	**/
	UniformBuffer;
	/**
		Use to allow to alloc buffers with >64K vertices (requires 32 bit indexes)
	**/
	LargeBuffer;
}

class Buffer {
	public static var GUID = 0;
	public var id : Int;
	#if track_alloc
	var allocPos : hxd.impl.AllocPos;
	var allocNext : Buffer;
	#end

	public var buffer(default,null) : h3d.impl.ManagedBuffer;
	public var position(default,null) : Int;
	public var vertices(default,null) : Int;
	public var next(default,null) : Buffer;
	public var flags(default, null) : haxe.EnumFlags<BufferFlag>;

	public function new(vertices, stride, ?flags : Array<BufferFlag> ) {
		id = GUID++;
		this.vertices = vertices;
		this.flags = new haxe.EnumFlags();
		#if track_alloc
		this.allocPos = new hxd.impl.AllocPos();
		#end
		if( flags != null )
			for( f in flags )
				this.flags.set(f);
		#if flash
		// flash strictly requires indexes to be within the bounds of the buffer
		// so we cannot use quad/triangle indexes unless the buffer is large enough
		if( this.flags.has(Quads) || this.flags.has(Triangles) )
			this.flags.set(Managed);
		#end
		if( !this.flags.has(NoAlloc) )
			h3d.Engine.getCurrent().mem.allocBuffer(this, stride);
	}

	public inline function isDisposed() {
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

	public function uploadVector( buf : hxd.FloatBuffer, bufPos : Int, vertices : Int, startVertice = 0 ) {
		var cur = this;
		while( cur != null && startVertice >= cur.vertices ) {
			startVertice -= cur.vertices;
			cur = cur.next;
		}
		while( vertices > 0 ) {
			if( cur == null ) throw "Too many vertices";
			var count = vertices + startVertice > cur.vertices ? cur.vertices - startVertice : vertices;
			cur.buffer.uploadVertexBuffer(cur.position + startVertice, count, buf, bufPos);
			startVertice = 0;
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

	public function readBytes( bytes : haxe.io.Bytes, bytesPosition : Int, vertices : Int,  startVertice : Int = 0 ) {
		var cur = this;
		while( cur != null && startVertice >= cur.vertices ) {
			startVertice -= cur.vertices;
			cur = cur.next;
		}
		while( vertices > 0 ) {
			if( cur == null ) throw "Too many vertices";
			var count = vertices + startVertice > cur.vertices ? cur.vertices - startVertice : vertices;
			cur.buffer.readVertexBytes(cur.position + startVertice, count, bytes, bytesPosition);
			startVertice = 0;
			bytesPosition += count * buffer.stride * 4;
			vertices -= count;
			cur = cur.next;
		}
	}

	public static function ofFloats( v : hxd.FloatBuffer, stride : Int, ?flags ) {
		var nvert = Std.int(v.length / stride);
		var b = new Buffer(nvert, stride, flags);
		b.uploadVector(v, 0, nvert);
		return b;
	}

	public static function ofSubFloats( v : hxd.FloatBuffer, stride : Int, vertices : Int, ?flags ) {
		var b = new Buffer(vertices, stride, flags);
		b.uploadVector(v, 0, vertices);
		return b;
	}

}

class BufferOffset {
	#if flash
	static var UID = 0;
	public var id : Int;
	#end

	public var buffer : Buffer;
	public var offset : Int;

	/*
		This is used to return a list of BufferOffset without allocating an array
	*/
	public var next : BufferOffset;

	public function new(buffer, offset) {
		#if flash
		this.id = UID++;
		#end
		this.buffer = buffer;
		this.offset = offset;
	}

	public inline function clone() {
		var b = new BufferOffset(buffer,offset);
		#if flash
		b.id = id;
		#end
		return b;
	}

	public function dispose() {
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
		next = null;
	}
}