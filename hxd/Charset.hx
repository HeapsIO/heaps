package hxd;

class Charset {

	/**
		Contains the whole ASCII charset.
	**/
	public static var ASCII = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

	/**
		The Latin1 (ISO 8859-1) charset (only the extra chars, no the ASCII part) + euro symbol
	**/
	public static var LATIN1 = "¡¢£¤¥¦§¨©ª«¬-®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿœæŒÆ€";

	/**
		Russian support
	**/
	public static var CYRILLIC = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяҐЄІЇґєії—";
	/**
		Polish support
	**/
	public static var POLISH = "ĄĆĘŁŃÓŚŹŻąćęłńóśźż";

	/**
		Turkish support
	**/
	public static var TURKISH = "ÂÇĞIİÎÖŞÜÛâçğıİîöşüû";

	/**
		Contains Hiragana, Katanaga, japanese punctuaction and full width space (0x3000) full width numbers (0-9) and some full width ascii punctuation (!:?%&()-). Does not include full width A-Za-z.
	**/
	public static var JP_KANA = "　あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゃゅょアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴャぇっッュョァィゥェォ・ー「」、。『』“”！：？％＆（）－０１２３４５６７８９";

	/**
		Special unicode chars (fallback chars)
	**/
	public static var UNICODE_SPECIALS = "�□";


	public static var DEFAULT_CHARS = ASCII + LATIN1;

	var map : Map<Int,Int>;

	function new() {
		map = new Map();
		inline function m(a, b) {
			map.set(a, b);
		}
		// fullwidth unicode to ASCII (if missing)
		for( i in 0...0x5E )
			m(0xFF01 + i, 0x21 + i);
		// Latin1 accents
		for( i in "À".code..."Æ".code + 1 )
			m(i, "A".code);
		for( i in "à".code..."æ".code + 1 )
			m(i, "a".code);
		for( i in "È".code..."Ë".code + 1 )
			m(i, "E".code);
		for( i in "è".code..."ë".code + 1 )
			m(i, "e".code);
		for( i in "Ì".code..."Ï".code + 1 )
			m(i, "I".code);
		for( i in "ì".code..."ï".code + 1 )
			m(i, "i".code);
		for( i in "Ò".code..."Ö".code + 1 )
			m(i, "O".code);
		for( i in "ò".code..."ö".code + 1 )
			m(i, "o".code);
		for( i in "Ù".code..."Ü".code + 1 )
			m(i, "U".code);
		for( i in "ù".code..."ü".code + 1 )
			m(i, "u".code);
		m("Ç".code, "C".code);
		m("ç".code, "C".code);
		m("Ð".code, "D".code);
		m("Þ".code, "d".code);
		m("Ñ".code, "N".code);
		m("ñ".code, "n".code);
		m("Ý".code, "Y".code);
		m("ý".code, "y".code);
		m("ÿ".code, "y".code);
		m("€".code, "E".code);
		// unicode spaces
		m(0x3000, 0x20); // full width space
		m(0xA0, 0x20); // nbsp
		// unicode quotes
		m("«".code, '"'.code);
		m("»".code, '"'.code);
		m("“".code, '"'.code);
		m("”".code, '"'.code);
		m("„".code, '"'.code);
		m("‘".code, "'".code);
		m("’".code, "'".code);
		m("´".code, "'".code);
		m("‘".code, "'".code);
		m("‹".code, "<".code);
		m("›".code, ">".code);
		m("–".code, "-".code);
	}

	public function resolveChar<T>( code : Int, glyphs : Map<Int,T> ) : Null<T> {
		var c : Null<Int> = code;
		while( c != null ) {
			var g = glyphs.get(c);
			if( g != null ) return g;
			c = map.get(c);
		}
		return null;
	}

