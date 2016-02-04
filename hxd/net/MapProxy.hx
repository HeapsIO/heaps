package hxd.net;
import hxd.net.NetworkSerializable;

@:generic class MapData<K,V> extends BaseProxy {
	public var map : Map<K,V>;
	public function new(map) {
		this.map = map;
	}
}

abstract MapProxy<K,V>(MapData<K,V>) {

	@:noCompletion public var __value(get, never) : Map<K,V>;
	inline function get___value() return this == null ? null : this.map;

	public inline function set(key:K, value:V) {
		this.mark();
		this.map.set(key, value);
	}

	@:arrayAccess public inline function get(key:K) return this.map.get(key);
	public inline function exists(key:K) return this.map.exists(key);
	public inline function remove(key:K) {
		var b = this.map.remove(key);
		if( b ) this.mark();
		return b;
	}

	@:noCompletion public inline function bindHost(o, bit) {
		this.bindHost(o, bit);
	}

	@:noCompletion public inline function unbindHost() {
		this.unbindHost();
	}

	public inline function keys():Iterator<K> {
		return this.map.keys();
	}

	public inline function iterator():Iterator<V> {
		return this.map.iterator();
	}

	public inline function toString():String {
		return this.map.toString();
	}

	@:arrayAccess @:noCompletion public inline function arrayWrite(k:K, v:V):V {
		this.mark();
		this.map.set(k, v);
		return v;
	}

	@:from static inline function fromStringMap<V>(map:haxe.ds.StringMap<V>):MapProxy< String, V > {
		if( map == null ) return null;
		return cast new MapData(map);
	}

	@:from static inline function fromIntMap<V>(map:haxe.ds.IntMap<V>):MapProxy< Int, V > {
		if( map == null ) return null;
		return cast new MapData(map);
	}

	@:from static inline function fromObjectMap<K:{ }, V>(map:haxe.ds.ObjectMap<K,V>):MapProxy<K,V> {
		if( map == null ) return null;
		return cast new MapData(map);
	}

	@:from static inline function fromStringMap2<V>(map:Map<String,V>):MapProxy< String, V > {
		if( map == null ) return null;
		return cast new MapData(map);
	}

	@:from static inline function fromIntMap2<V>(map:Map<Int,V>):MapProxy< Int, V > {
		if( map == null ) return null;
		return cast new MapData(map);
	}

	@:from static inline function fromObjectMap2<K:{ }, V>(map:Map<K,V>):MapProxy<K,V> {
		if( map == null ) return null;
		return cast new MapData(map);
	}

}
