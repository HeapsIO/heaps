/*
 * Copyright (C)2015-2016 Nicolas Cannasse
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package hxd.net;

#if !hxbit
#error	"Using SocketHost requires compiling with -lib hxbit"
#end
import hxbit.NetworkHost;

class SocketClient extends NetworkClient {

	var socket : Socket;

	public function new(host, s) {
		super(host);
		this.socket = s;
		if( s != null )
			s.onData = function() {
				// process all pending messages
				while( socket != null && readData(socket.input, socket.input.available) ) {
				}
			}
	}

	override function error(msg:String) {
		socket.close();
		super.error(msg);
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

class SocketHost extends NetworkHost {

	var connected = false;
	var socket : Socket;
	public var enableSound : Bool = true;

	public function new() {
		super();
		isAuth = false;
	}

	override function dispose() {
		super.dispose();
		close();
	}

	function close() {
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
				if( onConnect != null ) onConnect(false);
			} else
				throw msg;
		};
		self = new SocketClient(this, socket);
		socket.connect(host, port, function() {
			connected = true;
			if( host == "127.0.0.1" ) enableSound = false;
			clients = [self];
			if( onConnect != null ) onConnect(true);
		});
	}

	public function wait( host : String, port : Int, ?onConnected : NetworkClient -> Void ) {
		close();
		isAuth = false;
		socket = new Socket();
		self = new SocketClient(this, null);
		socket.bind(host, port, function(s) {
			var c = new SocketClient(this, s);
			pendingClients.push(c);
			s.onError = function(_) c.stop();
			if( onConnected != null ) onConnected(c);
		});
		isAuth = true;
	}

	public function offlineServer() {
		close();
		self = new SocketClient(this, null);
		isAuth = true;
	}

}