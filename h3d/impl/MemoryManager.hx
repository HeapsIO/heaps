package h3d.impl;

class MemoryManager {

	static inline var MAX_MEMORY = 250 << 20; // MB
	static inline var MAX_BUFFERS = 4096;
	static inline var SIZE = 65533;
	static var ALL_FLAGS = Type.allEnums(Buffer.BufferFlag);

	@:allow(h3d)
	var driver : Driver;
	var buffers : Array<ManagedBuffer>;
	var indexes : Array<Indexes>;
	var textures : Array<h3d.mat.Texture>;

	public var triIndexes(default,null) : Indexes;
	public var quadIndexes(default,null) : Indexes;
	public var usedMemory(default, null) : Int = 0;
	public var texMemory(default, null) : Int = 0;
	public var bufferCount(default,null) : Int = 0;

	public function new(driver) {
		this.driver = driver;
	}

	public function init() {
		indexes = new Array();
		textures = new Array();
		buffers = new Array();
		initIndexes();
	}

	function initIndexes() {
		var indices = new hxd.IndexBuffer();
		for( i in 0...SIZE ) indices.push(i);
		triIndexes = h3d.Indexes.alloc(indices);

		var indices = new hxd.IndexBuffer();
		var p = 0;
		for( i in 0...SIZE >> 2 ) {
			var k = i << 2;
			indices.push(k);
			indices.push(k + 1);
			indices.push(k + 2);
			indices.push(k + 2);
			indices.push(k + 1);
			indices.push(k + 3);
		}
		indices.push(SIZE);
		quadIndexes = h3d.Indexes.alloc(indices);
	}

	/**
		Call user-defined garbage function that will cleanup some unused allocated objects.
		Might be called several times if we need to allocate a lot of memory
	**/
	public dynamic function garbage() {
	}

	// ------------------------------------- BUFFERS ------------------------------------------

