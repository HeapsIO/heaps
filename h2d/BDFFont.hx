package h2d;

import hxd.BitmapData;
import haxe.Int32;
import h2d.Font;

/**
 * Intermediate representation of a glyph. Only used while
 * parsing a BDF font file.
 */
class BDFFontChar{
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
    
    static public function sortOnHeight( a : BDFFontChar, b : BDFFontChar ){
        return b.height-a.height; // Largest first
    }
}

/**
 * A BDF font
 */
class BDFFont extends Font{

    private static inline var BitmapPad : Float = 0.1;
    private static inline var BitmapMaxWidth : Int = 1024;
    private static inline var ClearColor : Int32 = 0x000000FF;
    private static inline var PixelColor : Int32 = 0x00FFFFFF;

    var bitsPerPixel : Int = 1;
    var ascent : Int = -1;
    var descent : Int = -1;
    var fbbHeight : Int = -1;
    var glyphData : Array<BDFFontChar>;

    /**
     * Create a new BDF font
     * @param bytes The BDF font file. Can pass in null and call fromFile later.
     */
    public function new( bytes : haxe.io.Bytes ) {
        super(null,0);
        if (bytes!=null) this.fromFile( bytes );
    }

    /**
     * Parse BDF font file into a bitmap font format supported by heaps. A BDF font is a text-based
     * font format that also contains the byte data (i.e. does not have a seperate PNG). It can support
     * smooth fonts with varying antialias levels.
     * Parsing the font file works in 3 steps:
     * 1) Parse the header to get general font information
     * 2) Parse the glyph data to get all the character information
     * 3) Generate bitmap for the glyphs
     * The first two are trivial. Step 3 would also be trivial if we were willing to sacrifce memory
     * and just give each glyph the same space as the largest glyph. However, we attempt to alculate
     * the minimum texture size and pack the character glyphs in with the least amount of waste. Fun. 
     * @param bytes The BDF font file
     */
    public function fromFile( bytes : haxe.io.Bytes ){
        // File starts with STARTFONT
        if ((bytes.getInt32(0)!=0x52415453)||(bytes.getInt32(8)!=0x2E322054))
            throw "File does not appear to be a BDF file. Should start with STARTFONT";

        // Break file into lines
        var lines = bytes.toString().split("\n");
        var linenum = 0;

        // Parse the header
        linenum = parseFontHeader(lines, linenum);
        // Parse the glyphs
        linenum = parseGlyphs(lines, linenum);
        // Generate glyphs and bitmap
        generateGlyphs();
    }

    /**
     * Extract what we can from teh font header. Unlike other font formats supported by heaps, some
     * of the values need to be infered from what is given (e.g. line height is not specificed directly,
     * nor is baseline).
     * @param lines     The remaining lines in the file
     * @param linenum   The current line number
     * @return Int      The final line number after processing header
     */
    private function parseFontHeader( lines : Array<String>, linenum : Int ) : Int{
        var line : String;
        var prop : String;
        var args : Array<String>;

        // Iterate lines
        while (lines.length>0){
            linenum++;

            line = lines.shift();
            args = StringTools.trim(line).split(" ");
            if (args.length==0) continue;
            prop = StringTools.trim(args.shift());

            switch (prop){
                case 'FAMILY_NAME':{
                    this.name = extractStr(args);
                }
                case 'SIZE':{
                    this.size = this.initSize = extractInt(args[0]);
                }
                case 'BITS_PER_PIXEL':{
                    this.bitsPerPixel = extractInt(args[0]);
                    if (!Lambda.has([1,2,4,8],bitsPerPixel)) throw('BITS_PER_PIXEL of '+bitsPerPixel+' not supported, at line '+linenum);
                }
                case 'FONTBOUNDINGBOX':{
                    this.fbbHeight = extractInt(args[1]);
                }
                case 'FONT_ASCENT':{
                    this.ascent = extractInt(args[0]);
                }
                case 'FONT_DESCENT':{
                    this.descent = extractInt(args[0]);
                }
                // Once we find STARTCHAR we know that the header is done. Stop
                // processing lines and continue.
                case 'STARTCHAR':{
                    break;
                }
                    
            }
            

        }
        // Check we have everything we need
        if (this.initSize==0) throw('SIZE not found or is 0');

        // Return linenum we are up to
        return linenum;
    }

