package hxsl;
import haxe.macro.Expr;
using haxe.macro.Tools;

class MacroParser {

	public function new() {
	}

	function error( msg : String, pos : Position ) : Dynamic {
		return Ast.Error.t(msg,pos);
	}

	function applyMeta( m : MetadataEntry, v : Ast.VarDecl ) {
		switch( m.params ) {
		case []:
			// fallthrough
		case [ { expr : EConst(CString(n)), pos : pos } ] if( m.name == "var" || m.name == "global" || m.name == "input" ):
			v.qualifiers.push(Name(n));
		case [ { expr : EConst(CInt(n)), pos : pos } ] if( m.name == "const" ):
			v.qualifiers.push(Const(Std.parseInt(n)));
			return;
		case [ { expr : EConst(CInt(a) | CFloat(a)) }, { expr : EConst(CInt(b) | CFloat(b)) } ] if( m.name == "range" ):
			v.qualifiers.push(Range(Std.parseFloat(a),Std.parseFloat(b)));
			return;
		case [ { expr : EConst(CInt(a)) } ] if( m.name == "perInstance" ):
			v.qualifiers.push(PerInstance(Std.parseInt(a)));
			return;
		case [ { expr: EConst(CString(s)), pos: pos } ] if (m.name == "doc"):
			v.qualifiers.push(Doc(s));
			return;
		case [ { expr: EConst(CString(s)) } ] if (m.name == "sampler"):
			v.qualifiers.push(Sampler(s));
			return;
		case [ e ] if (m.name == "borrow"):
			var path = [];
			function loop( e : Expr ) {
				switch( e.expr ) {
				case EConst(CIdent(s)): path.push(s);
				case EConst(CString(s)): path.push(s);
				case EField(e, f): loop(e); path.push(f);
				default:
					error("Should be a shader type path", e.pos);
				}
			}
			loop(e);
			v.qualifiers.push(Borrow(path.join(".")));
			return;
		default:
			error("Invalid meta parameter for "+m.name, m.pos);
		}
		switch( m.name ) {
		case "var":
			if( v.kind == null ) v.kind = Var else error("Duplicate type qualifier", m.pos);
		case "global":
			if( v.kind == null ) v.kind = Global else error("Duplicate type qualifier", m.pos);
		case "param":
			if( v.kind == null ) v.kind = Param else error("Duplicate type qualifier", m.pos);
		case "input":
			if( v.kind == null ) v.kind = Input else error("Duplicate type qualifier", m.pos);
		case "const":
			v.qualifiers.push(Const());
		case "private":
			v.qualifiers.push(Private);
		case "nullable":
			v.qualifiers.push(Nullable);
		case "perObject":
			v.qualifiers.push(PerObject);
		case "shared":
			v.qualifiers.push(Shared);
		case "lowp":
			v.qualifiers.push(Precision(Low));
		case "mediump":
			v.qualifiers.push(Precision(Medium));
		case "highp":
			v.qualifiers.push(Precision(High));
		case "ignore":
			v.qualifiers.push(Ignore);
		case "perInstance":
			v.qualifiers.push(PerInstance(1));
		default:
			error("Unsupported qualifier " + m.name, m.pos);
		}
	}

	function getTexDim( n : String, f : Ast.TexDimension -> Bool -> Ast.Type ) {
		var arr = false;
		if( StringTools.endsWith(n,"Array") ) {
			arr = true;
			n = n.substr(0,-5);
		}
		return switch( n ) {
		case "1D": f(T1D,arr);
		case "2D": f(T2D,arr);
		case "3D": f(T3D,arr);
		case "Cube": f(TCube,arr);
		default: null;
		}
	}

