package hxd.snd.webaudio;

#if (js && !useal)
import js.html.audio.PannerNode;
import js.html.audio.AudioContext;
import hxd.snd.effect.Spatialization;
import hxd.snd.Driver.EffectDriver;
import hxd.snd.webaudio.AudioTypes;

class SpatializationDriver extends EffectDriver<Spatialization> {

	var pool : Array<PannerNode>;

	public function new() {
		pool = [];
		super();
	}

	function get( ctx : AudioContext ) {
		if ( pool.length != 0 ) {
			return pool.pop();
		}
		var node = ctx.createPanner();
		return node;
	}

	override public function bind(e : Spatialization, source: SourceHandle) : Void {
		source.panner = get(source.driver.ctx);
		source.updateDestination();
		apply(e, source);
	}

	override function apply(e : Spatialization, source : SourceHandle) : Void {
		source.panner.setPosition(-e.position.x, e.position.y, e.position.z);
		source.panner.setOrientation(-e.direction.x, e.direction.y, e.direction.z);
		// TODO: Velocity
		source.panner.rolloffFactor = e.rollOffFactor;
		source.panner.refDistance = e.referenceDistance;
		var maxDist : Float = e.maxDistance == null ? 3.40282347e38 : e.maxDistance;
		source.panner.maxDistance = maxDist;
	}

	override function unbind(e : Spatialization, source : SourceHandle) : Void {
		pool.push(source.panner);
		source.panner.disconnect();
		source.panner = null;
		if ( source.driver != null )
			source.updateDestination();
	}
}
#end