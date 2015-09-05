package hxd.net;

class CdbInspector extends cdb.jq.Client {

	static var CSS = hxd.res.Embed.getFileContent("hxd/net/inspect.min.css");
	public var host : String = "127.0.0.1";
	public var port = 6669;

	var sock : hxd.net.Socket;

	public function new( ?host, ?port ) {
		super();
		if( host != null )
			this.host = host;
		if( port != null )
			this.port = port;
		sock = new hxd.net.Socket();
		sock.onError = function(_) haxe.Timer.delay(connect,500);
		connect();
	}

	function connect() {
		sock.close();
		sock.connect(host, port, refresh);
	}

	override function sendBytes( msg : haxe.io.Bytes ) {
		sock.out.wait();
		sock.out.writeInt32(msg.length);
		sock.out.write(msg);
		sock.out.flush();
	}

	function refresh() {
		j.text("");
		send(SetCSS(CSS));
		J("<div>").addClass("test").text("hello").appendTo(j);
	}

}