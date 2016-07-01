package hxd.net;
import hxd.net.NetworkSerializable;

@:generic
class VectorProxyData<T> extends BaseProxy {
	public var array : haxe.ds.Vector<T>;
	public function new(v) {
		array = v;
	}
}

abstract VectorProxy<T>(VectorProxyData<T>) {

	@:noCompletion public var __value(get, never) : haxe.ds.Vector<T>;
	@:noCompletion public var length(get, never) : Int;
	inline function get___value() : haxe.ds.Vector<T> return this == null ? null : this.array;
	inline function get_length() return this.array.length;

	inline function new(a) {
		this = a;
	}

	public inline function copy() {
		return new VectorProxy(new VectorProxyData(this.array.copy()));
	}

	public inline function join( s : String ) {
		return this.array.join(s);
	}

	public inline function sort(cmp:T->T->Int) {
		this.array.sort(cmp);
		this.mark();
	}

	public inline function toString() {
		return Std.string(this.array);
	}

	@:noCompletion public inline function bindHost(o, bit) {
		this.bindHost(o, bit);
	}

	@:noCompletion public inline function unbindHost() {
		this.unbindHost();
	}

	@:arrayAccess inline function get(idx:Int) {
		return this.array[idx];
	}

	@:arrayAccess inline function set(idx:Int,v:T) {
		this.array[idx] = v;
		this.mark();
	}

	@:from static inline function fromVector<T>( a : haxe.ds.Vector<T> ) {
		if( a == null ) return null;
		return new VectorProxy(new VectorProxyData(a));
	}
}
