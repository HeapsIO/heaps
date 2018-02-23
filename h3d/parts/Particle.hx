package h3d.parts;

class Particle implements Data.Randomized {

	var parts : Particles;
	public var x : Float;
	public var y : Float;
	public var z : Float;
	var w : Float; // used for sorting

	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;
	public var alpha(get, set) : Float;

	public var frame : Int;

	public var size : Float;
	public var ratio : Float;
	public var rotation : Float;

	public var prev : Particle;
	public var next : Particle;

	// --- Particle emitter ---
	public var time : Float;
	public var lifeTimeFactor : Float;

	public var dx : Float;
	public var dy : Float;
	public var dz : Float;

	public var fx : Float;
	public var fy : Float;
	public var fz : Float;

	public var randIndex = 0;
	public var randValues : Array<Float>;
	// -------------------------

	public function new() {
		r = 1;
		g = 1;
		b = 1;
		a = 1;
		frame = 0;
	}

	inline function get_alpha() return a;
	inline function set_alpha(v) return a = v;

	public function setColor( color : Int, alpha = 1. ) {
		a = alpha;
		r = ((color >> 16) & 0xFF) / 255.;
		g = ((color >> 8) & 0xFF) / 255.;
		b = (color & 0xFF) / 255.;
	}

	public function remove() {
		if( parts != null ) {
			@:privateAccess parts.kill(this);
			parts = null;
		}
	}

	public inline function eval( v : Data.Value, time : Float ) {
		return Data.State.eval(v, time, this, this);
	}

	public function rand() : Float {
		if( randValues == null ) randValues = [];
		if( randValues.length <= randIndex ) randValues.push(Math.random());
		return randValues[randIndex++];
	}

}