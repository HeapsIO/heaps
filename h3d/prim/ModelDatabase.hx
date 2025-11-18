package h3d.prim;

#if !macro
typedef ModelDataInput = {
	var resourceDirectory : String;
	var resourceName : String;
	var objectName : String;
	var hmd : HMDModel;
	var skin : h3d.scene.Skin;
	var collide : Dynamic;
}
#end

typedef ModelProps = {
	lodConfig: Array<Float>,
	dynamicBones: Array<Dynamic>
}

class ModelDatabase {

	public static var db : Map<String, Dynamic> = new Map();
	var baseDir(get, never) : String;

	public static var FILE_NAME = "model.props";
	public static var DEFAULT_CONFIG_ENTRY = "default";

	public static var LOD_CONFIG = "lodConfig";
	public static var DYN_BONES_CONFIG = "dynamicBones";
	public static var COLLIDE_CONFIG = "collide";

	public static dynamic function customizeLodConfig(c : Array<Float>) {
		return c;
	}

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
		#if macro
		if ( !haxe.io.Path.isAbsolute(file) )
			file = haxe.macro.Context.definedValue("resourcesPath") + file;
		var value = try haxe.Json.parse(sys.io.File.getBytes(file).toString()) catch( e : hxd.res.NotFound ) {};
		#else
		var fs = Std.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
		if ( fs != null && haxe.io.Path.isAbsolute(file) )
			file = file.substr(fs.baseDir.length);
		var value = try haxe.Json.parse(hxd.res.Loader.currentInstance.load(file).toText()) catch( e : hxd.res.NotFound ) {};
		#end
		ModelDatabase.db.set(directory, value);
		return value;
	}

	function getModelData( directory : String, resourceName : String, modelName : String ) {
		var key = resourceName + "/" + modelName;
		var rootData = getRootData(directory);
		cleanOldModelData(rootData, key);
		return Reflect.field(rootData, key);
	}

	// Used to clean previous version of modelDatabase, should be removed after some time
	function cleanOldModelData( rootData : Dynamic, key : String) {
		var oldKey = '${key}_LOD0';

		var oldLodConfig = Reflect.field(rootData, LOD_CONFIG);
		if (oldLodConfig != null) {
			for (f in Reflect.fields(oldLodConfig)) {
				if (key.indexOf(f) < 0 && oldKey.indexOf(f) < 0)
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

		oldLodConfig = Reflect.field(rootData, oldKey);
		if (oldLodConfig != null) {
			Reflect.deleteField(rootData, oldKey);
			Reflect.setField(rootData, key, oldLodConfig);
		}
	}

	#if !macro
	function saveModelData( directory : String, resourceName : String, modelName : String, data : Dynamic ) {
		var file = getFilePath(directory);

		var rootData = getRootData(directory);
		var key = resourceName + "/" + modelName;
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


	function loadLodConfig( input : ModelDataInput, data : Dynamic ) {
		var c = Reflect.field(data, LOD_CONFIG);
		if (c == null || input.hmd == null)
			return;
		@:privateAccess input.hmd.lodConfig = c;
	}

	function loadDynamicBonesConfig( input : ModelDataInput, data : Dynamic ) {
		var c : Array<Dynamic> = Reflect.field(data, DYN_BONES_CONFIG);
		if (c == null || input.skin == null)
			return;

		function getJointConf(j: h3d.anim.Skin.Joint) {
			for (jConf in c)
				if (jConf.name == j.name)
					return jConf;

			return null;
		}

		var skinData = input.skin.getSkinData();
		for (j in skinData.allJoints) {
			var jConf = getJointConf(j);
			if (jConf == null)
				continue;

			var newJ = new h3d.anim.Skin.DynamicJoint();
			newJ.index = j.index;
			newJ.name = j.name;
			newJ.bindIndex = j.bindIndex;
			newJ.splitIndex = j.splitIndex;
			newJ.defMat = j.defMat;
			newJ.transPos = j.transPos;
			newJ.parent = j.parent;
			newJ.follow = j.follow;
			newJ.subs = j.subs;
			newJ.offsets = j.offsets;
			newJ.offsetRay = j.offsetRay;
			newJ.retargetAnim = j.retargetAnim;
			newJ.damping = jConf.damping;
			newJ.resistance = jConf.resistance;
			newJ.slackness = jConf.slackness;
			newJ.stiffness = jConf.stiffness;
			newJ.additive = jConf.additive;
			newJ.lockAxis = jConf.lockAxis == null ? new Vector(0, 0, 0): new Vector(jConf.lockAxis?.x, jConf.lockAxis?.y, jConf.lockAxis?.z);
			newJ.globalForce = new Vector(jConf.globalForce.x, jConf.globalForce.y, jConf.globalForce.z);
			skinData.allJoints[j.index] = newJ;

			j.parent?.subs.push(newJ);
			j.parent?.subs.remove(j);
			if (newJ.subs != null) {
				for (s in newJ.subs)
					s.parent = newJ;
			}
		}

		input.skin.setSkinData(skinData);
	}


	function saveLodConfig( input : ModelDataInput, data : Dynamic ) @:privateAccess {
		var isDefaultConfig = true;
		var defaultConfig = hxd.fmt.hmd.Library.getDefaultLodConfig(input.resourceDirectory);

		if (input.hmd.lodConfig != null) {
			if (defaultConfig.length != input.hmd.lodConfig.length)
				isDefaultConfig = false;

			for (idx in 0...input.hmd.lodConfig.length) {
				if (defaultConfig[idx] != input.hmd.lodConfig[idx]) {
					isDefaultConfig = false;
					break;
				}
			}
		}

		if (!isDefaultConfig) {
			var c = [];
			for (idx in 0...input.hmd.lodCount()) {
				if (idx >= input.hmd.lodConfig.length)
					c[idx] = 0.;
				else
					c[idx] = input.hmd.lodConfig[idx];
			}
			Reflect.setField(data, LOD_CONFIG, c);
		}
		else
			Reflect.deleteField(data, LOD_CONFIG);
	}

	function saveDynamicBonesConfig( input : ModelDataInput, data : Dynamic ) {
		if (input.skin == null)
			return;

		var dynamicJoints = [];
		for (j in input.skin.getSkinData().allJoints) {
			var dynJ = Std.downcast(j, h3d.anim.Skin.DynamicJoint);
			if (dynJ == null)
				continue;

			dynamicJoints.push({
				name: dynJ.name,
				slackness: dynJ.slackness,
				stiffness: dynJ.stiffness,
				resistance: dynJ.resistance,
				damping: dynJ.damping,
				additive: dynJ.additive,
				globalForce: dynJ.globalForce,
				lockAxis: dynJ.lockAxis
			});
		}

		var isDefaultConfig = true;
		if (dynamicJoints.length > 0) {
			var defaultConfig : Array<Dynamic> = hxd.fmt.hmd.Library.getDefaultDynamicBonesConfig(input.resourceDirectory);
			for (jConf in dynamicJoints) {
				var same = false;
				for (defConf in defaultConfig) {
					if (jConf.name == defConf.name && haxe.Json.stringify(jConf) == haxe.Json.stringify(defConf)) {
						same = true;
						break;
					}
				}

				if (!same) {
					isDefaultConfig = false;
					break;
				}
			}
		}

		if (isDefaultConfig || dynamicJoints.length == 0) {
			Reflect.deleteField(data, DYN_BONES_CONFIG);
			return;
		}

		Reflect.setField(data, DYN_BONES_CONFIG, dynamicJoints);
	}

	function saveCollideConfig( input : ModelDataInput, data : Dynamic ) {
		if ( !Reflect.hasField(input.collide, COLLIDE_CONFIG) )
			Reflect.deleteField(data, COLLIDE_CONFIG);
		else
			Reflect.setField(data, COLLIDE_CONFIG, Reflect.field(input.collide, COLLIDE_CONFIG));
	}


	public function loadModelProps( input : ModelDataInput ) {
		var data : Dynamic = getModelData(input.resourceDirectory, input.resourceName, input.objectName);
		if (data == null)
			return;

		loadLodConfig(input, data);
		loadDynamicBonesConfig(input, data);
	}

	public function saveModelProps( input : ModelDataInput ) {
		var data : Dynamic = getModelData(input.resourceDirectory, input.resourceName, input.objectName);
		if( data == null )
			data = {};

		saveLodConfig(input, data);
		saveDynamicBonesConfig(input, data);
		saveCollideConfig(input, data);

		saveModelData(input.resourceDirectory, input.resourceName, input.objectName, data);
	}
	#end

	public static var current = new ModelDatabase();
}