package hxd.impl;
import h3d.impl.AllocPos;

@:enum abstract BufferFlags(Int) {
	public var Dynamic = 0;
	public var UniformDynamic = 1;
	public inline function toInt() : Int {
		return this;
	}
}

class Allocator {

	public function new() {
	}

	// GPU

	public function allocBuffer( vertices : Int, stride : Int, flags : BufferFlags, ?pos : AllocPos ) : h3d.Buffer {
		return new h3d.Buffer(vertices, stride, switch( flags ) { case Dynamic: [Dynamic]; case UniformDynamic: [UniformBuffer,Dynamic]; }, pos);
	}

	public function disposeBuffer( b : h3d.Buffer ) {
		b.dispose();
	}

	public function allocIndexBuffer( count : Int ) {
		return new h3d.Indexes(count);
	}

	public function disposeIndexBuffer( i : h3d.Indexes ) {
		i.dispose();
	}

	// CPU

	public function allocFloats( count : Int, ?pos : AllocPos ) : hxd.FloatBuffer {
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
