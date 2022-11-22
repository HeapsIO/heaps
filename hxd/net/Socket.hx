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

private class SocketInput extends haxe.io.Input {

	public var available(get, never) : Int;

	function get_available() {
		return 0;
	}

}

class Socket {

	static var openedSocks = [];
	#if flash
	var s : flash.net.Socket;
	#elseif hl
	var s : #if (haxe_ver >= 4) hl.uv.Stream #else Dynamic #end;
	#elseif (nodejs && hxnodejs)
	var s : js.node.net.Socket;
	#end
	#if (flash && air3)
	var serv : flash.net.ServerSocket;
	#end
	public var out(default, null) : SocketOutput;
	public var input(default, null) : SocketInput;
	public var timeout(default, set) : Null<Float>;

	public function new() {
		out = new SocketOutput();
		#if hl
			#if (haxe_ver < 4)
			throw "Not supported in Haxe 3.x";
			#end
		#end
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
		#elseif (hl && haxe_ver >= 4)
		var tcp = new hl.uv.Tcp();
		s = tcp;
		tcp.connect(new sys.net.Host(host), port, function(b) {
			if( !b ) {
				close();
				onError("Failed to connect");
				return;
			}
			out = new HLSocketOutput(this);
			input = new HLSocketInput(this);
			onConnect();
		});
		#else
		throw "Not implemented";
		#end
	}

	#if flash
	function bindEvents() {
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
	}
	#end

	public static inline var ALLOW_BIND = #if (flash && air3) true #else false #end;

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
		#elseif (hl && haxe_ver >= 4)
		var tcp = new hl.uv.Tcp();
		s = tcp;
		try {
			tcp.bind(new sys.net.Host(host), port);
			tcp.listen(10, function() {
				var sock = tcp.accept();
				var s = new Socket();
				s.s = sock;
				s.out = new HLSocketOutput(s);
				s.input = new HLSocketInput(s);
				openedSocks.push(s);
				onConnect(s);
			});
		} catch( e : Dynamic ) {
			close();
			throw e;
		}
		#elseif (nodejs && hxnodejs)
		js.node.Net.createServer(function(sock) {
			var s = new Socket();
			s.s = sock;
			s.out = new NodeSocketOutput(s);
			s.input = new NodeSocketInput(s);
			openedSocks.push(s);
			onConnect(s);
		}).on('error', function(e) {
			close();
			throw e;
		}).listen(port, host, listenCount);
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
		#if (flash || hl)
		if( s != null ) {
			try s.close() catch( e : Dynamic ) { };
			out = new SocketOutput();
			s = null;
		}
		#elseif (nodejs && hxnodejs)
		if( s != null ) {
			s.destroy();
			out = new SocketOutput();
			s = null;
		}
		#end
	}

	public dynamic function onError(msg:String) {
		throw "Socket Error " + msg;
	}

	public dynamic function onData() {
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

	override function writeString( str : String #if (haxe_ver >= 4) , ?encoding :  haxe.io.Encoding #end ) {
		s.writeUTFBytes(str);
		f();
	}

}

private class FlashSocketInput extends SocketInput {

	var sock : flash.net.Socket;

	public function new(s) {
		sock = s;
	}

