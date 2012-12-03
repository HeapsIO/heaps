package h3d.mat;

private class Shader extends h3d.Shader {
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( mpos : Matrix, mproj : Matrix ) {
			out = pos.xyzw * mpos * mproj;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv.xy);
		}
	}
}

class MeshTexture extends MeshMaterial {

	static var SHADER = new Shader();
	
	public var texture : Texture;
	
	public function new(texture) {
		super(SHADER);
		this.texture = texture;
	}
	
	public override function setMatrixes( mpos, mproj ) {
		var s = SHADER;
		s.mpos = mpos;
		s.mproj = mproj;
		s.tex = texture;
	}
	
}