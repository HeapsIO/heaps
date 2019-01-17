package h2d.uikit;
import h2d.uikit.Property;
import h2d.uikit.CssParser.Value;

final class Object extends Component<h2d.Object> {

	static var p_min_width : Property<Null<Int>>;
	static var p_min_height : Property<Null<Int>>;
	static var p_max_width : Property<Null<Int>>;

	function new() {
		super("object",h2d.Object,h2d.Object.new,null);

		// h2d.Object properties
		addHandler( defineProp("name",parseIdent,null), (o,v) -> o.name = v);
		addHandler( defineProp("x", parseFloat, 0), (o,v) -> o.x = v);
		addHandler( defineProp("y", parseFloat, 0), (o,v) -> o.y = v);
		addHandler( defineProp("alpha", parseFloat, 1), (o,v) -> o.alpha = v);
		addHandler( defineProp("rotation", parseFloat, 0), (o,v) -> o.rotation = v * Math.PI / 180);
		addHandler( defineProp("visible", parseBool, true), (o,v) -> o.visible = v);
		addHandler( defineProp("scale", parseScale, { x : 1, y : 1 }), (o,v) -> { o.scaleX = v.x; o.scaleY = v.y; });
		addHandler( defineProp("blend", parseBlend, Alpha), (o,v) -> o.blendMode = v);

		// flow properties
		addHandler( defineProp("margin", parseBox, { left : 0, top : 0, right : 0, bottom : 0 }), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) {
				p.paddingLeft = v.left;
				p.paddingRight = v.right;
				p.paddingTop = v.top;
				p.paddingBottom = v.bottom;
			}
		});
		addHandler( defineProp("margin-left", parseInt, 0), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingLeft = v;
		});
		addHandler( defineProp("margin-top", parseInt, 0), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingTop = v;
		});
		addHandler( defineProp("margin-right", parseInt, 0), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingRight = v;
		});
		addHandler( defineProp("margin-bottom", parseInt, 0), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingBottom = v;
		});
		addHandler( defineProp("align", parseAlign, { h : null, v : null }), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) {
				p.horizontalAlign = v.h;
				p.verticalAlign = v.v;
			}
		});
		addHandler( defineProp("halign", parseHAlign, null), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.horizontalAlign = v;
		});
		addHandler( defineProp("valign", parseVAlign, null), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.verticalAlign = v;
		});
		addHandler( defineProp("position",parsePosition,false), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.isAbsolute = v;
		});
		addHandler( defineProp("offset", parseXY, { x : 0, y : 0 }), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) {
				p.offsetX = Std.int(v.x);
				p.offsetY = Std.int(v.y);
			}
		});
		addHandler( defineProp("offset-x", parseInt, 0), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.offsetX = v;
		});
		addHandler( defineProp("offset-y", parseInt, 0), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.offsetY = v;
		});

		addHandler( p_min_width = defineProp("min-width",parseNone.bind(parseInt),null), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.minWidth = v;
		});
		addHandler( p_min_height = defineProp("min-height",parseNone.bind(parseInt),null), (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.minHeight = v;
		});

		p_max_width = defineProp("max-width",parseNone.bind(parseInt),null);
	}

	function getFlowProps( o : h2d.Object ) {
		var p = Std.instance(o.parent, h2d.Flow);
		return p == null ? null : p.getProperties(o);
	}

	function parsePosition( value ) {
		switch( value ) {
		case VIdent("auto"):
			return false;
		case VIdent("absolute"):
			return true;
		default:
			return invalidProp();
		}
	}

	function parseScale( value ) {
		switch( value ) {
		case VGroup([x,y]):
			return { x : parseFloat(x), y : parseFloat(y) };
		default:
			var s = parseFloat(value);
			return { x : s, y : s };
		}
	}

	function parseBlend( value ) : h2d.BlendMode {
		return switch( parseIdent(value) ) {
		case "add": Add;
		case "alpha": Alpha;
		case "none": None;
		default: invalidProp();
		}
	}

	public static var inst = new Object();
}

final class Drawable extends Component<h2d.Drawable> {

	function new() {
		super("drawable",h2d.Drawable,function(_) throw "assert",Object.inst);
		addHandler(defineProp("color", parseColorF, new h3d.Vector(1,1,1,1)), (o,v) -> o.color.load(v));
		addHandler(defineProp("smooth", parseAuto.bind(parseBool), null), (o,v) -> o.smooth = v);
		addHandler(defineProp("tilewrap", parseBool, false), (o,v) -> o.tileWrap = v);
	}

	function parseColorF( v : CssParser.Value ) : h3d.Vector {
		var c = parseColor(v);
		var v = new h3d.Vector();
		v.setColor(c);
		return v;
	}

	public static var inst = new Drawable();

}

final class Bitmap extends Component<h2d.Bitmap> {

