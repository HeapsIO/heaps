package h3d.prim;

class ModelDatabase {

	public static var db : Map<String,{ v : Dynamic }> = new Map();

	static var defaultLodConfigs : Map<String, Array<Float>> = new Map();
	static var baseLodConfig = [ 0.3, 0.2, 0.1];

	static var filename = "model.props";

	var baseDir(get, never) : String;

	public function new() {
	}

	function get_baseDir() return '';
	function getFilePath( model : hxd.res.Resource ) {
		var dir = model.entry.directory;
		return dir == null || dir == "" ? filename : model.entry.directory + "/" + filename;
	}

	public function getModelData( model : hxd.res.Resource ) {
		if( model == null )
			return null;
		var cached = ModelDatabase.db.get(model.entry.directory);
		if( cached != null )
			return cached.v;
		var file = getFilePath(model);
		var value = try haxe.Json.parse(hxd.res.Loader.currentInstance.load(file).toText()) catch( e : hxd.res.NotFound ) {};
		ModelDatabase.db.set(model.entry.directory, { v : value });
		return value;
	}

	function saveData( model : hxd.res.Resource, data : Dynamic ) {
		var file = getFilePath(model);
		#if ((sys || nodejs) && !usesys)
		var fs = Std.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
		if( fs != null && !haxe.io.Path.isAbsolute(file) )
			file = fs.baseDir + file;
		if( data == null || Reflect.fields(data).length == 0 )
			(try sys.FileSystem.deleteFile(file) catch( e : Dynamic ) {});
		else
			sys.io.File.saveContent(file, haxe.Json.stringify(data, "\t"));
		#else
		throw "Can't save model props database " + file;
		#end
	}

	public function loadModelProps( name : String, hmd : HMDModel) {
		var p : Dynamic = getModelData(@:privateAccess hmd.lib.resource);

		var lodConfigs = Reflect.field(p, "lodConfig");
		@:privateAccess hmd.lodConfig = Reflect.field(lodConfigs, name);
	}

	public function saveModelProps( name : String, hmd : HMDModel, defaultProps : Any = null ) {
		var root : Dynamic = getModelData(@:privateAccess hmd.lib.resource);
		if( root == null )
			return;

		var lodConfigObj = Reflect.field(root, "lodConfig");
		if (lodConfigObj == null) {
			lodConfigObj = {};
			Reflect.setField(root, "lodConfig", lodConfigObj);
		}

		if (@:privateAccess hmd.lodConfig != null)
			Reflect.setField(lodConfigObj, name, @:privateAccess hmd.lodConfig);
		else
			Reflect.deleteField(lodConfigObj, name);

		if (Reflect.fields(lodConfigObj).length <= 0)
			Reflect.deleteField(root, "lodConfig");

		saveData(@:privateAccess hmd.lib.resource, root);
	}

	public function getDefaultLodConfig( dir : String ) : Array<Float> {
		var c = defaultLodConfigs.get(dir);
		if( c != null ) return c;

		var dirPos = dir.lastIndexOf("/");
		var parent = dir == "" ? baseLodConfig : getDefaultLodConfig(dirPos < 0 ? "" : dir.substr(0,dirPos));
		var propsFile = (dir == "" ? baseDir : baseDir + dir + "/")+"props.json";
		if( !hxd.res.Loader.currentInstance.exists(propsFile) ) {
			c = parent;
		} else {
			var content = hxd.res.Loader.currentInstance.load(propsFile).toText();
			var obj = try haxe.Json.parse(content) catch( e : Dynamic ) throw "Failed to parse "+propsFile+"("+e+")";

			if (Reflect.hasField(obj, "lods.screenRatio"))
				c = Reflect.field(obj, "lods.screenRatio");
			else
				c = parent;
		}

		defaultLodConfigs.set(dir, c);
		return c;
	}

	public static var current = new ModelDatabase();
}