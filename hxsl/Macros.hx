package hxsl;
import haxe.macro.Context;

class Macros {

	public static function buildShader() {
		var fields = Context.getBuildFields();
		for( f in fields )
			if( f.name == "SRC" ) {
				switch( f.kind ) {
				case FVar(_, expr) if( expr != null ):
					fields.remove(f);
					try {
						var shader = new MacroParser().parseExpr(expr);
						var shader = new Checker().check(shader);
					} catch( e : Ast.Error ) {
						Context.error(e.msg, e.pos);
					}
				default:
				}
			}
		return fields;
	}
	
}