	public function new() {
		super("bitmap",h2d.Bitmap,function(p) return new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF,16,16),p), Drawable.inst);
		addHandler(defineProp("src",parseTile,null),(o,v) -> o.tile = v);
	}

	static var inst = new Bitmap();

}

final class Flow extends Component<h2d.Flow> {

	public function new() {
		super("flow",h2d.Flow,h2d.Flow.new, Object.inst);
		addHandler(defineProp("width",parseAuto.bind(parseInt),null),(o,v) -> { o.minWidth = o.maxWidth = v; });
		addHandler(defineProp("height",parseAuto.bind(parseInt),null),(o,v) -> { o.minHeight = o.maxHeight = v; });
		addHandler(@:privateAccess Object.p_min_width,(o,v) -> o.minWidth = v);
		addHandler(@:privateAccess Object.p_min_height,(o,v) -> o.minHeight = v);
		addHandler(@:privateAccess Object.p_max_width,(o,v) -> o.maxWidth = v);
		addHandler(defineProp("max-height",parseNone.bind(parseInt),null),(o,v) -> o.maxHeight = v);
		addHandler(defineProp("background",parseBackground,null),(o,v) -> {
			if( v == null ) {
				o.backgroundTile = null;
				o.borderWidth = o.borderHeight = 0;
			} else {
				o.backgroundTile = v.tile;
				o.borderWidth = v.borderW;
				o.borderHeight = v.borderH;
			}
		});
		addHandler(defineProp("debug", parseBool, false), (o,v) -> o.debug = v);
		addHandler(defineProp("padding", parseBox, { left : 0, top : 0, bottom : 0, right : 0 }), (o,v) -> {
			o.paddingLeft = v.left;
			o.paddingRight = v.right;
			o.paddingTop = v.top;
			o.paddingBottom = v.bottom;
		});
		addHandler(defineProp("padding-left", parseInt, 0), (o,v) -> o.paddingLeft = v);
		addHandler(defineProp("padding-right", parseInt, 0), (o,v) -> o.paddingRight = v);
		addHandler(defineProp("padding-top", parseInt, 0), (o,v) -> o.paddingTop = v);
		addHandler(defineProp("padding-bottom", parseInt, 0), (o,v) -> o.paddingBottom = v);
		addHandler(defineProp("content-align", parseAlign, { h : null, v : null }), (o,v) -> {
			o.horizontalAlign = v.h;
			o.verticalAlign = v.v;
		});
		addHandler(defineProp("content-halign", parseVAlign, null), (o,v) -> o.horizontalAlign = v);
		addHandler(defineProp("content-valign", parseHAlign, null), (o,v) -> o.verticalAlign = v);
	}

	function parseBackground(value) {
		return switch( value ) {
		case VIdent("transparent"): null;
		case VGroup([tile,VInt(x),VInt(y)]):
			{ tile : parseTile(tile), borderW : x, borderH : y };
		default:
			{ tile : parseTile(value), borderW : 0, borderH : 0 };
		}
	}

	static var inst = new Flow();

}

final class Text extends Component<h2d.Text> {

	public function new() {
		super("text",h2d.Text,function(p) return new h2d.Text(hxd.res.DefaultFont.get(),p), Drawable.inst);
		addHandler( defineProp("text",parseText,""), (o,v) -> o.text = v);
		addHandler( defineProp("font",parseFont,null), (o,v) -> o.font = v == null ? hxd.res.DefaultFont.get() : v );
		addHandler( defineProp("letter-spacing",parseInt,1), (o,v) -> o.letterSpacing = v);
		addHandler( defineProp("line-spacing",parseInt,0), (o,v) -> o.lineSpacing = v);
		addHandler( @:privateAccess Object.p_max_width, (o,v) -> o.maxWidth = v);
		addHandler( defineProp("text-align",parseTextAlign, Left), (o,v) -> o.textAlign = v);
		addHandler( defineProp("text-shadow",parseNone.bind(parseTextShadow), null), (o,v) -> o.dropShadow = v);
	}

	function parseTextAlign( value : CssParser.Value ) : h2d.Text.Align {
		return switch( parseIdent(value) ) {
		case "left": Left;
		case "right": Right;
		case "center": Center;
		default: invalidProp();
		}
	}

	function parseText( value : CssParser.Value ) {
		return switch( value ) {
		case VString(str): str;
		case VIdent(i): i;
		default: invalidProp();
		}
	}

	function parseTextShadow( value : CssParser.Value ) {
		return switch( value ) {
		case VGroup(vl):
			return { dx : parseFloat(vl[0]), dy : parseFloat(vl[1]), color : vl.length >= 3 ? parseColor(vl[2]) : 0, alpha : vl.length >= 4 ? parseFloat(vl[3]) : 1 };
		default:
			return { dx : 1, dy : 1, color : parseColor(value), alpha : 1 };
		}
	}

	function parseFont( value : CssParser.Value ) {
		var path = parsePath(value);
		return loadResource(path).to(hxd.res.BitmapFont).toFont();
	}

	static var inst = new Text();

}