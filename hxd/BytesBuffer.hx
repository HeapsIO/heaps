package hxd;

abstract BytesBuffer(haxe.io.BytesOutput) {

	public var length(get, never) : Int;

	public inline function new() {
		this = new haxe.io.BytesOutput();
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
		this.writeInt32(v);
	}

	public inline function getBytes() : haxe.io.Bytes {
		return this.getBytes();
	}

	inline function get_length() {
		return this.length;
	}

}

