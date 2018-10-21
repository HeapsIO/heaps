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
#if !hlsteam
#error	"Using SteamHost requires compiling with -lib hlsteam"
#end
import hxbit.NetworkHost;

@:allow(hxd.net.SteamHost)
class SteamClient extends NetworkClient {

	public var user : steam.User;
	public var sessionId : Int = 0;

	var shost : SteamHost;
	var bigPacket : haxe.io.Bytes;
	var bigPacketPosition = 0;
	var cache : haxe.io.Bytes;

	public function new(host, u) {
		super(host);
		shost = Std.instance(host, SteamHost);
		this.user = u;
	}

	override function send( data : haxe.io.Bytes ) {
		@:privateAccess shost.service.sendData(user, sessionId, data);
	}

	override function stop() {
		super.stop();
		//Sys.println("CLOSE " + user);
		steam.Networking.closeSession(user);
	}

}

@:access(hxd.net.SteamHost)
class SteamService {

	static inline var SPing = 1;
	static inline var SPong = 2;
	static inline var SRequestSession = 3;
	static inline var SSessionAnswer = 4;
	static inline var SSessionData = 5;
	static inline var SBigPacket = 6;
	static inline var SBigPacketData = 7;

	static var previousIds = new Map();

	var tmpBuf : haxe.io.Bytes;
	var pingRequests : Array<{ user : steam.User, id : Int, time : Float, onResult : Null<Float> -> Void } > ;
	var pingID : Int;

	function new() {
		tmpBuf = haxe.io.Bytes.alloc(5);
		pingRequests = [];
		pingID = randomID();
	}

	function onConnectionRequest( u : steam.User ) : Bool {
		return true;
	}

	function onConnectionError( u : steam.User, error : steam.Networking.NetworkStatus ) : Void {
		for( h in hosts )
			h.onConnectionError(u);
	}

	function sendMessage( u : steam.User, msgId : Int, ident : Int, ?payload : haxe.io.Bytes, payloadSize = -1 ) {
		if( payload != null ) {
			if( payloadSize < 0 ) payloadSize = payload.length;
			if( tmpBuf.length < payloadSize + 5 )
				tmpBuf = haxe.io.Bytes.alloc(payloadSize + 5);
			tmpBuf.blit(5, payload, 0, payloadSize);
		} else
			payloadSize = 0;
		tmpBuf.set(0, msgId);
		tmpBuf.setInt32(1, ident);
		steam.Networking.sendP2P(u, tmpBuf, Reliable, 0, 5 + payloadSize);
	}

	static var MAX_PACKET_SIZE = 512 * 1024;
	static var MAX_PAYLOAD_SIZE = MAX_PACKET_SIZE - 32;

	public function sendData( u : steam.User, sessionId : Int, data : haxe.io.Bytes ) {
		if( data.length > MAX_PACKET_SIZE ) {
			// split
			var bsize = haxe.io.Bytes.alloc(4);
			bsize.setInt32(0, data.length);
			sendMessage(u, SBigPacket, sessionId, bsize);
			var split = Std.int(data.length / MAX_PAYLOAD_SIZE);
			for( i in 0...split )
				sendMessage(u, SBigPacketData, sessionId, data.sub(i * MAX_PAYLOAD_SIZE, MAX_PAYLOAD_SIZE));
			sendMessage(u, SBigPacketData, sessionId, data.sub(split * MAX_PAYLOAD_SIZE, data.length - split * MAX_PAYLOAD_SIZE));
			return;
		}
		sendMessage(u, SSessionData, sessionId, data);
	}

	function getClient( u : steam.User, sid : Int ) {
		for( h in hosts ) {
			var c = h.getClient(u);
			if( c == null ) continue;
			var cs = Std.instance(c, SteamClient);
			if( cs.sessionId == sid ) return cs;
		}
		return null;
	}

