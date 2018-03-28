package h3d.impl;
#if macro
import haxe.macro.Expr;
using haxe.macro.ExprTools;
#end

@:autoBuild(h3d.impl.VarBinding.Macros.build())
interface VarBinding {
}

#if macro

class Init {
	public var path : Array<String>;
	public var expr : Expr;
	public var dependsOn : Array<Init>;
	public var dependedBy : Array<Init>;

	public var mark : Bool;
	public var isInit : Bool;
	public var parent : Init;

	public function new(path,expr, isInit=false) {
		this.path = path;
		this.expr = expr;
		this.isInit = isInit;
		this.dependsOn = [];
		this.dependedBy = [];
	}

}

class Macros {

	static function hasIdent( e ) {
		var has = false;
		function loop(e : Expr) {
			switch( e.expr ) {
			case EConst(CIdent(i)):
				has = true;
			default:
			}
			if( !has )
				e.iter(loop);
		}
		loop(e);
		return has;
	}

	public static function build() {
		var fields = haxe.macro.Context.getBuildFields();
		var inits = [];

		function initExpr( path : Array<String>, e : Expr, isInit ) : Expr {
			return switch( e.expr ) {
			case EObjectDecl(fields):
				if( !isInit )
					inits.push(new Init(path.copy(), null));
				for( f in fields ) {
					path.push(f.field);
					f.expr = initExpr(path, f.expr, isInit);
					path.pop();
				}
				e;
			case EBinop(OpArrow, e1, e2):
				if( isInit )
					haxe.macro.Context.error("Can't chain initializers", e.pos);
				if( !e2.expr.match(EObjectDecl(_)) )
					haxe.macro.Context.error("Object declaration required", e2.pos);
				initExpr(path, e2, true); // ignore returned expr : all inits has been pushed in path
				initExpr(path, e1, isInit);
			default:
				if( isInit || hasIdent(e) ) {
					inits.push(new Init(path.copy(), e, isInit));
					macro if( false ) $e else cast null; // type inference + delayed
				} else {
					inits.push(new Init(path.copy(), null));
					e;
				}
			}
		}

		var constructor = null;
		for( f in fields.copy() )
			switch( f.kind ) {
			case FVar(t, e) if( e != null ):
				var e = initExpr([f.name], e, false);
				f.kind = FVar(t, e);
			case FFun(m) if( f.name == "new" ):
				constructor = m;
			default:
			}

		if( constructor == null )
			haxe.macro.Context.error("Requires a declared constructor", haxe.macro.Context.currentPos());

		var initsMap = new Map();
		for( i in inits )
			initsMap.set(i.path.join("."), i);
		for( i in inits ) {
			if( i.path.length > 1 ) {
				var p = i.path.copy();
				while( p.length > 0 ) {
					p.pop();
					i.parent = initsMap.get(p.join("."));
					if( i.parent != null ) break;
				}
			}
			if( i.expr != null ) {
				function addDep( path : Array<String> ) {
					while( path.length > 0 ) {
						var idep = initsMap.get(path.join("."));
						if( idep != null ) {
							if( i.dependsOn.indexOf(idep) < 0 ) {
								i.dependsOn.push(idep);
								idep.dependedBy.push(i);
							}
							return;
						}
						path.pop();
					}
				}
				function browseExpr( path : Array<String>, e : Expr ) {
					switch( e.expr ) {
					case EField(eobj, field):
						path.unshift(field);
						browseExpr(path, eobj);
						path.shift();
					case EConst(CIdent(id)) if( initsMap.exists(id) ):
						path.unshift(id);
						addDep(path.copy());
						path.shift();
					default:
						e.iter(browseExpr.bind([]));
					}
				}
				browseExpr([], i.expr);
			}
		}

		var order = [];

		function makeAssign( path : Array<String>, expr : Expr ) : Expr {
			path = path.copy();
			var epath : Expr = { expr : EConst(CIdent(path.shift())), pos : expr.pos };
			while( path.length > 0 ) {
				var f = path.shift();
				var index;
				if( f.charCodeAt(0) == "_".code && (index = Std.parseInt(f.substr(1))) != null )
					epath = { expr : EArray(epath, { expr : EConst(CInt(""+index)), pos : expr.pos }), pos : expr.pos };
				else
					epath = { expr : EField(epath, f), pos : expr.pos };
			}
			return { expr : EBinop(OpAssign, epath, expr), pos : expr.pos };
		}

		function markRec( i : Init ) {
			if( i.mark )
				return;
			i.mark = true;
			if( i.parent != null )
				markRec(i.parent);
			for( d in i.dependsOn )
				markRec(d);
			if( i.expr != null )
				order.push(makeAssign(i.path,i.expr));
		}
		for( i in inits )
			markRec(i);

		switch( constructor.expr.expr ) {
		case EBlock(el):
			constructor.expr = { expr : EBlock(order.concat(el)), pos : constructor.expr.pos };
		default:
			constructor.expr = { expr : EBlock(order.concat([constructor.expr])), pos : constructor.expr.pos };
		}


		return fields;
	}
}
#end
