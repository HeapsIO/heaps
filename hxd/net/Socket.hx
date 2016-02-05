package hxd.net;

private class SocketOutput extends haxe.io.Output {

	public function new() {
	}

	/**
		Delay sending data until flush() is called
	**/
	public function wait() {
	}

	override function writeByte( c : Int ) {
	}

	override function writeBytes( s : haxe.io.Bytes, pos : Int, len : Int ) : Int {
		return len;
	}

}

#if flash
private class FlashSocketOutput extends SocketOutput {
	var s : flash.net.Socket;
	var autoFlush = true;

	public function new(s) {
		super();
		this.s = s;
		s.endian = flash.utils.Endian.LITTLE_ENDIAN;
	}

	inline function f() if( autoFlush ) s.flush();

	override function wait() {
		autoFlush = false;
	}

	override function flush() {
		autoFlush = true;
		s.flush();
	}

	override function writeByte( c : Int ) {
		s.writeByte(c);
		f();
	}

	override function writeBytes( b : haxe.io.Bytes, pos : Int, len : Int ) : Int {
		if( len > 0 ) {
			s.writeBytes(b.getData(), pos, len);
			f();
		}
		return len;
	}

	override function writeInt32( i : Int ) {
		s.writeInt(i);
		f();
	}

	override function writeString( str : String ) {
		s.writeUTFBytes(str);
		f();
	}

}

private class FlashSocketInput extends haxe.io.Input {

	var sock : flash.net.Socket;

	public function new(s) {
		sock = s;
	}

	override function readBytes( bytes : haxe.io.Bytes, pos : Int, len : Int ) {
		if( len > (sock.bytesAvailable : Int) ) {
			len = sock.bytesAvailable;
			if( len == 0 ) throw new haxe.io.Eof();
		}
		if( len > 0 )
			sock.readBytes(bytes.getData(), pos, len);
		return len;
	}

	override function readByte() {
		if( sock.bytesAvailable == 0 )
			throw new haxe.io.Eof();
		return sock.readUnsignedByte();
	}

}
#end

class Socket {

	static var openedSocks = [];
	#if flash
	var s : flash.net.Socket;
	#end
	#if (flash && air3)
	var serv : flash.net.ServerSocket;
	#end
	public var out(default, null) : SocketOutput;
	public var input(default, null) : haxe.io.Input;
	public var timeout(default, set) : Null<Float>;

	public function new() {
		out = new SocketOutput();
	}

	public function set_timeout(t:Null<Float>) {
		#if flash
		if( s != null ) s.timeout = t == null ? 0x7FFFFFFF : Math.ceil(t * 1000);
		#end
		return this.timeout = t;
	}

	public function connect( host : String, port : Int, onConnect : Void -> Void ) {
		close();
		openedSocks.push(this);
		#if flash
		s = new flash.net.Socket();
		if( timeout != null ) this.timeout = timeout;
		s.addEventListener(flash.events.Event.CONNECT, function(_) {
			out = new FlashSocketOutput(s);
			input = new FlashSocketInput(s);
			onConnect();
		});
		bindEvents();
		s.connect(host, port);
		#else
		throw "Not implemented";
		#end
	}

	function bindEvents() {
		#if flash
		s.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			close();
			onError(e.text);
		});
		s.addEventListener(flash.events.Event.CLOSE, function(_) {
			close();
			onError("Closed");
		});
		s.addEventListener(flash.events.ProgressEvent.SOCKET_DATA, function(e:flash.events.ProgressEvent) {
			onData();
		});
		#end
	}

	public function bind( host : String, port : Int, onConnect : Socket -> Void, listenCount = 5 ) {
		close();
		openedSocks.push(this);
		#if (flash && air3)
		serv = new flash.net.ServerSocket();
		try serv.bind(port, host) catch( e : Dynamic ) {
			close();
			throw e;
		};
		serv.listen(listenCount);
		serv.addEventListener(flash.events.ServerSocketConnectEvent.CONNECT, function(e:flash.events.ServerSocketConnectEvent) {
			var sock = e.socket;
			var s = new Socket();
			s.s = sock;
			s.bindEvents();
			s.out = new FlashSocketOutput(sock);
			s.input = new FlashSocketInput(sock);
			openedSocks.push(s);
			onConnect(s);
		});
		#else
		throw "Not implemented";
		#end
	}

	public function close() {
		openedSocks.remove(this);
		#if (flash && air3)
		if( serv != null ) {
			try serv.close() catch( e : Dynamic ) { };
			serv = null;
		}
		#end
		#if flash
		if( s != null ) {
			try s.close() catch( e : Dynamic ) { };
			out = new SocketOutput();
			s = null;
		}
		#else
		throw "Not implemented";
		#end
	}

	public dynamic function onError(msg:String) {
		throw "Socket Error " + msg;
	}

	public dynamic function onData() {
	}

}