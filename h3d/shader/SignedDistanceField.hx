package h3d.shader;

class SignedDistanceField extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.Base2d;
		/** Base2d's texture: the glyph atlas, sampled beside each pixel by `autoSmoothing`. **/
		@borrow(h3d.shader.Base2d) var texture : Sampler2D;

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

		function fieldOf(textureSample : Vec4) : Float {
			return if (channel == 0) textureSample.r;
				else if (channel == 1) textureSample.g;
				else if (channel == 2) textureSample.b;
				else if (channel == 3) textureSample.a;
				else median(textureSample.r, textureSample.g, textureSample.b);
		}

		function fragment() {
			var distance = fieldOf(textureColor);

			var smoothVal = smoothing;
			if (autoSmoothing) {
				// Half the distance the field changes over one screen pixel. fwidth(distance) alone
				// misses it on a stroke thinner than two pixels whose ridge lies between the two
				// pixels of a derivative block: the field is the same on both sides, its derivative
				// ~0, and the stroke vanishes under a hard cutoff. So also take the field's slope per
				// texel (sampled beside this one) times the texels per pixel (from the UVs, which
				// never cancel).
				var texSize = vec2(texture.size());
				var texel = vec2(1.0) / texSize;
				var slope = length(vec2(
					fieldOf(texture.get(calculatedUV + vec2(texel.x, 0.0))) - distance,
					fieldOf(texture.get(calculatedUV + vec2(0.0, texel.y))) - distance));
				var texelsPerPixel = fwidth(calculatedUV * texSize);
				smoothVal = 0.5 * max(abs(fwidth(distance)), slope * max(texelsPerPixel.x, texelsPerPixel.y));
			}
			textureColor = vec4(1.0, 1.0, 1.0, smoothstep(alphaCutoff - smoothVal, alphaCutoff + smoothVal, distance));
		}
	}

}