package hxd.net;

class NetworkClient {

	var host : NetworkHost;

	public function new(h) {
		this.host = h;
	}

	function send(bytes : haxe.io.Bytes) {
	}

	public function fullSync( obj : Serializable ) {
		var ctx = host.ctx;
		var refs = @:privateAccess ctx.refs;
		ctx.begin();
		ctx.addByte(NetworkHost.FULLSYNC);
		ctx.addAnyRef(obj);
		for( o in refs )
			if( o != null )
				ctx.addAnyRef(o);
		ctx.addAnyRef(null);
		@:privateAccess {
			var bytes = ctx.out.getBytes();
			ctx.out = new haxe.io.BytesBuffer();
			send(bytes);
		}
	}

	function error( msg : String ) {
		throw msg;
	}

	function processMessage( bytes : haxe.io.Bytes, pos : Int ) {
		var ctx = host.ctx;
		ctx.setInput(bytes, pos);
		switch( ctx.getByte() ) {
		case NetworkHost.SYNC:
			var o : hxd.net.NetworkSerializable = cast @:privateAccess ctx.refs[ctx.getInt()];
			o.networkSync(ctx);
		case NetworkHost.REG:
			var o : hxd.net.NetworkSerializable = cast ctx.getAnyRef();
			if( host.isAlive ) host.makeAlive();
		case NetworkHost.UNREG:
			var o : hxd.net.NetworkSerializable = cast @:privateAccess ctx.refs[ctx.getInt()];
			o.enableReplication = false;
			@:privateAccess ctx.refs[o.__uid] = null;
		case NetworkHost.FULLSYNC:
			@:privateAccess ctx.refs = [];
			host.onSync(ctx.getAnyRef());
			while( true ) {
				var o = ctx.getAnyRef();
				if( o == null ) break;
			}
		case x:
			error("Unknown message code " + x);
		}
		return @:privateAccess ctx.inPos;
	}

}

@:allow(hxd.net.NetworkClient)
class NetworkHost {

	static inline var SYNC = 0;
	static inline var REG = 1;
	static inline var UNREG = 2;
	static inline var FULLSYNC = 3;
	static inline var EOF = 0xFF;

	public static var current : NetworkHost = null;

	public var isAuth(default, null) : Bool;
	var markHead : NetworkSerializable;
	var ctx : Serializer;
	var clients : Array<NetworkClient>;
	var isAlive = false;

	public function new() {
		current = this;
		isAuth = true;
		clients = [];
		ctx = new Serializer();
		ctx.begin();
	}

	inline function mark(o:NetworkSerializable) {
		o.__next = markHead;
		markHead = o;
	}

	public function makeAlive() {
		isAlive = true;
		for( o in @:privateAccess ctx.refs ) {
			if( o == null ) continue;
			var n = Std.instance(o, NetworkSerializable);
			if( n == null || n.__host != null ) continue;
			n.alive();
		}
	}

	function register(o : NetworkSerializable) {
		if( @:privateAccess ctx.refs[o.__uid] != null )
			return;
		ctx.addByte(REG);
		ctx.addAnyRef(o);
	}

	function unregister(o : NetworkSerializable) {
		ctx.addByte(UNREG);
		ctx.addInt(o.__uid);
		@:privateAccess ctx.refs[o.__uid] = null;
	}

	function send( bytes : haxe.io.Bytes ) {
		for( c in clients )
			@:privateAccess c.send(bytes);
	}

	public dynamic function onSync( obj : Serializable ) {
		trace("SYNC " + obj);
	}

	public function flush() {
		var o = markHead;
		while( o != null ) {
			ctx.addByte(SYNC);
			ctx.addInt(o.__uid);
			o.networkFlush(ctx);
			o = o.__next;
		}
		markHead = null;
		@:privateAccess {
			var bytes = ctx.out.getBytes();
			ctx.out = new haxe.io.BytesBuffer();
			send(bytes);
		}
	}

	public static function enableReplication( o : NetworkSerializable, b : Bool ) {
		if( b ) {
			if( o.__host != null ) return;
			o.__host = current;
			if( o.__host == null ) throw "No NetworkHost defined";
			current.register(o);
		} else {
			if( o.__host == null ) return;
			o.__host.unregister(o);
			o.__host = null;
		}
	}


}