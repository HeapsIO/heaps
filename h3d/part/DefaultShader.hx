package h3d.part;

class DefaultShader extends h3d.Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
			delta : Float2,
			light : Float,
		};
		var tuv : Float2;
		var tlight : Float;
		function vertex( mproj : M44 ) {
			var tpos = pos.xyzw * mproj;
			tpos.xy += delta;
			out = tpos;
			tuv = uv;
			tlight = light;
		}
		function fragment( tex : Texture ) {
			var c = tex.get(tuv, nearest);
			c.rgb *= tlight;
			out = c;
		}
	};
}
