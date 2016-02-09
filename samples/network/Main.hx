
class Cursor implements hxd.net.NetworkSerializable {

	@:s var color : Int;
	@:s public var x(default, set) : Float;
	@:s public var y(default, set) : Float;

	var main : Main;
	var bmp : h2d.Graphics;

	public function new( color ) {
		this.color = color;
		init();
		x = 0;
		y = 0;
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
		main = Main.inst;
		main.log("Init "+this);
		bmp = new h2d.Graphics(main.s2d);
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
		main.event.waitUntil(function(dt) {
			bmp.scaleX *= Math.pow(0.9, dt);
			bmp.scaleY *= Math.pow(0.9, dt);
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
	}

}

class Main extends hxd.App {

	static var HOST = "127.0.0.1";
	static var PORT = 6676;

	public var host : hxd.net.LocalHost;
	public var event : hxd.WaitEvent;
	var cursor : Cursor;

	override function init() {
		event = new hxd.WaitEvent();
		host = new hxd.net.LocalHost();
		host.setLogger(function(msg) log(msg));
		try {
			host.wait(HOST, PORT, function(c) {
				log("Client Connected, sending data");

				var cursorClient = new Cursor(0x0000FF);
				c.fullSync(cursorClient);

			});
			log("Server Started");

			start();

			// force a new window to open, which will connect the client
			hxd.net.LocalHost.openNewWindow();
		} catch( e : Dynamic ) {
			// we could not start the server
			log("Connecting");

			host.connect(HOST, PORT, function(b) {
				if( !b ) {
					log("Failed to connect to server");
					return;
				}
				log("Connected to server");
				host.onSync = function(c) {
					log("Received " + c + " from server");
					cursor = cast c;

					log("Live");
					host.makeAlive();
				};
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

	public static var inst : Main;
	static function main() {
		#if air3
		@:privateAccess hxd.Stage.getInstance().multipleWindowsSupport = true;
		#end
		inst = new Main();
	}

}