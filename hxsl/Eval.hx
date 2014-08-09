package hxsl;

using hxsl.Ast;

/**
	Evaluator : will substitute some variables (usually constants) by their runtime value and will
	evaluate and reduce the expression, unroll loops, etc.
**/
class Eval {

	public var varMap : Map<TVar,TVar>;
	var constants : Map<TVar,TExprDef>;
	var funMap : Map<TVar,TFunction>;

	public function new() {
		varMap = new Map();
		funMap = new Map();
		constants = new Map();
	}

	public function setConstant( v : TVar, c : Const ) {
		constants.set(v, TConst(c));
	}

	function mapVar( v : TVar ) {
		var v2 = varMap.get(v);
		if( v2 != null )
			return v2;
		v2 = {
			id : Tools.allocVarId(),
			name : v.name,
			type : v.type,
			kind : v.kind,
		};
		if( v.parent != null ) v2.parent = mapVar(v.parent);
		if( v.qualifiers != null ) v2.qualifiers = v.qualifiers.copy();
		varMap.set(v, v2);
		varMap.set(v2, v2); // make it safe to have multiple eval
		switch( v2.type ) {
		case TStruct(vl):
			v2.type = TStruct([for( v in vl ) mapVar(v)]);
		case TArray(t, SVar(vs)):
			var c = constants.get(vs);
			if( c != null )
				switch( c ) {
				case TConst(CInt(v)):
					v2.type = TArray(t, SConst(v));
				default:
					Error.t("Integer value expected for array size constant " + vs.name, null);
				}
			else {
				var vs2 = mapVar(vs);
				v2.type = TArray(t, SVar(vs2));
			}
		default:
		}
		return v2;
	}

	public function eval( s : ShaderData ) : ShaderData {
		var funs = [];
		for( f in s.funs ) {
			var f2 : TFunction = {
				kind : f.kind,
				ref : mapVar(f.ref),
				args : [for( a in f.args ) mapVar(a)],
				ret : f.ret,
				expr : f.expr,
			};
			if( f.kind != Helper )
				funs.push(f2);
			funMap.set(f2.ref, f2);
		}
		for( i in 0...funs.length )
			funs[i].expr = evalExpr(funs[i].expr);
		return {
			name : s.name,
			vars : [for( v in s.vars ) mapVar(v)],
			funs : funs,
		};
	}

	var markReturn : Bool;

	function hasReturn( e : TExpr ) {
		markReturn = false;
		hasReturnLoop(e);
		return markReturn;
	}

	function hasReturnLoop( e : TExpr ) {
		switch( e.e ) {
		case TReturn(_):
			markReturn = true;
		default:
			if( !markReturn ) e.iter(hasReturnLoop);
		}
	}

	function handleReturn( e : TExpr, final : Bool = false ) : TExpr {
		switch( e.e ) {
		case TReturn(v):
			if( !final )
				Error.t("Cannot inline not final return", e.p);
			if( v == null )
				return { e : TBlock([]), t : TVoid, p : e.p };
			return handleReturn(v, true);
		case TBlock(el):
			var i = 0, last = el.length;
			var out = [];
			while( i < last ) {
				var e = el[i++];
				if( i == last )
					out.push(handleReturn(e, final));
				else switch( e.e ) {
				case TIf(econd, eif, null) if( final && hasReturn(eif) ):
					out.push(handleReturn( { e : TIf(econd, eif, { e : TBlock(el.slice(i)), t : e.t, p : e.p } ), t : e.t, p : e.p } ));
					break;
				default:
					out.push(handleReturn(e));
				}
			}
			var t = if( final ) out[out.length - 1].t else e.t;
			return { e : TBlock(out), t : t, p : e.p };
		case TParenthesis(v):
			var v = handleReturn(v, final);
			return { e : TParenthesis(v), t : v.t, p : e.p };
		case TIf(cond, eif, eelse) if( eelse != null && final ):
			var cond = handleReturn(cond);
			var eif = handleReturn(eif, final);
			return { e : TIf(cond, eif, handleReturn(eelse, final)), t : eif.t, p : e.p };
		default:
			return e.map(handleReturnDef);
		}
	}

	function handleReturnDef(e) {
		return handleReturn(e);
	}

	function evalCall( g : TGlobal, args : Array<TExpr> ) {
		return switch( [g,args] ) {
		case [ToFloat, [ { e : TConst(CInt(i)) } ]]: TConst(CFloat(i));
		default: null;
		}
	}

