package hxd.snd;

private class BytesOutput extends haxe.io.Output {

	var bytes : haxe.io.Bytes;
	var position : Int;
	#if flash
	var m : hxd.impl.Memory.MemoryReader;
	#end

	public function new() {
	}

	public function done() {
		#if flash
		m.end();
		#end
	}

	public function init( bytes : haxe.io.Bytes, position : Int ) {
		this.bytes = bytes;
		this.position = position;
		#if flash
		m = hxd.impl.Memory.select(bytes);
		#end
	}

	override function writeFloat(f) {
		#if flash
		m.wfloat(position, f);
		#else
		bytes.setFloat(position, f);
		#end
		position += 4;
	}

}

class OggData extends Data {

	var reader : stb.format.vorbis.Reader;
	var output : BytesOutput;
	var decodedFirst : Int;
	var decodedLast : Int;
	var decoded : haxe.io.Bytes;
	static inline var CACHED_SAMPLES = 44100 * 3; // 3s of cached sound

	public function new( bytes : haxe.io.Bytes ) {
		reader = stb.format.vorbis.Reader.openFromBytes(bytes);
		samples = reader.totalSample;
		output = new BytesOutput();
		decodedFirst = 0;
		decodedLast = 0;
	}

	override public function decode(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		var last = sampleStart + sampleCount;
		if( last > samples )
			throw "OUTSIDE";
		if( sampleStart < decodedFirst || last > decodedLast ) {
			var need = sampleCount - sampleStart;
			if( need > CACHED_SAMPLES || samples > CACHED_SAMPLES ) {
				// directly decode in out
				output.init(out, outPos);
				reader.currentSample = sampleStart;
				reader.read(output, sampleCount, 2, 44100, true);
				output.done();
				return;
			}
			if( decoded == null )
				decoded = haxe.io.Bytes.alloc((samples < CACHED_SAMPLES ? samples : CACHED_SAMPLES) * 2 * 4);
			need = CACHED_SAMPLES;
			if( sampleStart + need > samples ) need = samples - sampleStart;
			output.init(decoded,0);
			reader.currentSample = sampleStart;
			reader.read(output, need, 2, 44100, true);
			output.done();
			decodedFirst = sampleStart;
			decodedLast = sampleStart + need;
			if( sampleStart == 0 && need == samples ) {
				reader = null;
				output = null;
			}
		}
		out.blit(outPos, decoded, (sampleStart - decodedFirst) * 2 * 4, sampleCount * 2 * 4);
	}


}