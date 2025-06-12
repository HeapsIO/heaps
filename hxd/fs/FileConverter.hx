package hxd.fs;

#if (sys || nodejs)

typedef ConvertConfig = {
	var obj : Dynamic;
	var rules : Array<ConvertRule>;
}

typedef ConvertRule = { pt : ConvertPattern, cmd : ConvertCommand, priority : Int };

enum ConvertPattern {
	Filename( name : String );
	Regexp( r : EReg );
	Ext( e : String );
	Exts( e : Array<String> );
	Wildcard;
}

typedef ConvertCommand = {
	conv : Array<Convert>,
	?params : Dynamic,
	?paramsStr : String,
	?then : ConvertCommand
}

class FileConverter {

	// Date implementation has a second resolution on some platforms.
	public static final FILE_TIME_PRECISION = 1000;

	public var configuration(default,null) : String;

	var baseDir : String;
	var tmpDir : String;
	var configs : Map<String,ConvertConfig> = new Map();
	var defaultConfig : ConvertConfig;
	var cache : Map<String,Array<{ out : String, time : Int, hash : String, ver : Null<Int>, milliseconds : Null<Int>, localParamsHash : Null<String> }>>;
	var cacheTime : Float;

	static var extraConfigs:Array<Dynamic> = [];

	/**
		Add extra convert configuration. Should be props.json-compatible structure.
		Can be used to add or override converts that are enabled by default.
		Sample code of Convert registration and enabling it by default:
		```haxe
		// Register Convert
		static var _ = hxd.fs.Convert.register(new MyFancyConvert());
		// Enable it
		static var __ = hxd.fs.FileConverter.addConfig({
			"fs.convert": {
				// Converts are identified by output extension of Convert.
				"origext": { convert: "fancyext", priority: 0 },
				// Shorter declaration with default priority 0:
				"otherext": "fancyext"
			}
		});
		```
	**/
	public static function addConfig(conf:Dynamic) {
		extraConfigs.push(conf);
		return conf;
	}

	public function new(baseDir,configuration) {
		this.baseDir = baseDir;
		this.configuration = configuration;
		tmpDir = ".tmp/";
		// this is the default converts config, it can be override in per-directory props.json
		var defaultCfg : Dynamic = {
			"fs.convert" : {
				"fbx" : { "convert" : "hmd", "priority" : -1 },
				"fnt" : { "convert" : "bfnt", "priority" : -1 },
				"svg" : { "convert" : "png", "priority" : -1 }
			}
		};
		for ( conf in extraConfigs ) {
			defaultCfg = mergeRec(defaultCfg, conf);
		}
		defaultConfig = makeConfig(defaultCfg);
	}

	public dynamic function onConvert( c : Convert ) {
	}

	function makeConfig( obj : Dynamic ) {
		var cfg : ConvertConfig = {
			obj : obj,
			rules : [],
		};
		var def = Reflect.field(obj,"fs.convert");
		var conf = Reflect.field(obj,"fs.convert."+configuration);
		var merge = mergeRec(def, conf);
		for( f in Reflect.fields(merge) ) {
			var cmd = makeCommmand(Reflect.field(merge,f));
			var pt = if( f.charCodeAt(0) == "^".code ) {
				f = f.split("\\/").join("/").split("/").join("\\/");
				Regexp(new EReg(f,"i"));
			} else if( ~/^[a-zA-Z0-9,]+$/.match(f) ) {
				var el = f.toLowerCase().split(",");
				el.length == 1 ? Ext(el[0]) : Exts(el);
			} else if( f == "*" )
				Wildcard;
			else
				Filename(f);
			cfg.rules.push({ pt : pt, cmd : cmd.cmd, priority : cmd.priority });
		}
		cfg.rules.sort(sortByRulePiority);
		return cfg;
	}

	static function sortByRulePiority( r1 : ConvertRule, r2 : ConvertRule ) {
		if( r1.priority != r2.priority )
			return r2.priority - r1.priority;
		return r1.pt.getIndex() - r2.pt.getIndex();
	}

	function loadConvert( name : String ) {
		if( name == "none" ) return null;
		var c = @:privateAccess Convert.converts.get(name);
		if( c == null ) throw "No convert has been registered with name/extension '"+name+"'";
		return c;
	}

	function makeCommmand( obj : Dynamic ) : { cmd : ConvertCommand, priority : Int } {
		if( obj is String )
			return { cmd : { conv : loadConvert(obj) }, priority : 0 };
		if( obj.convert == null )
			throw "Missing 'convert' in "+obj;
		var cmd : ConvertCommand = { conv : loadConvert(obj.convert) };
		var priority = 0;
		for( f in Reflect.fields(obj) ) {
			var value : Dynamic = Reflect.field(obj,f);
			switch( f ) {
			case "convert": //
			case "then": cmd.then = makeCommmand(value).cmd;
			case "priority": priority = value;
			default:
				if( cmd.params == null ) cmd.params = {};
				Reflect.setField(cmd.params, f, value);
			}
		}
		if( cmd.params != null )
			cmd.paramsStr = formatValue(cmd.params);
		return { cmd : cmd, priority : priority };
	}

