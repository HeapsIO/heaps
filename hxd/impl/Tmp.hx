package hxd.impl;

class Tmp {

	static var bytes = new Array<haxe.io.Bytes>();

	public static dynamic function outOfMemory() {
	}

	public static function getBytes( size : Int ) {
		#if hl return haxe.io.Bytes.alloc(size); #end
		var found = -1;
		for( i in 0...bytes.length ) {
			var b = bytes[i];
			if( b.length >= size ) found = i;
		}
		if( found >= 0 ) {
			var b = bytes[found];
			bytes.splice(found, 1);
			return b;
		}
		var sz = 1024;
		while( sz < size )
			sz = (sz * 3) >> 1;
		return allocBytes(sz);
	}

	public static function freeMemory() {
		bytes = [];
		outOfMemory();
	}

	public static function allocBytes( size : Int ) {
		try {
			return haxe.io.Bytes.alloc(size);
		} catch( e : Dynamic ) {
			// out of memory
			freeMemory();
			return haxe.io.Bytes.alloc(size);
		}
	}

	public static function saveBytes( b : haxe.io.Bytes ) {
		#if hl return; #end
		for( i in 0...bytes.length ) {
			if( bytes[i].length <= b.length ) {
				bytes.insert(i, b);
				if( bytes.length > 8 )
					bytes.pop();
				return;
			}
		}
		bytes.push(b);
	}

}