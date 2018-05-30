package h3d.mat;

@:enum private abstract DefaultKind(String) {
	var Opaque = "Opaque";
	var Alpha = "Alpha";
	var AlphaKill = "AlphaKill";
	var Add = "Add";
	var SoftAdd = "SoftAdd";
}

private typedef DefaultProps = {
	var kind : DefaultKind;
	var shadows : Bool;
	var culled : Bool;
	var lighted : Bool;
}

class MaterialSetup {

	public var name(default,null) : String;
	var database : MaterialDatabase;

	public function new(name) {
		if( database == null )
			database = new MaterialDatabase("materials.json");
		this.name = name;
	}

	public function createRenderer() : h3d.scene.Renderer {
		return new h3d.scene.DefaultRenderer();
	}

	public function createLightSystem() {
		return new h3d.scene.LightSystem();
	}

	public function initModelMaterial( material : Material ) {
		var props = database.loadProps(material, this);
		if( props == null ) {
			props = getDefaults();
			// use hmd material
			var props : DefaultProps = props;
			switch( material.blendMode ) {
			case Alpha:
				props.kind = Alpha;
			case Add:
				props.kind = Add;
				props.culled = false;
				props.shadows = false;
				props.lighted = false;
			case None:
			default:
				throw "Unsupported HMD material " + material.blendMode;
			}
		}
		material.props = props;
	}

	public function saveModelMaterial( material : Material ) {
		database.saveProps(material, this);
	}

	public function initMeshAfterLoad( mesh : h3d.scene.Mesh ) {
	}

	public function getDefaults( ?type : String ) : Any {
		var props : DefaultProps;
		switch( type ) {
		case "particles3D":
			props = {
				kind : Opaque,
				shadows : false,
				culled : false,
				lighted : true,
			};
		case "trail3D":
			props = {
				kind : Opaque,
				shadows : false,
				culled : false,
				lighted : true,
			};
		default:
			props = {
				kind : Opaque,
				shadows : true,
				culled : true,
				lighted : true,
			};
		}
		return props;
	}

	public function applyProps( m : Material ) {
		var props : DefaultProps = m.props;
		var mainPass = m.mainPass;
		switch( props.kind ) {
		case Opaque, AlphaKill:
			mainPass.setBlendMode(None);
			mainPass.depthWrite = true;
			mainPass.setPassName("default");
		case Alpha:
			mainPass.setBlendMode(Alpha);
			mainPass.depthWrite = true;
			mainPass.setPassName("alpha");
		case Add:
			mainPass.setBlendMode(Add);
			mainPass.depthWrite = false;
			mainPass.setPassName("additive");
		case SoftAdd:
			mainPass.setBlendMode(SoftAdd);
			mainPass.depthWrite = false;
			mainPass.setPassName("additive");
		}
		var tshader = m.textureShader;
		if( tshader != null ) {
			tshader.killAlpha = props.kind == AlphaKill;
			tshader.killAlphaThreshold = 0.5;
		}
		mainPass.culling = props.culled ? Back : None;
		mainPass.enableLights = props.lighted;
		m.shadows = props.shadows;
		if( m.shadows ) m.getPass("shadow").culling = mainPass.culling;
	}

	#if js
	public function editMaterial( props : Any ) {
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
					</select>
				</dd>
				<dt>Shadows</dt><dd><input type="checkbox" field="shadows"/></dd>
				<dt>Culled</dt><dd><input type="checkbox" field="culled"/></dd>
				<dt>Lighted</dt><dd><input type="checkbox" field="lighted"/></dd>
			</dl>
		');
	}
	#end

	public static var current = new MaterialSetup("Default");

}