    /**
     * Extract glyph information from the file.
     * @param lines     The remaining lines in the file
     * @param linenum   The current line number
     * @return Int      The final line number after processing header
     */
    private function parseGlyphs( lines : Array<String>, linenum : Int ) : Int{
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
        while (lines.length>0){
            linenum++;

            line = lines.shift();
            args = StringTools.trim(line).split(" ");
            if (args.length==0) continue;
            prop = StringTools.trim(args.shift());

            // Start by processing the glyph header
            if (processingGlyphHeader){
                switch (prop){
                    case 'ENCODING':{
                        // XXX: Support encoding ranges. Not sure if they are common? Hacen't come across this yet
                        if (encoding!=-1) throw ('Encoding ranges not supported, at line '+linenum);
                        encoding = extractInt(args[0]);
                        if (encoding<1) throw('ENCODING '+encoding+' not supported, at line '+linenum);
                    }
                    case 'DWIDTH':{ // Device width
                        stride = extractInt(args[0]);
                        if (stride<0) throw('DWIDTH is negative, at line '+linenum);
                        // XXX: This could be a warning and we could ignore the vertical step. Font might render weird?
                        if (extractInt(args[1])!=0) throw('A non-0 DWIDTH is not supported (maybe vertical character set?), at line '+linenum);
                    }
                    case 'BBX':{
                        bbxFound = true;
                        bbxWidth = extractInt(args[0]);
                        bbxHeight = extractInt(args[1]);
                        bbxXOffset = extractInt(args[2]);
                        bbxYOffset = extractInt(args[3]);
                        if (bbxWidth < 0) throw('BBX width is negative, line '+linenum);
                        if (bbxHeight < 0) throw('BBX height is negative, line '+linenum);
                    }
                    case 'BITMAP':{
                        if (encoding<0) throw('missing ENCODING, line '+linenum);
                        if (stride<0) throw('missing DWIDTH, line '+linenum);
                        if (!bbxFound) throw('missing BBX, line '+linenum);
                        processingGlyphHeader = false;
                        expectedLines = bbxHeight;
                        expectedBytesPerLine = ((bbxWidth * bitsPerPixel) + 7) >> 3;
                        char = new BDFFontChar( encoding, bbxWidth, bbxHeight, bbxXOffset, bbxYOffset, stride );
                    }
                }
            } // header

            // Secondly, extract the bitmap data (will be processed later)
            else{
                // Extract data as long as we are still expecting some
                if ((expectedLines > 0) && (expectedBytesPerLine > 0)){
                    for (i in 0...expectedBytesPerLine) {
                        char.bits.push( extractInt('0x'+prop.substr(0,2)) );
                    
                        prop = prop.substr(2);
                    }
                    expectedLines--;
                }
                // Otherwise we have finished reading bitmap data
                else{
                    // Sanity check
                    if (prop != 'ENDCHAR') throw('ENDCHAR expected, line '+linenum);
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
    private function generateGlyphs(){
        // Firstly, sort glyphData by height
        glyphData.sort( BDFFontChar.sortOnHeight );

        // Calculate total volume, and from that an approx width and height if packing with 80%
        // efficiency (i.e. add a 10% buffer). This is from trial and error :)
        var volume : Int = 0;
        for (d in glyphData) volume += (d.width*d.height);
        var bitmapWidth : Int32 = Math.ceil(Math.sqrt(volume*(1+BitmapPad)));
        if (bitmapWidth>BitmapMaxWidth) throw('The font bitmap is too big: '+bitmapWidth+'x'+bitmapWidth+' (max '+BitmapMaxWidth+'x'+BitmapMaxWidth+')');
        
        // Create the bitmap
        var bitmapData : BitmapData = new BitmapData( bitmapWidth, bitmapWidth );
        bitmapData.lock();
        bitmapData.clear(ClearColor); // Blue, but transparent

        // Calculate values for extracting pixel data
        var bppMask : Int = 0x80;
        switch (bitsPerPixel){
            case 2: bppMask = 0xC0;
            case 4: bppMask = 0xF0;
            case 8: bppMask = 0xFF;
        }
        var pixPerByte : Int = Math.floor(8/bitsPerPixel);
        var bppScale : Float = 255/((1 << bitsPerPixel)-1);
        var pixLeftInByte : Int = 0;
        var pixBits : Int = 0;
        var pixAlpha : Int32 = 0;

        // Draw glyphs to bitmap in height order and save position on bitmap
        var x : Int = 0;
        var y : Int = 0;
        var found : Bool = false;
        for (d in glyphData){
            found = false;

            // Wrap x if glyph will not fit in width
            if ((x+d.width) > bitmapWidth) x = 0;

            // Find nearest space big enough for glyph, left to right, top to bottom
            while (x<=(bitmapWidth-d.width)){
                y = 0;
                while (y<=(bitmapWidth-d.height)){
                    // If top-left pixel is clear...
                    if (bitmapData.getPixel(x,y)==ClearColor){
                        found = true;
                        // Check first row and first column are clear to ensure space is clear
                        for (xx in x...(x+d.width)){
                            if (bitmapData.getPixel(xx,y)!=ClearColor){
                                found = false;
                                break;
                            }
                        }
                        if (found){
                            for (yy in y...(y+d.height)){
                                if (bitmapData.getPixel(x,yy)!=ClearColor){
                                    found = false;
                                    break;
                                }
                            }
                        }
                        if (found) break;
                    }
                    y++;
                }
                if (found) break;
                x++;
            }

            // XXX: At this point it would be really good to see the bitmap (so far)
            if (!found) throw('Glyphs are overflowing the bitmap. Help!');

            // Now have space that starts at x,y.
            // Draw the glyph to the bitmap and save position
            d.x = x; d.y = y;
            for (yy in y...(y+d.height)){
                pixLeftInByte = 0;
                for (xx in x...(x+d.width)){
                    // Grab a new byte
                    if (pixLeftInByte==0){
                        pixLeftInByte = pixPerByte;
                        pixBits = d.bits.shift();
                    }
                    // Grab a pixel alpha
                    pixAlpha = (pixBits & bppMask) >> (8-bitsPerPixel);
                    pixBits = pixBits << bitsPerPixel;
                    // Calculate actual pixel value and set pixel
                    pixAlpha = Math.floor( pixAlpha * bppScale) << 24;
                    bitmapData.setPixel( xx, yy, pixAlpha | PixelColor);
                    // Advance
                    pixLeftInByte--;
                }
            }

            // Advance the start position to after the bitmap
            x += d.width;
        }
        bitmapData.unlock();

        // Create tile from bitmap data
        this.tile = h2d.Tile.fromBitmap(bitmapData);

        // Generate glyphs
        for (d in glyphData){
            // In BDF, y-offset is offset from baseline. In FNT it appears to be offset from top
            var t = tile.sub(d.x, d.y, d.width, d.height, d.xoffset, ascent-(d.height+d.yoffset) );
			var fc = new h2d.Font.FontChar(t, d.stride);
			glyphs.set(d.code, fc);
        }

        // Ensure space character exists
        if( glyphs.get(" ".code) == null )
            glyphs.set(" ".code, new h2d.Font.FontChar(tile.sub(0, 0, 0, 0), this.size>>1));

        // Set line height, or estimate it
        if ((ascent>=0) && (descent>=0))
            this.lineHeight = ascent + descent;
        else if ((fbbHeight>=0))
            this.lineHeight = fbbHeight;
        else{
            var a = glyphs.get("E".code);
            if ( a == null )
                a = glyphs.get("A".code);
            if (a==null)
                this.lineHeight = this.size * 2;
            else
                this.lineHeight = a.t.height * 2; 
        }
        
        // Estimate a baseline
        var space = glyphs.get(" ".code);
        var padding : Float = (space.t.height * .5);
        var a = glyphs.get("A".code);
        if( a == null ) a = glyphs.get("a".code);
        if( a == null ) a = glyphs.get("0".code); // numerical only
        if( a == null )
            this.baseLine = this.lineHeight - 2 - padding;
        else
            this.baseLine = a.t.dy + a.t.height - padding;

        // Set a fallback glyph
        var fallback = glyphs.get(0xFFFD); // <?>
		if( fallback == null )
			fallback = glyphs.get(0x25A1); // square
		if( fallback == null )
            fallback = glyphs.get("?".code);
        if( fallback == null )
            fallback = glyphs.get(" ".code);
        this.defaultChar = fallback;
        
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
    private function extractStr( p : Array<String> ) : String {
        if (StringTools.startsWith(p[0],'"')){
            p[0] = p[0].substr(1);
            p[p.length-1] = p[p.length-1].substr(0,p[p.length-1].length-1);
            return p.join(' ');
        }
        return p[0];
    }

    /**
     * Extract an integer from a string. if the string starts with 0x it is treated
     * as hexidecimal, otherwise decimal.
     * @param s     The string
     * @return Int  The resulting integer
     */
    private function extractInt( s : String ) : Int{
        return Std.parseInt(s);
    }

}