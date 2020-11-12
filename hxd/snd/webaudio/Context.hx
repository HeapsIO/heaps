package hxd.snd.webaudio;

#if js
import js.html.audio.AudioBuffer;
import js.html.audio.GainNode;
import js.html.audio.AudioNode;
import js.html.audio.AudioContext;

/**
	Common part between webaudio and OpenAL emulator - AudioContext and masterGain.
**/
class Context {

	static var ctx : AudioContext;
	static var suspended : Bool;
	static var bufferPool : Array<BufferPool>;
	static var gainPool : Array<GainNode>;
	public static var destination : AudioNode;
	public static var masterGain : GainNode;

	public static function get() : AudioContext {
		if ( ctx == null ) {
			try {
				ctx = new js.html.audio.AudioContext();
			} catch( e : Dynamic ) try {
				// Fallback to Chrome webkit prefix.
				#if (haxe_ver >= 4)
				ctx = js.Syntax.code('new window.webkitAudioContext()');
				#else
				ctx = untyped __js__('new window.webkitAudioContext()');
				#end
			} catch( e : Dynamic ) {
				ctx = null;
			}
			if ( ctx == null ) {
				throw "WebAudio API not available in this browser!";
			}

			// AudioContext starts in suspended mode until user input - add hooks to resume it.
			// see https://developers.google.com/web/updates/2017/09/autoplay-policy-changes#webaudio
			if ( ctx.state == SUSPENDED ) waitForPageInput();
			ctx.addEventListener("statechange", function(_) if ( ctx.state == SUSPENDED ) waitForPageInput() );

			bufferPool = [];
			gainPool = [];

			masterGain = ctx.createGain();
			masterGain.connect(ctx.destination);
			destination = masterGain;
		}
		return ctx;
	}

	public static inline function getGain():GainNode
	{
		return gainPool.length != 0 ? gainPool.pop() : ctx.createGain();
	}

	public static inline function putGain(gain:GainNode) {
		gainPool.push(gain);
		gain.gain.value = 1;
	}

	static function waitForPageInput() {
		if ( !suspended ) {

			js.Browser.document.addEventListener("click", resumeContext);
			js.Browser.document.addEventListener("keydown", resumeContext);
			js.Browser.document.body.addEventListener("keydown", resumeContext);
			js.Browser.document.body.addEventListener("touchend", resumeContext);

			suspended = true;
		}
	}

	static function resumeContext(_) {
		if ( suspended ) {
			if ( ctx != null ) ctx.resume();

			js.Browser.document.removeEventListener("click", resumeContext);
			js.Browser.document.removeEventListener("keydown", resumeContext);
			js.Browser.document.body.removeEventListener("keydown", resumeContext);
			js.Browser.document.body.removeEventListener("touchend", resumeContext);

			suspended = false;
		}
	}

	/**
		Returns free AudioBuffer instance corresponding to sample count, amount of channels and sample-rate.
	**/
	public static function getBuffer( channels : Int, sampleCount : Int, rate : Int ) : AudioBuffer
	{
		for ( pool in bufferPool ) {
			if ( pool.channels == channels && pool.samples == sampleCount && pool.rate == rate ) {
				if ( pool.pool.length != 0 ) return pool.pool.pop();
				else return ctx.createBuffer(channels, sampleCount, rate);
			}
		}
		var pool = new BufferPool(channels, sampleCount, rate);
		bufferPool.push(pool);
		return ctx.createBuffer(channels, sampleCount, rate);
	}

	/**
		Puts AudioBuufer back to it's pool.
	**/
	public static function putBuffer( buf : AudioBuffer ) {
		var rate = Std.int(buf.sampleRate);
		for (pool in bufferPool) {
			if (pool.channels == buf.numberOfChannels && pool.samples == buf.length && pool.rate == rate) {
				pool.pool.push(buf);
				break;
			}
		}
	}


}

// AudioBuffer pool to minimize allocation count.
private class BufferPool {

	public var pool : Array<AudioBuffer>;
	public var channels : Int;
	public var samples : Int;
	public var rate : Int;

	public function new( channels : Int, samples : Int, rate : Int ) {
		this.pool = [];
		this.channels = channels;
		this.samples = samples;
		this.rate = rate;
	}

}

#end