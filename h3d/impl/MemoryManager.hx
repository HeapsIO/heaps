package h3d.impl;

@:allow(h3d)
class FreeCell {
	var pos : Int;
	var count : Int;
	var next : FreeCell;
	function new(pos,count,next) {
		this.pos = pos;
		this.count = count;
		this.next = next;
	}
}

@:allow(h3d)
class BigBuffer {

	var stride : Int;
	var size : Int;
	var written : Bool;
	var vbuf : flash.display3D.VertexBuffer3D;
	var free : FreeCell;
	var next : BigBuffer;
	
	function new(v, stride, size) {
		written = false;
		this.size = size;
		this.stride = stride;
		this.vbuf = v;
		this.free = new FreeCell(0,size,null);
	}

	function freeCursor( pos, nvect ) {
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
				if( prev != null && prev.pos + prev.count == pos )
					prev.count += nvect;
				else {
					var n = new FreeCell(pos, nvect, f);
					if( prev == null ) free = n else prev.next = n;
				}
				return;
			}
			prev = f;
			f = f.next;
		}
		if( nvect != 0 )
			throw "assert";
	}

	function dispose() {
		vbuf.dispose();
		vbuf = null;
	}

}

class MemoryManager {

	static inline var MAX_MEMORY = 250 << 20; // MB
	static inline var MAX_BUFFERS = 4096;

	var ctx : flash.display3D.Context3D;
	var empty : flash.utils.ByteArray;
	var buffers : Array<BigBuffer>;
	
	var tdict : flash.utils.TypedDictionary<h3d.mat.Texture,flash.display3D.textures.TextureBase>;
	var textures : Array<flash.display3D.textures.TextureBase>;
	
	public var indexes(default,null) : Indexes;
	public var quadIndexes(default,null) : Indexes;
	public var usedMemory(default,null) : Int;
	public var bufferCount(default,null) : Int;
	public var allocSize(default,null) : Int;

	public function new(ctx,allocSize) {
		this.ctx = ctx;
		this.allocSize = allocSize;

		tdict = new flash.utils.TypedDictionary(true);
		textures = new Array();
		empty = new flash.utils.ByteArray();
		buffers = new Array();

		var indices = new flash.Vector<UInt>();
		for( i in 0...allocSize ) indices[i] = i;
		indexes = allocIndex(indices);

		var indices = new flash.Vector<UInt>();
		var p = 0;
		for( i in 0...allocSize >> 2 ) {
			var k = i << 2;
			indices[p++] = k;
			indices[p++] = k + 1;
			indices[p++] = k + 2;
			indices[p++] = k + 2;
			indices[p++] = k + 1;
			indices[p++] = k + 3;
		}
		quadIndexes = allocIndex(indices);
	}

	/**
		Call user-defined garbage function that will cleanup some unused allocated objects.
		Might be called several times if we need to allocate a lot of memory
	**/
	public dynamic function garbage() {
	}

	/**
		Clean empty (unused) buffers
	**/
	public function cleanBuffers() {
		for( i in 0...buffers.length ) {
			var b = buffers[i], prev = null;
			while( b != null ) {
				if( b.free.count == b.size ) {
					b.dispose();
					bufferCount--;
					usedMemory -= b.size * b.stride * 4;
					if( prev == null )
						buffers[i] = b.next;
					else
						prev.next = b.next;
				}
				b = b.next;
			}
		}
	}

