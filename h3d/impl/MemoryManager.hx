package h3d.impl;

class FreeCell {
	public var pos : Int;
	public var count : Int;
	public var next : FreeCell;
	public function new(pos,count,next) {
		this.pos = pos;
		this.count = count;
		this.next = next;
	}
}

class BigBuffer {

	public var stride : Int;
	public var written : Bool;
	public var vbuf : flash.display3D.VertexBuffer3D;
	public var free : FreeCell;
	public var next : BigBuffer;

	public function new(v, stride, size) {
		written = false;
		this.stride = stride;
		this.vbuf = v;
		this.free = new FreeCell(0,size,null);
	}
	
	public function freeCursor( pos, nvect ) {
		var prev : FreeCell = null;
		var f = free;
		var end = pos + nvect;
		while( f != null ) {
			if( f.pos == end ) {
				f.pos -= nvect;
				f.count += nvect;
				if( prev != null && prev.pos + prev.count == f.pos ) {
					prev.count += f.count;
					prev.next = f.next;
				}
				return;
			}
			if( f.pos > end ) {
				var n = new FreeCell(pos, nvect, f);
				if( prev == null ) free = n else prev.next = n;
				return;
			}
			prev = f;
			f = f.next;
		}
		throw "assert";
	}
	
	public function dispose() {
		vbuf.dispose();
		vbuf = null;
	}

}

class MemoryManager {

	static inline var MAX_MEMORY = 250 << 20; // MB
	
	var ctx : flash.display3D.Context3D;
	var empty : flash.utils.ByteArray;
	public var buffers : Array<BigBuffer>;
	public var indexes : Indexes;
	public var usedMemory : Int;
	public var allocSize : Int;
	
	public function new(ctx,allocSize) {
		this.ctx = ctx;
		this.allocSize = allocSize;
				
		empty = new flash.utils.ByteArray();
		buffers = new Array();
		
		var indices = new flash.Vector<UInt>();
		for( i in 0...allocSize ) indices[i] = i;
		indexes = allocIndex(indices);
	}
	
	public dynamic function garbage() {
	}
	
	public function stats() {
		var total = 0, free = 0, count = 0;
		return {
			bufferCount : count,
			freeMemory : free,
			totalMemory : total,
		};
	}
	
	public function allocTexture( width : Int, height : Int ) {
		return new h3d.mat.Texture(ctx.createTexture(width, height, flash.display3D.Context3DTextureFormat.BGRA, false), false);
	}
	
	public function allocCubeTexture( size : Int ) {
		return new h3d.mat.Texture(ctx.createCubeTexture(size, flash.display3D.Context3DTextureFormat.BGRA, false), true);
	}
	
	public function allocIndex( indices : flash.Vector<UInt> ) {
		var ibuf = ctx.createIndexBuffer(indices.length);
		ibuf.uploadFromVector(indices, 0, indices.length);
		return new Indexes(ibuf,indices.length);
	}
	
	public function alloc( bytes : flash.utils.ByteArray, stride : Int, allowSplit = true ) {
		var b = allocSub(Std.int(bytes.length / (stride * 4)), stride, allowSplit);
		var tmp = b;
		var pos = 0;
		while( tmp != null ) {
			tmp.b.vbuf.uploadFromByteArray(bytes, pos, tmp.pos, tmp.nvect);
			pos += tmp.nvect * stride * 4;
			tmp = tmp.next;
		}
		return b;
	}
	
	public function allocVector( v : flash.Vector<Float>, stride : Int, allowSplit = true ) {
		var b = allocSub(Std.int(v.length / stride), stride, allowSplit);
		var tmp = b;
		var pos = 0;
		while( tmp != null ) {
			tmp.b.vbuf.uploadFromVector( pos == 0 ? v : v.slice(pos,tmp.nvect+pos), tmp.pos, tmp.nvect);
			pos += tmp.nvect * stride;
			tmp = tmp.next;
		}
		return b;
	}
	
	public function allocSub( nvect, stride, split ) {
		var b = buffers[stride], free = null;
		while( b != null ) {
			free = b.free;
			while( free != null ) {
				if( free.count >= nvect )
					break;
				free = free.next;
			}
			if( free != null ) break;
			b = b.next;
		}
		// second try : half size
		if( b == null && split ) {
			b = buffers[stride];
			while( b != null ) {
				free = b.free;
				while( free != null ) {
					if( free.count >= nvect>>1 )
						break;
					free = free.next;
				}
				if( free != null ) break;
				b = b.next;
			}
		}
		// buffer not found : allocate a new one
		if( b == null ) {
			var mem = allocSize * stride * 4;
			if( usedMemory + mem > MAX_MEMORY ) {
				garbage();
				if( usedMemory + mem > MAX_MEMORY )
					throw "Memory Full";
				return allocSub(nvect, stride, split);
			}
			var v = ctx.createVertexBuffer(allocSize, stride);
			usedMemory += mem;
			b = new BigBuffer(v, stride, allocSize);
			b.next = buffers[stride];
			buffers[stride] = b;
			free = b.free;
		}
		var alloc = nvect > free.count ? free.count : nvect;
		var fpos = free.pos;
		free.pos += alloc;
		free.count -= alloc;
		var b = new Buffer(b, fpos, alloc);
		nvect -= alloc;
		if( nvect > 0 )
			b.next = this.allocSub(nvect, stride, split);
		return b;
	}
	
	public function finalize( b : BigBuffer ) {
		if( !b.written ) {
			b.written = true;
			if( b.free.count > 0 ) {
				var mem : UInt = b.free.count * b.stride * 4;
				if( empty.length < mem ) empty.length = mem;
				b.vbuf.uploadFromByteArray(empty, 0, b.free.pos, b.free.count);
			}
		}
	}
	
	public function dispose() {
		indexes.dispose();
		indexes = null;
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				b.vbuf.dispose();
				b = b.next;
			}
		}
		buffers = [];
	}
	
}