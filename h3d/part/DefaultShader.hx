package h3d.part;

class DefaultShader extends h3d.Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
			delta : Float2,
		};
		var tuv : Float2;
		function vertex( mproj : M44 ) {
			var tpos = pos.xyzw * mproj;
			tpos.xy += delta;
			out = tpos;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv,nearest);
		}
	};
}
