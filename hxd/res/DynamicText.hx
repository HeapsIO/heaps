package hxd.res;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class DynamicText {

	public static function parse( data : String, ?dict : Map<String,String> ) : Dynamic {
		var x = new haxe.xml.Fast(Xml.parse(data).firstElement());
		var idict = null;
		if( dict != null ) {
			idict = new Map();
			for( f in dict.keys() )
				idict.set(dict.get(f), f);
		}
		var obj = {};
		for( e in x.elements )
			Reflect.setField(obj, getDict(dict,e.att.id), parseXmlData(e,dict,idict));
		return obj;
	}
	
	static inline function getDict( d : Map<String,String>, x : String ) {
		return d == null ? x : d.get(x);
	}
	
	static function parseXmlData( x : haxe.xml.Fast, hdict : Map<String,String>, idict : Map<String,String> ) : Dynamic {
		switch( x.name ) {
		case "g":
			var first = x.elements.next();
			// build structure
			if( first != null && first.has.id ) {
				var o = {};
				for( e in x.elements )
					Reflect.setField(o, getDict(hdict, e.att.id), parseXmlData(e, hdict, idict));
				return o;
			} else {
				var a = new Array<Dynamic>();
				var isArray = false;
				for( e in x.elements ) {
					var v : Dynamic = parseXmlData(e,hdict,idict);
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
			var str = x.innerHTML;
			if( str.split("::").length <= 1 )
				return str;
			return function(vars) {
				var str = str;
				for( f in Reflect.fields(vars) )
					str = str.split("::" + getDict(idict,f) + "::").join(Reflect.field(vars, f));
				return str;
			};
		default:
			throw "Unknown tag " + x.name;
		}
	}
	
	#if macro
	
	static function typeFromXml( x : haxe.xml.Fast, tdict : Map<String,Bool>, pos ) {
		switch( x.name ) {
		case "g":
			var first = x.elements.next();
			// build structure
			if( first != null && first.has.id ) {
				var fields = new Array<Field>();
				for( e in x.elements ) {
					tdict.set(e.att.id, true);
					fields.push( { name : e.att.id, kind : FVar(typeFromXml(e, tdict, pos)), pos : pos, meta : [] } );
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
			while( i < vars.length ) {
				tdict.set(vars[i], true);
				fields.push( { name : vars[i], kind : FVar(tstring), pos : pos, meta : [] } );
				i += 2;
			}
			return TFunction([TAnonymous(fields)], tstring);
		default:
			Context.error("Unknown node " + x.name, pos);
		}
		return null;
	}

	public static function build( file : String, ?withDict : Bool ) {
		var path = FileTree.resolvePath();
		var x = Xml.parse(sys.io.File.getContent(path + "/" + file));
		Context.registerModuleDependency(Context.getLocalModule(), path + "/" + file);
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var tdict = new Map();
		for( x in new haxe.xml.Fast(x.firstElement()).elements ) {
			var id = x.att.id;
			var t = typeFromXml(x, tdict, pos);
			tdict.set(id, true);
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
		var c : TypeDefinition;
		if( withDict ) {
			var fdict = [];
			for( name in tdict.keys() )
				fdict.push( { field : name, expr : macro $v { name } } );
			var edict = { expr : EObjectDecl(fdict), pos : pos };
			c = macro class {
				static var DATA : Dynamic = null;
				static var DICT = $edict;
				static var HDICT : Map<String,String> = null;
				public static function resolve( key : String ) : Dynamic {
					return Reflect.field(DATA, HDICT.get(key));
				}
				public static function load( data : String ) {
					if( HDICT == null ) {
						HDICT = new Map();
						for( f in Reflect.fields(DICT) )
							HDICT.set(Reflect.field(DICT, f), f);
					}
					DATA = hxd.res.DynamicText.parse(data,HDICT);
				}
			};
		} else {
			c = macro class {
				static var DATA : Dynamic = null;
				public static inline function resolve( key : String ) : Dynamic {
					return Reflect.field(DATA, key);
				}
				public static function load( data : String ) {
					DATA = hxd.res.DynamicText.parse(data);
				}
			};
		}
		for( f in c.fields )
			fields.push(f);
		return fields;
	}
	#end

}
