package h3d.impl;
import haxe.macro.Context;
import haxe.macro.Expr;

class MacroHelper {

#if macro

	static function replaceGLLoop( e : Expr ) {
		switch( e.expr ) {
		case EConst(CIdent("gl")):
			e.expr = EConst(CIdent("GL"));
		default:
			haxe.macro.ExprTools.iter(e, replaceGLLoop);
		}
	}

	public static function replaceGL() {
		var fields = Context.getBuildFields();
		for( f in fields )
			switch( f.kind ) {
			case FFun(f):
				if( f.expr != null ) replaceGLLoop(f.expr);
			default:
			}
		return fields;
	}

#end

}