	function onData( u : steam.User, data : haxe.io.Bytes ) : Void {
		switch( data.get(0) ) {
		case SPing:
			var pid = data.getInt32(1);
			sendMessage(u, SPong, pid);
		case SPong:
			var pid = data.getInt32(1);
			for( p in pingRequests )
				if( p.user == u && p.id == pid ) {
					pingRequests.remove(p);
					p.onResult( haxe.Timer.stamp() - p.time );
					break;
				}
		case SRequestSession:
			var gid = data.getInt32(1);
			var sid = 0;
			for( h in hosts )
				if( h.isAuth && h.gameId == gid ) {
					sid = h.onUserConnect(u);
					break;
				}
			var tmp = haxe.io.Bytes.alloc(4);
			tmp.setInt32(0, gid);
			sendMessage(u, SSessionAnswer, sid, tmp);
		case SSessionAnswer:
			var sid = data.getInt32(1);
			var gid = data.getInt32(5);
			for( h in hosts )
				if( !h.isAuth && h.gameId == gid && h.server == u ) {
					var serv = Std.instance(h.clients[0], SteamClient);
					if( serv.sessionId != 0 ) break;
					serv.sessionId = sid;
					h.onConnected(sid != 0);
					break;
				}
		case SSessionData:
			var sid = data.getInt32(1);
			var from = getClient(u, sid);
			if( from != null )
				Std.instance(@:privateAccess from.host, SteamHost).onData(from, data, 5, data.length - 5);
		case SBigPacket:
			var sid = data.getInt32(1);
			var size = data.getInt32(5);
			var from = getClient(u, sid);
			if( from != null ) @:privateAccess {
				from.bigPacket = haxe.io.Bytes.alloc(size);
				from.bigPacketPosition = 0;
			}
		case SBigPacketData:
			var sid = data.getInt32(1);
			var from = getClient(u, sid);
			if( from != null ) @:privateAccess {
				from.bigPacket.blit(from.bigPacketPosition, data, 5, data.length - 5);
				from.bigPacketPosition += data.length - 5;
				if( from.bigPacketPosition == from.bigPacket.length ) {
					var data = from.bigPacket;
					from.bigPacket = null;
					Std.instance(from.host, SteamHost).onData(from, data, 0, data.length);
				}
			}
		default:
			// ignore
		}
	}

	public function randomID() {
		while( true ) {
			var id = Std.random(0x7FFFFFFF) + 1; // positive integer
			if( !previousIds.exists(id) ) {
				previousIds.set(id, true);
				return id;
			}
		}
	}

	public function requestSession( server : steam.User, gid : Int ) {
		sendMessage(server, SRequestSession, gid);
	}

	public function ping( user : steam.User, onResult : Null<Float> -> Void ) {
		var pid = pingID++;
		pingRequests.push({ user : user, id : pid, time : haxe.Timer.stamp(), onResult : onResult });
		sendMessage(user, SPing, pid);
	}

	public function stop( host : SteamHost ) {
		hosts.remove(host);
		if( hosts.length == 0 ) {
			inst = null;
			steam.Networking.closeP2P();
		}
	}

	static var hosts = new Array<SteamHost>();
	static var inst : SteamService;
	public static function start( ?host : SteamHost ) {
		if( inst == null ) {
			inst = new SteamService();
			steam.Networking.startP2P({ onData : inst.onData, onConnectionRequest: inst.onConnectionRequest, onConnectionError: inst.onConnectionError });
		}
		if( host != null )
			hosts.push(host);
		return inst;
	}

}

class SteamHost extends NetworkHost {

	public var enableRecording(default,set) : Bool = false;
	var recordedData : haxe.io.BytesBuffer;
	var recordedStart : Float;
	var server : steam.User;
	var onConnected : Bool -> Void;
	var input : haxe.io.BytesInput;
	var gameId : Int;
	var service : SteamService;

	public function new( gameId ) {
		super();
		this.gameId = gameId;
		isAuth = false;
		perPacketBytes += 20; // STEAM header
		self = new SteamClient(this, steam.Api.getUser());
		input = new haxe.io.BytesInput(haxe.io.Bytes.alloc(0));
	}

	function set_enableRecording(b) {
		if( b && recordedData == null ) {
			if( isAuth ) throw "Can't record if isAuth";
			recordedStart = haxe.Timer.stamp();
			recordedData = new haxe.io.BytesBuffer();
		}
		return enableRecording = b;
	}

	override function dispose() {
		super.dispose();
		close();
	}

	function close() {
		if( service != null ) {
			service.stop(this);
			service = null;
		}
	}

	public function startClient( server : steam.User, onConnected : Bool -> Void ) {
		isAuth = false;
		this.server = server;
		clients = [new SteamClient(this, server)];
		service = SteamService.start(this);
		this.onConnected = onConnected;
		service.requestSession(server, gameId);
	}

	function onUserConnect( user : steam.User ) {
		var c = getClient(user);
		if( c == null )
			c = new SteamClient(this, user);
		else {
			// was disconnected, let's reassign a SID
			clients.remove(c);
			pendingClients.remove(c);
		}
		pendingClients.push(c);
		var sid = service.randomID();
		@:privateAccess Std.instance(c,SteamClient).sessionId = sid;
		return sid;
	}

	public function startServer() {
		this.server = steam.Api.getUser();
		service = SteamService.start(this);
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

	function onConnectionError( user : steam.User ) {
		if( !isAuth && user == server ) {
			onConnected(false);
			return;
		}
		if( isAuth ) {
			var c = getClient(user);
			if( c != null ) c.stop();
		}
	}

	public function getRecordedData() {
		return recordedData == null ? null : recordedData.getBytes();
	}

	function onData( from : SteamClient, data : haxe.io.Bytes, startPos : Int, dataLen : Int ) {
		if( recordedData != null ) {
			recordedData.addFloat(haxe.Timer.stamp() - recordedStart);
			recordedData.addInt32(dataLen);
			recordedData.addBytes(data, startPos, dataLen);
		}
		@:privateAccess from.processMessagesData(data, startPos, dataLen);
	}


}