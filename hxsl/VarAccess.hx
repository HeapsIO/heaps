package hxsl;
using hxsl.Ast;

/**
	Collects the vars an expression reads and writes, the functions it calls, and whether it does
	something else than writing vars (discard, image store, inline syntax, ...).
	Vars declared by the expression are ignored, as well as the ones added with `addLocal`.
**/
class VarAccess {

	public var reads : Array<TVar> = [];
	public var writes : Array<TVar> = [];
	public var calls : Array<TVar> = [];
	public var sideEffect : Bool;

	var locals : Map<Int,Bool> = new Map();
	var readMap : Map<Int,Bool> = new Map();
	var writeMap : Map<Int,Bool> = new Map();

	public function new() {
	}

	public function addLocal( v : TVar ) {
		locals.set(v.id, true);
	}

	/**
		Adds what a called function accesses, as if its body had been inlined here.
	**/
	public function merge( a : VarAccess ) {
		for( v in a.reads ) read(v);
		for( v in a.writes ) write(v);
		if( a.sideEffect ) sideEffect = true;
	}

	function read( v : TVar ) {
		if( locals.exists(v.id) || readMap.exists(v.id) ) return;
		readMap.set(v.id, true);
		reads.push(v);
	}

	function write( v : TVar ) {
		if( locals.exists(v.id) || writeMap.exists(v.id) ) return;
		writeMap.set(v.id, true);
		writes.push(v);
	}

	function writeRec( e : TExpr ) {
		switch( e.e ) {
		case TVar(v): write(v);
		default: e.iter(writeRec);
		}
	}

	public function collect( e : TExpr ) {
		switch( e.e ) {
		case TVar(v):
			read(v);
		case TBinop(OpAssign, { e : (TVar(v) | TSwiz({ e : TVar(v) },_)) }, e2):
			write(v);
			collect(e2);
		case TBinop(OpAssignOp(_), { e : (TVar(v) | TSwiz({ e : TVar(v) },_)) }, e2):
			read(v);
			write(v);
			collect(e2);
		case TBinop(OpAssign | OpAssignOp(_), { e : (TArray({ e : TVar(v) }, i) | TSwiz({ e : TArray({ e : TVar(v) }, i) },_) | TField({ e : TArray({ e : TVar(v) }, i) }, _)) }, e2):
			write(v);
			collect(i);
			collect(e2);
		case TVarDecl(v, _), TFor(v, _, _):
			addLocal(v);
			e.iter(collect);
		case TDiscard:
			sideEffect = true;
		case TSyntax(_, _, args):
			sideEffect = true;
			for( arg in args ) {
				if( arg.access != Read ) writeRec(arg.e);
				collect(arg.e);
			}
		case TCall({ e : TVar(f) }, args):
			if( calls.indexOf(f) < 0 ) calls.push(f);
			for( a in args ) collect(a);
		case TCall({ e : TGlobal(ImageStore|AtomicAdd|AtomicAnd|AtomicOr) }, args = [{ e : TVar(v) }, _, _]):
			sideEffect = true;
			write(v);
			for( i in 1...args.length ) collect(args[i]);
		case TCall({ e : TGlobal(ResolveSampler|ResolveBuffer) }, [handle, { e : TVar(v) }]):
			sideEffect = true;
			write(v);
			collect(handle);
		case TCall({ e : TGlobal(GroupMemoryBarrier|SetLayout) }, args):
			sideEffect = true;
			for( a in args ) collect(a);
		default:
			e.iter(collect);
		}
	}

	/**
		Tells if the expression does anything else than producing a value.
		`isDeadCall` tells whether a call to an helper function can be removed : the Dce uses it to
		drop the calls that no longer affect anything.
	**/
	public static function hasSideEffect( e : TExpr, ?isDeadCall : TVar -> Bool ) {
		inline function rec( e : TExpr ) return hasSideEffect(e, isDeadCall);
		switch( e.e ) {
		case TParenthesis(e):
			return rec(e);
		case TBlock(el), TArrayDecl(el):
			for( e in el )
				if( rec(e) )
					return true;
			return false;
		case TBinop(OpAssign | OpAssignOp(_), _, _):
			return true;
		case TBinop(_, e1, e2):
			return rec(e1) || rec(e2);
		case TUnop(_, e1):
			return rec(e1);
		case TSwiz(e, _):
			return rec(e);
		case TIf(econd, eif, eelse):
			return rec(econd) || rec(eif) || (eelse != null && rec(eelse));
		case TFor(_, it, loop):
			return rec(it) || rec(loop);
		case TArray(e, index):
			return rec(e) || rec(index);
		case TConst(_), TVar(_), TGlobal(_):
			return false;
		case TCall({ e : TGlobal(SetLayout) },_):
			return true;
		case TCall(e, pl):
			switch( e.e ) {
			case TGlobal( ImageStore | AtomicAdd | AtomicAnd | AtomicOr | GroupMemoryBarrier | ResolveSampler | ResolveBuffer ):
				return true;
			case TGlobal(g):
			case TVar(v) if( isDeadCall != null && isDeadCall(v) ):
			default:
				return true;
			}
			for( p in pl )
				if( rec(p) )
					return true;
			return false;
		case TVarDecl(_), TDiscard, TContinue, TBreak, TReturn(_), TSyntax(_, _, _):
			return true;
		case TSwitch(e, cases, def):
			for( c in cases ) {
				for( v in c.values ) if( rec(v) ) return true;
				if( rec(c.expr) ) return true;
			}
			return rec(e) || (def != null && rec(def));
		case TWhile(e, loop, _):
			return rec(e) || rec(loop);
		case TMeta(_, _, e):
			return rec(e);
		case TField(e,_):
			return rec(e);
		}
	}

}
