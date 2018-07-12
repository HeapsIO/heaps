package h3d.shader.pbr;

class Bloom extends ScreenShader {

	static var SRC = {

		var albedo : Vec3;
		var emissive : Float;

		@param var hdr : Sampler2D;
		@param var threshold : Float;
		@param var intensity : Float;

		function fragment() {
			pixelColor = hdr.get(calculatedUV);
			var lum = pixelColor.rgb.dot(vec3(0.2126, 0.7152, 0.0722));
			if( lum < threshold ) pixelColor.rgb = vec3(0.) else pixelColor.rgb *= (lum - threshold) / lum;
			pixelColor.rgb += albedo * emissive;
			pixelColor.rgb *= intensity;
		}

	};

}