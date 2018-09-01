package h3d.shader.pbr;


class ToneMapping extends ScreenShader {

	static var SRC = {

		@param var hdrTexture : Sampler2D;
		@param var exposureExp : Float;
		@const var isSRBG : Bool;
		@const var mode : Int;

		@const var hasBloom : Bool;
		@param var bloom : Sampler2D;

		function fragment() {
			var color = hdrTexture.get(calculatedUV);
			if( hasBloom )
				color += bloom.get(calculatedUV);

			color.rgb *= exposureExp;

			switch( mode ) {
			case 0:
				// linear
			case 1:
				// reinhard
				color.rgb = color.rgb / (color.rgb + vec3(1.));
			}

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