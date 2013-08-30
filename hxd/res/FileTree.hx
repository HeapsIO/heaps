package hxd.res;
import haxe.macro.Context;
import haxe.macro.Expr;

typedef FileEntry = { e : Expr, t : ComplexType, ?d : Dynamic };

class FileTree {
	
	var path : String;
	var currentModule : String;
	var pos : Position;
	var loaderType : ComplexType;
	
	function new(dir) {
		this.path = resolvePath(dir);
		currentModule = Std.string(Context.getLocalClass());
		pos = Context.currentPos();
	}
	
	function resolvePath(dir:Null<String>) {
		var resolve = true;
		if( dir == null ) {
			dir = Context.definedValue("resourcesPath");
			if( dir == null ) dir = "res" else resolve = false;
		}
		var pos = Context.currentPos();
		if( resolve )
			dir = try Context.resolvePath(dir) catch( e : Dynamic ) Context.error("Resource directory not found in classpath '" + dir + "'", pos);
		var path = sys.FileSystem.fullPath(dir);
		if( !sys.FileSystem.exists(path) || !sys.FileSystem.isDirectory(path) )
			Context.error("Resource directory does not exists '" + path + "'", pos);
		return path;
	}
	
	function scan() {
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
				kind : FVar(loaderType),
				pos : pos,
			});
		}
		var data = scanRec("", fields, dict);
		
		fields.push({
			name : "_ROOT",
			access : [AStatic],
			kind : FVar(null, { expr : EConst(CString(haxe.Serializer.run(data))), pos : pos } ),
			pos : pos,
		});
		
		return fields;
	}
	
	function scanRec( relPath : String, fields : Array<Field>, dict : Map<String,String> ) {
		var dir = this.path + relPath;
		var data = { };
		// make sure to rescan if one of the directories content has changed (file added or deleted)
		Context.registerModuleDependency(currentModule, dir);
		for( f in sys.FileSystem.readDirectory(dir) ) {
			var path = dir + "/" + f;
			var fileName = f;
			var field = null;
			var ext = null;
			if( sys.FileSystem.isDirectory(path) ) {
				switch( f ) {
				case ".svn", ".git":
					// don't look into these
				default:
					field = handleDir(f, relPath+"/"+f, path);
				}
			} else {
				var extParts = f.split(".");
				var noExt = extParts.shift();
				ext = extParts.join(".");
				field = handleFile(f, ext, relPath + "/" + f, path);
				f = noExt;
			}
			if( field != null ) {
				var other = dict.get(f);
				if( other != null ) {
					Context.warning("Resource " + relPath + "/" + f + " is used by both " + relPath + "/" + fileName + " and " + other, pos);
					continue;
				}
				dict.set(f, relPath + "/" + fileName);
				fields.push({
					name : f,
					pos : pos,
					kind : FProp("get","never",field.t),
					access : [AStatic, APublic],
				});
				fields.push({
					name : "get_" + f,
					pos : pos,
					kind : FFun({
						args : [],
						params : [],
						ret : field.t,
						expr : { expr : EMeta({ name : ":privateAccess", params : [], pos : pos }, { expr : EReturn(field.e), pos : pos }), pos : pos },
					}),
					meta : [ { name:":extern", pos:pos, params:[] } ],
					access : [AStatic, AInline],
				});
				if( field.d == null && ext != null )
					field.d = ext;
				else if( ext != null )
					field.d._e = ext;
				Reflect.setField(data, f, field.d);
			}
		}
		return data;
	}
	
	function handleDir( dir : String, relPath : String, fullPath : String ) : FileEntry {
		var ofields = [];
		var dict = new Map();
		dict.set("loader", "reserved identifier");
		var data = scanRec(relPath, ofields, dict);
		if( ofields.length == 0 )
			return null;
		var name = "R" + (~/[^A-Za-z0-9_]/g.replace(fullPath, "_"));
		for( f in ofields )
			f.access.remove(AStatic);
		var def = macro class {
			public inline function new(loader) this = loader;
			var loader(get,never) : $loaderType;
			inline function get_loader() : $loaderType return this;
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
			d : data,
		};
	}
	
	function handleFile( file : String, ext : String, relPath : String, fullPath : String ) : FileEntry {
		var epath = { expr : EConst(CString(relPath)), pos : pos };
		switch( ext.toLowerCase() ) {
		case "jpg", "png":
			return { e : macro loader.loadTexture($epath), t : macro : hxd.res.Texture };
		case "fbx", "xbx":
			return { e : macro loader.loadModel($epath), t : macro : hxd.res.Model };
		case "ttf":
			return { e : macro loader.loadFont($epath), t : macro : hxd.res.Font };
		case "wav", "mp3":
			return { e : macro loader.loadSound($epath), t : macro : hxd.res.Sound };
		default:
			Context.warning("File extension not supported '." + ext + "'", Context.makePosition( { min : 0, max : 0, file : fullPath } ));
		}
		return null;
	}
	
	public static function build( ?dir : String ) {
		return new FileTree(dir).scan();
	}
	
}