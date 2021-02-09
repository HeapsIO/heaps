package h3d.shader;

class Outline2D extends ScreenShader {
	static var SRC = {
		@param var texture : Sampler2D;
		@param var size : Vec2;
		@param @const var samples : Int;
		@param var color : Vec4;
		@param @const var multiplyAlpha : Int;
		function fragment() {
			var ownColor : Vec4 = texture.get(input.uv);
			var maxAlpha = 0.;
			var curColor : Vec4;
			var displaced : Vec2;
			var angle = 0.;
			var doublePi = 6.28318530717958647692528;
			var step = doublePi / samples;
			@unroll for (i in 0...samples) {
				angle += step;
				displaced.x = input.uv.x + size.x * cos(angle);
				displaced.y = input.uv.y + size.y * sin(angle);
				curColor = texture.get(displaced);
				maxAlpha = max(maxAlpha, curColor.a);
			}
			var resultAlpha = max(maxAlpha, ownColor.a);
			var resultColor = ownColor.rgb + color.rgb * (1. - ownColor.a);
			var out = resultColor * max(float(multiplyAlpha), resultAlpha);
			output.color = vec4(out, resultAlpha * mix(color.a, 1, ownColor.a));
		}
	};
}
