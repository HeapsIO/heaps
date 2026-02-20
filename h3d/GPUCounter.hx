package h3d;

class GPUCounter {
	public var buffer(default, null) : h3d.Buffer;
	var accessor : haxe.io.Bytes;
	var size : Int;

	public function new( size : Int = 1 ) {
		this.size = size;
		var alloc = hxd.impl.Allocator.get();
		buffer = alloc.allocBuffer(size, hxd.BufferFormat.INDEX32, UniformReadWrite);
		accessor = haxe.io.Bytes.alloc(size << 2);
	}

	public function dispose(){
		var alloc = hxd.impl.Allocator.get();
		alloc.disposeBuffer(buffer);
	}

	public function getAll() : Array<Int> {
		buffer.readBytes(accessor, 0, size, 0);
		var res = [];
		res.resize(size);
		for ( i in 0...size )
			res[i] = accessor.getInt32(i << 2);
		return res;
	}

	public function get( index : Int = 0 ) : Int {
		buffer.readBytes(accessor, 0, 1, index);
		return accessor.getInt32(0);
	}

	public function reset() {
		for ( i in 0...size )
			accessor.setInt32(i << 2, 0);
		buffer.uploadBytes(accessor, 0, size);
	}
}