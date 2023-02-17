package hxd.res;

using StringTools;

/**
 * Intermediate representation of a glyph. Only used while
 * parsing a BDF font file.
 */
 class BDFFontChar {
	public var code : Int;
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var xoffset : Int;
	public var yoffset : Int;
	public var stride : Int;
	public var bits : Array<Int>;

	public function new( code, width, height, xoffset, yoffset, stride ) {
		this.code = code;
		this.width = width;
		this.height = height;
		this.xoffset = xoffset;
		this.yoffset = yoffset;
		this.stride = stride;
		this.bits = new Array();
	}

	static public function sortOnHeight( a : BDFFontChar, b : BDFFontChar ) {
		return b.height - a.height; // Largest first
	}
}

/**
 * Parse BDF font format to h2d.Font
 */
class BDFFont extends Resource {

	static inline var BitmapPad : Float = 0.1;
	static inline var BitmapMaxWidth : Int = 1024;
	static inline var ClearColor : Int = 0x000000FF;
	static inline var PixelColor : Int = 0x00FFFFFF;

	var font : h2d.Font;
	var bitsPerPixel : Int = 1;
	var ascent : Int = -1;
	var descent : Int = -1;
	var fbbHeight : Int = -1;
	var glyphData : Array<BDFFontChar>;

	/**
	 * Convert BDF resource to a h2d.Font instance
	 * @return h2d.Font The font
	 */
	@:access(h2d.Font)
	public function toFont() : h2d.Font {
		if ( font != null ) return font;

		// File starts with STARTFONT
		var text = entry.getText();
		if( !StringTools.startsWith(text,"STARTFONT") )
			throw 'File does not appear to be a BDF file. Expecting STARTFONT';

		// Init empty font
		font = new h2d.Font( null, 0 );

		// Break file into lines
		var lines = text.split("\n");
		var linenum = 0;

		// Parse the header
		linenum = parseFontHeader( lines, linenum );
		// Parse the glyphs
		linenum = parseGlyphs( lines, linenum );
		// Generate glyphs and bitmap
		generateGlyphs();

		// Return the generated font
		return font;
	}

	/**
	 * Extract what we can from the font header. Unlike other font formats supported by heaps, some
	 * of the values need to be infered from what is given (e.g. line height is not specificed directly,
	 * nor is baseline).
	 * @param lines		The remaining lines in the file
	 * @param linenum	The current line number
	 * @return Int		The final line number after processing header
	 */
	@:access(h2d.Font)
	function parseFontHeader( lines : Array<String>, linenum : Int ) : Int {
		var line : String;
		var prop : String;
		var args : Array<String>;

		// Iterate lines
		while ( lines.length > 0 ) {
			linenum++;

			line = lines.shift();
			args = line.trim().split(" ");
			if ( args.length == 0 ) continue;
			prop = args.shift().trim();

			switch ( prop ) {
				case 'FAMILY_NAME':
					font.name = extractStr( args );
				case 'SIZE':
					font.size = font.initSize = extractInt( args[0] );
				case 'BITS_PER_PIXEL':
					this.bitsPerPixel = extractInt( args[0] );
					if ( [1,2,4,8].indexOf( bitsPerPixel ) != -1 ) throw 'BITS_PER_PIXEL of $bitsPerPixel not supported, at line $linenum';
				case 'FONTBOUNDINGBOX':
					this.fbbHeight = extractInt( args[1] );
				case 'FONT_ASCENT':
					this.ascent = extractInt( args[0] );
				case 'FONT_DESCENT':
					this.descent = extractInt( args[0] );
				// Once we find STARTCHAR we know that the header is done. Stop processing lines and continue.
				case 'STARTCHAR':
					break;
			}
		}
		// Check we have everything we need
		if ( font.initSize == 0 ) throw 'SIZE not found or is 0';

		// Return linenum we are up to
		return linenum;
	}

