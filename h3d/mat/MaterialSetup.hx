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

	public function initModelMaterial( material : Material ) {
		var props = getStoredProps(getMaterialDBPath(material));
		if( props == null ) props = getDefaults();
		material.props = props;
	}

	function getMaterialDBPath( material : Material ) {
		var path = material.model.entry.path.split("/");
		path.pop();
		path.push(material.name);
		path.unshift(name);
		return path;
	}

	public function saveModelMaterial( material : Material ) {
		if( materialDB == null ) loadDB();
		var path = getMaterialDBPath(material);
		var root : Dynamic = materialDB;
		var prevs = [];
		for( i in 0...path.length - 1 ) {
			var next = Reflect.field(root, path[i]);
			if( next == null ) {
				next = {};
				Reflect.setField(root, path[i], next);
			}
			prevs.push(root);
			root = next;
		}
		var name = path.pop();
		Reflect.deleteField(root, name);

		var currentProps = material.props;
		initModelMaterial(material); // reset to default
		if( Std.string(material.props) == Std.string(currentProps) ) {
			// cleanup
			while( path.length > 0 ) {
				var name = path.pop();
				var root = prevs.pop();
				if( Reflect.fields(Reflect.field(root, name)).length != 0 )
					break;
				Reflect.deleteField(root, name);
			}
		} else {
			Reflect.setField(root, name, currentProps);
			material.props = currentProps;
		}
		saveDB();
	}

	function saveDB() {
		#if sys
		var path = haxe.macro.Compiler.getDefine("resourcesPath");
		if( path == null ) path = "res";
		sys.io.File.saveContent(path + "/" + dbPath, haxe.Json.stringify(materialDB, "\t"));
		#else
		throw "Can't save material props database " + dbPath;
		#end
	}

	function getStoredProps( path : Array<String> ) {
		if( materialDB == null ) loadDB();
		var root : Dynamic = materialDB;
		while( path.length > 0 ) {
			root = Reflect.field(root, path.shift());
			if( root == null )
				return null;
		}
		return root;
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

	static var dbPath = "materials.json";
	static var materialDB : Dynamic;
	static function loadDB() {
		materialDB = try haxe.Json.parse(hxd.res.Loader.currentInstance.load(dbPath).toText()) catch( e : hxd.res.NotFound ) {};
	}

}