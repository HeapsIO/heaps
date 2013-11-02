package hxsl;

using hxsl.Ast;

enum WithType {
	NoValue;
	Value;
	With( t : Type );
}

class Checker {
	
	var vars : Map<String,TVar>;
	var globals : Map<String,{ g : TGlobal, t : Type }>;
	var functions : Map<String,TFunction>;
	var toRename : Array<{ v : TVar, name : String }>;
	var curFun : TFunction;

	public function new() {
		globals = new Map();
		inline function g(gl:TGlobal, vars) {
			globals.set(gl.toString(), { t : TFun(vars), g : gl } );
		}
		g(Vec4, []);
		g(Vec3, []);
		g(Vec2, []);
		g(Mat3, [
			{ args : [{ name : "matrix", type : TMat4 }], ret : TMat3 },
			{ args : [ { name : "matrix", type : TMat3x4 } ], ret : TMat3 },
		]);
		g(Mat3x4, [
			{ args : [{ name : "matrix", type : TMat4 }], ret : TMat3x4 },
		]);
	}
	
	function error( msg : String, pos : Position ) : Dynamic {
		return Ast.Error.t(msg,pos);
	}

	public function check( shader : Expr ) : Shader {
		vars = new Map();
		functions = new Map();
		toRename = [];

		var funs = [];
		checkExpr(shader, funs);
		var tfuns = [];
		for( f in funs ) {
			var pos = f.p, f = f.f;
			var args : Array<TVar> = [for( a in f.args ) {
				if( a.type == null ) error("Argument type required", pos);
				if( a.expr != null ) error("Optional argument not supported", pos);
				if( a.kind == null ) a.kind = Local;
				if( a.kind != Local ) error("Argument should be local", pos);
				if( a.realName != null ) error("No real name allowed for argument", pos);
				if( a.qualifiers.length != 0 ) error("No qualifier allowed for argument", pos);
				{ name : a.name, kind : Local, type : a.type };
			}];
			var f : TFunction = {
				name : f.name,
				args : args,
				ret : f.ret == null ? TVoid : f.ret,
				expr : null,
			};
			functions.set(f.name,f);
			tfuns.push(f);
		}
		for( i in 0...tfuns.length )
			typeFun(tfuns[i], funs[i].f.expr);
			
		for( n in toRename )
			n.v.name = n.name;
			
		return {
			vars : Lambda.array(vars),
			funs : tfuns,
		};
	}
	
	function saveVars() {
		var old = new Map();
		for( v in vars.keys() )
			old.set(v, vars.get(v));
		return old;
	}

	function typeFun( f : TFunction, e : Expr ) {
		var old = saveVars();
		for( a in f.args )
			vars.set(a.name, a);
		curFun = f;
		f.expr = typeExpr(e,NoValue);
		vars = old;
	}
	
	function tryUnify( t1 : Type, t2 : Type ) {
		if( t1 == t2 )
			return true;
		return false;
	}
	
	function unify( t1 : Type, t2 : Type, p : Position ) {
		if( !tryUnify(t1,t2) )
			error(t1.toString() + " should be " + t2.toString(), p);
	}
	
	function unifyExpr( e : TExpr, t : Type ) {
		if( !tryUnify(e.t, t) ) {
			switch( e.e ) {
			case TConst(CInt(v)) if( t == TFloat ):
				e.e = TConst(CFloat(v));
				e.t = TFloat;
			default:
				error(e.t.toString() + " should be " + t.toString(), e.p);
			}
		}
	}
	
	function checkWrite( e : TExpr ) {
		switch( e.e ) {
		case TVar(v):
			switch( v.kind ) {
			case Var, Local:
				return;
			default:
			}
		default:
		}
		error("This expression cannot be assigned", e.p);
	}

	function typeExpr( e : Expr, with : WithType ) : TExpr {
		var type = null;
		var ed = switch( e.expr ) {
		case EConst(c):
			type = switch( c ) {
			case CInt(_): TInt;
			case CString(_): TString;
			case CNull: TVoid;
			case CTrue, CFalse: TBool;
			case CFloat(_): TFloat;
			};
			TConst(c);
		case EBlock(el):
			switch( with ) {
			case NoValue:
				TBlock([for( e in el ) typeExpr(e, NoValue)]);
			default:
				null;
			}
		case EBinop(op, e1, e2):
			var e1 = typeExpr(e1, Value);
			var e2 = typeExpr(e2, With(e1.t));
			switch( op ) {
			case OpAssign:
				checkWrite(e1);
				unify(e2.t, e1.t, e2.p);
				type = e1.t;
			case OpMult, OpAdd, OpSub, OpDiv:
				type = switch( [e1.t, e2.t] ) {
				case [TVec4, TMat4], [TMat4, TVec4]:
					TVec4;
				default:
					var opName = switch( op ) {
					case OpMult: "multiply";
					case OpAdd: "add";
					case OpSub: "subtract";
					case OpDiv: "divide";
					default: throw "assert";
					}
					error("Cannot " + opName + " " + e1.t.toString() + " and " + e2.t.toString(), e.pos);
				}
			default:
			}
			TBinop(op, e1, e2);
		case EIdent(name):
			var v = vars.get(name);
			if( v != null ) {
				type = v.type;
				TVar(v);
			} else {
				var f = functions.get(name);
				if( f != null ) {
					type = TFun([{ args : [for( a in f.args ) { name : a.name, type : a.type }], ret : f.ret }]);
					TFunVar(f);
				} else {
					var g = globals.get(name);
					if( g != null ) {
						type = g.t;
						TGlobal(g.g);
					} else
						error("Unknown identifier '" + name + "'", e.pos);
				}
			}
		case EField(e1, f):
			var e1 = typeExpr(e1, Value);
			var ef = getField(e1, f, e.pos);
			if( ef == null ) error(e1.t.toString() + " has no field '" + f + "'", e.pos);
			type = ef.t;
			ef.e;
		case ECall(e1, args):
			var e1 = typeExpr(e1, Value);
			switch( e1.t ) {
			case TFun(variants):
				var e = unifyCallParams(e1, args, variants, e.pos);
				type = e.t;
				e.e;
			default:
				error(e1.t.toString() + " cannot be called", e.pos);
			}
		default:
			null;
		}
		if( ed == null || type == null )
			throw "TODO " + e.expr;
		return { e : ed, t : type, p : e.pos };
	}
	
