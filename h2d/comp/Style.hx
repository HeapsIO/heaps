package h2d.comp;
import h2d.comp.CssDefs;

class Style {
	
	#if !macro
	
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
	public var layout : Null<Layout>;
	public var horizontalSpacing : Null<Float>;
	public var verticalSpacing : Null<Float>;
	public var marginTop : Null<Float>;
	public var marginLeft : Null<Float>;
	public var marginRight : Null<Float>;
	public var marginBottom : Null<Float>;
	public var increment : Null<Float>;
	public var maxIncrement : Null<Float>;
	
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
		if( s.layout != null ) layout = s.layout;
		if( s.horizontalSpacing != null ) horizontalSpacing = s.horizontalSpacing;
		if( s.verticalSpacing != null ) verticalSpacing = s.verticalSpacing;
		if( s.marginLeft != null ) marginLeft = s.marginLeft;
		if( s.marginRight != null ) marginRight = s.marginRight;
		if( s.marginTop != null ) marginTop = s.marginTop;
		if( s.marginBottom != null ) marginBottom = s.marginBottom;
		if( s.increment != null ) increment = s.increment;
		if( s.maxIncrement != null ) maxIncrement = s.maxIncrement;
	}
	
	public function padding( v : Float ) {
		this.paddingTop = v;
		this.paddingLeft = v;
		this.paddingRight = v;
		this.paddingBottom = v;
	}

	public function margin( v : Float ) {
		this.marginTop = v;
		this.marginLeft = v;
		this.marginRight = v;
		this.marginBottom = v;
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
	
	public static var DEFAULT_CSS = getFile("h2d/comp/default.css");
	
	static var DEF = null;
	public static function getDefault() {
		if( DEF != null )
			return DEF;
		var e = new CssEngine();
		e.addRules(DEFAULT_CSS);
		return e;
	}
	
	#end
	
	static macro function getFile( file : String ) {
		var file = haxe.macro.Context.resolvePath(file);
		haxe.macro.Context.registerModuleDependency("h2d.comp.Style", file);
		return macro $v{sys.io.File.getContent(file)};
	}
	
}