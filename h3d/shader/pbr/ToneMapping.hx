package h3d.shader.pbr;


class ToneMapping extends ScreenShader {

	static var SRC = {

		@param var hdrTexture : Sampler2D;
		@param var exposure : Float;

		function fragment() {
			var color = hdrTexture.get(calculatedUV);

			// reinhard tonemapping
			color.rgb *= exp(exposure);
			color.rgb = color.rgb / (color.rgb + vec3(1.));

			// gamma correct
			color.rgb = color.rgb.pow(vec3(1 / 2.2));

			pixelColor = color;
		}
	}


}