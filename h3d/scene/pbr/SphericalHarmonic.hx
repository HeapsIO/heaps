package h3d.scene.pbr;

class SphericalHarmonic {

	public var coefR : Array<Float> = [];
	public var coefG : Array<Float> = [];
	public var coefB : Array<Float> = [];

	public function new(order:Int) {
		var coefCount = order * order;
		coefR = [for (value in 0...coefCount) 0];
		coefG = [for (value in 0...coefCount) 0];
		coefB = [for (value in 0...coefCount) 0];
	}
}
