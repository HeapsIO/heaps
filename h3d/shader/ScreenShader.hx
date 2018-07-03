package h3d.shader;

class ScreenShader extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			position : Vec2,
			uv : Vec2,
		};

		@param var flipY : Float;

		var output : {
			position : Vec4,
			color : Vec4,
		};

		var pixelColor : Vec4;
		var calculatedUV : Vec2;

		function __init__() {
			output.color = pixelColor;
		}

		function vertex() {
			calculatedUV = input.uv;
			output.position = vec4(input.position.x, input.position.y * flipY, 0, 1);
		}
	};

}