package h3d.impl;

#if flash
private typedef WeakMap<K,T> = haxe.ds.WeakMap<K,T>;
#else
private typedef WeakMap<K,T> = haxe.ds.ObjectMap<K,T>;
#end

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

	var mem : MemoryManager;
	var stride : Int;
	var size : Int;
	
	var vbuf : Driver.VertexBuffer;
	var free : FreeCell;
	var next : BigBuffer;
	#if debug
	public var allocHead : Buffer;
	#end
	
	function new(mem, v, stride, size) {
		this.mem = mem;
		this.size = size;
		this.stride = stride;
		this.vbuf = v;
		this.free = new FreeCell(0,size,null);
	}

	function freeCursor( pos:Int, nvect:Int ) {
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
		mem.driver.disposeVertex(vbuf);
		vbuf = null;
	}
	
	function isDisposed() {
		return vbuf == null;
	}

}

class MemoryManager {

	static inline var MAX_MEMORY = 250 << 20; // MB
	static inline var MAX_BUFFERS = 4096;

	@:allow(h3d)
	var driver : Driver;
	var buffers : Array<BigBuffer>;
	var idict : Map<Indexes,Bool>;
	
	var tdict : WeakMap<h3d.mat.Texture,Driver.Texture>;
	var textures : Array<Driver.Texture>;
	
	public var indexes(default,null) : Indexes;
	public var quadIndexes(default,null) : Indexes;
	public var usedMemory(default,null) : Int;
	public var bufferCount(default,null) : Int;
	public var allocSize(default,null) : Int;

	public function new(driver,allocSize) {
		this.driver = driver;
		this.allocSize = allocSize;

		idict = new Map();
		tdict = new WeakMap();
		textures = new Array();
		buffers = new Array();
		
		initIndexes();
	}
	
	function initIndexes() {
		var indices = new hxd.IndexBuffer();
		for( i in 0...allocSize ) indices.push(i);
		indexes = allocIndex(indices);

		var indices = new hxd.IndexBuffer();
		var p = 0;
		for( i in 0...allocSize >> 2 ) {
			var k = i << 2;
			indices.push(k);
			indices.push(k + 1);
			indices.push(k + 2);
			indices.push(k + 2);
			indices.push(k + 1);
			indices.push(k + 3);
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
			var b = buffers[i], prev : BigBuffer = null;
			while( b != null ) {
				if( b.free.count == b.size ) {
					b.dispose();
					bufferCount--;
					usedMemory -= b.size * b.stride * 4;
					if( prev == null )
						buffers[i] = b.next;
					else
						prev.next = b.next;
				} else
					prev = b;
				b = b.next;
			}
		}
	}

