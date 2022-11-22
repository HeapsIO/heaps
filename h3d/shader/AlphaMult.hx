package h3d.shader;

class AlphaMult extends hxsl.Shader {
	static var SRC = {
		@perInstance @range(0, 1) @param var alpha : Float;
		var pixelColor : Vec4;

		function fragment() {
			pixelColor.a *= alpha;
		}
	}
}