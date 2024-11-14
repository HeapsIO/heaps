package h3d.shader;

class DisplacementDisplay extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;

		@param var tex : Sampler2D;

		var calculatedUV : Vec2;

		function fragment() {
			pixelColor.rgb = tex.get(calculatedUV).aaa;
		}

	};
}