	public function stats() {
		var total = 0, free = 0, count = 0;
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				total += b.stride * b.size * 4;
				var f = b.free;
				while( f != null ) {
					free += f.count * b.stride * 4;
					f = f.next;
				}
				count++;
				b = b.next;
			}
		}
		freeTextures();
		var tcount = 0, tmem = 0;
		for( t in tdict.keys() ) {
			tcount++;
			tmem += t.width * t.height * 4;
		}
		return {
			bufferCount : count,
			freeMemory : free,
			totalMemory : total,
			textureCount : tcount,
			textureMemory : tmem,
		};
	}

	public function allocStats() : Array<{ file : String, line : Int, count : Int, tex : Bool, size : Int }> {
		#if !debug
		return [];
		#else
		var h = new Map();
		var all = [];
		for( buf in buffers ) {
			var buf = buf;
			while( buf != null ) {
				var b = buf.allocHead;
				while( b != null ) {
					var key = b.allocPos.fileName + ":" + b.allocPos.lineNumber;
					var inf = h.get(key);
					if( inf == null ) {
						inf = { file : b.allocPos.fileName, line : b.allocPos.lineNumber, count : 0, size : 0, tex : false };
						h.set(key, inf);
						all.push(inf);
					}
					inf.count++;
					inf.size += b.nvert * b.b.stride * 4;
					b = b.allocNext;
				}
				buf = buf.next;
			}
		}
		for( t in tdict.keys() ) {
			var key = "$"+t.allocPos.fileName + ":" + t.allocPos.lineNumber;
			var inf = h.get(key);
			if( inf == null ) {
				inf = { file : t.allocPos.fileName, line : t.allocPos.lineNumber, count : 0, size : 0, tex : true };
				h.set(key, inf);
				all.push(inf);
			}
			inf.count++;
			inf.size += t.width * t.height * 4;
		}
		all.sort(function(a, b) return a.size == b.size ? a.line - b.line : b.size - a.size);
		return all;
		#end
	}
	
	function newTexture(fmt, w, h, cubic, target, mm, allocPos) {
		var t = new h3d.mat.Texture(this, fmt, w, h, cubic, target, mm);
		#if debug
		t.allocPos = allocPos;
		#end
		initTexture(t);
		return t;
	}
	
	function initTexture( t : h3d.mat.Texture ) {
		t.t = driver.allocTexture(t);
		tdict.set(t, t.t);
		textures.push(t.t);
	}

	@:allow(h3d.impl.Indexes.dispose)
	function deleteIndexes( i : Indexes ) {
		idict.remove(i);
		driver.disposeIndexes(i.ibuf);
		i.ibuf = null;
		usedMemory -= i.count * 2;
	}
	
	@:allow(h3d.mat.Texture.dispose)
	function deleteTexture( t : h3d.mat.Texture ) {
		textures.remove(t.t);
		tdict.remove(t);
		driver.disposeTexture(t.t);
		t.t = null;
	}

	@:allow(h3d.mat.Texture.resize)
	function resizeTexture( t : h3d.mat.Texture, width, height ) {
		t.dispose();
		t.width = width;
		t.height = height;
		initTexture(t);
	}
	
	public function readAtfHeader( data : haxe.io.Bytes ) {
		var cubic = (data.get(6) & 0x80) != 0;
		var alpha = false, compress = false;
		switch( data.get(6) & 0x7F ) {
		case 0:
		case 1: alpha = true;
		case 2: compress = true;
		case 3, 4: alpha = true; compress = true;
		case f: throw "Invalid ATF format " + f;
		}
		var width = 1 << data.get(7);
		var height = 1 << data.get(8);
		var mips = data.get(9) - 1;
		return {
			width : width,
			height : height,
			cubic : cubic,
			alpha : alpha,
			compress : compress,
			mips : mips,
		};
	}

	public function allocCustomTexture( fmt : h3d.mat.Data.TextureFormat, width : Int, height : Int, mipLevels : Int = 0, cubic : Bool = false, target : Bool = false, ?allocPos : AllocPos ) {
		freeTextures();
		return newTexture(fmt, width, height, cubic, target, mipLevels, allocPos);
	}
	
	public function allocTexture( width : Int, height : Int, ?mipMap = false, ?allocPos : AllocPos ) {
		freeTextures();
		var levels = 0;
		if( mipMap ) {
			while( width > (1 << levels) && height > (1 << levels) )
				levels++;
		}
		return newTexture(Rgba, width, height, false, false, levels, allocPos);
	}
	
	public function allocTargetTexture( width : Int, height : Int, ?allocPos : AllocPos ) {
		freeTextures();
		return newTexture(Rgba, width, height, false, true, 0, allocPos);
	}

	public function allocCubeTexture( size : Int, ?mipMap = false, ?allocPos : AllocPos ) {
		freeTextures();
		var levels = 0;
		if( mipMap ) {
			while( size > (1 << levels) )
				levels++;
		}
		return newTexture(Rgba, size, size, true, false, levels, allocPos);
	}

	//TODO remove pos
	public function allocIndex( indices : hxd.IndexBuffer, pos = 0, count = -1 ) {
		if( count < 0 ) count = indices.length;
		var ibuf = driver.allocIndexes(count);
		var idx = new Indexes(this, ibuf, count);
		idx.upload(indices, 0, count);
		idict.set(idx, true);
		usedMemory += idx.count * 2;
		return idx;
	}

	public function allocBytes( bytes : haxe.io.Bytes, stride : Int, align, ?allocPos : AllocPos ) {
		var count = Std.int(bytes.length / (stride * 4));
		var b = alloc(count, stride, align, allocPos);
		b.uploadBytes(bytes, 0, count);
		return b;
	}

	public function allocVector( v : hxd.FloatBuffer, stride, align, ?allocPos : AllocPos ) {
		var nvert = Std.int(v.length / stride);
		var b = alloc(nvert, stride, align, allocPos);
		b.uploadVector(v, 0, nvert);
		return b;
	}
	
	/**
		This will automatically free all textures which are no longer referenced / have been GC'ed.
		This is called before each texture allocation as well.
		Returns the number of textures freed that way.
	 **/
	public function freeTextures() {
		var tall = new Map();
		for( t in textures )
			tall.set(t, true);
		for( t in tdict )
			tall.remove(t);
		var count = 0;
		for( t in tall.keys() ) {
			driver.disposeTexture(t);
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
	public function alloc( nvect : Int, stride, align, ?allocPos : AllocPos ) {
		var b = buffers[stride], free = null;
		if( nvect == 0 && align == 0 )
			align = 3;
		while( b != null ) {
			free = b.free;
			while( free != null ) {
				if( free.count >= nvect ) {
					// align 0 must be on first index
					if( align == 0 ) {
						if( free.pos != 0 )
							free = null;
						break;
					} else {
						// we can't alloc into a smaller buffer because we might use preallocated indexes
						if( b.size != allocSize ) {
							free = null;
							break;
						}
						var d = (align - (free.pos % align)) % align;
						if( d == 0 )
							break;
							
						// insert some padding
						if( free.count >= nvect + d ) {
							free.next = new FreeCell(free.pos + d, free.count - d, free.next);
							free.count = d;
							free = free.next;
							break;
						}
					}
					break;
				}
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
					// skip not aligned buffers
					if( b.size != allocSize )
						free = null;
					while( free != null ) {
						if( free.count >= size ) {
							// check alignment
							var d = (align - (free.pos % align)) % align;
							if( d == 0 )
								break;
							// insert some padding
							if( free.count >= size + d ) {
								free.next = new FreeCell(free.pos + d, free.count - d, free.next);
								free.count = d;
								free = free.next;
								break;
							}
						}
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
				if( size > 0xFFFF ) throw "Too many vertex to allocate "+size;
			} else
				size = allocSize; // group allocations together to minimize buffer count
			var mem = size * stride * 4, v = null;
			if( usedMemory + mem > MAX_MEMORY || bufferCount >= MAX_BUFFERS || (v = driver.allocVertex(size,stride)) == null ) {
				var size = usedMemory - freeMemory();
				garbage();
				cleanBuffers();
				if( usedMemory - freeMemory() == size ) {
					if( bufferCount >= MAX_BUFFERS )
						throw "Too many buffer";
					throw "Memory full";
				}
				return alloc(nvect, stride, align, allocPos);
			}
			usedMemory += mem;
			bufferCount++;
			b = new BigBuffer(this, v, stride, size);
			#if flash
			untyped v.b = b;
			#end
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
		#if debug
		var head = b.b.allocHead;
		b.allocPos = allocPos;
		b.allocNext = head;
		if( head != null ) head.allocPrev = b;
		b.b.allocHead = b;
		#end
		if( nvect > 0 )
			b.next = this.alloc(nvect, stride, align #if debug, allocPos #end);
		return b;
	}

	public function onContextLost() {
		indexes.dispose();
		quadIndexes.dispose();
		var tkeys = Lambda.array({ iterator : tdict.keys });
		for( t in tkeys ) {
			if( !tdict.exists(t) )
				continue;
			if( t.onContextLost == null )
				t.dispose();
			else {
				textures.remove(t.t);
				initTexture(t);
				t.onContextLost();
			}
		}
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				b.dispose();
				b = b.next;
			}
		}
		for( i in idict.keys() )
			i.dispose();
		buffers = [];
		bufferCount = 0;
		usedMemory = 0;
		initIndexes();
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
		for( i in idict.keys() )
			i.dispose();
		buffers = [];
		bufferCount = 0;
		usedMemory = 0;
	}

}