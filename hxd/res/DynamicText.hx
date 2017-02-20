package hxd.res;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class DynamicText {

	public static function parse( data : String ) : Dynamic {
		var x = new haxe.xml.Fast(Xml.parse(data).firstElement());
		var obj = {};
		for( e in x.elements )
			Reflect.setField(obj, e.att.id, parseXmlData(e));
		return obj;
	}

	public static function apply( obj : Dynamic, data : String, ?onMissing ) {
		var x = new haxe.xml.Fast(Xml.parse(data).firstElement());
		applyRec([], obj, x, onMissing);
	}

	static var r_attr = ~/::([A-Za-z0-9]+)::/g;

	static function applyText( path : Array<String>, old : Dynamic, str : String, onMissing ) {
		if( str == null ) {
			onMissing(path.join(".") + " is missing");
			return null;
		}
		var strOld : String = if( Reflect.isFunction(old) ) old({}) else old;
		var mparams = new Map();
		var ok = true;
		r_attr.map(strOld, function(r) { mparams.set(r.matched(1), true); return ""; });
		r_attr.map(str, function(r) {
			var p = r.matched(1);
			if( !mparams.exists(p) ) {
				onMissing(path.join(".") + " has extra param '" + p + "'");
				ok = false;
			}
			mparams.set(p, false);
			return "";
		});
		for( p in mparams.keys() )
			if( mparams.get(p) ) {
				onMissing(path.join(".") + " is missing param '" + p + "'");
				ok = false;
			}
		if( !ok )
			return null;
		return parseText(str);
	}

	public static function applyRec( path : Array<String>, obj : Dynamic, data : haxe.xml.Fast, onMissing ) {
		var fields = new Map();
		for( f in Reflect.fields(obj) ) fields.set(f, true);
		if( data != null )
		for( x in data.elements ) {
			switch( x.name ) {
			case "t":
				var id = x.att.id;
				path.push(id);
				var vnew = applyText(path, Reflect.field(obj, id), x.innerHTML, onMissing);
				if( vnew != null )
					Reflect.setField(obj, id, vnew);
				path.pop();
				fields.remove(id);
			case "g":
				var id = x.att.id;
				var sub : Dynamic = Reflect.field(obj, id);
				if( sub == null ) continue;
				var first = x.elements.next();
				// build structure
				path.push(id);
				if( first != null && first.has.id ) {
					applyRec(path, sub, x, onMissing);
				} else {
					var elements : Array<Dynamic> = sub;
					var data = [for( e in x.elements ) e];
					for( i in 0...elements.length ) {
						var e = elements[i];
						path.push("[" + i + "]");
						if( Std.is(e, Array) ) {
							trace("TODO");
						} else if( Std.is(e, String) ) {
							var enew = applyText(path, e, data[i] == null ? null : data[i].innerHTML, onMissing);
							if( enew != null )
								elements[i] = enew;
						} else {
							//trace(e);
							applyRec(path, elements[i], data[i], onMissing);
						}
						path.pop();
					}
				}
				path.pop();
				fields.remove(id);
			}
		}
		for( f in fields.keys() ) {
			path.push(f);
			onMissing(path.join(".") +" is missing");
			path.pop();
		}
	}

	static function parseXmlData( x : haxe.xml.Fast ) : Dynamic {
		switch( x.name ) {
		case "g":
			var first = x.elements.next();
			// build structure
			if( first != null && first.has.id ) {
				var o = {};
				for( e in x.elements )
					Reflect.setField(o, e.att.id, parseXmlData(e));
				return o;
			} else {
				var a = new Array<Dynamic>();
				var isArray = false;
				for( e in x.elements ) {
					var v : Dynamic = parseXmlData(e);
					if( isArray ) {
						if( !Std.is(v, Array) ) v = [v];
					} else {
						if( Std.is(v, Array) ) {
							for( i in 0...a.length ) {
								var v = a[i];
								if( !Std.is(v, Array) )
									a[i] = [v];
							}
							isArray = true;
						}
					}
					a.push(v);
				}
				return a;
			}
		case "t":
			return parseText(x.innerHTML);
		default:
			throw "Unknown tag " + x.name;
		}
	}

	static function parseText( str : String ) : Dynamic {
		if( str.split("::").length <= 1 )
			return str;
		return function(vars) {
			var str = str;
			for( f in Reflect.fields(vars) )
				str = str.split("::" + f + "::").join(Reflect.field(vars, f));
			return str;
		};
	}

	#if macro

	static function findPos( pos : { file : String, content : String }, str : String ) {
		// this might lead to false positive in case the same id is used several times
		// but until we have a Xml parser with original position info that's the best we have
		var index = pos.content.indexOf(str);
		if( index < 0 )
			return Context.makePosition({ min : 0, max : 0, file : pos.file });
		return Context.makePosition({ min : index, max : index + str.length, file : pos.file });
	}

	static function typeFromXml( x : haxe.xml.Fast, pos : { file : String, content : String, pos : Position } ) {
		switch( x.name ) {
		case "g":
			var first = x.elements.next();
			// build structure
			if( first != null && first.has.id ) {
				var fields = new Array<Field>();
				for( e in x.elements ) {
					var id = e.att.id;
					fields.push( { name : id, kind : FProp("default","never",typeFromXml(e, pos)), pos : findPos(pos, 'id="${id.toLowerCase()}"'), meta : [] } );
				}
				return TAnonymous(fields);
			} else {
				for( e in x.elements )
					if( e.name == "g" )
						return macro : Array<Array<String>>;
			}
			return macro : Array<String>;
		case "t":
			var tstring = macro : String;
			var vars = x.innerHTML.split("::");
			if( vars.length <= 1 )
				return tstring;
			// printer function
			var i = 1;
			var fields = new Array<Field>();
			var map = new Map();
			while( i < vars.length ) {
				var name = vars[i];
				if( map.exists(name) ) {
					i += 2;
					continue;
				}
				map.set(name, true);
				fields.push( { name : name, kind : FVar(macro : Dynamic), pos : pos.pos, meta : [] } );
				i += 2;
			}
			return TFunction([TAnonymous(fields)], tstring);
		default:
			Context.error("Unknown node " + x.name, findPos(pos,'<${x.name.toLowerCase()}'));
		}
		return null;
	}

	public static function build( file : String ) {
		var path = FileTree.resolvePath();
		var fullPath = path + "/" + file;
		var content = null, x = null;
		try {
			content = sys.io.File.getContent(fullPath);
			x = Xml.parse(content);
		} catch( e : haxe.xml.Parser.XmlParserException ) {
			Context.error(e.message, Context.makePosition({min:e.position, max:e.position, file:fullPath}));
			return null;
		}
		Context.registerModuleDependency(Context.getLocalModule(), fullPath);
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var fpos = { file : fullPath, content : content.toLowerCase(), pos : pos };
		for( x in new haxe.xml.Fast(x.firstElement()).elements ) {
			var id = x.att.id;
			var t = typeFromXml(x, fpos);
			fields.push( {
				name : id,
				doc : null,
				meta : [],
				kind : FProp("get", "never", t),
				access : [APublic, AStatic],
				pos : pos,
			});
			fields.push( {
				name : "get_"+id,
				doc : null,
				meta : [],
				kind : FFun( {
					ret : t,
					args : [],
					params : [],
					expr : { expr : EReturn({ expr : EField({ expr : EConst(CIdent("DATA")), pos : pos },id), pos : pos }), pos : pos },
				}),
				access : [AInline, AStatic],
				pos : pos,
			});
		}
		var c = macro class {
			static var DATA : Dynamic = null;
			public static inline function resolve( key : String ) : Dynamic {
				return Reflect.field(DATA, key);
			}
			public static function load( data : String ) {
				DATA = hxd.res.DynamicText.parse(data);
			}
			public static function applyLang( data : String, ?onMissing ) {
				if( onMissing == null ) onMissing = function(msg) trace(msg);
				hxd.res.DynamicText.apply(DATA,data,onMissing);
			}
		};
		for( f in c.fields )
			fields.push(f);
		return fields;
	}
	#end

}
