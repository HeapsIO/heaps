package hxd.snd.webaudio;

#if (js && !useal)
import js.html.audio.BiquadFilterType;
import js.html.audio.AudioContext;
import js.html.audio.BiquadFilterNode;
import hxd.snd.effect.LowPass;
import hxd.snd.Driver.EffectDriver;
import hxd.snd.webaudio.AudioTypes;

class LowPassDriver extends EffectDriver<LowPass> {

	var pool : Array<BiquadFilterNode>;

	public function new() {
		pool = [];
		super();
	}

	function get( ctx : AudioContext ) {
		if ( pool.length != 0 ) {
			return pool.pop();
		}
		var node = ctx.createBiquadFilter();
		node.type = BiquadFilterType.LOWPASS;
		return node;
	}

	override public function bind(e:LowPass, source: SourceHandle) : Void {
		source.lowPass = get(source.driver.ctx);
		source.updateDestination();
		apply(e, source);
	}

	override function apply(e : LowPass, source : SourceHandle) : Void {
		var min = 40;
		var max = source.driver.ctx.sampleRate / 2;
		var octaves = js.lib.Math.log(max / min) / js.lib.Math.LN2;
		source.lowPass.frequency.value = max * Math.pow(2, octaves * (e.gainHF - 1));
	}

	override function unbind(e : LowPass, source : SourceHandle) : Void {
		pool.push(source.lowPass);
		source.lowPass.disconnect();
		source.lowPass = null;
		if ( source.driver != null )
			source.updateDestination();
	}
}
#end