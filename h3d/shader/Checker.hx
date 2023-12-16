package h3d.shader;

class Checker extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;

		@param var width : Float;
		@param var height : Float;

		var calculatedUV : Vec2;

		@input var input : { var uv : Vec2; }
		function vertex() {
			calculatedUV = input.uv;
		}

		function fragment() {
			if ( ((calculatedUV.fract().x - 0.5) * (calculatedUV.fract().y - 0.5)) > 0.0 ) {
				pixelColor.rgb = vec3(1.0);
			} else {
				pixelColor.rgb = vec3(0.0);
			}
		}

	};
}