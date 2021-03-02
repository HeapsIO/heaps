package h3d.shader;

class UVTransform extends hxsl.Shader {

	static var SRC = {
		@global var global : {
			var time : Float;
		};
		@input var input : {
			var uv : Vec2;
		};

		@param var shift : Vec2;
		@param var speed : Vec2;
		@param var scale : Vec2;

		var calculatedUV : Vec2;

		function vertex() {
			var uv = input.uv;
			calculatedUV = (uv + speed * global.time + shift) * scale;
		}
	};
}