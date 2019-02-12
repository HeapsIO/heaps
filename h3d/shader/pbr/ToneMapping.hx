package h3d.shader.pbr;


class ToneMapping extends ScreenShader {

	static var SRC = {

		@param var hdrTexture : Sampler2D;
		@param var exposureExp : Float;
		@const var isSRBG : Bool;
		@const var mode : Int;

		@const var hasBloom : Bool;
		@param var bloom : Sampler2D;

		@const var hasDistortion : Bool;
		@param var distortion : Sampler2D;

		@const var hasColorGrading : Bool;
		@param var colorGradingLUT : Sampler2D;
		@param var lutSize : Float;

		@param var pixelSize : Vec2;

		function fragment() {

			if( hasDistortion)  {
				var baseUV = calculatedUV;
				var distortionVal = distortion.get(baseUV).rg;
				calculatedUV = baseUV + distortionVal ;
			}

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

			if( hasColorGrading ) {
				var uv = min(color.rgb, vec3(1,1,1));
				var sliceSize = 1.0 / lutSize;
				var slicePixelSize = sliceSize / lutSize;
				var sliceInnerSize = slicePixelSize * (lutSize - 1.0);
				var blueSlice0 = min(floor(uv.b * lutSize), lutSize - 1.0);
				var blueSlice1 = min(blueSlice0 + 1.0, lutSize - 1.0);
				var xOffset = slicePixelSize * 0.5 + uv.r * sliceInnerSize;
				var s0 = xOffset + (blueSlice0 * sliceSize);
				var s1 = xOffset + (blueSlice1 * sliceSize);
				var slice0Color = texture(colorGradingLUT, vec2(s0, uv.y)).rgb;
				var slice1Color = texture(colorGradingLUT, vec2(s1, uv.y)).rgb;
				var bOffset = mod(uv.b * lutSize, 1.0);
				var result = mix(slice0Color, slice1Color, bOffset);
				color.rgb = result;
			}

			pixelColor = color;
		}
	}

	public var exposure(default,set) : Float;

	public function new() {
		super();
		exposure = 0;
		hasDistortion = false;
		hasBloom = false;
	}

	function set_exposure(v) {
		exposureExp = Math.exp(v);
		return exposure = v;
	}


}