	/**
	 * Extract glyph information from the file.
	 * @param lines		The remaining lines in the file
	 * @param linenum	The current line number
	 * @return Int		The final line number after processing header
	 */
	function parseGlyphs( lines : Array<String>, linenum : Int ) : Int {
		var line : String;
		var prop : String;
		var args : Array<String>;

		this.glyphData = new Array(); // Destroyed after generating bitmap

		var processingGlyphHeader : Bool = true;
		var encoding : Int = -1;
		var stride : Int = -1;
		var bbxFound : Bool = false;
		var bbxWidth : Int = 0;
		var bbxHeight : Int = 0;
		var bbxXOffset : Int = 0;
		var bbxYOffset : Int = 0;
		var expectedLines : Int = 0;
		var expectedBytesPerLine : Int = 0;
		var char : BDFFontChar = null;

		// Iterate lines
		while ( lines.length > 0 ) {
			linenum++;

			line = lines.shift();
			args = line.trim().split(" ");
			if ( args.length == 0 ) continue;
			prop = args.shift().trim();

			// Start by processing the glyph header
			if ( processingGlyphHeader ) {
				switch ( prop ) {
					case 'ENCODING':
						// XXX: Support encoding ranges. Not sure if they are common? Hacen't come across this yet
						if ( encoding != -1 ) throw 'Encoding ranges not supported, at line $linenum';
						encoding = extractInt( args[0] );
						if ( encoding < 1 ) throw 'ENCODING $encoding not supported, at line $linenum';
					case 'DWIDTH': // Device width
						stride = extractInt( args[0] );
						if ( stride < 0 ) throw 'DWIDTH is negative, at line $linenum';
						// XXX: This could be a warning and we could ignore the vertical step. Font might render weird?
						if ( extractInt( args[1] ) != 0 ) throw 'A non-0 DWIDTH is not supported (maybe vertical character set?), at line $linenum';
					case 'BBX': // Bounding box
						bbxFound = true;
						bbxWidth = extractInt( args[0] );
						bbxHeight = extractInt( args[1] );
						bbxXOffset = extractInt( args[2] );
						bbxYOffset = extractInt( args[3] );
						if ( bbxWidth < 0 ) throw 'BBX width is negative, line $linenum';
						if ( bbxHeight < 0 ) throw 'BBX height is negative, line $linenum';
					case 'BITMAP':
						if ( encoding < 0 ) throw 'missing ENCODING, line $linenum';
						if ( stride < 0 ) throw 'missing DWIDTH, line $linenum';
						if ( !bbxFound ) throw 'missing BBX, line $linenum';
						processingGlyphHeader = false;
						expectedLines = bbxHeight;
						expectedBytesPerLine = ( (bbxWidth * bitsPerPixel) + 7 ) >> 3;
						char = new BDFFontChar( encoding, bbxWidth, bbxHeight, bbxXOffset, bbxYOffset, stride );
				}
			} // header

			// Secondly, extract the bitmap data (will be processed later)
			else {
				// Extract data as long as we are still expecting some
				if ( (expectedLines > 0) && (expectedBytesPerLine > 0) ) {
					for ( i in 0...expectedBytesPerLine ) {
						char.bits.push( extractInt( '0x' + prop.substr( 0, 2 ) ) );
						prop = prop.substr( 2 );
					}
					expectedLines--;
				}
				// Otherwise we have finished reading bitmap data
				else {
					// Sanity check
					if ( prop != 'ENDCHAR' ) throw 'ENDCHAR expected, line $linenum';
					// Save the glyph data
					this.glyphData.push( char );
					// reset for next glyph
					processingGlyphHeader = true;
					encoding = -1;
					stride = -1;
					bbxFound = false;
				}
			} // glyphs

		} // lines

		// Return linenum we are up to
		return linenum;
	}

