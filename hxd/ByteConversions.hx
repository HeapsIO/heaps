package hxd;

import haxe.io.Bytes;

/**
 * Tries to provide consistent access to haxe.io.bytes from any primitive
 */
class ByteConversions{

#if flash

	public static inline function byteArrayToBytes( v: flash.utils.ByteArray ) : haxe.io.Bytes {
		return Bytes.ofData( v );
	}

	public static inline function bytesToByteArray( v: haxe.io.Bytes ) :  flash.utils.ByteArray {
		return v.getData();
	}
#elseif js

	public static inline function arrayBufferToBytes( v : hxd.impl.TypedArray.ArrayBuffer ) : haxe.io.Bytes{
		return haxe.io.Bytes.ofData(v);
	}

#end

}
