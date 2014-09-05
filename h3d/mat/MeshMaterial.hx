package h3d.mat;

class MeshMaterial extends Material {

	var mshader : h3d.shader.BaseMesh;
	var textureShader : h3d.shader.Texture;
	public var texture(get,set) : h3d.mat.Texture;

	public var color(get, set) : Vector;
	public var blendMode(default, set) : BlendMode;

	public function new(?texture) {
		mshader = new h3d.shader.BaseMesh();
		blendMode = None;
		super(mshader);
		this.texture = texture;
	}

	inline function get_color() {
		return mshader.color;
	}

	inline function set_color(v) {
		return mshader.color = v;
	}

	override function clone( ?m : Material ) : Material {
		var m = m == null ? new MeshMaterial() : cast m;
		super.clone(m);
		m.texture = texture;
		m.color = color;
		m.blendMode = blendMode;
		return m;
	}

	function set_blendMode(v:BlendMode) {
		if( mainPass != null ) {
			switch( v ) {
			case None:
				mainPass.depthWrite = true;
				mainPass.blend(One, Zero);
				mainPass.setPassName("default");
			case Alpha:
				mainPass.depthWrite = true;
				mainPass.blend(SrcAlpha, OneMinusSrcAlpha);
				mainPass.setPassName("alpha");
			case Add:
				mainPass.depthWrite = false;
				mainPass.blend(SrcAlpha, One);
				mainPass.setPassName("additive");
			case SoftAdd:
				mainPass.depthWrite = false;
				mainPass.blend(OneMinusDstColor, One);
				mainPass.setPassName("additive");
			case Multiply:
				mainPass.depthWrite = false;
				mainPass.blend(DstColor, OneMinusSrcAlpha);
				mainPass.setPassName("additive");
			case Erase:
				mainPass.depthWrite = false;
				mainPass.blend(Zero, OneMinusSrcAlpha);
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
				mainPass.removeShader(textureShader);
				textureShader = null;
			}
		} else {
			if( textureShader == null ) {
				textureShader = new h3d.shader.Texture();
				mainPass.addShader(textureShader);
			}
			textureShader.texture = t;
		}
		return t;
	}

}
