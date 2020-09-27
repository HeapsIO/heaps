package hxd.impl;

@:enum abstract BufferFlags(Int) {
	public var Dynamic = 0;
	public var UniformDynamic = 1;
	public var RawFormat = 2;
	public var RawQuads = 3;
	public inline function toInt() : Int {
		return this;
	}
}

class Allocator {

	public function new() {
	}

	// GPU

	public function allocBuffer( vertices : Int, stride : Int, flags : BufferFlags ) : h3d.Buffer {
		return new h3d.Buffer(vertices, stride,
			switch( flags ) {
				case Dynamic: [Dynamic];
				case UniformDynamic: [UniformBuffer,Dynamic];
				case RawFormat: [RawFormat];
				case RawQuads: [Quads, RawFormat];
			});
	}

	public function ofFloats( v : hxd.FloatBuffer, stride : Int, flags : BufferFlags ) {
		var nvert = Std.int(v.length / stride);
		var b = allocBuffer(nvert, stride, flags);
		b.uploadVector(v, 0, nvert);
		return b;
	}

	public function disposeBuffer( b : h3d.Buffer ) {
		b.dispose();
	}

	public function allocIndexBuffer( count : Int ) {
		return new h3d.Indexes(count);
	}

	public function ofIndexes( ib: hxd.IndexBuffer, length = -1) {
		if( length < 0 && ib != null ) length = ib.length;
		var idx = allocIndexBuffer( length );
		idx.upload(ib, 0, length);
		return idx;
	}

	public function disposeIndexBuffer( i : h3d.Indexes ) {
		i.dispose();
	}

	public function onContextLost() {
	}

	// CPU

	public function allocFloats( count : Int ) : hxd.FloatBuffer {
		return new hxd.FloatBuffer(count);
	}

	public function disposeFloats( f : hxd.FloatBuffer ) {
	}

	public function allocIndexes( count : Int ) {
		return new hxd.IndexBuffer(count);
	}

	public function disposeIndexes( i : hxd.IndexBuffer ) {
	}

	static var inst : Allocator;
	public static function set( a : Allocator ) {
		inst = a;
	}
	public static function get() : Allocator {
		if( inst == null ) inst = new Allocator();
		return inst;
	}

}
