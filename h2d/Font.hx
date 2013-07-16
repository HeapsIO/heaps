package h2d;

class Font #if !macro extends Tile #end {

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
	
	static var DEFAULT_CHARSET = ASCII + LATIN1;

	#if !macro
	
	public var name(default, null) : String;
	public var size(default, null) : Int;
	public var glyphs : Array<Tile>;
	public var lineHeight : Int;
	var charset : String;
	var aa : Bool;
	
	public function new( name : String, size : Int, aa = true, ?charset ) {
		super(null, 0, 0, 0, 0);
		if( charset == null )
			charset = DEFAULT_CHARSET;
		this.name = name;
		this.size = size;
		this.charset = charset;
		this.aa = aa;
		init();
	}
	
	/**
		Divides by two the glyphs size. This is meant to create smoother fonts by creating them with double size
		while still keeping the original glyph size.
	**/
	public function halfSize() {
		for( t in glyphs )
			if( t != null )
				t.scaleToSize(t.width >> 1, t.height >> 1);
		lineHeight >>= 1;
	}
	
	public function hasChar( code : Int ) {
		return glyphs[code] != null;
	}

	public function isSpace(code) {
		return code == ' '.code || code == 0x3000;
	}
	
	public function isBreakChar(code) {
		return switch( code ) {
		case ' '.code, 0x3000: true;
		case '!'.code, '?'.code, '.'.code, ','.code, ':'.code: true;
		case '！'.code, '？'.code, '．'.code, '，'.code, '：'.code: true; // full width
		case '・'.code, '、'.code, '。'.code: true; // JP
		default: false;
		}
	}
		
	function init() {
		lineHeight = 0;
		var tf = new flash.text.TextField();
		var fmt = tf.defaultTextFormat;
		fmt.font = name;
		fmt.size = size;
		fmt.color = 0xFFFFFF;
		tf.defaultTextFormat = fmt;
		for( f in flash.text.Font.enumerateFonts() )
			if( f.fontName == name ) {
				tf.embedFonts = true;
				break;
			}
		if( aa ) {
			tf.gridFitType = flash.text.GridFitType.PIXEL;
			tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		}
		var surf = 0;
		var sizes = [];
		for( i in 0...charset.length ) {
			tf.text = charset.charAt(i);
			var w = Math.ceil(tf.textWidth) + 1;
			if( w == 0 ) continue;
			var h = Math.ceil(tf.textHeight) + 1;
			surf += (w + 1) * (h + 1);
			if( h > lineHeight )
				lineHeight = h;
			sizes[i] = { w:w, h:h };
		}
		var side = Math.ceil( Math.sqrt(surf) );
		var width = 1;
		while( side > width )
			width <<= 1;
		var height = width;
		while( width * height >> 1 > surf )
			height >>= 1;
		var all, bmp;
		do {
			bmp = new flash.display.BitmapData(width, height, true, 0);
			glyphs = [];
			all = [];
			var m = new flash.geom.Matrix();
			var x = 0, y = 0, lineH = 0;
			for( i in 0...charset.length ) {
				var size = sizes[i];
				if( size == null ) continue;
				var w = size.w;
				var h = size.h;
				if( x + w > width ) {
					x = 0;
					y += lineH + 1;
				}
				// no space, resize
				if( y + h > height ) {
					bmp.dispose();
					bmp = null;
					height <<= 1;
					break;
				}
				m.tx = x - 2;
				m.ty = y - 2;
				tf.text = charset.charAt(i);
				bmp.fillRect(new flash.geom.Rectangle(x, y, w, h), 0);
				bmp.draw(tf, m);
				var t = sub(x, y, w - 1, h - 1);
				all.push(t);
				glyphs[charset.charCodeAt(i)] = t;
				// next element
				if( h > lineH ) lineH = h;
				x += w + 1;
			}
		} while( bmp == null );
		
		// let's remove alpha premult (all pixels should be white with alpha)
		var bytes = bmp.getPixels(bmp.rect);
		if( bytes.length < 1024 ) bytes.length = 1024;
		flash.Memory.select(bytes);
		inline function g(p) return flash.Memory.getByte(p);
		inline function s(p,v) flash.Memory.setByte(p,v);
		for( i in 0...bmp.width * bmp.height ) {
			var p = i << 2;
			var b = g(p);
			if( b > 0 ) {
				s(p, 0xFF);
				s(p + 1, 0xFF);
				s(p + 2, 0xFF);
				s(p + 3, b);
			}
		}
		var bytes = haxe.io.Bytes.ofData(bytes);
		
		if( innerTex == null ) {
			var t = h3d.Engine.getCurrent().mem.allocTexture(bmp.width, bmp.height);
			t.uploadBytes(bytes);
			setTexture(t);
			for( t in all )
				t.setTexture(innerTex);
			innerTex.onContextLost = init;
		} else
			innerTex.uploadBytes(bytes);
		
		bmp.dispose();
		
		inline function map(code, to) {
			if( glyphs[code] == null ) glyphs[code] = glyphs[to] else if( glyphs[to] == null ) glyphs[to] = glyphs[code];
		}
		// fullwidth unicode to ASCII (if missing)
		for( i in 1...0x5E )
			map(0xFF01 + i, 0x21 + i);
		// unicode spaces
		map(0x3000, 0x20); // full width space
		map(0xA0, 0x20); // nbsp
		// unicode quotes
		map("«".code, '"'.code);
		map("»".code, '"'.code);
		map("“".code, '"'.code);
		map("”".code, '"'.code);
		map("‘".code, "'".code);
		map("’".code, "'".code);
		map("‘".code, "'".code);
		map("‹".code, "<".code);
		map("›".code, ">".code);
	}
	
	#else
	
	static function locateFont( file : String ) {
		try {
			return haxe.macro.Context.resolvePath(file);
		} catch( e : Dynamic ) {
		}
		if( Sys.systemName() == "Windows" ) {
			var path = Sys.getEnv("SystemRoot") + "\\Fonts\\" + file;
			if( sys.FileSystem.exists(path) )
				return path;
		}
		return null;
	}
	#end

	/**
		By default, the charset is ASCII+LATIN1
	**/
	public static function setDefaultCharset( chars ) {
		DEFAULT_CHARSET = chars;
	}
	
	public macro static function embed( name : String, file : String, ?chars : String, ?skipErrors : Bool ) {
		var ok = true;
		var path = locateFont(file);
		if( path == null ) {
			if( !skipErrors ) throw "Font file not found " + file;
			return macro false;
		}
		if( chars == null ) chars = DEFAULT_CHARS;
		var pos = haxe.macro.Context.currentPos();
		var safeName = "F_"+~/[^A-Za-z_]+/g.replace(name, "_");
		haxe.macro.Context.defineType({
			pack : ["_fonts"],
			name : safeName,
			meta : [{ name : ":font", pos : pos, params : [macro $v{path},macro $v{chars}] }, { name : ":keep", pos : pos, params : [] }],
			kind : TDClass(),
			params : [],
			pos : pos,
			isExtern : false,
			fields : [],
		});
		return macro true;
	}
	
}