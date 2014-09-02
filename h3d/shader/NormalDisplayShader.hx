package h3d.shader;

class NormalDisplayShader extends hxsl.Shader {

	static var SRC = {

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var uv : Vec2;
		}

		var transformedNormal : Vec3;
		var transformedPosition : Vec3;

		@param var normalLength : Float;

		function vertex() {
			transformedPosition += (transformedNormal * input.uv.x + transformedNormal.zyx * input.uv.y * 0.03) * normalLength;
		}

	};

	public function new( length = 0.2 ) {
		super();
		normalLength = length;
	}

}