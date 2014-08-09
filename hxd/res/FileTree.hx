package hxd.res;
import haxe.macro.Context;
import haxe.macro.Expr;

private typedef FileEntry = { e : Expr, t : ComplexType };

class FileTree {

	var path : String;
	var currentModule : String;
	var pos : Position;
	var loaderType : ComplexType;
	var ignoredExt : Map<String,Bool>;
	var pairedExt : Map<String,Array<String>>;
	var ignoredPairedExt : Map<String,Array<String>>;
	var options : EmbedOptions;
	var isFlash : Bool;
	var isJS : Bool;
	var isCPP : Bool;
	var embedTypes : Array<String>;

	public function new(dir) {
		this.path = resolvePath(dir);
		currentModule = Std.string(Context.getLocalClass());
		pos = Context.currentPos();
		ignoredExt = new Map();
		ignoredExt.set("gal", true); // graphics gale source
		ignoredExt.set("lch", true); // labchirp source
		ignoredExt.set("fla", true); // Adobe flash
		pairedExt = new Map();
		pairedExt.set("fnt", ["png"]);
		pairedExt.set("fbx", ["png"]);
		pairedExt.set("cdb", ["img"]);
		pairedExt.set("xtra", ["fbx"]);
		isFlash = Context.defined("flash");
		isJS = Context.defined("js");
		isCPP = Context.defined("cpp");
	}

	public static function resolvePath( ?dir:String ) {
		var resolve = true;
		if( dir == null ) {
			dir = Context.definedValue("resourcesPath");
			if( dir == null ) dir = "res" else resolve = false;
		}
		var pos = Context.currentPos();
		if( resolve )
			dir = try Context.resolvePath(dir) catch( e : Dynamic ) Context.error("Resource directory not found in classpath '" + dir + "' (use -D resourcesPath=DIR)", pos);
		var path = sys.FileSystem.fullPath(dir);
		if( !sys.FileSystem.exists(path) || !sys.FileSystem.isDirectory(path) )
			Context.error("Resource directory does not exists '" + path + "'", pos);
		return path;
	}

	public function embed(options:EmbedOptions) {
		if( options == null ) options = { };
		var needTmp = options.compressSounds;
		if( options.tmpDir == null ) options.tmpDir = path + "/.tmp/";
		if( needTmp && !sys.FileSystem.exists(options.tmpDir) )
			sys.FileSystem.createDirectory(options.tmpDir);
		this.options = options;
		embedTypes = [];
		return { tree : embedRec(""), types : embedTypes };
	}

	function embedRec( relPath : String ) {
		var dir = this.path + relPath;
		var data = { };
		// make sure to rescan if one of the directories content has changed (file added or deleted)
		Context.registerModuleDependency(currentModule, dir);
		for( f in sys.FileSystem.readDirectory(dir) ) {
			var path = dir + "/" + f;
			if( sys.FileSystem.isDirectory(path) ) {
				if( f.charCodeAt(0) == ".".code || f.charCodeAt(0) == "_".code )
					continue;
				var sub = embedDir(f, relPath + "/" + f, path);
				if( sub != null )
					Reflect.setField(data, f, sub);
			} else {
				var extParts = f.split(".");
				var noExt = extParts.shift();
				var ext = extParts.join(".");
				if( ignoredExt.exists(ext.toLowerCase()) )
					continue;
				if( embedFile(f, ext, relPath + "/" + f, path) )
					Reflect.setField(data, f, true);
			}
		}
		return data;
	}

	function embedDir( dir : String, relPath : String, fullPath : String ) {
		var f = embedRec(relPath);
		if( Reflect.fields(f).length == 0 )
			return null;
		return f;
	}

	function getTime( file : String ) {
		return try sys.FileSystem.stat(file).mtime.getTime() catch( e : Dynamic ) -1.;
	}

