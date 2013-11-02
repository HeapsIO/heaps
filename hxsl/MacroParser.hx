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
			v.qualifiers.push(Const);
		case "Private":
			v.qualifiers.push(Private);
		default:
			error("Unsupported qualifier " + m.name, m.pos);
		}
	}
	
	public function parseType( t : ComplexType, pos : Position ) : Ast.Type {
		switch( t ) {
		case TPath( { pack : [], name : name, sub : null } ):
			switch( name ) {
			case "Float": return TFloat;
			case "Vec2": return TVec2;
			case "Vec3": return TVec3;
			case "Vec4": return TVec4;
			case "Mat4": return TMat4;
			case "Mat3": return TMat3;
			case "Mat3x4": return TMat3x4;
			case "String": return TString;
			}
		case TAnonymous(fl):
			return TUntypedStruct([for( f in fl ) {
				switch( f.kind ) {
				case FVar(t,e):
					var v : Ast.VarDecl = {
						name : f.name,
						type : t == null ? null : parseType(t, f.pos),
						qualifiers : [],
						kind : null,
						expr : e == null ? null : parseExpr(e),
					};
					for( m in f.meta )
						applyMeta(m,v);
					v;
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
				error("Qualifier only supported before 'var'", e.pos);
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
				EConst(CTrue);
			case CIdent("false"):
				EConst(CFalse);
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
		default:
			null;
		};
		if( ed == null )
			error("Unsupported expression", e.pos);
		return { expr : ed, pos : e.pos };
	}

}