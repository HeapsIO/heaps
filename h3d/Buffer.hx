package h3d;

enum BufferFlag {
	/**
		Indicate that the buffer content will be often modified.
	**/
	Dynamic;
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
	public var format(default,null) : hxd.BufferFormat;
	public var flags(default, null) : haxe.EnumFlags<BufferFlag>;

	public function new(vertices, format : hxd.BufferFormat, ?flags : Array<BufferFlag> ) {
		id = GUID++;
		this.vertices = vertices;
		this.format = format;
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

	public inline function getMemSize() {
		return vertices * (format.stride << 2);
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

	public static function ofFloats( v : hxd.FloatBuffer, format : hxd.BufferFormat, ?flags ) {
		var nvert = Std.int(v.length / format.stride);
		var b = new Buffer(nvert, format, flags);
		b.uploadVector(v, 0, nvert);
		return b;
	}

	public static function ofSubFloats( v : hxd.FloatBuffer, vertices : Int, format : hxd.BufferFormat, ?flags ) {
		var b = new Buffer(vertices, format, flags);
		b.uploadVector(v, 0, vertices);
		return b;
	}

}
