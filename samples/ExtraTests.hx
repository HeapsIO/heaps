
class CheckMacroCompilation {

	// check correct compilation of these files in macro mode
	//var t : h2d.Tile;
	//var tex : h3d.mat.Texture;

	public static function check() {
		return macro null;
	}
}

#if !macro
class ExtraTests extends hxd.App {

	override function init() {
		CheckMacroCompilation.check();
	}

	static function main() {
		new ExtraTests();
	}

}
 #end