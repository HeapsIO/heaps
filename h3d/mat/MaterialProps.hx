package h3d.mat;

#if !macro

typedef MaterialProps = haxe.macro.MacroType<[h3d.mat.MaterialProps.Macros.getDefinition()]>;

#else

class Macros {
	public static function getDefinition() {
		// using getType() will create haxe assert
		try {
			if( haxe.macro.Context.resolvePath("MaterialProps.hx").indexOf("h3d.mat") < 0 )
				return macro : std.MaterialProps;
		} catch( e : Dynamic ) {
		}
		return macro : DefaultMaterialProps;
	}
}

#end

