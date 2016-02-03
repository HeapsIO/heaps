package hxd.net;

class NetworkHost {

	static inline var SYNC = 0;
	static inline var REG = 1;
	static inline var UNREG = 1;
	static inline var EOF = 0xFF;

	public static var current : NetworkHost = null;

	var markHead : NetworkSerializable;
	var liveObjects : Map<Int,NetworkSerializable>;
	var ctx : Serializer;

	public function new() {
		current = this;
		liveObjects = new Map();
		ctx = new Serializer();
		ctx.begin();
	}

	inline function mark(o:NetworkSerializable) {
		o.__next = markHead;
		markHead = o;
	}

	function register(o : NetworkSerializable) {
		liveObjects.set(o.__uid, o);
		ctx.addByte(REG);
		o.serialize(ctx);
	}

	function unregister(o : NetworkSerializable) {
		liveObjects.remove(o.__uid);
		ctx.addByte(UNREG);
		ctx.addInt(o.__uid);
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
			trace(bytes.length);
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