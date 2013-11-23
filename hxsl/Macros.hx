package hxsl;
import haxe.macro.Context;

class Macros {

	public static function buildShader() {
		var fields = Context.getBuildFields();
		for( f in fields )
			if( f.name == "SRC" ) {
				switch( f.kind ) {
				case FVar(_, expr) if( expr != null ):
					try {
						var shader = new MacroParser().parseExpr(expr);
						var name = Std.string(Context.getLocalClass());
						var shader = new Checker().check(name,shader);
						var str = Serializer.run(shader);
						f.kind = FVar(null, { expr : EConst(CString(str)), pos : expr.pos } );
						f.meta.push({
							name : ":keep",
							pos : expr.pos,
						});
					} catch( e : Ast.Error ) {
						fields.remove(f);
						Context.error(e.msg, e.pos);
					}
				default:
				}
			}
		return fields;
	}
	
}