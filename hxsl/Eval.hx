package hxsl;

using hxsl.Ast;

/**
	Evaluator : will substitute some variables (usually constants) by their runtime value and will
	evaluate and reduce the expression, unroll loops, etc.
**/
class Eval {
	
	public var inlineFunctions : Bool;
	public var unrollLoops : Bool;
	
	var constants : Map<TVar,Const>;
	var varMap : Map<TVar,TVar>;
	var funMap : Map<TFunction,TFunction>;
	
	public function new() {
		varMap = new Map();
		funMap = new Map();
		constants = new Map();
	}
	
	public function setConstant( v : TVar, c : Const ) {
		constants.set(v, c);
	}
	
	function mapVar( v : TVar ) {
		var v2 = varMap.get(v);
		if( v2 != null )
			return v2;
		v2 = {
			name : v.name,
			type : v.type,
			kind : v.kind,
		};
		if( v.parent != null ) v2.parent = mapVar(v.parent);
		if( v.qualifiers != null ) v2.qualifiers = v.qualifiers.copy();
		varMap.set(v, v2);
		switch( v2.type ) {
		case TStruct(vl):
			v2.type = TStruct([for( v in vl ) mapVar(v)]);
		case TArray(t, SVar(vs)):
			var c = constants.get(vs);
			if( c != null )
				switch( c ) {
				case CInt(v):
					v2.type = TArray(t, SConst(v));
				default:
				}
		default:
		}
		return v2;
	}
	
	public function eval( s : ShaderData ) : ShaderData {
		var funs = [];
		for( f in s.funs ) {
			var f2 : TFunction = {
				args : [for( a in f.args ) mapVar(a)],
				ret : f.ret,
				name : f.name,
				expr : null,
			};
			funs.push(f2);
			funMap.set(f, f2);
		}
		for( i in 0...funs.length )
			funs[i].expr = evalExpr(s.funs[i].expr);
		return {
			vars : [for( v in s.vars ) mapVar(v)],
			funs : funs,
		};
	}
	
	function evalExpr( e : TExpr ) : TExpr {
		var d : TExprDef = switch( e.e ) {
		case TGlobal(_), TConst(_): e.e;
		case TVar(v):
			var c = constants.get(v);
			if( c != null )
				TConst(c);
			else
				TVar(mapVar(v));
		case TVarDecl(v, init):
			TVarDecl(mapVar(v), init == null ? null : evalExpr(init));
		case TArray(e1, e2):
			TArray(evalExpr(e1), evalExpr(e2));
		case TSwiz(e, r):
			TSwiz(evalExpr(e), r.copy());
		case TReturn(e):
			TReturn(e == null ? null : evalExpr(e));
		case TCall(e, args):
			TCall(evalExpr(e), [for( a in args ) evalExpr(a)]);
		case TBlock(el):
			TBlock([for( e in el ) evalExpr(e)]);
		case TBinop(op, e1, e2):
			var e1 = evalExpr(e1);
			var e2 = evalExpr(e2);
			inline function fop(callb:Float->Float->Float) {
				return switch( [e1.e, e2.e] ) {
				case [TConst(CInt(a)), TConst(CInt(b))]:
					TConst(CInt(Std.int(callb(a, b))));
				case [TConst(CFloat(a)), TConst(CFloat(b))]:
					TConst(CFloat(callb(a, b)));
				default:
					TBinop(op, e1, e2);
				}
			}
			inline function iop(callb:Int->Int->Int) {
				return switch( [e1.e, e2.e] ) {
				case [TConst(CInt(a)), TConst(CInt(b))]:
					TConst(CInt(callb(a, b)));
				default:
					TBinop(op, e1, e2);
				}
			}
			inline function bop(callb:Bool->Bool->Bool) {
				return switch( [e1.e, e2.e] ) {
				case [TConst(CBool(a)), TConst(CBool(b))]:
					TConst(CBool(callb(a, b)));
				default:
					TBinop(op, e1, e2);
				}
			}
			inline function compare(callb:Int->Bool) {
				return switch( [e1.e, e2.e] ) {
				case [TConst(CNull), TConst(CNull)]:
					TConst(CBool(callb(0)));
				case [TConst(_), TConst(CNull)]:
					TConst(CBool(callb(1)));
				case [TConst(CNull), TConst(_)]:
					TConst(CBool(callb(-1)));
				case [TConst(CBool(a)), TConst(CBool(b))]:
					TConst(CBool(callb(a == b ? 0 : 1)));
				case [TConst(CInt(a)), TConst(CInt(b))]:
					TConst(CBool(callb(a - b)));
				case [TConst(CFloat(a)), TConst(CFloat(b))]:
					TConst(CBool(callb(a > b ? 1 : (a == b) ? 0 : -1)));
				case [TConst(CString(a)), TConst(CString(b))]:
					TConst(CBool(callb(a > b ? 1 : (a == b) ? 0 : -1)));
				default:
					TBinop(op, e1, e2);
				}
			}
			switch( op ) {
			case OpAdd: fop(function(a, b) return a + b);
			case OpSub: fop(function(a, b) return a - b);
			case OpMult: fop(function(a, b) return a * b);
			case OpDiv: fop(function(a, b) return a / b);
			case OpMod: fop(function(a, b) return a % b);
			case OpXor: iop(function(a, b) return a ^ b);
			case OpOr: iop(function(a, b) return a | b);
			case OpAnd: iop(function(a, b) return a & b);
			case OpShr: iop(function(a, b) return a >> b);
			case OpUShr: iop(function(a, b) return a >>> b);
			case OpShl: iop(function(a, b) return a << b);
			case OpBoolAnd: bop(function(a, b) return a && b);
			case OpBoolOr: bop(function(a, b) return a || b);
			case OpEq: compare(function(x) return x == 0);
			case OpNotEq: compare(function(x) return x != 0);
			case OpGt: compare(function(x) return x > 0);
			case OpGte: compare(function(x) return x >= 0);
			case OpLt: compare(function(x) return x < 0);
			case OpLte: compare(function(x) return x <= 0);
			case OpArrow, OpInterval: throw "assert";
			case OpAssign, OpAssignOp(_): TBinop(op, e1, e2);
			}
		case TUnop(op, e):
			var e = evalExpr(e);
			// todo : calc
			TUnop(op, e);
		case TParenthesis(e):
			var e = evalExpr(e);
			switch( e.e ) {
			case TConst(_): e.e;
			default: TParenthesis(e);
			}
		case TIf(econd, eif, eelse):
			var e = evalExpr(econd);
			switch( e.e ) {
			case TConst(CBool(b)): return b ? evalExpr(eif) : eelse == null ? { e : TConst(CNull), t : TVoid, p : e.p } : evalExpr(eelse);
			default:
				TIf(e, evalExpr(eif), eelse == null ? null : evalExpr(eelse));
			}
		case TFunVar(f):
			TFunVar(funMap.get(f));
		case TBreak:
			TBreak;
		case TContinue:
			TContinue;
		case TDiscard:
			TDiscard;
		case TFor(v, it, loop):
			TFor(mapVar(v), evalExpr(it), evalExpr(loop));
		};
		return { e : d, t : e.t, p : e.p }
	}
	
}