	override function get_available() {
		return sock.bytesAvailable;
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

#elseif hl

class HLSocketOutput extends SocketOutput {

	var tmpBuf : haxe.io.Bytes;
	var s : Socket;
	var onWriteResult : Bool -> Void;

	public function new(s) {
		super();
		this.s = s;
		onWriteResult = writeResult;
	}

	function writeResult(b) {
		if( !b ) {
			s.close();
			s.onError("Failed to write data");
		}
	}

	override function writeByte(c:Int) {
		if( tmpBuf == null )
			tmpBuf = haxe.io.Bytes.alloc(1);
		tmpBuf.set(0, c);
		@:privateAccess s.s.write(tmpBuf, onWriteResult);
	}

	override function writeBytes(buf:haxe.io.Bytes, pos:Int, len:Int):Int {
		@:privateAccess s.s.write(buf, onWriteResult, pos, len);
		return len;
	}

}

class HLSocketInput extends SocketInput {

	var s : Socket;
	var data : hl.Bytes;
	var pos : Int;
	var len : Int;
	var size : Int;

	public function new(sock) {
		this.s = sock;
		@:privateAccess s.s.readStartRaw(onData);
	}

	function onData(recvData:hl.Bytes, recv:Int) {
		if( recv < 0 ) {
			s.close();
			s.onError("Connection closed");
			return;
		}
		var req = pos + len + recv;
		if( req > size && pos >= (size >> 1) ) {
			data.blit(0, data, pos, len);
			pos = 0;
			req -= pos;
		}
		if( req > size ) {
			var nsize = size == 0 ? 1024 : size;
			while( nsize < req ) nsize = (nsize * 3) >> 1;
			var ndata = new hl.Bytes(nsize);
			ndata.blit(0, data, pos, len);
			data = ndata;
			size = nsize;
			pos = 0;
		}
		data.blit(pos + len, recvData, 0, recv);
		len += recv;
		s.onData();
	}

	override function get_available() {
		return len;
	}

	override function readByte():Int {
		if( len == 0 ) throw new haxe.io.Eof();
		var c = data[pos++];
		len--;
		return c;
	}

	override function readBytes(s:haxe.io.Bytes, pos:Int, len:Int):Int {
		if( pos < 0 || len < 0  || pos + len > s.length ) throw haxe.io.Error.OutsideBounds;
		var max = len < this.len ? len : this.len;
		@:privateAccess s.b.blit(pos, data, this.pos, max);
		this.pos += max;
		this.len -= max;
		return max;
	}

}

#elseif (nodejs && hxnodejs)

class NodeSocketOutput extends SocketOutput {

	var tmpBuf : js.node.Buffer;
	var s : Socket;

	public function new(s) {
		super();
		this.s = s;
		@:privateAccess s.s.on('error', () -> writeResult(false));
		@:privateAccess s.s.on('end', () -> s.close());
	}

	function writeResult(b) {
		if( !b ) {
			s.close();
			s.onError("Failed to write data");
		}
	}

	override function writeByte(c:Int) {
		if( tmpBuf == null )
			tmpBuf = js.node.Buffer.alloc(1);
		tmpBuf.fill(c);
		@:privateAccess s.s.write(tmpBuf);
	}

	override function writeBytes(buf:haxe.io.Bytes, pos:Int, len:Int):Int {
		@:privateAccess s.s.write(buf.sub(pos, len).b);
		return len;
	}

}

class NodeSocketInput extends SocketInput {

	var s : Socket;
	var data : js.node.Buffer;
	var pos : Int = 0;
	var len : Int = 0;
	var size : Int = 0;

	public function new(sock) {
		this.s = sock;
		@:privateAccess s.s.on('data', buf -> onData(buf, buf.length));
		@:privateAccess s.s.on('end', () -> onData(js.node.Buffer.from([]), -4095));
	}

	function onData(buf:js.node.Buffer, recv:Int) {
		if( recv < 0 ) {
			s.close();
			s.onError("Connection closed");
			return;
		}
		if (data == null)
			data = js.node.Buffer.alloc(len - pos);
		var req = pos + len + recv;
		if( req > size && pos >= (size >> 1) ) {
			data.copy(data, 0, pos, pos+len);
			pos = 0;
			req -= pos;
		}
		if( req > size ) {
			var nsize = size == 0 ? 1024 : size;
			while( nsize < req ) nsize = (nsize * 3) >> 1;
			var ndata = js.node.Buffer.alloc(nsize);
			data.copy(ndata, 0, pos, pos+len);
			data = ndata;
			size = nsize;
			pos = 0;
		}
		buf.copy(data, pos + len, 0, recv);
		len += recv;
		s.onData();
	}

	override function get_available() {
		return len;
	}

	override function readByte():Int {
		if( len == 0) throw new haxe.io.Eof();
		var c = data[pos++];
		len--;
		return c;
	}

	override function readBytes(s:haxe.io.Bytes, pos:Int, len:Int):Int {
		if( pos < 0 || len < 0  || pos + len > s.length ) throw haxe.io.Error.OutsideBounds;
		var max = len < this.len ? len : this.len;
		data.copy(@:privateAccess s.b, pos, this.pos, this.pos+max);
		this.pos += max;
		this.len -= max;
		return max;
	}

}

#end
