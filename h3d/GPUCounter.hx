package h3d;

class GPUCounter {
	public var buffer(default, null) : h3d.Buffer;
	var accessor : haxe.io.Bytes;

	public function new() {
		buffer = new h3d.Buffer(1,hxd.BufferFormat.INDEX32, [ReadWriteBuffer]);
		accessor = haxe.io.Bytes.alloc(4);
	}

	public function dispose(){
		buffer.dispose();
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