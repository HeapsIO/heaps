package h3d.shader.pbr;

class Slides extends ScreenShader {
	static var SRC = {
		@param var albedo : Sampler2D;
		@param var normal : Sampler2D;
		@param var pbr : Sampler2D;
		function fragment() {
			var uv = input.uv;
			var x = input.position.x;
			var normDepth = normal.get(uv);
			var normal = normDepth.xyz;
			var depth = normDepth.w;
			if( x < -0.5 ) {
				output.color = albedo.get(uv);
			} else if( x < 0 )
				output.color = packNormal(normal);
			else if( x < 0.5 )
				output.color = vec4( pbr.get(uv).xxx, 1. );
			else
				output.color = vec4( pbr.get(uv).yyy, 1. );
		}
	};
}
