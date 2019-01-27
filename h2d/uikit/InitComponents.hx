package h2d.uikit;
import h2d.uikit.BaseComponents.CustomParser;

class InitComponents {

	#if macro
	public static function initOnce() : Array<haxe.macro.Expr.Field> {
		if( @:privateAccess uikit.Macros.COMPONENTS.get("object") == null ) {
			uikit.Macros.registerComponent(macro : h2d.uikit.BaseComponents.ObjectComp);
			uikit.Macros.registerComponent(macro : h2d.uikit.BaseComponents.DrawableComp);
			uikit.Macros.registerComponent(macro : h2d.uikit.BaseComponents.FlowComp);
			uikit.Macros.registerComponent(macro : h2d.uikit.BaseComponents.BitmapComp);
			uikit.Macros.registerComponent(macro : h2d.uikit.BaseComponents.TextComp);
		}
		return null;
	}
	#end

}
