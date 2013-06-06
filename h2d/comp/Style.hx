package h2d.comp;
import h2d.comp.CssEngine.FillStyle;

class Style {
	
	public var fontName : Null<String>;
	public var fontSize : Null<Float>;
	public var color : Null<Int>;
	public var backgroundColor : Null<FillStyle>;
	public var borderSize : Null<Float>;
	public var borderColor : Null<FillStyle>;
	public var paddingTop : Null<Float>;
	public var paddingLeft : Null<Float>;
	public var paddingRight : Null<Float>;
	public var paddingBottom : Null<Float>;
	public var width : Null<Float>;
	public var height : Null<Float>;
	public var offsetX : Null<Float>;
	public var offsetY : Null<Float>;
	
	public function new() {
	}
	
	public function apply( s : Style ) {
		if( s.fontName != null ) fontName = s.fontName;
		if( s.fontSize != null ) fontSize = s.fontSize;
		if( s.color != null ) color = s.color;
		if( s.backgroundColor != null ) backgroundColor = s.backgroundColor;
		if( s.borderSize != null ) borderSize = s.borderSize;
		if( s.borderColor != null ) borderColor = s.borderColor;
		if( s.paddingLeft != null ) paddingLeft = s.paddingLeft;
		if( s.paddingRight != null ) paddingRight = s.paddingRight;
		if( s.paddingTop != null ) paddingTop = s.paddingTop;
		if( s.paddingBottom != null ) paddingBottom = s.paddingBottom;
		if( s.offsetX != null ) offsetX = s.offsetX;
		if( s.offsetY != null ) offsetY = s.offsetY;
		if( s.width != null ) width = s.width;
		if( s.height != null ) height = s.height;
	}
	
	public function padding( v : Float ) {
		this.paddingTop = v;
		this.paddingLeft = v;
		this.paddingRight = v;
		this.paddingBottom = v;
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
			offset : 0 0;
		}
		button {
			background-color : gradient(#434343, #4B4B4B, #383838, #3A3A3A);
			color : #FFF;
			border : 1px solid gradient(#A0A0A0,#909090,#707070,#606060);
			padding : 5px;
		}
		button:hover {
			background-color : gradient(#282828,#2A2A2A,#333333,#3B3B3B);
			border : 1px solid gradient(#606060,#606060,#707070,#606060);
			offset-y : 1px;
			padding-bottom : 4px;
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