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

	var time = 0.;
	static var music : hxd.snd.Worker;

	override function init() {
		var c = new NoiseChannel();
		haxe.Timer.delay(c.stop, 1000);
		var c = hxd.Res.music_loop.play(true);
		c.onEnd = function() trace("LOOP");
	}

	override function update(dt:Float) {
		time += dt/60;
		if( time > 1 ) {
			time--;
			hxd.Res.sound_fx.play();
			engine.backgroundColor = 0xFFFF0000;
		} else
			engine.backgroundColor = 0;
	}

	static function main() {
		hxd.Res.initEmbed({compressSounds:true});
		if( hxd.res.Sound.startWorker() )
			return;
		new Sound();
	}

}
