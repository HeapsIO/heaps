package hxsl;

using hxsl.Ast;

/**
	Evaluator : will substitute some variables (usually constants) by their runtime value and will
	evaluate and reduce the expression, unroll loops, etc.
**/
class Eval {

	public var varMap : Map<TVar,TVar>;
	public var inlineCalls : Bool;
	public var unrollLoops : Bool;
	public var eliminateConditionals : Bool;
	var constants : Map<Int,TExprDef>;
	var funMap : Map<TVar,TFunction>;
	var curFun : TFunction;

	public function new() {
		varMap = new Map();
		funMap = new Map();
		constants = new Map();
	}

	public function setConstant( v : TVar, c : Const ) {
		constants.set(v.id, TConst(c));
	}

	function mapVar( v : TVar ) {
		var v2 = varMap.get(v);
		if( v2 != null )
			return v == v2 ? v2 : mapVar(v2);

		if( v.parent != null ) {
			mapVar(v.parent); // always map parent first
			v2 = varMap.get(v);
			if( v2 != null )
				return v == v2 ? v2 : mapVar(v2);
		}

		v2 = {
			id : v.type.match(TChannel(_)) ? v.id : Tools.allocVarId(),
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
		case TArray(t, SVar(vs)), TBuffer(t, SVar(vs)):
			var c = constants.get(vs.id);
			if( c != null )
				switch( c ) {
				case TConst(CInt(v)):
					v2.type = v2.type.match(TArray(_)) ? TArray(t, SConst(v)) : TBuffer(t, SConst(v));
				default:
					Error.t("Integer value expected for array size constant " + vs.name, null);
				}
			else {
				var vs2 = mapVar(vs);
				v2.type = v2.type.match(TArray(_)) ? TArray(t, SVar(vs2)) : TBuffer(t, SVar(vs2));
			}
		default:
		}
		return v2;
	}

	function checkSamplerRec(t:Type) {
		if( t.isSampler() )
			return true;
		switch( t ) {
		case TStruct(vl):
			for( v in vl )
				if( checkSamplerRec(v.type) )
					return true;
			return false;
		case TArray(t, _):
			return checkSamplerRec(t);
		case TBuffer(_, size):
			return true;
		default:
		}
		return false;
	}

	function needsInline(f:TFunction) {
		for( a in f.args )
			if( checkSamplerRec(a.type) )
				return true;
		return false;
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
			if( (f.kind == Helper && inlineCalls) || needsInline(f2) )
				funMap.set(f2.ref, f);
			else
				funs.push(f2);
		}
		for( i in 0...funs.length ) {
			curFun = funs[i];
			curFun.expr = evalExpr(curFun.expr,false);
		}
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

