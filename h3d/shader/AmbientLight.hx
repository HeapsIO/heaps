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

		function __init__() {
			lightColor = global.ambientLight;
		}

		function __init__fragment() {
			lightPixelColor = global.ambientLight;
		}

		function vertex() {
			if( !global.perPixelLighting ) pixelColor.rgb *= lightColor;
		}

		function fragment() {
			if( global.perPixelLighting ) pixelColor.rgb *= lightPixelColor;
		}

	}

}