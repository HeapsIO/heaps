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

	public static function build() {
		var fields = domkit.Macros.buildObject();
		for( f in fields )
			if( f.name == "document" ) {
				fields = fields.concat((macro class {
					override function onRemove() {
						super.onRemove();
						var style = Std.instance(document.style, h2d.domkit.Style);
						if( style != null ) @:privateAccess style.remove(this);
					}
				}).fields);
				break;
			}
		return fields;
	}
}
