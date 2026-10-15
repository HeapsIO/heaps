package hxsl;
using hxsl.Ast;

private class Region {
	public var e : TExpr;
	public var name : String;
	public var isVal : Bool;
	public var params : Array<TVar> = [];
	public var args : Array<TExpr> = [];
	public var body : Array<TExpr>;
	public var freeMap : Map<Int,TVar>;
	public var key : String;
	public var size : Int;
	public function new() {
	}
}

/**
	Eval inlines every helper call and tags the result with a TMeta(META) region : constant args are
	folded and DCE works on each call site exactly as with plain inlining. Once DCE is done, the regions
	that occur several times identically in a stage are turned back into a single function, the others
	are unwrapped. An unwrapped value keeps the helper name in a TMeta(VALUE) so that the function the
	backend emits for a value block is named after it.
**/
class Outliner {

	public static inline var META = "inlined";
	public static inline var VALUE = "inlinedValue";
	// statement regions with fewer expression nodes are kept inlined ; not values, since the backend
	// would turn each of them into its own function anyway
	public static var MIN_SIZE = 10;

	var shaderVars : Map<Int,Bool>;
	var regions : Array<Region>;
	var funs : Array<TFunction>;
	var refs : Array<TVar>;

	var ids : Map<Int,Int>;
	var nextId : Int;
	var buf : StringBuf;
	var size : Int;

	public function new() {
	}

	public function outline( shaders : Array<ShaderData> ) {
		return [for( s in shaders ) outlineShader(s)];
	}

	function outlineShader( s : ShaderData ) : ShaderData {
		shaderVars = new Map();
		for( v in s.vars )
			shaderVars.set(v.id, true);
		funs = [];
		refs = [];
		// each pass resolves the innermost regions, rewriting them in place (Dce created these nodes)
		while( true ) {
			regions = [];
			var found = false;
			for( f in s.funs )
				if( collect(f.expr, f.ret != TVoid) )
					found = true;
			if( !found ) break;
			resolve();
		}
		return {
			name : s.name,
			vars : s.vars.concat(refs),
			funs : funs.concat(s.funs),
		};
	}

	// innermost regions first : returns true if e contains a region
	function collect( e : TExpr, isVal : Bool ) : Bool {
		switch( e.e ) {
		case TMeta(m, [CString(name)], body) if( m == META ):
			if( !collect(body, isVal) )
				regions.push(makeRegion(e, name, body, isVal));
			return true;
		case TBlock(el):
			var found = false;
			for( i => e in el )
				if( collect(e, isVal && i == el.length - 1) )
					found = true;
			return found;
		case TIf(econd, eif, eelse):
			var found = collect(econd, true);
			if( collect(eif, isVal) ) found = true;
			if( eelse != null && collect(eelse, isVal) ) found = true;
			return found;
		case TFor(_, it, loop):
			var found = collect(it, true);
			return collect(loop, false) || found;
		case TWhile(econd, loop, _):
			var found = collect(econd, true);
			return collect(loop, false) || found;
		case TSwitch(ec, cases, def):
			var found = collect(ec, true);
			for( c in cases ) {
				for( v in c.values )
					if( collect(v, true) ) found = true;
				if( collect(c.expr, isVal) ) found = true;
			}
			if( def != null && collect(def, isVal) ) found = true;
			return found;
		case TMeta(_, _, e):
			return collect(e, isVal);
		default:
			var found = false;
			e.iter(function(e) if( collect(e, true) ) found = true);
			return found;
		}
	}

	function makeRegion( e : TExpr, name : String, body : TExpr, isVal : Bool ) {
		var r = new Region();
		r.e = e;
		r.name = name;
		r.isVal = isVal;
		var el = switch( body.e ) {
		case TBlock(el): el;
		default: [body];
		};
		var locals = new Map();
		var i = 0;
		while( i < el.length - (isVal ? 1 : 0) ) {
			switch( el[i].e ) {
			// the evaluated args come first : make them parameters, evaluated by the caller
			case TVarDecl(v, init) if( init != null && isParamType(v.type) && !init.hasSideEffect() && !readsAny(init, locals) ):
				r.params.push(v);
				r.args.push(init);
				locals.set(v.id, true);
				i++;
			default:
				break;
			}
		}
		r.body = el.slice(i);
		if( r.body.length == 0 || !checkBody(r.body, locals) )
			return r;

		// the caller locals it reads are passed by value, it must not write them
		var free = [];
		var written = new Map();
		for( e in r.body )
			collectFree(e, locals, free, written);
		r.freeMap = new Map();
		for( v in free ) {
			if( written.exists(v.id) || !isParamType(v.type) )
				return r;
			var p : TVar = { id : Tools.allocVarId(), name : v.name, type : v.type, kind : Local };
			r.freeMap.set(v.id, p);
			r.params.push(p);
			r.args.push({ e : TVar(v), t : v.type, p : e.p });
		}

		ids = new Map();
		nextId = 0;
		buf = new StringBuf();
		size = 0;
		buf.add(isVal ? typeKey(e.t) : "void");
		for( v in r.params )
			declKey(v);
		for( v in free )
			ids.set(v.id, ids.get(r.freeMap.get(v.id).id));
		buf.add("|");
		for( e in r.body ) {
			exprKey(e);
			buf.add(";");
		}
		r.key = buf.toString();
		r.size = size;
		buf = null;
		return r;
	}

