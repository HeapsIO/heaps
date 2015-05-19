package hxd.snd;

class Data {

	public var samples(default, null) : Int;

	/**
		Decode sound samples as stereo 32 bit floats 44.1Khz
		If you decode while no data is available, blank samples will be written.
	**/
	public function decode( out : haxe.io.Bytes, outPos : Int, sampleStart : Int, sampleCount : Int ) : Void {
		throw "not implemented";
	}

	/**
		Some platforms might require some data to be loaded before we can start decoding.
		Use load() and wait for onEnd to make sure that the sound data and the correct number of samples is available.
		onEnd() might be called back immediately if the data is already available.
	**/
	public function load( onEnd : Void -> Void ) {
		onEnd();
	}

}