	public function stats() {
		var total = 0, free = 0, count = 0;
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				total += b.stride * allocSize * 4;
				var f = b.free;
				while( f != null ) {
					free += f.count * b.stride * 4;
					f = f.next;
				}
				count++;
				b = b.next;
			}
		}
		return {
			bufferCount : count,
			freeMemory : free,
			totalMemory : total,
		};
	}
		
	function newTexture(t, w, h, cubic) {
		var t = new h3d.mat.Texture(this, t, w, h, cubic);
		tdict.set(t, t.t);
		textures.push(t.t);
		return t;
	}

	@:allow(h3d.mat.Texture.dispose)
	function deleteTexture( t : h3d.mat.Texture ) {
		textures.remove(t.t);
		tdict.delete(t);
		t.t.dispose();
		t.t = null;
	}
	
	public function allocTexture( width : Int, height : Int ) {
		freeTextures();
		return newTexture(ctx.createTexture(width, height, flash.display3D.Context3DTextureFormat.BGRA, false), width, height, false);
	}

	public function allocTargetTexture( width : Int, height : Int ) {
		freeTextures();
		return newTexture(ctx.createTexture(width, height, flash.display3D.Context3DTextureFormat.BGRA, true), width, height, false);
	}

	public function makeTexture( ?bmp : flash.display.BitmapData, ?mbmp : h3d.mat.Bitmap ) {
		var t;
		if( bmp != null ) {
			t = allocTexture(bmp.width, bmp.height);
			t.upload(bmp);
			bmp.dispose();
		} else {
			t = allocTexture(mbmp.width, mbmp.height);
			t.uploadBytes(mbmp.bytes);
		}
		return t;
	}

	public function allocCubeTexture( size : Int ) {
		freeTextures();
		return newTexture(ctx.createCubeTexture(size, flash.display3D.Context3DTextureFormat.BGRA, false), size, size, true);
	}

	public function allocIndex( indices : flash.Vector<UInt> ) {
		var ibuf = ctx.createIndexBuffer(indices.length);
		ibuf.uploadFromVector(indices, 0, indices.length);
		return new Indexes(ibuf,indices.length);
	}

	public function allocBytes( bytes : flash.utils.ByteArray, stride : Int, align ) {
		var count = Std.int(bytes.length / (stride * 4));
		var b = alloc(count, stride, align);
		b.upload(bytes, 0, count);
		return b;
	}

	public function allocVector( v : flash.Vector<Float>, stride, align ) {
		var b = alloc(Std.int(v.length / stride), stride, align);
		var tmp = b;
		var pos = 0;
		while( tmp != null ) {
			tmp.b.vbuf.uploadFromVector( pos == 0 ? v : v.slice(pos,tmp.nvert*stride+pos), tmp.pos, tmp.nvert);
			pos += tmp.nvert * stride;
			tmp = tmp.next;
		}
		return b;
	}
	
	/**
		This will automatically free all textures which are no longer referenced / have been GC'ed.
		This is called before each texture allocation as well.
		Returns the number of textures freed that way.
	 **/
	public function freeTextures() {
		var tall = new flash.utils.TypedDictionary();
		for( t in textures )
			tall.set(t, true);
		for( t in tdict )
			tall.delete(tdict.get(t));
		var count = 0;
		for( t in tall ) {
			t.dispose();
			textures.remove(t);
			count++;
		}
		return count;
	}

	/**
		The amount of free buffers memory
	 **/
	function freeMemory() {
		var size = 0;
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				var free = b.free;
				while( free != null ) {
					size += free.count * b.stride * 4;
					free = free.next;
				}
				b = b.next;
			}
		}
		return size;
	}

	/**
		Allocate a vertex buffer.
		Align represent the number of vertex that represent a single primitive : 3 for triangles, 4 for quads
		You can use 0 to allocate your own buffer but in that case you can't use pre-allocated indexes/quadIndexes
	 **/
	public function alloc( nvect, stride, align ) {
		var b = buffers[stride], free = null;
		while( b != null ) {
			free = b.free;
			while( free != null ) {
				if( free.count >= nvect && (free.pos == 0 || (align > 0 && free.pos % align == 0)) )
					break;
				free = free.next;
			}
			if( free != null ) break;
			b = b.next;
		}
		// try splitting big groups
		if( b == null && align > 0 ) {
			var size = nvect;
			while( size > 1000 ) {
				b = buffers[stride];
				size >>= 1;
				size -= size % align;
				while( b != null ) {
					free = b.free;
					while( free != null ) {
						if( free.count >= size && free.pos % align == 0 )
							break;
						free = free.next;
					}
					if( free != null ) break;
					b = b.next;
				}
				if( b != null ) break;
			}
		}
		// buffer not found : allocate a new one
		if( b == null ) {
			var size;
			if( align == 0 ) {
				size = nvect;
				if( size > allocSize ) throw "Too many vertex to allocate "+size;
			} else
				size = allocSize; // group allocations together to minimize buffer count
			var mem = size * stride * 4;
			if( usedMemory + mem > MAX_MEMORY || bufferCount >= MAX_BUFFERS ) {
				var size = freeMemory();
				garbage();
				cleanBuffers();
				if( bufferCount >= MAX_BUFFERS )
					throw "Too many buffer";
				if( freeMemory() == size )
					throw "Memory full";
				return alloc(nvect, stride, align);
			}
			var v = ctx.createVertexBuffer(size, stride);
			usedMemory += mem;
			bufferCount++;
			b = new BigBuffer(v, stride, size);
			b.next = buffers[stride];
			buffers[stride] = b;
			free = b.free;
		}
		// always alloc multiples of 4 (prevent quad split)
		var alloc = nvect > free.count ? free.count - (free.count%align) : nvect;
		var fpos = free.pos;
		free.pos += alloc;
		free.count -= alloc;
		var b = new Buffer(b, fpos, alloc);
		nvect -= alloc;
		if( nvect > 0 )
			b.next = this.alloc(nvect, stride, align);
		return b;
	}

	@:allow(h3d)
	function finalize( b : BigBuffer ) {
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
		quadIndexes.dispose();
		quadIndexes = null;
		for( t in tdict.keys() )
			t.dispose();
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				b.dispose();
				b = b.next;
			}
		}
		buffers = [];
		bufferCount = 0;
		usedMemory = 0;
	}

}