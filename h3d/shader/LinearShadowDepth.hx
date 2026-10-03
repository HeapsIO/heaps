package h3d.shader;

class LinearShadowDepth extends hxsl.Shader {

	static var SRC = {
		@global var camera : {
			var position : Vec3;
			var zFar : Float;
		};
		var transformedPosition : Vec3;
		var depth : Float;

		function fragment() {
			depth = length(transformedPosition - camera.position) / camera.zFar;
		}
	}
}
