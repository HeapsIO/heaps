package hxsl;
using hxsl.Ast;
import hxsl.Debug.trace in debug;

private class Exit {
	public function new() {
	}
}

private class VarRel {
	public var v : VarDeps;
	public var fields : Int = 0;
	public function new(v) {
		this.v = v;
	}
}

private class VarDeps {
	public var v : TVar;
	public var keep : Int = 0;
	public var used : Int = 0;
	public var deps : Map<Int,VarRel>;
	public var adeps : Array<VarRel>;
	public function new(v) {
		this.v = v;
		deps = new Map();
		adeps = [];
	}
}

private class WriteTo {
	public var vars : Array<VarDeps>;
	public var bits : Array<Int>;
	public function new() {
		vars = [];
		bits = [];
	}
	public function push(v,b) {
		vars.push(v);
		bits.push(b);
	}
	public function pop() {
		vars.pop();
		bits.pop();
	}
	public function append( v: VarDeps, b : Int ) {
		for( i => v2 in vars )
			if( v2 == v ) {
				bits[i] |= b;
				return;
			}
		push(v,b);
	}
	public function appendTo( w : WriteTo ) {
		for( i => v in vars )
			w.append(v, bits[i]);
	}
}

class Dce {

	var used : Map<Int,VarDeps>;
	var channelVars : Array<TVar>;
	var markAsKeep : Bool;

	public function new() {
	}

	public function dce( shaders : Array<ShaderData> ) {
		// collect vars dependencies
		used = new Map();
		channelVars = [];

		var inputs = [];
		for( s in shaders ) {
			for( v in s.vars ) {
				var i = get(v);
				if( v.kind == Input )
					inputs.push(i);
				if( v.kind == Output || v.type.match(TBuffer(_,_,RW) | TRWTexture(_)) )
					i.keep = 15;
			}
		}

		// collect dependencies
		for( s in shaders ) {
			for( f in s.funs )
				check(f.expr, new WriteTo(), new WriteTo());
		}

		var outExprs = [];
		while( true ) {

			debug("DCE LOOP");

			for( v in used )
				if( v.keep != 0 )
					markRec(v, v.keep);

			while( inputs.length > 1 && inputs[inputs.length - 1].used == 0 )
				inputs.pop();
			for( v in inputs )
				markRec(v, 15);

			outExprs = [];
			for( s in shaders ) {
				for( f in s.funs )
					outExprs.push(mapExpr(f.expr, false));
			}

			// post add conditional branches
			markAsKeep = false;
			for( e in outExprs )
				checkBranches(e);
			if( !markAsKeep ) break;
		}

		for( s in shaders ) {
			for( f in s.funs )
				f.expr = outExprs.shift();
		}

		for( v in used ) {
			if( v.used != 0 ) continue;
			if( v.v.kind == VarKind.Input) continue;
			for( s in shaders )
				s.vars.remove(v.v);
		}

		return shaders.copy();
	}

	function get( v : TVar ) {
		var vd = used.get(v.id);
		if( vd == null ) {
			vd = new VarDeps(v);
			used.set(v.id, vd);
		}
		return vd;
	}

	function varName( v : TVar, bits = 15 ) {
		return Debug.varName(v, bits);
	}

	function markRec( v : VarDeps, bits : Int ) {
		if( v.used & bits == bits ) return;
		bits &= ~v.used;
		debug(varName(v.v,bits)+" is used");
		v.used |= bits;
		for( d in v.adeps ) {
			var mask = makeFieldsBits(15, bits);
			if( d.fields & mask != 0 )
				markRec(d.v, extractFieldsBits(d.fields,bits));
		}
	}

	function extractFieldsBits( fields : Int, write : Int ) {
		return ((write & 1 == 0 ? 0 : fields) | (write & 2 == 0 ? 0 : fields>>4) | (write & 4 == 0 ? 0 : fields>>8) | (write & 8 == 0 ? 0 : fields>>12)) & 15;
	}

	function makeFieldsBits( read : Int, write : Int ) {
		return read * ((write & 1) + ((write & 2) << 3) + ((write & 4) << 6) + ((write & 8) << 9));
	}