	static var invalidChars = ~/[^A-Za-z0-9_]/g;
	function embedFile( file : String, ext : String, relPath : String, fullPath : String ) {
		var name = "R" + invalidChars.replace(relPath, "_");

		switch( ext.toLowerCase() ) {
		case "wav" if( options.compressSounds ):
			var tmp = options.tmpDir + name + ".mp3";
			if( getTime(tmp) < getTime(fullPath) ) {
				Sys.println("Converting " + relPath);
				if( Sys.command("lame", ["--silent","-h",fullPath,tmp]) != 0 )
					Context.warning("Failed to run lame on " + path, pos);
				else {
					fullPath = tmp;
				}
			} else {
				fullPath = tmp;
			}
			Context.registerModuleDependency(currentModule, fullPath);
		case "fbx" if( options.createXBX ):
			var tmp = options.tmpDir + name + ".xbx";
			if( getTime(tmp) < getTime(fullPath) ) {
				Sys.println("Converting " + relPath);
				var fbx = hxd.fmt.fbx.Parser.parse(sys.io.File.getContent(fullPath));
				if( options.xbxFilter != null )
					fbx = options.xbxFilter(relPath,fbx);
				var out = sys.io.File.write(tmp);
				new hxd.fmt.fbx.XBXWriter(out).write(fbx);
				out.close();
			}
			Context.registerModuleDependency(currentModule, fullPath);
			fullPath = tmp;
		default:
		}

		if( isFlash ) {
			switch( ext.toLowerCase() ) {
			case "ttf":
				Embed.doEmbedFont(name, fullPath, options.fontsChars);
				embedTypes.push("hxd._res." + name);
				return false; // don't embed font bytes in flash
			default:
			}
			Context.defineType( {
				params : [],
				pack : ["hxd","_res"],
				name : name,
				pos : pos,
				isExtern : false,
				fields : [],
				meta : [
					{ name : ":native", params : [{ expr : EConst(CString("_"+name)), pos : pos }], pos : pos },
					{ name : ":keep", params : [], pos : pos },
					{ name : ":file", params : [ { expr : EConst(CString(fullPath)), pos : pos } ], pos : pos },
				],
				kind : TDClass({ pack : ["flash","utils"], name : "ByteArray", params : [] }),
			});
			embedTypes.push("hxd._res." + name);
		} else if( isJS || isCPP ) {
			switch( ext.toLowerCase() ) {
			case "ttf" if( isJS ):
				Embed.doEmbedFont(name, fullPath, options.fontsChars);
				embedTypes.push("hxd._res." + name);
				return true;
			default:
			}
			Context.addResource(name, sys.io.File.getBytes(fullPath));
		} else {
			return false;
		}
		return true;
	}

	public function scan() {
		var fields = Context.getBuildFields();
		var dict = new Map();
		for( f in fields ) {
			if( Lambda.has(f.access,AStatic) ) {
				dict.set(f.name, { field : null, fget : null, path : "class declaration" });
				if( f.name == "loader" )
					loaderType = switch( f.kind ) {
					case FVar(t, _), FProp(_, _, t, _): t;
					default: null;
					}
			}
		}
		if( loaderType == null ) {
			loaderType = macro : hxd.res.Loader;
			dict.set("loader", { field : null, fget : null, path : "reserved identifier" });
			fields.push({
				name : "loader",
				access : [APublic, AStatic],
				kind : FVar(loaderType),
				pos : pos,
			});
		}
		ignoredPairedExt = new Map();
		for( e1 in pairedExt.keys() ) {
			for( e2 in pairedExt.get(e1) ) {
				var a = ignoredPairedExt.get(e2);
				if( a == null ) {
					a = [];
					ignoredPairedExt.set(e2, a);
				}
				a.push(e1);
			}
		}
		scanRec("", fields, dict);
		return fields;
	}

