package h3d;

@:allow(h3d.impl.MemoryManager)
@:allow(h3d.Engine)
class Indexes {

	var mem : h3d.impl.MemoryManager;
	var ibuf : h3d.impl.Driver.IndexBuffer;
	public var count(default,null) : Int;
	
	function new(mem, ibuf, count) {
		this.mem = mem;
		this.ibuf = ibuf;
		this.count = count;
	}
	
	public function isDisposed() {
		return ibuf == null;
	}
	
	public function upload( indexes : hxd.IndexBuffer, pos : Int, count : Int, bufferPos = 0 ) {
		mem.driver.uploadIndexesBuffer(this.ibuf, pos, count, indexes, bufferPos);
	}
	
	public function dispose() {
		if( ibuf != null )
			mem.deleteIndexes(this);
	}

}