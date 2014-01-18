package h3d.mat;

class MeshMaterial extends Material {

	var mshader : h3d.shader.BaseMesh;
	var textureShader : h3d.shader.Texture;
	public var texture(get,set) : h3d.mat.Texture;
	
	public var color(get, set) : Vector;
	public var blendMode(default, set) : BlendMode;

	public function new(?texture) {
		mshader = new h3d.shader.BaseMesh();
		blendMode = Normal;
		super(new h3d.pass.Pass("default",[mshader]));
		this.texture = texture;
	}
	
	inline function get_color() {
		return mshader.color;
	}

	inline function set_color(v) {
		return mshader.color = v;
	}
	
	function set_blendMode(v:BlendMode) {
		if( mainPass != null ) {
			switch( v ) {
			case Normal:
				mainPass.blend(One, Zero);
				mainPass.setPassName("default");
			case Alpha:
				mainPass.blend(SrcAlpha, OneMinusSrcAlpha);
				mainPass.setPassName("alpha");
			case Add:
				mainPass.blend(SrcAlpha, One);
				mainPass.setPassName("additive");
			case SoftAdd:
				mainPass.blend(OneMinusDstColor, One);
				mainPass.setPassName("additive");
			}
		}
		return blendMode = v;
	}

	function get_texture() {
		return textureShader == null ? null : textureShader.texture;
	}
	
	function set_texture(t) {
		if( t == null ) {
			if( textureShader != null ) {
				mainPass.shaders.remove(textureShader);
				textureShader = null;
			}
		} else {
			if( textureShader == null ) {
				textureShader = new h3d.shader.Texture();
				mainPass.shaders.push(textureShader);
			}
			textureShader.texture = t;
		}
		return t;
	}

}
