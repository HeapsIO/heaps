package h3d;

@:allow(h3d.impl.Driver)
class BufferHandle {
	public var buffer(default, null) : h3d.Buffer;
	public var handle(default, null) : Int;
	function new(b : h3d.Buffer, handle : Int) {
		buffer = b;
		this.handle = handle;
	}
}