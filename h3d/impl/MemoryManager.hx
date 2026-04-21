package h3d.impl;

typedef StackStats = {
	var stats: Array<TextureStat>;
	var stack : String;
	var count : Int;
	var size : Float;
}

typedef AllocStats = {
	var position : String;
	var count : Int;
	var tex : Bool;
	var size : Float;
	var stacks : Array<StackStats>;
}

typedef TextureStat = {
	var name: String;
	var size: Float;
}

class MemoryManager {

	static inline var SIZE = 65532;
	static var ALL_FLAGS = Type.allEnums(Buffer.BufferFlag);

	@:allow(h3d)
	var driver : Driver;
	var buffers : Array<Buffer>;
	var textures : Array<h3d.mat.Texture>;

	var triIndexes16 : Indexes;
	var quadIndexes16 : Indexes;
	var triIndexes32 : Indexes;
	var quadIndexes32 : Indexes;
	public var bufferMemory(default, null) : Float = 0;
	public var texMemory(default, null) : Float = 0;

	/**
	 	How much time a texture should be kept into memory if it's not used.
	**/
	public var autoDisposeKeepTime : Float = 3.0;

	/**
	 	The amount of free memory we want to keep on our GPU to allow swapping.
	**/
	public var autoDisposeGpuFreeMB : Float = 1024;

	var lastAutoDispose = 0;

	public function new(driver) {
		this.driver = driver;
	}

	public function init() {
		textures = new Array();
		buffers = new Array();
		initIndexes();
	}

	public static function enableTrackAlloc(?b : Bool) {
		@:privateAccess hxd.impl.AllocPos.ENABLED = b != null ? b : true;
	}

	function initIndexes() {
		var indices = new hxd.IndexBuffer();
		for( i in 0...SIZE ) indices.push(i);
		triIndexes16 = h3d.Indexes.alloc(indices);

		var indices = new hxd.IndexBuffer();
		var p = 0;
		for( i in 0...Std.int(SIZE/6) ) {
			var k = i << 2;
			indices.push(k);
			indices.push(k + 1);
			indices.push(k + 2);
			indices.push(k + 2);
			indices.push(k + 1);
			indices.push(k + 3);
		}
		indices.push(SIZE);
		quadIndexes16 = h3d.Indexes.alloc(indices);
	}

	/**
		Call user-defined garbage function that will cleanup some unused allocated objects.
		Might be called several times if we need to allocate a lot of memory
	**/
	public dynamic function garbage() {
		if( !cleanTextures(false) ) cleanTextures(true);
	}

	public function getTriIndexes( vertices : Int ) {
		if( vertices <= SIZE )
			return triIndexes16;
		if( triIndexes32 == null || triIndexes32.count < vertices ) {
			var sz = 1 << 17;
			while( sz < vertices ) sz <<= 1;
			var bytes = haxe.io.Bytes.alloc(sz << 2);
			for( i in 0...sz )
				bytes.setInt32(i<<2, i);
			if( triIndexes32 != null )
				triIndexes32.dispose();
			triIndexes32 = new h3d.Indexes(sz,true);
			triIndexes32.uploadBytes(bytes,0,sz);
		}
		return triIndexes32;
	}

	public function getQuadIndexes( vertices : Int ) {
		var nquads = ((vertices + 3) >> 2) * 6;
		if( nquads <= SIZE )
			return quadIndexes16;
		if( quadIndexes32 == null || quadIndexes32.count < vertices ) {
			var sz = 1 << 17;
			while( sz < nquads ) sz <<= 1;
			var bytes = haxe.io.Bytes.alloc(sz << 2);
			var p = 0;
			for( i in 0...Std.int(sz/6) ) {
				var k = i << 2;
				bytes.setInt32(p++ << 2, k);
				bytes.setInt32(p++ << 2, k + 1);
				bytes.setInt32(p++ << 2, k + 2);
				bytes.setInt32(p++ << 2, k + 2);
				bytes.setInt32(p++ << 2, k + 1);
				bytes.setInt32(p++ << 2, k + 3);
			}
			if( quadIndexes32 != null )
				quadIndexes32.dispose();
			quadIndexes32 = new h3d.Indexes(sz,true);
			quadIndexes32.uploadBytes(bytes,0,sz);
		}
		return quadIndexes32;
	}

	// ------------------------------------- BUFFERS ------------------------------------------

	function allocBuffer( b : Buffer ) {
		if( b.vbuf != null ) return;

		var mem = b.getMemSize();
		if( mem == 0 ) return;

		autoDisposeMemory();
		while( (b.vbuf = driver.allocBuffer(b)) == null ) {
			if( driver.isDisposed() ) return;
			tryFreeMemory();
		}
		bufferMemory += mem;
		buffers.push(b);
	}

	function freeBuffer( b : Buffer ) {
		if( b.vbuf == null ) return;
		driver.disposeBuffer(b);
		b.vbuf = null;
		// in case it was allocated with a previous memory manager
		if( buffers.remove(b) )
			bufferMemory -= b.getMemSize();
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
		var cleanupFrames = Math.ceil(autoDisposeKeepTime * hxd.Timer.fps());
		if( cleanupFrames < 1 ) cleanupFrames = 1;
		for( t in textures ) {
			if( t.realloc == null || t.isDisposed() ) continue;
			if( t.lastFrame == h3d.mat.Texture.PREVENT_AUTO_DISPOSE ) break;
			if( force || t.lastFrame < hxd.Timer.frameCount - cleanupFrames ) {
				t.dispose();
				return true;
			}
		}
		return false;
	}

