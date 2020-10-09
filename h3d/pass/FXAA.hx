package h3d.pass;

private class FXAAShader extends h3d.shader.ScreenShader {

	static var SRC = {

		@param var delta : Vec2;
		@param var texture : Sampler2D;

		function fragment() {

			var tuv = input.uv;

			var nw = texture.get(tuv + vec2(-1, -1) * delta).rgb;
			var ne = texture.get(tuv + vec2(1, -1) * delta).rgb;
			var sw = texture.get(tuv + vec2(-1, 1) * delta).rgb;
			var se = texture.get(tuv + vec2(1, 1) * delta).rgb;
			var origin = texture.get(tuv);
			var mid = origin.rgb;
			var lumA = vec3(0.299, 0.587, 0.114);
			var lumNW = nw.dot(lumA);
			var lumNE = ne.dot(lumA);
			var lumSW = sw.dot(lumA);
			var lumSE = se.dot(lumA);
			var lumMid = mid.dot(lumA);
			var lumMin = min(lumMid, min(min(lumNW, lumNE), min(lumSW, lumSE)));
			var lumMax = max(lumMid, max(max(lumNW, lumNE), max(lumSW, lumSE)));
			var dir : Vec2;
			dir.x = -((lumNW + lumNE) - (lumSW + lumSE));
			dir.y = ((lumNW + lumSW) - (lumNE + lumSE));
			var dirReduce = max((lumNW + lumNE + lumSW + lumSE) * (0.25 / 128), 1. / 8);
			var rcpDirMin = 1 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
			dir = min(vec2(8, 8), max(vec2(-8, -8), dir * rcpDirMin)) * delta;

			var rgbA = 0.5 * (texture.get(tuv + dir * (1.0 / 3.0 - 0.5)).xyz + texture.get(tuv + dir * (2.0 / 3.0 - 0.5)).xyz);
			var rgbB = rgbA * 0.5 + 0.25 * (texture.get(tuv + dir * -0.5).xyz + texture.get(tuv + dir * 0.5).xyz);
			var lumB = dot(rgbB, lumA);
			var color : Vec4;
			var cmp = vec2(lumB, -lumB) > vec2(lumMin, -lumMax);
			color.xyz = mix(rgbA, rgbB, cmp.x * cmp.y);
			color.a = origin.a;
			output.color = color;
		}
	}
}

class FXAA extends ScreenFx<FXAAShader> {

	public function new() {
		super(new FXAAShader());
	}

	public function apply( texture : h3d.mat.Texture ) {
		shader.texture = texture;
		shader.delta.set(1 / texture.width, 1 / texture.height);
		render();
	}

}
