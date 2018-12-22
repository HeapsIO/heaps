package h3d.shader;

/** Channel reading method for SDF. **/
@:enum abstract SDFChannel(Int) from Int to Int {
	/** Use red channel of a texture to determine distance. **/
	var Red = 0;
	/** Use green channel of a texture to determine distance. **/
	var Green = 1;
	/** Use blue channel of a texture to determine distance. **/
	var Blue = 2;
	/** Use alpha channel of a texture to determine distance. **/
	var Alpha = 3;
	/** Use RGB channels of a texture to determine distance. See here for details: https://github.com/Chlumsky/msdfgen **/
	var MultiChannel = 4;
}

class SignedDistanceField extends hxsl.Shader {

	static var SRC = {
		
		@:import h3d.shader.Base2d;

		// Output color of the shader. Due to how HXSL works, it's not possible to retreive object tinting.
		@param var color : Vec4;

		// Mode of operation - single-channel or multi-channel.
		@const var channel : Int = 0;
		@param var buffer : Float = 0.5;
		@param var gamma : Float = 0.04166666666666666666666666666667; // 1/24

		function median(r : Float, g : Float, b : Float) : Float {
			return max(min(r, g), min(max(r, g), b));
		}

		function fragment() {
			var textureSample : Vec4 = textureColor;
			var distance : Float;

			if (channel == 4) {
				distance = median(textureSample.r, textureSample.g, textureSample.b);
			} else {
				distance = if (channel == 0) textureSample.r;
					else if (channel == 1) textureSample.g;
					else if (channel == 2) textureSample.b;
					else textureSample.a;
			}
			output.color = vec4(color.rgb, color.a * smoothstep(buffer - gamma, buffer + gamma, distance));
		}
	}

}