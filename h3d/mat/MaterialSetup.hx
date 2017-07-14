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

	public function new(name) {
		this.name = name;
	}

	public function createRenderer() {
		return new h3d.scene.Renderer();
	}

	public function createLightSystem() {
		return new h3d.pass.LightSystem();
	}

	public function initModelMaterial( model : hxd.res.Model, material : Material ) {
		material.mainPass.enableLights = true;
		material.shadows = true;
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

	public static var current = new MaterialSetup("Default");

}