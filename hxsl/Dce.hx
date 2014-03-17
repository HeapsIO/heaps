package hxsl;
using hxsl.Ast;

private class VarDeps {
	public var v : TVar;
	public var used : Bool;
	public var deps : Map<Int,VarDeps>;
	public function new(v) {
		this.v = v;
		used = true;
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
		for( v in vertex.vars )
			get(v);
		for( v in fragment.vars )
			get(v);
		for( f in vertex.funs )
			check(f.expr, []);
		for( f in fragment.funs )
			check(f.expr, []);
			
		// mark vars as unused
		var changed = true;
		while( changed ) {
			changed = false;
			for( v in used ) {
				if( !v.used || v.v.kind == Output || v.v.kind == Input ) continue;
				var used = false;
				for( d in v.deps )
					if( d.used ) {
						used = true;
						break;
					}
				if( !used ) {
					v.used = false;
					changed = true;
					vertex.vars.remove(v.v);
					fragment.vars.remove(v.v);
				}
			}
		}
		for( f in vertex.funs )
			f.expr = mapExpr(f.expr);
		for( f in fragment.funs )
			f.expr = mapExpr(f.expr);
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
	
	function link( v : TVar, writeTo : Array<VarDeps> ) {
		var vd = get(v);
		for( w in writeTo )
			vd.deps.set(w.v.id, w);
	}
	
	function check( e : TExpr, writeTo : Array<VarDeps> ) {
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
		default:
			e.iter(check.bind(_, writeTo));
		}
	}
	
	function mapExpr( e : TExpr ) : TExpr {
		switch( e.e ) {
		case TBlock(el):
			var out = [];
			var count = 0;
			for( e in el ) {
				var e = mapExpr(e);
				switch( e.e ) {
				case TConst(_) if( count < el.length ):
				default:
					out.push(e);
				}
				count++;
			}
			return { e : TBlock(out), p : e.p, t : e.t };
		case TVarDecl(v,_) | TBinop(OpAssign | OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, _) if( !get(v).used ):
			return { e : TConst(CNull), t : e.t, p : e.p };
		default:
			return e.map(mapExpr);
		}
	}
	
}