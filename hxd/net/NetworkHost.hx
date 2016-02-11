package hxd.net;

class NetworkClient {

	var host : NetworkHost;
	var resultID : Int;

	public function new(h) {
		this.host = h;
	}

	public function send(bytes : haxe.io.Bytes) {
	}

	public function fullSync( obj : Serializable ) {
		var ctx = host.ctx;
		var refs = ctx.refs;
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
			var o : hxd.net.NetworkSerializable = cast ctx.refs[ctx.getInt()];
			var old = o.__bits;
			o.networkSync(ctx);
			o.__bits = old;
		case NetworkHost.REG:
			var o : hxd.net.NetworkSerializable = cast ctx.getAnyRef();
			if( host.isAlive ) host.makeAlive();
		case NetworkHost.UNREG:
			var o : hxd.net.NetworkSerializable = cast ctx.refs[ctx.getInt()];
			o.enableReplication = false;
			ctx.refs[o.__uid] = null;
		case NetworkHost.FULLSYNC:
			ctx.refs = [];
			var obj = ctx.getAnyRef();
			while( true ) {
				var o = ctx.getAnyRef();
				if( o == null ) break;
			}
			host.onSync(obj);
		case NetworkHost.RPC:
			var o : hxd.net.NetworkSerializable = cast ctx.refs[ctx.getInt()];
			var fid = ctx.getByte();
			if( !o.__host.isAuth ) {
				var old = o.__host;
				o.__host = null;
				o.networkRPC(ctx, fid, this);
				o.__host = old;
			} else
				o.networkRPC(ctx, fid, this);
		case NetworkHost.RPC_WITH_RESULT:

			var old = resultID;
			resultID = ctx.getInt();
			var o : hxd.net.NetworkSerializable = cast ctx.refs[ctx.getInt()];
			var fid = ctx.getByte();

			if( !o.__host.isAuth ) {
				var old = o.__host;
				o.__host = null;
				o.networkRPC(ctx, fid, this);
				o.__host = old;
			} else
				o.networkRPC(ctx, fid, this);

			host.doSend();
			host.targetClient = null;
			resultID = old;

		case NetworkHost.RPC_RESULT:

			var resultID = ctx.getInt();
			var callb = host.rpcWaits.get(resultID);
			host.rpcWaits.remove(resultID);
			callb(ctx);

		case x:
			error("Unknown message code " + x);
		}
		return @:privateAccess ctx.inPos;
	}

	function beginRPCResult() {
		var ctx = host.ctx;
		host.flush();
		host.targetClient = this;
		ctx.addByte(NetworkHost.RPC_RESULT);
		ctx.addInt(resultID);
	}

}

@:allow(hxd.net.NetworkClient)
class NetworkHost {

	static inline var SYNC 		= 1;
	static inline var REG 		= 2;
	static inline var UNREG 	= 3;
	static inline var FULLSYNC 	= 4;
	static inline var RPC 		= 5;
	static inline var RPC_WITH_RESULT = 6;
	static inline var RPC_RESULT = 7;

	public static var current : NetworkHost = null;

	public var isAuth(default, null) : Bool;

	public var sendRate : Float = 0.;
	public var totalSentBytes : Int = 0;

	var lastSentTime : Float = 0.;
	var lastSentBytes = 0;
	var markHead : NetworkSerializable;
	var ctx : Serializer;
	var clients : Array<NetworkClient>;
	var isAlive = false;
	var logger : String -> Void;
	var hasData = false;
	var rpcUID = Std.random(0x1000000);
	var rpcWaits = new Map<Int,Serializer->Void>();

	var targetClient : NetworkClient;

	public function new() {
		current = this;
		isAuth = true;
		clients = [];
		ctx = new Serializer();
		ctx.begin();
	}

	public function saveState( s : Serializable ) {
		return new hxd.net.Serializer().serialize(s);
	}

	public function loadSave<T:Serializable>( bytes : haxe.io.Bytes, c : Class<T> ) : T {
		ctx.refs = [];
		ctx.setInput(bytes, 0);
		return ctx.getKnownRef(c);
	}

	inline function mark(o:NetworkSerializable) {
		o.__next = markHead;
		markHead = o;
	}

	public function beginRPC(o:NetworkSerializable, id:Int, onResult:Serializer->Void) {
		flushProps();
		hasData = true;
		if( ctx.refs[o.__uid] == null )
			throw "Can't call RPC on an object not previously transferred";
		if( onResult != null ) {
			var id = rpcUID++;
			ctx.addByte(RPC_WITH_RESULT);
			ctx.addInt(id);
			rpcWaits.set(id, onResult);
		} else
			ctx.addByte(RPC);
		ctx.addInt(o.__uid);
		ctx.addByte(id);
		if( logger != null )
			logger("RPC " + o +"#"+id+(onResult == null ? "" : "->" + (rpcUID-1)));
		return ctx;
	}

	public function defaultLogger( ?filter : String -> Bool ) {
		setLogger(function(str) {
			if( filter != null && !filter(str) ) return;
			str = (isAuth ? "[S] " : "[C] ") + str;
			str = haxe.Timer.stamp() + " " + str;
			#if	sys Sys.println(str); #else trace(str); #end
		});
	}

	public function makeAlive() {
		isAlive = true;
		for( o in ctx.refs ) {
			if( o == null ) continue;
			var n = Std.instance(o, NetworkSerializable);
			if( n == null || n.__host != null ) continue;
			if( logger != null )
				logger("Alive " + n +"#"+n.__uid);
			n.alive();
		}
	}

	public function setLogger( log : String -> Void ) {
		this.logger = log;
	}

	function register(o : NetworkSerializable) {
		if( ctx.refs[o.__uid] != null )
			return;
		if( logger != null )
			logger("Register " + o+"#"+o.__uid);
		ctx.addByte(REG);
		ctx.addAnyRef(o);
	}

	function unregister(o : NetworkSerializable) {
		if( logger != null )
			logger("Unregister " + o+"#"+o.__uid);
		ctx.addByte(UNREG);
		ctx.addInt(o.__uid);
		ctx.refs[o.__uid] = null;
	}

	function doSend() {
		@:privateAccess {
			var bytes = ctx.out.getBytes();
			ctx.out = new haxe.io.BytesBuffer();
			send(bytes);
		}
	}

	function send( bytes : haxe.io.Bytes ) {
		if( targetClient != null ) {
			totalSentBytes += bytes.length;
			targetClient.send(bytes);
		}
		else {
			totalSentBytes += bytes.length * clients.length;
			for( c in clients )
				c.send(bytes);
		}
	}

	public dynamic function onSync( obj : Serializable ) {
		trace("SYNC " + obj);
	}

	function flushProps() {
		var o = markHead;
		while( o != null ) {
			if( o.__bits != 0 ) {
				if( logger != null )
					logger("SYNC " + o + "#" + o.__uid + " " + o.__bits);
				ctx.addByte(SYNC);
				ctx.addInt(o.__uid);
				o.networkFlush(ctx);
				hasData = true;
			}
			o = o.__next;
		}
		markHead = null;
	}

	public function flush() {
		flushProps();
		if( hasData ) {
			doSend();
			hasData = false;
		}
		// update sendRate
		var now = haxe.Timer.stamp();
		var dt = now - lastSentTime;
		if( dt < 0.5 )
			return;
		var db = totalSentBytes - lastSentBytes;
		var rate = db / dt;
		sendRate = (sendRate + rate) * 0.5; // smooth
		lastSentTime = now;
		lastSentBytes = totalSentBytes;
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