	function formatValue( v : Dynamic ) : String {
		if( !Reflect.isObject(v) )
			return Std.string(v);
		if( v is String )
			return v;
		if( v is Array ) {
			var a : Array<Dynamic> = v;
			return [for( v in a ) formatValue(v)].toString();
		}
		var fl = Reflect.fields(v);
		fl.sort(Reflect.compare);
		return [for( f in fl ) f+"_"+formatValue(Reflect.field(v,f))].join("_");
	}

	function mergeRec( a : Dynamic, b : Dynamic ) {
		if( b == null ) return a;
		if( a == null ) return b;
		var cp = {};
		for( f in Reflect.fields(a) ) {
			var va = Reflect.field(a,f);
			if( Reflect.hasField(b,f) ) {
				var vb = Reflect.field(b,f);
				if( Type.typeof(vb) == TObject && Type.typeof(va) == TObject ) vb = mergeRec(va,vb);
				Reflect.setField(cp,f,vb);
				continue;
			}
			Reflect.setField(cp,f,va);
		}
		for( f in Reflect.fields(b) )
			if( !Reflect.hasField(cp,f) )
				Reflect.setField(cp, f, Reflect.field(b,f));
		return cp;
	}

	function getFileTime( filePath : String ) : Float {
		return sys.FileSystem.stat(filePath).mtime.getTime();
	}

	function loadConfig( dir : String ) : ConvertConfig {
		return getConfig(configs, defaultConfig, dir, function(fullObj) {
			return makeConfig(fullObj);
		});
	}

	function getConfig(cachedConfigs : Map<String, Dynamic>, defaultConfig : Dynamic, dir : String, makeConfig : Dynamic -> Dynamic) : Dynamic {
		var c = cachedConfigs.get(dir);
		if( c != null ) return c;
		var dirPos = dir.lastIndexOf("/");
		var parent = dir == "" ? defaultConfig : getConfig(cachedConfigs, defaultConfig, dirPos < 0 ? "" : dir.substr(0,dirPos), (fullObj) -> makeConfig(fullObj));
		var propsFile = (dir == "" ? baseDir : baseDir + dir + "/") +"props.json";
		if( !sys.FileSystem.exists(propsFile) ) {
			c = parent;
		} else {
			var content = sys.io.File.getContent(propsFile);
			var obj = try haxe.Json.parse(content) catch( e : Dynamic ) throw "Failed to parse "+propsFile+"("+e+")";
			var fullObj = mergeRec(parent.obj, obj);
			c = makeConfig(fullObj);
		}
		cachedConfigs.set(dir, c);
		return c;
	}

	function getConvertRule( path : String ) : ConvertRule {
		var dirPos = path.lastIndexOf("/");
		var cfg = loadConfig(dirPos < 0 ? "" : path.substr(0,dirPos));
		var name = dirPos < 0 ? path : path.substr(dirPos + 1);
		var ext = name.split(".").pop().toLowerCase();
		for( r in cfg.rules )
			switch( r.pt ) {
			case Filename(f): if( name == f || path == f ) return r;
			case Regexp(reg): if( reg.match(name) || reg.match(path) ) return r;
			case Ext(e): if( ext == e ) return r;
			case Exts(el): if( el.indexOf(ext) >= 0 ) return r;
			case Wildcard: return r;
			}
		return null;
	}

	public function run( e : LocalFileSystem.LocalEntry ) {
		var rule = getConvertRule(e.path);
		if( e.originalFile == null )
			e.originalFile = e.file;
		else
			e.file = e.originalFile;
		if( rule == null || rule.cmd.conv == null )
			return;
		e.file = e.file.substr(baseDir.length);
		runConvert(e, rule.cmd, rule.pt.match(Ext(_)));
	}

