package hxd.impl;

private typedef InnerData = #if hl hl.Bytes #elseif js TypedArray.Uint8Array #else haxe.io.BytesData #end

abstract UncheckedBytes(InnerData) {

	inline function new(v) {
		this = v;
	}

	@:arrayAccess inline function get( i : Int ) : Int {
		#if neko
		return untyped $sget(b,i);
		#else
		return this[i];
		#end
	}

	@:arrayAccess inline function set( i : Int, v : Int ) : Int {
		#if neko
		untyped $sset(b,i,v);
		#else
		this[i] = v;
		#end
		return v;
	}

	@:from public static inline function fromBytes( b : haxe.io.Bytes ) : UncheckedBytes {
		#if hl
		return new UncheckedBytes(b);
		#elseif js
		return new UncheckedBytes(@:privateAccess b.b);
		#else
		return new UncheckedBytes(b.getData());
		#end
	}

}