	/**
		Clean empty (unused) buffers
	**/
	public function cleanManagedBuffers() {
		for( i in 1...buffers.length ) {
			var b = buffers[i], prev : ManagedBuffer = null;
			while( b != null ) {
				if( b.freeList.count == b.size ) {
					b.dispose();
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

	@:allow(h3d.impl.ManagedBuffer)
	function allocManaged( m : ManagedBuffer ) {
		if( m.vbuf != null ) return;

		var mem = m.size * m.stride * 4;
		while( usedMemory + mem > MAX_MEMORY || bufferCount >= MAX_BUFFERS || (m.vbuf = driver.allocVertexes(m)) == null ) {
			var size = usedMemory - freeMemorySize();
			garbage();
			cleanManagedBuffers();
			if( usedMemory - freeMemorySize() == size ) {
				if( bufferCount >= MAX_BUFFERS )
					throw "Too many buffer";
				throw "Memory full ("+(size>>10)+" KB,"+bufferCount+" buffers)";
			}
		}
		usedMemory += mem;
		bufferCount++;
	}

	@:allow(h3d.impl.ManagedBuffer)
	function freeManaged( m : ManagedBuffer ) {
		if( m.vbuf == null ) return;
		driver.disposeVertexes(m.vbuf);
		m.vbuf = null;
		usedMemory -= m.size * m.stride * 4;
		bufferCount--;
		#if debug
		if( !m.flags.has(Managed) ) {
			var c = buffers[0], prev : ManagedBuffer = null;
			while( c != null ) {
				if( c == m ) {
					if( prev == null ) buffers[0] = m.next else prev.next = m.next;
					break;
				}
				prev = c;
				c = c.next;
			}
		}
		#end
	}

	@:allow(h3d.Buffer)
	@:access(h3d.Buffer)
	function allocBuffer( b : Buffer, stride : Int ) {
		// split big buffers
		var max = b.flags.has(Quads) ? 65532 : b.flags.has(Triangles) ? 65533 : 65534;
		if( b.vertices > max ) {
			if( max == 65534 )
				throw "Cannot split buffer with "+b.vertices+" vertices if it's not Quads/Triangles";
			var rem = b.vertices - max;
			b.vertices = max;
			// make sure to alloc in order
			allocBuffer(b, stride);

			var n = b;
			while( n.next != null ) n = n.next;

			var flags = [];
			for( f in ALL_FLAGS )
				if( b.flags.has(f) )
					flags.push(f);
			n.next = new Buffer(rem, stride, flags);
			return;
		}

		if( !b.flags.has(Managed) ) {
			var m = new ManagedBuffer(stride, b.vertices);
			#if debug
			m.next = buffers[0];
			buffers[0] = m;
			#end
			if( !m.allocBuffer(b) ) throw "assert";
			return;
		}

		// look into one of the managed buffers
		var m = buffers[stride], prev = null;
		while( m != null ) {
			if( m.allocBuffer(b) )
				return;
			prev = m;
			m = m.next;
		}

		// if quad/triangles, we are allowed to split it
		var align = b.flags.has(Triangles) ? 3 : b.flags.has(Quads) ? 4 : 0;
		if( m == null && align > 0 ) {
			var total = b.vertices;
			var size = total;
			while( size > 2048 ) {
				m = buffers[stride];
				size >>= 1;
				size -= size % align;
				b.vertices = size;
				while( m != null ) {
					if( m.allocBuffer(b) ) {
						var flags = [];
						for( f in ALL_FLAGS )
							if( b.flags.has(f) )
								flags.push(f);
						b.next = new Buffer(total - size, stride, flags);
						return;
					}
					m = m.next;
				}
			}
			b.vertices = total;
		}

		// alloc a new managed buffer
		m = new ManagedBuffer(stride, SIZE, [Managed]);
		if( prev == null )
			buffers[stride] = m;
		else
			prev.next = m;

		if( !m.allocBuffer(b) ) throw "assert";
	}

	// ------------------------------------- INDEXES ------------------------------------------

	@:allow(h3d.Indexes)
	function deleteIndexes( i : Indexes ) {
		indexes.remove(i);
		driver.disposeIndexes(i.ibuf);
		i.ibuf = null;
		usedMemory -= i.count * 2;
	}

	@:allow(h3d.Indexes)
	function allocIndexes( i : Indexes ) {
		i.ibuf = driver.allocIndexes(i.count);
		indexes.push(i);
		usedMemory += i.count * 2;
	}


	// ------------------------------------- TEXTURES ------------------------------------------

	function bpp( t : h3d.mat.Texture ) {
		return 4;
	}

	public function cleanTextures( force = true ) {
		textures.sort(sortByLRU);
		for( t in textures ) {
			if( t.realloc == null ) continue;
			if( force || t.lastFrame < h3d.Engine.getCurrent().frameCount - 3600 ) {
				t.dispose();
				return true;
			}
		}
		return false;
	}

	function sortByLRU( t1 : h3d.mat.Texture, t2 : h3d.mat.Texture ) {
		return t1.lastFrame - t2.lastFrame;
	}

	@:allow(h3d.mat.Texture.dispose)
	function deleteTexture( t : h3d.mat.Texture ) {
		textures.remove(t);
		driver.disposeTexture(t);
		texMemory -= t.width * t.height * bpp(t);
	}

	@:allow(h3d.mat.Texture.alloc)
	function allocTexture( t : h3d.mat.Texture ) {
		var free = cleanTextures(false);
		t.t = driver.allocTexture(t);
		if( t.t == null ) {
			if( !cleanTextures(true) ) throw "Maximum texture memory reached";
			allocTexture(t);
			return;
		}
		textures.push(t);
		texMemory += t.width * t.height * bpp(t);
	}

	// ------------------------------------- DISPOSE ------------------------------------------

	public function onContextLost() {
		dispose();
		initIndexes();
	}

	public function dispose() {
		triIndexes.dispose();
		quadIndexes.dispose();
		triIndexes = null;
		quadIndexes = null;
		for( t in textures.copy() )
			t.dispose();
		for( b in buffers.copy() ) {
			var b = b;
			while( b != null ) {
				b.dispose();
				b = b.next;
			}
		}
		for( i in indexes.copy() )
			i.dispose();
		buffers = [];
		indexes = [];
		textures = [];
		bufferCount = 0;
		usedMemory = 0;
		texMemory = 0;
	}

	// ------------------------------------- STATS ------------------------------------------

	function freeMemorySize() {
		var size = 0;
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				var free = b.freeList;
				while( free != null ) {
					size += free.count * b.stride * 4;
					free = free.next;
				}
				b = b.next;
			}
		}
		return size;
	}

	public function stats() {
		var total = 0, free = 0, count = 0;
		for( b in buffers ) {
			var b = b;
			while( b != null ) {
				total += b.stride * b.size * 4;
				var f = b.freeList;
				while( f != null ) {
					free += f.count * b.stride * 4;
					f = f.next;
				}
				count++;
				b = b.next;
			}
		}
		return {
			bufferCount : bufferCount,
			freeManagedMemory : free,
			managedMemory : total,
			totalMemory : usedMemory + texMemory,
			textureCount : textures.length,
			textureMemory : texMemory,
		};
	}

	@:access(h3d.Buffer)
	public function allocStats() : Array<{ file : String, line : Int, count : Int, tex : Bool, size : Int }> {
		#if !debug
		return [];
		#else
		var h = new Map();
		var all = [];
		for( t in textures ) {
			var key = "$"+t.allocPos.fileName + ":" + t.allocPos.lineNumber;
			var inf = h.get(key);
			if( inf == null ) {
				inf = { file : t.allocPos.fileName, line : t.allocPos.lineNumber, count : 0, size : 0, tex : true };
				h.set(key, inf);
				all.push(inf);
			}
			inf.count++;
			inf.size += t.width * t.height * bpp(t);
		}
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
					inf.size += b.vertices * b.buffer.stride * 4;
					b = b.allocNext;
				}
				buf = buf.next;
			}
		}
		all.sort(function(a, b) return a.size == b.size ? a.line - b.line : b.size - a.size);
		return all;
		#end
	}


}