
class Cursor implements hxbit.NetworkSerializable {

	@:s var color : Int;
	@:s public var uid : Int;
	@:s public var x(default, set) : Float;
	@:s public var y(default, set) : Float;

	var net : Network;
	var bmp : h2d.Graphics;

	public function new( color, uid=0 ) {
		this.color = color;
		this.uid = uid;
		init();
		x = 0;
		y = 0;
	}

	public function networkAllow( op : hxbit.NetworkSerializable.Operation, propId : Int, client : hxbit.NetworkSerializable ) : Bool {
		return client == this;
	}

	function set_x( v : Float ) {
		if( v == x ) return v;
		if( bmp != null ) bmp.x = v;
		return this.x = v;
	}

	function set_y( v : Float ) {
		if( bmp != null ) bmp.y = v;
		return this.y = v;
	}

	public function toString() {
		return "Cursor " + StringTools.hex(color, 6)+(enableReplication?":ALIVE":"");
	}

	function init() {
		net = Network.inst;
		net.log("Init "+this);
		bmp = new h2d.Graphics(net.s2d);
		bmp.beginFill(color, 0.5);
		bmp.drawCircle(0, 0, 10);
		bmp.beginFill(color);
		bmp.drawCircle(0, 0, 5);

		enableReplication = true;

		var i = new h2d.Interactive(10, 10, bmp);
		i.x = i.y = -5;
		i.isEllipse = true;
		i.onClick = function(_) blink( 2 + Math.random() * 2 );
	}

	@:rpc function blink( s : Float ) {
		bmp.scale(s);
		net.event.waitUntil(function(dt) {
			bmp.scaleX *= Math.pow(0.9, dt * 60);
			bmp.scaleY *= Math.pow(0.9, dt * 60);
			if( bmp.scaleX < 1 ) {
				bmp.scaleX = bmp.scaleY = 1;
				return true;
			}
			return false;
		});
	}

	public function alive() {
		init();
		// refresh bmp
		this.x = x;
		this.y = y;
		if( uid == net.uid ) {
			net.cursor = this;
			net.host.self.ownerObject = this;
		}
	}

}

//PARAM=-lib hxbit
class Network extends hxd.App {

	static var HOST = "127.0.0.1";
	static var PORT = 6676;

	public var host : hxd.net.SocketHost;
	public var event : hxd.WaitEvent;
	public var uid : Int;
	public var cursor : Cursor;

	override function init() {
		event = new hxd.WaitEvent();
		host = new hxd.net.SocketHost();
		host.setLogger(function(msg) log(msg));

		if( !hxd.net.Socket.ALLOW_BIND ) {
			#if flash
			log("Using network with flash requires compiling with -lib air3 and running through AIR");
			#else
			log("Server not allowed on this platform");
			#end
		}

		try {
			host.wait(HOST, PORT, function(c) {
				log("Client Connected");
			});
			host.onMessage = function(c,uid:Int) {
				log("Client identified ("+uid+")");
				var cursorClient = new Cursor(0x0000FF, uid);
				c.ownerObject = cursorClient;
				c.sync();
			};
			log("Server Started");

			start();
		} catch( e : Dynamic ) {

			// we could not start the server
			log("Connecting");

			uid = 1 + Std.random(1000);
			host.connect(HOST, PORT, function(b) {
				if( !b ) {
					log("Failed to connect to server");
					return;
				}
				log("Connected to server");
				host.sendMessage(uid);
			});
		}
	}

	public function log( s : String, ?pos : haxe.PosInfos ) {
		pos.fileName = (host.isAuth ? "[S]" : "[C]") + " " + pos.fileName;
		haxe.Log.trace(s, pos);
	}

	function start() {
		cursor = new Cursor(0xFF0000);
		log("Live");
		host.makeAlive();
	}

	override function update(dt:Float) {
		event.update(dt);
		if( cursor != null ) {
			cursor.x = s2d.mouseX;
			cursor.y = s2d.mouseY;
		}
		host.flush();
	}

	public static var inst : Network;
	static function main() {
		#if air3
		@:privateAccess hxd.Stage.getInstance().multipleWindowsSupport = true;
		#end
		inst = new Network();
	}

}
