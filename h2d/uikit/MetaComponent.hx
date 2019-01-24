package h2d.uikit;
import haxe.macro.Type;
import haxe.macro.Expr;
using haxe.macro.TypeTools;

class MetaError {
	public var message : String;
	public var position : Position;
	public function new(msg,pos) {
		this.message = msg;
		this.position = pos;
	}
}

class MetaComponent extends Component<Dynamic> {

	public var baseType : ComplexType;
	public var parserType : ComplexType;
	var parser : h2d.uikit.CssValue.ValueParser;
	var classType : ClassType;

	public function new( t : Type ) {
		classType = switch( t ) {
		case TInst(c, _): c.get();
		default: error("Invalid type",haxe.macro.Context.currentPos());
		}

		var c = classType;
		var name = getCompName(c);
		if( name == null ) error("Missing :uiComp", c.pos);

		var fields = [];
		var ccur = c;
		var metaParent = null;
		while( true ) {
			var fl = ccur.fields.get();
			fields = fields.concat(fl);
			if( ccur.superClass == null ) break;
			var csup = ccur.superClass.t.get();
			var cname = getCompName(csup);
			if( cname != null ) {
				metaParent = Component.get(cname);
				if( metaParent == null ) error("Missing super component registration "+cname, c.pos);
				break;
			}
			ccur = csup;
		}
		super(name,null,metaParent);

		initParser(c);
		if( name == "object" ) {
			addHandler("class", parser.parseArray.bind(parser.parseIdent), null, null);
			addHandler("id", parser.parseIdent, null, null);
		}

		var baseT = t;
		for( i in c.interfaces )
			if( i.t.toString() == "h2d.uikit.ComponentDecl" )
				baseT = i.params[0];
		baseType = baseT.toComplexType();

		for( f in fields ) {
			if( !f.meta.has(":p") ) continue;
			defineField(f);
		}
	}

	function initParser( c : ClassType ) {
		var pdef = c.meta.extract(":parser")[0];
		if( pdef == null ) {
			if( parent != null ) {
				var parent = cast(parent,MetaComponent);
				parserType = parent.parserType;
				parser = parent.parser;
			} else {
				parserType = macro : h2d.uikit.CssValue.ValueParser;
				parser = new h2d.uikit.CssValue.ValueParser();
			}
			return;
		}
		if( pdef.params.length == 0 )
			error("Invalid parser definition", pdef.pos);
		var e = pdef.params[0];
		var path = [];
		while( true ) {
			switch( e.expr ) {
			case EField(e2, field):
				path.unshift(field);
				e = e2;
			case EConst(CIdent(i)):
				path.unshift(i);
				break;
			default:
				error("Invalid parser definition", e.pos);
			}
		}
		var name = path.pop();
		inline function isUpper(str:String) return str.charCodeAt(0) >= 'A'.code && str.charCodeAt(0) <= 'Z'.code;
		var subType = path.length > 0 && isUpper(path[path.length - 1]) ? path.pop() : null;
		parserType = TPath({ pack : path, name : subType == null ? name : subType, sub : subType == null ? null : name });

		var clPath = path.length == 0 ? name : path.join(".")+"."+name;
		var cl = std.Type.resolveClass(clPath);
		if( cl == null )
			error("Class "+clPath+" has not been compiled in macros", pdef.pos);
		parser = std.Type.createInstance(cl,[]);
	}

	function defineField( f : ClassField ) {
		var pm = f.meta.extract(":p")[0];
		var t = f.type.follow();
		var parser = null;
		var def = null;

		if( pm.params.length > 0 )
			switch( pm.params[0].expr ) {
			case EConst(CIdent(name)):
				var fname = "parse"+name.charAt(0).toUpperCase()+name.substr(1);
				var meth = Reflect.field(this.parser,fname);
				if( meth == null )
					error("Unknown parser "+name, pm.params[0].pos);
				parser = function(css:CssValue) : Dynamic {
					return Reflect.callMethod(this.parser,meth,[css]);
				};
			default:
			}

		if( parser == null )
			parser = parserFromType(t, f.pos);

		switch( f.expr() ) {
		case null:
		case { expr : TConst(c), pos : pos }:
			def = { expr : EConst(switch( c ) {
				case TString(s): CString(s);
				case TInt(i): CInt(""+i);
				case TFloat(f): CFloat(f);
				case TNull: CIdent("null");
				case TBool(b): CIdent(b?"true":"false");
				default: error("Unsupported constant", pos);
			}), pos : pos };
		case { expr : TField(_,FEnum(en,ef)), pos : pos }:
			def = { expr : EConst(CIdent(ef.name)), pos : pos };
		default:
			error("Invalid default expr", f.pos);
		}
		addHandler(f.name.split("_").join("-"), parser, def, t.toComplexType());
	}

	function parserFromType( t : Type, pos : Position ) : CssValue -> Dynamic {
		switch( t ) {
		case TAbstract(a,_):
			switch( a.toString() ) {
			case "Int": return parser.parseInt;
			case "Float": return parser.parseFloat;
			case "Bool": return parser.parseBool;
			default:
			}
		case TEnum(en,_):
			var idents = [for( n in en.get().names ) n.toLowerCase()];
			return function(css:CssValue) {
				return switch( css ) {
				case VIdent(i) if( idents.indexOf(i) >= 0 ): true;
				case VIdent(v): parser.invalidProp(v+" should be "+idents.join("|"));
				default: parser.invalidProp();
				}
			};
		default:
		}
		return error("Unsupported type "+t.toString()+", use custom parser", pos);
	}

	function getCompName( c : ClassType ) {
		var name = c.meta.extract(":uiComp")[0];
		if( name == null ) return null;
		if( name.params.length == 0 ) error("Invalid :uiComp", name.pos);
		return switch( name.params[0].expr ) {
		case EConst(CString(name)): name;
		default: error("Invalid :uiComp", name.pos);
		}
	}

	function error( msg : String, pos : Position ) : Dynamic {
		throw new MetaError(msg, pos);
	}

	static function runtimeName( name : String ) {
		return "Comp"+name.charAt(0).toUpperCase()+name.substr(1);
	}

	public function buildRuntimeComponent() {
		var cname = runtimeName(name);
		var hasCreateMethod = false;
		var parentExpr;
		if( parent == null )
			parentExpr = macro null;
		else {
			var parentName = runtimeName(parent.name);
			parentExpr = macro @:privateAccess h2d.uikit.$parentName.inst;
		}
		var path;

		for( f in classType.statics.get() )
			if( f.name == "create" && f.kind.match(FMethod(_)) )
				hasCreateMethod = true;

		if( hasCreateMethod ) {
			path = classType.module.split(".").concat([classType.name,"create"]);
		} else
			path = switch( baseType ) {
			case TPath(p): p.pack.concat([p.name, "new"]);
			default: throw "assert";
			}

		var newExpr = haxe.macro.MacroStringTools.toFieldExpr(path);
		var fields = (macro class {
			function new() {
				super($v{this.name},@:privateAccess $newExpr,$parentExpr);
			}
			static var inst = new h2d.uikit.$cname();
		}).fields;
		var td : TypeDefinition = {
			pos : classType.pos,
			pack : ["h2d","uikit"],
			name : cname,
			kind : TDClass({ pack : ["h2d","uikit"], name : "Component", params : [TPType(baseType)] }),
			fields : fields,
		};
		return td;
	}

	public function getRuntimeComponentType() {
		var name = runtimeName(name);
		return macro : h2d.uikit.$name;
	}

}