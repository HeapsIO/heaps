package h2d.comp;

class Style {
	
	public var fontName : Null<String>;
	public var fontSize : Null<Float>;
	public var color : Null<Int>;
	public var backgroundColor : Null<CssEngine.FillStyle>;
	public var borderSize : Null<Float>;
	public var borderColor : Null<Int>;
	public var padding : Null<Float>;
	public var width : Null<Float>;
	public var height : Null<Float>;
	
	public function new() {
	}
	
	public function apply( s : Style ) {
		if( s.fontName != null ) fontName = s.fontName;
		if( s.fontSize != null ) fontSize = s.fontSize;
		if( s.color != null ) color = s.color;
		if( s.backgroundColor != null ) backgroundColor = s.backgroundColor;
		if( s.borderSize != null ) borderSize = s.borderSize;
		if( s.borderColor != null ) borderColor = s.borderColor;
		if( s.padding != null ) padding = s.padding;
		if( width != null ) width = s.width;
		if( height != null ) height = s.height;
	}
	
	public function toString() {
		var fields = [];
		for( f in Type.getInstanceFields(Style) ) {
			var v : Dynamic = Reflect.field(this, f);
			if( v == null || Reflect.isFunction(v) || f == "toString" || f == "apply" )
				continue;
			if( f.toLowerCase().indexOf("color") >= 0 && Std.is(v,Int) )
				v = "#" + StringTools.hex(v, 6);
			fields.push(f + ": " + v);
		}
		return "{" + fields.join(", ") + "}";
	}
	
	public static function getFont( name : String, size : Int ) {
		var key = name + "#" + size;
		var f = FONTS.get(key);
		if( f != null )
			return f;
		f = new h2d.Font(name, size);
		FONTS.set(key, f);
		return f;
	}
	
	public static function dispose() {
		for( f in FONTS )
			f.dispose();
		FONTS = new Map();
	}

	static var FONTS = new Map<String,h2d.Font>();
	
	public static var DEFAULT_CSS = '
		* {
			font-family : "Arial";
			font-size : 14px;
			color : #000;
		}
		button {
			background-color : gradient(#333333,#3B3B3B,#282828,#2A2A2A);
			color : #FFF;
			border : 1px solid #808080;
			padding : 5px;
		}
	';
	
	static var DEF = null;
	public static function getDefault() {
		if( DEF != null )
			return DEF;
		var e = new CssEngine();
		e.addRules(DEFAULT_CSS);
		return e;
	}
	
}