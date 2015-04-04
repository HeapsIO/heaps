import hxd.snd.NativeChannel;

class NoiseChannel extends hxd.snd.NativeChannel {

	public function new() {
		super(4096);
	}

	override function onSample( buf : haxe.io.Float32Array ) {
		for( i in 0...buf.length )
			buf[i] = Math.random() * 2 - 1;
	}

}


class Sound extends hxd.App {

	var chan : hxd.snd.SoundChannel;

	override function init() {
		var c = new NoiseChannel();
		haxe.Timer.delay(c.stop, 1000);
	}

	static function main() {
		new Sound();
	}

}