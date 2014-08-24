package hxd.res;

class Sound extends Resource {

	public static var BUFFER_SIZE = 4096;

	public static dynamic function getGlobalVolume( s : Sound ) {
		return 1.0;
	}

	public var volume(default, set) = 1.0;
	public var loop : Bool;

	#if flash
	var snd : flash.media.Sound;
	var channel : flash.media.SoundChannel;

	var mp3Data : flash.media.Sound;
	var wavHeader : format.wav.Data.WAVEHeader;
	var playingBytes : haxe.io.Bytes;
	var bytesPosition : Int;
	var mp3SampleCount : Int;
	var playDelay : Float = 0;
	#end

	public function getPosition() : Float {
		#if flash
		return channel.position;
		#else
		return 0.;
		#end
	}

	public function play() {
		playAt(0);
	}

	public function isPlaying() {
		#if flash
		return channel != null || playDelay > haxe.Timer.stamp();
		#else
		return false;
		#end
	}

	#if flash
	function onWavSample( e : flash.events.SampleDataEvent ) {
		var input = new haxe.io.BytesInput(playingBytes,bytesPosition);
		var out = e.data;
		var size = BUFFER_SIZE;
		out.position = 0;
		do {
			var write = size - Std.int(out.position/8);
			try {
				switch( [wavHeader.channels, wavHeader.bitsPerSample] ) {
				case [2, 16]:
					for( i in 0...write ) {
						out.writeFloat(input.readInt16() / 32767);
						out.writeFloat(input.readInt16() / 32767);
					}
				case [1, 16]:
					for( i in 0...write ) {
						var f = input.readInt16() / 32767;
						out.writeFloat(f);
						out.writeFloat(f);
					}
				case [1, 8]:
					for( i in 0...write ) {
						var f = input.readByte() / 255;
						out.writeFloat(f);
						out.writeFloat(f);
					}
				case [2, 8]:
					for( i in 0...write ) {
						out.writeFloat(input.readByte() / 255);
						out.writeFloat(input.readByte() / 255);
					}
				default:
				}
				break;
			} catch( e : haxe.io.Eof ) {
				if( loop )
					input.position = 0;
				else if( channel != null && out.position == 0 ) {
					haxe.Timer.delay(channel.stop, 150); // wait until the buffer is played
					channel = null;
				} else if( out.position > 0 ) {
					playDelay = haxe.Timer.stamp() + (out.position / 8) / 44000;
				}
			}
		} while( Std.int(out.position) < size * 8 && loop );
		// pad with zeroes
		while( Std.int(out.position) < size * 8 ) {
			out.writeFloat(0);
			out.writeFloat(0);
		}
		bytesPosition = input.position;
	}

	function onMp3Sample(e:flash.events.SampleDataEvent) {
		var out = e.data;
		out.position = 0;

		var MAGIC_DELAY = 2257;
		var position = bytesPosition;
		while( true ) {
			var size = BUFFER_SIZE - (out.position >> 3);
			if( size == 0 ) break;
			if( position + size >= mp3SampleCount ) {
				var read = mp3SampleCount - position;
				mp3Data.extract(out, read, position + MAGIC_DELAY);
				position = 0;
			} else {
				mp3Data.extract(out, size, position + MAGIC_DELAY);
				position += size;
			}
		}
		bytesPosition = position;
	}

	function initSound() {
		snd = new flash.media.Sound();
		var bytes = entry.getBytes();
		switch( bytes.get(0) ) {
		case 'R'.code: // RIFF (wav)
			var s = new format.wav.Reader(new haxe.io.BytesInput(bytes)).read();

			if( s.header.channels > 2 || (s.header.bitsPerSample != 8 && s.header.bitsPerSample != 16) )
				throw "Unsupported " + s.header.bitsPerSample + "x" + s.header.channels;

			wavHeader = s.header;
			playingBytes = s.data;
			snd.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, onWavSample);

		case 255, 'I'.code: // MP3 (or ID3)

			snd.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
			if( loop ) {

				var mp = new format.mp3.Reader(new haxe.io.BytesInput(bytes)).read();
				var samples = mp.sampleCount;
				var frame = mp.frames[0].data.toString();
				// http://gabriel.mp3-tech.org/mp3infotag.html
				var lame = frame.indexOf("LAME", 32 + 120);
				if( lame >= 0 ) {
					var startEnd = (frame.charCodeAt(lame + 21) << 16) | (frame.charCodeAt(lame + 22) << 8) | frame.charCodeAt(lame + 23);
					var start = startEnd >> 12;
					var end = startEnd & ((1 << 12) - 1);
					samples -= start + end + 1152; // first frame is empty
				}


				mp3Data = snd;
				mp3SampleCount = samples;
				snd = new flash.media.Sound();
				snd.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, onMp3Sample);
			}

		default:
			throw "Unsupported sound format " + entry.path;
		}
		hxd.impl.Tmp.saveBytes(bytes);
	}

	#end

	public function playAt( startPosition : Float ) {
		#if flash
		if( snd == null ) initSound();

		// can't mix two wavs
		if( wavHeader != null && channel != null )
			return;
		bytesPosition = 0;
		channel = snd.play(startPosition, loop?0x7FFFFFFF:0);
		if( !loop ) {
			var chan = channel;
			channel.addEventListener(flash.events.Event.SOUND_COMPLETE, function(e) { chan.stop(); if( chan == channel ) channel = null; } );
		}
		volume = volume;
		#end
	}

	public function stop() {
		#if flash
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		#end
	}

	function set_volume( v : Float ) {
		volume = v;
		#if flash
		if( channel != null )
			channel.soundTransform = new flash.media.SoundTransform(v * getGlobalVolume(this));
		#end
		return v;
	}

}