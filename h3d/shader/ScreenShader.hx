package h3d.shader;

class ScreenShader extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			position : Vec2,
			uv : Vec2,
		};

		var output : {
			position : Vec4,
			color : Vec4,
		};

		var calculatedUV : Vec2;

		function vertex() {
			calculatedUV = input.uv;
			output.position = vec4(input.position, 0, 1);
		}
	};

}