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
	var slider : h2d.Slider;
	var music : hxd.snd.Channel;

	override function init() {
		var res = if( hxd.res.Sound.supportedFormat(Mp3) || hxd.res.Sound.supportedFormat(OggVorbis) ) hxd.Res.music_loop else null;
		if( res != null ) {
			trace("Playing "+res);
			music = res.play(true);
			//music.queueSound(...);
			music.onEnd = function() trace("LOOP");
		}

		slider = new h2d.Slider(300, 10, s2d);
		slider.x = 150;
		slider.y = 80;
		if( music == null ) slider.remove();
		slider.onChange = function() {
			music.position = slider.value * music.duration;
		};
	}

	override function update(dt:Float) {
		time += dt/60;
		if( time > 1 ) {
			time--;
			hxd.Res.sound_fx.play();
			engine.backgroundColor = 0xFFFF0000;
		} else
			engine.backgroundColor = 0;

		if( music != null ) {
			slider.value = music.position / music.duration;
		}

		if( hxd.Key.isPressed(hxd.Key.SPACE) ) {
			var c = new NoiseChannel();
			haxe.Timer.delay(c.stop, 1000);
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Sound();
	}

}
