package hxd.fs;

class FileInput extends haxe.io.Input {

	static var PREFETCH_CACHE : haxe.io.Bytes = null;

	var entry : FileEntry;
	var cache : haxe.io.Bytes;
	var cachePos : Int;
	var cacheLen : Int;
	var nextReadPos : Int;

	function new(entry) {
		this.entry = entry;
	}

	public function fetch( dataSize:Int = 256 ) {
		var prev = cache;
		if( cache == null || cache.length < dataSize ) {
			cache = PREFETCH_CACHE;
			if( cache != null && cache.length >= dataSize ) {
				PREFETCH_CACHE = null;
			} else {
				cache = haxe.io.Bytes.alloc(dataSize);
			}
		}
		var startPos = 0;
		if( cacheLen > 0 ) {
			startPos = cacheLen;
			dataSize -= cacheLen;
			cache.blit(0, prev, cachePos, cacheLen);
		}
		var read = entry.readBytes(cache, startPos, nextReadPos, dataSize);
		cachePos = 0;
		cacheLen = startPos + read;
		nextReadPos += read;
		if( cacheLen == 0 )
			throw new haxe.io.Eof();
	}

	public function skip( nbytes : Int ) {
		if( cacheLen > 0 ) {
			var k = hxd.Math.imin(cacheLen, nbytes);
			cachePos += k;
			cacheLen -= k;
			nbytes -= k;
		}
		nextReadPos += nbytes;
	}

	override function readByte() {
		if( cacheLen == 0 ) fetch();
		var b = cache.get(cachePos++);
		cacheLen--;
		return b;
	}

	override function readBytes( b : haxe.io.Bytes, pos : Int, len : Int ) {
		var tot = 0;

		if( len < 256 && cacheLen < len )
			fetch();

		if( cacheLen > 0 ) {
			var k = hxd.Math.imin(len, cacheLen);
			b.blit(pos, cache, cachePos, k);
			cachePos += k;
			cacheLen -= k;
			len -= k;
			if( len == 0 )
				return k;
			pos += k;
			tot += k;
		}
		if( len > 0 ) {
			var k = entry.readBytes(b, pos, nextReadPos, len);
			nextReadPos += k;
			tot += k;
		}
		return tot;
	}

	override function close() {
		if( cache != null && (PREFETCH_CACHE == null || PREFETCH_CACHE.length < cache.length) )
			PREFETCH_CACHE = cache;
		cache = null;
		cacheLen = 0;
	}

}
