package hxd.snd.effect;

#if hlopenal
private typedef AL = openal.AL;
#else
private typedef AL = hxd.snd.ALEmulator;
#end

class Pitch extends hxd.snd.Effect {
	
	public var value : Float;

	public function new( value = 1.0 ) {
		super();
		this.value =  value;
	}

	override function apply(s : Driver.Source) {
		AL.sourcef(s.inst, AL.PITCH, value);
	}

	override function unapply(s : Driver.Source) {
		AL.sourcef(s.inst, AL.PITCH,  1.);
	}

}