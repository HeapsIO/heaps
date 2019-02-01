package h2d.domkit;
import h2d.domkit.BaseComponents.CustomParser;

class InitComponents {

	public static function init() {
		domkit.Macros.registerComponentsPath("h2d.domkit.BaseComponents.$Comp");
		domkit.Macros.registerComponentsPath("$Comp");
		return null;
	}

	public static function register() {
		var fields = haxe.macro.Context.getBuildFields();
		//var file = haxe.macro.Context.getPosInfos(haxe.macro.Context.currentPos()).file;
		fields = fields.concat((macro class {
			override function onRemove() {
				super.onRemove();
				var style = Std.instance(document.style, h2d.domkit.Style);
				if( style != null ) @:privateAccess style.remove(this);
			}
		}).fields);
		return fields;
	}
}
