package h3d.shader;

class AmbientLight extends hxsl.Shader {

	static var SRC = {

		@global var global : {
			var ambientLight : Vec3;
			@const var perPixelLighting : Bool;
		};

		var pixelColor : Vec4;
		var lightPixelColor : Vec3;
		var lightColor : Vec3;

		@const var oldModel : Bool;

		function __init__() {
			lightColor = oldModel ? global.ambientLight : vec3(0.);
		}

		function __init__fragment() {
			lightPixelColor = oldModel ? global.ambientLight : vec3(0.);
		}

		function calcLight( lightColor : Vec3 ) : Vec3 {
			return oldModel ? lightColor : (global.ambientLight + (1 - global.ambientLight).max(0.) * lightColor);
		}

		function vertex() {
			if( !global.perPixelLighting ) pixelColor.rgb *= calcLight(lightColor);
		}

		function fragment() {
			if( global.perPixelLighting ) pixelColor.rgb *= calcLight(lightPixelColor);
		}

	}

}