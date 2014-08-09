package h3d.shader;

class VertexColorAlpha extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			var color : Vec4;
		};

		var pixelColor : Vec4;
		@const var additive : Bool;

		function fragment() {
			if( additive )
				pixelColor += input.color;
			else
				pixelColor *= input.color;
		}

	};

}