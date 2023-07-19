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
}

@:allow(h3d.impl.MemoryManager)
class Buffer {
	public static var GUID = 0;
	public var id : Int;
	#if track_alloc
	var allocPos : hxd.impl.AllocPos;
	var allocNext : Buffer;
	#end

	var mem : h3d.impl.MemoryManager;
	var vbuf : h3d.impl.Driver.GPUBuffer;
	public var vertices(default,null) : Int;
	public var stride(default,null) : Int;
	public var flags(default, null) : haxe.EnumFlags<BufferFlag>;

	public function new(vertices, stride, ?flags : Array<BufferFlag> ) {
		id = GUID++;
		this.vertices = vertices;
		this.stride = stride;
		this.flags = new haxe.EnumFlags();
		#if track_alloc
		this.allocPos = new hxd.impl.AllocPos();
		#end
		if( flags != null )
			for( f in flags )
				this.flags.set(f);
		if( !this.flags.has(NoAlloc) )
			@:privateAccess h3d.Engine.getCurrent().mem.allocBuffer(this);
	}

	public inline function isDisposed() {
		return vbuf == null;
	}

	public function dispose() {
		if( vbuf != null ) {
			@:privateAccess mem.freeBuffer(this);
			vbuf = null;
		}
	}

	public function uploadVector( buf : hxd.FloatBuffer, bufPos : Int, vertices : Int, startVertice = 0 ) {
		if( startVertice < 0 || vertices < 0 || startVertice + vertices > this.vertices )
			throw "Invalid vertices count";
		mem.driver.uploadBufferData(vbuf, startVertice, vertices, buf, bufPos);
	}

	public function uploadBytes( data : haxe.io.Bytes, dataPos : Int, vertices : Int ) {
		if( vertices < 0 || vertices > this.vertices )
			throw "Invalid vertices count";
		mem.driver.uploadBufferBytes(vbuf, 0, vertices, data, dataPos);
	}

	public function readBytes( bytes : haxe.io.Bytes, bytesPosition : Int, vertices : Int,  startVertice : Int = 0 ) {
		if( startVertice < 0 || vertices < 0 || startVertice + vertices > this.vertices )
			throw "Invalid vertices count";
		mem.driver.readBufferBytes(vbuf, startVertice, vertices, bytes, bytesPosition);
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