package hxd.res;
#if (haxe_ver < 4)
import haxe.xml.Fast in Access;
#else
import haxe.xml.Access;
#end

class BitmapFont extends Resource {

	var loader : Loader;
	var font : h2d.Font;
	var sdfFonts:Array<h2d.Font>;

	public function new( entry ) {
		super(entry);
		this.loader = hxd.res.Loader.currentInstance;
	}

	public function toFont() : h2d.Font {
		if ( font == null ) {
			font = hxd.fmt.bfnt.FontParser.parse(entry.getBytes(), entry.path, resolveTile);
		}
		return font;
	}

	/**
		Load and cache Signed Distance Field font with specified size, channel, buffer and gamma. ( default : initial size, red, 0.5, 1 / 32 )
		For more information on SDF texture generation refer to this page: https://github.com/libgdx/libgdx/wiki/Distance-field-fonts
		For more information on MSDF texture generation refer to this page: https://github.com/Chlumsky/msdfgen
	**/
	public function toSdfFont(?size:Int, channel : h3d.shader.SignedDistanceField.SDFChannel = 0, buffer : Float = 0.5, gamma : Float = 1 / 32 ) {
		if ( sdfFonts == null ) sdfFonts = new Array();
		if ( size == null ) size = toFont().size;
		for ( font in sdfFonts ) {
			switch ( font.type ) {
				case SignedDistanceField(fchannel, fbuffer, fgamma):
					if (font.size == size && fchannel == channel && fbuffer == buffer && fgamma == gamma ) {
						return font;
					}
				default:
			}
		}
		var font : h2d.Font = hxd.fmt.bfnt.FontParser.parse(entry.getBytes(), entry.path, resolveSdfTile);
		font.type = h2d.Font.FontType.SignedDistanceField(channel, buffer, gamma);
		font.resizeTo(size);
		sdfFonts.push(font);
		return font;
	}

	function resolveSdfTile( path : String ) : h2d.Tile {
		var tex = loader.load(path).toTexture();
		tex.filter = Linear;
		return h2d.Tile.fromTexture(tex);
	}

	function resolveTile( path : String ) : h2d.Tile {
		return loader.load(path).toTile();
	}

}
