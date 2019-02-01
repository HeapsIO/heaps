package h2d.domkit;
import h2d.domkit.BaseComponents.CustomParser;

class InitComponents {
	public static function init() {
		domkit.Macros.registerComponentsPath("h2d.domkit.BaseComponents.$Comp");
		domkit.Macros.registerComponentsPath("$Comp");
		return null;
	}
}
