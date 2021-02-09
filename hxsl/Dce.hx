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
	var channelVars : Array<TVar>;
	var markAsKeep : Bool;

	public function new() {
	}

	inline function debug( msg : String, ?pos : haxe.PosInfos ) {
		#if shader_debug_dump
		if( Cache.TRACE )
			haxe.Log.trace(msg, pos);
		#end
	}

	public function dce( vertex : ShaderData, fragment : ShaderData ) {
		// collect vars dependencies
		used = new Map();
		channelVars = [];

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

		// collect dependencies
		for( f in vertex.funs )
			check(f.expr, [], []);
		for( f in fragment.funs )
			check(f.expr, [], []);

		var outExprs = [];
		while( true ) {

			debug("DCE LOOP");

			for( v in used )
				if( v.keep )
					markRec(v);

			while( inputs.length > 1 && !inputs[inputs.length - 1].used )
				inputs.pop();
			for( v in inputs )
				markRec(v);

			outExprs = [];
			for( f in vertex.funs )
				outExprs.push(mapExpr(f.expr, false));
			for( f in fragment.funs )
				outExprs.push(mapExpr(f.expr, false));

			// post add conditional branches
			markAsKeep = false;
			for( e in outExprs )
				checkBranches(e);
			if( !markAsKeep ) break;
		}

		for( f in vertex.funs )
			f.expr = outExprs.shift();
		for( f in fragment.funs )
			f.expr = outExprs.shift();

		for( v in used ) {
			if( v.used ) continue;
			if( v.v.kind == VarKind.Input) continue;
			vertex.vars.remove(v.v);
			fragment.vars.remove(v.v);
		}

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
		debug(v.v.name+" is used");
		v.used = true;
		for( d in v.deps )
			markRec(d);
	}

	function link( v : TVar, writeTo : Array<VarDeps> ) {
		var vd = get(v);
		for( w in writeTo ) {
			if( w == null ) {
				// mark for conditional
				if( !vd.keep ) {
					debug("Force keep "+vd.v.name);
					vd.keep = true;
					markAsKeep = true;
				}
				continue;
			}
			debug(w.v.name+" depends on "+vd.v.name);
			w.deps.set(v.id, vd);
		}
	}

	function check( e : TExpr, writeTo : Array<VarDeps>, isAffected : Array<VarDeps> ) : Void {
		switch( e.e ) {
		case TVar(v):
			link(v, writeTo);
		case TBinop(OpAssign | OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, e):
			var v = get(v);
			writeTo.push(v);
			check(e, writeTo, isAffected);
			writeTo.pop();
			if( isAffected.indexOf(v) < 0 )
				isAffected.push(v);
		case TBlock(el):
			var noWrite = [];
			for( i in 0...el.length )
				check(el[i],i < el.length - 1 ? noWrite : writeTo, isAffected);
		case TVarDecl(v, init) if( init != null ):
			writeTo.push(get(v));
			check(init, writeTo, isAffected);
			writeTo.pop();
		case TIf(e, eif, eelse):
			var affect = [];
			check(eif, writeTo, affect);
			if( eelse != null ) check(eelse, writeTo, affect);
			var len = affect.length;
			for( v in writeTo )
				if( affect.indexOf(v) < 0 )
					affect.push(v);
			check(e, affect, isAffected);
			for( i in 0...len ) {
				var v = affect[i];
				if( isAffected.indexOf(v) < 0 )
					isAffected.push(v);
			}
		case TFor(v, it, loop):
			var affect = [];
			check(loop, writeTo, affect);
			check(it, affect, isAffected);
			for( v in affect )
				if( isAffected.indexOf(v) < 0 )
					isAffected.push(v);
		case TCall({ e : TGlobal(ChannelRead) }, [{ e : TVar(c) }, uv, { e : TConst(CInt(cid)) }]):
			check(uv, writeTo, isAffected);
			if( channelVars[cid] == null ) {
				channelVars[cid] = c;
				link(c, writeTo);
			} else {
				link(channelVars[cid], writeTo);
			}
		case TCall({ e : TGlobal(ChannelReadLod) }, [{ e : TVar(c) }, uv, lod, { e : TConst(CInt(cid)) }]):
			check(uv, writeTo, isAffected);
			check(lod, writeTo, isAffected);
			if( channelVars[cid] == null ) {
				channelVars[cid] = c;
				link(c, writeTo);
			} else {
				link(channelVars[cid], writeTo);
			}
		default:
			e.iter(check.bind(_, writeTo, isAffected));
		}
	}

	function checkBranches( e : TExpr ) {
		// found a branch with side effect left, this condition vars needs to be kept
		switch( e.e ) {
		case TIf(cond, _, _):
			var writeTo = [null];
			check(cond, writeTo, []);
		default:
		}
		e.iter(checkBranches);
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
		case TCall({ e : TGlobal(ChannelRead) }, [_, uv, { e : TConst(CInt(cid)) }]):
			var c = channelVars[cid];
			return { e : TCall({ e : TGlobal(Texture), p : e.p, t : TVoid }, [{ e : TVar(c), t : c.type, p : e.p }, mapExpr(uv,true)]), t : TVoid, p : e.p };
		case TCall({ e : TGlobal(ChannelReadLod) }, [_, uv, lod, { e : TConst(CInt(cid)) }]):
			var c = channelVars[cid];
			return { e : TCall({ e : TGlobal(TextureLod), p : e.p, t : TVoid }, [{ e : TVar(c), t : c.type, p : e.p }, mapExpr(uv,true), mapExpr(lod,true)]), t : TVoid, p : e.p };
		case TCall({ e : TGlobal(ChannelFetch) }, [_, pos, { e : TConst(CInt(cid)) }]):
			var c = channelVars[cid];
			return { e : TCall({ e : TGlobal(Texel), p : e.p, t : TVoid }, [{ e : TVar(c), t : c.type, p : e.p }, mapExpr(pos,true)]), t : TVoid, p : e.p };
		case TCall({ e : TGlobal(ChannelFetch) }, [_, pos, lod, { e : TConst(CInt(cid)) }]):
			var c = channelVars[cid];
			return { e : TCall({ e : TGlobal(Texel), p : e.p, t : TVoid }, [{ e : TVar(c), t : c.type, p : e.p }, mapExpr(pos,true), mapExpr(lod,true)]), t : TVoid, p : e.p };
		case TCall({ e : TGlobal(ChannelTextureSize) }, [_, { e : TConst(CInt(cid)) }]):
			var c = channelVars[cid];
			return { e : TCall({ e : TGlobal(TextureSize), p : e.p, t : TVoid }, [{ e : TVar(c), t : c.type, p : e.p }]), t : TVoid, p : e.p };
		case TCall({ e : TGlobal(ChannelTextureSize) }, [_, lod, { e : TConst(CInt(cid)) }]):
			var c = channelVars[cid];
			return { e : TCall({ e : TGlobal(TextureSize), p : e.p, t : TVoid }, [{ e : TVar(c), t : c.type, p : e.p }, mapExpr(lod,true)]), t : TVoid, p : e.p };
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