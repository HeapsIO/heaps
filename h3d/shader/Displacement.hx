package h3d.shader;

class Displacement extends ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param var normalMap : Sampler2D;
		@param var normalScale : Vec2;
		@param var normalPos : Vec2;
		@param var displacement : Vec2;

		function fragment() {
			var n = unpackNormal(normalMap.get(input.uv * normalScale + normalPos));
			output.color = texture.get(input.uv + n.xy * displacement);
		}

	}


}