	function runConvert( e : LocalFileSystem.LocalEntry, cmd : ConvertCommand, replaceExt : Bool = false ) {
		var outFile = tmpDir;
		var ext = e.extension;
		if( replaceExt && cmd.paramsStr == null && cmd.then == null )
			outFile += e.path.substr(0, -(ext.length + 1));
		else
			outFile += e.path;
		if( cmd.paramsStr != null ) {
			var paramsStr = cmd.paramsStr;
			if( paramsStr.length > 40 )
				paramsStr = haxe.crypto.Sha1.make(haxe.io.Bytes.ofString(paramsStr)).toHex();
			outFile += "." + paramsStr;
		}
		var conv = null;
		for( c in cmd.conv )
			if( c.sourceExts == null || c.sourceExts.indexOf(ext) >= 0 ) {
				conv = c;
				break;
			}
		if( conv == null )
			throw "No converter is registered that can convert "+e.path+" to "+cmd.conv[0].destExt;
		if( conv.destExt == "dummy" ) {
			e.file = baseDir + tmpDir + ".dummy";
			if( !sys.FileSystem.exists(e.file) )
				sys.io.File.saveContent(e.file,"");
			return;
		}
		if( conv.destExt == "remove" ) {
			e.file = null;
			return;
		}
		outFile += "."+conv.destExt;
		convertAndCache(e, outFile, conv, cmd.params);
		if( cmd.then != null ) {
			e.file = outFile;
			runConvert(e, cmd.then);
		}
		e.file = baseDir + outFile;
	}

	function convertAndCache( e : LocalFileSystem.LocalEntry, outFile : String, conv : Convert, params : Dynamic ) {
		var cacheFile = baseDir + tmpDir + "cache.dat";
		var time = try sys.FileSystem.stat(cacheFile).mtime.getTime() catch( e : Dynamic ) 0;
		if( cache == null || time > cacheTime ) {
			cache = try haxe.Unserializer.run(sys.io.File.getContent(cacheFile)) catch( e : Dynamic ) cache == null ? new Map() : cache;
			cacheTime = time;
		}
		var entry = cache.get(e.file);
		var needInsert = false;
		if( entry == null ) {
			entry = [];
			needInsert = true;
		}
		function saveCache() {
			if( needInsert ) cache.set(e.file, entry);
			sys.FileSystem.createDirectory(baseDir + tmpDir);
			sys.io.File.saveContent(baseDir + tmpDir + "cache.dat", haxe.Serializer.run(cache));
			cacheTime = Date.now().getTime();
		}

		var match = null;
		for( e in entry ) {
			if( e.out == outFile ) {
				match = e;
				if (match.ver == null) match.ver = 0;
				break;
			}
		}
		if( match == null ) {
			match = {
				out : outFile,
				time : 0,
				hash : "",
				ver: conv.version,
				milliseconds : #if js 0 #else null #end,
				localParamsHash: null
			};
			entry.push(match);
		}
		var fullPath = baseDir + e.file;
		var fullOutPath = baseDir + outFile;

		if( !sys.FileSystem.exists(fullPath) ) throw "Missing "+fullPath;

		var fileTime = getFileTime(fullPath);
		var time = hxd.Math.floor(fileTime / FILE_TIME_PRECISION);
		#if js
		var milliseconds = hxd.Math.floor(fileTime) - time * FILE_TIME_PRECISION;
		#else
		var milliseconds = null;
		#end
		var alreadyGen = sys.FileSystem.exists(fullOutPath) && match.ver == conv.version #if disable_res_cache && false #end;

		conv.params = params;
		conv.srcPath = fullPath;
		conv.dstPath = fullOutPath;
		conv.baseDir = baseDir;
		conv.originalFilename = e.name;
		var hasLocalParams = conv.hasLocalParams();

		if( alreadyGen && !hasLocalParams && match.time == time #if js && (match.milliseconds == null || match.milliseconds == milliseconds ) #end ) {
			conv.cleanup();
			return; // not changed (time stamp)
		}

		var content = hxd.File.getBytes(fullPath);
		var hash = haxe.crypto.Sha1.make(content).toHex();
		conv.srcBytes = content;
		conv.hash = hash;
		var localParams = hasLocalParams ? conv.computeLocalParams() : null;
		conv.localParams = localParams;
		var localParamsHash = localParams == null ? null : haxe.crypto.Sha1.make(haxe.io.Bytes.ofString(formatValue(localParams))).toHex();
		if( alreadyGen && match.hash == hash && match.localParamsHash == localParamsHash ) {
			conv.cleanup();
			match.time = time;
			match.milliseconds = milliseconds;
			saveCache();
			return; // not changed (hash)
		}

		sys.FileSystem.createDirectory(fullOutPath.substr(0, fullOutPath.lastIndexOf("/")));

		onConvert(conv);
		executeConvert(conv);
		conv.cleanup();

		if( !sys.FileSystem.exists(fullOutPath) )
			throw "Converted output file "+fullOutPath+" was not created";

		match.ver = conv.version;
		match.time = time;
		match.milliseconds = milliseconds;
		match.hash = hash;
		match.localParamsHash = localParamsHash;
		saveCache();
	}

	dynamic function executeConvert( conv : Convert ) {
		var prev = hxd.System.allowTimeout;
		hxd.System.allowTimeout = false;
		conv.convert();
		if( prev ) hxd.System.timeoutTick();
		hxd.System.allowTimeout = prev;
	}

}

#end
