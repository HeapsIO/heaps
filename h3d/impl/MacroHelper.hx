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
			case FVar(_,e):
				if( e != null ) replaceGLLoop(e);
			default:
			}
		return fields;
	}

#end

	public static macro function getResourcesPath() {
		var dir = haxe.macro.Context.definedValue("resourcesPath");
		if( dir == null ) dir = "res";
		return macro $v{try Context.resolvePath(dir) catch( e : Dynamic ) null};
	}

}