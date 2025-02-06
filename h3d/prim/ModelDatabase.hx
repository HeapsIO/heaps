package h3d.prim;

class ModelDatabase {

	public static var db : Map<String,{ v : Dynamic }> = new Map();

	static var defaultLodConfigs : Map<String, Array<Float>> = new Map();
	static var baseLodConfig = [ 0.5, 0.2, 0.01];

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

	public function saveModelProps( name : String, hmd : HMDModel) {
		var root : Dynamic = getModelData(@:privateAccess hmd.lib.resource);
		if( root == null )
			return;

		var lodConfigObj = Reflect.field(root, "lodConfig");
		if (lodConfigObj == null) {
			lodConfigObj = {};
			Reflect.setField(root, "lodConfig", lodConfigObj);
		}

		var isDefaultConfig = true;
		var defaultConfig = getDefaultLodConfig(@:privateAccess hmd.lib.resource.entry.directory);

		if (@:privateAccess hmd.lodConfig != null) {
			if (defaultConfig.length != @:privateAccess hmd.lodConfig.length)
				isDefaultConfig = false;

			for (idx in 0...@:privateAccess hmd.lodConfig.length) {
				if (defaultConfig[idx] != @:privateAccess hmd.lodConfig[idx]) {
					isDefaultConfig = false;
					break;
				}
			}
		}

		if (!isDefaultConfig) {
			var c = [];
			for (idx in 0...hmd.lodCount()) @:privateAccess {
				if (idx >= hmd.lodConfig.length)
					c[idx] = 0.;
				else
					c[idx] = hmd.lodConfig[idx];
			}
			Reflect.setField(lodConfigObj, name, c);
		}
		else
			Reflect.deleteField(lodConfigObj, name);

		if (Reflect.fields(lodConfigObj).length <= 0)
			Reflect.deleteField(root, "lodConfig");

		saveData(@:privateAccess hmd.lib.resource, root);
	}

	public function getDefaultLodConfig( dir : String ) : Array<Float> {
		var fs = Std.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
		if (fs == null)
			return baseLodConfig;

		#if (sys || nodejs)
			var c = @:privateAccess fs.convert.getConfig(defaultLodConfigs, baseLodConfig, dir, function(fullObj) {
				if (Reflect.hasField(fullObj, "lods.screenRatio"))
					return Reflect.field(fullObj, "lods.screenRatio");

				return baseLodConfig;
			});
			return c;
		#else
			return baseLodConfig;
		#end

	}

	public static var current = new ModelDatabase();
}