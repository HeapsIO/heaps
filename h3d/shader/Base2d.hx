package h3d.shader;

class Base2d extends hxsl.Shader {

	static var SRC = {
		
		@input var input : {
			var position : Vec2;
			var uv : Vec2;
			var color : Vec4;
		};
		
		var output : {
			var position : Vec4;
			var color : Vec4;
		};

		@param var zValue : Float;
		@param var texture : Sampler2D;
		
		var spritePosition : Vec4;
		var pixelColor : Vec4;
		var calculateUV : Vec2;

		function __init__() {
			spritePosition = vec4(input.position, zValue, 1);
			calculateUV = input.uv;
			pixelColor = input.color;
			pixelColor *= texture.get(calculateUV);
		}
		
		function vertex() {
			output.position = spritePosition;
		}
		
		function fragment() {
			output.color = vec4(1,1,1,1);
		}
		
	};

	
}