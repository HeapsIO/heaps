package h2d.domkit;
import h2d.domkit.BaseComponents.CustomParser;

class InitComponents {

	public static function init() {
		domkit.Macros.registerComponentsPath("h2d.domkit.BaseComponents.$Comp");
		domkit.Macros.registerComponentsPath("$Comp");
		// force base components to be built before custom components
		@:privateAccess domkit.Macros.preload = [
			for( o in ["Object","Bitmap","Text","Flow","Mask"] )
				'h2d.domkit.BaseComponents.${o}Comp'
		];
		return null;
	}

	static function addOnRemove(fields : Array<haxe.macro.Expr.Field>) : Array<haxe.macro.Expr.Field> {
		var removeExpr = macro {
			var style = Std.instance(document.style, h2d.domkit.Style);
			if( style != null ) @:privateAccess style.remove(this);
			// make sure it's also removed from document
			var elt = document.get(this);
			if( elt != null && elt.parent != null ) {
				elt.parent.children.remove(elt);
				@:privateAccess elt.parent = null;
			}
		};

		var found = false;
		for( f in fields ) {
			if( f.name == "onRemove" ) {
				function repl(e:haxe.macro.Expr) {
					switch( e.expr ) {
					case ECall( { expr : EField( { expr : EConst(CIdent("super")) }, "onRemove") }, []):
						found = true;
						return macro { $e; $removeExpr; }
					default:
						return haxe.macro.ExprTools.map(e, repl);
					}
				}
				switch( f.kind ) {
				case FFun(f):
					f.expr = repl(f.expr);
				default:
				}
				if( !found ) haxe.macro.Context.error("Override of onRemove() with no super.onRemove() found", f.pos);
			}
		}
		if(!found) {
			fields = fields.concat((macro class {
				override function onRemove() {
					super.onRemove();
					$removeExpr;
				}
			}).fields);
		}
		return fields;
	}

	public static function build() {
		var fields = domkit.Macros.buildObject();
		for( f in fields )
			if( f.name == "document" ) {
				fields = addOnRemove(fields);
				break;
			}
		return fields;
	}
}
