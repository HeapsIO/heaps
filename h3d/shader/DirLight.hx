package h3d.shader;

class DirLight extends hxsl.Shader {

	static var SRC = {
		@param var color : Vec3;
		@param var direction : Vec3;

		var lightColor : Vec3;
		var lightPixelColor : Vec3;
		var transformedNormal : Vec3;

		function vertex() {
			lightColor.rgb += color * transformedNormal.dot(direction).max(0.);
		}

		function fragment() {
			lightPixelColor.rgb += color * transformedNormal.dot(direction).max(0.);
		}

	}

	public function new() {
		super();
		color.set(1, 1, 1);
	}

}