	function evalExpr( e : TExpr ) : TExpr {
		var d : TExprDef = switch( e.e ) {
		case TGlobal(_), TConst(_): e.e;
		case TVar(v):
			var c = constants.get(v);
			if( c != null )
				c;
			else
				TVar(mapVar(v));
		case TVarDecl(v, init):
			TVarDecl(mapVar(v), init == null ? null : evalExpr(init));
		case TArray(e1, e2):
			var e1 = evalExpr(e1);
			var e2 = evalExpr(e2);
			switch( [e1.e, e2.e] ) {
			case [TArrayDecl(el),TConst(CInt(i))] if( i >= 0 && i < el.length ):
				el[i].e;
			default:
				TArray(e1, e2);
			}
		case TSwiz(e, r):
			TSwiz(evalExpr(e), r.copy());
		case TReturn(e):
			TReturn(e == null ? null : evalExpr(e));
		case TCall(c, args):
			var c = evalExpr(c);
			var args = [for( a in args ) evalExpr(a)];
			switch( c.e ) {
			case TGlobal(g):
				var v = evalCall(g, args);
				if( v != null ) v else TCall(c, args);
			case TVar(v) if( funMap.exists(v) ):
				var f = funMap.get(v);
				var outExprs = [], undo = [];
				for( i in 0...f.args.length ) {
					var v = f.args[i];
					var e = args[i];
					switch( e.e ) {
					case TConst(_), TVar({ kind : (Input|Param|Global) }):
						var old = constants.get(v);
						undo.push(function() old == null ? constants.remove(v) : constants.set(v, old));
						constants.set(v, e.e);
					default:
						var old = varMap.get(v);
						if( old == null )
							undo.push(function() varMap.remove(v));
						else {
							varMap.remove(v);
							undo.push(function() varMap.set(v, old));
						}
						var v = mapVar(v);
						outExprs.push( { e : TVarDecl(v, e), t : TVoid, p : e.p } );
					}
				}
				var e = handleReturn(evalExpr(f.expr), true);
				for( u in undo ) u();
				switch( e.e ) {
				case TBlock(el):
					for( e in el )
						outExprs.push(e);
				default:
					outExprs.push(e);
				}
				TBlock(outExprs);
			default:
				Error.t("Cannot eval non-static call expresssion '" + new Printer().exprString(c)+"'", c.p);
			}
		case TBlock(el):
			var out = [];
			var last = el.length - 1;
			for( i in 0...el.length ) {
				var e = evalExpr(el[i]);
				switch( e.e ) {
				case TConst(_), TVar(_) if( i < last ):
				default:
					out.push(e);
				}
			}
			if( out.length == 1 )
				out[0].e
			else
				TBlock(out);
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
			inline function bop(callb:Bool->Bool->Bool,def) {
				return switch( [e1.e, e2.e] ) {
				case [TConst(CBool(a)), TConst(CBool(b))]:
					TConst(CBool(callb(a, b)));
				case [TConst(CBool(a)), _]:
					if( a == def )
						TConst(CBool(a));
					else
						e2.e;
				case [_, TConst(CBool(a))]:
					if( a == def )
						TConst(CBool(a)); // ignore e1 side effects ?
					else
						e1.e;
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
			case OpBoolAnd: bop(function(a, b) return a && b, false);
			case OpBoolOr: bop(function(a, b) return a || b, true);
			case OpEq: compare(function(x) return x == 0);
			case OpNotEq: compare(function(x) return x != 0);
			case OpGt: compare(function(x) return x > 0);
			case OpGte: compare(function(x) return x >= 0);
			case OpLt: compare(function(x) return x < 0);
			case OpLte: compare(function(x) return x <= 0);
			case OpInterval, OpAssign, OpAssignOp(_): TBinop(op, e1, e2);
			case OpArrow: throw "assert";
			}
		case TUnop(op, e):
			var e = evalExpr(e);
			switch( e.e ) {
			case TConst(c):
				switch( [op, c] ) {
				case [OpNot, CBool(b)]: TConst(CBool(!b));
				case [OpNeg, CInt(i)]: TConst(CInt( -i));
				case [OpNeg, CFloat(f)]: TConst(CFloat( -f));
				default:
					TUnop(op, e);
				}
			default:
				TUnop(op, e);
			}
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
		case TBreak:
			TBreak;
		case TContinue:
			TContinue;
		case TDiscard:
			TDiscard;
		case TFor(v, it, loop):
			var v2 = mapVar(v);
			var it = evalExpr(it);
			var e = switch( it.e ) {
			case TBinop(OpInterval, { e : TConst(CInt(start)) }, { e : TConst(CInt(len)) } ):
				var out = [];
				for( i in start...len ) {
					constants.set(v, TConst(CInt(i)));
					out.push(evalExpr(loop));
				}
				constants.remove(v);
				TBlock(out);
			default:
				TFor(v2, it, evalExpr(loop));
			}
			varMap.remove(v);
			e;
		case TArrayDecl(el):
			TArrayDecl([for( e in el ) evalExpr(e)]);
		};
		return { e : d, t : e.t, p : e.p }
	}

}