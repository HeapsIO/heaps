package hxd.net;

class NetworkClient {

	var host : NetworkHost;
	var resultID : Int;
	public var seqID : Int;
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
		var mid = ctx.getByte();
		switch( mid ) {
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
			o.__host = null;
			ctx.refs.remove(o.__uid);
		case NetworkHost.FULLSYNC:
			ctx.refs = new Map();
			@:privateAccess {
				hxd.net.Serializer.UID = 0;
				hxd.net.Serializer.SEQ = ctx.getByte();
				ctx.newObjects = [];
			};
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

			if( host.checkEOM ) ctx.addByte(NetworkHost.EOM);

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

		case NetworkHost.BMSG:
			var msg = ctx.getBytes();
			host.onMessage(this, msg);

		case x:
			error("Unknown message code " + x);
		}
		return @:privateAccess ctx.inPos;
	}

	function beginRPCResult() {
		host.flush();

		if( host.logger != null )
			host.logger("RPC RESULT #" + resultID);

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
	static inline var BMSG		 = 9;
	static inline var EOM		 = 0xFF;

	public var checkEOM(get, never) : Bool;
	inline function get_checkEOM() return true;

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

	public function saveState() {
		var s = new hxd.net.Serializer();
		s.begin();
		var clids = [];
		for( r in ctx.refs )
			if( !s.refs.exists(r.__uid) ) {
				var cl = r.getCLID();
				var cval = Type.getClass(r);
				s.addCLID(cl);
				if( !clids[cl] ) {
					clids[cl] = true;
					s.addString(Type.getClassName(cval));
				}
				s.addKnownRef(r);
				s.addByte(EOM);
			}
		s.addCLID(0xFFFF);
		return s.end();
	}

	public function loadSave( bytes : haxe.io.Bytes ) {
		ctx.refs = new Map();
		@:privateAccess ctx.newObjects = [];
		ctx.setInput(bytes, 0);
		var classByName = new Map();
		for( c in @:privateAccess Serializer.CLASSES )
			classByName.set(Type.getClassName(c), c);
		var clids = [];
		while( true ) {
			var cl = ctx.getCLID();
			if( cl == 0xFFFF ) break;
			var cval = clids[cl];
			if( cval == null ) {
				var cname = ctx.getString();
				cval = classByName.get(cname);
				if( cval == null ) throw "Unsupported class " + cname;
				clids[cl] = cval;
			}
			ctx.getKnownRef(cval);
			if( ctx.getByte() != EOM ) throw "Save file is not compatible with current version";
		}
	}

	function mark(o:NetworkSerializable) {
		if( !isAuth ) {
			var owner = o.networkGetOwner();
			if( owner == null || clients[0].ownerObject != owner )
				throw "Client can't set property on " + o + " without ownership ("+owner + " should be "+clients[0].ownerObject+")";
			// allow to modify the property localy and send it to server
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
		if( Std.is(msg, haxe.io.Bytes) ) {
			ctx.addByte(BMSG);
			ctx.addBytes(msg);
		} else {
			ctx.addByte(MSG);
			ctx.addString(haxe.Serializer.run(msg));
		}
		if( checkEOM ) ctx.addByte(EOM);
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
			logger("RPC " + o +"."+o.networkGetName(id,true)+"()");
		return ctx;
	}

	inline function endRPC() {
		if( checkEOM ) ctx.addByte(EOM);
	}

	function fullSync( c : NetworkClient ) {
		if( !pendingClients.remove(c) )
			return;
		flush();

		// unique client sequence number
		var seq = clients.length + 1;
		while( true ) {
			var found = false;
			for( c in clients )
				if( c.seqID == seq ) {
					found = true;
					break;
				}
			if( !found ) break;
			seq++;
		}
		ctx.addByte(seq);
		c.seqID = seq;

		clients.push(c);
		var refs = ctx.refs;
		ctx.begin();
		ctx.addByte(FULLSYNC);
		ctx.addByte(c.seqID);
		for( o in refs )
			if( o != null )
				ctx.addAnyRef(o);
		ctx.addAnyRef(null);
		if( checkEOM ) ctx.addByte(EOM);
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
		if( !isAuth ) {
			var owner = o.networkGetOwner();
			if( owner == null || owner != self.ownerObject )
				throw "Can't register "+o+" without ownership (" + owner + " should be " + self.ownerObject + ")";
		}
		if( logger != null )
			logger("Register " + o + "#" + o.__uid);
		ctx.addByte(REG);
		ctx.addAnyRef(o);
		if( checkEOM ) ctx.addByte(EOM);
	}

	function unmark( o : NetworkSerializable ) {
		if( o.__next == null )
			return;
		var prev = null;
		var h = markHead;
		while( h != o ) {
			prev = h;
			h = h.__next;
		}
		if( prev == null )
			markHead = o.__next;
		else
			prev.__next = o.__next;
		o.__next = null;
	}

	function unregister( o : NetworkSerializable ) {
		if( o.__host == null )
			return;
		if( !isAuth ) {
			var owner = o.networkGetOwner();
			if( owner == null || owner != self.ownerObject )
				throw "Can't unregister "+o+" without ownership (" + owner + " should be " + self.ownerObject + ")";
		}
		flushProps(); // send changes
		o.__host = null;
		o.__bits = 0;
		unmark(o);
		if( logger != null )
			logger("Unregister " + o+"#"+o.__uid);
		ctx.addByte(UNREG);
		ctx.addInt(o.__uid);
		if( checkEOM ) ctx.addByte(EOM);
		ctx.refs.remove(o.__uid);
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
			if( clients.length == 0 ) totalSentBytes += bytes.length; // still count for statistics
			for( c in clients )
				c.send(bytes);
		}
	}

	function flushProps() {
		var o = markHead;
		while( o != null ) {
			if( o.__bits != 0 ) {
				if( logger != null ) {
					var props = [];
					var i = 0;
					while( 1 << i <= o.__bits ) {
						if( o.__bits & (1 << i) != 0 )
							props.push(o.networkGetName(i));
						i++;
					}
					logger("SYNC " + o + "#" + o.__uid + " " + props.join("|"));
				}
				ctx.addByte(SYNC);
				ctx.addInt(o.__uid);
				o.networkFlush(ctx);
				if( checkEOM ) ctx.addByte(EOM);
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