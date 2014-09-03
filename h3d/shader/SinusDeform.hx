package h3d.shader;

class SinusDeform extends hxsl.Shader {

	static var SRC = {

		@param var time : Float;
		@param var frequency : Float;
		@param var amplitude : Float;

		var calculatedUV : Vec2;

		function fragment() {
			calculatedUV.x += sin(calculatedUV.y * frequency + time) * amplitude;
		}

	};

}