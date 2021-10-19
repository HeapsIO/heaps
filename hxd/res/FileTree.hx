package hxd.res;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

private typedef FileEntry = { e : Expr, t : ComplexType, ?doc:String };

typedef FileTreeData = {
	var name : String;
	var relPath : String;
	var ident : String;
	var dirs : Map<String, FileTreeData>;
	var files : Map<String, { relPath : String, fullPath : String, file : String, ident : String, noExt : String, ext : String }>;
}

class FileTree {

	var paths : Array<String>;
	var currentModule : String;
	var pos : Position;
	var loaderType : ComplexType;
	var extensions : Map<String,{ t : ComplexType, e : Expr }>;
	var defaultExt : { t : ComplexType, e : Expr };
	var ignoredPairedExt : Map<String,Array<String>>;
	var options : EmbedOptions;
	var embedTypes : Array<String>;
	var checkTmp : Bool;

	public function new(dir) {
		this.paths = resolvePaths(dir);
		currentModule = Std.string(Context.getLocalClass());
		pos = Context.currentPos();
		defaultExt = { t : macro : hxd.res.Resource, e : macro hxd.res.Resource };
	}

	public static function resolvePaths( ?dir:String ) {
		var resolve = true;
		if( dir == null ) {
			dir = Context.definedValue("resourcesPath");
			if( dir == null ) dir = "res" else resolve = false;
		}
		var pos = Context.currentPos();
		var paths = [];
		for( dir in dir.split(";") ) {
			if( resolve )
				dir = try Context.resolvePath(dir) catch( e : Dynamic ) { Context.warning("Resource directory not found in classpath '" + dir + "' (use -D resourcesPath=DIR)", pos); return ["__invalid"]; }
			var path = sys.FileSystem.fullPath(dir);
			if( !sys.FileSystem.exists(path) || !sys.FileSystem.isDirectory(path) )
				Context.warning("Resource directory does not exists '" + path + "'", pos);
			paths.push(path);
		}
		return paths;
	}

	function scan() {
		var root : FileTreeData = {
			name : "root",
			ident : "root",
			relPath : "",
			dirs : new Map(),
			files : new Map(),
		};
		for( p in paths )
			scanRec(root, p);
		function cleanRec(f:FileTreeData) {
			var hasFile = f.files.iterator().hasNext();
			for( d in f.dirs )
				if( cleanRec(d) )
					hasFile = true;
				else
					f.dirs.remove(d.name);
			return hasFile;
		}
		cleanRec(root);
		return root;
	}

	static var invalidChars = ~/[^A-Za-z0-9_]/g;
	static var KEYWORDS = [for( k in ["break","case","cast","catch","class","continue","default","do","dynamic",
									"else","extends","extern","false","for","function","if","implementes","import",
									"interface","never","null","override","package","private","public","return",
									"static","super","switch","this","throw","trace","true","typedef","untyped",
									"using","var","final","while"] ) k => true];

	function makeIdent( s : String ) {
		var ident = invalidChars.replace(s, "_");
		if( ident == "" || (ident.charCodeAt(0) >= "0".code && ident.charCodeAt(0) <= "9".code) || KEYWORDS.exists(ident) )
			ident = "_" + ident;
		return ident;
	}


	function scanRec( tree : FileTreeData, basePath : String ) {
		var dir = basePath + "/" + tree.relPath;
		Context.registerModuleDependency(currentModule, dir);
		for( f in sys.FileSystem.readDirectory(dir) ) {
			var path = dir + "/" + f;
			if( sys.FileSystem.isDirectory(path) ) {
				if( f.charCodeAt(0) == ".".code || f.charCodeAt(0) == "_".code )
					continue;
				var d = tree.dirs.get(f);
				if( d == null ) {
					d = {
						name : f,
						relPath : tree.relPath.length == 0 ? f : tree.relPath + "/" + f,
						ident : makeIdent(f),
						dirs : new Map(),
						files : new Map()
					};
					tree.dirs.set(f, d);
				}
				scanRec(d, basePath);
			} else {
				var extParts = f.split(".");
				var noExt = extParts.shift();
				var ident = makeIdent(noExt);
				var ext = extParts.join(".").toLowerCase();
				if( Config.ignoredExtensions.exists(ext) )
					continue;
				// override previous file definition, if any
				if( tree.files.exists(f) )
					Context.warning(tree.files.get(f).fullPath + " is overridden by " + path, pos);
				tree.files.set(f, {
					relPath : tree.relPath.length == 0 ? f : tree.relPath + "/" + f,
					fullPath : path,
					file : f,
					ident : ident,
					noExt : noExt,
					ext : ext,
				});
			}
		}
	}

	public function embed(options:EmbedOptions) {
		if( options == null ) options = { };
		checkTmp = false;
		this.options = options;
		embedTypes = [];

		var tree = scan();
		for( path in paths ) {
			var fs = new hxd.fs.LocalFileSystem(path,options.configuration);
			fs.convert.onConvert = function(c) Sys.println("Converting " + c.srcPath);
			embedRec(tree, path, fs);
		}
		return { tree : tree, types : embedTypes };
	}

	function embedRec( tree : FileTreeData, basePath : String, fs : hxd.fs.LocalFileSystem ) {

		for( file in tree.files ) {
			// try later with another fs
			if( !StringTools.startsWith(file.fullPath, basePath) )
				continue;
			var name = "R_" + invalidChars.replace(file.relPath, "_");
			var f = try fs.get(file.relPath) catch( e : hxd.res.NotFound ) continue; // convert and filter
			var fullPath = fs.getAbsolutePath(f);

			switch( file.ext ) {
			case "ttf" if( Config.platform == JS || Config.platform == Flash ):
				Embed.doEmbedFont(name, fullPath, options.fontsChars);
				embedTypes.push("hxd._res." + name);
				continue;
			case _ if( Config.platform == Flash ):
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
			default:
				Context.addResource(name, sys.io.File.getBytes(fullPath));
			}
		}

		for( t in tree.dirs )
			embedRec(t, basePath, fs);
	}


