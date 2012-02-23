package h3d.impl;

class Buffer {

	public var b : MemoryManager.BigBuffer;
	public var pos : Int;
	public var nvert : Int;
	public var next : Buffer;
	
	public function new(b, pos, nvert) {
		this.b = b;
		this.pos = pos;
		this.nvert = nvert;
	}

	public function dispose() {
		b.freeCursor(pos, nvert);
		b = null;
		if( next != null ) next.dispose();
	}
	
	public function upload( data : flash.utils.ByteArray, dataPos : Int, nverts : Int ) {
		var cur = this;
		while( nverts > 0 ) {
			if( cur == null ) throw "Too many vertexes";
			var count = nverts > cur.nvert ? cur.nvert : nverts;
			cur.b.vbuf.uploadFromByteArray(data, dataPos, cur.pos, count);
			dataPos += count * b.stride * 4;
			nverts -= count;
			cur = cur.next;
		}
	}
	
}