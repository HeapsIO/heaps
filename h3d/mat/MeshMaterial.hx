package h3d.mat;

class MeshMaterial extends Material {

	var mshader : h3d.shader.BaseMesh;
	public var textureShader(default, null) : h3d.shader.Texture;
	public var specularShader(default, null) : h3d.shader.SpecularTexture;
	public var texture(get, set) : h3d.mat.Texture;
	public var specularTexture(get,set) : h3d.mat.Texture;

	public var color(get, set) : Vector;
	public var specularAmount(get, set) : Float;
	public var specularPower(get, set) : Float;
	public var blendMode(default, set) : BlendMode;

	public function new(?texture) {
		mshader = new h3d.shader.BaseMesh();
		blendMode = None;
		super(mshader);
		this.texture = texture;
	}

	inline function get_specularPower() {
		return mshader.specularPower;
	}

	inline function set_specularPower(v) {
		return mshader.specularPower = v;
	}

	inline function get_specularAmount() {
		return mshader.specularAmount;
	}

	inline function set_specularAmount(v) {
		return mshader.specularAmount = v;
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
		if( textureShader != null ) {
			m.textureShader.additive = textureShader.additive;
			m.textureShader.killAlpha = textureShader.killAlpha;
			m.textureShader.killAlphaThreshold = textureShader.killAlphaThreshold;
		}
		m.color = color;
		m.blendMode = blendMode;
		return m;
	}

	function set_blendMode(v:BlendMode) {
		if( mainPass != null ) {
			mainPass.setBlendMode(v);
			switch( v ) {
			case None:
				mainPass.depthWrite = true;
				mainPass.setPassName("default");
			case Alpha:
				mainPass.depthWrite = true;
				mainPass.setPassName("alpha");
			case Add:
				mainPass.depthWrite = false;
				mainPass.setPassName("additive");
			case SoftAdd:
				mainPass.depthWrite = false;
				mainPass.setPassName("additive");
			case Multiply:
				mainPass.depthWrite = false;
				mainPass.setPassName("additive");
			case Erase:
				mainPass.depthWrite = false;
				mainPass.setPassName("additive");
			case Screen:
				mainPass.depthWrite = false;
				mainPass.setPassName("additive");
			}
		}
		return blendMode = v;
	}

	function get_specularTexture() {
		return specularShader == null ? null : specularShader.texture;
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

	function set_specularTexture(t) {
		if( t == null ) {
			if( specularShader != null ) {
				mainPass.removeShader(specularShader);
				specularShader = null;
			}
		} else {
			if( specularShader == null ) {
				specularShader = new h3d.shader.SpecularTexture();
				mainPass.addShader(specularShader);
			}
			specularShader.texture = t;
		}
		return t;
	}

}
