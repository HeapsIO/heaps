package h3d;

@:allow(h3d.impl.MemoryManager)
@:allow(h3d.Engine)
class Indexes {

	var mem : h3d.impl.MemoryManager;
	var ibuf : h3d.impl.Driver.IndexBuffer;
	public var count(default,null) : Int;

	public function new(count) {
		this.mem = h3d.Engine.getCurrent().mem;
		this.count = count;
		mem.allocIndexes(this);
	}

	public function isDisposed() {
		return ibuf == null;
	}

	public function upload( indexes : hxd.IndexBuffer, pos : Int, count : Int, bufferPos = 0 ) {
		mem.driver.uploadIndexBuffer(this.ibuf, pos, count, indexes, bufferPos);
	}

	public function dispose() {
		if( ibuf != null )
			mem.deleteIndexes(this);
	}

	public static function alloc( i : hxd.IndexBuffer ) {
		var idx = new Indexes( i.length );
		idx.upload(i, 0, i.length);
		return idx;
	}

}