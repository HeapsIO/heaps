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

	/**
		Load and cache the font instance.

		Because font instance is cached, operations like `resizeTo` should be performed on a copy of the font, to avoid affecting other text fields.
	**/
	public function toFont() : h2d.Font {
		if ( font == null ) {
			font = hxd.fmt.bfnt.FontParser.parse(entry.getBytes(), entry.path, resolveTile);
		}
		return font;
	}

	/**
		Load and cache Signed Distance Field font with specified size, channel, alphaCutoff and smoothing. ( default : initial size, red, 0.5, -1 )
		For more information on SDF texture generation refer to this page: https://github.com/libgdx/libgdx/wiki/Distance-field-fonts
		For more information on MSDF texture generation refer to this page: https://github.com/Chlumsky/msdfgen

		Because font instance is cached, operations like `resizeTo` should be performed on a copy of the font, to avoid affecting other text fields.

		@param channel The channel that serves as distance data source.
		@param alphaCutoff The distance value that is considered to be the edge. Usually should be 0.5.
		@param smoothing The smoothing of edge. Lower value lead to sharper edges. Value of -1 sets it to automatic.
	**/
	public function toSdfFont(?size:Int, channel : h2d.Font.SDFChannel = 0, alphaCutoff : Float = 0.5, smoothing : Float = -1 ) {
		if ( sdfFonts == null ) sdfFonts = new Array();
		if ( size == null ) size = toFont().size;
		for ( font in sdfFonts ) {
			switch ( font.type ) {
				case SignedDistanceField(fchannel, falphaCutoff, fsmoothing):
					if (font.size == size && fchannel == channel && falphaCutoff == alphaCutoff && fsmoothing == smoothing ) {
						return font;
					}
				default:
			}
		}
		var font : h2d.Font = hxd.fmt.bfnt.FontParser.parse(entry.getBytes(), entry.path, resolveSdfTile);
		font.type = h2d.Font.FontType.SignedDistanceField(channel, alphaCutoff, smoothing);
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