	function resolve() {
		var groups = new Map<String,Array<Region>>();
		var order = [];
		for( r in regions ) {
			if( r.key == null ) {
				unwrap(r);
				continue;
			}
			var g = groups.get(r.key);
			if( g == null ) {
				g = [];
				groups.set(r.key, g);
				order.push(g);
			}
			g.push(r);
		}
		for( g in order ) {
			if( g.length < 2 || (g[0].size < MIN_SIZE && !g[0].isVal) ) {
				for( r in g )
					unwrap(r);
				continue;
			}
			var f = makeFunction(g[0]);
			for( r in g ) {
				r.e.e = TCall({ e : TVar(f.ref), t : f.ref.type, p : r.e.p }, r.args);
				r.e.t = f.ret;
			}
		}
	}

	function unwrap( r : Region ) {
		switch( r.e.e ) {
		case TMeta(_, _, body):
			if( r.isVal )
				r.e.e = TMeta(VALUE, [CString(r.name)], body);
			else {
				r.e.e = body.e;
				r.e.t = body.t;
			}
		default:
			throw "assert";
		}
	}

	function makeFunction( r : Region ) : TFunction {
		var ret = r.isVal ? r.e.t : TVoid;
		var ref : TVar = {
			id : Tools.allocVarId(),
			name : r.name,
			kind : Function,
			type : TFun([{ args : [for( p in r.params ) { name : p.name, type : p.type }], ret : ret }]),
		};
		function mapFree( e : TExpr ) : TExpr {
			return switch( e.e ) {
			case TVar(v) if( r.freeMap.exists(v.id) ):
				var p = r.freeMap.get(v.id);
				{ e : TVar(p), t : p.type, p : e.p };
			default:
				e.map(mapFree);
			}
		}
		var body = [for( e in r.body ) mapFree(e)];
		var f : TFunction = {
			kind : Helper,
			ref : ref,
			args : r.params,
			ret : ret,
			expr : body.length == 1 ? body[0] : { e : TBlock(body), t : ret, p : r.e.p },
		};
		funs.push(f);
		refs.push(ref);
		return f;
	}

	function isParamType( t : Type ) {
		return switch( t ) {
		case TInt, TBool, TFloat, TVec(_), TMat2, TMat3, TMat4, TMat3x4, TEnum(_): true;
		default: false;
		}
	}

	function isShaderVar( v : TVar ) {
		while( v.parent != null )
			v = v.parent;
		return v.kind != Local || shaderVars.exists(v.id);
	}

	function readsAny( e : TExpr, vars : Map<Int,Bool> ) {
		var found = false;
		function rec( e : TExpr ) {
			switch( e.e ) {
			case TVar(v) if( vars.exists(v.id) ): found = true;
			default: if( !found ) e.iter(rec);
			}
		}
		rec(e);
		return found;
	}

	// a function body can't break out of the caller loop
	function checkBody( el : Array<TExpr>, locals : Map<Int,Bool> ) {
		var ok = true;
		function rec( e : TExpr, inLoop : Bool ) {
			if( !ok ) return;
			switch( e.e ) {
			case TReturn(_), TSyntax(_, _, _):
				ok = false;
			case TBreak, TContinue if( !inLoop ):
				ok = false;
			case TFor(v, it, loop):
				locals.set(v.id, true);
				rec(it, inLoop);
				rec(loop, true);
			case TWhile(econd, loop, _):
				rec(econd, inLoop);
				rec(loop, true);
			case TVarDecl(v, init):
				locals.set(v.id, true);
				if( init != null ) rec(init, inLoop);
			default:
				e.iter(function(e) rec(e, inLoop));
			}
		}
		for( e in el )
			rec(e, false);
		return ok;
	}

