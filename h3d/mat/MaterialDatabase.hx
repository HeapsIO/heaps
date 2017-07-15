package h3d.mat;

class MaterialDatabase {

	public var file(default, null) : String;
	var db : Dynamic;

	public function new( file : String ) {
		this.file = file;
	}

	function getPath( material : Material, setup : MaterialSetup ) {
		var path = material.model == null ? [] : material.model.entry.path.split("/");
		path.pop();
		path.push(material.name);
		path.unshift(setup.name);
		return path;
	}

	function load() {
		db = try haxe.Json.parse(hxd.res.Loader.currentInstance.load(file).toText()) catch( e : hxd.res.NotFound ) {};
	}

	function save() {
		#if sys
		var path = haxe.macro.Compiler.getDefine("resourcesPath");
		if( path == null ) path = "res";
		sys.io.File.saveContent(path + "/" + file, haxe.Json.stringify(db, "\t"));
		#else
		throw "Can't save material props database " + file;
		#end
	}

	public function loadProps( material : Material, setup : MaterialSetup ) {
		if( db == null ) load();
		var path = getPath(material, setup);
		var root : Dynamic = db;
		while( path.length > 0 ) {
			root = Reflect.field(root, path.shift());
			if( root == null )
				return null;
		}
		return root;
	}

	public function saveProps( material : Material, setup : MaterialSetup ) {
		if( db == null ) load();
		var path = getPath(material, setup);
		var root : Dynamic = db;
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
		setup.initModelMaterial(material); // reset to default
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
		}
		material.props = currentProps;
		save();
	}

}