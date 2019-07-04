package h3d.shader;

class ColorMult extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;

		@param var color : Vec4;

		function fragment() {
			pixelColor *= color;
		}

	};

}