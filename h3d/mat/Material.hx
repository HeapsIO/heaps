package h3d.mat;

@:enum private abstract DefaultKind(String) {
	var Opaque = "Opaque";
	var Alpha = "Alpha";
	var AlphaKill = "AlphaKill";
	var Add = "Add";
	var SoftAdd = "SoftAdd";
	var Hidden = "Hidden";
}

private typedef DefaultProps = {
	var kind : DefaultKind;
	var shadows : Bool;
	var culling : Bool;
	var light : Bool;
}

class Material extends BaseMaterial {

	var mshader : h3d.shader.BaseMesh;
	var normalShader : h3d.shader.NormalMap;

	public var model : hxd.res.Resource;

	public var shadows(get, set) : Bool;
	public var castShadows(default, set) : Bool;
	public var receiveShadows(default, set) : Bool;
	public var staticShadows(default, set) : Bool;

	public var textureShader(default, null) : h3d.shader.Texture;
	public var specularShader(default, null) : h3d.shader.SpecularTexture;
	public var texture(get, set) : h3d.mat.Texture;
	public var specularTexture(get, set) : h3d.mat.Texture;
	public var normalMap(get,set) : h3d.mat.Texture;

	public var color(get, set) : Vector;
	public var specularAmount(get, set) : Float;
	public var specularPower(get, set) : Float;
	public var blendMode(default, set) : BlendMode;

	function new(?texture) {
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

	inline function get_shadows() {
		return castShadows && receiveShadows;
	}

	inline function set_shadows(v) {
		castShadows = v;
		receiveShadows = v;
		return v;
	}

	function set_castShadows(v) {
		if( castShadows == v )
			return v;
		if( mainPass != null ) {
			if( v )
				addPass(new Pass("shadow", null, mainPass)).isStatic = staticShadows;
			else
				removePass(getPass("shadow"));
		}
		return castShadows = v;
	}

	function set_receiveShadows(v) {
		if( v == receiveShadows )
			return v;
		if( mainPass != null ) {
			var shadows = h3d.mat.Defaults.shadowShader;
			if( v )
				mainPass.addShader(shadows);
			else
				mainPass.removeShader(shadows);
		}
		return receiveShadows = v;
	}

	function set_staticShadows(v) {
		var p = getPass("shadow");
		if( p != null ) p.isStatic = v;
		return staticShadows = v;
	}

	override function clone( ?m : BaseMaterial ) : BaseMaterial {
		var m = m == null ? new Material() : cast m;
		super.clone(m);
		m.castShadows = castShadows;
		m.receiveShadows = receiveShadows;
		m.texture = texture;
		m.specularTexture = specularTexture;
		m.normalMap = normalMap;
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
			case Add, AlphaAdd, SoftAdd, Multiply, AlphaMultiply, Erase, Screen, Sub, Max, Min:
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

	function get_normalMap() {
		return normalShader == null ? null : normalShader.texture;
	}

	function set_normalMap(t) {
		if( t == null ) {
			if( normalShader != null ) {
				mainPass.removeShader(normalShader);
				normalShader = null;
			}
		} else {
			if( normalShader == null ) {
				normalShader = new h3d.shader.NormalMap();
				if( textureShader != null )
					mainPass.addShaderAtIndex(normalShader, mainPass.getShaderIndex(textureShader)+1);
				else
					mainPass.addShader(normalShader);
			}
			normalShader.texture = t;
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

	// -- PROPS

	/*
		This is called after a model has been loaded and the material textures setup.
		It will build the properties for this material, loading them from storage if necessary
	*/
	public function getDefaultModelProps() : Any {
		var props : DefaultProps = getDefaultProps();
		switch( blendMode ) {
		case Alpha:
			props.kind = Alpha;
		case Add:
			props.kind = Add;
			props.culling = false;
			props.shadows = false;
			props.light = false;
		case None:
			// default
		default:
			throw "Unsupported HMD material " + blendMode;
		}
		return props;
	}

	override function getDefaultProps( ?type : String ) : Any {
		var props : DefaultProps;
		switch( type ) {
		case "particles3D", "trail3D":
			props = {
				kind : Alpha,
				shadows : false,
				culling : false,
				light : true,
			};
		case "ui":
			props = {
				kind : Alpha,
				shadows : false,
				culling : false,
				light : false,
			};
		default:
			props = {
				kind : Opaque,
				shadows : true,
				culling : true,
				light : true,
			};
		}
		return props;
	}

	override function refreshProps() {
		if( props == null || mainPass == null ) return;
		var props : DefaultProps = props;
		switch( props.kind ) {
		case Opaque, AlphaKill, Hidden: blendMode = None;
		case Alpha: blendMode = Alpha;
		case Add: blendMode = Add;
		case SoftAdd: blendMode = SoftAdd;
		}
		var tshader = textureShader;
		if( tshader != null ) {
			tshader.killAlpha = props.kind == AlphaKill;
			tshader.killAlphaThreshold = 0.5;
		}
		mainPass.culling = props.kind == Hidden ? Both : props.culling ? Back : None;
		mainPass.enableLights = props.light;
		shadows = props.shadows;
		if( shadows )
			getPass("shadow").culling = mainPass.culling;
	}

	#if editor
	override function editProps() {
		return new js.jquery.JQuery('
			<dl>
				<dt>Kind</dt>
				<dd>
					<select field="kind">
						<option value="Opaque">Opaque</option>
						<option value="Alpha">Alpha</option>
						<option value="AlphaKill">AlphaKill</option>
						<option value="Add">Add</option>
						<option value="SoftAdd">SoftAdd</option>
						<option value="Hidden">Hidden</option>
					</select>
				</dd>
				<dt>Shadows</dt><dd><input type="checkbox" field="shadows"/></dd>
				<dt>Culling</dt><dd><input type="checkbox" field="culling"/></dd>
				<dt>Light</dt><dd><input type="checkbox" field="light"/></dd>
			</dl>
		');
	}
	#end

	/*
		Shortcut to create a material for the current renderer setup using the specific diffuse texture.
	*/
	public static function create( ?tex : h3d.mat.Texture ) {
		var mat = h3d.mat.MaterialSetup.current.createMaterial();
		mat.texture = tex;
		mat.props = mat.getDefaultProps();
		return mat;
	}

}
