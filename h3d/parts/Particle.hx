package h3d.parts;

class Particle {
	
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;
	
	public var time : Float;
	public var lifeTimeFactor : Float;

	public var dx : Float;
	public var dy : Float;
	public var dz : Float;

	public var cr : Float;
	public var cg : Float;
	public var cb : Float;
	public var ca : Float;
	
	public var size : Float;
	public var rotation : Float;
	
	public var prev : Particle;
	public var next : Particle;

	public function new() {
		cr = 1;
		cg = 1;
		cb = 1;
		ca = 1;
	}
	
}