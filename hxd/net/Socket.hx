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
#end

class Socket {

	#if flash
	var s : flash.net.Socket;
	#end
	public var out(default, null) : SocketOutput;

	public function new() {
		out = new SocketOutput();
	}

	public function connect( host : String, port : Int, onConnect : Void -> Void ) {
		close();
		#if flash
		s = new flash.net.Socket();
		s.addEventListener(flash.events.Event.CONNECT, function(_) {
			out = new FlashSocketOutput(s);
			onConnect();
		});
		s.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			close();
			onError(e.text);
		});
		s.addEventListener(flash.events.Event.CLOSE, function(_) {
			close();
			onError("Closed");
		});
		s.connect(host, port);
		#else
		throw "Not implemented";
		#end
	}

	public function close() {
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

}