	function checkExpr( e : Expr, funs : Array<{ f : FunDecl, p : Position }> ) {
		switch( e.expr ) {
		case EBlock(el):
			for( e in el )
				checkExpr(e,funs);
		case EFunction(f):
			funs.push({ f : f, p : e.pos });
		case EVars(vl):
			for( v in vl ) {
				if( v.kind == null ) v.kind = Var;
				if( v.expr != null ) error("Cannot initialize variable declaration", v.expr.pos);
				if( v.type == null ) error("Type required for variable declaration", e.pos);
				if( vars.exists(v.name) ) error("Duplicate var decl '" + v.name + "'", e.pos);
				declVar(v);
			}
		default:
			error("This expression is not allowed at shader declaration level", e.pos);
		}
	}
	
	function declVar( v : VarDecl, ?parent : TVar ) {
		var tv : TVar = {
			name : v.name,
			kind : v.kind,
			type : v.type,
		};
		if( parent != null )
			tv.parent = parent;
		if( v.qualifiers.length > 0 )
			tv.qualifiers = v.qualifiers;
		vars.set(tv.name, tv);
		if( v.realName != null )
			toRename.push( { v : tv, name : v.realName } );
		switch( v.type ) {
		case TUntypedStruct(vl):
			tv.type = TStruct([for( v in vl ) declVar(v, tv)]);
		default:
		}
		return tv;
	}
	
	function getField( e : TExpr, f : String, pos : Position ) : TExpr {
		var ef = switch( e.t ) {
		case TStruct(vl):
			var found = null;
			for( v in vl )
				if( v.name == f ) {
					found = v;
					break;
				}
			if( found == null )
				null;
			else
				{ e : TVar(found), t : found.type, p : pos };
		default:
			null;
		}
		return ef;
	}

	function specialGlobal( g : TGlobal, e : TExpr, args : Array<Expr>, pos : Position ) : TExpr {
		var args = [for( a in args ) typeExpr(a, Value)];
		var type = null;
		inline function checkLength(n) {
			var t = 0;
			for( a in args )
				switch( a.t ) {
				case TFloat: t++;
				case TVec2: t += 2;
				case TVec3: t += 3;
				case TVec4: t += 4;
				default:
					unifyExpr(a, TFloat);
					t++; // if we manage to unify
				}
			if( t != n )
				error(g.toString() + " requires " + n + " floats but has " + t, pos);
		}
		switch( g ) {
		case Vec2:
			checkLength(2);
			type = TVec2;
		case Vec3:
			checkLength(3);
			type = TVec3;
		case Vec4:
			checkLength(4);
			type = TVec4;
		default:
		}
		if( type == null )
			throw "Custom Global not supported " + g;
		return { e : TCall(e, args), t : type, p : pos };
	}
	
	function unifyCallParams( efun : TExpr, args : Array<Expr>, variants : Array<FunType>, pos : Position ) {
		var minArgs = 1000, maxArgs = -1000, sel = [];
		for( v in variants ) {
			var n = v.args.length;
			if( n < minArgs ) minArgs = n;
			if( n > maxArgs ) maxArgs = n;
			if( n == args.length ) sel.push(v);
		}
		switch( sel ) {
		case [] if( variants.length == 0 ):
			switch( efun.e ) {
			case TGlobal(g):
				return specialGlobal(g, efun, args, pos);
			default:
				throw "assert";
			}
		case []:
			return error("Function expects " + (minArgs == maxArgs ? "" + minArgs : minArgs + "-" + maxArgs)  + " arguments", pos);
		case [f]:
			var targs = [];
			for( i in 0...args.length ) {
				var ft = f.args[i].type;
				var a = typeExpr(args[i], With(ft));
				try {
					unifyExpr(a, ft);
				} catch( e : Error ) {
					e.msg += " for arg " + f.args[i].name;
					throw e;
				}
				targs.push(a);
			}
			if( variants.length > 1 ) efun.t = TFun([f]);
			return { e : TCall(efun, targs), t : f.ret, p : pos };
		default:
			var targs = [for( a in args ) typeExpr(a, Value)];
			var bestMatch = null, mcount = -1;
			for( f in sel ) {
				var m = 0;
				for( i in 0...targs.length ) {
					if( !tryUnify(targs[i].t, f.args[i].type) )
						break;
					m++;
				}
				if( m > mcount ) {
					bestMatch = f;
					mcount = m;
					if( m == targs.length ) {
						efun.t = TFun([f]);
						return { e : TCall(efun, targs), t : f.ret, p : pos };
					}
				}
			}
			for( i in 0...targs.length )
				try {
					unify(targs[i].t, bestMatch.args[i].type, targs[i].p);
				} catch( e : Error ) {
					e.msg += " for arg " + bestMatch.args[i].name;
					throw e;
				}
			throw "assert";
		}
		
	}
	
}