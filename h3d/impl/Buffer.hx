package h3d.impl;

class Buffer {

	public var b : MemoryManager.BigBuffer;
	public var pos : Int;
	public var nvert : Int;
	public var next : Buffer;
	#if debug
	public var allocPos : AllocPos;
	public var allocNext : Buffer;
	public var allocPrev : Buffer;
	#end
	
	public function new(b, pos, nvert) {
		this.b = b;
		this.pos = pos;
		this.nvert = nvert;
	}

	public function dispose() {
		if( b != null ) {
			b.freeCursor(pos, nvert);
			#if debug
			if( allocNext != null )
				allocNext.allocPrev = allocPrev;
			if( allocPrev != null )
				allocPrev.allocNext = allocNext;
			if( b.allocHead == this )
				b.allocHead = allocNext;
			#end
			b = null;
			if( next != null ) next.dispose();
		}
	}
	
	public function uploadVector( data : flash.Vector<Float>, dataPos : Int, nverts : Int ) {
		var cur = this;
		while( nverts > 0 ) {
			if( cur == null ) throw "Too many vertexes";
			var count = nverts > cur.nvert ? cur.nvert : nverts;
			cur.b.vbuf.uploadFromVector( dataPos == 0 ? data : data.slice(dataPos,count*b.stride+dataPos), cur.pos, count );
			dataPos += count * b.stride;
			nverts -= count;
			cur = cur.next;
		}
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

class BufferOffset {
	public var b : Buffer;
	public var offset : Int;
	public function new(b, offset) {
		this.b = b;
		this.offset = offset;
	}
	public function dispose() {
		if( b != null ) {
			b.dispose();
			b = null;
		}
	}
}