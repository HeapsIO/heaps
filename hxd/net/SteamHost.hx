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

@:allow(hxd.net.SteamHost)
class SteamClient extends NetworkClient {

	static var MAX_PACKET_SIZE = 512 * 1024;
	static var MAX_PAYLOAD_SIZE = MAX_PACKET_SIZE - 32;

	public var user : steam.User;

	var bigPacket : haxe.io.Bytes;
	var bigPacketPosition = 0;

	public function new(host, u) {
		super(host);
		this.user = u;
	}

	override function send( data : haxe.io.Bytes ) {
		if( data.length > MAX_PACKET_SIZE ) {
			// split
			var bsize = haxe.io.Bytes.alloc(4);
			bsize.setInt32(0, data.length);
			host.sendCustom(SteamHost.CBIG_PACKET, bsize, this);
			var split = Std.int(data.length / MAX_PAYLOAD_SIZE);
			for( i in 0...split )
				host.sendCustom(SteamHost.CBIG_PACKET_DATA, data.sub(i * MAX_PAYLOAD_SIZE, MAX_PAYLOAD_SIZE), this);
			host.sendCustom(SteamHost.CBIG_PACKET_DATA, data.sub(split * MAX_PAYLOAD_SIZE, data.length - split * MAX_PAYLOAD_SIZE), this);
			return;
		}
		//Sys.println(user + " > [" + data.length+"] " + (data.length > 100 ? data.sub(0,60).toHex()+"..."+data.sub(data.length-8,8).toHex() : data.toHex()));
		steam.Networking.sendP2P(user, data, Reliable);
	}

	override function stop() {
		super.stop();
		//Sys.println("CLOSE " + user);
		steam.Networking.closeSession(user);
	}

}

class SteamHost extends NetworkHost {

	public static inline var CHELLO_CLIENT = 0;
	public static inline var CHELLO_SERVER = 1;
	public static inline var CBIG_PACKET = 2;
	public static inline var CBIG_PACKET_DATA = 3;

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
		isAuth = false;
		this.server = server;
		clients = [new SteamClient(this, server)];
		steam.Networking.startP2P(this);
		this.onConnected = onConnected;
		sendCustom(CHELLO_CLIENT);
	}

	override function onCustom(from:NetworkClient, id:Int, ?data:haxe.io.Bytes) {
		switch( id ) {
		case CHELLO_CLIENT if( isAuth ):
			// was disconnected !
			if( clients.indexOf(from) >= 0 ) {
				clients.remove(from);
				pendingClients.push(from);
			}
			sendCustom(CHELLO_SERVER, from);
		case CHELLO_SERVER if( !isAuth && from == clients[0] ):
			onConnected(true);
		case CBIG_PACKET:
			var from = Std.instance(from, SteamClient);
			from.bigPacket = haxe.io.Bytes.alloc(data.getInt32(0));
			from.bigPacketPosition = 0;
		case CBIG_PACKET_DATA:
			var from = Std.instance(from, SteamClient);
			from.bigPacket.blit(from.bigPacketPosition, data, 0, data.length);
			from.bigPacketPosition += data.length;
			if( from.bigPacketPosition == from.bigPacket.length ) {
				var data = from.bigPacket;
				from.bigPacket = null;
				@:privateAccess {
					var oldIn = ctx.input;
					var oldPos = ctx.inPos;
					onData(from.user, data);
					ctx.input = oldIn;
					ctx.inPos = oldPos;
				}
			}
		default:
			throw "Unknown custom packet " + id;
		}
	}

	public function startServer() {
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
		for( c in pendingClients )
			if( Std.instance(c, SteamClient).user == user )
				return c;
		return null;
	}

	function onConnectionError( user : steam.User, error : steam.Networking.NetworkStatus ) {
		if( !isAuth && user == server ) {
			onConnected(false);
			return;
		}
		if( isAuth ) {
			var c = getClient(user);
			if( c != null ) c.stop();
		}
	}

	function onConnectionRequest( user : steam.User ) {
		return true;
	}

	function onData( from : steam.User, data : haxe.io.Bytes ) {
		//Sys.println(from + " < [" + data.length+"] " + (data.length > 100 ? data.sub(0,60).toHex()+"..."+data.sub(data.length-8,8).toHex() : data.toHex()));
		var c = getClient(from);
		if( c == null ) {
			// prevent messages coming from previous connection to reach us
			if( !isCustomMessage(data, CHELLO_CLIENT) )
				return;
			c = new SteamClient(this, from);
			pendingClients.push(c);
		}
		@:privateAccess c.processMessagesData(data, data.length);
	}


}