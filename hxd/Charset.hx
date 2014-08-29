package hxd;

class Charset {

	/**
		Contains Hiragana, Katanaga, japanese punctuaction and full width space (0x3000) full width numbers (0-9) and some full width ascii punctuation (!:?%&()-). Does not include full width A-Za-z.
	**/
	public static var JP_KANA = "　あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゃゅょアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴャぇっッュョァィゥェォ・ー「」、。『』“”！：？％＆（）－０１２３４５６７８９";

	/**
		Contains the whole ASCII charset.
	**/
	public static var ASCII = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

	/**
		The Latin1 (ISO 8859-1) charset (only the extra chars, no the ASCII part)
	**/
	public static var LATIN1 = "¡¢£¤¥¦§¨©ª«¬-®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ";

	public static var DEFAULT_CHARS = ASCII + LATIN1;

	var map : Map<Int,Int>;

	function new() {
		map = new Map();
		inline function m(a, b) {
			map.set(a, b);
		}
		// fullwidth unicode to ASCII (if missing)
		for( i in 1...0x5E )
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
		// unicode spaces
		m(0x3000, 0x20); // full width space
		m(0xA0, 0x20); // nbsp
		// unicode quotes
		m("«".code, '"'.code);
		m("»".code, '"'.code);
		m("“".code, '"'.code);
		m("”".code, '"'.code);
		m("‘".code, "'".code);
		m("’".code, "'".code);
		m("´".code, "'".code);
		m("‘".code, "'".code);
		m("‹".code, "<".code);
		m("›".code, ">".code);
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

	public function isSpace(code) {
		return code == ' '.code || code == 0x3000;
	}

	public function isBreakChar(code) {
		return switch( code ) {
		case '!'.code, '?'.code, '.'.code, ','.code, ':'.code: true;
		case '！'.code, '？'.code, '．'.code, '，'.code, '：'.code: true; // full width
		case '・'.code, '、'.code, '。'.code: true; // JP
		default: isSpace(code);
		}
	}

	static var inst : Charset;
	public static function getDefault() {
		if( inst == null ) inst = new Charset();
		return inst;
	}

}