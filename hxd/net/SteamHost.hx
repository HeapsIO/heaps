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
#error	"Using SteamHost requires compiling with -lib hxbit"
#end
#if !steamwrap
#error	"Using SteamHost requires compiling with -lib steamwrap"
#end
import hxbit.NetworkHost;

class SteamClient extends NetworkClient {

	public var user : steam.User;

	public function new(host, u) {
		super(host);
		this.user = u;
	}

	override function send( bytes : haxe.io.Bytes ) {
		steam.Networking.sendP2P(user, bytes, Reliable);
	}

	override function stop() {
		super.stop();
		steam.Networking.closeSession(user);
	}

}

class SteamHost extends NetworkHost {

	public var enableSound : Bool = true;
	var server : steam.User;
	var onConnected : Bool -> Void;
	var input : haxe.io.BytesInput;

	public function new() {
		super();
		isAuth = false;
		self = new SteamClient(this, steam.Api.getUser());
		input = new haxe.io.BytesInput(haxe.io.Bytes.alloc(0));
	}

	override function dispose() {
		super.dispose();
		close();
	}

	function close() {
		steam.Networking.closeP2P();
	}

	public function startClient( server : steam.User, onConnected : Bool -> Void ) {
		close();
		isAuth = false;
		this.server = server;
		clients = [new SteamClient(this, server)];
		steam.Networking.startP2P(this);
		this.onConnected = onConnected;
		sendCustom(0);
	}

	override function onCustom(from:NetworkClient, id:Int, ?data:haxe.io.Bytes) {
		if( !isAuth && id == 1 && from == clients[0] )
			onConnected(true);
		if( isAuth && id == 0 )
			sendCustom(1, from);
	}

	public function startServer() {
		close();
		this.server = steam.Api.getUser();
		steam.Networking.startP2P(this);
		isAuth = true;
	}

	public function offlineServer() {
		close();
		isAuth = true;
	}

	public function getClient( user : steam.User ) {
		for( c in clients )
			if( Std.instance(c, SteamClient).user == user )
				return c;
		return null;
	}

	function onConnectionError( user : steam.User, error : steam.Networking.NetworkStatus ) {
		if( !isAuth && user == server ) {
			onConnected(false);
			return;
		}
	}

	function onConnectionRequest( user : steam.User ) {
		return true;
	}

	function onData( from : steam.User, data : haxe.io.Bytes ) {
		var c = getClient(from);
		if( c == null ) {
			c = new SteamClient(this, from);
			clients.push(c);
		}
		// reuse BytesInput (no allocation)
		@:privateAccess {
			#if hl
			input.b = data;
			input.len = input.totlen = data.length;
			#else
			throw "TODO:impl";
			#end
		}
		input.position = 0;
		while( @:privateAccess c.readData(input, input.length - input.position) ) {
		}
	}

	// ---

}