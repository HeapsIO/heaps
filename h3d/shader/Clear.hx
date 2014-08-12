package h3d.shader;

class Clear extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			position : Vec2,
		};
		var output : {
			position : Vec4,
			color : Vec4,
		};

		@param var depth : Float;
		@param var color : Vec4;

		function vertex() {
			output.position = vec4(input.position, depth, 1);
		}
		function fragment() {
			output.color = color;
		}
	}

}