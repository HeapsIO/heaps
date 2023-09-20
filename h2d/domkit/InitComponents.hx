package h2d.domkit;
import h2d.domkit.BaseComponents.CustomParser;

class InitComponents {

	public static function init() {
		domkit.Macros.registerComponentsPath("h2d.domkit.BaseComponents.$Comp");
		domkit.Macros.registerComponentsPath("$Comp");
		if( domkit.Macros.defaultParserPath == null )
			domkit.Macros.setDefaultParser("h2d.domkit.BaseComponents.CustomParser");
		// force base components to be built before custom components
		@:privateAccess domkit.Macros.preload = [
			for( o in ["Object", "Drawable", "Video", "Bitmap", "Text", "HtmlText", "Flow", "Mask", "ScaleGrid", "Input"] )
				'h2d.domkit.BaseComponents.${o}Comp'
		];
		return null;
	}

	public static function build() {
		return domkit.Macros.buildObject();
	}
}