	public function buildFields() {
		var fields = Context.getBuildFields();
		var dict = new Map();
		for( f in fields ) {
			if( Lambda.has(f.access,AStatic) ) {
				dict.set(f.name, "class declaration");
				if( f.name == "loader" )
					loaderType = switch( f.kind ) {
					case FVar(t, _), FProp(_, _, t, _): t;
					default: null;
					}
			}
		}
		if( loaderType == null ) {
			loaderType = macro : hxd.res.Loader;
			dict.set("loader", "reserved identifier");
			fields.push({
				name : "loader",
				access : [APublic, AStatic],
				kind : FProp("get","set",loaderType),
				pos : pos,
			});
			fields.push( {
				name : "get_loader",
				access : [AStatic],
				kind : FFun( {
					args : [],
					ret : loaderType,
					expr : macro {
						var l = hxd.res.Loader.currentInstance;
						if( l == null ) throw "Resource loader not initialized: call to hxd.Res.initXXX() required";
						return l;
					}
				}),
				pos : pos
			});
			fields.push( {
				name : "set_loader",
				access : [AStatic],
				kind : FFun( {
					args : [ { name : "l", type : loaderType } ],
					ret : loaderType,
					expr : macro {
						return hxd.res.Loader.currentInstance = l;
					}
				}),
				pos : pos
			});
		}

		ignoredPairedExt = new Map();
		for( e1 in Config.pairedExtensions.keys() ) {
			for( e2 in Config.pairedExtensions.get(e1).split(",") ) {
				var a = ignoredPairedExt.get(e2);
				if( a == null ) {
					a = [];
					ignoredPairedExt.set(e2, a);
				}
				a.push(e1);
			}
		}

		extensions = new Map();
		for( e in Config.extensions.keys() ) {
			var t = Config.extensions.get(e).split(".");
			var expr = { expr : EConst(CIdent(t[0])), pos : pos };
			for( i in 1...t.length )
				expr = { expr : EField(expr, t[i]), pos : pos };
			var ct : ComplexType = TPath({ pack : t, name : t.pop() });
			for( e in e.split(",") )
				extensions.set(e, { t : ct, e : expr });
		}

		buildFieldsRec(scan(), fields, dict);
		return fields;
	}

	function buildFieldsRec( tree : FileTreeData, fields : Array<Field>, fident : Map<String,String> ) {
		function addField( fname : String, field : FileEntry ) {
			var fget : Field = {
				name : "get_" + fname,
				pos : pos,
				kind : FFun({
					args : [],
					params : [],
					ret : field.t,
					expr : { expr : EMeta({ name : ":privateAccess", params : [], pos : pos }, { expr : EReturn(field.e), pos : pos }), pos : pos },
				}),
				meta : [ { name:":extern", pos:pos, params:[] } ],
				access : [AStatic, AInline, APrivate],
			};
			var field : Field = {
				name : fname,
				pos : pos,
				kind : FProp("get","never",field.t),
				access : [AStatic, APublic],
				doc: field.doc,
			};
			fields.push(field);
			fields.push(fget);
		}

		for( d in tree.dirs ) {
			if( d.name.indexOf(".") >= 0 )
				continue; // ignore directories containing a dot (only for ident generation)
			if( fident.exists(d.ident) ) {
				Context.warning("Directory " + d.relPath + " ignored because of " + fident.get(d.ident), pos);
				continue;
			}
			var f = buildDir(d);
			fident.set(d.ident, d.relPath);
			addField(d.ident, f);
		}

		// handle ignored pairs
		for( f in Lambda.array(tree.files) ) {

			var a = ignoredPairedExt.get(f.ext);
			if( a != null ) {
				var removed = false;
				for( f2 in tree.files )
					if( f2.noExt == f.noExt && a.indexOf(f2.ext) >= 0 ) {
						removed = true;
						break;
					}
				if( removed ) {
					tree.files.remove(f.file);
					continue;
				}
			}

			if( fident.exists(f.ident) )
				fident.set(f.ident, "");
			else
				fident.set(f.ident, f.relPath);
		}

		for( f in tree.files ) {
			// handle duplicates
			if( fident.get(f.ident) != f.relPath )
				f.ident += "_" + makeIdent(f.ext);
			var ftype = extensions.get(f.ext);
			if( ftype == null ) ftype = defaultExt;
			var epath = { expr : EConst(CString(f.relPath)), pos : pos };
			var doc = if ( f.ext == "png" || f.ext == "jpg" || f.ext == "jpeg" || f.ext == "gif" )
					'[${f.relPath}](file:///${f.fullPath})\n\n[![](file:///${f.fullPath})](file:///${f.fullPath})';
				else
					'[${f.relPath}](file:///${f.fullPath})';
			var field = { e : macro loader.loadCache($epath, ${ftype.e}), t : ftype.t, doc: doc };
			addField(f.ident, field);
		}

	}

	function buildDir( d : FileTreeData ) : FileEntry {
		var ofields = [];
		var dict = new Map();
		dict.set("loader", "reserved identifier");
		buildFieldsRec(d, ofields, dict);

		var name = makeIdent(d.relPath);
		name = "_" + name.charAt(0).toUpperCase() + name.substr(1);
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

	public static function build( ?dir : String ) {
		return new FileTree(dir).buildFields();
	}

}
#end