	function scanRec( relPath : String, fields : Array<Field>, dict : Map<String,{path:String,field:Field,fget:Field}> ) {
		var dir = this.path + (relPath == "" ? "" : "/" + relPath);
		// make sure to rescan if one of the directories content has changed (file added or deleted)
		Context.registerModuleDependency(currentModule, dir);
		var allFiles = sys.FileSystem.readDirectory(dir);
		for( f in allFiles ) {
			var path = dir + "/" + f;
			var fileName = f;
			var field = null;
			var ext = null;
			if( sys.FileSystem.isDirectory(path) ) {
				if( f.charCodeAt(0) == ".".code || f.charCodeAt(0) == "_".code )
					continue;
				field = handleDir(f, relPath.length == 0 ? f : relPath+"/"+f, path);
			} else {
				var extParts = f.split(".");
				var noExt = extParts.shift();
				ext = extParts.join(".");
				if( ignoredExt.exists(ext.toLowerCase()) )
					continue;
				// when we have a pair file [a,b], ignore file.b if file.a is present
				var a = ignoredPairedExt.get(ext.toLowerCase());
				if( a != null ) {
					var found = false;
					for( e in a ) {
						var otherFile = noExt + "." + e;
						for( f in allFiles )
							if( f == otherFile ) {
								found = true;
								break;
							}
						if( found ) break;
					}
					if( found ) continue;
				}
				field = handleFile(f, ext, relPath.length == 0 ? f : relPath + "/" + f, path);
				f = noExt;
			}
			if( field != null ) {
				var fname = invalidChars.replace(f, "_");
				if( fname.charCodeAt(0) >= "0".code && fname.charCodeAt(0) <= "9".code )
					fname = "_" + fname;
				var other = dict.get(fname);
				if( other != null ) {
					var pe = pairedExt.get(other.path.split(".").pop().toLowerCase());
					if( pe != null && Lambda.has(pe,ext.toLowerCase()) )
						continue;
					if( other.field == null ) {
						Context.warning("Resource " + relPath + "/" + f + " is used by both " + relPath + "/" + fileName + " and " + other, pos);
						continue;
					}
					fname += "_" + ext.split(".").join("_");
					var exts = other.path.split("/").pop().split(".");
					exts.shift();
					var otherExt = exts.join("_");
					other.field.name += "_" + otherExt;
					other.fget.name += "_" + otherExt;
				}
				var fget : Field = {
					name : "get_" + fname,
					pos : pos,
					kind : FFun({
						args : [],
						params : [],
						ret : field.t,
						expr : { expr : EMeta({ name : ":privateAccess", params : [], pos : pos }, { expr : EReturn(field.e), pos : pos }), pos : pos },
					}),
					#if openfl
					meta : [ { name:":keep", pos:pos, params:[] } ],
					#else
					meta : [ { name:":extern", pos:pos, params:[] } ],
					#end
					access : [AStatic, AInline, APrivate],
				};
				var field : Field = {
					name : fname,
					pos : pos,
					kind : FProp("get","never",field.t),
					access : [AStatic, APublic],
				};
				fields.push(field);
				fields.push(fget);
				dict.set(f, { path : relPath + "/" + fileName, field : field, fget : fget });
			}
		}
	}

	function handleDir( dir : String, relPath : String, fullPath : String ) : FileEntry {
		var ofields = [];
		var dict = new Map();
		dict.set("loader", { path : "reserved identifier", field : null, fget : null });
		scanRec(relPath, ofields, dict);
		if( ofields.length == 0 )
			return null;
		var name = "R" + (~/[^A-Za-z0-9_]/g.replace(fullPath, "_"));
		for( f in ofields )
			f.access.remove(AStatic);
		var def = macro class {
			private inline function new(loader) this = loader;
			private var loader(get,never) : $loaderType;
			inline private function get_loader() : $loaderType return this;
		};
		for( f in def.fields )
			ofields.push(f);
		Context.defineType( {
			pack : ["hxd", "_res"],
			name : name,
			pos : pos,
			meta : [{ name : ":dce", params : [], pos : pos }],
			isExtern : false,
			fields : ofields,
			params : [],
			kind : TDAbstract(loaderType),
		});
		var tpath = { pack : ["hxd", "_res"], name : name, params : [] };
		return {
			t : TPath(tpath),
			e : { expr : ENew(tpath, [macro loader]), pos : pos },
		};
	}

	function handleFile( file : String, ext : String, relPath : String, fullPath : String ) : FileEntry {
		var epath = { expr : EConst(CString(relPath)), pos : pos };
		switch( ext.toLowerCase() ) {
		case "jpg", "png":
			return { e : macro loader.loadImage($epath), t : macro : hxd.res.Image };
		case "fbx", "xbx", "xtra":
			return { e : macro loader.loadFbxModel($epath), t : macro : hxd.res.FbxModel };
		case "awd":
			return { e : macro loader.loadAwdModel($epath), t : macro : hxd.res.AwdModel };
		case "ttf":
			return { e : macro loader.loadFont($epath), t : macro : hxd.res.Font };
		case "fnt":
			return { e : macro loader.loadBitmapFont($epath), t : macro : hxd.res.BitmapFont };
		case "wav", "mp3":
			return { e : macro loader.loadSound($epath), t : macro : hxd.res.Sound };
		case "tmx":
			return { e : macro loader.loadTiledMap($epath), t : macro : hxd.res.TiledMap };
		default:
			return { e : macro loader.loadData($epath), t : macro : hxd.res.Resource };
		}
		return null;
	}

	public static function build( ?dir : String ) {
		return new FileTree(dir).scan();
	}

}