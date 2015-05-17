package hxd.snd;

class Data {

	public var samples(default, null) : Int;
	public function decode( out : haxe.io.Bytes, outPos : Int, sampleStart : Int, sampleCount : Int ) : Void {
		throw "not implemented";
	}

}