package hxd.snd.openal;

#if hlopenal
import openal.AL.Source;
import openal.AL.Buffer;
typedef AL = openal.AL;
typedef EFX = openal.EFX;
#else
import hxd.snd.openal.Emulator;
typedef AL = Emulator;
#end

class BufferHandle {
	public var inst : Buffer;
	public var isEnd : Bool;
	public function new() { }
}

class SourceHandle {
	public var inst           : Source;
	public var sampleOffset   : Int;
	public var playing        : Bool;
	var nextAuxiliarySend     : Int;
	var freeAuxiliarySends    : Array<Int>;
	var effectToAuxiliarySend : Map<Effect, Int>;

	public function new() {
		sampleOffset = 0;
		nextAuxiliarySend = 0;
		freeAuxiliarySends = [];
		effectToAuxiliarySend = new Map();
	}

	public function acquireAuxiliarySend(effect : Effect) : Int {
		var send = freeAuxiliarySends.length > 0
			? freeAuxiliarySends.shift()
			: nextAuxiliarySend++;
		effectToAuxiliarySend.set(effect, send);
		return send;
	}

	public function getAuxiliarySend(effect : Effect) : Int {
		return effectToAuxiliarySend.get(effect);
	}

	public function releaseAuxiliarySend(effect : Effect) : Int {
		var send = effectToAuxiliarySend.get(effect);
		effectToAuxiliarySend.remove(effect);
		freeAuxiliarySends.push(send);
		return send;
	}
}