package h3d.shader.pbr;

class AlphaMultiply extends hxsl.Shader {
	static var SRC = {
		var pixelColor : Vec4;
		function fragment() {
			pixelColor.rgb *= pixelColor.a;
		}
	}
}