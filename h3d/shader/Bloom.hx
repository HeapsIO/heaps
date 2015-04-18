package h3d.shader;

class Bloom extends ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param var power : Float;
		@param var amount : Float;

		function fragment() {
			var c = texture.get(input.uv);
			var lum = c.rgb.dot(vec3(0.2126, 0.7152, 0.0722));
			output.color = vec4(c.rgb * lum.pow(power) * amount * c.a, c.a);
		}
	}

}