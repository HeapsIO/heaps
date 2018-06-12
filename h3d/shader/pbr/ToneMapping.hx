package h3d.shader.pbr;


class ToneMapping extends ScreenShader {

	static var SRC = {

		@param var hdrTexture : Sampler2D;
		@param var exposureExp : Float;
		@const var isSRBG : Bool;

		function fragment() {
			var color = hdrTexture.get(calculatedUV);

			// reinhard tonemapping
			color.rgb *= exposureExp;
			color.rgb = color.rgb / (color.rgb + vec3(1.));

			// gamma correct
			if( !isSRBG ) color.rgb = color.rgb.sqrt();

			pixelColor = color;
		}
	}

	public var exposure(default,set) : Float;

	public function new() {
		super();
		exposure = 0;
	}

	function set_exposure(v) {
		exposureExp = Math.exp(v);
		return exposure = v;
	}


}