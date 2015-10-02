package h3d.shader;

class DirLight extends hxsl.Shader {

	static var SRC = {
		@param var color : Vec3;
		@param var direction : Vec3;
		@const var enableSpecular : Bool;
		@global var camera : {
			var position : Vec3;
		};

		var lightColor : Vec3;
		var lightPixelColor : Vec3;
		var transformedNormal : Vec3;
		var transformedPosition : Vec3;
		var specPower : Float;
		var specColor : Vec3;

		function calcLighting() : Vec3 {
			var diff = transformedNormal.dot(-direction).max(0.);
			if( !enableSpecular )
				return color * diff;
			var r = reflect(direction, transformedNormal).normalize();
			var specValue = r.dot((camera.position - transformedPosition).normalize()).max(0.);
			return color * (diff + specColor * pow(specValue, specPower));
		}

		function vertex() {
			lightColor.rgb += calcLighting();
		}

		function fragment() {
			lightPixelColor.rgb += calcLighting();
		}

	}

	public function new() {
		super();
		color.set(1, 1, 1);
	}

}