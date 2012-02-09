package h3d.impl;

class Buffer {

	public var b : MemoryManager.BigBuffer;
	public var pos : Int;
	public var nvect : Int;
	public var next : Buffer;
	
	public function new(b, pos, nvect) {
		this.b = b;
		this.pos = pos;
		this.nvect = nvect;
	}

	public function dispose() {
		b.freeCursor(pos, nvect);
		b = null;
		if( next != null ) next.dispose();
	}
	
}