	function link( v : TVar, writeTo : WriteTo, bits = 15 ) {
		var vd = get(v);
		for( i => w in writeTo.vars ) {
			if( w == null ) {
				// mark for conditional
				if( vd.keep == 0 ) {
					debug("Force keep "+varName(vd.v));
					vd.keep = 15;
					markAsKeep = true;
				}
				continue;
			}
			var d = w.deps.get(v.id);
			if( d == null ) {
				d = new VarRel(vd);
				w.deps.set(v.id, d);
				w.adeps.push(d);
			}
			var fields = makeFieldsBits(bits, writeTo.bits[i]);
			if( d.fields & fields != fields ) {
				d.fields |= fields;
				debug(varName(w.v,writeTo.bits[i])+" depends on "+varName(vd.v,bits));
			}
		}
	}

	function swizBits( sw : Array<Component> ) {
		var b = 0;
		for( c in sw )
			b |= 1 << c.getIndex();
		return b;
	}

	function check( e : TExpr, writeTo : WriteTo, isAffected : WriteTo ) : Void {
		switch( e.e ) {
		case TVar(v):
			link(v, writeTo);
		case TSwiz({ e : TVar(v) }, swiz):
			link(v, writeTo, swizBits(swiz));
		case TBinop(OpAssign | OpAssignOp(_), { e : TVar(v) }, e):
			var v = get(v);
			writeTo.push(v,15);
			check(e, writeTo, isAffected);
			writeTo.pop();
			isAffected.append(v,15);
		case TBinop(OpAssign | OpAssignOp(_), { e : TSwiz({ e : TVar(v) },swiz) }, e):
			var v = get(v);
			var bits = swizBits(swiz);
			writeTo.push(v,bits);
			check(e, writeTo, isAffected);
			writeTo.pop();
			isAffected.append(v,bits);
		case TBinop(OpAssign | OpAssignOp(_), { e : (TArray({ e: TVar(v) }, i) | TSwiz({ e : TArray({ e : TVar(v) }, i) },_) | TField({e : TArray({ e : TVar(v) }, i) }, _)) }, e):
			var v = get(v);
			writeTo.push(v,15);
			check(i, writeTo, isAffected);
			check(e, writeTo, isAffected);
			writeTo.pop();
			isAffected.append(v,15);
		case TBlock(el):
			var noWrite = new WriteTo();
			for( i in 0...el.length )
				check(el[i],i < el.length - 1 ? noWrite : writeTo, isAffected);
		case TVarDecl(v, init) if( init != null ):
			writeTo.push(get(v),15);
			check(init, writeTo, isAffected);
			writeTo.pop();
		case TIf(e, eif, eelse):
			var affect = new WriteTo();
			check(eif, writeTo, affect);
			if( eelse != null ) check(eelse, writeTo, affect);
			affect.appendTo(isAffected);
			writeTo.appendTo(affect);
			check(e, affect, isAffected);
		case TFor(v, it, loop):
			var affect = new WriteTo();
			check(loop, writeTo, affect);
			affect.appendTo(isAffected);
			check(it, affect, isAffected);
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
		case TCall({ e : TGlobal(ImageStore)}, [{ e : TVar(v) }, uv, val]):
			var v = get(v);
			writeTo.push(v,15);
			check(uv, writeTo, isAffected);
			check(val, writeTo, isAffected);
			writeTo.pop();
			isAffected.append(v,15);
		default:
			e.iter(check.bind(_, writeTo, isAffected));
		}
	}

	function checkBranches( e : TExpr ) {
		// found a branch with side effect left, this condition vars needs to be kept
		switch( e.e ) {
		case TIf(cond, _, _):
			var writeTo = new WriteTo();
			writeTo.append(null,0);
			check(cond, writeTo, new WriteTo());
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
		case TVarDecl(v,_) | TBinop(OpAssign | OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _) | TArray( { e : TVar(v) }, _)) }, _) if( get(v).used == 0 ):
			return { e : TConst(CNull), t : e.t, p : e.p };
		case TBinop(OpAssign | OpAssignOp(_), { e : TSwiz( { e : TVar(v) }, swiz) }, _) if( get(v).used & swizBits(swiz) == 0 ):
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
		case TMeta(m, args, em):
			var em = mapExpr(em, isVar);
			if( !isVar && !em.hasSideEffect() )
				return { e : TConst(CNull), t : e.t, p : e.p };
			return { e : TMeta(m, args, em), t : e.t, p : e.p };
		default:
			return e.map(function(e) return mapExpr(e,true));
		}
	}

}