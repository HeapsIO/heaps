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
	/**
		Can be written
	**/
	ReadWriteBuffer;
	/**
		Used as index buffer
	**/
	IndexBuffer;
}

@:allow(h3d.impl.MemoryManager)
class Buffer {
	public static var GUID = 0;
	public var id : Int;
	var allocPos : hxd.impl.AllocPos;
	var engine : h3d.Engine;
	var lastFrame : Int;

	@:allow(h3d.impl.Driver) var vbuf : h3d.impl.Driver.GPUBuffer;
	public var vertices(default,null) : Int;
	public var format(default,null) : hxd.BufferFormat;
	public var flags(default, null) : haxe.EnumFlags<BufferFlag>;

	public function new(vertices, format : hxd.BufferFormat, ?flags : Array<BufferFlag> ) {
		id = GUID++;
		this.vertices = vertices;
		this.format = format;
		this.flags = new haxe.EnumFlags();
		this.allocPos = hxd.impl.AllocPos.make();
		if( flags != null )
			for( f in flags )
				this.flags.set(f);
		engine = h3d.Engine.getCurrent();
		if( !this.flags.has(NoAlloc) )
			@:privateAccess engine.mem.allocBuffer(this);
	}

	public inline function getMemSize() {
		return vertices * format.strideBytes;
	}

	public inline function isDisposed() {
		return vbuf == null;
	}

	public function dispose() {
		if( vbuf != null ) {
			@:privateAccess engine.mem.freeBuffer(this);
			vbuf = null;
		}
	}

	public function uploadFloats( buf : hxd.FloatBuffer, bufPos : Int, vertices : Int, startVertice = 0 ) {
		if( startVertice < 0 || vertices < 0 || startVertice + vertices > this.vertices )
			throw "Invalid vertices count";
		if( vertices == 0 )
			return;
		if( format.hasLowPrecision ) {
			var bytes = haxe.io.Bytes.alloc(vertices * format.strideBytes);
			var bytesPos : Int = 0;
			var index : Int = bufPos;

			var inputs = format.getInputs();
			for ( _ in 0...vertices ) {
				@:privateAccess inputs.current = 0;
				for ( input in inputs ) {
					var elementCount = input.type.getSize();
					var step = 0;
					switch ( input.precision ) {
						case F32 :
							for ( i in 0...elementCount ) {
								bytes.setFloat( bytesPos + step, buf[index++] );
								step += 4;
							}
						case F16 :
							for ( i in 0...elementCount ) {
								var f = hxd.BufferFormat.float32to16(buf[index++]);
								bytes.setUInt16( bytesPos + step, f );
								step += 2;
							}
						case U8 :
							for ( i in 0...elementCount ) {
								var f = hxd.BufferFormat.float32toU8(buf[index++]);
								bytes.set( bytesPos + step, f );
								step++;
							}
						case S8 :
							for ( i in 0...elementCount ) {
								var f = hxd.BufferFormat.float32toS8(buf[index++]);
								bytes.set( bytesPos + step, f );
								step++;
							}
					}
					// 4 bytes align
					bytesPos += input.getBytesSize();
					if ( bytesPos & 3 != 0 ) bytesPos += ( 4 - (bytesPos & 3) );
				}
			}
			uploadBytes(bytes, 0, vertices);
			return;
		}
		engine.driver.uploadBufferData(this, startVertice, vertices, buf, bufPos);
	}

	public function uploadBytes( data : haxe.io.Bytes, dataPos : Int, vertices : Int ) {
		if( vertices < 0 || vertices > this.vertices )
			throw "Invalid vertices count";
		if( vertices == 0 )
			return;
		engine.driver.uploadBufferBytes(this, 0, vertices, data, dataPos);
	}

	public function readBytes( bytes : haxe.io.Bytes, bytesPosition : Int, vertices : Int,  startVertice : Int = 0 ) {
		if( startVertice < 0 || vertices < 0 || startVertice + vertices > this.vertices )
			throw "Invalid vertices count";
		engine.driver.readBufferBytes(this, startVertice, vertices, bytes, bytesPosition);
	}

	public static function ofFloats( v : hxd.FloatBuffer, format : hxd.BufferFormat, ?flags ) {
		var nvert = Math.ceil(v.length / format.stride);
		var b = new Buffer(nvert, format, flags);
		b.uploadFloats(v, 0, nvert);
		return b;
	}

	public static function ofSubFloats( v : hxd.FloatBuffer, vertices : Int, format : hxd.BufferFormat, ?flags ) {
		var b = new Buffer(vertices, format, flags);
		b.uploadFloats(v, 0, vertices);
		return b;
	}

}
