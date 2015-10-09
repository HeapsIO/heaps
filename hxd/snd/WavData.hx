package hxd.snd;
import format.wav.Data;

class WavData extends hxd.snd.Data {

	var rawData : haxe.io.Bytes;

	public function new(bytes) {
		init(new format.wav.Reader(new haxe.io.BytesInput(bytes)).read());
	}

	function init(d:format.wav.Data.WAVE) {
		var h = d.header;
		if( h.channels > 2 || (h.bitsPerSample != 8 && h.bitsPerSample != 16) )
			throw "Unsupported WAV " + h.bitsPerSample + " bits " + h.channels + " chans";

		var data = d.data;
		if( h.samplingRate != 44100 ) {
			// resample, without increasing bit resolution
			var out = new haxe.io.BytesOutput();
			var rpos = 0.;
			var max = data.length >> (h.bitsPerSample >> 4);
			var delta = h.samplingRate / 44100;
			var next = h.channels;
			while( rpos < max ) {
				var ipos = Std.int(rpos);
				var npos = ipos + next;
				if( npos >= max ) npos = max - next;
				var v1, v2;

				inline function getUI8(p) {
					return data.get(p);
				}
				inline function getI16(p) {
					var v = data.get(p) | (data.get(p + 1) << 8);
					if( v & 0x8000 != 0 ) v -= 0x10000;
					return v;
				}
				if( h.bitsPerSample == 8 ) {
					v1 = getUI8(ipos);
					v2 = getUI8(npos);
				} else {
					v1 = getI16(ipos<<1);
					v2 = getI16(npos<<1);
				}
				var v = Std.int(hxd.Math.lerp(v1, v2, rpos - ipos));
				if( h.bitsPerSample == 8 )
					out.writeByte(v);
				else
					out.writeInt16(v);
				rpos += delta;
			}
			data = out.getBytes();
		}

		var out = new haxe.io.BytesOutput();
		var input = new haxe.io.BytesInput(data);
		switch( [h.channels, h.bitsPerSample] ) {
		case [2, 16]:
			samples = data.length >> 2;
			for( i in 0...samples ) {
				out.writeFloat(input.readInt16() / 32767);
				out.writeFloat(input.readInt16() / 32767);
			}
		case [1, 16]:
			samples = data.length >> 1;
			for( i in 0...samples ) {
				var f = input.readInt16() / 32767;
				out.writeFloat(f);
				out.writeFloat(f);
			}
		case [1, 8]:
			samples = data.length;
			for( i in 0...samples ) {
				var f = input.readByte() / 255;
				out.writeFloat(f);
				out.writeFloat(f);
			}
		case [2, 8]:
			samples = data.length >> 1;
			for( i in 0...samples ) {
				out.writeFloat(input.readByte() / 255);
				out.writeFloat(input.readByte() / 255);
			}
		default:
		}
		rawData = out.getBytes();
	}

	override public function decode(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		out.blit(outPos, rawData, sampleStart * 8, sampleCount * 8);
	}

}