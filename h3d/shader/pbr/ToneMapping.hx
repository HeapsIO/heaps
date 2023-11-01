package h3d.shader.pbr;


class ToneMapping extends ScreenShader {

	static var SRC = {

		@param var hdrTexture : Sampler2D;
		@param var exposureExp : Float;
		@const var isSRBG : Bool;
		@const var mode : Int;
		@param var invGamma : Float;
		@param var a : Float;
		@param var b : Float;
		@param var c : Float;
		@param var d : Float;
		@param var e : Float;

		var hdrColor : Vec4;

		function __init__fragment() {
			hdrColor = hdrTexture.get(calculatedUV);
		}

		function fragment() {
			var color = hdrColor;
			color.rgb *= exposureExp;
			switch( mode ) {
			case 0:
				// linear
				color.rgb = color.rgb.saturate();
			case 1:
				// reinhard
				color.rgb = color.rgb / (color.rgb + vec3(1.));
			case 2:
				// filmic
				color.rgb = saturate((color.rgb*(a*color.rgb+b))/(color.rgb*(c*color.rgb+d)+e));
			}
			// gamma correct
			if( !isSRBG )
				color.rgb = pow(color.rgb, vec3(invGamma));
			pixelColor = color;
		}
	}

	public var exposure(default,set) : Float;
	public var gamma(default,set) : Float;

	public function new() {
		super();
		exposure = 0;
		gamma = 2.0;
		a = 2.51;
		b = 0.03;
		c = 2.43;
		d = 0.59;
		e = 0.14;
	}

	function set_exposure(v) {
		exposureExp = Math.exp(v);
		return exposure = v;
	}

	function set_gamma(v:Float) {
		invGamma = 1.0/v;
		return gamma = v;
	}
}
