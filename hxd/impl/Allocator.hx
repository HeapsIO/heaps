package hxd.impl;

enum abstract BufferFlags(Int) {
	public var Dynamic = 0;
	public var Static = 1;
	public var UniformDynamic = 2;
	public inline function toInt() : Int {
		return this;
	}
}

class Allocator {

	public function new() {
	}

	// GPU

	public function allocBuffer( vertices : Int, format, flags : BufferFlags = Dynamic ) : h3d.Buffer {
		return new h3d.Buffer(vertices, format,
			switch( flags ) {
			case Static: null;
			case Dynamic: [Dynamic];
			case UniformDynamic: [UniformBuffer,Dynamic];
			});
	}

	public function ofFloats( v : hxd.FloatBuffer, format : hxd.BufferFormat, flags : BufferFlags = Dynamic ) {
		var nvert = Std.int(v.length / format.stride);
		return ofSubFloats(v, nvert, format, flags);
	}

	public function ofSubFloats( v : hxd.FloatBuffer, vertices : Int, format, flags : BufferFlags = Dynamic ) {
		var b = allocBuffer(vertices, format, flags);
		b.uploadFloats(v, 0, vertices);
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
		idx.uploadIndexes(ib, 0, length);
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
