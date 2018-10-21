package hxd.res;
#if (haxe_ver < 4)
import haxe.xml.Fast in Access;
#else
import haxe.xml.Access;
#end

class BitmapFont extends Resource {

	var loader : Loader;
	var font : h2d.Font;

	public function new(entry) {
		super(entry);
		this.loader = hxd.res.Loader.currentInstance;
	}

	@:access(h2d.Font)
	public function toFont() : h2d.Font {
		if ( font == null ) {
			font = hxd.fmt.bfnt.FontParser.parse(entry.getBytes(), entry.path, resolveTile);
		}
		return font;
	}

	function resolveTile(path:String) : h2d.Tile {
		return loader.load(path).toTile();
	}

}
