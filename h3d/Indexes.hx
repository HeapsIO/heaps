package h3d;

@:allow(h3d.impl.MemoryManager)
@:allow(h3d.Engine)
class Indexes {

	var mem : h3d.impl.MemoryManager;
	var ibuf : h3d.impl.Driver.IndexBuffer;
	public var is32(default,null) : Bool;
	public var count(default,null) : Int;
	#if track_alloc
	var allocPos : hxd.impl.AllocPos;
	#end

	public function new(count,is32=false) {
		this.mem = h3d.Engine.getCurrent().mem;
		this.count = count;
		this.is32 = is32;
		mem.allocIndexes(this);
		#if track_alloc
		allocPos = new hxd.impl.AllocPos();
		#end
	}

	public function isDisposed() {
		return ibuf == null;
	}

	public function upload( indexes : hxd.IndexBuffer, pos : Int, count : Int, bufferPos = 0 ) {
		mem.driver.uploadIndexBuffer(this.ibuf, pos, count, indexes, bufferPos);
	}

	public function uploadBytes( bytes : haxe.io.Bytes, dataPos : Int, indices : Int ) {
		mem.driver.uploadIndexBytes(this.ibuf, 0, indices, bytes, dataPos);
	}

	public function readBytes( bytes : haxe.io.Bytes, bytesPosition : Int, indices : Int, startIndice : Int = 0 ) {
		mem.driver.readIndexBytes(this.ibuf, startIndice, indices, bytes, bytesPosition);
	}

	public function dispose() {
		if( ibuf != null )
			mem.deleteIndexes(this);
	}

	public static function alloc( i : hxd.IndexBuffer, startPos = 0, length = -1 ) {
		if( length < 0 ) length = i.length;
		var idx = new Indexes( length );
		idx.upload(i, 0, length);
		return idx;
	}

}