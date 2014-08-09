package h3d.shader;

class UVScroll extends hxsl.Shader {

	static var SRC = {
		@param var uvDelta : Vec2;
		var calculatedUV : Vec2;
		function vertex() {
			calculatedUV += uvDelta;
		}
	};

}