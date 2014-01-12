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

	public var fx : Float;
	public var fy : Float;
	public var fz : Float;

	public var cr : Float;
	public var cg : Float;
	public var cb : Float;
	public var ca : Float;
	
	public var frame : Int;
	
	public var size : Float;
	public var ratio : Float;
	public var rotation : Float;
	
	public var prev : Particle;
	public var next : Particle;
	
	public var randIndex = 0;
	public var randValues : Array<Float>;

	public function new() {
		cr = 1;
		cg = 1;
		cb = 1;
		ca = 1;
		frame = 0;
	}
	
	public function getRand() {
		if( randValues == null ) randValues = [];
		if( randValues.length <= randIndex ) randValues.push(Math.random());
		return randValues[randIndex++];
	}
	
}