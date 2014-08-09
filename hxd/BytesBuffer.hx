package hxd;

private typedef InnerData = #if flash flash.utils.ByteArray #else haxe.io.BytesOutput #end

abstract BytesBuffer(InnerData) {

	public var length(get, never) : Int;

	public inline function new() {
		#if flash
		this = new flash.utils.ByteArray();
		this.endian = flash.utils.Endian.LITTLE_ENDIAN;
		#else
		this = new haxe.io.BytesOutput();
		#end
	}

	public static inline function fromU8Array(arr:Array<Int>) {
		var v = new BytesBuffer();
		for ( i in 0...arr.length)
			v.writeByte( arr[i] );
		return v;
	}

	public static inline function fromIntArray(arr:Array<Int>) {
		var v = new BytesBuffer();
		for ( i in 0...arr.length)
			v.writeInt32(arr[i]);
		return v;
	}

	public inline function writeByte( v : Int ) {
		this.writeByte(v&255);
	}

	public inline function writeFloat( v : Float ) {
		this.writeFloat(v);
	}

	public inline function writeInt32( v : Int ) {
		#if flash
		this.writeUnsignedInt(v);
		#else
		this.writeInt32(v);
		#end
	}

	public inline function getBytes() : haxe.io.Bytes {
		#if flash
		return haxe.io.Bytes.ofData(this);
		#else
		return this.getBytes();
		#end
	}

	inline function get_length() {
		#if flash
		return this.length;
		#else
		return this.length;
		#end
	}

}