	public function isCJK(code) {
		// ID class line-break characters based off Unicode specification.
		// Ref: https://www.unicode.org/reports/tr14/tr14-34.html#ID
		#if accurate_cjk_detection
		return (code >= 0x2E80 && code <= 0x2FFF) || // CJK, Kangxi Radicals, Ideographic Description Symbols
					 (code >= 0x3040 && code <= 0x309F) || // Hiragana (except small characters)
					 (code >= 0x30A0 && code <= 0x30FF) || // Katakana (except small characters)
					 (code >= 0x3400 && code <= 0x4DBF) || // CJK Unified Ideographs Extension A
					 (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified Ideographs
					 (code >= 0xF900 && code <= 0xFAFF) || // CJK Compatibility Ideographs
					 (code >= 0xA000 && code <= 0xA48F) || // Yi Syllables
					 (code >= 0xA490 && code <= 0xA4CF) || // Yi Radicals
					 (code >= 0xFE64 && code <= 0xFE66) || // SMALL PLUS SIGN..SMALL EQUALS SIGN
					 (code >= 0xFF01 && code <= 0xFF5A) || // Fullwidth Latin letters and digits
					 (code >= 0x20000 && code <= 0x3FFFD); // CJK Unified Ideographs Extension B-E, CJK Compatibility Ideographs Supplement, SIP (Plane 2) and TIP (Plane 3)
		#else
		// Simpler and less accurate SJK detection, but faster due to less compares.
		return (code >= 0x2E80 && code <= 0xA4CF) || (code >= 0xF900 && code <= 0xFAFF) || (code >= 0x20000 && code <= 0x3FFFD);
		#end

	}

	public function isSpace(code) {
		return code == ' '.code || code == 0x3000;
	}

	public function isBreakChar(code) {
		return isSpace(code) || isCJK(code);
	}

	static var complementChars : Map<Int,Bool> = {
		var str = "ヽヾーァィゥェォッャュョヮヵヶぁぃぅぇぉっゃゅょゎゕゖㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ々〻。，、；：！？";
		[for( i in 0...str.length ) str.charCodeAt(i) => true];
	}

	public function isComplementChar(code) {
		return complementChars.exists(code);
	}

	/**
		The character starting at `i` in `s`: a whole code point where `i` starts a surrogate pair
		(UTF-16 strings, e.g. HashLink and JS), otherwise the unit at `i` (a lone surrogate stays itself).
		`charLength` gives how many units it takes.
	**/
	public static inline function codeAt( s : String, i : Int ) : Int {
		var c = StringTools.fastCodeAt(s, i);
		if( c >= 0xD800 && c <= 0xDBFF && i + 1 < s.length ) {
			var d = StringTools.fastCodeAt(s, i + 1);
			if( d >= 0xDC00 && d <= 0xDFFF )
				c = 0x10000 + ((c - 0xD800) << 10) + (d - 0xDC00);
		}
		return c;
	}

	/** Units taken in `s` at `i` by `code`, the result of `codeAt(s, i)`: 2 for a surrogate pair, else 1. **/
	public static inline function charLength( s : String, i : Int, code : Int ) : Int {
		return code > 0xFFFF && StringTools.fastCodeAt(s, i) != code ? 2 : 1;
	}

	/**
		True for characters that only modify the one before them and are drawn with no glyph and no
		width: zero width (non-)joiner, variation selectors (emoji vs. text style) and tag characters
		(subdivision flags). Without shaping, the characters they join draw side by side.
	**/
	public static function isZeroWidth( code : Int ) : Bool {
		return code == 0x200C || code == 0x200D
			|| (code >= 0xFE00 && code <= 0xFE0F)
			|| (code >= 0xE0020 && code <= 0xE007F)
			|| (code >= 0xE0100 && code <= 0xE01EF);
	}

	/**
		The end (exclusive) of the cluster starting at `i` in `s` (`i < s.length`): the text that lays
		out, wraps and takes the caret as one character. One code point, extended by what modifies it
		(UTS #51 emoji sequences): variation selectors, emoji modifiers (skin tones), the keycap mark
		U+20E3, tag characters, ideographic variation selectors, and a ZWJ with the emoji after it
		(a family; a ZWJ before anything else stays on this cluster alone); a regional indicator pairs with the one after it (a flag). Everything else is a
		cluster of one code point, so text without these characters lays out as before.
	**/
	public static function clusterEnd( s : String, i : Int ) : Int {
		var len = s.length;
		var c = codeAt(s, i);
		var p = i + charLength(s, i, c);
		var flag = isRegionalIndicator(c);
		while( p < len ) {
			var d = codeAt(s, p);
			var n = charLength(s, p, d);
			if( (d >= 0xFE00 && d <= 0xFE0F) || (d >= 0x1F3FB && d <= 0x1F3FF) || d == 0x20E3
				|| (d >= 0xE0020 && d <= 0xE007F) || (d >= 0xE0100 && d <= 0xE01EF) ) {
				p += n;
			} else if( d == 0x200D ) {
				p += n;
				if( p < len ) {
					var e = codeAt(s, p);
					if( isPictographic(e) ) p += charLength(s, p, e);
				}
			} else if( flag && isRegionalIndicator(d) ) {
				flag = false;
				p += n;
			} else
				break;
		}
		return p;
	}

	/**
		Whether `c` may follow a ZWJ in an emoji sequence: the symbol blocks that hold
		Extended_Pictographic (arrows, technical, geometric shapes, dingbats, misc symbols, the
		U+1Fxxx emoji planes, (c) and (R)). A superset of that property with no letters, digits
		or spaces, so a ZWJ in Indic or Arabic text never joins the letter after it.
	**/
	static function isPictographic( c : Int ) : Bool {
		return c == 0xA9 || c == 0xAE || c == 0x203C || c == 0x2049 || c == 0x2122 || c == 0x2139
			|| (c >= 0x2190 && c <= 0x21FF) || (c >= 0x2300 && c <= 0x23FF) || c == 0x24C2
			|| (c >= 0x25A0 && c <= 0x27BF) || c == 0x2934 || c == 0x2935 || (c >= 0x2B00 && c <= 0x2BFF)
			|| c == 0x3030 || c == 0x303D || c == 0x3297 || c == 0x3299 || (c >= 0x1F000 && c <= 0x1FFFF);
	}

	/**
		True when `[start, end)` of `s` holds an emoji sequence marker: U+FE0F (emoji style), the keycap
		mark, an emoji modifier, ZWJ, a regional indicator or a tag character. Such a cluster is drawn
		from the OS emoji font as one picture. Not for ideographic or text-style (U+FE0E) selectors.
	**/
	public static function isEmojiCluster( s : String, start : Int, end : Int ) : Bool {
		var i = start;
		while( i < end ) {
			var c = codeAt(s, i);
			if( c == 0xFE0F || c == 0x20E3 || c == 0x200D || (c >= 0x1F3FB && c <= 0x1F3FF)
				|| isRegionalIndicator(c) || (c >= 0xE0020 && c <= 0xE007F) )
				return true;
			i += charLength(s, i, c);
		}
		return false;
	}

	static inline function isRegionalIndicator( c : Int ) {
		return c >= 0x1F1E6 && c <= 0x1F1FF;
	}

	static var inst : Charset;
	public static function getDefault() {
		if( inst == null ) inst = new Charset();
		return inst;
	}

}