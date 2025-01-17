package hxd.fmt.bfnt;

import h2d.Font.FontChar;
import haxe.Json;
using thx.Arrays;

typedef JsonFontAtlas = {
	var type:String;
	var distanceRange:Int;
    var size:Int;
	var width:Int;
	var height:Int;
}

typedef JsonFontMetrics = {
	var emSize:Float;
	var lineHeight:Float;
	var ascender:Float;
	var descender:Float;
	var underlineY:Float;
	var underlineThickness:Float;
}

typedef JsonFontBounds = {
	var left:Float;
	var bottom:Float;
	var right:Float;
	var top:Float;
}

typedef JsonFontGlyph = {
	var unicode:Int;
	var advance:Float;
	var planeBounds:JsonFontBounds;
	var atlasBounds:JsonFontBounds;
}


typedef JsonFontFormat = {
	var atlas:JsonFontAtlas;
	var metrics:JsonFontMetrics;
	var glyphs:Array<JsonFontGlyph>;
}

@:access(h2d.Font)
class JsonFontParser {

	public static inline function parse(bytes : haxe.io.Bytes,tile) : h2d.Font {
        final font = new h2d.Font(null,0);
        final glyphs = font.glyphs;
        font.tile = tile;

        final data:JsonFontFormat = Json.parse(bytes.getString(0,bytes.length));

        font.size = data.atlas.size;
		font.initSize = font.size;
        font.distanceRange = data.atlas.distanceRange;
        font.fieldType = data.atlas.type;

        font.lineHeight = data.metrics.lineHeight * data.atlas.size * 0.5;

		for(glyph in data.glyphs)
		{
			final xadvance = data.atlas.size * glyph.advance;
			if(glyph.atlasBounds != null && glyph.planeBounds != null) {
				final x = glyph.atlasBounds.left;
				final y = data.atlas.height - glyph.atlasBounds.top;
				final width = glyph.atlasBounds.right - glyph.atlasBounds.left;
				final height = glyph.atlasBounds.top - glyph.atlasBounds.bottom;

				final offsetX = glyph.planeBounds.left * data.atlas.size;
				final offsetY = glyph.planeBounds.top * data.atlas.size;

				final subTile = tile.sub(x,y,width,height,offsetX,-offsetY + data.atlas.size);
				glyphs.set(glyph.unicode,new FontChar(subTile,xadvance));
			} else {
				final subTile = tile.sub(0,0,1,1,0,0);
				glyphs.set(glyph.unicode,new FontChar(subTile,xadvance));
			}
	
		}

		return font;
	}

}