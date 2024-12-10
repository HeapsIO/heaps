package h3d.impl;

typedef StackStats = {
	var stats: Array<TextureStat>;
	var stack : String;
	var count : Int;
	var size : Int;
}

typedef AllocStats = {
	var position : String;
	var count : Int;
	var tex : Bool;
	var size : Int;
	var stacks : Array<StackStats>;
}

typedef TextureStat = {
	var name: String;
	var size: Int;
}

class MemoryManager {

	static inline var MAX_MEMORY = 4096 * (1024. * 1024.); // MB
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
	public var usedMemory(default, null) : Float = 0;
	public var texMemory(default, null) : Float = 0;
	public var autoDisposeCooldown : Int = 60;
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

		while( usedMemory + mem > MAX_MEMORY || (b.vbuf = driver.allocBuffer(b)) == null ) {

			if( driver.isDisposed() ) return;

			var size = usedMemory;
			garbage();
			if( usedMemory == size )
				throw "Memory full (" + Math.fceil(size / 1024) + " KB," + buffers.length + " buffers)";
		}
		usedMemory += mem;
		buffers.push(b);
	}

	function freeBuffer( b : Buffer ) {
		if( b.vbuf == null ) return;
		driver.disposeBuffer(b);
		b.vbuf = null;
		// in case it was allocated with a previous memory manager
		if( buffers.remove(b) )
			usedMemory -= b.getMemSize();
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
			var free = true;
			if ( hxd.Timer.frameCount > lastAutoDispose + autoDisposeCooldown ) {
				free = cleanTextures(false);
				lastAutoDispose = hxd.Timer.frameCount;
			}
			t.t = t.isDepth() ? driver.allocDepthBuffer(t) : driver.allocTexture(t);
			if( t.t != null ) break;

			if( driver.isDisposed() ) return;
			while( cleanTextures(false) ) {} // clean all old textures
			if( !free && !cleanTextures(true) )
				throw "Maximum texture memory reached";
		}
		textures.push(t);
		texMemory += memSize(t);
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
		usedMemory = 0;
		texMemory = 0;
	}

	// ------------------------------------- STATS ------------------------------------------

	public function stats() {
		var total = 0.;
		for( b in buffers )
			total += b.getMemSize();
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
	public function allocStats() : Array<AllocStats> {
		var h = new Map();
		var all = [];
		inline function addStack( name: String, a : hxd.impl.AllocPos, stacks : Array<StackStats>, size : Int ) {
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
				inf = { position : t.allocPos.position, count : 0, size : 0, tex : true, stacks : [] };
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
				inf = { position : key, count : 0, size : 0, tex : false, stacks : [] };
				h.set(key, inf);
				all.push(inf);
			}
			inf.count++;
			var size = b.vertices * b.format.stride * 4;
			inf.size += size;
			addStack("buffer", b.allocPos, inf.stacks, size);
		}
		all.sort(function(a, b) return b.size - a.size);
		return all;
	}
}