	static function sortByLRU( t1 : h3d.mat.Texture, t2 : h3d.mat.Texture ) {
		return t1.lastFrame - t2.lastFrame;
	}

	public function beginFrame() {
		if( autoDisposeGpuFreeMB > 0 && hxd.Timer.frameCount > lastAutoDispose + 60 ) {
			var stats = driver.getMemoryUsage();
			if( stats == null ) {
				// disable (our driver doesn't support it anyway)
				autoDisposeGpuFreeMB = -1;
				return;
			}
			if( (stats.free/(1024*1024)) < autoDisposeGpuFreeMB )
				cleanTextures(false); // will check again next frame, if we are still above the limit
			else
				lastAutoDispose = hxd.Timer.frameCount; // wait a bit
		}
	}

	function autoDisposeMemory() {
		if( autoDisposeGpuFreeMB < 0 && hxd.Timer.frameCount > lastAutoDispose + 60 ) {
			// if we have disabled per frame memory cleanup, or if our driver doesn't support it
			// then let's do at least some cleanup for each allocation on a regular basis
			// so we don't wait until our GPU returns null
			cleanTextures(false);
			lastAutoDispose = hxd.Timer.frameCount;
		}
	}

	function tryFreeMemory() {
		var size = bufferMemory + texMemory;
		if( !cleanTextures(false) ) garbage();
		if( bufferMemory + texMemory == size )
			errorOutOfMemory();
	}

	@:allow(h3d.mat.Texture.dispose)
	function deleteTexture( t : h3d.mat.Texture ) {
		if( !textures.remove(t) ) return;
		driver.disposeTexture(t);
		texMemory -= memSize(t);
	}

	@:allow(h3d.mat.Texture.alloc)
	function allocTexture( t : h3d.mat.Texture ) {
		autoDisposeMemory();
		while( true ) {
			t.t = t.isDepth() ? driver.allocDepthBuffer(t) : driver.allocTexture(t);
			if( t.t != null ) break;
			if( driver.isDisposed() ) return;
			tryFreeMemory();
		}
		textures.push(t);
		texMemory += memSize(t);
	}

	public dynamic function errorOutOfMemory() {
		throw "Failed to alloc GPU Memory (full)";
	}

	// ------------------------------------- DISPOSE ------------------------------------------

	public function onContextLost() {
		dispose();
		initIndexes();
	}

	public function dispose() {
		if( triIndexes16 != null ) triIndexes16.dispose();
		if( quadIndexes16 != null ) quadIndexes16.dispose();
		if( triIndexes32 != null ) triIndexes32.dispose();
		if( quadIndexes32 != null ) quadIndexes32.dispose();
		triIndexes16 = null;
		quadIndexes16 = null;
		triIndexes32 = null;
		quadIndexes32 = null;
		for( t in textures.copy() )
			t.dispose();
		for( b in buffers.copy() )
			b.dispose();
		buffers = [];
		textures = [];
		bufferMemory = 0;
		texMemory = 0;
	}

	// ------------------------------------- STATS ------------------------------------------

	public function stats( megas = false ) {
		var total = bufferMemory + texMemory;
		var use = driver.getMemoryUsage();
		inline function fmt( v : Float ) return megas ? hxd.Math.fmt(v/(1024*1024)) : v;
		return {
			bufferCount : buffers.length,
			bufferMemory : fmt(bufferMemory),
			totalMemory : fmt(use == null ? bufferMemory + texMemory : use.allocated),
			textureCount : textures.length,
			textureMemory : fmt(texMemory),
			otherMemory : use == null ? 0 : fmt(use.allocated - total) /* remaining memory that we don't know about */,
			maxMemory : use == null ? 0 : fmt(use.total),
		};
	}

	/**
	 * Return statistics for currently allocated buffers and textures.
	 * Requires call `MemoryManager.enableTrackAlloc()` before allocations.
	 */
	@:access(h3d.Buffer)
	public function allocStats() : Array<AllocStats> {
		var h = new Map();
		var all = [];
		inline function addStack( name: String, a : hxd.impl.AllocPos, stacks : Array<StackStats>, size : Float ) {
			var stackStr = a.stack.join("\n");
			for( s in stacks )
				if( s.stack == stackStr ) {
					s.size += size;
					s.count++;
					s.stats.push({{name: name, size: size}});
					stackStr = null;
				}
			if( stackStr != null )
				stacks.push({ stats: [{name: name, size: size}], stack : stackStr, count : 1, size : size });
		}
		for( t in textures ) {
			if ( t.allocPos == null )
				continue;
			var key = "$"+t.allocPos.position;
			var inf = h.get(key);
			if( inf == null ) {
				inf = { position : t.allocPos.position, count : 0, size : 0.0, tex : true, stacks : [] };
				h.set(key, inf);
				all.push(inf);
			}
			inf.count++;
			var size = memSize(t);
			inf.size += size;
			addStack(t.name, t.allocPos, inf.stacks, size);
		}
		for( b in buffers ) {
			if ( b.allocPos == null )
				continue;
			var key = b.allocPos.position;
			var inf = h.get(key);
			if( inf == null ) {
				inf = { position : key, count : 0, size : 0.0, tex : false, stacks : [] };
				h.set(key, inf);
				all.push(inf);
			}
			inf.count++;
			var size = b.getMemSize();
			inf.size += size;
			addStack("buffer", b.allocPos, inf.stacks, size);
		}
		all.sort(function(a, b) return a.size > b.size ? 1 : ( a.size < b.size ? -1 : 0 ));
		return all;
	}
}