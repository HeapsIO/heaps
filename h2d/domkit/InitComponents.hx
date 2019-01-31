package h2d.domkit;
import h2d.domkit.BaseComponents.CustomParser;

class InitComponents {

	#if macro
	public static function initOnce() : Array<haxe.macro.Expr.Field> {
		if( @:privateAccess domkit.Macros.COMPONENTS.get("object") == null ) {
			domkit.Macros.registerComponent(macro : h2d.domkit.BaseComponents.ObjectComp);
			domkit.Macros.registerComponent(macro : h2d.domkit.BaseComponents.DrawableComp);
			domkit.Macros.registerComponent(macro : h2d.domkit.BaseComponents.FlowComp);
			domkit.Macros.registerComponent(macro : h2d.domkit.BaseComponents.BitmapComp);
			domkit.Macros.registerComponent(macro : h2d.domkit.BaseComponents.TextComp);
		}
		return null;
	}
	#end

}
