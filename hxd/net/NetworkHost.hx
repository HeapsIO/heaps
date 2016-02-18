package hxd.net;

class NetworkClient {

	var host : NetworkHost;
	var resultID : Int;
	public var ownerObject : NetworkSerializable;

	public function new(h) {
		this.host = h;
	}

	public function sync() {
		host.fullSync(this);
	}

	@:allow(hxd.net.NetworkHost)
	function send(bytes : haxe.io.Bytes) {
	}

	public function sendMessage( msg : Dynamic ) {
		host.sendMessage(msg, this);
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
			var oldH = o.__host;
			o.__host = null;
			o.networkSync(ctx);
			o.__host = oldH;
			o.__bits = old;
		case NetworkHost.REG:
			var o : hxd.net.NetworkSerializable = cast ctx.getAnyRef();
			o.__host = host;
			host.makeAlive();
		case NetworkHost.UNREG:
			var o : hxd.net.NetworkSerializable = cast ctx.refs[ctx.getInt()];
			o.enableReplication = false;
			ctx.refs[o.__uid] = null;
		case NetworkHost.FULLSYNC:
			ctx.refs = [];
			@:privateAccess ctx.newObjects = [];
			while( true ) {
				var o = ctx.getAnyRef();
				if( o == null ) break;
			}
			host.makeAlive();
		case NetworkHost.RPC:
			var o : hxd.net.NetworkSerializable = cast ctx.refs[ctx.getInt()];
			var fid = ctx.getByte();
			if( !host.isAuth ) {
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
			if( !host.isAuth ) {
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

		case NetworkHost.MSG:
			var msg = haxe.Unserializer.run(ctx.getString());
			host.onMessage(this, msg);

		case x:
			error("Unknown message code " + x);
		}
		return @:privateAccess ctx.inPos;
	}

	function beginRPCResult() {
		host.flush();
		var ctx = host.ctx;
		host.hasData = true;
		host.targetClient = this;
		ctx.addByte(NetworkHost.RPC_RESULT);
		ctx.addInt(resultID);
		// after that RPC will add result value then return
	}

	public function stop() {
		if( host == null ) return;
		host.clients.remove(this);
		host.pendingClients.remove(this);
		host = null;
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
	static inline var MSG		 = 8;

	public static var current : NetworkHost = null;

	public var isAuth(default, null) : Bool;

	public var sendRate : Float = 0.;
	public var totalSentBytes : Int = 0;

	var lastSentTime : Float = 0.;
	var lastSentBytes = 0;
	var markHead : NetworkSerializable;
	var ctx : Serializer;
	var pendingClients : Array<NetworkClient>;
	var clients : Array<NetworkClient>;
	var logger : String -> Void;
	var hasData = false;
	var rpcUID = Std.random(0x1000000);
	var rpcWaits = new Map<Int,Serializer->Void>();
	var targetClient : NetworkClient;
	var aliveEvents : Array<Void->Void>;
	public var self(default,null) : NetworkClient;

	public function new() {
		current = this;
		isAuth = true;
		self = new NetworkClient(this);
		clients = [];
		aliveEvents = [];
		pendingClients = [];
		ctx = new Serializer();
		@:privateAccess ctx.newObjects = [];
		ctx.begin();
	}

	public function saveState( s : Serializable ) {
		return new hxd.net.Serializer().serialize(s);
	}

	public function loadSave<T:Serializable>( bytes : haxe.io.Bytes, c : Class<T> ) : T {
		ctx.refs = [];
		@:privateAccess ctx.newObjects = [];
		ctx.setInput(bytes, 0);
		return ctx.getKnownRef(c);
	}

	function mark(o:NetworkSerializable) {
		if( !isAuth ) {
			var owner = o.networkGetOwner();
			if( owner == null || clients[0].ownerObject != owner )
				throw "Client can't set property on " + o + " without ownership ("+owner + " should be "+clients[0].ownerObject+")";
			// allow to modify the property localy but don't send it to server
			return false;
		}
		o.__next = markHead;
		markHead = o;
		return true;
	}

	public dynamic function onMessage( from : NetworkClient, msg : Dynamic ) {
	}

	public function sendMessage( msg : Dynamic, ?to : NetworkClient ) {
		flush();
		targetClient = to;
		ctx.addByte(MSG);
		ctx.addString(haxe.Serializer.run(msg));
		doSend();
		targetClient = null;
	}

	function setTargetOwner( owner : NetworkSerializable ) {
		if( !isAuth )
			return true;
		if( owner == null ) {
			doSend();
			targetClient = null;
			return true;
		}
		flush();
		targetClient = null;
		for( c in clients )
			if( c.ownerObject == owner ) {
				targetClient = c;
				break;
			}
		return targetClient != null; // owner not connected
	}

	function beginRPC(o:NetworkSerializable, id:Int, onResult:Serializer->Void) {
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

	function fullSync( c : NetworkClient ) {
		if( !pendingClients.remove(c) )
			return;
		flush();
		clients.push(c);
		var refs = ctx.refs;
		ctx.begin();
		ctx.addByte(NetworkHost.FULLSYNC);
		for( o in refs )
			if( o != null )
				ctx.addAnyRef(o);
		ctx.addAnyRef(null);
		targetClient = c;
		doSend();
		targetClient = null;
	}

	public function defaultLogger( ?filter : String -> Bool ) {
		setLogger(function(str) {
			if( filter != null && !filter(str) ) return;
			str = (isAuth ? "[S] " : "[C] ") + str;
			str = haxe.Timer.stamp() + " " + str;
			#if	sys Sys.println(str); #else trace(str); #end
		});
	}

	public inline function addAliveEvent(f) {
		aliveEvents.push(f);
	}

	public function isAliveComplete() {
		return @:privateAccess ctx.newObjects.length == 0 && aliveEvents.length == 0;
	}

	public function makeAlive() {
		var objs = @:privateAccess ctx.newObjects;
		if( objs.length == 0 )
			return;
		while( true ) {
			var o = objs.shift();
			if( o == null ) break;
			var n = Std.instance(o, NetworkSerializable);
			if( n == null ) continue;
			if( logger != null )
				logger("Alive " + n +"#" + n.__uid);
			n.alive();
		}
		while( aliveEvents.length > 0 )
			aliveEvents.shift()();
	}

	public function setLogger( log : String -> Void ) {
		this.logger = log;
	}

	function register( o : NetworkSerializable ) {
		o.__host = this;
		if( ctx.refs[o.__uid] != null )
			return;
		if( logger != null )
			logger("Register " + o+"#"+o.__uid);
		ctx.addByte(REG);
		ctx.addAnyRef(o);
	}

	function unregister( o : NetworkSerializable ) {
		flushProps(); // send changes
		o.__host = null;
		o.__bits = 0;
		if( logger != null )
			logger("Unregister " + o+"#"+o.__uid);
		ctx.addByte(UNREG);
		ctx.addInt(o.__uid);
		ctx.refs[o.__uid] = null;
	}

	function doSend() {
		var bytes;
		@:privateAccess {
			bytes = ctx.out.getBytes();
			ctx.out = new haxe.io.BytesBuffer();
		}
		send(bytes);
		hasData = false;
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
			var n = o.__next;
			o.__next = null;
			o = n;
		}
		markHead = null;
	}

	public function flush() {
		flushProps();
		if( hasData ) doSend();
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

	static function enableReplication( o : NetworkSerializable, b : Bool ) {
		if( b ) {
			if( o.__host != null ) return;
			if( current == null ) throw "No NetworkHost defined";
			current.register(o);
		} else {
			if( o.__host == null ) return;
			o.__host.unregister(o);
		}
	}


}