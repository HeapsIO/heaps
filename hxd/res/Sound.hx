package hxd.res;

enum SoundFormat {
	Wav;
	Mp3;
	OggVorbis;
}

class Sound extends Resource {

	static var ENABLE_AUTO_WATCH = true;

	var data : hxd.snd.Data;
	var channel : hxd.snd.Channel;
	public var lastPlay(default, null) = 0.;

	public static function supportedFormat( fmt : SoundFormat ) {
		return switch( fmt ) {
		case Wav, Mp3, OggVorbis:
			return true;
		}
	}

	public function getData() : hxd.snd.Data {
		if( data != null )
			return data;
		var bytes = entry.getBytes();

		#if flash
		if( bytes.length == 0 )
			return new hxd.snd.LoadingData(this);
		#end

		switch( bytes.get(0) ) {
		case 'R'.code: // RIFF (wav)
			data = new hxd.snd.WavData(bytes);
		case 255, 'I'.code: // MP3 (or ID3)
			data = new hxd.snd.Mp3Data(bytes);
		case 'O'.code: // Ogg (vorbis)
			data = new hxd.snd.OggData(bytes);
		default:
		}
		if( data == null )
			throw "Unsupported sound format " + entry.path;
		if ( ENABLE_AUTO_WATCH )
			watch(watchCallb);
		return data;
	}

	public function dispose() {
		stop();
		data = null;
	}

	public function stop() {
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
	}

	public function play( ?loop = false, ?volume = 1., ?channelGroup, ?soundGroup ) {
		lastPlay = haxe.Timer.stamp();
		channel = hxd.snd.Manager.get().play(this, channelGroup, soundGroup);
		channel.loop = loop;
		channel.volume = volume;
		return channel;
	}

	public static function startWorker() {
		return false;
	}

	@:access(hxd.snd.ChannelBase)
	function watchCallb() {
		var old = this.data;
		this.data = null;
		var data = getData();
		if (old != null) {
			if (old.channels != data.channels || old.samples != data.samples || old.sampleFormat != data.sampleFormat || old.samplingRate != data.samplingRate) {
				var manager = hxd.snd.Manager.get();
				for ( ch in manager.getAll(this) ) {
					ch.duration = data.duration;
					ch.position = ch.position;
				}
			}
		}
	}

}
