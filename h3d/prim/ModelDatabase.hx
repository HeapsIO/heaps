package h3d.prim;

class ModelDatabase {

	public static var db : Map<String, Dynamic> = new Map();
	var baseDir(get, never) : String;

	static var FILE_NAME = "model.props";

	static var LOD_CONFIG = "lodConfig";
	static var DYN_BONES_CONFIG = "dynamicBones";

	static var defaultLodConfigs : Map<String, Array<Float>> = new Map();
	static var baseLodConfig = [ 0.5, 0.2, 0.01];

	function new() {
	}

	function get_baseDir() return '';

	function getFilePath( directory : String ) {
		return directory == null || directory == "" ? FILE_NAME : directory + "/" + FILE_NAME;
	}


	function getRootData( directory : String ) {
		if( directory == null )
			return null;
		var cached = ModelDatabase.db.get(directory);
		if( cached != null )
			return cached;
		var file = getFilePath(directory);
		var value = try haxe.Json.parse(hxd.res.Loader.currentInstance.load(file).toText()) catch( e : hxd.res.NotFound ) {};
		ModelDatabase.db.set(directory, value);
		return value;
	}

	function getModelData( directory : String, key : String ) {
		var rootData = getRootData(directory);
		cleanOldModelData(rootData, key);
		return Reflect.field(rootData, key);
	}

	function saveModelData( directory : String, key : String, data : Dynamic ) {
		var file = getFilePath(directory);

		var rootData = getRootData(directory);
		if (data == null || Reflect.fields(data).length == 0)
			Reflect.deleteField(rootData, key);
		else
			Reflect.setField(rootData, key, data);

		#if ((sys || nodejs) && !usesys)
		var fs = Std.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
		if( fs != null && !haxe.io.Path.isAbsolute(file) )
			file = fs.baseDir + file;
		if( rootData == null || Reflect.fields(rootData).length == 0 )
			(try sys.FileSystem.deleteFile(file) catch( e : Dynamic ) {});
		else
			sys.io.File.saveContent(file, haxe.Json.stringify(rootData, "\t"));
		#else
		throw "Can't save model props database " + file;
		#end
	}


	public function loadModelProps( objectName : String, hmd : HMDModel ) {
		var key = @:privateAccess hmd.lib.resource.name + "/" + objectName;
		var modelData : Dynamic = getModelData(@:privateAccess hmd.lib.resource.entry.directory, key);

		loadLodConfig(modelData, hmd);
		loadDynamicBonesConfig(modelData, hmd);
	}

	public function saveModelProps( objectName : String, hmd : HMDModel ) {
		var key = @:privateAccess hmd.lib.resource.name + "/" + objectName;
		var data : Dynamic = getModelData(@:privateAccess hmd.lib.resource.entry.directory, key);
		if( data == null )
			data = {};

		saveLodConfig(data, hmd);
		saveDynamicBonesConfig(data, hmd);

		saveModelData(@:privateAccess hmd.lib.resource.entry.directory, @:privateAccess hmd.lib.resource.name + "/" + objectName, data);
	}


	function loadLodConfig( modelData : Dynamic, hmd : HMDModel ) {
		var lodConfigs = Reflect.field(modelData, LOD_CONFIG);
		@:privateAccess hmd.lodConfig = lodConfigs;
	}

	function loadDynamicBonesConfig( modelData : Dynamic, hmd : HMDModel ) {
		// TODO
	}


	function saveLodConfig( data : Dynamic, hmd : HMDModel ) {
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
			Reflect.setField(data, LOD_CONFIG, c);
		}
		else
			Reflect.deleteField(data, LOD_CONFIG);
	}

	function saveDynamicBonesConfig( data : Dynamic, hmd : HMDModel ) {
		// TODO
	}


	function getDefaultLodConfig( dir : String ) : Array<Float> {
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

	// Used to clean previous version of modelDatabase, should be removed after some time
	function cleanOldModelData( rootData : Dynamic, key : String) {
		var oldLodConfig = Reflect.field(rootData, LOD_CONFIG);
		if (oldLodConfig != null) {
			for (f in Reflect.fields(oldLodConfig)) {
				if (key.indexOf(f) < 0)
					continue;

				var c = Reflect.field(oldLodConfig, f);

				var newData = { "lodConfig" : c };
				Reflect.setField(rootData, key, newData);

				// Remove old entry
				Reflect.deleteField(oldLodConfig, f);
				Reflect.setField(rootData, LOD_CONFIG, oldLodConfig);
			}

			if (oldLodConfig == null || Reflect.fields(oldLodConfig).length == 0)
				Reflect.deleteField(rootData, LOD_CONFIG);
		}
	}

	public static var current = new ModelDatabase();
}