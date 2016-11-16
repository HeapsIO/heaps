package hxsl;
using hxsl.Ast;

private class Exit {
	public function new() {
	}
}

private class VarDeps {
	public var v : TVar;
	public var keep : Bool;
	public var used : Bool;
	public var deps : Map<Int,VarDeps>;
	public function new(v) {
		this.v = v;
		used = false;
		deps = new Map();
	}
}

class Dce {

	var used : Map<Int,VarDeps>;

	public function new() {
	}

	public function dce( vertex : ShaderData, fragment : ShaderData ) {
		// collect vars dependencies
		used = new Map();

		var inputs = [];
		for( v in vertex.vars ) {
			var i = get(v);
			if( v.kind == Input )
				inputs.push(i);
			if( v.kind == Output )
				i.keep = true;
		}
		for( v in fragment.vars ) {
			var i = get(v);
			if( v.kind == Output )
				i.keep = true;
		}
		for( f in vertex.funs )
			check(f.expr, []);
		for( f in fragment.funs )
			check(f.expr, []);

		for( v in used )
			if( v.keep )
				markRec(v);

		while( inputs.length > 1 && !inputs[inputs.length - 1].used )
			inputs.pop();
		for( v in inputs )
			markRec(v);

		for( v in used ) {
			if( v.used ) continue;
			vertex.vars.remove(v.v);
			fragment.vars.remove(v.v);
		}

		for( f in vertex.funs )
			f.expr = mapExpr(f.expr, false);
		for( f in fragment.funs )
			f.expr = mapExpr(f.expr, false);


		return {
			fragment : fragment,
			vertex : vertex,
		}
	}

	function get( v : TVar ) {
		var vd = used.get(v.id);
		if( vd == null ) {
			vd = new VarDeps(v);
			used.set(v.id, vd);
		}
		return vd;
	}

	function markRec( v : VarDeps ) {
		if( v.used ) return;
		v.used = true;
		for( d in v.deps )
			markRec(d);
	}

	function link( v : TVar, writeTo : Array<VarDeps> ) {
		var vd = get(v);
		for( w in writeTo ) {
			if( w == null ) {
				// mark for discard()
				vd.keep = true;
				continue;
			}
			w.deps.set(v.id, vd);
		}
	}

	function hasDiscardRec( e : TExpr ) {
		switch( e.e ) {
		case TDiscard: throw new Exit();
		default:
			e.iter(hasDiscardRec);
		}
	}

	function hasDiscard( e : TExpr ) {
		try {
			hasDiscardRec(e);
			return false;
		} catch( e : Exit ) {
			return true;
		}
	}

	function check( e : TExpr, writeTo : Array<VarDeps> ) : Void {
		switch( e.e ) {
		case TVar(v):
			link(v, writeTo);
		case TBinop(OpAssign | OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, e):
			writeTo.push(get(v));
			check(e, writeTo);
			writeTo.pop();
		case TVarDecl(v, init) if( init != null ):
			writeTo.push(get(v));
			check(init, writeTo);
			writeTo.pop();
		case TIf(e, eif, eelse) if( hasDiscard(eif) || (eelse != null && hasDiscard(eelse)) ):
			writeTo.push(null);
			check(e, writeTo);
			writeTo.pop();
			check(eif, writeTo);
			if( eelse != null ) check(eelse, writeTo);
		case TFor(v, it, loop):
			writeTo.push(null);
			check(it, writeTo);
			check(loop, writeTo);
			writeTo.pop();
		default:
			e.iter(check.bind(_, writeTo));
		}
	}

	function mapExpr( e : TExpr, isVar ) : TExpr {
		switch( e.e ) {
		case TBlock(el):
			var out = [];
			var count = 0;
			for( e in el ) {
				var isVar = isVar && count == el.length - 1;
				var e = mapExpr(e, isVar);
				if( e.hasSideEffect() || isVar )
					out.push(e);
				count++;
			}
			return { e : TBlock(out), p : e.p, t : e.t };
		case TVarDecl(v,_) | TBinop(OpAssign | OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, _) if( !get(v).used ):
			return { e : TConst(CNull), t : e.t, p : e.p };
		case TIf(e, econd, eelse):
			var e = mapExpr(e, true);
			var econd = mapExpr(econd, isVar);
			var eelse = eelse == null ? null : mapExpr(eelse, isVar);
			if( !isVar && !econd.hasSideEffect() && (eelse == null || !eelse.hasSideEffect()) )
				return { e : TConst(CNull), t : e.t, p : e.p };
			return { e : TIf(e, econd, eelse), p : e.p, t : e.t };
		case TFor(v, it, loop):
			var it = mapExpr(it, true);
			var loop = mapExpr(loop, false);
			if( !loop.hasSideEffect() )
				return { e : TConst(CNull), t : e.t, p : e.p };
			return { e : TFor(v, it, loop), p : e.p, t : e.t };
		default:
			return e.map(function(e) return mapExpr(e,true));
		}
	}

}