	/**
	 * We now have all glyphs and (unprocessed) bitmap data. We need to generate the bitmap in
	 * an efficient manner. This involves estimating the size of the canvas we need, and then
	 * tiling the glyphs into the bitmap.
	 */
	@:access(h2d.Font)
	function generateGlyphs() {
		// Firstly, sort glyphData by height
		glyphData.sort( BDFFontChar.sortOnHeight );

		// Calculate total volume, and from that an approx width and height if packing with 80%
		// efficiency (i.e. add a 10% buffer). This is from trial and error :)
		var volume : Int = 0;
		for ( d in glyphData ) volume += ( d.width * d.height );
		var bitmapWidth : Int = Math.ceil( Math.sqrt( volume * (1 + BitmapPad) ) );
		if ( bitmapWidth > BitmapMaxWidth ) throw 'The font bitmap is too big: ${bitmapWidth}x${bitmapWidth} (max ${BitmapMaxWidth}x${BitmapMaxWidth})';

		// Create the bitmap
		var bitmapData : hxd.BitmapData = new hxd.BitmapData( bitmapWidth, bitmapWidth );
		bitmapData.lock();
		bitmapData.clear( ClearColor ); // Blue, but transparent

		// Calculate values for extracting pixel data
		var bppMask : Int = 0x80;
		switch ( bitsPerPixel ) {
			case 2: bppMask = 0xC0;
			case 4: bppMask = 0xF0;
			case 8: bppMask = 0xFF;
		}
		var pixPerByte : Int = Math.floor( 8 / bitsPerPixel );
		var bppScale : Float = 255 / ((1 << bitsPerPixel) - 1);
		var pixLeftInByte : Int = 0;
		var pixBits : Int = 0;
		var pixAlpha : Int = 0;

		// Draw glyphs to bitmap in height order and save position on bitmap
		var x : Int = 0;
		var y : Int = 0;
		var found : Bool = false;
		for ( d in glyphData ) {
			found = false;

			// Wrap x if glyph will not fit in width
			if ( ( x + d.width ) > bitmapWidth ) x = 0;

			// Find nearest space big enough for glyph, left to right, top to bottom
			while ( x <= (bitmapWidth - d.width) ) {
				y = 0;
				while ( y <= (bitmapWidth - d.height) ) {
					// If top-left pixel is clear...
					if ( bitmapData.getPixel( x, y ) == ClearColor ) {
						found = true;
						// Check first row and first column are clear to ensure space is clear
						for ( xx in x...(x + d.width) ) {
							if ( bitmapData.getPixel( xx, y ) != ClearColor ) {
								found = false;
								break;
							}
						}
						if ( found ) {
							for ( yy in y...(y + d.height) ) {
								if ( bitmapData.getPixel( x, yy ) != ClearColor ) {
									found = false;
									break;
								}
							}
						}
						if ( found ) break;
					}
					y++;
				}
				if ( found ) break;
				x++;
			}

			// XXX: At this point it would be really good to see the bitmap (so far)
			if ( !found ) throw 'Glyphs are overflowing the bitmap. Help!';

			// Now have space that starts at x,y.
			// Draw the glyph to the bitmap and save position
			d.x = x; d.y = y;
			for ( yy in y...(y + d.height) ) {
				pixLeftInByte = 0;
				for ( xx in x...(x + d.width) ) {
					// Grab a new byte
					if ( pixLeftInByte == 0 ) {
						pixLeftInByte = pixPerByte;
						pixBits = d.bits.shift();
					}
					// Grab a pixel alpha
					pixAlpha = (pixBits & bppMask) >> (8 - bitsPerPixel);
					pixBits = pixBits << bitsPerPixel;
					// Calculate actual pixel value and set pixel
					pixAlpha = Math.floor( pixAlpha * bppScale ) << 24;
					bitmapData.setPixel( xx, yy, pixAlpha | PixelColor );
					// Advance
					pixLeftInByte--;
				}
			}

			// Advance the start position to after the bitmap
			x += d.width;
		}
		bitmapData.unlock();

		// Create tile from bitmap data
		font.tile = h2d.Tile.fromBitmap( bitmapData );

		// Generate glyphs
		for ( d in glyphData ) {
			// In BDF, y-offset is offset from baseline. In FNT it appears to be offset from top
			var t = font.tile.sub( d.x, d.y, d.width, d.height, d.xoffset, ascent - (d.height + d.yoffset) );
			var fc = new h2d.Font.FontChar( t, d.stride );
			font.glyphs.set( d.code, fc );
		}

		// Ensure space character exists
		if( font.glyphs.get( " ".code ) == null )
			font.glyphs.set( " ".code, new h2d.Font.FontChar( font.tile.sub( 0, 0, 0, 0 ), font.size >> 1 ) );

		// Set line height, or estimate it
		if ( (ascent >= 0) && (descent >= 0) )
			font.lineHeight = ascent + descent;
		else if ( fbbHeight >= 0 )
			font.lineHeight = fbbHeight;
		else{
			var a = font.glyphs.get( "E".code );
			if ( a == null )
				a = font.glyphs.get( "A".code );
			if ( a == null )
				font.lineHeight = font.size * 2;
			else
				font.lineHeight = a.t.height * 2;
		}

		// Estimate a baseline
		var space = font.glyphs.get( " ".code );
		var padding : Float = ( space.t.height * .5 );
		var a = font.glyphs.get( "A".code );
		if( a == null ) a = font.glyphs.get( "a".code );
		if( a == null ) a = font.glyphs.get( "0".code ); // numerical only
		if( a == null )
			font.baseLine = font.lineHeight - 2 - padding;
		else
			font.baseLine = a.t.dy + a.t.height - padding;

		// Set a fallback glyph
		var fallback = font.glyphs.get( 0xFFFD ); // <?>
		if( fallback == null )
			fallback = font.glyphs.get( 0x25A1 ); // square
		if( fallback == null )
			fallback = font.glyphs.get( "?".code );
		if( fallback == null )
			fallback = font.glyphs.get( " ".code );
		font.defaultChar = fallback;

		// Cleanup
		bitmapData.dispose();
		this.glyphData = null; // No longer required
	}

	/**
	 * Each line of the BDF file is split by spaces into an Array. Sometimes the
	 * line is actually a string and shouldn't be split. This method detects that
	 * by checking for "quote marks" and joining the string back up.
	 * @param p The split line
	 * @return String The resulting string
	 */
	inline function extractStr( p : Array<String> ) : String {
		if ( p[0].startsWith("\"") ) {
			var pj : String = p.join(" ").trim();
			return pj.substring( 1, pj.length - 1 );
		}
		return p[0];
	}

	/**
	 * Extract an integer from a string. if the string starts with 0x it is treated
	 * as hexidecimal, otherwise decimal.
	 * @param s     The string
	 * @return Int  The resulting integer
	 */
	inline function extractInt( s : String ) : Int {
		return Std.parseInt( s );
	}

}