	function collectFree( e : TExpr, locals : Map<Int,Bool>, free : Array<TVar>, written : Map<Int,Bool> ) {
		switch( e.e ) {
		case TVar(v) if( !locals.exists(v.id) && !isShaderVar(v) ):
			locals.set(v.id, true);
			free.push(v);
		case TBinop(OpAssign | OpAssignOp(_), e1, _), TUnop(OpIncrement | OpDecrement, e1):
			var v = rootVar(e1);
			if( v != null ) written.set(v.id, true);
		default:
		}
		e.iter(function(e) collectFree(e, locals, free, written));
	}

	function rootVar( e : TExpr ) {
		return switch( e.e ) {
		case TVar(v): v;
		case TSwiz(e, _), TArray(e, _), TField(e, _), TParenthesis(e): rootVar(e);
		default: null;
		}
	}

	function typeKey( t : Type ) {
		return Std.string(t);
	}

	function declKey( v : TVar ) {
		ids.set(v.id, nextId++);
		buf.add("<");
		buf.add(typeKey(v.type));
		buf.add(">");
	}

	function exprKey( e : TExpr ) {
		size++;
		switch( e.e ) {
		case TConst(c):
			buf.add("c");
			switch( c ) {
			case CNull: buf.add("n");
			case CBool(b): buf.add(b ? "t" : "f");
			case CInt(i): buf.add("i"); buf.add(i);
			case CFloat(f):
				var bits = haxe.io.FPHelper.doubleToI64(f);
				buf.add("f"); buf.add(bits.high); buf.add(":"); buf.add(bits.low);
			case CString(s): buf.add("s"); buf.add(s.length); buf.add(":"); buf.add(s);
			}
		case TVar(v):
			var id = ids.get(v.id);
			if( id != null ) {
				buf.add("$");
				buf.add(id);
			} else {
				buf.add("@");
				buf.add(v.id);
			}
		case TGlobal(g):
			buf.add("G");
			buf.add(g.getIndex());
		case TParenthesis(e):
			buf.add("(");
			exprKey(e);
			buf.add(")");
		case TBlock(el):
			buf.add("{");
			for( e in el ) {
				exprKey(e);
				buf.add(";");
			}
			buf.add("}");
		case TBinop(op, e1, e2):
			buf.add("b");
			buf.add(Std.string(op));
			buf.add("(");
			exprKey(e1);
			buf.add(",");
			exprKey(e2);
			buf.add(")");
		case TUnop(op, e1):
			buf.add("u");
			buf.add(Std.string(op));
			buf.add("(");
			exprKey(e1);
			buf.add(")");
		case TVarDecl(v, init):
			buf.add("d");
			declKey(v);
			if( init != null ) {
				buf.add("=");
				exprKey(init);
			}
		case TCall(e, args):
			buf.add("C");
			buf.add(typeKey(e.t));
			exprKey(e);
			buf.add("(");
			for( a in args ) {
				exprKey(a);
				buf.add(",");
			}
			buf.add(")");
		case TSwiz(e, regs):
			buf.add("s");
			for( r in regs )
				buf.add(r.getIndex());
			buf.add("(");
			exprKey(e);
			buf.add(")");
		case TIf(econd, eif, eelse):
			buf.add("i(");
			exprKey(econd);
			buf.add(")");
			exprKey(eif);
			if( eelse != null ) {
				buf.add("e");
				exprKey(eelse);
			}
		case TDiscard:
			buf.add("D");
		case TReturn(e):
			buf.add("R");
			if( e != null ) exprKey(e);
		case TFor(v, it, loop):
			buf.add("f");
			declKey(v);
			exprKey(it);
			exprKey(loop);
		case TContinue:
			buf.add("k");
		case TBreak:
			buf.add("K");
		case TArray(e, index):
			buf.add("[");
			exprKey(e);
			buf.add(",");
			exprKey(index);
			buf.add("]");
		case TArrayDecl(el):
			buf.add("A");
			buf.add(typeKey(e.t));
			buf.add("(");
			for( e in el ) {
				exprKey(e);
				buf.add(",");
			}
			buf.add(")");
		case TSwitch(e, cases, def):
			buf.add("S(");
			exprKey(e);
			buf.add(")");
			for( c in cases ) {
				buf.add("c");
				for( v in c.values ) {
					exprKey(v);
					buf.add(",");
				}
				exprKey(c.expr);
			}
			if( def != null ) {
				buf.add("d");
				exprKey(def);
			}
		case TWhile(e, loop, normalWhile):
			buf.add(normalWhile ? "w" : "W");
			exprKey(e);
			exprKey(loop);
		case TMeta(m, args, e):
			buf.add("m");
			buf.add(m.length);
			buf.add(":");
			buf.add(m);
			buf.add(Std.string(args));
			exprKey(e);
		case TField(e, name):
			buf.add(".");
			buf.add(name);
			buf.add(":");
			exprKey(e);
		case TSyntax(_, _, _):
			throw "assert";
		}
	}

}
