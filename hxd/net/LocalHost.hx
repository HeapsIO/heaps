package hxd.net;
import hxd.net.NetworkHost;

class LocalClient extends NetworkClient {

	var socket : Socket;

	var pendingBuffer : haxe.io.Bytes;
	var pendingPos : Int;
	var messageLength : Int = -1;

	public function new(host, s) {
		super(host);
		this.socket = s;
		if( s != null ) s.onData = readData;
	}

	override function error(msg:String) {
		socket.close();
		super.error(msg);
	}

	function readData() {
		if( messageLength < 0 ) {
			if( socket.input.available < 4 )
				return;
			messageLength = socket.input.readInt32();
			if( pendingBuffer == null || pendingBuffer.length < messageLength )
				pendingBuffer = haxe.io.Bytes.alloc(messageLength);
			pendingPos = 0;
		}
		var len = socket.input.readBytes(pendingBuffer, pendingPos, messageLength - pendingPos);
		pendingPos += len;
		if( pendingPos == messageLength ) {
			pendingPos = 0;
			while( pendingPos < messageLength ) {
				var oldPos = pendingPos;
				pendingPos = processMessage(pendingBuffer, pendingPos);
				if( host.checkEOM && pendingBuffer.get(pendingPos++) != NetworkHost.EOM )
					throw "Message missing EOM " + pendingBuffer.sub(oldPos, pendingPos - oldPos).toHex()+"..."+(pendingBuffer.sub(pendingPos,hxd.Math.imin(messageLength-pendingPos,128)).toHex());
			}
			messageLength = -1;
			readData();
		}
	}

	override function send( bytes : haxe.io.Bytes ) {
		socket.out.wait();
		socket.out.writeInt32(bytes.length);
		socket.out.write(bytes);
		socket.out.flush();
	}

	override function stop() {
		super.stop();
		if( socket != null ) {
			socket.close();
			socket = null;
		}
	}

}

class LocalHost extends NetworkHost {

	var connected = false;
	var socket : Socket;
	public var enableSound : Bool = true;

	public function new() {
		super();
		isAuth = false;
	}

	public function close() {
		if( socket != null ) {
			socket.close();
			socket = null;
		}
		connected = false;
	}

	public function connect( host : String, port : Int, ?onConnect : Bool -> Void ) {
		close();
		isAuth = false;
		socket = new Socket();
		socket.onError = function(msg) {
			if( !connected ) {
				socket.onError = function(_) { };
				onConnect(false);
			} else
				throw msg;
		};
		self = new LocalClient(this, socket);
		socket.connect(host, port, function() {
			connected = true;
			if( host == "127.0.0.1" ) enableSound = false;
			clients = [self];
			onConnect(true);
		});
	}

	public function wait( host : String, port : Int, ?onConnected : NetworkClient -> Void ) {
		close();
		isAuth = false;
		socket = new Socket();
		self = new LocalClient(this, null);
		socket.bind(host, port, function(s) {
			var c = new LocalClient(this, s);
			pendingClients.push(c);
			if( onConnected != null ) onConnected(c);
		});
		isAuth = true;
	}

	public static function openNewWindow() {
		#if (flash && air3)
		var opt = new flash.display.NativeWindowInitOptions();
		opt.renderMode = flash.display.NativeWindowRenderMode.DIRECT;
		var win = new flash.display.NativeWindow(opt);
		win.width += flash.Lib.current.stage.stageWidth - win.stage.stageWidth;
		win.height += flash.Lib.current.stage.stageHeight - win.stage.stageHeight;
		win.title = "Client";
		var l = new flash.display.Loader();
		var ctx = new flash.system.LoaderContext(false, new flash.system.ApplicationDomain());
		ctx.allowCodeImport = true;
		win.stage.addChild(l);
		l.loadBytes(flash.Lib.current.stage.loaderInfo.bytes, ctx);
		win.activate();
		#else
		throw "Not implemented";
		#end
	}

}