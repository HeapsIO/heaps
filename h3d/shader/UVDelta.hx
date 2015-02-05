package h3d.shader;

class UVDelta extends hxsl.Shader {

	static var SRC = {
		@param var uvDelta : Vec2;
		var calculatedUV : Vec2;
		function vertex() {
			calculatedUV += uvDelta;
		}
	};

	public function new( dx = 0., dy = 0. ) {
		super();
		uvDelta.set(dx, dy);
	}

}