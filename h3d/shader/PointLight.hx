package h3d.shader;

class PointLight extends hxsl.Shader {

	static var SRC = {

		@const var enableSpecular : Bool;
		@param var color : Vec3;
		@param var params : Vec3; // [constant, linear, quadratic]
		@param var lightPosition : Vec3;
		@global var camera : {
			var position : Vec3;
		};

		/**
			Don't use model normal to calculate light amount
		**/
		@const var isAmbient : Bool;

		var lightColor : Vec3;
		var lightPixelColor : Vec3;
		var transformedPosition : Vec3;
		var pixelTransformedPosition : Vec3;
		var transformedNormal : Vec3;
		var specPower : Float;
		var specColor : Vec3;


		function calcLighting( position : Vec3 ) : Vec3 {
			var dvec = lightPosition - position;
			var dist2 = dvec.dot(dvec);
			var dist = dist2.sqrt();
			var diff : Float =  isAmbient ? 1. : transformedNormal.dot(dvec).max(0.);
			var factor = 1 / vec3(dist, dist2, dist * dist2).dot(params);
			if( !enableSpecular )
				return color * diff * factor;
			var r = reflect(-dvec.normalize(), transformedNormal).normalize();
			var specValue = r.dot((camera.position - position).normalize()).max(0.);
			return color * (diff * factor + specColor * pow(specValue, specPower));
		}

		function vertex() {
			lightColor.rgb += calcLighting(transformedPosition);
		}

		function fragment() {
			lightPixelColor.rgb += calcLighting(pixelTransformedPosition);
		}

	};

	public function new() {
		super();
		color.set(1, 1, 1);
		params.set(0, 0, 1);
	}

}