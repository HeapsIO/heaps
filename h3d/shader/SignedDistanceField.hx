package h3d.shader;

class SignedDistanceField extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.Base2d;

		// Mode of operation - single-channel or multi-channel.
		// 0123 = RGBA, evertyhing else is MSDF.
		@const var channel : Int = 0;
		/**
			Use automatic edge smoothing based on derivatives.
		**/
		@const var autoSmoothing : Bool = false;
		/**
			Variable used to determine the edge of the field. ( default : 0.5 ) 
			Can be used to provide cheaper Outline for Text compared to Filter usage.
		**/
		@param var alphaCutoff : Float = 0.5;
		/**
			Determines smoothing of the edge. Lower value is sharper.
		**/
		@param var smoothing : Float = 0.04166666666666666666666666666667; // 1/24

		function median(r : Float, g : Float, b : Float) : Float {
			return max(min(r, g), min(max(r, g), b));
		}

		function fragment() {
			var textureSample : Vec4 = textureColor;
			var distance : Float;

			distance = if (channel == 0) textureSample.r;
				else if (channel == 1) textureSample.g;
				else if (channel == 2) textureSample.b;
				else if (channel == 3) textureSample.a;
				else median(textureSample.r, textureSample.g, textureSample.b);

			var smoothVal = autoSmoothing ? abs(fwidth(distance) * 0.5) : smoothing;
			textureColor = vec4(1.0, 1.0, 1.0, smoothstep(alphaCutoff - smoothVal, alphaCutoff + smoothVal, distance));
		}
	}

}