	function handleReturn( e : TExpr, isFinal : Bool = false ) : TExpr {
		switch( e.e ) {
		case TReturn(v):
			if( !isFinal )
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
					out.push(handleReturn(e, isFinal));
				else switch( e.e ) {
				case TIf(econd, eif, null) if( isFinal && hasReturn(eif) ):
					out.push(handleReturn( { e : TIf(econd, eif, { e : TBlock(el.slice(i)), t : e.t, p : e.p } ), t : e.t, p : e.p } ));
					break;
				case TReturn(e):
					out.push(handleReturn(e, isFinal));
					break;
				default:
					out.push(handleReturn(e));
				}
			}
			var t = if( isFinal ) (out.length == 0 ? TVoid : out[out.length - 1].t) else e.t;
			return { e : TBlock(out), t : t, p : e.p };
		case TParenthesis(v):
			var v = handleReturn(v, isFinal);
			return { e : TParenthesis(v), t : v.t, p : e.p };
		case TIf(cond, eif, eelse) if( eelse != null && isFinal ):
			var cond = handleReturn(cond);
			var eif = handleReturn(eif, isFinal);
			return { e : TIf(cond, eif, handleReturn(eelse, isFinal)), t : eif.t, p : e.p };
		default:
			return e.map(handleReturnDef);
		}
	}

	function handleReturnDef(e) {
		return handleReturn(e);
	}

	function evalCall( g : TGlobal, args : Array<TExpr>, oldArgs : Array<TExpr>, pos : Position ) {
		return switch( [g,args] ) {
		case [ToFloat, [ { e : TConst(CInt(i)) } ]]: TConst(CFloat(i));
		case [Trace, args]:
			for( a in args )
				haxe.Log.trace(Printer.toString(a), { fileName : #if macro haxe.macro.Context.getPosInfos(a.p).file #else a.p.file #end, lineNumber : 0, className : null, methodName : null });
			TBlock([]);
		case [ChannelRead|ChannelReadLod, _]:
			var i = switch( args[0].e ) { case TConst(CInt(i)): i; default: Error.t("Cannot eval complex channel " + Printer.toString(args[0],true)+" "+constantsToString(), pos); throw "assert"; };
			var channel = oldArgs[0];
			channel = { e : switch( channel.e ) {
			case TVar(v): TVar(mapVar(v));
			default: throw "assert";
			}, t : channel.t, p : channel.p };
			var count = switch( channel.t ) { case TChannel(i): i; default: throw "assert"; };
			var channelMode = hxsl.Channel.createByIndex(i & 7);
			var targs = [channel];
			for( i in 1...args.length )
				targs.push(args[i]);
			targs.push({ e : TConst(CInt(i >> 3)), t : TInt, p : pos });
			var tget = {
				e : TCall({ e : TGlobal(g), t : TVoid, p : pos }, targs),
				t : TVoid,
				p : pos,
			};
			switch( channelMode ) {
			case R, G, B, A:
				return TSwiz(tget, switch( [count,channelMode] ) {
					case [1,R]: [X];
					case [1,G]: [Y];
					case [1,B]: [Z];
					case [1,A]: [W];
					case [2,R]: [X,Y];
					case [2,G]: [Y,Z];
					case [2,B]: [Z,W];
					case [3,R]: [X,Y,Z];
					case [3,G]: [Y,Z,W];
					default: throw "Invalid channel value "+channelMode+" for "+count+" channels";
				});
			case Unknown:
				var zero = { e : TConst(CFloat(0.)), t : TFloat, p : pos };
				if( count == 1 )
					return zero.e;
				return TCall({ e : TGlobal([Vec2, Vec3, Vec4][count - 2]), t : TVoid, p : pos }, [zero]);
			case PackedFloat:
				return TCall({ e : TGlobal(Unpack), t:TVoid, p:pos}, [tget]);
			case PackedNormal:
				return TCall({ e : TGlobal(UnpackNormal), t:TVoid, p:pos}, [tget]);
			}
		default: null;
		}
	}

	function constantsToString() {
		return [for( c in constants.keys() ) c + " => " + Printer.toString({ e : constants.get(c), t : TVoid, p : null }, true)].toString();
	}

	function ifBlock( e : TExpr ) {
		if( e == null || !e.e.match(TIf(_)) )
			return e;
		return { e : TBlock([e]), t : e.t, p : e.p };
	}

	function evalExpr( e : TExpr, isVal = true ) : TExpr {
		var d : TExprDef = switch( e.e ) {
		case TGlobal(_), TConst(_): e.e;
		case TVar(v):
			var c = constants.get(v.id);
			if( c != null )
				c;
			else {
				var v2 = mapVar(v);
				TVar(v2);
			}
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
		case TCall(c, eargs):
			var c = evalExpr(c);
			var args = [for( a in eargs ) evalExpr(a)];
			switch( c.e ) {
			case TGlobal(g):
				var v = evalCall(g, args, eargs, e.p);
				if( v != null ) v else TCall(c, args);
			case TVar(v) if( funMap.exists(v) ):
				// inline the function call
				var f = funMap.get(v);
				var outExprs = [], undo = [];
				for( i in 0...f.args.length ) {
					var v = f.args[i];
					var e = args[i];
					switch( e.e ) {
					case TConst(_), TVar({ kind : (Input|Param|Global) }):
						var old = constants.get(v.id);
						undo.push(function() old == null ? constants.remove(v.id) : constants.set(v.id, old));
						constants.set(v.id, e.e);
					default:
						var old = varMap.get(v);
						if( old == null )
							undo.push(function() varMap.remove(v));
						else {
							varMap.remove(v);
							undo.push(function() varMap.set(v, old));
						}
						var v2 = mapVar(v);
						outExprs.push( { e : TVarDecl(v2, e), t : TVoid, p : e.p } );
					}
				}
				var e = handleReturn(evalExpr(f.expr,false), true);
				for( u in undo ) u();
				switch( e.e ) {
				case TBlock(el):
					for( e in el )
						outExprs.push(e);
				default:
					outExprs.push(e);
				}
				TBlock(outExprs);
			case TVar(_):
				TCall(c, args);
			default:
				Error.t("Cannot eval non-static call expresssion '" + new Printer().exprString(c)+"'", c.p);
			}
		case TBlock(el):
			var out = [];
			var last = el.length - 1;
			for( i in 0...el.length ) {
				var isVal = isVal && i == last;
				var e = evalExpr(el[i], isVal);
				switch( e.e ) {
				case TConst(_), TVar(_) if( !isVal ):
				default:
					out.push(e);
				}
			}
			if( out.length == 1 && curFun.kind != Init )
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
			#if (haxe_ver >= 4)
			case OpIn: throw "assert";
			#end
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
			var e = evalExpr(e, isVal);
			switch( e.e ) {
			case TConst(_): e.e;
			default: TParenthesis(e);
			}
		case TIf(econd, eif, eelse):
			var econd = evalExpr(econd);
			switch( econd.e ) {
			case TConst(CBool(b)): b ? evalExpr(eif, isVal).e : eelse == null ? TConst(CNull) : evalExpr(eelse, isVal).e;
			default:
				if( isVal && eelse != null && eliminateConditionals )
					TCall( { e : TGlobal(Mix), t : e.t, p : e.p }, [evalExpr(eelse,true), evalExpr(eif,true), { e : TCall( { e : TGlobal(ToFloat), t : TFun([]), p : econd.p }, [econd]), t : TFloat, p : e.p } ]);
				else {
					eif = evalExpr(eif, isVal);
					if( eelse != null ) {
						eelse = evalExpr(eelse,isVal);
						if( eelse.e.match(TConst(CNull)) ) eelse = null;
					}
					eif = ifBlock(eif);
					eelse = ifBlock(eelse);
					TIf(econd, eif, eelse);
				}
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
			case TBinop(OpInterval, { e : TConst(CInt(start)) }, { e : TConst(CInt(len)) } ) if( unrollLoops ):
				var out = [];
				for( i in start...len ) {
					constants.set(v.id, TConst(CInt(i)));
					out.push(evalExpr(loop,false));
				}
				constants.remove(v.id);
				TBlock(out);
			default:
				TFor(v2, it, ifBlock(evalExpr(loop,false)));
			}
			varMap.remove(v);
			e;
		case TWhile(cond, loop, normalWhile):
			var cond = evalExpr(cond);
			var loop = evalExpr(loop, false);
			TWhile(cond, ifBlock(loop), normalWhile);
		case TSwitch(e, cases, def):
			var e = evalExpr(e);
			var cases = [for( c in cases ) { values : [for( v in c.values ) evalExpr(v)], expr : evalExpr(c.expr, isVal) }];
			var def = def == null ? null : evalExpr(def, isVal);
			var hasCase = false;
			switch( e.e ) {
			case TConst(c):
				switch( c ) {
				case CInt(val):
					for( c in cases ) {
						for( v in c.values )
							switch( v.e ) {
							case TConst(cst):
								switch( cst ) {
								case CInt(k) if( k == val ): return c.expr;
								case CFloat(k) if( k == val ): return c.expr;
								default:
								}
							default:
								hasCase = true;
							}
					}
				default:
					throw "Unsupported switch constant "+c;
				}
			default:
				hasCase = true;
			}
			if( hasCase )
				TSwitch(e, cases, def);
			else if( def == null )
				TBlock([]);
			else
				def.e;
		case TArrayDecl(el):
			TArrayDecl([for( e in el ) evalExpr(e)]);
		case TMeta(name, args, e):
			var e2;
			switch( name ) {
			case "unroll":
				var old = unrollLoops;
				unrollLoops = true;
				e2 = evalExpr(e, isVal);
				unrollLoops = false;
			default:
				e2 = evalExpr(e, isVal);
			}
			TMeta(name, args, e2);
		};
		return { e : d, t : e.t, p : e.p }
	}

}
