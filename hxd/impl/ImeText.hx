package hxd.impl;

/**
	Helpers for text input / IME composition: code point splitting and conversion of
	native cursor offsets (code points or UTF-16 units) into Haxe string (UTF-16) indices.
**/
class ImeText {

	static inline function isHigh( c : Int ) return c >= 0xD800 && c <= 0xDBFF;
	static inline function isLow( c : Int ) return c >= 0xDC00 && c <= 0xDFFF;

	/**
		Splits a string into Unicode code points. Surrogate pairs are combined, a lone surrogate is passed through as itself.
	**/
	public static function codePoints( s : String ) : Array<Int> {
		var out : Array<Int> = [];
		var i = 0;
		var n = s.length;
		while( i < n ) {
			var c = s.charCodeAt(i++);
			if( isHigh(c) && i < n ) {
				var d = s.charCodeAt(i);
				if( isLow(d) ) {
					i++;
					c = 0x10000 + ((c - 0xD800) << 10) + (d - 0xDC00);
				}
			}
			out.push(c);
		}
		return out;
	}

	/**
		Converts a native offset (`raw`, in UTF-16 units if `rawIsUtf16` else in code points) to an index in `s`.
		A negative `raw` means "end of string". The result is clamped to `[0, s.length]` and never falls inside a surrogate pair.
	**/
	public static function toUtf16Index( s : String, raw : Int, rawIsUtf16 : Bool ) : Int {
		var n = s.length;
		if( raw < 0 ) return n;
		var i = 0;
		if( rawIsUtf16 ) {
			i = raw > n ? n : raw;
			if( i > 0 && i < n && isHigh(s.charCodeAt(i - 1)) && isLow(s.charCodeAt(i)) )
				i++;
			return i;
		}
		var cp = 0;
		while( cp < raw && i < n ) {
			var c = s.charCodeAt(i++);
			if( isHigh(c) && i < n && isLow(s.charCodeAt(i)) ) i++;
			cp++;
		}
		return i;
	}

	/**
		Converts a native length starting at native offset `start` into a length in UTF-16 units. A negative `raw` gives 0.
	**/
	public static function toUtf16Length( s : String, start : Int, raw : Int, rawIsUtf16 : Bool ) : Int {
		if( raw < 0 ) return 0;
		var a = toUtf16Index(s, start, rawIsUtf16);
		var b = toUtf16Index(s, start + raw, rawIsUtf16);
		return b > a ? b - a : 0;
	}

}
