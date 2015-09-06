package hxd.net;

class CdbInspector extends cdb.jq.Client {

	static var inst = null;
	static var CSS = hxd.res.Embed.getFileContent("hxd/net/inspect.min.css");

	public var host : String = "127.0.0.1";
	public var port = 6669;

	var sock : hxd.net.Socket;
	var connected = false;
	var oldLog : Dynamic -> haxe.PosInfos -> Void;

	public function new( ?host, ?port ) {
		super();
		inst = this; // prevent GC
		if( host != null )
			this.host = host;
		if( port != null )
			this.port = port;
		sock = new hxd.net.Socket();
		sock.onError = function(e) {
			connected = false;
			trace(e);
			haxe.Timer.delay(connect,500);
		}
		connect();
		oldLog = haxe.Log.trace;
		haxe.Log.trace = onTrace;
	}

	function onTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		if( !connected )
			oldLog(v, pos);
		else {
			J("<div>").addClass("line").text(pos.fileName+"(" + pos.lineNumber + ") : " + Std.string(v)).appendTo(J("#log"));
		}
	}

	function connect() {
		sock.close();
		sock.connect(host, port, function() {
			connected = true;
			refresh();
		});
	}

	override function sendBytes( msg : haxe.io.Bytes ) {
		sock.out.wait();
		sock.out.writeInt32(msg.length);
		sock.out.write(msg);
		sock.out.flush();
	}

	function refresh() {
		j.html('
			<div id="scene" class="panel" caption="Scene">
			</div>
			<div id="log" class="panel" caption="Log">
			</div>
		');
		send(SetCSS(CSS));
		J("#scene").dock(root, Left, 0.2);
		J("#log").dock(root, Down, 0.3);
	}

}