	public function parseType( t : ComplexType, pos : Position ) : Ast.Type {
		switch( t ) {
		case TPath( { pack : [], name : name, sub : null, params : [] } ):
			switch( name ) {
			case "Int": return TInt;
			case "Bool": return TBool;
			case "Float": return TFloat;
			case "Vec2": return TVec(2,VFloat);
			case "Vec3": return TVec(3,VFloat);
			case "Vec4": return TVec(4,VFloat);
			case "IVec2": return TVec(2,VInt);
			case "IVec3": return TVec(3,VInt);
			case "IVec4": return TVec(4,VInt);
			case "BVec2": return TVec(2,VBool);
			case "BVec3": return TVec(3,VBool);
			case "BVec4": return TVec(4,VBool);
			case "Mat4": return TMat4;
			case "Mat3": return TMat3;
			case "Mat3x4": return TMat3x4;
			case "Mat2": return TMat2;
			case "String": return TString;
			case "Bytes2": return TBytes(2);
			case "Bytes3": return TBytes(3);
			case "Bytes4": return TBytes(4);
			case "Channel": return TChannel(1);
			case "Channel2": return TChannel(2);
			case "Channel3": return TChannel(3);
			case "Channel4": return TChannel(4);
			case _ if( StringTools.startsWith(name,"Sampler") ):
				var t = getTexDim(name.substr(7), (d,arr) -> TSampler(d,arr));
				if( t != null ) return t;
			}
		case TPath( { pack : [], name : name, sub : null, params : pl } ) if( StringTools.startsWith(name,"RWTexture") ):
			var chans = switch( pl[0] ) {
			case TPType(TPath({ pack : [], name : n, sub : null, params : [] })):
				switch( n ) {
				case "Float": 1;
				case "Vec2": 2;
				case "Vec3": 3;
				case "Vec4": 4;
				default: 0;
				}
			case null, _: 0;
			}
			if( chans == 0 )
				error("Unsupported RWTexture parameter, should be Float|Vec2|Vec3|Vec4", pos);
			var t = getTexDim(name.substr(9), (dim,arr) -> TRWTexture(dim,arr,chans));
			if( t != null )
				return t;
		case TPath( { pack : [], name : name = ("StorageBuffer"|"RWBuffer"|"StoragePartialBuffer"|"RWPartialBuffer"), sub : null, params : [t] } ):
			var t = switch( t ) {
				case TPType(t): parseType(t, pos);
				default: null;
				}
			if( t != null )
				return switch( name ) {
				case "StorageBuffer" : TBuffer(t, SConst(0), Storage);
				case "RWBuffer": TBuffer(t,SConst(0),RW);
				case "StoragePartialBuffer" : TBuffer(t, SConst(0), StoragePartial);
				case "RWPartialBuffer": TBuffer(t,SConst(0),RWPartial);
				default: throw "assert";
				}
		case TPath( { pack : [], name : name = ("Array"|"Buffer"|"StorageBuffer"|"RWBuffer"|"PartialBuffer"|"StoragePartialBuffer"|"RWPartialBuffer"), sub : null, params : [t, size] } ):
			var t = switch( t ) {
			case TPType(t): parseType(t, pos);
			default: null;
			}
			var size : Ast.SizeDecl = switch( size ) {
			case TPExpr({ expr : EConst(CInt(v)) }): SConst(Std.parseInt(v));
			case TPType(TPath( { pack : pack, name : name, sub : null, params : [] } )):
				var pack = pack.copy();
				pack.push(name);
				SVar( { id : 0, type : null, name : pack.join("."), kind : null } );
			default: null;
			}
			if( t != null && size != null )
				return switch( name ) {
				case "Array": TArray(t, size);
				case "Buffer": TBuffer(t,size,Uniform);
				case "StorageBuffer": TBuffer(t,size,Storage);
				case "RWBuffer": TBuffer(t,size,RW);
				case "PartialBuffer": TBuffer(t,size,Partial);
				case "StoragePartialBuffer": TBuffer(t,size,StoragePartial);
				case "RWPartialBuffer": TBuffer(t,size,RWPartial);
				default: throw "assert";
				}
		case TAnonymous(fl):
			return TStruct([for( f in fl ) {
				switch( f.kind ) {
				case FVar(t,e):
					if( e != null ) error("No expression allowed in structure", e.pos);
					var v : Ast.VarDecl = {
						name : f.name,
						type : t == null ? null : parseType(t, f.pos),
						qualifiers : [],
						kind : null,
						expr : null,
					};
					for( m in f.meta )
						applyMeta(m,v);
					{ id : 0, name : v.name, type : v.type, kind : v.kind, qualifiers : v.qualifiers };
				default:
					error("Only variables are allowed in structures", f.pos);
				}
			}]);
		default:
		}
		error("Unsupported type " + t.toString(), pos);
		return null;
	}

