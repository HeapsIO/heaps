package hxd.net;

interface ProxyHost {
	public function networkSetBit( bit : Int ) : Void;
}

interface ProxyChild {
	public function bindHost( p : ProxyHost, bit : Int ) : Void;
	public function unbindHost() : Void;
}

@:autoBuild(hxd.net.Macros.buildNetworkSerializable())
interface NetworkSerializable extends Serializable extends ProxyHost {
	public var __host : NetworkHost;
	public var __bits : Int;
	public var __next : NetworkSerializable;
	public var enableReplication(get, set) : Bool;
	public function alive() : Void; // user defined

	public function networkFlush( ctx : Serializer ) : Void;
	public function networkSync( ctx : Serializer ) : Void;
	public function networkRPC( ctx : Serializer, rpcID : Int, clientResult : NetworkHost.NetworkClient ) : Void;
	public function networkGetOwner() : NetworkSerializable;
}

@:genericBuild(hxd.net.Macros.buildSerializableProxy())
class Proxy<T> {
}

class BaseProxy implements ProxyHost implements ProxyChild {
	public var obj : ProxyHost;
	public var bit : Int;
	public inline function networkSetBit(_) {
		mark();
	}
	public inline function mark() {
		if( obj != null ) obj.networkSetBit(bit);
	}
	public inline function bindHost(o, bit) {
		this.obj = o;
		this.bit = bit;
	}
	public inline function unbindHost() {
		this.obj = null;
	}
}

abstract Property(Int) {

	public inline function new(x:Int) {
		this = x;
	}

	public inline function toInt() {
		return this;
	}

	@:op(a|b) inline function opOr(a:Property) return new Property(this | a.toInt());

}