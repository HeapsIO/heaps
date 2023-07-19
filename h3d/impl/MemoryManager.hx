package h3d.impl;

class MemoryManager {

	static inline var MAX_MEMORY = 4096 * (1024. * 1024.); // MB
	static inline var MAX_BUFFERS = 65536;
	static inline var SIZE = 65533;
	static var ALL_FLAGS = Type.allEnums(Buffer.BufferFlag);

	@:allow(h3d)
	var driver : Driver;
	var buffers : Array<Buffer>;
	var indexes : Array<Indexes>;
	var textures : Array<h3d.mat.Texture>;
	var depths : Array<h3d.mat.DepthBuffer>;

	public var triIndexes(default,null) : Indexes;
	public var quadIndexes(default,null) : Indexes;
	public var usedMemory(default, null) : Float = 0;
	public var texMemory(default, null) : Float = 0;

	public function new(driver) {
		this.driver = driver;
	}

	public function init() {
		indexes = new Array();
		textures = new Array();
		buffers = new Array();
		depths = new Array();
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

	function allocBuffer( b : Buffer ) {
		if( b.vbuf != null ) return;

		var mem = b.vertices * b.stride * 4;

		if( mem == 0 ) return;

		while( usedMemory + mem > MAX_MEMORY || buffers.length >= MAX_BUFFERS || (b.vbuf = driver.allocBuffer(b)) == null ) {

			if( driver.isDisposed() ) return;

			var size = usedMemory;
			garbage();
			if( usedMemory == size ) {
				if( buffers.length >= MAX_BUFFERS )
					throw "Too many buffers";
				throw "Memory full (" + Math.fceil(size / 1024) + " KB," + buffers.length + " buffers)";
			}
		}
		usedMemory += mem;
		b.mem = this;
		buffers.push(b);
	}

	function freeBuffer( b : Buffer ) {
		if( b.vbuf == null ) return;
		driver.disposeBuffer(b.vbuf);
		b.vbuf = null;
		b.mem = null;
		usedMemory -= b.vertices * b.stride * 4;
		buffers.remove(b);
	}

	// ------------------------------------- INDEXES ------------------------------------------

	@:allow(h3d.Indexes)
	function deleteIndexes( i : Indexes ) {
		indexes.remove(i);
		driver.disposeIndexes(i.ibuf);
		i.ibuf = null;
		usedMemory -= i.count * (i.is32 ? 4 : 2);
	}

	@:allow(h3d.Indexes)
	function allocIndexes( i : Indexes ) {
		i.ibuf = driver.allocIndexes(i.count,i.is32);
		indexes.push(i);
		usedMemory += i.count * (i.is32 ? 4 : 2);
	}


	// ------------------------------------- TEXTURES ------------------------------------------

	function memSize( t : h3d.mat.Texture ) {
		if( t.flags.has(AsyncLoading) && t.flags.has(Loading) )
			return 4; // 1x1 pixel
		var size = hxd.Pixels.calcDataSize(t.width,t.height,t.format);
		if( t.mipLevels > 0 ) {
			for( i in 1...t.mipLevels ) {
				var w = t.width >> i; if( w == 0 ) w = 1;
				var h = t.height >> i; if( h == 0 ) h = 1;
				size += hxd.Pixels.calcDataSize(w,h,t.format);
			}
		}
		return size * t.layerCount;
	}

	public function cleanTextures( force = true ) {
		textures.sort(sortByLRU);
		for( t in textures ) {
			if( t.realloc == null || t.isDisposed() ) continue;
			if( (force || t.lastFrame < hxd.Timer.frameCount - 3600) && t.lastFrame != h3d.mat.Texture.PREVENT_AUTO_DISPOSE ) {
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
		if( !textures.remove(t) ) return;
		driver.disposeTexture(t);
		texMemory -= memSize(t);
	}

	@:allow(h3d.mat.Texture.alloc)
	function allocTexture( t : h3d.mat.Texture ) {
		while( true ) {
			var free = cleanTextures(false);
			t.t = driver.allocTexture(t);
			if( t.t != null ) break;

			if( driver.isDisposed() ) return;
			while( cleanTextures(false) ) {} // clean all old textures
			if( !free && !cleanTextures(true) )
				throw "Maximum texture memory reached";
		}
		textures.push(t);
		texMemory += memSize(t);
	}

	@:allow(h3d.mat.DepthBuffer.alloc)
	function allocDepth( b : h3d.mat.DepthBuffer ) {
		while( true ) {
			var free = cleanTextures(false);
			b.b = driver.allocDepthBuffer(b);
			if( b.b != null ) break;

			if( driver.isDisposed() ) return;
			while( cleanTextures(false) ) {} // clean all old textures
			if( !free && !cleanTextures(true) )
				throw "Maximum texture memory reached";
		}
		depths.push(b);
		texMemory += b.width * b.height * 4;
	}

	@:allow(h3d.mat.DepthBuffer.dispose)
	function deleteDepth( b : h3d.mat.DepthBuffer ) {
		if( !depths.remove(b) ) return;
		driver.disposeDepthBuffer(b);
		texMemory -= b.width * b.height * 4;
	}

	// ------------------------------------- DISPOSE ------------------------------------------

	public function onContextLost() {
		dispose();
		initIndexes();
	}

	public function dispose() {
		if( triIndexes != null ) triIndexes.dispose();
		if( quadIndexes != null ) quadIndexes.dispose();
		triIndexes = null;
		quadIndexes = null;
		for( t in textures.copy() )
			t.dispose();
		for( b in depths.copy() )
			b.dispose();
		for( b in buffers.copy() )
			b.dispose();
		for( i in indexes.copy() )
			i.dispose();
		buffers = [];
		indexes = [];
		textures = [];
		usedMemory = 0;
		texMemory = 0;
	}

	// ------------------------------------- STATS ------------------------------------------

	public function stats() {
		var total = 0.;
		for( b in buffers )
			total += b.stride * b.vertices * 4;
		return {
			bufferCount : buffers.length,
			bufferMemory : total,
			totalMemory : usedMemory + texMemory,
			textureCount : textures.length,
			textureMemory : texMemory,
		};
	}

	/**
	 * Return statistics for currently allocated buffers and textures. Requires -D track-alloc compilation flag
	 */
	@:access(h3d.Buffer)
	public function allocStats() : Array<{ position : String, count : Int, tex : Bool, size : Int, stacks : Array<{ stack : String, count : Int, size : Int }> }> {
		#if !track_alloc
		return [];
		#else
		var h = new Map();
		var all = [];
		inline function addStack( a : hxd.impl.AllocPos, stacks : Array<{ stack : String, count : Int, size : Int }>, size : Int ) {
			var stackStr = a.stack.join("\n");
			for( s in stacks )
				if( s.stack == stackStr ) {
					s.size += size;
					s.count++;
					stackStr = null;
				}
			if( stackStr != null )
				stacks.push({ stack : stackStr, count : 1, size : size });
		}
		for( t in textures ) {
			var key = "$"+t.allocPos.position;
			var inf = h.get(key);
			if( inf == null ) {
				inf = { position : t.allocPos.position, count : 0, size : 0, tex : true, stacks : [] };
				h.set(key, inf);
				all.push(inf);
			}
			inf.count++;
			var size = memSize(t);
			inf.size += size;
			addStack(t.allocPos, inf.stacks, size);
		}
		for( buf in buffers ) {
			var buf = buf;
			while( buf != null ) {
				var b = buf.allocHead;
				while( b != null ) {
					var key = b.allocPos == null ? "null" : b.allocPos.position;
					var inf = h.get(key);
					if( inf == null ) {
						inf = { position : key, count : 0, size : 0, tex : false, stacks : [] };
						h.set(key, inf);
						all.push(inf);
					}
					inf.count++;
					var size = b.vertices * b.buffer.stride * 4;
					inf.size += size;
					addStack(b.allocPos, inf.stacks, size);
					b = b.allocNext;
				}
				buf = buf.next;
			}
		}
		all.sort(function(a, b) return b.size - a.size);
		return all;
		#end
	}


}