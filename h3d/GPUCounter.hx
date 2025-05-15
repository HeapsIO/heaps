package h3d;

class GPUCounter {
	public var buffer(default, null) : h3d.Buffer;
	var accessor : haxe.io.Bytes;

	public function new() {
		var alloc = hxd.impl.Allocator.get();
		buffer = alloc.allocBuffer(1,hxd.BufferFormat.INDEX32, UniformReadWrite);
		accessor = haxe.io.Bytes.alloc(4);
	}

	public function dispose(){
		var alloc = hxd.impl.Allocator.get();
		alloc.disposeBuffer(buffer);
	}

	public function get() : Int {
		buffer.readBytes(accessor, 0, 1);
		return accessor.getInt32(0);
	}

	public function reset(){
		accessor.setInt32(0, 0);
		buffer.uploadBytes(accessor, 0,1);
	}
}