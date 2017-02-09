package h3d.shader;

class UVDelta extends hxsl.Shader {

	static var SRC = {
		@param var uvDelta : Vec2;
		@param var uvScale : Vec2;
		var calculatedUV : Vec2;
		function vertex() {
			calculatedUV = calculatedUV * uvScale + uvDelta;
		}
	};

	public function new( dx = 0., dy = 0., sx = 1., sy = 1. ) {
		super();
		uvDelta.set(dx, dy);
		uvScale.set(sx, sy);
	}

}