	public function parseExpr( e : Expr ) : Ast.Expr {
		var ed : Ast.ExprDef = switch( e.expr ) {
		case EBlock(el):
			EBlock([for( e in el ) parseExpr(e)]);
		case EMeta(m, e):
			var e2 = parseExpr(e);
			switch( e2.expr ) {
			case EVars(vl):
				for( v in vl )
					applyMeta(m, v);
				e2.expr;
			default:
				switch( m.name ) {
				case ":extends":
					ECall({ expr : EIdent("extends"), pos : m.pos }, [e2]);
				case ":import":
					ECall({ expr : EIdent("import"), pos : m.pos }, [e2]);
				default:
					EMeta(m.name, [for( e in m.params ) parseExpr(e)], e2);
				}
			}
		case EVars(vl):
			EVars([for( v in vl ) {
				{
					name : v.name,
					expr : v.expr == null ? null : parseExpr(v.expr),
					type : v.type == null ? null : parseType(v.type, e.pos),
					kind : null,
					qualifiers : v.isFinal ? [Final] : [],
				}
			}]);
		case EFunction(FNamed(name,_),f) if( f.expr != null ):
			EFunction({
				name : name,
				ret : f.ret == null ? null : (switch( f.ret ) {
					case TPath( { pack:[], name:"Void", sub:null } ): TVoid;
					default: parseType(f.ret, e.pos);
				}),
				args : [for( a in f.args ) {
					{
						name : a.name,
						type : a.type == null ? null : parseType(a.type, e.pos),
						kind : Local,
						qualifiers : [],
						expr : a.value == null ? (a.opt ? { expr : EConst(CNull), pos : e.pos } : null) : parseExpr(a.value),
					}
				}],
				expr : parseExpr(f.expr),
			});
		case EBinop(op, e1, e2):
			EBinop(op, parseExpr(e1), parseExpr(e2));
		case EUnop(op, false, e1):
			EUnop(op, parseExpr(e1));
		case EUnop(op, true, e1):
			EUnop(op, parseExpr(e1)); // TODO : ++/-- postfix with lvalue
		case EConst(c):
			switch( c ) {
			case CString(s):
				EConst(CString(s));
			case CInt(v):
				EConst(CInt(Std.parseInt(v)));
			case CIdent("null"):
				EConst(CNull);
			case CIdent("true"):
				EConst(CBool(true));
			case CIdent("false"):
				EConst(CBool(false));
			case CIdent("discard"):
				EDiscard;
			case CIdent(s):
				EIdent(s);
			case CFloat(f):
				EConst(CFloat(Std.parseFloat(f)));
			case CRegexp(_):
				null;
			}
		case EField(e, f):
			EField(parseExpr(e), f);
		case ECall(e, args):
			ECall(parseExpr(e), [for( a in args ) parseExpr(a)]);
		case EParenthesis(e):
			EParenthesis(parseExpr(e));
		case EIf(cond, eif, eelse), ETernary(cond, eif, eelse):
			EIf(parseExpr(cond), parseExpr(eif), eelse == null ? null : parseExpr(eelse));
		case EFor({ expr : EBinop(OpIn,{ expr : EConst(CIdent(n)) }, eloop) },eblock):
			EFor(n, parseExpr(eloop), parseExpr(eblock));
		case EReturn(e):
			EReturn(e == null ? null : parseExpr(e));
		case EBreak:
			EBreak;
		case EContinue:
			EContinue;
		case EArray(e1, e2):
			EArray(parseExpr(e1), parseExpr(e2));
		case EArrayDecl(el):
			EArrayDecl([for( e in el ) parseExpr(e)]);
		case ESwitch(e, cases, def):
			ESwitch(parseExpr(e), [for( c in cases ) { expr : c.expr == null ? { expr : EBlock([]), pos : c.values[0].pos } : parseExpr(c.expr), values : [for( v in c.values ) parseExpr(v)] }], def == null ? null : parseExpr(def));
		case EWhile(cond, e, normalWhile):
			EWhile(parseExpr(cond), parseExpr(e), normalWhile);
		case EObjectDecl([]):
			EBlock([]);
		default:
			null;
		};
		if( ed == null )
			error("Unsupported expression", e.pos);
		return { expr : ed, pos : e.pos };
	}

}