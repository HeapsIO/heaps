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
		case [ { expr : EConst(CString(n)), pos : pos } ] if( m.name == "var" || m.name == "global" || m.name == "input" ):
			v.qualifiers.push(Name(n));
		case [ { expr : EConst(CInt(n)), pos : pos } ] if( m.name == "const" ):
			v.qualifiers.push(Const(Std.parseInt(n)));
			return;
		default:
			error("Invalid meta parameter", m.pos);
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
		default:
			error("Unsupported qualifier " + m.name, m.pos);
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
			case "String": return TString;
			case "Sampler2D": return TSampler2D;
			case "SamplerCube": return TSamplerCube;
			case "Bytes2": return TBytes(2);
			case "Bytes3": return TBytes(3);
			case "Bytes4": return TBytes(4);
			}
		case TPath( { pack : [], name : "Array", sub : null, params : [t, size] } ):
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
				return TArray(t, size);
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
					error("Qualifier only supported before 'var'", e.pos);
				}
			}
		case EVars(vl):
			EVars([for( v in vl ) {
				{
					name : v.name,
					expr : v.expr == null ? null : parseExpr(v.expr),
					type : v.type == null ? null : parseType(v.type, e.pos),
					kind : null,
					qualifiers : [],
				}
			}]);
		case EFunction(name, f) if( name != null && f.expr != null ):
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
		case EFor( { expr : EIn( { expr : EConst(CIdent(n)) }, eloop) }, eblock):
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
		default:
			null;
		};
		if( ed == null )
			error("Unsupported expression", e.pos);
		return { expr : ed, pos : e.pos };
	}

}