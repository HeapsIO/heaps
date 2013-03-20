package h3d.impl;

@:allow(h3d.impl.MemoryManager)
class Indexes {

	var mem : MemoryManager;
	public var ibuf : flash.display3D.IndexBuffer3D;
	public var count(default,null) : Int;
	
	function new(mem, ibuf, count) {
		this.mem = mem;
		this.ibuf = ibuf;
		this.count = count;
	}
	
	public function isDisposed() {
		return ibuf == null;
	}
	
	public function dispose() {
		if( ibuf != null )
			mem.deleteIndexes(this);
	}

}